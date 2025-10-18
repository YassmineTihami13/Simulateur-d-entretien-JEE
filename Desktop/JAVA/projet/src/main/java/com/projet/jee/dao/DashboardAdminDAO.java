package com.projet.jee.dao;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.ZoneId;
import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardAdminDAO {

    // 🔹 Nombre total de candidats
    public static int getNombreCandidats() throws SQLException {
        String sql = "SELECT COUNT(*) FROM utilisateur WHERE role = 'CANDIDAT'";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // 🔹 Nombre total de formateurs
    public static int getNombreFormateurs() throws SQLException {
        String sql = "SELECT COUNT(*) FROM utilisateur WHERE role = 'FORMATEUR'";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // 🔹 Nombre total utilisateurs (candidats + formateurs SEULEMENT)
    public static int getTotalUtilisateurs() throws SQLException {
        String sql = "SELECT COUNT(*) FROM utilisateur WHERE role IN ('CANDIDAT', 'FORMATEUR')";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // 🔹 Formateurs par spécialité
    public static Map<String, Integer> getFormateursParSpecialite() throws SQLException {
        String sql = "SELECT specialite, COUNT(*) AS cnt FROM formateur GROUP BY specialite";
        Map<String, Integer> result = new LinkedHashMap<>();
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String spec = rs.getString("specialite");
                int cnt = rs.getInt("cnt");
                result.put(spec != null ? spec : "AUTRE", cnt);
            }
        }
        return result;
    }

    // 🔹 Nouveaux utilisateurs par mois (candidats + formateurs SEULEMENT)
    public static Map<String, Integer> getNouveauxUtilisateursParMois(int months) throws SQLException {
        Map<String, Integer> result = new LinkedHashMap<>();

        YearMonth now = YearMonth.now(ZoneId.systemDefault());
        YearMonth start = now.minusMonths(months - 1);

        String sql = "SELECT COUNT(*) FROM utilisateur WHERE role IN ('CANDIDAT', 'FORMATEUR') AND date_creation >= ? AND date_creation < ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < months; i++) {
                YearMonth ym = start.plusMonths(i);
                LocalDateTime from = ym.atDay(1).atStartOfDay();
                LocalDateTime to = ym.plusMonths(1).atDay(1).atStartOfDay();

                ps.setTimestamp(1, Timestamp.valueOf(from));
                ps.setTimestamp(2, Timestamp.valueOf(to));

                try (ResultSet rs = ps.executeQuery()) {
                    int count = 0;
                    if (rs.next()) count = rs.getInt(1);
                    String key = ym.toString();
                    result.put(key, count);
                }
            }
        }
        return result;
    }
}
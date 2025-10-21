package com.projet.jee.dao;

import com.projet.jee.models.Candidat;
import com.projet.jee.models.Utilisateur;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CandidatDAO {

    public List<Candidat> getAllCandidats() throws SQLException {
        List<Candidat> candidats = new ArrayList<>();
        String sql = "SELECT u.id, u.nom, u.prenom, u.email, u.role, u.statut, u.estVerifie, " +
                "c.domaineProfessionnel, c.cv " +
                "FROM utilisateur u " +
                "INNER JOIN candidat c ON u.id = c.id " +
                "WHERE u.role = 'CANDIDAT' " +
                "ORDER BY u.nom, u.prenom";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Candidat candidat = new Candidat();
                candidat.setId(rs.getLong("id"));
                candidat.setNom(rs.getString("nom"));
                candidat.setPrenom(rs.getString("prenom"));
                candidat.setEmail(rs.getString("email"));
                candidat.setRole(Utilisateur.Role.valueOf(rs.getString("role")));
                candidat.setStatut(rs.getBoolean("statut"));
                candidat.setEstVerifie(rs.getBoolean("estVerifie"));

                // Conversion String → Enum
                String domaineStr = rs.getString("domaineProfessionnel");
                if (domaineStr != null) {
                    candidat.setDomaineProfessionnel(domaineStr);
                }

                candidat.setCv(rs.getString("cv"));
                candidats.add(candidat);
            }
        }
        return candidats;
    }

    public Candidat getCandidatById(long id) throws SQLException {
        String sql = "SELECT u.id, u.nom, u.prenom, u.email, u.role, u.statut, u.estVerifie, " +
                "c.domaineProfessionnel, c.cv " +
                "FROM utilisateur u " +
                "INNER JOIN candidat c ON u.id = c.id " +
                "WHERE u.id = ? AND u.role = 'CANDIDAT'";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Candidat candidat = new Candidat();
                    candidat.setId(rs.getLong("id"));
                    candidat.setNom(rs.getString("nom"));
                    candidat.setPrenom(rs.getString("prenom"));
                    candidat.setEmail(rs.getString("email"));
                    candidat.setRole(Utilisateur.Role.valueOf(rs.getString("role")));
                    candidat.setStatut(rs.getBoolean("statut"));
                    candidat.setEstVerifie(rs.getBoolean("estVerifie"));

                    String domaineStr = rs.getString("domaineProfessionnel");
                    if (domaineStr != null) {
                        candidat.setDomaineProfessionnel(domaineStr);
                    }

                    candidat.setCv(rs.getString("cv"));
                    return candidat;
                }
            }
        }
        return null;
    }

    public boolean toggleCandidatStatus(long candidatId, boolean newStatus) throws SQLException {
        String sql = "UPDATE utilisateur SET statut = ? WHERE id = ? AND role = 'CANDIDAT'";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, newStatus);
            stmt.setLong(2, candidatId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateCandidat(Candidat candidat, boolean updatePassword) throws SQLException {
        Connection conn = null;
        PreparedStatement stmtUser = null;
        PreparedStatement stmtCandidat = null;

        try {
            conn = ConnectionBD.getConnection();
            conn.setAutoCommit(false);

            // 1. Table utilisateur
            String sqlUser = updatePassword
                    ? "UPDATE utilisateur SET nom=?, prenom=?, email=?, motDePasse=? WHERE id=? AND role='CANDIDAT'"
                    : "UPDATE utilisateur SET nom=?, prenom=?, email=? WHERE id=? AND role='CANDIDAT'";

            stmtUser = conn.prepareStatement(sqlUser);
            stmtUser.setString(1, candidat.getNom());
            stmtUser.setString(2, candidat.getPrenom());
            stmtUser.setString(3, candidat.getEmail().toLowerCase());
            if (updatePassword) {
                stmtUser.setString(4, hashPassword(candidat.getMotDePasse()));
                stmtUser.setLong(5, candidat.getId());
            } else {
                stmtUser.setLong(4, candidat.getId());
            }

            int affectedRows = stmtUser.executeUpdate();
            if (affectedRows == 0) {
                conn.rollback();
                return false;
            }

            // 2. Table candidat
            stmtCandidat = conn.prepareStatement(
                    "UPDATE candidat SET domaineProfessionnel=?, cv=? WHERE id=?"
            );
            stmtCandidat.setString(1, candidat.getDomaineProfessionnelEnumName());
            stmtCandidat.setString(2, candidat.getCv());
            stmtCandidat.setLong(3, candidat.getId());
            stmtCandidat.executeUpdate();

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (stmtUser != null) stmtUser.close();
            if (stmtCandidat != null) stmtCandidat.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Erreur lors du hashage du mot de passe", e);
        }
    }
}
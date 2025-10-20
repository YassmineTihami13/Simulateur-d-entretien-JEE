
package com.projet.jee.dao;

import com.projet.jee.models.Candidat;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

public class UtilisateurDAO {

    /**
     * Vérifie si un email existe déjà dans la base de données
     */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM utilisateur WHERE email = ?";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email.toLowerCase());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Crée un nouveau candidat dans la base de données
     */
    public boolean createCandidat(Candidat candidat) throws SQLException {
        Connection conn = null;
        PreparedStatement stmtUser = null;
        PreparedStatement stmtCandidat = null;

        try {
            conn = ConnectionBD.getConnection();
            conn.setAutoCommit(false); // Démarrer la transaction

            // 1. Insérer dans la table utilisateur
            String sqlUser = "INSERT INTO utilisateur (nom, prenom, email, motDePasse, role, statut, estVerifie) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            stmtUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            stmtUser.setString(1, candidat.getNom());
            stmtUser.setString(2, candidat.getPrenom());
            stmtUser.setString(3, candidat.getEmail().toLowerCase());
            stmtUser.setString(4, hashPassword(candidat.getMotDePasse()));
            stmtUser.setString(5, "CANDIDAT");
            stmtUser.setBoolean(6, true); // statut actif par défaut
            stmtUser.setBoolean(7, false); // non vérifié par défaut

            int affectedRows = stmtUser.executeUpdate();

            if (affectedRows == 0) {
                conn.rollback();
                return false;
            }

            // Récupérer l'ID généré
            long userId;
            try (ResultSet generatedKeys = stmtUser.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    userId = generatedKeys.getLong(1);
                } else {
                    conn.rollback();
                    return false;
                }
            }

            // 2. Insérer dans la table candidat
            String sqlCandidat = "INSERT INTO candidat (id, domaineProfessionnel, cv) VALUES (?, ?, ?)";

            stmtCandidat = conn.prepareStatement(sqlCandidat);
            stmtCandidat.setLong(1, userId);
            stmtCandidat.setString(2, candidat.getDomaineProfessionnel());
            stmtCandidat.setString(3, candidat.getCv());

            stmtCandidat.executeUpdate();

            // Valider la transaction
            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
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

    /**
     * Hash le mot de passe avec SHA-256
     */
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());

            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Erreur lors du hashage du mot de passe", e);
        }
    }
}
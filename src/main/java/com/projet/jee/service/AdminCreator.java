package com.projet.jee.service;

import com.projet.jee.dao.ConnectionBD;
import com.projet.jee.model.Administrateur;

import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 * AdminCreator : crée un administrateur initial dans la base.
 */
public class AdminCreator {

    /**
     * Hash SHA-256 du mot de passe
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Erreur de hashage du mot de passe", e);
        }
    }

    /**
     * Vérifie si l'email existe déjà
     */
    private static boolean emailExiste(Connection con, String email) throws Exception {
        String sql = "SELECT COUNT(*) FROM utilisateur WHERE email = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
                return false;
            }
        }
    }

    /**
     * Ajoute un administrateur dans la base.
     * @return true si succès, false sinon
     */
    public static boolean ajouterAdmin(Administrateur admin) {
        String sql = "INSERT INTO utilisateur (nom, prenom, email, motDePasse, role, date_creation) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = ConnectionBD.getConnection()) {

            if (con == null) {
                System.err.println("[AdminCreator] Connexion DB échouée !");
                return false;
            }

            // Vérifier si l'email existe déjà
            if (emailExiste(con, admin.getEmail())) {
                System.err.println("[AdminCreator] L'email existe déjà : " + admin.getEmail());
                return false;
            }

            String motDePasseHash = hashPassword(admin.getMotDePasse());
            LocalDateTime dateCreation = LocalDateTime.now();

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, admin.getNom());
                ps.setString(2, admin.getPrenom());
                ps.setString(3, admin.getEmail());
                ps.setString(4, motDePasseHash);
                ps.setString(5, admin.getRole().name());
                ps.setTimestamp(6, Timestamp.valueOf(dateCreation));

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    System.out.println("✅ Administrateur ajouté avec succès !");
                    System.out.println("   Email: " + admin.getEmail());
                    System.out.println("   Date création: " + dateCreation);
                    System.out.println("   Mot de passe hashé: " + motDePasseHash);
                    return true;
                } else {
                    System.err.println("⚠️ Échec lors de l'ajout de l'administrateur (rows == 0).");
                    return false;
                }
            }

        } catch (Exception e) {
            System.err.println("❌ Erreur SQL / exception : " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Test direct depuis la console (main)
     */
    public static void main(String[] args) {
        Administrateur admin = new Administrateur(
                3,
                "Admi3",
                "Principal",
                "admin3@gmail.com",
                "admin123"
        );

        boolean ok = ajouterAdmin(admin);
        if (ok) {
            System.out.println("[main] Admin inséré avec succès !");
        } else {
            System.err.println("[main] Échec insertion admin (voir logs ci-dessus).");
        }
    }
}

package com.projet.jee.servlet;

import com.projet.jee.dao.ConnectionBD;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;

@WebServlet("/admin/update-profile")
public class UpdateProfileServlet extends HttpServlet {

    private String hashPassword(String password) {
        if (password == null) return null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Erreur de hashage SHA-256", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // 🔍 DEBUG: Afficher tous les attributs de session
        System.out.println("=== ATTRIBUTS SESSION ===");
        java.util.Enumeration<String> attrNames = session.getAttributeNames();
        while (attrNames.hasMoreElements()) {
            String name = attrNames.nextElement();
            System.out.println(name + " = " + session.getAttribute(name));
        }

        // Récupération de l'ID utilisateur (essayer différents noms d'attributs)
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            userId = (Long) session.getAttribute("userID");
        }
        if (userId == null) {
            userId = (Long) session.getAttribute("id");
        }

        System.out.println("UserID récupéré: " + userId);

        if (userId == null) {
            sendError(response, "Utilisateur non connecté - Session invalide");
            return;
        }

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String currentPassword = request.getParameter("currentPassword");

        // Validation des champs
        if (nom == null || nom.trim().isEmpty() ||
                prenom == null || prenom.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                currentPassword == null || currentPassword.trim().isEmpty()) {

            sendError(response, "Tous les champs sont obligatoires");
            return;
        }

        // Nettoyage des données
        nom = nom.trim();
        prenom = prenom.trim();
        email = email.trim().toLowerCase();

        try (PrintWriter out = response.getWriter()) {
            // Vérifier le mot de passe actuel
            if (!verifyCurrentPassword(userId, currentPassword)) {
                sendError(response, "Mot de passe actuel incorrect");
                return;
            }

            // Vérifier si l'email existe déjà pour un autre utilisateur
            if (isEmailTakenByOtherUser(userId, email)) {
                sendError(response, "Cet email est déjà utilisé par un autre utilisateur");
                return;
            }

            // Mettre à jour le profil
            boolean success = updateUserProfile(userId, nom, prenom, email);

            if (success) {
                // Mettre à jour la session
                session.setAttribute("userNom", nom);
                session.setAttribute("userPrenom", prenom);
                session.setAttribute("userEmail", email);
                session.setAttribute("userNomComplet", prenom + " " + nom);

                // Retourner les données mises à jour
                out.print("{");
                out.print("\"success\":true,");
                out.print("\"message\":\"Profil mis à jour avec succès\",");
                out.print("\"updatedAdmin\":{");
                out.print("\"nom\":\"" + escapeJson(nom) + "\",");
                out.print("\"prenom\":\"" + escapeJson(prenom) + "\",");
                out.print("\"email\":\"" + escapeJson(email) + "\"");
                out.print("}");
                out.print("}");

                System.out.println("✅ Profil mis à jour pour l'utilisateur ID: " + userId);

            } else {
                sendError(response, "Erreur lors de la mise à jour du profil en base de données");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Erreur serveur: " + e.getMessage());
        }
    }

    private boolean verifyCurrentPassword(Long userId, String password) {
        String sql = "SELECT motDePasse FROM utilisateur WHERE id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("motDePasse");
                    String inputHash = hashPassword(password);

                    System.out.println("🔐 Vérification mot de passe - Stored: " + storedHash);
                    System.out.println("🔐 Vérification mot de passe - Input: " + inputHash);

                    return storedHash != null && storedHash.equals(inputHash);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean isEmailTakenByOtherUser(Long userId, String email) {
        String sql = "SELECT COUNT(*) FROM utilisateur WHERE email = ? AND id != ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setLong(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("📧 Email '" + email + "' trouvé " + count + " fois pour d'autres utilisateurs");
                    return count > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean updateUserProfile(Long userId, String nom, String prenom, String email) {
        String sql = "UPDATE utilisateur SET nom = ?, prenom = ?, email = ? WHERE id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nom);
            ps.setString(2, prenom);
            ps.setString(3, email);
            ps.setLong(4, userId);

            int rowsUpdated = ps.executeUpdate();
            System.out.println("📝 Lignes mises à jour en BD: " + rowsUpdated);

            return rowsUpdated > 0;

        } catch (Exception e) {
            System.err.println("❌ Erreur lors de la mise à jour du profil:");
            e.printStackTrace();
            return false;
        }
    }

    private void sendError(HttpServletResponse response, String message) throws IOException {
        try (PrintWriter out = response.getWriter()) {
            out.print("{\"success\":false,\"error\":\"" + escapeJson(message) + "\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t")
                .replace("\\", "\\\\");
    }
}
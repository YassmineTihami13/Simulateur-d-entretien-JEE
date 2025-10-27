package com.projet.jee.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.projet.jee.dao.ConnectionBD;
import com.google.gson.JsonObject;

@WebServlet("/candidat/sauvegarder-reponse")
public class SauvegarderReponseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== SAUVEGARDER REPONSE APPELE ===");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        try {
            // Récupérer les paramètres
            String questionIdStr = request.getParameter("questionId");
            String reponseDonnee = request.getParameter("reponse");

            System.out.println("Question ID: " + questionIdStr);
            System.out.println("Réponse: " + reponseDonnee);

            // Validation basique
            if (questionIdStr == null || questionIdStr.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "ID de question manquant");
                response.getWriter().write(jsonResponse.toString());
                return;
            }

            long questionId = Long.parseLong(questionIdStr);

            // Simuler une sauvegarde réussie pour tester
            boolean success = true; // sauvegarderReponse(1L, questionId, reponseDonnee);

            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Réponse sauvegardée avec succès - TEST");
                System.out.println("Sauvegarde simulée réussie");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Erreur lors de la sauvegarde");
            }

        } catch (Exception e) {
            System.err.println("Erreur dans le servlet: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Erreur serveur: " + e.getMessage());
        }

        String responseStr = jsonResponse.toString();
        System.out.println("Réponse envoyée: " + responseStr);
        response.getWriter().write(responseStr);
    }

    private boolean sauvegarderReponse(Long candidatId, long questionId, String reponseDonnee) {
        String sql = "INSERT INTO reponse_candidat (candidat_id, question_id, reponse_donnee, date_reponse) " +
                "VALUES (?, ?, ?, NOW()) " +
                "ON DUPLICATE KEY UPDATE reponse_donnee = ?, date_reponse = NOW()";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, candidatId);
            pstmt.setLong(2, questionId);
            pstmt.setString(3, reponseDonnee);
            pstmt.setString(4, reponseDonnee);

            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Lignes affectées en BD: " + rowsAffected);
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
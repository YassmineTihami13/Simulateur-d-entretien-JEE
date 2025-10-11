package com.projet.jee.servlet;

import com.projet.jee.dao.ConnectionBD;
import com.projet.jee.model.Utilisateur;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterFormateurServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String confirmMotDePasse = request.getParameter("confirmMotDePasse");
        String specialite = request.getParameter("specialite");
        String anneeExperienceStr = request.getParameter("anneeExperience");
        String certifications = request.getParameter("certifications");
        String tarifHoraireStr = request.getParameter("tarifHoraire");
        String description = request.getParameter("description");

        if (nom == null || prenom == null || email == null || motDePasse == null ||
                nom.trim().isEmpty() || prenom.trim().isEmpty() || email.trim().isEmpty() || motDePasse.trim().isEmpty()) {
            request.setAttribute("error", "Tous les champs obligatoires doivent être remplis.");
            request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
            return;
        }

        if (!motDePasse.equals(confirmMotDePasse)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas.");
            request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
            return;
        }

        try {
            int anneeExperience = Integer.parseInt(anneeExperienceStr);
            double tarifHoraire = Double.parseDouble(tarifHoraireStr);

            String motDePasseHache = hashPassword(motDePasse);

            try (Connection conn = ConnectionBD.getConnection()) {
                conn.setAutoCommit(false);

                try {
                    String sqlUtilisateur = "INSERT INTO utilisateur (nom, prenom, email, motDePasse, role) VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement psUtilisateur = conn.prepareStatement(sqlUtilisateur, PreparedStatement.RETURN_GENERATED_KEYS);
                    psUtilisateur.setString(1, nom);
                    psUtilisateur.setString(2, prenom);
                    psUtilisateur.setString(3, email);
                    psUtilisateur.setString(4, motDePasseHache);
                    psUtilisateur.setString(5, Utilisateur.Role.FORMATEUR.name());
                    psUtilisateur.executeUpdate();

                    var rs = psUtilisateur.getGeneratedKeys();
                    long userId = 0;
                    if (rs.next()) {
                        userId = rs.getLong(1);
                    }

                    String sqlFormateur = "INSERT INTO formateur (id, specialite, anneeExperience, certifications, tarifHoraire, description) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement psFormateur = conn.prepareStatement(sqlFormateur);
                    psFormateur.setLong(1, userId);
                    psFormateur.setString(2, specialite);
                    psFormateur.setInt(3, anneeExperience);
                    psFormateur.setString(4, certifications);
                    psFormateur.setDouble(5, tarifHoraire);
                    psFormateur.setString(6, description);
                    psFormateur.executeUpdate();

                    conn.commit();

                    response.sendRedirect(request.getContextPath() + "/jsp/success.jsp");

                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                }
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Les années d'expérience et le tarif horaire doivent être des nombres valides.");
            request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("error", "Cet email est déjà utilisé.");
            } else {
                request.setAttribute("error", "Erreur lors de l'inscription : " + e.getMessage());
            }
            request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Erreur lors du hachage du mot de passe", e);
        }
    }
}
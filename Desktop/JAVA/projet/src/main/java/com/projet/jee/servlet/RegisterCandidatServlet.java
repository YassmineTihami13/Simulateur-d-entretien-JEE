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

@WebServlet("/registerCandidat")
public class RegisterCandidatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/registerCandidat.jsp").forward(request, response);
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


        if (nom == null || prenom == null || email == null || motDePasse == null ||
                nom.trim().isEmpty() || prenom.trim().isEmpty() || email.trim().isEmpty() || motDePasse.trim().isEmpty()) {
            request.setAttribute("error", "Tous les champs obligatoires doivent être remplis.");
            request.getRequestDispatcher("/jsp/registerCandidat.jsp").forward(request, response);
            return;
        }

        if (!motDePasse.equals(confirmMotDePasse)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas.");
            request.getRequestDispatcher("/jsp/registerCandidat.jsp").forward(request, response);
            return;
        }

        try {
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
                    psUtilisateur.setString(5, Utilisateur.Role.CANDIDAT.name());
                    psUtilisateur.executeUpdate();

                    var rs = psUtilisateur.getGeneratedKeys();
                    long userId = 0;
                    if (rs.next()) {
                        userId = rs.getLong(1);
                    }

                    conn.commit();

                    response.sendRedirect(request.getContextPath() + "/jsp/successCandidat.jsp");

                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                }
            }

        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("error", "Cet email est déjà utilisé.");
            } else {
                request.setAttribute("error", "Erreur lors de l'inscription : " + e.getMessage());
            }
            request.getRequestDispatcher("/jsp/registerCandidat.jsp").forward(request, response);
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
package com.projet.jee.servlet;

import com.projet.jee.dao.ConnectionBD;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet de connexion. Attend "email" et "password" en POST.
 * Hash le password en SHA-256 avant de comparer avec la base.
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Méthode utilitaire pour hasher en SHA-256
    private String hashPassword(String password) {
        if (password == null) return null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Erreur de hashage SHA-256", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Rediriger GET vers la page de login
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // S'assurer de l'encodage pour lire correctement les champs
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=empty");
            return;
        }

        String hashed = hashPassword(password);

        String sql = "SELECT id, nom, prenom, role FROM utilisateur WHERE email=? AND motDePasse=?";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, hashed);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("userId", rs.getLong("id"));
                    session.setAttribute("userNom", rs.getString("nom"));
                    session.setAttribute("userPrenom", rs.getString("prenom"));
                    session.setAttribute("userRole", rs.getString("role"));

                    String role = rs.getString("role");
                    if ("CANDIDAT".equalsIgnoreCase(role)) {
                        response.sendRedirect(request.getContextPath() + "/jsp/condidat.jsp");
                    } else if ("FORMATEUR".equalsIgnoreCase(role)) {
                        response.sendRedirect(request.getContextPath() + "/jsp/formateur.jsp");
                    } else if ("ADMIN".equalsIgnoreCase(role)) {
                        response.sendRedirect(request.getContextPath() + "/jsp/adminDashboard.jsp");
                    } else {
                        // rôle inconnu -> erreur
                        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=invalid");
                    }
                } else {
                    // aucun utilisateur trouvé
                    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=invalid");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=db");
        }
    }
}

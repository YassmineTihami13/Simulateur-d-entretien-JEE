package com.projet.jee.servlet;

import com.projet.jee.dao.ConnectionBD;
import com.projet.jee.dao.DashboardFormateurDAO;
import com.projet.jee.models.Formateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=empty");
            return;
        }

        try (Connection con = ConnectionBD.getConnection()) {
            // Hachage du mot de passe
            String hashedPassword = hashPassword(password);

            String sql = "SELECT id, nom, prenom, role FROM utilisateur WHERE email=? AND motDePasse=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, hashedPassword);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                long userId = rs.getLong("id");
                String nom = rs.getString("nom");
                String prenom = rs.getString("prenom");
                String role = rs.getString("role");

                session.setAttribute("userId", userId);
                session.setAttribute("userNom", nom);
                session.setAttribute("userPrenom", prenom);
                session.setAttribute("userRole", role);

                if ("FORMATEUR".equals(role)) {
                    // Récupérer les infos supplémentaires du formateur
                    DashboardFormateurDAO dao = new DashboardFormateurDAO();
                    Formateur formateur = dao.getFormateurById(userId); // Méthode à créer dans DAO
                    session.setAttribute("formateur", formateur);
                    response.sendRedirect(request.getContextPath() + "/jsp/dashboard_formateur.jsp");
                } else if ("CANDIDAT".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/jsp/condidat.jsp");
                } else if ("ADMIN".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/jsp/adminDashboard.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=invalid");
                }

            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=db");
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
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du hachage du mot de passe", e);
        }
    }
}

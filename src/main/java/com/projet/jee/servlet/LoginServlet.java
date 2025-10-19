package com.projet.jee.servlet;

import com.projet.jee.dao.ConnectionBD;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.security.MessageDigest;

import javax.servlet.http.HttpSession;
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=empty");
            return;
        }

        try (Connection con = ConnectionBD.getConnection()) {
            // ✅ Hachage du mot de passe avant la vérification
            String hashedPassword = hashPassword(password);

            String sql = "SELECT id, nom, prenom, role FROM utilisateur WHERE email=? AND motDePasse=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getLong("id"));
                session.setAttribute("userNom", rs.getString("nom"));
                session.setAttribute("userPrenom", rs.getString("prenom"));
                session.setAttribute("userRole", rs.getString("role"));

                String role = rs.getString("role");
                switch (role) {
                    case "CANDIDAT":
                        response.sendRedirect(request.getContextPath() + "/jsp/condidat.jsp");
                        break;
                    case "FORMATEUR":
                        response.sendRedirect(request.getContextPath() + "/jsp/formateur.jsp");
                        break;
                    case "ADMIN":
                        response.sendRedirect(request.getContextPath() + "/jsp/adminDashboard.jsp");
                        break;
                    default:
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

    // ✅ même méthode que dans RegisterCandidatServlet
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

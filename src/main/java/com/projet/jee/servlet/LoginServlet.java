package com.projet.jee.servlet;

import com.projet.jee.dao.ConnectionBD;
import com.projet.jee.model.Formateur;
import com.projet.jee.model.Utilisateur;
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
            // Hachage du mot de passe
            String hashedPassword = hashPassword(password);

            // Requête pour récupérer les informations complètes selon le rôle
            String sql = "SELECT u.id, u.nom, u.prenom, u.email, u.role, " +
                        "f.specialite, f.anneeExperience, f.certifications, f.tarifHoraire, f.description " +
                        "FROM utilisateur u " +
                        "LEFT JOIN formateur f ON u.id = f.id " +
                        "WHERE u.email=? AND u.motDePasse=?";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                String role = rs.getString("role");
                
                // Stocker les attributs de base
                session.setAttribute("userId", rs.getLong("id"));
                session.setAttribute("userNom", rs.getString("nom"));
                session.setAttribute("userPrenom", rs.getString("prenom"));
                session.setAttribute("userRole", role);
                session.setAttribute("userEmail", rs.getString("email"));

                switch (role) {
                    case "CANDIDAT":
                        response.sendRedirect(request.getContextPath() + "/jsp/condidat.jsp");
                        break;
                    case "FORMATEUR":
                        // Créer un objet Formateur complet pour la session
                        Formateur formateur = createFormateurFromResultSet(rs);
                        session.setAttribute("formateur", formateur);
                        response.sendRedirect(request.getContextPath() + "/dashboardFormateur");
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

    private Formateur createFormateurFromResultSet(ResultSet rs) {
        try {
            Formateur formateur = new Formateur();
            formateur.setId(rs.getLong("id"));
            formateur.setNom(rs.getString("nom"));
            formateur.setPrenom(rs.getString("prenom"));
            formateur.setEmail(rs.getString("email"));
            formateur.setRole(Utilisateur.Role.FORMATEUR);
            formateur.setSpecialite(rs.getString("specialite"));
            formateur.setAnneeExperience(rs.getInt("anneeExperience"));
            formateur.setCertifications(rs.getString("certifications"));
            formateur.setTarifHoraire(rs.getDouble("tarifHoraire"));
            formateur.setDescription(rs.getString("description"));
            return formateur;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
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
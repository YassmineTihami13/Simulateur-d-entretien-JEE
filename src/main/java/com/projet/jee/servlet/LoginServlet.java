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
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if(email == null || email.isEmpty() || password == null || password.isEmpty()) {
        	response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?error=empty");

            return;
        }

        try (Connection con = ConnectionBD.getConnection()) {
            String sql = "SELECT id, nom, prenom, role FROM utilisateur WHERE email=? AND motDePasse=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getLong("id"));
                session.setAttribute("userNom", rs.getString("nom"));
                session.setAttribute("userPrenom", rs.getString("prenom"));
                session.setAttribute("userRole", rs.getString("role"));

                String role = rs.getString("role");
                if ("CANDIDAT".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/jsp/condidat.jsp");
                } else if ("FORMATEUR".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/jsp/formateur.jsp");
                } else if ("ADMIN".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/jsp/admin.jsp");
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
}

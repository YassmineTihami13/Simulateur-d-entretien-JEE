package com.projet.jee.servlet;

import com.projet.jee.dao.ConnectionBD;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/verifyCode")
public class VerifyCodeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("pendingEmail");
        String code = request.getParameter("code");

        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Session expirée. Veuillez vous réinscrire.");
            request.getRequestDispatcher("/jsp/verifyCode.jsp").forward(request, response);
            return;
        }

        if (code == null || code.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez entrer le code de vérification.");
            request.getRequestDispatcher("/jsp/verifyCode.jsp").forward(request, response);
            return;
        }

        try (Connection conn = ConnectionBD.getConnection()) {
            String sql = "SELECT verificationCode, codeExpiration, estVerifie FROM utilisateur WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedCode = rs.getString("verificationCode");
                long expirationTime = rs.getLong("codeExpiration");
                boolean isVerified = rs.getBoolean("estVerifie");

                if (isVerified) {
                    request.setAttribute("error", "Ce compte est déjà vérifié.");
                    request.getRequestDispatcher("/jsp/verifyCode.jsp").forward(request, response);
                    return;
                }

                if (System.currentTimeMillis() > expirationTime) {
                    request.setAttribute("error", "Le code a expiré. Veuillez demander un nouveau code.");
                    request.getRequestDispatcher("/jsp/verifyCode.jsp").forward(request, response);
                    return;
                }

                if (code.trim().equals(storedCode)) {
                    String updateSql = "UPDATE utilisateur SET estVerifie = true, verificationCode = NULL, codeExpiration = NULL WHERE email = ?";
                    PreparedStatement updatePs = conn.prepareStatement(updateSql);
                    updatePs.setString(1, email);
                    updatePs.executeUpdate();

                    session.removeAttribute("pendingEmail");
                    session.removeAttribute("userName");

                    response.sendRedirect(request.getContextPath() + "/jsp/success.jsp");
                } else {
                    request.setAttribute("error", "Code incorrect. Veuillez réessayer.");
                    request.getRequestDispatcher("/jsp/verifyCode.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Utilisateur introuvable.");
                request.getRequestDispatcher("/jsp/verifyCode.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la vérification : " + e.getMessage());
            request.getRequestDispatcher("/jsp/verifyCode.jsp").forward(request, response);
        }
    }
}
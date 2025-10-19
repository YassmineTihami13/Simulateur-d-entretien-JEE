package com.projet.jee.servlet;

import com.projet.jee.dao.ConnectionBD;
import com.projet.jee.service.EmailUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/resendCode")
public class ResendCodeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("pendingEmail");
        String userName = (String) session.getAttribute("userName");

        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Session expirée. Veuillez vous réinscrire.");
            request.getRequestDispatcher("/jsp/verifyCode.jsp").forward(request, response);
            return;
        }

        try (Connection conn = ConnectionBD.getConnection()) {
            String newCode = EmailUtil.generateVerificationCode();
            long newExpiration = System.currentTimeMillis() + (15 * 60 * 1000); // 15 minutes

            String sql = "UPDATE utilisateur SET verificationCode = ?, codeExpiration = ? WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newCode);
            ps.setLong(2, newExpiration);
            ps.setString(3, email);
            ps.executeUpdate();

            boolean emailSent = EmailUtil.sendVerificationEmail(email, userName, newCode);

            if (emailSent) {
                request.setAttribute("success", "Un nouveau code a été envoyé à votre adresse email.");
            } else {
                request.setAttribute("error", "Erreur lors de l'envoi de l'email. Veuillez réessayer.");
            }

            request.getRequestDispatcher("/jsp/verifyCode.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la génération du nouveau code : " + e.getMessage());
            request.getRequestDispatcher("/jsp/verifyCode.jsp").forward(request, response);
        }
    }
}
package com.projet.jee.servlet;

import com.projet.jee.models.Question;
import com.projet.jee.service.TestService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/genererTest")
public class TestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("candidatId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        long candidatId = (long) session.getAttribute("candidatId");

        try {
            TestService testService = new TestService();
            List<Question> test = testService.genererTestPourCandidat(candidatId);
            session.setAttribute("testQuestions", test);
            request.getRequestDispatcher("/jsp/test.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            String errorHtml = "<!DOCTYPE html>" +
                    "<html>" +
                    "<head>" +
                    "<title>Erreur</title>" +
                    "<style>" +
                    "body { font-family: Arial, sans-serif; margin: 40px; line-height: 1.6; }" +
                    ".error-container { max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px; }" +
                    ".error-title { color: #d9534f; }" +
                    ".btn { display: inline-block; padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 4px; }" +
                    "</style>" +
                    "</head>" +
                    "<body>" +
                    "<div class='error-container'>" +
                    "<h2 class='error-title'>Erreur</h2>" +
                    "<p>Une erreur est survenue lors de la génération du test.</p>" +
                    "<p><strong>Détail :</strong> " + e.getMessage() + "</p>" +
                    "<a href='index.jsp' class='btn'>Retour à l'accueil</a>" +
                    "</div>" +
                    "</body>" +
                    "</html>";

            response.getWriter().println(errorHtml);
        }
    }
}
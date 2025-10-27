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

        // 1️⃣ Récupérer l'id du candidat depuis la session ou un paramètre
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("candidatId") == null) {
            response.sendRedirect("login.jsp"); // Rediriger vers login si non connecté
            return;
        }

        long candidatId = (long) session.getAttribute("candidatId");

        try {
            // 2️⃣ Générer le test
            TestService testService = new TestService();
            List<Question> test = testService.genererTestPourCandidat(candidatId);

            // 3️⃣ Stocker les questions dans la session pour le quiz
            session.setAttribute("testQuestions", test);

            // 4️⃣ Rediriger vers la page du test
            request.getRequestDispatcher("/jsp/test.jsp").forward(request, response);


        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de la génération du test.");
        } catch (IllegalArgumentException e) {
            request.setAttribute("messageErreur", e.getMessage());
            request.getRequestDispatcher("erreur.jsp").forward(request, response);
        }
    }
}

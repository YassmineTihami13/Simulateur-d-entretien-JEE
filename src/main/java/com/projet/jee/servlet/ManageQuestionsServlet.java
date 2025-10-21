package com.projet.jee.servlet;

import com.projet.jee.dao.QuestionDAO;
import com.projet.jee.models.Formateur;
import com.projet.jee.models.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/ManageQuestions")
public class ManageQuestionsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Formateur formateur = (Formateur) session.getAttribute("formateur");

        if (formateur == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        // Récupérer les statistiques des questions
        QuestionDAO questionDAO = new QuestionDAO();
        try {
            long totalQuestions = questionDAO.getQuestionCountByFormateur(formateur.getId());
            long questionsVraiFaux = questionDAO.getQuestionCountByType(formateur.getId(), "VRAI_FAUX");
            long questionsChoixMultiple = questionDAO.getQuestionCountByType(formateur.getId(), "CHOIX_MULTIPLE");
            long questionsReponse = questionDAO.getQuestionCountByType(formateur.getId(), "REPONSE");
            request.setCharacterEncoding("UTF-8");
            request.setAttribute("totalQuestions", totalQuestions);
            request.setAttribute("questionsVraiFaux", questionsVraiFaux);
            request.setAttribute("questionsChoixMultiple", questionsChoixMultiple);
            request.setAttribute("questionsReponse", questionsReponse);
            List<Question> questions = questionDAO.getQuestionsByFormateur(formateur.getId());
            
            request.setAttribute("questions", questions);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des statistiques");
        }

        request.getRequestDispatcher("/jsp/manage_questions.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            long questionId = Long.parseLong(request.getParameter("id"));
            QuestionDAO dao = new QuestionDAO();
            
            try {
                boolean success = dao.deleteQuestion(questionId);
                if (success) {
                    response.getWriter().write("{\"success\":true}");
                } else {
                    response.getWriter().write("{\"success\":false, \"message\":\"Erreur lors de la suppression\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("{\"success\":false, \"message\":\"Erreur: \" + e.getMessage()}");
            }
        }
    }
}
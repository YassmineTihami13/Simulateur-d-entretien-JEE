package com.projet.jee.servlet;

import com.projet.jee.dao.QuestionDAO;
import com.projet.jee.models.Formateur;
import com.projet.jee.models.Question;
import com.projet.jee.models.QuestionReponse;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import javax.servlet.annotation.MultipartConfig;

@WebServlet("/AddQuestionReponseLibre")
@MultipartConfig 
public class AddQuestionReponseLibreServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== [AddQuestionReponseLibreServlet] Début de doPost ===");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        Formateur formateur = (session != null) ? (Formateur) session.getAttribute("formateur") : null;

        if (formateur == null) {
            System.out.println("❌ Formateur non authentifié ou session inexistante.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"message\": \"Non authentifié\"}");
            return;
        }

        System.out.println("✅ Formateur authentifié : " + formateur.getNom() + " (ID: " + formateur.getId() + ")");

        try {
            // Récupérer les paramètres du formulaire
            String contenu = request.getParameter("contenu");
            String reponseAttendue = request.getParameter("reponseAttendue");
            String domaine = request.getParameter("domaine");
            String difficulteStr = request.getParameter("difficulte");

            System.out.println("Paramètres reçus :");
            System.out.println(" - contenu = " + contenu);
            System.out.println(" - reponseAttendue = " + reponseAttendue);
            System.out.println(" - domaine = " + domaine);
            System.out.println(" - difficulte = " + difficulteStr);

            // Validation des champs requis
            if (contenu == null || contenu.trim().isEmpty() ||
                reponseAttendue == null || reponseAttendue.trim().isEmpty() ||
                domaine == null || domaine.trim().isEmpty() ||
                difficulteStr == null || difficulteStr.trim().isEmpty()) {
                
                System.out.println("❌ Validation échouée : un ou plusieurs champs sont vides.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"success\": false, \"message\": \"Tous les champs sont obligatoires\"}");
                return;
            }

            // Créer l'objet QuestionReponse
            QuestionReponse question = new QuestionReponse();
            question.setContenu(contenu.trim());
            question.setReponseAttendue(reponseAttendue.trim());
            question.setDomaine(domaine.trim());
            question.setDifficulte(Question.Difficulte.valueOf(difficulteStr));
            question.setTypeQuestion(Question.TypeQuestion.REPONSE);
            question.setDateCreation(LocalDate.now());
            question.setCreateurId(formateur.getId());

            System.out.println("🧠 Question préparée : " + question);

            // Insérer dans la base de données
            QuestionDAO questionDAO = new QuestionDAO();
            System.out.println("Insertion de la question en base...");
            boolean success = questionDAO.insertQuestion(question);

            if (success) {
                System.out.println("✅ Question insérée avec succès !");
                out.write("{\"success\": true, \"message\": \"Question créée avec succès\"}");
            } else {
                System.out.println("❌ Erreur lors de l'insertion en base de données.");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("{\"success\": false, \"message\": \"Erreur lors de l'insertion en base de données\"}");
            }

        } catch (Exception e) {
            System.out.println("💥 Exception dans AddQuestionReponseLibreServlet:");
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\": false, \"message\": \"Erreur serveur: " + e.getMessage() + "\"}");
        }

        System.out.println("=== [AddQuestionReponseLibreServlet] Fin de doPost ===");
    }
}

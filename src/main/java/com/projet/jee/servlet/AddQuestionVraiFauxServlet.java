package com.projet.jee.servlet;

import com.projet.jee.dao.QuestionDAO;
import com.projet.jee.models.Formateur;
import com.projet.jee.models.Question;
import com.projet.jee.models.QuestionVraiFaux;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.annotation.MultipartConfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;

@WebServlet("/AddQuestionVraiFaux")
@MultipartConfig
public class AddQuestionVraiFauxServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        System.out.println("=== [AddQuestionVraiFauxServlet] Début du traitement ===");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                System.out.println("[ERREUR] Session inexistante !");
                response.getWriter().write("{\"success\":false, \"message\":\"Session expirée.\"}");
                return;
            }
    
            Formateur formateur = (Formateur) session.getAttribute("formateur");
            if (formateur == null) {
                System.out.println("[ERREUR] Aucun formateur dans la session !");
                response.getWriter().write("{\"success\":false, \"message\":\"Formateur non connecté.\"}");
                return;
            }

            System.out.println("Formateur connecté: ID=" + formateur.getId() + 
                               ", Nom=" + formateur.getNom() + 
                               ", Prénom=" + formateur.getPrenom());

            // Lecture des paramètres
            String contenu = request.getParameter("contenu");
            String difficulteStr = request.getParameter("difficulte");
            String reponseCorrecteStr = request.getParameter("reponseCorrecte");
            String explication = request.getParameter("explication");

            System.out.println("=== [Paramètres reçus] ===");
            System.out.println("contenu: " + contenu);
            System.out.println("difficulte: " + difficulteStr);
            System.out.println("reponseCorrecte: " + reponseCorrecteStr);
            System.out.println("explication: " + explication);

            // Vérification des champs obligatoires
            if (contenu == null || contenu.trim().isEmpty() ||
                difficulteStr == null || difficulteStr.trim().isEmpty() ||
                reponseCorrecteStr == null || reponseCorrecteStr.trim().isEmpty()) {

                System.out.println("[ERREUR] Champs manquants ou invalides !");
                response.getWriter().write("{\"success\":false, \"message\":\"Champs manquants.\"}");
                return;
            }

            // Conversion des types
            boolean reponseCorrecte = Boolean.parseBoolean(reponseCorrecteStr);
            Question.Difficulte difficulte = Question.Difficulte.valueOf(difficulteStr);

            System.out.println("Conversion réussie : reponseCorrecte=" + reponseCorrecte + ", difficulte=" + difficulte);

            // Création de l’objet question
            QuestionVraiFaux question = new QuestionVraiFaux();
            question.setContenu(contenu);
            question.setDifficulte(difficulte);
            question.setTypeQuestion(Question.TypeQuestion.VRAI_FAUX);
            question.setReponseCorrecte(reponseCorrecte);
            question.setExplication(explication);
            question.setDateCreation(LocalDate.now());
            question.setCreateurId(formateur.getId());

            System.out.println("=== [Objet QuestionVraiFaux créé] ===");
            System.out.println("Contenu: " + question.getContenu());
            System.out.println("Domaine: " + question.getDomaine());
            System.out.println("Difficulté: " + question.getDifficulte());
            System.out.println("Réponse correcte: " + question.isReponseCorrecte());
            System.out.println("Explication: " + question.getExplication());
            System.out.println("Date de création: " + question.getDateCreation());
            System.out.println("Créateur ID: " + question.getCreateurId());

            // Insertion en base
            QuestionDAO dao = new QuestionDAO();
            System.out.println("Insertion de la question en base...");
            boolean success = dao.insertQuestion(question);

            if (success) {
                System.out.println("[SUCCÈS] Question insérée en base avec succès !");
                response.getWriter().write("{\"success\":true}");
            } else {
                System.out.println("[ERREUR] Échec d'insertion en base !");
                response.getWriter().write("{\"success\":false, \"message\":\"Échec en base de données.\"}");
            }

        } catch (IllegalArgumentException e) {
            System.out.println("[ERREUR] Valeur de difficulté invalide : " + e.getMessage());
            response.getWriter().write("{\"success\":false, \"message\":\"Valeur de difficulté invalide.\"}");
        } catch (Exception e) {
            System.out.println("[EXCEPTION] Une erreur est survenue : " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\":false, \"message\":\"Erreur interne.\"}");
        }

        System.out.println("=== [AddQuestionVraiFauxServlet] Fin du traitement ===");
    }
}

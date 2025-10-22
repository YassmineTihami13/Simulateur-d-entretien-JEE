package com.projet.jee.servlet;

import com.projet.jee.dao.QuestionDAO;
import com.projet.jee.models.Formateur;
import com.projet.jee.models.Question;
import com.projet.jee.models.QuestionChoixMultiple;
import com.projet.jee.models.Choix;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;

@WebServlet("/AddQuestionChoixMultiple")
@MultipartConfig 
public class AddQuestionChoixMultipleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            System.out.println("=== [AddQuestionChoixMultipleServlet] Début du traitement POST ===");

            // Debug: Afficher tous les paramètres reçus
            System.out.println("=== PARAMÈTRES REÇUS ===");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                if (paramName.startsWith("choixTexte") || paramName.startsWith("estCorrect")) {
                    String[] values = request.getParameterValues(paramName);
                    System.out.println(paramName + " = " + java.util.Arrays.toString(values));
                } else {
                    String paramValue = request.getParameter(paramName);
                    System.out.println(paramName + " = " + paramValue);
                }
            }
            System.out.println("=== FIN PARAMÈTRES ===");

            HttpSession session = request.getSession(false);
            if (session == null) {
                System.out.println("Session n'existe pas !");
                out.write("{\"success\":false, \"message\":\"Session expirée.\"}");
                return;
            }

            Formateur formateur = (Formateur) session.getAttribute("formateur");
            if (formateur == null) {
                System.out.println("Formateur non trouvé dans la session !");
                out.write("{\"success\":false, \"message\":\"Utilisateur non connecté.\"}");
                return;
            }
            System.out.println("Formateur connecté: id=" + formateur.getId());

            // Récupération des paramètres
            String contenu = request.getParameter("contenu");
            String difficulteStr = request.getParameter("difficulte");
            String nbChoixStr = request.getParameter("nbChoix");

            System.out.println("Paramètres principaux: contenu=" + contenu + ",  difficulte=" + difficulteStr + ", nbChoix=" + nbChoixStr);

            // Validation des champs obligatoires
            if (contenu == null || contenu.trim().isEmpty() ||
                difficulteStr == null || difficulteStr.trim().isEmpty() ||
                nbChoixStr == null || nbChoixStr.trim().isEmpty()) {
                
                System.out.println("Champs manquants ou vides !");
                out.write("{\"success\":false, \"message\":\"Tous les champs obligatoires doivent être remplis.\"}");
                return;
            }

            int nbChoix;
            try {
                nbChoix = Integer.parseInt(nbChoixStr);
            } catch (NumberFormatException e) {
                System.out.println("Format de nombre invalide: nbChoix=" + nbChoixStr);
                out.write("{\"success\":false, \"message\":\"Données invalides.\"}");
                return;
            }

            // Récupérer tous les choix et leurs statuts
            String[] choixTextes = request.getParameterValues("choixTexte[]");
            String[] estCorrectArray = request.getParameterValues("estCorrect[]");
            
            if (choixTextes == null || estCorrectArray == null || 
                choixTextes.length != nbChoix || estCorrectArray.length != nbChoix) {
                System.out.println("Nombre de choix incohérent: attendu=" + nbChoix + 
                                 ", textes reçus=" + (choixTextes != null ? choixTextes.length : 0) +
                                 ", correct reçus=" + (estCorrectArray != null ? estCorrectArray.length : 0));
                out.write("{\"success\":false, \"message\":\"Nombre de choix incohérent.\"}");
                return;
            }

            // Validation des choix
            for (int i = 0; i < choixTextes.length; i++) {
                String texte = choixTextes[i];
                System.out.println("Choix " + i + " - texte reçu: '" + texte + "'");
                
                if (texte == null || texte.trim().isEmpty()) {
                    System.out.println("Choix " + i + " est vide !");
                    out.write("{\"success\":false, \"message\":\"Le texte du choix " + (i+1) + " ne peut pas être vide.\"}");
                    return;
                }
            }

            // Vérifier qu'un seul choix est marqué comme correct
            int countCorrect = 0;
            for (String estCorrect : estCorrectArray) {
                if ("true".equals(estCorrect)) {
                    countCorrect++;
                }
            }
            
            if (countCorrect != 1) {
                System.out.println("Nombre de réponses correctes invalide: " + countCorrect);
                out.write("{\"success\":false, \"message\":\"Une et une seule réponse doit être correcte.\"}");
                return;
            }

            Question.Difficulte difficulte = Question.Difficulte.valueOf(difficulteStr);

            QuestionChoixMultiple question = new QuestionChoixMultiple();
            question.setContenu(contenu.trim());
            question.setDifficulte(difficulte);
            question.setTypeQuestion(Question.TypeQuestion.CHOIX_MULTIPLE);
            question.setDateCreation(LocalDate.now());
            question.setCreateurId(formateur.getId());

            System.out.println("Création de la question QCM terminée, récupération des choix...");

            // Ajout des choix avec leur statut correct/incorrect
            for (int i = 0; i < choixTextes.length; i++) {
                String texte = choixTextes[i].trim();
                boolean estCorrect = "true".equals(estCorrectArray[i]);

                Choix c = new Choix(0, texte, estCorrect, 0);
                question.addChoix(c);

                System.out.println("Choix " + i + ": texte='" + texte + "', estCorrect=" + estCorrect);
            }

            System.out.println("Insertion de la question dans la base...");
            QuestionDAO dao = new QuestionDAO();
            boolean success = dao.insertQuestion(question);

            if (success) {
                System.out.println("Question insérée avec succès !");
                out.write("{\"success\":true}");
            } else {
                System.out.println("Échec de l'insertion en base !");
                out.write("{\"success\":false, \"message\":\"Échec de l'insertion en base de données.\"}");
            }

            System.out.println("=== [AddQuestionChoixMultipleServlet] Fin du traitement POST ===");

        } catch (Exception e) {
            System.out.println("Exception capturée dans le servlet !");
            e.printStackTrace();
            out.write("{\"success\":false, \"message\":\"Erreur interne du serveur: " + e.getMessage() + "\"}");
        }
    }
}
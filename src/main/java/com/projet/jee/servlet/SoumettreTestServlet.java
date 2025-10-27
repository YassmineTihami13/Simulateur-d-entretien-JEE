package com.projet.jee.servlet;

import com.projet.jee.models.Question;
import com.projet.jee.models.QuestionChoixMultiple;
import com.projet.jee.models.QuestionVraiFaux;
import com.projet.jee.models.Choix;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/soumettreTest")
public class SoumettreTestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("testQuestions") == null) {
            response.sendRedirect(request.getContextPath() + "/genererTest");
            return;
        }

        List<Question> questions = (List<Question>) session.getAttribute("testQuestions");
        List<Map<String, Object>> corrections = new ArrayList<>();
        int score = 0;

        for (int i = 0; i < questions.size(); i++) {
            Question q = questions.get(i);
            String[] reponses = request.getParameterValues("reponse_" + i);
            List<String> reponsesCandidat = reponses != null ? List.of(reponses) : List.of();
            Map<String, Object> map = new HashMap<>();
         // Ajout du type de question pour le JSP
            map.put("typeQuestion", q instanceof QuestionChoixMultiple ? "QCM" : "VF");

            boolean correct = false;
            String explication = null;
            List<String> bonnesReponses = new ArrayList<>();
            List<String> reponsesTextesCandidat = new ArrayList<>();

            if (q instanceof QuestionVraiFaux) {
                boolean userRep = !reponsesCandidat.isEmpty() && Boolean.parseBoolean(reponsesCandidat.get(0));
                boolean bonneRep = ((QuestionVraiFaux) q).isReponseCorrecte();
                correct = userRep == bonneRep;
                if (correct) score++;
                bonnesReponses.add(bonneRep ? "Vrai" : "Faux");
                explication = ((QuestionVraiFaux) q).getExplication();

                // Texte clair pour la réponse candidat
                reponsesTextesCandidat.add(!reponsesCandidat.isEmpty() ? (userRep ? "Vrai" : "Faux") : "Aucune réponse");

            } else if (q instanceof QuestionChoixMultiple) {
                QuestionChoixMultiple qcm = (QuestionChoixMultiple) q;
                List<String> bonnesIds = new ArrayList<>();
                List<String> bonnesTextes = new ArrayList<>();

                for (Choix c : qcm.getChoixList()) {
                    if (c.isEstCorrect()) {
                        bonnesIds.add(String.valueOf(c.getId()));
                        bonnesTextes.add(c.getTexte());
                    }
                }

                // Vérifie les bonnes réponses par ID
                correct = new HashSet<>(reponsesCandidat).equals(new HashSet<>(bonnesIds));
                if (correct) score++;

                // Conversion des IDs choisis par le candidat → texte
                for (String idRep : reponsesCandidat) {
                    for (Choix c : qcm.getChoixList()) {
                        if (String.valueOf(c.getId()).equals(idRep)) {
                            reponsesTextesCandidat.add(c.getTexte());
                        }
                    }
                }

                bonnesReponses = bonnesTextes;
                explication = String.join(", ", bonnesTextes);
            }

            // Stockage des infos
            map.put("question", q);
            map.put("reponsesCandidat", reponsesTextesCandidat);
            map.put("bonnesReponses", bonnesReponses);
            map.put("correct", correct);
            map.put("explication", explication);

            corrections.add(map);
        }

        session.setAttribute("correctionsTest", corrections);
        session.setAttribute("scoreTest", score);
        session.setAttribute("nbQuestions", questions.size());

        response.sendRedirect(request.getContextPath() + "/jsp/resultatTest.jsp");
    }
}

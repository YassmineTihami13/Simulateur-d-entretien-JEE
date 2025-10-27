package com.projet.jee.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.projet.jee.models.QuestionReponse;
import com.projet.jee.models.Question.Difficulte;
import com.projet.jee.dao.ConnectionBD;

@WebServlet("/candidat/fiches-revision")
public class FichesRevisionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");

        // Vérifier si l'utilisateur est un candidat connecté
        if (userId == null || !"CANDIDAT".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Récupérer le domaine du candidat
        String domaineCandidatEnum = getDomaineCandidatEnum(userId);

        if (domaineCandidatEnum == null) {
            // Gérer le cas où le domaine n'est pas trouvé
            request.setAttribute("error", "Domaine du candidat non trouvé");
            request.getRequestDispatcher("/jsp/fichesRevision.jsp").forward(request, response);
            return;
        }

        // Récupérer les paramètres de filtrage
        String difficulteParam = request.getParameter("difficulte");

        // TOUJOURS utiliser le domaine du candidat, ignorer le paramètre domaine de la requête
        String domaineParam = domaineCandidatEnum;

        // Récupérer les questions de type REPONSE pour le domaine du candidat
        List<QuestionReponse> questions = getQuestionsReponse(domaineParam, difficulteParam);

        // Récupérer les réponses déjà données par le candidat
        Map<Long, String> reponsesCandidat = getReponsesCandidatMap(userId);

        request.setAttribute("questions", questions);
        request.setAttribute("domaineCandidatEnum", domaineCandidatEnum);
        request.setAttribute("selectedDifficulte", difficulteParam);
        request.setAttribute("selectedDomaine", domaineParam); // Pour compatibilité avec le PDF
        request.setAttribute("reponsesCandidat", reponsesCandidat);

        request.getRequestDispatcher("/jsp/fichesRevision.jsp").forward(request, response);
    }

    private String getDomaineCandidatEnum(Long candidatId) {
        String sql = "SELECT domaineProfessionnel FROM candidat WHERE id = ?";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, candidatId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getString("domaineProfessionnel");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    private List<QuestionReponse> getQuestionsReponse(String domaine, String difficulte) {
        List<QuestionReponse> questions = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT q.id, q.contenu, q.difficulte, q.domaine, q.dateCreation, q.createur_id, " +
                        "qr.reponseAttendue " +
                        "FROM question q " +
                        "INNER JOIN questionreponse qr ON q.id = qr.id " +
                        "WHERE q.typeQuestion = 'REPONSE'"
        );

        // TOUJOURS filtrer par domaine (celui du candidat)
        sql.append(" AND q.domaine = ?");

        // Ajouter le filtre de difficulté si spécifié
        if (difficulte != null && !difficulte.isEmpty()) {
            sql.append(" AND q.difficulte = ?");
        }

        sql.append(" ORDER BY q.dateCreation DESC");

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            pstmt.setString(paramIndex++, domaine);

            if (difficulte != null && !difficulte.isEmpty()) {
                pstmt.setString(paramIndex++, difficulte);
            }

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                QuestionReponse question = new QuestionReponse();
                question.setId(rs.getLong("id"));
                question.setContenu(rs.getString("contenu"));
                question.setDifficulte(Difficulte.valueOf(rs.getString("difficulte")));
                question.setDomaine(rs.getString("domaine"));

                Date sqlDate = rs.getDate("dateCreation");
                if (sqlDate != null) {
                    question.setDateCreation(sqlDate.toLocalDate());
                }

                question.setCreateurId(rs.getLong("createur_id"));
                question.setReponseAttendue(rs.getString("reponseAttendue"));

                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return questions;
    }

    private Map<Long, String> getReponsesCandidatMap(Long candidatId) {
        Map<Long, String> reponsesMap = new HashMap<>();
        String sql = "SELECT question_id, reponse_donnee FROM reponse_candidat WHERE candidat_id = ?";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, candidatId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                reponsesMap.put(rs.getLong("question_id"), rs.getString("reponse_donnee"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reponsesMap;
    }
}
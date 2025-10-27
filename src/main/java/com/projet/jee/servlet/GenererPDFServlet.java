package com.projet.jee.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.projet.jee.models.Question;
import com.projet.jee.models.QuestionReponse;
import com.projet.jee.dao.ConnectionBD;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/candidat/generer-pdf")
public class GenererPDFServlet extends HttpServlet {
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

        // Récupérer les paramètres de filtrage
        String difficulteParam = request.getParameter("difficulte");
        String domaineParam = request.getParameter("domaine");

        // Récupérer les questions et réponses
        List<QuestionReponse> questions = getQuestionsReponse(domaineParam, difficulteParam);
        Map<Long, String> reponsesCandidat = getReponsesCandidatMap(userId);

        try {
            // Configurer la réponse pour un téléchargement PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"fiches_revision_" + System.currentTimeMillis() + ".pdf\"");

            // Créer le document PDF
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Titre principal
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
            Paragraph title = new Paragraph("Fiches de Révision", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // Informations sur les filtres
            Font infoFont = new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC, BaseColor.GRAY);
            String filtersInfo = "Domaine: " + (domaineParam != null && !domaineParam.isEmpty() ? domaineParam : "Tous") +
                    " | Difficulté: " + (difficulteParam != null && !difficulteParam.isEmpty() ? difficulteParam : "Toutes");
            Paragraph filters = new Paragraph(filtersInfo, infoFont);
            filters.setSpacingAfter(20);
            document.add(filters);

            // Ajouter chaque question au PDF
            for (int i = 0; i < questions.size(); i++) {
                QuestionReponse question = questions.get(i);
                String reponseCandidat = reponsesCandidat.get(question.getId());

                addQuestionToPDF(document, question, i + 1, reponseCandidat);

                // Ajouter un saut de page après chaque question sauf la dernière
                if (i < questions.size() - 1) {
                    document.newPage();
                }
            }

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Erreur lors de la génération du PDF: " + e.getMessage());
        }
    }

    private void addQuestionToPDF(Document document, QuestionReponse question, int numero, String reponseCandidat)
            throws DocumentException {

        // En-tête de la question
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.BLUE);
        Paragraph questionHeader = new Paragraph("Question " + numero, headerFont);
        questionHeader.setSpacingAfter(10);
        document.add(questionHeader);

        // Métadonnées
        Font metaFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.GRAY);
        String metaInfo = "Domaine: " + question.getDomaine() + " | Difficulté: " + question.getDifficulte();
        Paragraph meta = new Paragraph(metaInfo, metaFont);
        meta.setSpacingAfter(15);
        document.add(meta);

        // Contenu de la question
        Font contentFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL, BaseColor.BLACK);
        Paragraph content = new Paragraph(question.getContenu(), contentFont);
        content.setSpacingAfter(15);
        document.add(content);

        // Réponse du candidat
        Font answerLabelFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph answerLabel = new Paragraph("Votre réponse :", answerLabelFont);
        answerLabel.setSpacingAfter(5);
        document.add(answerLabel);

        Font answerFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.BLACK);
        String reponseText = (reponseCandidat != null && !reponseCandidat.isEmpty()) ?
                reponseCandidat : "Aucune réponse fournie";
        Paragraph answer = new Paragraph(reponseText, answerFont);
        answer.setSpacingAfter(15);
        document.add(answer);

        // Réponse attendue
        Font expectedLabelFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, new BaseColor(0, 100, 0));
        Paragraph expectedLabel = new Paragraph("Réponse attendue :", expectedLabelFont);
        expectedLabel.setSpacingAfter(5);
        document.add(expectedLabel);

        Font expectedFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, new BaseColor(0, 100, 0));
        Paragraph expectedAnswer = new Paragraph(question.getReponseAttendue(), expectedFont);
        expectedAnswer.setSpacingAfter(20);
        document.add(expectedAnswer);

        // Ligne de séparation
        Paragraph separator = new Paragraph("______________________________________________________");
        separator.setSpacingAfter(20);
        document.add(separator);
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

        // Ajouter les filtres
        if (domaine != null && !domaine.isEmpty()) {
            sql.append(" AND q.domaine = ?");
        }
        if (difficulte != null && !difficulte.isEmpty()) {
            sql.append(" AND q.difficulte = ?");
        }

        sql.append(" ORDER BY q.dateCreation DESC");

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (domaine != null && !domaine.isEmpty()) {
                pstmt.setString(paramIndex++, domaine);
            }
            if (difficulte != null && !difficulte.isEmpty()) {
                pstmt.setString(paramIndex++, difficulte);
            }

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                QuestionReponse question = new QuestionReponse();
                question.setId(rs.getLong("id"));
                question.setContenu(rs.getString("contenu"));
                question.setDifficulte(Question.Difficulte.valueOf(rs.getString("difficulte")));
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

}
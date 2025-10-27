package com.projet.jee.dao;

import com.projet.jee.models.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TestDAO {

    // 🔹 Récupérer les questions adaptées au domaine du candidat
    public static List<Question> getQuestionsPourCandidat(long candidatId) throws SQLException {
        List<Question> questions = new ArrayList<>();

        String sql = "SELECT q.id, q.contenu, q.typeQuestion, q.difficulte, q.dateCreation, q.createur_id " +
                "FROM question q " +
                "JOIN formateur f ON q.createur_id = f.id " +
                "JOIN candidat c ON c.domaineProfessionnel = f.specialite " +
                "WHERE c.id = ? " +
                "AND q.typeQuestion IN ('VRAI_FAUX', 'CHOIX_MULTIPLE')";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, candidatId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String type = rs.getString("typeQuestion");
                    long idQuestion = rs.getLong("id");

                    if ("VRAI_FAUX".equalsIgnoreCase(type)) {
                        QuestionVraiFaux qvf = getQuestionVraiFaux(idQuestion);
                        if (qvf != null) questions.add(qvf);
                    } else if ("CHOIX_MULTIPLE".equalsIgnoreCase(type)) {
                        QuestionChoixMultiple qcm = getQuestionChoixMultiple(idQuestion);
                        if (qcm != null) questions.add(qcm);
                    }
                }
            }
        }

        return questions;
    }

    // 🔹 Charger une question Vrai/Faux
    private static QuestionVraiFaux getQuestionVraiFaux(long id) throws SQLException {
        String sql = "SELECT q.id, q.contenu, q.difficulte, q.dateCreation, q.createur_id, " +
                "vf.reponseCorrecte, vf.explication " +
                "FROM question q " +
                "JOIN questionvraifaux vf ON q.id = vf.id " +
                "WHERE q.id = ?";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new QuestionVraiFaux(
                            rs.getLong("id"),
                            rs.getString("contenu"),
                            Question.Difficulte.valueOf(rs.getString("difficulte")),
                            null,
                            rs.getDate("dateCreation").toLocalDate(),
                            rs.getLong("createur_id"),
                            rs.getBoolean("reponseCorrecte"),
                            rs.getString("explication")
                    );
                }
            }
        }
        return null;
    }

    // 🔹 Charger une question à choix multiple + ses choix
    private static QuestionChoixMultiple getQuestionChoixMultiple(long id) throws SQLException {
        String sqlQ = "SELECT q.id, q.contenu, q.difficulte, q.dateCreation, q.createur_id " +
                "FROM question q " +
                "JOIN questionchoixmultiple cm ON q.id = cm.id " +
                "WHERE q.id = ?";

        QuestionChoixMultiple qcm = null;

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlQ)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    qcm = new QuestionChoixMultiple();
                    qcm.setId(rs.getLong("id"));
                    qcm.setContenu(rs.getString("contenu"));
                    qcm.setTypeQuestion(Question.TypeQuestion.CHOIX_MULTIPLE);
                    qcm.setDifficulte(Question.Difficulte.valueOf(rs.getString("difficulte")));
                    qcm.setDateCreation(rs.getDate("dateCreation").toLocalDate());
                    qcm.setCreateurId(rs.getLong("createur_id"));
                }
            }
        }

        // Charger les choix associés
        if (qcm != null) {
            String sqlC = "SELECT * FROM choix WHERE question_id = ?";
            try (Connection conn = ConnectionBD.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sqlC)) {
                ps.setLong(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Choix choix = new Choix(
                                rs.getLong("id"),
                                rs.getString("texte"),
                                rs.getBoolean("estCorrect"),
                                rs.getLong("question_id")
                        );
                        qcm.addChoix(choix);
                    }
                }
            }
        }

        return qcm;
    }
}

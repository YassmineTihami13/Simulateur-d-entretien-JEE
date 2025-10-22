package com.projet.jee.dao;

import com.projet.jee.models.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    public long getQuestionCountByFormateur(long formateurId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM question WHERE createur_id = ?";
        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, formateurId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return 0;
    }

    public long getQuestionCountByType(long formateurId, String type) throws SQLException {
        String sql = "SELECT COUNT(*) FROM question WHERE createur_id = ? AND typeQuestion = ?";
        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, formateurId);
            ps.setString(2, type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return 0;
    }

    public List<Question> getQuestionsByFormateur(long formateurId) throws SQLException {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM question WHERE createur_id = ? ORDER BY dateCreation DESC";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, formateurId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Question question = createQuestionFromResultSet(rs);
                questions.add(question);
            }
        }
        return questions;
    }

    private Question createQuestionFromResultSet(ResultSet rs) throws SQLException {
        long id = rs.getLong("id");
        String contenu = rs.getString("contenu");
        String typeStr = rs.getString("typeQuestion");
        String difficulteStr = rs.getString("difficulte");
      
        Date dateCreation = rs.getDate("dateCreation");
        long createurId = rs.getLong("createur_id");

        Question.TypeQuestion type = Question.TypeQuestion.valueOf(typeStr);
        Question.Difficulte difficulte = Question.Difficulte.valueOf(difficulteStr);

        Question question;
        switch (type) {
            case VRAI_FAUX:
                question = createQuestionVraiFaux(id, rs);
                break;
            case CHOIX_MULTIPLE:
                question = createQuestionChoixMultiple(id, rs);
                break;
            case REPONSE:
                question = createQuestionReponse(id, rs);
                break;
            default:
                question = new Question();
        }

        question.setId(id);
        question.setContenu(contenu);
        question.setTypeQuestion(type);
        question.setDifficulte(difficulte);


        question.setDateCreation(dateCreation.toLocalDate());
        question.setCreateurId(createurId);

        return question;
    }

    private QuestionVraiFaux createQuestionVraiFaux(long questionId, ResultSet rs) throws SQLException {
        String sql = "SELECT * FROM questionvraifaux WHERE id = ?";
        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, questionId);
            ResultSet vfRs = ps.executeQuery();
            if (vfRs.next()) {
                boolean reponseCorrecte = vfRs.getBoolean("reponseCorrecte");
                String explication = vfRs.getString("explication");
                return new QuestionVraiFaux(questionId, "", Question.Difficulte.FACILE, "",
                        null, 0, reponseCorrecte, explication);
            }
        }
        return new QuestionVraiFaux();
    }

    private QuestionChoixMultiple createQuestionChoixMultiple(long questionId, ResultSet rs) throws SQLException {
        QuestionChoixMultiple qcm = new QuestionChoixMultiple();
        // Les choix seront chargés séparément si nécessaire
        return qcm;
    }

    private QuestionReponse createQuestionReponse(long questionId, ResultSet rs) throws SQLException {
        String sql = "SELECT * FROM questionreponse WHERE id = ?";
        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, questionId);
            ResultSet repRs = ps.executeQuery();
            if (repRs.next()) {
                String reponseAttendue = repRs.getString("reponseAttendue");
                return new QuestionReponse(questionId, "", Question.Difficulte.FACILE, "",
                        null, 0, reponseAttendue);
            }
        }
        return new QuestionReponse();
    }

    public boolean insertQuestion(Question question) throws SQLException {
        Connection con = null;
        try {
            con = ConnectionBD.getConnection();
            con.setAutoCommit(false);

            // Insérer dans la table question
            String sqlQuestion = "INSERT INTO question (contenu, typeQuestion, difficulte,  dateCreation, createur_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement psQuestion = con.prepareStatement(sqlQuestion, Statement.RETURN_GENERATED_KEYS);
            psQuestion.setString(1, question.getContenu());
            psQuestion.setString(2, question.getTypeQuestion().name());
            psQuestion.setString(3, question.getDifficulte().name());
         
            psQuestion.setDate(4, Date.valueOf(question.getDateCreation()));
            psQuestion.setLong(5, question.getCreateurId());

            int affectedRows = psQuestion.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Échec de l'insertion de la question");
            }

            // Récupérer l'ID généré
            long questionId;
            try (ResultSet generatedKeys = psQuestion.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    questionId = generatedKeys.getLong(1);
                } else {
                    throw new SQLException("Échec de la récupération de l'ID de la question");
                }
            }

            // Insérer dans les tables spécifiques selon le type
            switch (question.getTypeQuestion()) {
                case VRAI_FAUX:
                    insertQuestionVraiFaux(con, questionId, (QuestionVraiFaux) question);
                    break;
                case CHOIX_MULTIPLE:
                    insertQuestionChoixMultiple(con, questionId, (QuestionChoixMultiple) question);
                    break;
                case REPONSE:
                    insertQuestionReponse(con, questionId, (QuestionReponse) question);
                    break;
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    private void insertQuestionVraiFaux(Connection con, long questionId, QuestionVraiFaux question) throws SQLException {
        String sql = "INSERT INTO questionvraifaux (id, reponseCorrecte, explication) VALUES (?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, questionId);
            ps.setBoolean(2, question.isReponseCorrecte());
            ps.setString(3, question.getExplication());
            ps.executeUpdate();
        }
    }

    private void insertQuestionChoixMultiple(Connection con, long questionId, QuestionChoixMultiple question) throws SQLException {
        // Insérer l'ID dans questionchoixmultiple (ta table vide)
        String sqlQCM = "INSERT INTO questionchoixmultiple (id) VALUES (?)";
        try (PreparedStatement ps = con.prepareStatement(sqlQCM)) {
            ps.setLong(1, questionId);
            ps.executeUpdate();
        }

        // Insérer chaque choix dans la table choix
        String sqlChoix = "INSERT INTO choix (texte, estCorrect, question_id) VALUES (?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sqlChoix)) {
            for (Choix c : question.getChoixList()) {
                ps.setString(1, c.getTexte());
                ps.setBoolean(2, c.isEstCorrect());
                ps.setLong(3, questionId);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }


    private void insertQuestionReponse(Connection con, long questionId, QuestionReponse question) throws SQLException {
        String sql = "INSERT INTO questionreponse (id, reponseAttendue) VALUES (?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, questionId);
            ps.setString(2, question.getReponseAttendue());
            ps.executeUpdate();
        }
    }
    
    public List<Question> getQuestionsByFormateurAndType(long formateurId, String type) throws SQLException {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM question WHERE createur_id = ? AND typeQuestion = ? ORDER BY dateCreation DESC";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, formateurId);
            ps.setString(2, type);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Question question = createQuestionFromResultSet(rs);
                questions.add(question);
            }
        }
        return questions;
    }

    public boolean deleteQuestion(long questionId) throws SQLException {
        Connection con = null;
        try {
            con = ConnectionBD.getConnection();
            con.setAutoCommit(false);

            // Supprimer d'abord les tables spécifiques
            String[] deleteQueries = {
                "DELETE FROM questionvraifaux WHERE id = ?",
                "DELETE FROM questionreponse WHERE id = ?", 
                "DELETE FROM choix WHERE question_id = ?",
                "DELETE FROM questionchoixmultiple WHERE id = ?",
                "DELETE FROM question WHERE id = ?"
            };

            for (String query : deleteQueries) {
                try (PreparedStatement ps = con.prepareStatement(query)) {
                    ps.setLong(1, questionId);
                    ps.executeUpdate();
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }
}
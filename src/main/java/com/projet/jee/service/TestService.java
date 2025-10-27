package com.projet.jee.service;

import com.projet.jee.dao.TestDAO;
import com.projet.jee.models.Question;

import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

public class TestService {

    public List<Question> genererTestPourCandidat(long candidatId) throws SQLException {
        List<Question> toutesLesQuestions = TestDAO.getQuestionsPourCandidat(candidatId);

        if (toutesLesQuestions.size() < 10) {
            throw new IllegalArgumentException("Pas assez de questions disponibles pour ce domaine !");
        }

        Collections.shuffle(toutesLesQuestions);
        return toutesLesQuestions.subList(0, 10);
    }
}

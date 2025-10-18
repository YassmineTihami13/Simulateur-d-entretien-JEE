package com.projet.jee.model;

public class QuestionChoixMultiple extends Question {
    public QuestionChoixMultiple() {}

    public QuestionChoixMultiple(long id, String contenu, TypeQuestion type, Difficulte difficulte,
                                 String domaine, java.time.LocalDate dateCreation, long createurId) {
        super(id, contenu, type, difficulte, domaine, dateCreation, createurId);
    }

    @Override
    public String toString() {
        return "QuestionChoixMultiple " + super.toString();
    }
}
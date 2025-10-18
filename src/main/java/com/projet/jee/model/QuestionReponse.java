package com.projet.jee.model;

public class QuestionReponse extends Question {
    private String reponseAttendue;

    public QuestionReponse() {}

    public QuestionReponse(long id, String contenu, Difficulte difficulte, String domaine,
                           java.time.LocalDate dateCreation, long createurId, String reponseAttendue) {
        super(id, contenu, TypeQuestion.REPONSE, difficulte, domaine, dateCreation, createurId);
        this.reponseAttendue = reponseAttendue;
    }

    public String getReponseAttendue() { return reponseAttendue; }
    public void setReponseAttendue(String reponseAttendue) { this.reponseAttendue = reponseAttendue; }

    @Override
    public String toString() {
        return "QuestionReponse [reponseAttendue=" + reponseAttendue + "]";
    }
}
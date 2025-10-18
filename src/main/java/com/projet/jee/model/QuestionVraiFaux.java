package com.projet.jee.model;

public class QuestionVraiFaux extends Question {
    private boolean reponseCorrecte;
    private String explication;

    public QuestionVraiFaux() {}

    public QuestionVraiFaux(long id, String contenu, Difficulte difficulte, String domaine,
                            java.time.LocalDate dateCreation, long createurId,
                            boolean reponseCorrecte, String explication) {
        super(id, contenu, TypeQuestion.VRAI_FAUX, difficulte, domaine, dateCreation, createurId);
        this.reponseCorrecte = reponseCorrecte;
        this.explication = explication;
    }

    public boolean isReponseCorrecte() { return reponseCorrecte; }
    public void setReponseCorrecte(boolean reponseCorrecte) { this.reponseCorrecte = reponseCorrecte; }

    public String getExplication() { return explication; }
    public void setExplication(String explication) { this.explication = explication; }

    @Override
    public String toString() {
        return "QuestionVraiFaux [reponseCorrecte=" + reponseCorrecte + "]";
    }
}
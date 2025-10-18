package com.projet.jee.model;

import java.time.LocalDate;

public class Question {
    private long id;
    private String contenu;
    private TypeQuestion typeQuestion;
    private Difficulte difficulte;
    private String domaine;
    private LocalDate dateCreation;
    private long createurId;

    public enum TypeQuestion { VRAI_FAUX, CHOIX_MULTIPLE, REPONSE }
    public enum Difficulte { FACILE, MOYEN, DIFFICILE, EXPERT }

    public Question() {}

    public Question(long id, String contenu, TypeQuestion typeQuestion, Difficulte difficulte,
                    String domaine, LocalDate dateCreation, long createurId) {
        this.id = id;
        this.contenu = contenu;
        this.typeQuestion = typeQuestion;
        this.difficulte = difficulte;
        this.domaine = domaine;
        this.dateCreation = dateCreation;
        this.createurId = createurId;
    }

    // Getters & Setters
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getContenu() { return contenu; }
    public void setContenu(String contenu) { this.contenu = contenu; }

    public TypeQuestion getTypeQuestion() { return typeQuestion; }
    public void setTypeQuestion(TypeQuestion typeQuestion) { this.typeQuestion = typeQuestion; }

    public Difficulte getDifficulte() { return difficulte; }
    public void setDifficulte(Difficulte difficulte) { this.difficulte = difficulte; }

    public String getDomaine() { return domaine; }
    public void setDomaine(String domaine) { this.domaine = domaine; }

    public LocalDate getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDate dateCreation) { this.dateCreation = dateCreation; }

    public long getCreateurId() { return createurId; }
    public void setCreateurId(long createurId) { this.createurId = createurId; }

    @Override
    public String toString() {
        return "Question [id=" + id + ", contenu=" + contenu + ", typeQuestion=" + typeQuestion +
                ", difficulte=" + difficulte + ", domaine=" + domaine + "]";
    }
}
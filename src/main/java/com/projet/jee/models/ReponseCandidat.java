package com.projet.jee.models;

import java.time.LocalDateTime;

public class ReponseCandidat {
    private long id;
    private long candidatId;
    private long questionId;
    private String reponseDonnee;
    private LocalDateTime dateReponse;

    public ReponseCandidat() {
        this.dateReponse = LocalDateTime.now();
    }

    public ReponseCandidat(long id, long candidatId, long questionId, String reponseDonnee, LocalDateTime dateReponse) {
        this.id = id;
        this.candidatId = candidatId;
        this.questionId = questionId;
        this.reponseDonnee = reponseDonnee;
        this.dateReponse = dateReponse;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getCandidatId() {
        return candidatId;
    }

    public void setCandidatId(long candidatId) {
        this.candidatId = candidatId;
    }

    public long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(long questionId) {
        this.questionId = questionId;
    }

    public String getReponseDonnee() {
        return reponseDonnee;
    }

    public void setReponseDonnee(String reponseDonnee) {
        this.reponseDonnee = reponseDonnee;
    }

    public LocalDateTime getDateReponse() {
        return dateReponse;
    }

    public void setDateReponse(LocalDateTime dateReponse) {
        this.dateReponse = dateReponse;
    }

    @Override
    public String toString() {
        return "ReponseCandidat [id=" + id + ", candidatId=" + candidatId +
                ", questionId=" + questionId + ", dateReponse=" + dateReponse + "]";
    }
}
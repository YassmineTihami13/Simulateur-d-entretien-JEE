package com.projet.jee.model;

import java.time.LocalDate;

public class FeedbackFormateur {
    private long id;
    private int note;
    private String commentaire;
    private LocalDate dateFeedback;
    private long reservationId;

    public FeedbackFormateur() {}

    public FeedbackFormateur(long id, int note, String commentaire, LocalDate dateFeedback, long reservationId) {
        this.id = id;
        this.note = note;
        this.commentaire = commentaire;
        this.dateFeedback = dateFeedback;
        this.reservationId = reservationId;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public int getNote() { return note; }
    public void setNote(int note) { this.note = note; }

    public String getCommentaire() { return commentaire; }
    public void setCommentaire(String commentaire) { this.commentaire = commentaire; }

    public LocalDate getDateFeedback() { return dateFeedback; }
    public void setDateFeedback(LocalDate dateFeedback) { this.dateFeedback = dateFeedback; }

    public long getReservationId() { return reservationId; }
    public void setReservationId(long reservationId) { this.reservationId = reservationId; }

    @Override
    public String toString() {
        return "FeedbackFormateur [note=" + note + ", commentaire=" + commentaire + "]";
    }
}
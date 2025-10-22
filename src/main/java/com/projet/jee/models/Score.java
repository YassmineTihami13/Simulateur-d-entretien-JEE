package com.projet.jee.models;

import java.sql.Date;

public class Score {
    private double moyenne;
    private int totalFeedbacks;
    private Date derniereDate;
    private int derniereNote;

    // --- Constructeurs ---
    public Score() {}

    public Score(double moyenne, int totalFeedbacks, Date derniereDate, int derniereNote) {
        this.moyenne = moyenne;
        this.totalFeedbacks = totalFeedbacks;
        this.derniereDate = derniereDate;
        this.derniereNote = derniereNote;
    }

    // --- Getters & Setters ---
    public double getMoyenne() {
        return moyenne;
    }

    public void setMoyenne(double moyenne) {
        this.moyenne = moyenne;
    }

    public int getTotalFeedbacks() {
        return totalFeedbacks;
    }

    public void setTotalFeedbacks(int totalFeedbacks) {
        this.totalFeedbacks = totalFeedbacks;
    }

    public Date getDerniereDate() {
        return derniereDate;
    }

    public void setDerniereDate(Date derniereDate) {
        this.derniereDate = derniereDate;
    }

    public int getDerniereNote() {
        return derniereNote;
    }

    public void setDerniereNote(int derniereNote) {
        this.derniereNote = derniereNote;
    }

    // --- Méthode utilitaire ---
    @Override
    public String toString() {
        return "Score{" +
                "moyenne=" + moyenne +
                ", totalFeedbacks=" + totalFeedbacks +
                ", derniereDate=" + derniereDate +
                ", derniereNote=" + derniereNote +
                '}';
    }
}

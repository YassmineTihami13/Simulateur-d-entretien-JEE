package com.projet.jee.models;

import java.sql.Date;

public class Reservation {
    private long id;
    private Date dateReservation;
    private double duree;
    private double prix;
    private String statut;
    private String candidatNom;
    private String formateurNom;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public Date getDateReservation() { return dateReservation; }
    public void setDateReservation(Date dateReservation) { this.dateReservation = dateReservation; }

    public double getDuree() { return duree; }
    public void setDuree(double duree) { this.duree = duree; }

    public double getPrix() { return prix; }
    public void setPrix(double prix) { this.prix = prix; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getCandidatNom() { return candidatNom; }
    public void setCandidatNom(String candidatNom) { this.candidatNom = candidatNom; }

    public String getFormateurNom() { return formateurNom; }
    public void setFormateurNom(String formateurNom) { this.formateurNom = formateurNom; }
}

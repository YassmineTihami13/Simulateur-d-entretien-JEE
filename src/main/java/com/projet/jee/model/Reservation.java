package com.projet.jee.model;

import java.time.LocalDate;

public class Reservation {
    private long id;
    private LocalDate dateReservation;
    private double duree;
    private double prix;
    private long candidatId;
    private long formateurId;

    public Reservation() {}

    public Reservation(long id, LocalDate dateReservation, double duree, double prix, long candidatId, long formateurId) {
        this.id = id;
        this.dateReservation = dateReservation;
        this.duree = duree;
        this.prix = prix;
        this.candidatId = candidatId;
        this.formateurId = formateurId;
    }

    // Getters & Setters
    // ...
}
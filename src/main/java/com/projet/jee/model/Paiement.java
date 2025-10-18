package com.projet.jee.model;

import java.time.LocalDate;

public class Paiement {
    private long id;
    private double montant;
    private LocalDate datePaiement;
    private String methodePaiement;
    private long reservationId;

    public Paiement() {}

    public Paiement(long id, double montant, LocalDate datePaiement, String methodePaiement, long reservationId) {
        this.id = id;
        this.montant = montant;
        this.datePaiement = datePaiement;
        this.methodePaiement = methodePaiement;
        this.reservationId = reservationId;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public double getMontant() { return montant; }
    public void setMontant(double montant) { this.montant = montant; }

    public LocalDate getDatePaiement() { return datePaiement; }
    public void setDatePaiement(LocalDate datePaiement) { this.datePaiement = datePaiement; }

    public String getMethodePaiement() { return methodePaiement; }
    public void setMethodePaiement(String methodePaiement) { this.methodePaiement = methodePaiement; }

    public long getReservationId() { return reservationId; }
    public void setReservationId(long reservationId) { this.reservationId = reservationId; }

    @Override
    public String toString() {
        return "Paiement [montant=" + montant + ", methode=" + methodePaiement + "]";
    }
}
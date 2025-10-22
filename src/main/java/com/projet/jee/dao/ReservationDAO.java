package com.projet.jee.dao;

import com.projet.jee.models.Reservation;
import com.projet.jee.models.ReservationDetails;
import com.projet.jee.models.Reservation.Statut;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    private Statut statutFromDb(String dbValue) {
        if (dbValue == null) return null;
        switch (dbValue.toUpperCase()) {
            case "EN_ATTENTE": return Statut.EN_ATTENTE;
            case "CONFIRMEE":  return Statut.ACCEPTEE;
            case "REFUSEE":    return Statut.REFUSEE;
            default: return null;
        }
    }

    private String statutToDb(Statut s) {
        if (s == null) return null;
        switch (s) {
            case EN_ATTENTE: return "EN_ATTENTE";
            case ACCEPTEE:   return "CONFIRMEE";
            case REFUSEE:    return "REFUSEE";
            default: return s.name();
        }
    }

    /**
     * Récupère toutes les réservations avec détails complets pour un formateur
     */
    public List<ReservationDetails> getReservationsDetailsByFormateurId(long formateurId) throws SQLException {
        List<ReservationDetails> list = new ArrayList<>();
        String sql = "SELECT r.id, r.dateReservation, r.duree, r.prix, r.statut, " +
                "r.candidat_id, r.formateur_id, " +
                "u.nom, u.prenom, u.email, " +
                "c.cv " +
                "FROM reservation r " +
                "INNER JOIN utilisateur u ON r.candidat_id = u.id " +
                "INNER JOIN candidat c ON u.id = c.id " +
                "WHERE r.formateur_id = ? " +
                "ORDER BY r.dateReservation DESC, r.id DESC";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, formateurId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReservationDetails rd = new ReservationDetails();

                    // Informations de base de la réservation
                    rd.setId(rs.getLong("id"));

                    Date dateResa = rs.getDate("dateReservation");
                    if (dateResa != null) {
                        rd.setDateReservation(dateResa.toLocalDate());
                    }

                    rd.setDuree(rs.getDouble("duree"));
                    rd.setPrix(rs.getDouble("prix"));
                    rd.setCandidatId(rs.getLong("candidat_id"));
                    rd.setFormateurId(rs.getLong("formateur_id"));

                    // Informations du candidat
                    rd.setCandidatNom(rs.getString("nom"));
                    rd.setCandidatPrenom(rs.getString("prenom"));
                    rd.setCandidatEmail(rs.getString("email"));
                    rd.setCv(rs.getString("cv"));

                    // Statut
                    String statutStr = rs.getString("statut");
                    if (statutStr != null) {
                        Statut st = statutFromDb(statutStr);
                        rd.setStatut(st != null ? st : Statut.EN_ATTENTE);
                    } else {
                        rd.setStatut(Statut.EN_ATTENTE);
                    }

                    list.add(rd);
                }
            }
        }
        return list;
    }

    /**
     * Récupère toutes les réservations liées à un formateur (ordre décroissant)
     */
    public List<Reservation> getReservationsByFormateurId(long formateurId) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT id, dateReservation, duree, prix, candidat_id, formateur_id, statut " +
                "FROM reservation WHERE formateur_id = ? ORDER BY dateReservation DESC, id DESC";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, formateurId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setId(rs.getLong("id"));
                    Date d = rs.getDate("dateReservation");
                    if (d != null) r.setDateReservation(d.toLocalDate());
                    r.setDuree(rs.getDouble("duree"));
                    r.setPrix(rs.getDouble("prix"));
                    r.setCandidatId(rs.getLong("candidat_id"));
                    r.setFormateurId(rs.getLong("formateur_id"));

                    String statutStr = rs.getString("statut");
                    if (statutStr != null) {
                        Statut st = statutFromDb(statutStr);
                        r.setStatut(st != null ? st : Statut.EN_ATTENTE);
                    }
                    list.add(r);
                }
            }
        }
        return list;
    }

    /**
     * Met à jour le statut d'une réservation.
     */
    public boolean updateReservationStatus(long reservationId, Statut nouveauStatut, String rejectionReason) throws SQLException {
        String sql = "UPDATE reservation SET statut = ? WHERE id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statutToDb(nouveauStatut));
            ps.setLong(2, reservationId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Récupère l'email et le nom du candidat pour une réservation donnée
     */
    public String[] getCandidatContactByReservationId(long reservationId) throws SQLException {
        String sql = "SELECT u.email, u.prenom, u.nom FROM utilisateur u " +
                "INNER JOIN reservation r ON u.id = r.candidat_id WHERE r.id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String email = rs.getString("email");
                    String prenom = rs.getString("prenom");
                    String nom = rs.getString("nom");
                    return new String[]{ email, prenom + " " + nom };
                }
            }
        }
        return null;
    }

    /**
     * Récupère les détails d'une réservation
     */
    public Reservation getReservationById(long id) throws SQLException {
        String sql = "SELECT id, dateReservation, duree, prix, candidat_id, formateur_id, statut " +
                "FROM reservation WHERE id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reservation r = new Reservation();
                    r.setId(rs.getLong("id"));
                    Date d = rs.getDate("dateReservation");
                    if (d != null) r.setDateReservation(d.toLocalDate());
                    r.setDuree(rs.getDouble("duree"));
                    r.setPrix(rs.getDouble("prix"));
                    r.setCandidatId(rs.getLong("candidat_id"));
                    r.setFormateurId(rs.getLong("formateur_id"));

                    String statutStr = rs.getString("statut");
                    if (statutStr != null) r.setStatut(statutFromDb(statutStr));
                    return r;
                }
            }
        }
        return null;
    }
}
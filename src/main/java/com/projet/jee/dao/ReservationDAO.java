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
            case "ACCEPTEE":  return Statut.ACCEPTEE;
            case "REFUSEE":    return Statut.REFUSEE;
            default: return null;
        }
    }

    private String statutToDb(Statut s) {
        if (s == null) return null;
        switch (s) {
            case EN_ATTENTE: return "EN_ATTENTE";
            case ACCEPTEE:   return "ACCEPTEE";
            case REFUSEE:    return "REFUSEE";
            default: return s.name();
        }
    }

    // =================== Récupérations ===================

    public List<ReservationDetails> getReservationsDetailsByFormateurId(long formateurId) throws SQLException {
        List<ReservationDetails> list = new ArrayList<>();
        String sql = "SELECT r.id, r.dateReservation, r.duree, r.prix, r.statut, " +
                "r.candidat_id, r.formateur_id, r.session_link, " +
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
                    rd.setId(rs.getLong("id"));

                    Date dateResa = rs.getDate("dateReservation");
                    if (dateResa != null) rd.setDateReservation(dateResa.toLocalDate());

                    rd.setDuree(rs.getDouble("duree"));
                    rd.setPrix(rs.getDouble("prix"));
                    rd.setCandidatId(rs.getLong("candidat_id"));
                    rd.setFormateurId(rs.getLong("formateur_id"));
                    rd.setSessionLink(rs.getString("session_link"));

                    rd.setCandidatNom(rs.getString("nom"));
                    rd.setCandidatPrenom(rs.getString("prenom"));
                    rd.setCandidatEmail(rs.getString("email"));
                    rd.setCv(rs.getString("cv"));

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

    public List<Reservation> getReservationsByFormateurId(long formateurId) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT id, dateReservation, duree, prix, candidat_id, formateur_id, statut, session_link " +
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
                    r.setSessionLink(rs.getString("session_link"));

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

    public List<ReservationDetails> getReservationsDetailsByCandidatId(long candidatId) throws SQLException {
        List<ReservationDetails> list = new ArrayList<>();
        String sql = "SELECT r.id, r.dateReservation, r.duree, r.prix, r.statut, " +
                "r.candidat_id, r.formateur_id, r.session_link, " +
                "u.nom, u.prenom, u.email, " +
                "f.specialite, f.anneeExperience " +
                "FROM reservation r " +
                "INNER JOIN utilisateur u ON r.formateur_id = u.id " +
                "INNER JOIN formateur f ON u.id = f.id " +
                "WHERE r.candidat_id = ? " +
                "ORDER BY r.dateReservation DESC";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, candidatId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReservationDetails rd = new ReservationDetails();
                    rd.setId(rs.getLong("id"));
                    Date dateResa = rs.getDate("dateReservation");
                    if (dateResa != null) rd.setDateReservation(dateResa.toLocalDate());

                    rd.setDuree(rs.getDouble("duree"));
                    rd.setPrix(rs.getDouble("prix"));
                    rd.setCandidatId(rs.getLong("candidat_id"));
                    rd.setFormateurId(rs.getLong("formateur_id"));
                    rd.setSessionLink(rs.getString("session_link"));

                    rd.setCandidatNom(rs.getString("nom"));
                    rd.setCandidatPrenom(rs.getString("prenom"));
                    rd.setCandidatEmail(rs.getString("email"));

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

    // =================== Mises à jour ===================

    public boolean updateReservationStatus(long reservationId, Statut nouveauStatut, String rejectionReason) throws SQLException {
        String sql = "UPDATE reservation SET statut = ? WHERE id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statutToDb(nouveauStatut));
            ps.setLong(2, reservationId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateReservationStatus(long reservationId, Statut nouveauStatut, String rejectionReason, String sessionLink) throws SQLException {
        String sql = "UPDATE reservation SET statut = ?, session_link = ? WHERE id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statutToDb(nouveauStatut));
            ps.setString(2, sessionLink);
            ps.setLong(3, reservationId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateSessionLink(long reservationId, String sessionLink) throws SQLException {
        String sql = "UPDATE reservation SET session_link = ? WHERE id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionLink);
            ps.setLong(2, reservationId);
            return ps.executeUpdate() > 0;
        }
    }

    // =================== Autres ===================

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
                    return new String[]{email, prenom + " " + nom};
                }
            }
        }
        return null;
    }
    
    
    /**
 * Vérifie si une réservation peut être évaluée
 */
public boolean peutEtreEvaluee(long reservationId) throws SQLException {
    String sql = "SELECT peut_etre_evaluee FROM reservation WHERE id = ?";
    
    try (Connection conn = ConnectionBD.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setLong(1, reservationId);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            return rs.getBoolean("peut_etre_evaluee");
        }
        return false;
    }
}

   /**
 * Récupère les réservations acceptées avec le statut d'évaluation
 */
public List<ReservationDetails> getReservationsAccepteesByCandidatId(long candidatId) throws SQLException {
    List<ReservationDetails> list = new ArrayList<>();
    String sql = "SELECT r.id, r.dateReservation, r.prix, r.statut, " +
                "r.candidat_id, r.formateur_id, r.session_link, r.disponibilite_id, " +
                "r.peut_etre_evaluee, " + // ← CHAMP AJOUTÉ
                "d.jour, d.heureDebut, d.heureFin, " +
                "u.nom, u.prenom, u.email, " +
                "f.specialite, f.anneeExperience " +
                "FROM reservation r " +
                "INNER JOIN disponibilite d ON r.disponibilite_id = d.id " +
                "INNER JOIN utilisateur u ON r.formateur_id = u.id " +
                "INNER JOIN formateur f ON u.id = f.id " +
                "WHERE r.candidat_id = ? AND r.statut = 'ACCEPTEE' " +
                "ORDER BY d.jour DESC, d.heureDebut DESC";

    try (Connection conn = ConnectionBD.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setLong(1, candidatId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ReservationDetails rd = new ReservationDetails();
                rd.setId(rs.getLong("id"));
                
                // Date de réservation
                Date dateResa = rs.getDate("dateReservation");
                if (dateResa != null) {
                    rd.setDateReservation(dateResa.toLocalDate());
                }
                
                // Date et heure de la session
                Date dateSession = rs.getDate("jour");
                if (dateSession != null) {
                    rd.setDateSession(dateSession.toLocalDate());
                }
                
                Time heureDebut = rs.getTime("heureDebut");
                Time heureFin = rs.getTime("heureFin");
                if (heureDebut != null) {
                    rd.setHeureDebut(heureDebut.toLocalTime());
                }
                if (heureFin != null) {
                    rd.setHeureFin(heureFin.toLocalTime());
                }
                
                rd.setPrix(rs.getDouble("prix"));
                rd.setCandidatId(rs.getLong("candidat_id"));
                rd.setFormateurId(rs.getLong("formateur_id"));
                rd.setSessionLink(rs.getString("session_link"));
                
                // NOUVEAU : Statut d'évaluation
                rd.setPeutEtreEvaluee(rs.getBoolean("peut_etre_evaluee"));
                
                long disponibiliteId = rs.getLong("disponibilite_id");
                if (!rs.wasNull()) {
                    rd.setDisponibiliteId(disponibiliteId);
                }
                
                // Informations du formateur
                rd.setCandidatNom(rs.getString("nom")); 
                rd.setCandidatPrenom(rs.getString("prenom")); 
                rd.setCandidatEmail(rs.getString("email"));
                
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
    public ReservationDetails getReservationDetailsById(long reservationId) throws SQLException {
        String sql = "SELECT r.id, r.dateReservation, r.prix, r.statut, " +
                "r.candidat_id, r.formateur_id, r.session_link, r.disponibilite_id, " +
                "d.jour, d.heureDebut, d.heureFin, " +
                "u.nom, u.prenom, u.email, " +
                "f.specialite, f.anneeExperience " +
                "FROM reservation r " +
                "INNER JOIN disponibilite d ON r.disponibilite_id = d.id " +
                "INNER JOIN utilisateur u ON r.formateur_id = u.id " +
                "INNER JOIN formateur f ON u.id = f.id " +
                "WHERE r.id = ?";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ReservationDetails rd = new ReservationDetails();
                    rd.setId(rs.getLong("id"));

                    Date dateResa = rs.getDate("dateReservation");
                    if (dateResa != null) rd.setDateReservation(dateResa.toLocalDate());

                    Date dateSession = rs.getDate("jour");
                    if (dateSession != null) rd.setDateSession(dateSession.toLocalDate());

                    Time heureDebut = rs.getTime("heureDebut");
                    Time heureFin = rs.getTime("heureFin");
                    if (heureDebut != null) rd.setHeureDebut(heureDebut.toLocalTime());
                    if (heureFin != null) rd.setHeureFin(heureFin.toLocalTime());

                    rd.setPrix(rs.getDouble("prix"));
                    rd.setCandidatId(rs.getLong("candidat_id"));
                    rd.setFormateurId(rs.getLong("formateur_id"));
                    rd.setSessionLink(rs.getString("session_link"));

                    long disponibiliteId = rs.getLong("disponibilite_id");
                    if (!rs.wasNull()) rd.setDisponibiliteId(disponibiliteId);

                    rd.setCandidatNom(rs.getString("nom"));
                    rd.setCandidatPrenom(rs.getString("prenom"));
                    rd.setCandidatEmail(rs.getString("email"));

                    String statutStr = rs.getString("statut");
                    if (statutStr != null) {
                        Statut st = statutFromDb(statutStr);
                        rd.setStatut(st != null ? st : Statut.EN_ATTENTE);
                    } else {
                        rd.setStatut(Statut.EN_ATTENTE);
                    }

                    return rd;
                }
            }
        }
        return null;
    }
    
    /**
 * Méthode de debug pour vérifier l'état des réservations
 */
public void debugEtatReservations(long candidatId) throws SQLException {
    String sql = "SELECT r.id, r.statut, r.peut_etre_evaluee, " +
                "d.jour, d.heureDebut, d.heureFin, " +
                "CURDATE() as aujourdhui, CURTIME() as maintenant " +
                "FROM reservation r " +
                "INNER JOIN disponibilite d ON r.disponibilite_id = d.id " +
                "WHERE r.candidat_id = ? AND r.statut = 'ACCEPTEE'";
    
    try (Connection conn = ConnectionBD.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setLong(1, candidatId);
        try (ResultSet rs = ps.executeQuery()) {
            System.out.println("=== DEBUG ÉTAT RÉSERVATIONS ===");
            while (rs.next()) {
                System.out.println("Réservation #" + rs.getLong("id") + 
                                 " - Statut: " + rs.getString("statut") +
                                 " - Peut être évaluée: " + rs.getBoolean("peut_etre_evaluee") +
                                 " - Date session: " + rs.getDate("jour") +
                                 " - Heure fin: " + rs.getTime("heureFin") +
                                 " - Aujourd'hui: " + rs.getDate("aujourdhui") +
                                 " - Maintenant: " + rs.getTime("maintenant"));
            }
            System.out.println("=== FIN DEBUG ===");
        }
    }
}

    public Reservation getReservationById(long id) throws SQLException {
        String sql = "SELECT id, dateReservation, duree, prix, candidat_id, formateur_id, statut, session_link " +
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
                    r.setSessionLink(rs.getString("session_link"));

                    String statutStr = rs.getString("statut");
                    if (statutStr != null) r.setStatut(statutFromDb(statutStr));
                    return r;
                }
            }
        }
        return null;
    }
}

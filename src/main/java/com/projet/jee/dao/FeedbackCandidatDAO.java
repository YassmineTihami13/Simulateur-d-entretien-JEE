package com.projet.jee.dao;

import com.projet.jee.models.FeedbackCandidat;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackCandidatDAO {

    /**
     * Ajoute un feedback pour une réservation
     */
    public boolean ajouterFeedback(FeedbackCandidat feedback) throws SQLException {
        String sql = "INSERT INTO feedbackcandidat (note, commentaire, dateFeedback, reservation_id) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, feedback.getNote());
            stmt.setString(2, feedback.getCommentaire());
            stmt.setDate(3, Date.valueOf(feedback.getDateFeedback()));
            stmt.setLong(4, feedback.getReservationId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Vérifie si une réservation a déjà été évaluée
     */
    public boolean feedbackExistsForReservation(long reservationId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM feedbackcandidat WHERE reservation_id = ?";
        
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Récupère tous les feedbacks pour un formateur
     */
    public List<FeedbackCandidat> getFeedbacksByFormateurId(long formateurId) throws SQLException {
        List<FeedbackCandidat> feedbacks = new ArrayList<>();
        String sql = "SELECT fc.* FROM feedbackcandidat fc " +
                    "INNER JOIN reservation r ON fc.reservation_id = r.id " +
                    "WHERE r.formateur_id = ? " +
                    "ORDER BY fc.dateFeedback DESC";
        
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, formateurId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                FeedbackCandidat feedback = new FeedbackCandidat();
                feedback.setId(rs.getLong("id"));
                feedback.setNote(rs.getInt("note"));
                feedback.setCommentaire(rs.getString("commentaire"));
                feedback.setDateFeedback(rs.getDate("dateFeedback").toLocalDate());
                feedback.setReservationId(rs.getLong("reservation_id"));
                feedbacks.add(feedback);
            }
        }
        return feedbacks;
    }

    /**
     * Récupère la note moyenne d'un formateur
     */
    public double getNoteMoyenneFormateur(long formateurId) throws SQLException {
        String sql = "SELECT AVG(fc.note) as moyenne FROM feedbackcandidat fc " +
                    "INNER JOIN reservation r ON fc.reservation_id = r.id " +
                    "WHERE r.formateur_id = ?";
        
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, formateurId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("moyenne");
            }
        }
        return 0.0;
    }

    /**
     * Récupère le feedback pour une réservation spécifique
     */
    public FeedbackCandidat getFeedbackByReservationId(long reservationId) throws SQLException {
        String sql = "SELECT * FROM feedbackcandidat WHERE reservation_id = ?";
        
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                FeedbackCandidat feedback = new FeedbackCandidat();
                feedback.setId(rs.getLong("id"));
                feedback.setNote(rs.getInt("note"));
                feedback.setCommentaire(rs.getString("commentaire"));
                feedback.setDateFeedback(rs.getDate("dateFeedback").toLocalDate());
                feedback.setReservationId(rs.getLong("reservation_id"));
                return feedback;
            }
        }
        return null;
    }
}
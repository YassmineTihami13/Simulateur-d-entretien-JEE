package com.projet.jee.jobs;

import com.projet.jee.dao.ConnectionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.logging.Logger;

public class ActivationEvaluationJob implements Runnable {
    
    private static final Logger logger = Logger.getLogger(ActivationEvaluationJob.class.getName());

    @Override
    public void run() {
        LocalDateTime startTime = LocalDateTime.now();
        System.out.println("⏰ DÉBUT CRON - " + startTime);
        
        try {
            int reservationsActivees = activerEvaluationsPourSessionsTerminees();
            int reservationsDesactivees = desactiverEvaluationsPourSessionsFutures();
            
            System.out.println("📊 RÉSULTAT CRON:");
            System.out.println("   ✅ " + reservationsActivees + " évaluation(s) activée(s)");
            System.out.println("   ❌ " + reservationsDesactivees + " évaluation(s) désactivée(s)");
            System.out.println("⏰ FIN CRON - " + LocalDateTime.now());
            
        } catch (Exception e) {
            System.err.println("💥 ERREUR CRON: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private int activerEvaluationsPourSessionsTerminees() throws SQLException {
        String sql = "UPDATE reservation r " +
                    "INNER JOIN disponibilite d ON r.disponibilite_id = d.id " +
                    "SET r.peut_etre_evaluee = TRUE " +
                    "WHERE r.statut = 'ACCEPTEE' " +
                    "AND r.peut_etre_evaluee = FALSE " +
                    "AND (d.jour < CURDATE() OR (d.jour = CURDATE() AND d.heureFin <= ?))";
        
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Ajouter une marge de sécurité de 5 minutes
            LocalTime nowWithMargin = LocalTime.now().plusMinutes(5);
            stmt.setTime(1, java.sql.Time.valueOf(nowWithMargin));
            
            int rowsUpdated = stmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                System.out.println("   🔓 Activation de " + rowsUpdated + " évaluation(s)");
            }
            
            return rowsUpdated;
        }
    }
    
    private int desactiverEvaluationsPourSessionsFutures() throws SQLException {
        String sql = "UPDATE reservation r " +
                    "INNER JOIN disponibilite d ON r.disponibilite_id = d.id " +
                    "SET r.peut_etre_evaluee = FALSE " +
                    "WHERE r.statut = 'ACCEPTEE' " +
                    "AND r.peut_etre_evaluee = TRUE " +
                    "AND (d.jour > CURDATE() OR (d.jour = CURDATE() AND d.heureFin > ?))";
        
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTime(1, java.sql.Time.valueOf(LocalTime.now()));
            int rowsUpdated = stmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                System.out.println("   🔒 Désactivation de " + rowsUpdated + " évaluation(s)");
            }
            
            return rowsUpdated;
        }
    }
}
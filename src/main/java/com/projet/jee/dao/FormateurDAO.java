
package com.projet.jee.dao;

import com.projet.jee.models.Formateur;
import com.projet.jee.models.Utilisateur;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FormateurDAO {

    public List<Formateur> getAllFormateurs() throws SQLException {
        List<Formateur> formateurs = new ArrayList<>();
        String sql = "SELECT u.id, u.nom, u.prenom, u.email, u.role, u.statut, " +
                "f.specialite, f.anneeExperience, f.certifications, f.tarifHoraire, f.description " +
                "FROM utilisateur u " +
                "INNER JOIN formateur f ON u.id = f.id " +
                "WHERE u.role = 'FORMATEUR' " +
                "ORDER BY u.nom, u.prenom";

        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Formateur formateur = new Formateur();
                formateur.setId(rs.getLong("id"));
                formateur.setNom(rs.getString("nom"));
                formateur.setPrenom(rs.getString("prenom"));
                formateur.setEmail(rs.getString("email"));
                formateur.setRole(Utilisateur.Role.valueOf(rs.getString("role")));

                // AJOUT IMPORTANT: Récupérer le statut
                formateur.setStatut(rs.getBoolean("statut"));

                formateur.setSpecialite(rs.getString("specialite"));
                formateur.setAnneeExperience(rs.getInt("anneeExperience"));
                formateur.setCertifications(rs.getString("certifications"));
                formateur.setTarifHoraire(rs.getDouble("tarifHoraire"));
                formateur.setDescription(rs.getString("description"));

                formateurs.add(formateur);
            }
        }
        return formateurs;
    }

    public boolean toggleFormateurStatus(long formateurId, boolean newStatus) throws SQLException {
        String sql = "UPDATE utilisateur SET statut = ? WHERE id = ? AND role = 'FORMATEUR'";
        
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, newStatus);
            stmt.setLong(2, formateurId);
            
            return stmt.executeUpdate() > 0;
        }
    }

// Dans FormateurDAO.java - Ajouter cette méthode
public Formateur getFormateurById(long id) throws SQLException {
    String sql = "SELECT u.id, u.nom, u.prenom, u.email, u.role, u.statut, " +
            "f.specialite, f.anneeExperience, f.certifications, f.tarifHoraire, f.description " +
            "FROM utilisateur u " +
            "INNER JOIN formateur f ON u.id = f.id " +
            "WHERE u.id = ? AND u.role = 'FORMATEUR'";

    try (Connection conn = ConnectionBD.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setLong(1, id);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Formateur formateur = new Formateur();
                formateur.setId(rs.getLong("id"));
                formateur.setNom(rs.getString("nom"));
                formateur.setPrenom(rs.getString("prenom"));
                formateur.setEmail(rs.getString("email"));
                formateur.setRole(Utilisateur.Role.valueOf(rs.getString("role")));

                // AJOUT IMPORTANT: Récupérer le statut
                formateur.setStatut(rs.getBoolean("statut"));

                formateur.setSpecialite(rs.getString("specialite"));
                formateur.setAnneeExperience(rs.getInt("anneeExperience"));
                formateur.setCertifications(rs.getString("certifications"));
                formateur.setTarifHoraire(rs.getDouble("tarifHoraire"));
                formateur.setDescription(rs.getString("description"));

                return formateur;
            }
        }
    }
    return null;
}
}
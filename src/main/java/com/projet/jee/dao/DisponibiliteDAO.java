package com.projet.jee.dao;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import com.projet.jee.models.Disponibilite;

public class DisponibiliteDAO {

    /**
     * Récupère toutes les disponibilités ACTIVES d'un formateur (futures ou aujourd'hui)
     */
    public List<Disponibilite> getDisponibilitesByFormateur(long formateurId) {
        List<Disponibilite> disponibilites = new ArrayList<>();
        String query = "SELECT * FROM disponibilite " +
                "WHERE formateur_id = ? AND jour >= CURDATE() " +
                "ORDER BY jour, heureDebut";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, formateurId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Disponibilite dispo = new Disponibilite(
                        rs.getLong("id"),
                        rs.getDate("jour").toLocalDate(),
                        rs.getTime("heureDebut").toLocalTime(),
                        rs.getTime("heureFin").toLocalTime(),
                        rs.getLong("formateur_id")
                );
                disponibilites.add(dispo);
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des disponibilités");
            e.printStackTrace();
        }
        return disponibilites;
    }

    /**
     * Récupère l'HISTORIQUE des disponibilités passées d'un formateur
     */
    public List<Disponibilite> getHistoriqueDisponibilites(long formateurId) {
        List<Disponibilite> disponibilites = new ArrayList<>();
        String query = "SELECT * FROM disponibilite " +
                "WHERE formateur_id = ? AND jour < CURDATE() " +
                "ORDER BY jour DESC, heureDebut DESC";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, formateurId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Disponibilite dispo = new Disponibilite(
                        rs.getLong("id"),
                        rs.getDate("jour").toLocalDate(),
                        rs.getTime("heureDebut").toLocalTime(),
                        rs.getTime("heureFin").toLocalTime(),
                        rs.getLong("formateur_id")
                );
                disponibilites.add(dispo);
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération de l'historique");
            e.printStackTrace();
        }
        return disponibilites;
    }

    /**
     * Vérifie si une disponibilité est déjà réservée ET acceptée
     * Une disponibilité est considérée réservée seulement si le statut = 'ACCEPTEE'
     */
    public boolean isDisponibiliteReservee(long disponibiliteId) {
        String query = "SELECT COUNT(*) FROM reservation " +
                "WHERE disponibilite_id = ? AND statut = 'ACCEPTEE'";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, disponibiliteId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la vérification de réservation");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Récupère le statut de réservation d'une disponibilité
     * @return "ACCEPTEE", "EN_ATTENTE", "REFUSEE", ou null si pas de réservation
     */
    public String getStatutReservation(long disponibiliteId) {
        String query = "SELECT statut FROM reservation " +
                "WHERE disponibilite_id = ? " +
                "ORDER BY id DESC LIMIT 1";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, disponibiliteId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("statut");
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération du statut");
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Ajoute une nouvelle disponibilité
     */
    public boolean ajouterDisponibilite(Disponibilite dispo) {
        String query = "INSERT INTO disponibilite (jour, heureDebut, heureFin, formateur_id) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setDate(1, Date.valueOf(dispo.getJour()));
            ps.setTime(2, Time.valueOf(dispo.getHeureDebut()));
            ps.setTime(3, Time.valueOf(dispo.getHeureFin()));
            ps.setLong(4, dispo.getFormateurId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de l'ajout de la disponibilité");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Modifie une disponibilité existante
     */
    public boolean modifierDisponibilite(Disponibilite dispo) {
        String query = "UPDATE disponibilite SET jour = ?, heureDebut = ?, heureFin = ? " +
                "WHERE id = ? AND formateur_id = ?";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setDate(1, Date.valueOf(dispo.getJour()));
            ps.setTime(2, Time.valueOf(dispo.getHeureDebut()));
            ps.setTime(3, Time.valueOf(dispo.getHeureFin()));
            ps.setLong(4, dispo.getId());
            ps.setLong(5, dispo.getFormateurId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de la modification de la disponibilité");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Supprime une disponibilité si elle n'est pas réservée
     */
    public boolean supprimerDisponibilite(long disponibiliteId, long formateurId) {
        // Vérifier d'abord si elle est réservée
        if (isDisponibiliteReservee(disponibiliteId)) {
            return false;
        }

        String query = "DELETE FROM disponibilite WHERE id = ? AND formateur_id = ?";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, disponibiliteId);
            ps.setLong(2, formateurId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de la suppression de la disponibilité");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Récupère une disponibilité par son ID
     */
    public Disponibilite getDisponibiliteById(long id) {
        String query = "SELECT * FROM disponibilite WHERE id = ?";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Disponibilite(
                        rs.getLong("id"),
                        rs.getDate("jour").toLocalDate(),
                        rs.getTime("heureDebut").toLocalTime(),
                        rs.getTime("heureFin").toLocalTime(),
                        rs.getLong("formateur_id")
                );
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération de la disponibilité");
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Vérifie s'il y a un chevauchement avec d'autres disponibilités
     */
    public boolean checkChevauchement(Disponibilite dispo) {
        String query = "SELECT COUNT(*) FROM disponibilite " +
                "WHERE formateur_id = ? AND jour = ? AND id != ? " +
                "AND ((heureDebut < ? AND heureFin > ?) OR " +
                "(heureDebut < ? AND heureFin > ?) OR " +
                "(heureDebut >= ? AND heureFin <= ?))";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, dispo.getFormateurId());
            ps.setDate(2, Date.valueOf(dispo.getJour()));
            ps.setLong(3, dispo.getId());
            ps.setTime(4, Time.valueOf(dispo.getHeureFin()));
            ps.setTime(5, Time.valueOf(dispo.getHeureDebut()));
            ps.setTime(6, Time.valueOf(dispo.getHeureFin()));
            ps.setTime(7, Time.valueOf(dispo.getHeureDebut()));
            ps.setTime(8, Time.valueOf(dispo.getHeureDebut()));
            ps.setTime(9, Time.valueOf(dispo.getHeureFin()));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la vérification du chevauchement");
            e.printStackTrace();
        }
        return false;
    }
}
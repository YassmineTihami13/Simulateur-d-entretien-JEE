package com.projet.jee.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

import com.projet.jee.models.Formateur;
import com.projet.jee.models.Disponibilite;
import com.projet.jee.dao.DisponibiliteDAO;

@WebServlet("/disponibilites")
public class DisponibiliteServlet extends HttpServlet {

    private DisponibiliteDAO dao = new DisponibiliteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("formateur") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        Formateur formateur = (Formateur) session.getAttribute("formateur");
        String action = request.getParameter("action");
        String view = request.getParameter("view");

        if ("edit".equals(action)) {
            long id = Long.parseLong(request.getParameter("id"));
            Disponibilite dispo = dao.getDisponibiliteById(id);
            request.setAttribute("disponibilite", dispo);
            request.setAttribute("mode", "edit");
        } else if ("delete".equals(action)) {
            long id = Long.parseLong(request.getParameter("id"));
            if (dao.supprimerDisponibilite(id, formateur.getId())) {
                request.setAttribute("successMessage", "Disponibilité supprimée avec succès");
            } else {
                request.setAttribute("errorMessage", "Impossible de supprimer cette disponibilité (déjà réservée)");
            }
        }

        List<Disponibilite> disponibilites;
        if ("historique".equals(view)) {
            disponibilites = dao.getHistoriqueDisponibilites(formateur.getId());
            request.setAttribute("isHistorique", true);
        } else {
            disponibilites = dao.getDisponibilitesByFormateur(formateur.getId());
            request.setAttribute("isHistorique", false);
        }

        for (Disponibilite dispo : disponibilites) {
            boolean reservee = dao.isDisponibiliteReservee(dispo.getId());
            String statutReservation = dao.getStatutReservation(dispo.getId());

            request.setAttribute("reservee_" + dispo.getId(), reservee);
            request.setAttribute("statut_" + dispo.getId(), statutReservation);
        }

        request.setAttribute("disponibilites", disponibilites);
        request.getRequestDispatcher("/jsp/disponibilites_formateur.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("formateur") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        Formateur formateur = (Formateur) session.getAttribute("formateur");
        String action = request.getParameter("action");

        try {
            String jourStr = request.getParameter("jour");
            String heureDebutStr = request.getParameter("heureDebut");
            String heureFinStr = request.getParameter("heureFin");

            LocalDate jour = LocalDate.parse(jourStr);
            LocalTime heureDebut = LocalTime.parse(heureDebutStr);
            LocalTime heureFin = LocalTime.parse(heureFinStr);

            if (jour.isBefore(LocalDate.now())) {
                request.setAttribute("errorMessage", "La date ne peut pas être dans le passé");
                doGet(request, response);
                return;
            }

            if (heureDebut.isAfter(heureFin) || heureDebut.equals(heureFin)) {
                request.setAttribute("errorMessage", "L'heure de début doit être avant l'heure de fin");
                doGet(request, response);
                return;
            }

            Disponibilite dispo = new Disponibilite();
            dispo.setJour(jour);
            dispo.setHeureDebut(heureDebut);
            dispo.setHeureFin(heureFin);
            dispo.setFormateurId(formateur.getId());

            if ("edit".equals(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                dispo.setId(id);

                if (dao.checkChevauchement(dispo)) {
                    request.setAttribute("errorMessage", "Cette disponibilité chevauche une autre disponibilité existante");
                    doGet(request, response);
                    return;
                }

                if (dao.modifierDisponibilite(dispo)) {
                    request.setAttribute("successMessage", "Disponibilité modifiée avec succès");
                } else {
                    request.setAttribute("errorMessage", "Erreur lors de la modification");
                }
            } else {
                if (dao.checkChevauchement(dispo)) {
                    request.setAttribute("errorMessage", "Cette disponibilité chevauche une autre disponibilité existante");
                    doGet(request, response);
                    return;
                }

                if (dao.ajouterDisponibilite(dispo)) {
                    request.setAttribute("successMessage", "Disponibilité ajoutée avec succès");
                } else {
                    request.setAttribute("errorMessage", "Erreur lors de l'ajout");
                }
            }

        } catch (DateTimeParseException e) {
            request.setAttribute("errorMessage", "Format de date ou d'heure invalide");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            e.printStackTrace();
        }

        doGet(request, response);
    }
}

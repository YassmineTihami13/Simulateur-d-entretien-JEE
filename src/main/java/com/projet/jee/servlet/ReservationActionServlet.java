package com.projet.jee.servlet;

import com.projet.jee.dao.ReservationDAO;
import com.projet.jee.model.Reservation;
import com.projet.jee.model.Reservation.Statut;
import com.projet.jee.service.EmailUtil;
import com.projet.jee.model.Formateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/reservationAction")
public class ReservationActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Securité : vérifier session formateur
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("formateur") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        Formateur formateur = (Formateur) session.getAttribute("formateur");

        String action = request.getParameter("action"); // "accept" ou "reject"
        String idStr = request.getParameter("reservationId");
        if (idStr == null || idStr.isEmpty() || action == null) {
            response.sendRedirect(request.getContextPath() + "/reservations");
            return;
        }

        long reservationId = Long.parseLong(idStr);
        ReservationDAO dao = new ReservationDAO();
        try {
            if ("accept".equalsIgnoreCase(action)) {
                boolean ok = dao.updateReservationStatus(reservationId, Statut.ACCEPTEE, null);
                if (ok) {
                    // récupérer contact candidat et détails
                    String[] contact = dao.getCandidatContactByReservationId(reservationId);
                    Reservation reservation = dao.getReservationById(reservationId);
                    if (contact != null && reservation != null) {
                        String email = contact[0];
                        String candidatNom = contact[1];
                        EmailUtil.sendReservationAcceptedEmail(email, candidatNom, formateur.getPrenom() + " " + formateur.getNom(), reservation);
                    }
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().isEmpty()) reason = "Motif non précisé";
                boolean ok = dao.updateReservationStatus(reservationId, Statut.REFUSEE, reason);
                if (ok) {
                    String[] contact = dao.getCandidatContactByReservationId(reservationId);
                    Reservation reservation = dao.getReservationById(reservationId);
                    if (contact != null && reservation != null) {
                        String email = contact[0];
                        String candidatNom = contact[1];
                        EmailUtil.sendReservationRejectedEmail(email, candidatNom, formateur.getPrenom() + " " + formateur.getNom(), reservation, reason);
                    }
                }
            }
            // après action revenir à la liste
            response.sendRedirect(request.getContextPath() + "/reservations");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reservations?error=server");
        }
    }
}

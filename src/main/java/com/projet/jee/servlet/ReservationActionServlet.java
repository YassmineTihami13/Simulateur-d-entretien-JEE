package com.projet.jee.servlet;

import com.projet.jee.dao.ReservationDAO;
import com.projet.jee.models.Reservation;
import com.projet.jee.models.Reservation.Statut;
import com.projet.jee.service.EmailUtil;
import com.projet.jee.models.Formateur;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/reservationAction")
public class ReservationActionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Sécurité : vérifier session formateur
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("formateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Formateur formateur = (Formateur) session.getAttribute("formateur");
        String action = request.getParameter("action");
        String idStr = request.getParameter("reservationId");

        if (idStr == null || idStr.isEmpty() || action == null) {
            response.sendRedirect(request.getContextPath() + "/reservations?error=missing_params");
            return;
        }

        long reservationId;
        try {
            reservationId = Long.parseLong(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reservations?error=invalid_id");
            return;
        }

        ReservationDAO dao = new ReservationDAO();
        try {
            boolean success = false;

            if ("reject".equalsIgnoreCase(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().isEmpty()) {
                    reason = "Motif non précisé";
                }

                // Utilisez la méthode existante sans lien de session pour le refus
                success = dao.updateReservationStatus(reservationId, Statut.REFUSEE, reason, null);
                if (success) {
                    String[] contact = dao.getCandidatContactByReservationId(reservationId);
                    Reservation reservation = dao.getReservationById(reservationId);
                    if (contact != null && reservation != null) {
                        String email = contact[0];
                        String candidatNom = contact[1];
                        EmailUtil.sendReservationRejectedEmail(
                                email, candidatNom,
                                formateur.getPrenom() + " " + formateur.getNom(),
                                reservation, reason
                        );
                    }
                    response.sendRedirect(request.getContextPath() + "/reservations?success=rejected");
                } else {
                    response.sendRedirect(request.getContextPath() + "/reservations?error=reject_failed");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reservations?error=server_error");
        }
    }
}
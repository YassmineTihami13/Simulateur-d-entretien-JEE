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

@WebServlet("/acceptReservation")
public class AcceptReservationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("formateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Formateur formateur = (Formateur) session.getAttribute("formateur");
        String idStr = request.getParameter("reservationId");
        String sessionLink = request.getParameter("sessionLink");

        if (idStr == null || idStr.isEmpty() || sessionLink == null || sessionLink.trim().isEmpty()) {
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
            // Mettre à jour le statut et le lien de session
            boolean success = dao.updateReservationStatus(reservationId, Statut.ACCEPTEE, null, sessionLink.trim());
            
            if (success) {
                // Envoyer l'email de confirmation
                String[] contact = dao.getCandidatContactByReservationId(reservationId);
                
                // Créer un objet Reservation avec le lien de session pour l'email
                Reservation reservation = new Reservation();
                reservation.setId(reservationId);
                reservation.setDateReservation(dao.getReservationById(reservationId).getDateReservation());
                reservation.setDuree(dao.getReservationById(reservationId).getDuree());
                reservation.setPrix(dao.getReservationById(reservationId).getPrix());
                reservation.setSessionLink(sessionLink.trim()); // IMPORTANT: Utiliser le lien directement
                
                if (contact != null) {
                    String email = contact[0];
                    String candidatNom = contact[1];
                    boolean emailSent = EmailUtil.sendReservationAcceptedEmail(
                            email, candidatNom,
                            formateur.getPrenom() + " " + formateur.getNom(),
                            reservation
                    );
                    
                    if (emailSent) {
                        response.sendRedirect(request.getContextPath() + "/reservations?success=accepted");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/reservations?success=accepted_no_email");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/reservations?success=accepted_no_contact");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/reservations?error=accept_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reservations?error=server_error");
        }
    }
}
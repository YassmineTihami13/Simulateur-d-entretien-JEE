package com.projet.jee.servlet;

import com.projet.jee.dao.ReservationDAO;
import com.projet.jee.dao.FeedbackCandidatDAO;
import com.projet.jee.models.ReservationDetails;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/mesReservations")
public class MesReservationsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("candidatId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long candidatId = (Long) session.getAttribute("candidatId");

        ReservationDAO reservationDAO = new ReservationDAO();
        FeedbackCandidatDAO feedbackDAO = new FeedbackCandidatDAO();

        try {
            // Récupérer les réservations acceptées avec les infos de disponibilité
            List<ReservationDetails> reservations = reservationDAO.getReservationsAccepteesByCandidatId(candidatId);
            
            System.out.println("DEBUG: " + reservations.size() + " réservations acceptées trouvées");
            
            // Pour chaque réservation, déterminer si elle peut être évaluée
            for (ReservationDetails reservation : reservations) {
                boolean dejaEvalue = feedbackDAO.feedbackExistsForReservation(reservation.getId());
                boolean peutEvaluer = reservation.isPeutEtreEvaluee() && !dejaEvalue;
                
                // Debug info
                System.out.println("DEBUG Réservation #" + reservation.getId() + 
                                 " - Date session: " + reservation.getDateSession() +
                                 " - Heure fin: " + reservation.getHeureFin() +
                                 " - peutEtreEvaluee: " + reservation.isPeutEtreEvaluee() +
                                 " - dejaEvalue: " + dejaEvalue +
                                 " - peutEvaluer: " + peutEvaluer);
                
                request.setAttribute("peutEvaluer_" + reservation.getId(), peutEvaluer);
                request.setAttribute("dejaEvalue_" + reservation.getId(), dejaEvalue);
                request.setAttribute("peutEtreEvaluee_" + reservation.getId(), reservation.isPeutEtreEvaluee());
                
                // Si déjà évalué, récupérer le feedback
                if (dejaEvalue) {
                    request.setAttribute("feedback_" + reservation.getId(), 
                        feedbackDAO.getFeedbackByReservationId(reservation.getId()));
                }
            }

            request.setAttribute("reservations", reservations);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de la récupération des réservations: " + e.getMessage());
        }

        request.getRequestDispatcher("/jsp/mesReservations.jsp").forward(request, response);
    }
}
package com.projet.jee.servlet;

import com.projet.jee.dao.FeedbackCandidatDAO;
import com.projet.jee.dao.ReservationDAO;
import com.projet.jee.models.FeedbackCandidat;
import com.projet.jee.models.Reservation;
import com.projet.jee.models.Reservation.Statut;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/evaluationFormateur")
public class EvaluationFormateurServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("candidatId") == null) {
            System.out.println("DEBUG: Redirection vers login - candidatId non trouvé");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long candidatId = (Long) session.getAttribute("candidatId");
        System.out.println("DEBUG: Candidat ID: " + candidatId);
        
        String reservationIdStr = request.getParameter("reservationId");
        String noteStr = request.getParameter("note");
        String commentaire = request.getParameter("commentaire");

        try {
            long reservationId = Long.parseLong(reservationIdStr);
            int note = Integer.parseInt(noteStr);

            // Validation de la note
            if (note < 1 || note > 5) {
                response.sendRedirect(request.getContextPath() + "/mesReservations?error=note_invalide");
                return;
            }

            ReservationDAO reservationDAO = new ReservationDAO();
            FeedbackCandidatDAO feedbackDAO = new FeedbackCandidatDAO();

            // Vérifier que la réservation appartient au candidat
            Reservation reservation = reservationDAO.getReservationById(reservationId);
            if (reservation == null) {
                System.out.println("DEBUG: Réservation non trouvée: " + reservationId);
                response.sendRedirect(request.getContextPath() + "/mesReservations?error=reservation_invalide");
                return;
            }
            
            if (reservation.getCandidatId() != candidatId) {
                System.out.println("DEBUG: Réservation n'appartient pas au candidat. Candidat réservation: " + 
                    reservation.getCandidatId() + ", Candidat session: " + candidatId);
                response.sendRedirect(request.getContextPath() + "/mesReservations?error=reservation_invalide");
                return;
            }

            // Vérifier que la réservation est acceptée
            if (reservation.getStatut() != Statut.ACCEPTEE) {
                System.out.println("DEBUG: Réservation non acceptée. Statut: " + reservation.getStatut());
                response.sendRedirect(request.getContextPath() + "/mesReservations?error=reservation_non_acceptee");
                return;
            }

            // CORRECTION IMPORTANTE : Utiliser le système avec le cron
            if (!reservationDAO.peutEtreEvaluee(reservationId)) {
                System.out.println("DEBUG: Évaluation non autorisée par le système cron. Réservation: " + reservationId);
                response.sendRedirect(request.getContextPath() + "/mesReservations?error=session_non_terminee");
                return;
            }

            // Vérifier que la réservation n'a pas déjà été évaluée
            if (feedbackDAO.feedbackExistsForReservation(reservationId)) {
                System.out.println("DEBUG: Réservation déjà évaluée: " + reservationId);
                response.sendRedirect(request.getContextPath() + "/mesReservations?error=deja_evalue");
                return;
            }

            // Créer et sauvegarder le feedback
            FeedbackCandidat feedback = new FeedbackCandidat();
            feedback.setNote(note);
            feedback.setCommentaire(commentaire);
            feedback.setDateFeedback(LocalDate.now());
            feedback.setReservationId(reservationId);

            if (feedbackDAO.ajouterFeedback(feedback)) {
                System.out.println("DEBUG: Feedback enregistré avec succès pour réservation: " + reservationId);
                response.sendRedirect(request.getContextPath() + "/mesReservations?success=evaluation_ajoutee");
            } else {
                System.out.println("DEBUG: Erreur lors de l'enregistrement du feedback");
                response.sendRedirect(request.getContextPath() + "/mesReservations?error=erreur_sauvegarde");
            }

        } catch (NumberFormatException e) {
            System.out.println("DEBUG: Format invalide - reservationId: " + reservationIdStr + ", note: " + noteStr);
            response.sendRedirect(request.getContextPath() + "/mesReservations?error=format_invalide");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG: Erreur serveur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/mesReservations?error=erreur_serveur");
        }
    }
}
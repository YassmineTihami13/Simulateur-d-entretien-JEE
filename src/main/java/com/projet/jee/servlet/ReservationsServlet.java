package com.projet.jee.servlet;

import com.projet.jee.dao.ReservationDAO;
import com.projet.jee.models.Formateur;
import com.projet.jee.models.ReservationDetails;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/reservations")
public class ReservationsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérification de la session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("formateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Formateur formateur = (Formateur) session.getAttribute("formateur");
        ReservationDAO dao = new ReservationDAO();

        try {
            // Récupérer les réservations avec tous les détails
            List<ReservationDetails> reservations = dao.getReservationsDetailsByFormateurId(formateur.getId());
            request.setAttribute("reservations", reservations);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de la récupération des réservations : " + e.getMessage());
        }

        // Forward vers la JSP
        request.getRequestDispatcher("/jsp/reservations_formateur.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
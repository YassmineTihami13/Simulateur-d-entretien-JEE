package com.projet.jee.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.projet.jee.dao.ReservationDAO;
import com.projet.jee.dao.ReservationadminDAO;
import com.projet.jee.models.Reservation;

@WebServlet("/admin/reservations")
public class ReservationadminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Vérifier d'abord si c'est une action de suppression
        if ("delete".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    Long id = Long.parseLong(idParam);
                    ReservationadminDAO dao = new ReservationadminDAO();
                    boolean deleted = dao.deleteReservation(id);

                    if (deleted) {
                        System.out.println("✅ Réservation supprimée, redirection...");
                    } else {
                        System.out.println("⚠️ Échec de la suppression");
                    }
                } catch (NumberFormatException e) {
                    System.err.println("❌ ID invalide: " + idParam);
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/reservations");
            return;
        }

        // Affichage normal de la liste
        ReservationadminDAO dao = new ReservationadminDAO();
        List<Reservation> reservations = dao.getAllReservations();

        request.setAttribute("reservations", reservations);
        request.getRequestDispatcher("/jsp/reservations.jsp").forward(request, response);
    }
}
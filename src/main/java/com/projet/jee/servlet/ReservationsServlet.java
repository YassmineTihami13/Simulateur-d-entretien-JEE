package com.projet.jee.servlet;

import com.projet.jee.dao.ReservationDAO;
import com.projet.jee.model.Formateur;
import com.projet.jee.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/reservations")
public class ReservationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("formateur") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        Formateur formateur = (Formateur) session.getAttribute("formateur");
        ReservationDAO dao = new ReservationDAO();
        try {
            List<Reservation> list = dao.getReservationsByFormateurId(formateur.getId());
            request.setAttribute("reservations", list);
            request.getRequestDispatcher("/jsp/reservations_formateur.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de la récupération des réservations : " + e.getMessage());
            request.getRequestDispatcher("/jsp/reservations_formateur.jsp").forward(request, response);
        }
    }
}

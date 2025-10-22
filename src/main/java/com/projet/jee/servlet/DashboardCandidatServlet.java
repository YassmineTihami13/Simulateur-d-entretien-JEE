package com.projet.jee.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.projet.jee.dao.CandidatDashboardDAO;
import com.projet.jee.models.Formateur;
import com.projet.jee.models.Score;
import com.projet.jee.models.Reservation;


@WebServlet("/candidat/dashboard")
public class DashboardCandidatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        // CORRECTION : Utiliser le même nom d'attribut que dans la JSP
        Long userId = (Long) session.getAttribute("userId"); // ou "userID" selon votre login
        String userRole = (String) session.getAttribute("userRole");

        // Vérifier si l'utilisateur est un candidat connecté
        if (userId == null || !"CANDIDAT".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        CandidatDashboardDAO dao = new CandidatDashboardDAO();

        // CORRECTION : Passer l'ID utilisateur (qui est le même que candidat_id)
        int totalReservations = dao.getNombreReservations(userId);
        Reservation prochaineSeance = dao.getProchaineSeance(userId);
        List<Formateur> formateurs = dao.getFormateursDuDomaine(userId);
        Score score = dao.getScoreCandidat(userId);

        request.setAttribute("totalReservations", totalReservations);
        request.setAttribute("prochaineSeance", prochaineSeance);
        request.setAttribute("formateurs", formateurs);
        request.setAttribute("score", score);

        request.getRequestDispatcher("/jsp/dashboardCandidat.jsp").forward(request, response);
    }
}
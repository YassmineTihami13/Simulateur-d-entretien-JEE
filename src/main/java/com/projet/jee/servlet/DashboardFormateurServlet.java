package com.projet.jee.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

import com.projet.jee.models.Formateur;
import com.projet.jee.dao.DashboardFormateurDAO;

@WebServlet("/dashboardFormateur")
public class DashboardFormateurServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Vérifier si le formateur est connecté
        if (session == null || session.getAttribute("formateur") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        Formateur formateur = (Formateur) session.getAttribute("formateur");
        DashboardFormateurDAO dao = new DashboardFormateurDAO();

        // ✅ Utiliser le nom de l'enum pour DAO
        String specialite = formateur.getSpecialiteEnumName(); 

        // Récupérer les stats
        int nbCandidats = dao.getNombreCandidatsParSpecialite(specialite);
        int nbReservations = dao.getTotalReservations(formateur.getId());
        int nbEntretiensPasses = dao.getEntretiensPasses(formateur.getId());
        int[] statsReservations = dao.getStatutReservations(formateur.getId());
        int confirmees = statsReservations[0];
        int annulees = statsReservations[1];

        // Passer les infos au JSP
        request.setAttribute("nbCandidats", nbCandidats);
        request.setAttribute("nbReservations", nbReservations);
        request.setAttribute("nbEntretiensPasses", nbEntretiensPasses);
        request.setAttribute("confirmees", confirmees);
        request.setAttribute("annulees", annulees);
        request.setAttribute("formateur", formateur);

        // Forward vers le JSP
        request.getRequestDispatcher("/jsp/dashboard_formateur.jsp").forward(request, response);
    }
}

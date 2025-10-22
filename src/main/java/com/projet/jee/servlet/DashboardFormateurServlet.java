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

        // Vérifier si la session existe
        if (session == null || session.getAttribute("formateur") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        Formateur formateur = (Formateur) session.getAttribute("formateur");
        DashboardFormateurDAO dao = new DashboardFormateurDAO();

        // Récupérer la spécialité du formateur (ENUM: "INFORMATIQUE", "MECATRONIQUE", etc.)
        String specialiteFormateur = formateur.getSpecialite().name();

        System.out.println("=== DEBUG DASHBOARD ===");
        System.out.println("Formateur: " + formateur.getNom() + " " + formateur.getPrenom());
        System.out.println("Spécialité (ENUM): " + specialiteFormateur);

        // Compter les candidats du même domaine
        // Récupérer le nombre de candidats dans le domaine du formateur
        int nbCandidats = dao.getNombreCandidatsParDomaine(formateur.getSpecialite().name());

        request.setAttribute("nbCandidats", nbCandidats);

        // Récupérer les autres statistiques
        int nbReservations = dao.getTotalReservations(formateur.getId());
        int nbEntretiensPasses = dao.getEntretiensPasses(formateur.getId());
        int[] stats = dao.getStatutReservations(formateur.getId());

        // Passer les attributs au JSP
        request.setAttribute("nbCandidats", nbCandidats);
        request.setAttribute("nbReservations", nbReservations);
        request.setAttribute("nbEntretiensPasses", nbEntretiensPasses);
        request.setAttribute("confirmees", stats[0]);
        request.setAttribute("annulees", stats[1]);
        request.setAttribute("nomFormateur", formateur.getNom());
        request.setAttribute("prenomFormateur", formateur.getPrenom());
        request.setAttribute("specialiteFormateur", formateur.getSpecialiteDisplayName());

        // Forward vers le dashboard
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/dashboard_formateur.jsp");
        dispatcher.forward(request, response);
    }
}
package com.projet.jee.servlet;

import com.projet.jee.dao.ProfileCandidatDAO;
import com.projet.jee.models.Candidat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/CandidatProfileServlet")
public class CandidatProfileServlet extends HttpServlet {
    private ProfileCandidatDAO profileCandidatDAO;

    @Override
    public void init() throws ServletException {
        profileCandidatDAO = new ProfileCandidatDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Vérifier si l'utilisateur est connecté
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        // Vérifier le rôle
        String role = (String) session.getAttribute("userRole");
        if (!"CANDIDAT".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/jsp/unauthorized.jsp");
            return;
        }

        try {
            Long userId = (Long) session.getAttribute("userId");

            // Récupérer les informations complètes du candidat
            Candidat candidat = profileCandidatDAO.getCandidatById(userId);

            if (candidat == null) {
                request.setAttribute("errorMessage", "Impossible de récupérer vos informations");
                request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
                return;
            }

            // Debug - Afficher les informations récupérées
            System.out.println("Candidat récupéré: " + candidat);
            System.out.println("Nom: " + candidat.getNom());
            System.out.println("Prénom: " + candidat.getPrenom());
            System.out.println("Email: " + candidat.getEmail());
            System.out.println("Domaine: " + candidat.getDomaineProfessionnelDisplayName());
            System.out.println("CV: " + candidat.getCv());

            // Mettre à jour les attributs de session et request
            session.setAttribute("candidat", candidat);
            session.setAttribute("userNom", candidat.getNom());
            session.setAttribute("userPrenom", candidat.getPrenom());
            session.setAttribute("userEmail", candidat.getEmail());

            request.setAttribute("candidat", candidat);

            // Rediriger vers la JSP
            request.getRequestDispatcher("/jsp/profileCandidat.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Erreur détaillée: " + e.getMessage());
            request.setAttribute("errorMessage", "Erreur lors du chargement du profil: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        if (profileCandidatDAO != null) {
            profileCandidatDAO.closeConnection();
        }
    }
}
// FormateurDetailsServlet.java
package com.projet.jee.servlet;

import com.projet.jee.dao.FormateurDAO;
import com.projet.jee.models.Formateur;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/formateur-details")
public class FormateurDetailsServlet extends HttpServlet {

    private FormateurDAO formateurDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        formateurDAO = new FormateurDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            long formateurId = Long.parseLong(request.getParameter("id"));
            Formateur formateur = formateurDAO.getFormateurById(formateurId);
            
            if (formateur != null) {
                // Créer un DTO pour la réponse JSON
                FormateurDetailsDTO detailsDTO = new FormateurDetailsDTO(formateur);
                response.getWriter().write(gson.toJson(detailsDTO));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Formateur non trouvé\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"ID de formateur invalide\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Erreur serveur: " + e.getMessage() + "\"}");
        }
    }

    // DTO pour la réponse JSON
    public static class FormateurDetailsDTO {
        private long id;
        private String nom;
        private String prenom;
        private String email;
        private String specialiteDisplayName;
        private int anneeExperience;
        private double tarifHoraire;
        private String description;
        private String[] certifications;
        private boolean hasCertifications;

        public FormateurDetailsDTO(Formateur formateur) {
            this.id = formateur.getId();
            this.nom = formateur.getNom();
            this.prenom = formateur.getPrenom();
            this.email = formateur.getEmail();
            this.specialiteDisplayName = formateur.getSpecialiteDisplayName();
            this.anneeExperience = formateur.getAnneeExperience();
            this.tarifHoraire = formateur.getTarifHoraire();
            this.description = formateur.getDescription();
            this.certifications = formateur.getCertificationFiles();
            this.hasCertifications = formateur.hasCertifications();
        }

        // Getters (nécessaires pour la sérialisation JSON)
        public long getId() { return id; }
        public String getNom() { return nom; }
        public String getPrenom() { return prenom; }
        public String getEmail() { return email; }
        public String getSpecialiteDisplayName() { return specialiteDisplayName; }
        public int getAnneeExperience() { return anneeExperience; }
        public double getTarifHoraire() { return tarifHoraire; }
        public String getDescription() { return description; }
        public String[] getCertifications() { return certifications; }
        public boolean isHasCertifications() { return hasCertifications; }
    }
}
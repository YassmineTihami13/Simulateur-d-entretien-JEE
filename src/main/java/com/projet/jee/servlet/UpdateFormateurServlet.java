package com.projet.jee.servlet;

import com.projet.jee.dao.FormateurDAO;
import com.projet.jee.models.Formateur;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/update-formateur")
public class UpdateFormateurServlet extends HttpServlet {

    private FormateurDAO formateurDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        formateurDAO = new FormateurDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        updateFormateur(request, response);
    }

    private void updateFormateur(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Validation des paramètres obligatoires
            long id = Long.parseLong(request.getParameter("id"));
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String specialite = request.getParameter("specialite");
            int anneeExperience = Integer.parseInt(request.getParameter("anneeExperience"));
            double tarifHoraire = Double.parseDouble(request.getParameter("tarifHoraire"));

            // Paramètres optionnels
            String description = request.getParameter("description");
            String certifications = request.getParameter("certifications"); // Peut être null

            // Validation basique
            if (nom == null || nom.trim().isEmpty() ||
                    prenom == null || prenom.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    specialite == null || specialite.trim().isEmpty()) {

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"Tous les champs obligatoires doivent être remplis\"}");
                return;
            }

            // Récupérer le formateur existant
            Formateur formateur = formateurDAO.getFormateurById(id);
            if (formateur != null) {
                // Mettre à jour les champs
                formateur.setNom(nom.trim());
                formateur.setPrenom(prenom.trim());
                formateur.setEmail(email.trim());
                formateur.setSpecialite(specialite); // Utilise l'enum
                formateur.setAnneeExperience(anneeExperience);
                formateur.setTarifHoraire(tarifHoraire);
                formateur.setDescription(description != null ? description.trim() : null);

                // Garder les certifications existantes si non fournies
                if (certifications != null && !certifications.trim().isEmpty()) {
                    formateur.setCertifications(certifications.trim());
                }

                boolean success = formateurDAO.updateFormateur(formateur);

                if (success) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"success\": true, \"message\": \"Formateur modifié avec succès\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"success\": false, \"error\": \"Erreur lors de la modification en base de données\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"success\": false, \"error\": \"Formateur non trouvé\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"error\": \"Format de nombre invalide\"}");
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"error\": \"Spécialité invalide: \" + e.getMessage()}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"error\": \"Erreur serveur: \" + e.getMessage()}");
        }
    }
}
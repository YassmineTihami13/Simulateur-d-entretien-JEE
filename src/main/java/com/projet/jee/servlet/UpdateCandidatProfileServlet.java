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
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/UpdateCandidatProfileServlet")
public class UpdateCandidatProfileServlet extends HttpServlet {
    private ProfileCandidatDAO profileCandidatDAO;

    @Override
    public void init() throws ServletException {
        profileCandidatDAO = new ProfileCandidatDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Vérifier si l'utilisateur est connecté
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        try {
            Long userId = (Long) session.getAttribute("userId");

            // Récupérer les données du formulaire
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String domaineProfessionnel = request.getParameter("domaineProfessionnel");

            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validation des champs obligatoires
            if (nom == null || nom.trim().isEmpty() ||
                    prenom == null || prenom.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    domaineProfessionnel == null || domaineProfessionnel.trim().isEmpty()) {

                session.setAttribute("errorMessage", "Tous les champs obligatoires doivent être remplis");
                response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                return;
            }

            // Vérifier si l'email existe déjà pour un autre utilisateur
            if (profileCandidatDAO.isEmailExists(email.trim().toLowerCase(), userId)) {
                session.setAttribute("errorMessage", "Cet email est déjà utilisé par un autre compte");
                response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                return;
            }

            // Récupérer le candidat actuel depuis la base de données
            Candidat candidat = profileCandidatDAO.getCandidatById(userId);

            if (candidat == null) {
                session.setAttribute("errorMessage", "Candidat introuvable");
                response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                return;
            }

            // Mettre à jour les informations de base
            candidat.setNom(nom.trim());
            candidat.setPrenom(prenom.trim());
            candidat.setEmail(email.trim().toLowerCase());
            candidat.setDomaineProfessionnel(domaineProfessionnel);

            // Gestion du changement de mot de passe
            boolean updatePassword = false;
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                // Vérifier que le mot de passe actuel est fourni
                if (currentPassword == null || currentPassword.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Veuillez entrer votre mot de passe actuel");
                    response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                    return;
                }

                // Vérifier que le mot de passe actuel est correct
                String hashedCurrentPassword = hashPassword(currentPassword);
                if (!hashedCurrentPassword.equals(candidat.getMotDePasse())) {
                    session.setAttribute("errorMessage", "Le mot de passe actuel est incorrect");
                    response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                    return;
                }

                // Vérifier que les mots de passe correspondent
                if (!newPassword.equals(confirmPassword)) {
                    session.setAttribute("errorMessage", "Les nouveaux mots de passe ne correspondent pas");
                    response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                    return;
                }

                // Vérifier la longueur du mot de passe
                if (newPassword.length() < 6) {
                    session.setAttribute("errorMessage", "Le mot de passe doit contenir au moins 6 caractères");
                    response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                    return;
                }

                // Si tout est valide, mettre à jour le mot de passe
                String hashedNewPassword = hashPassword(newPassword);
                candidat.setMotDePasse(hashedNewPassword);
                updatePassword = true;
            }

            // Mettre à jour dans la base de données
            boolean updated = profileCandidatDAO.updateCandidat(candidat, updatePassword);

            if (updated) {
                // Recharger les données complètes du candidat
                Candidat updatedCandidat = profileCandidatDAO.getCandidatById(userId);

                // Mettre à jour la session avec les nouvelles données
                session.setAttribute("userNom", updatedCandidat.getNom());
                session.setAttribute("userPrenom", updatedCandidat.getPrenom());
                session.setAttribute("userEmail", updatedCandidat.getEmail());
                session.setAttribute("candidat", updatedCandidat);

                session.setAttribute("successMessage", "Profil mis à jour avec succès !");
            } else {
                session.setAttribute("errorMessage", "Erreur lors de la mise à jour du profil");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
    }

    // Méthode pour hasher le mot de passe (SHA-256)
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Erreur lors du hashage du mot de passe", e);
        }
    }

    @Override
    public void destroy() {
        if (profileCandidatDAO != null) {
            profileCandidatDAO.closeConnection();
        }
    }
}
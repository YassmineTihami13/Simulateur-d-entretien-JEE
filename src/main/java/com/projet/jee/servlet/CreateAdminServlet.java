package com.projet.jee.servlet;

import com.projet.jee.model.Administrateur;
import com.projet.jee.service.AdminCreator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/createAdminInit")
public class CreateAdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Vérification des champs vides
        if (nom == null || prenom == null || email == null || password == null
                || nom.isEmpty() || prenom.isEmpty() || email.isEmpty() || password.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jsp/createAdmin.jsp?error=empty");
            return;
        }

        try {
            // Créer l'objet Administrateur
            Administrateur admin = new Administrateur(0, nom, prenom, email, password);

            // 🔹 Appel direct à AdminCreator pour ajouter l'admin
            AdminCreator.ajouterAdmin(admin);

            // Redirection vers la page JSP avec succès
            response.sendRedirect(request.getContextPath() + "/jsp/createAdmin.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            // Redirection avec erreur
            response.sendRedirect(request.getContextPath() + "/jsp/createAdmin.jsp?error=db");
        }
    }

    // GET : redirige vers le formulaire de création
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/jsp/createAdmin.jsp");
    }
}

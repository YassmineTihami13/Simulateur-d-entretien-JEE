package com.projet.jee.servlet;

import com.projet.jee.dao.FormateurDAO;
import com.projet.jee.models.Formateur;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/formateurs")
public class FormateurManagementServlet extends HttpServlet {

    private FormateurDAO formateurDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        formateurDAO = new FormateurDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Formateur> formateurs = formateurDAO.getAllFormateurs();
            request.setAttribute("formateurs", formateurs);
            request.getRequestDispatcher("/jsp/adminFormateurs.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des formateurs: " + e.getMessage());
            request.getRequestDispatcher("/jsp/adminFormateurs.jsp").forward(request, response);
        }
    }




}
package com.projet.jee.servlet;

import com.projet.jee.dao.ConnectionBD;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/testdb")
public class TestDBServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try (Connection con = ConnectionBD.getConnection()) {
            out.println("<h1>Connexion à la DB réussie kkl ! 🎉</h1>");
        } catch (SQLException e) {
            out.println("<h1>Erreur de connexion : " + e.getMessage() + "</h1>");
        }
    }
}
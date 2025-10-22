package com.projet.jee.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConnectionBD {

    private static Properties props = new Properties();

    static {
        try (InputStream in = ConnectionBD.class.getClassLoader().getResourceAsStream("config.properties")) {
            props.load(in);
            // Chargement explicite du driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors du chargement de la configuration", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = props.getProperty("db.url");
        String user = props.getProperty("db.user");
        String password = props.getProperty("db.password");
        return DriverManager.getConnection(url, user, password);
    }
}
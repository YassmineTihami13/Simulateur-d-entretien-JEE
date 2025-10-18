package com.projet.jee.service;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import java.util.Random;

public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_FROM = "tihami.yassmine@etu.uae.ac.ma";
    private static final String EMAIL_PASSWORD = "jbbvokuenrhwrafe";

    public static String generateVerificationCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }


    public static boolean sendVerificationEmail(String toEmail, String userName, String verificationCode) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM, "Simulateur d'Entretien"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Code de vérification - Inscription Formateur");

            String htmlContent = buildEmailTemplate(userName, verificationCode);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    private static String buildEmailTemplate(String userName, String code) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; background-color: #f5f0ff; margin: 0; padding: 20px; }" +
                ".container { max-width: 600px; margin: 0 auto; background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #667eea 0%, #b39ddb 100%); padding: 40px 20px; text-align: center; }" +
                ".header h1 { color: white; margin: 0; font-size: 28px; }" +
                ".content { padding: 40px 30px; }" +
                ".code-box { background: linear-gradient(135deg, #f5f0ff 0%, #fff9f0 100%); border-left: 4px solid #b39ddb; padding: 20px; margin: 30px 0; border-radius: 8px; text-align: center; }" +
                ".code { font-size: 36px; font-weight: bold; color: #667eea; letter-spacing: 8px; margin: 10px 0; }" +
                ".info { color: #666; line-height: 1.6; margin: 20px 0; }" +
                ".warning { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; border-radius: 8px; color: #856404; }" +
                ".footer { background: #f8f9fa; padding: 20px; text-align: center; color: #999; font-size: 14px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🎯 Vérification de votre compte</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<p class='info'>Bonjour <strong>" + userName + "</strong>,</p>" +
                "<p class='info'>Merci de vous être inscrit sur notre plateforme ! Pour finaliser votre inscription, veuillez utiliser le code de vérification ci-dessous :</p>" +
                "<div class='code-box'>" +
                "<p style='margin: 0; color: #666; font-size: 14px;'>Votre code de vérification</p>" +
                "<div class='code'>" + code + "</div>" +
                "<p style='margin: 0; color: #999; font-size: 13px;'>Ce code est valide pendant 15 minutes</p>" +
                "</div>" +
                "<p class='info'>Entrez ce code sur la page de vérification pour activer votre compte formateur.</p>" +
                "<div class='warning'>" +
                "<strong>⚠️ Important :</strong> Si vous n'avez pas demandé cette inscription, veuillez ignorer cet email." +
                "</div>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>© 2025 Simulateur d'Entretien - Tous droits réservés</p>" +
                "<p>Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
}
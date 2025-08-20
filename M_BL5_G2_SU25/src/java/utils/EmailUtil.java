/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author tayho
 */
public class EmailUtil {

    // ==== YOUR ACCOUNT (must match the Google account that created the app password) ====
    private static final String FROM_EMAIL = "chungdthe150207@fpt.edu.vn";
    private static final String APP_PASSWORD = "pqdcvhjupaiqflum"; // 16 chars, NO SPACES
    private static final String FROM_NAME = "HappySale";        // shown to recipients

    // Turn off after you confirm it works (reduces log noise)
    private static final boolean DEBUG = true;

    /**
     * Send a plain-text email using Gmail SMTP. Tries STARTTLS(587) first; if
     * that fails (e.g., firewall), falls back to SSL(465).
     *
     * @return true if sent successfully, false otherwise (details printed to
     * server log when DEBUG=true)
     */
    public static boolean sendMail(String toEmail, String subject, String body) {
        // Try STARTTLS 587 first
        if (trySend(toEmail, subject, body, false)) {
            return true;
        }
        // Fallback to SSL 465
        return trySend(toEmail, subject, body, true);
    }

    /**
     * Fire-and-forget async sender (non-blocking). Useful from servlets.
     */
    public static void sendMailAsync(String toEmail, String subject, String body) {
        Thread t = new Thread(() -> sendMail(toEmail, subject, body));
        t.setDaemon(true);
        t.start();
    }

    // -------------------- internals --------------------
    private static boolean trySend(String toEmail, String subject, String body, boolean ssl) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            if (ssl) {
                props.put("mail.smtp.port", "465");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.ssl.enable", "true");
            } else {
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
            }

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
                }
            });
            session.setDebug(DEBUG);

            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, StandardCharsets.UTF_8.name()));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            msg.setSubject(subject, StandardCharsets.UTF_8.name());
            msg.setText(body, StandardCharsets.UTF_8.name());
            msg.setSentDate(new Date());

            Transport.send(msg);
            return true;

        } catch (Exception ex) {
            if (DEBUG) {
                ex.printStackTrace();
            }
            return false;
        }
    }

    // Optional quick test
    public static void main(String[] args) {
        boolean ok = sendMail(
                "chungdthe150207@fpt.edu.vn",
                "SMTP test",
                "This is a test email from HappySale."
        );
        System.out.println("MAIL SENT? " + ok);
    }
}

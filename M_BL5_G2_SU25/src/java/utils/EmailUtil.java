/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.util.Date;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author tayho
 */
public class EmailUtil {

//    public static final String FROM = "chungdthe150207@fpt.edu.vn";   
//    static final String APP_PASSWORD = "pqdcvhjupaiqflum";            
    static final String FROM_NAME = "HappySale";

    public static final String FROM = "he180616nguyentuandung@gmail.com";
    static final String APP_PASSWORD = "qrll vkzp xfxl ldrv";

    /**
     * Gửi email HTML đơn giản qua Gmail SMTP (STARTTLS 587).
     *
     * @param to địa chỉ người nhận
     * @param tieuDe tiêu đề
     * @param noiDung nội dung (HTML hoặc text)
     * @return true nếu gửi thành công, ngược lại false
     */
    public static boolean sendMail(String to, String tieuDe, String noiDung) {
        long startTime = System.currentTimeMillis();
        // Properties : khai báo thuộc tính
        Properties pros = new Properties();
        pros.put("mail.smtp.host", "smtp.gmail.com"); // SMTP HOST
        pros.put("mail.smtp.port", "587"); // TLS 587 SSL 465
        pros.put("mail.smtp.auth", "true");
        pros.put("mail.smtp.starttls.enable", "true");

        // create Authenticator
        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM, APP_PASSWORD);
            }
        };

        // Phiên làm việc
        Session session = Session.getInstance(pros, auth);
        System.out.println("Khởi tạo Session: " + (System.currentTimeMillis() - startTime) + "ms");
        // Gửi email

        // tạo một tin nhắn
        MimeMessage msg = new MimeMessage(session);

        try {
            // kiểu nội dung
            msg.addHeader("Conten-type", "text/html; charset=UTF-8");
            // người gửi
            msg.setFrom(FROM);
            // người  nhận
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            // Tiêu đề email
            msg.setSubject(tieuDe, "UTF-8");
            //Quy định ngày gửi
            msg.setSentDate(new Date());
            // Quy định email phản hồi
            msg.setReplyTo(null); 
            //Nội dung
            msg.setContent(noiDung, "text/HTML; charset=UTF-8");
            // Gửi email
            long sendStart = System.currentTimeMillis();
            Transport.send(msg);
            System.out.println("Gửi email: " + (System.currentTimeMillis() - sendStart) + "ms");
            System.out.println("Tổng thời gian: " + (System.currentTimeMillis() - startTime) + "ms");
            return true;
        } catch (MessagingException ex) {
            System.out.println("Gửi không Thành Công");
            System.out.println(ex.getMessage());
            return false;
        }
    }

    /**
     * Gửi email bất đồng bộ (không chặn luồng hiện tại).
     */
    public static void sendMailAsync(String to, String tieuDe, String noiDung) {
        if (to == null || to.trim().isEmpty()) {

        }
        Thread thread = new Thread(() -> {
            try {
                sendMail(to, tieuDe, noiDung);
            } catch (Exception e) {
                // Đăng ký log hoặc xử lý lỗi gửi mail tại đây
                System.err.println("Lỗi khi gửi mail: " + e.getMessage());
                e.printStackTrace();
            }
        });

        // Nếu bạn không muốn thread này ngăn JVM tắt, đặt nó thành daemon
        thread.setDaemon(true);

        // Bắt đầu thực thi bất đồng bộ
        thread.start();
    }

    // Test nhanh (chạy độc lập)
    public static void main(String[] args) {
    //            sendMailAsync("chungdthe150207@fpt.edu.vn", "Test async " + System.currentTimeMillis(), "Chào 1");
        // Đóng thread pool sau khi thử nghiệm
     //   shutdown();
    }
}

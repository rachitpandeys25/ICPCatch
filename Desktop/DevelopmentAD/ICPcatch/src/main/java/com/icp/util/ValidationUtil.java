package com.icp.util;

import jakarta.servlet.http.Part;

public class ValidationUtil {

    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^[0-9]{10}$");
    }

    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static boolean isValidImageExtension(Part filePart) {
        if (filePart == null) return false;
        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) return false;
        String ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
        return ext.equals("jpg") || ext.equals("jpeg") 
            || ext.equals("png") || ext.equals("gif");
    }
}
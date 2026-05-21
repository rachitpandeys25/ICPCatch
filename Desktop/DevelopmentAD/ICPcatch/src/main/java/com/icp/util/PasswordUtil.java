package com.icp.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    private static final int COST = 10;

    public static String hashPassword(String plainPassword) {

        String salt = BCrypt.gensalt(COST);

        return BCrypt.hashpw(plainPassword, salt);
    }

  
    public static boolean checkPassword(String plainPassword,
            String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
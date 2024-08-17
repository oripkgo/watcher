package com.watcher.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.AlgorithmParameters;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.Base64;
import java.util.Objects;

@Component
public class AESUtil {

    @Value("${enc.aes.key}")
    private String secretKeyFromConfig;

    // static 변수에 AES 키 저장
    private static String secretKey;

    // 이 메서드는 @Value로 secretKey를 읽어온 후 설정하는 초기화 단계입니다.
    @PostConstruct
    public void init() {
        secretKey = this.secretKeyFromConfig;

        if (secretKey == null || secretKey.isEmpty()) {
            throw new RuntimeException("AES secret key is not set. Please check your configuration.");
        }
    }

    public static String encrypt(String strToEncrypt) {
        return encrypt(strToEncrypt, null);
    }

    public static String encrypt(String strToEncrypt, String strToSalt) {
        try {
            byte[] salt = stringTo16Bytes(strToSalt);
            SecretKeySpec secretKeySpec = getSecretKey(salt);
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);
            AlgorithmParameters params = cipher.getParameters();
            byte[] iv = params.getParameterSpec(IvParameterSpec.class).getIV();
            byte[] encryptedTextBytes = cipher.doFinal(strToEncrypt.getBytes("UTF-8"));

            byte[] result = new byte[salt.length + iv.length + encryptedTextBytes.length];
            System.arraycopy(salt, 0, result, 0, salt.length);
            System.arraycopy(iv, 0, result, salt.length, iv.length);
            System.arraycopy(encryptedTextBytes, 0, result, salt.length + iv.length, encryptedTextBytes.length);

            return Base64.getEncoder().encodeToString(result);
        } catch (Exception e) {
            throw new RuntimeException("Error while encrypting: " + e.toString());
        }
    }

    public static String decrypt(String strToDecrypt) {
        try {
            byte[] decodedBytes = Base64.getDecoder().decode(strToDecrypt);

            byte[] salt = new byte[16];
            System.arraycopy(decodedBytes, 0, salt, 0, 16);

            byte[] iv = new byte[16];
            System.arraycopy(decodedBytes, 16, iv, 0, 16);

            byte[] encryptedTextBytes = new byte[decodedBytes.length - 32];
            System.arraycopy(decodedBytes, 32, encryptedTextBytes, 0, encryptedTextBytes.length);

            SecretKeySpec secretKeySpec = getSecretKey(salt);
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, new IvParameterSpec(iv));

            byte[] decryptedTextBytes = cipher.doFinal(encryptedTextBytes);

            return new String(decryptedTextBytes);
        } catch (Exception e) {
            throw new RuntimeException("Error while decrypting: " + e.toString());
        }
    }

    private static byte[] stringTo16Bytes(String input) {
        try {
            byte[] inputByte = generateSaltToByte();

            if (Objects.nonNull(input)) {
                inputByte = input.getBytes();
            }

            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(inputByte);
            byte[] result = new byte[16];
            System.arraycopy(hash, 0, result, 0, 16);
            return result;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error generating hash: " + e.toString());
        }
    }

    private static SecretKeySpec getSecretKey(byte[] salt) throws Exception {
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        KeySpec spec = new PBEKeySpec(secretKey.toCharArray(), salt, 65536, 256);
        SecretKey tmp = factory.generateSecret(spec);
        return new SecretKeySpec(tmp.getEncoded(), "AES");
    }

    private static byte[] generateSaltToByte() {
        byte[] salt = new byte[16];
        SecureRandom secureRandom = new SecureRandom();
        secureRandom.nextBytes(salt);
        return salt;
    }

    private static String bytesToString(byte[] bytes) {
        return Base64.getEncoder().encodeToString(bytes);
    }

    private static byte[] stringToBytes(String str) {
        return Base64.getDecoder().decode(str);
    }

}
package com.watcher.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;

@Component
public class JwtTokenUtil {

    private static String apikey;

    @Value("${jwt.secret}")
    public void setApikey(String secretKey) {
        JwtTokenUtil.apikey = secretKey;
    }

    private static final String issuer = "watcher";
    private static final String subject = "token";
    private static final long DEFAULT_EXPIRATION_MILLIS = 3600000; // 1 hour

    /**
     * 토큰 생성 (동적 유효기간 지원)
     * @param id
     * @param expirationMillis
     * @return
     */
    public static String createJWT(String id, long expirationMillis) {
        Date now = new Date();
        Date expiration = new Date(now.getTime() + expirationMillis);

        String token = Jwts.builder()
            .setId(id)
            .setSubject(subject)
            .setIssuedAt(now)
            .setExpiration(expiration)
            .signWith(getSignKey())
            .compact();

        return token;
    }

    /**
     * 토큰 생성 (기본 1시간)
     * @param id
     * @return
     */
    public static String createJWT(String id) {
        return createJWT(id, DEFAULT_EXPIRATION_MILLIS);
    }

    /**
     * 토큰 파싱
     * @param jwt
     * @return
     */
    static public Jws<Claims> parseJwt(String jwt) {
        Jws<Claims> claims = Jwts.parserBuilder()
            .setSigningKey(getSignKey())
            .build()
            .parseClaimsJws(jwt);

        return claims;
    }

    /**
     * 토큰 검증
     * @param token
     * @return boolean
     */
    public static boolean verifyToken(String token) {
        try {
            Jws<Claims> claimsJws = parseJwt(token);

            Claims body = claimsJws.getBody();

            // Check if the token has expired
            Date now = new Date();
            if (now.after(body.getExpiration())) {
                return false;
            }

            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // JWT의 exp(만료 시간)를 연장하기 (기본 1시간 기준 또는 필요에 따라 오버로딩 활용)
    public static String extendExpirationTime(String token) throws Exception {
        String id = "";
        try {
            Jws<Claims> claimsJws = parseJwt(token);
            Claims claims = claimsJws.getBody();
            id = claims.getId();
        } catch (Exception e) {
            throw new SignatureException("api 토큰검증 실패");
        }

        // JWT 재생성 (기본 1시간)
        return createJWT(id, DEFAULT_EXPIRATION_MILLIS);
    }

    static private Key getSignKey() {
        return Keys.hmacShaKeyFor(apikey.getBytes(StandardCharsets.UTF_8));
    }

    static public String getId(String token) {
        if (token == null || token.isEmpty()) {
            return "";
        }
        Jws<Claims> claimsJws = parseJwt(token);
        Claims claims = claimsJws.getBody();
        return claims.getId();
    }
}
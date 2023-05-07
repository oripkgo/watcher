package com.watcher.util;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;

public class JwtTokenUtil {

    private static final String apikey = "8adfc822-6fc2-3506-6f60-2a724fd2126a";
    private static final String issuer = "watcher";
    private static final String subject = "token";
    private static final long expirationMillis = 3600000; // 1 hour

    /**
     * 토큰생성
     * @param id
     * @return
     */
    static public String createJWT(String id) {

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

    //JWT의 exp(만료 시간)를 연장하기
    public static String extendExpirationTime(String token) throws Exception{
        String id = "";
        try{
            Jws<Claims> claimsJws = parseJwt(token);
            Claims claims = claimsJws.getBody();
            id = claims.getId();
        }catch (Exception e){
            throw new SignatureException("api 토큰검증 실패");
        }

        // JWT 재생성
        return createJWT(id);
    }

    static private Key getSignKey(){
        return Keys.hmacShaKeyFor(apikey.getBytes(StandardCharsets.UTF_8));
    }

    static public String getId(String token){
        Jws<Claims> claimsJws = parseJwt(token);
        Claims claims = claimsJws.getBody();
        return  claims.getId();
    }
}

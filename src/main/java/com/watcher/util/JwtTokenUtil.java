package com.watcher.util;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;

public class JwtTokenUtil {

    static private String apikey = "8adfc822-6fc2-3506-6f60-2a724fd2126a";
    static private String issuer = "watcher";
    static private String subject = "token";
    static private long ttlMills = 1000;

    /**
     * 토큰생성
     * @param id
     * @return
     */
    static public String createJWT(String id) {

        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);

        // 표준 클레임 셋팅
        JwtBuilder builder = Jwts.builder()
                .setId(id)
                .setIssuedAt(now)
                .setSubject(subject)
                .setIssuer(issuer)
                .signWith(getSignKey());

        // 토큰 만료 시간 셋팅
        if(ttlMills >= 0){
            long expMillis = nowMillis + ttlMills;
            Date exp = new Date(expMillis);
            builder.setExpiration(exp);
        }

        // 토큰 생성
        return builder.compact();
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

    static private Key getSignKey(){
        return Keys.hmacShaKeyFor(apikey.getBytes(StandardCharsets.UTF_8));
    }
}

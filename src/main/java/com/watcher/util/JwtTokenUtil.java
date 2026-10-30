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
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class JwtTokenUtil {

  private static String apikey;

  @Value("${jwt.secret}")
  public void setApikey(String secretKey) {
    JwtTokenUtil.apikey = secretKey;
  }

  private static final String ISSUER = "watcher";
  private static final String SUBJECT = "token";
  private static final long DEFAULT_EXPIRATION_MILLIS = 3600000; // 1 hour

  /**
   * 토큰 생성 (동적 유효기간 및 JSON 데이터(Claims) 지원 - 메인 생성 메서드)
   *
   * @param id
   * @param expirationMillis
   * @param claimsMap        토큰에 담고 싶은 커스텀 데이터 (JSON 형태)
   * @return String JWT 토큰
   */
  public static String createJWT(String id, long expirationMillis, Map<String, Object> claimsMap) {
    Date now = new Date();
    Date expiration = new Date(now.getTime() + expirationMillis);

    JwtBuilder builder = Jwts.builder()
        .setIssuer(ISSUER) // 설정에만 선언되어 있던 issuer 적용
        .setId(id)
        .setSubject(SUBJECT)
        .setIssuedAt(now)
        .setExpiration(expiration)
        .signWith(getSignKey());

    if (claimsMap != null && !claimsMap.isEmpty()) {
      builder.addClaims(claimsMap);
    }

    return builder.compact();
  }

  /**
   * 토큰 생성 (동적 유효기간 지원)
   */
  public static String createJWT(String id, long expirationMillis) {
    return createJWT(id, expirationMillis, null);
  }

  /**
   * 토큰 생성 (기본 1시간)
   */
  public static String createJWT(String id) {
    return createJWT(id, DEFAULT_EXPIRATION_MILLIS, null);
  }

  /**
   * 토큰 파싱
   */
  public static Jws<Claims> parseJwt(String jwt) {
    return Jwts.parserBuilder()
        .setSigningKey(getSignKey())
        .build()
        .parseClaimsJws(jwt);
  }

  /**
   * 토큰 검증
   */
  public static boolean verifyToken(String token) {
    if (!StringUtils.hasText(token)) {
      return false;
    }
    try {
      Jws<Claims> claimsJws = parseJwt(token);
      Claims body = claimsJws.getBody();

      // 만료 시간 체크 (now가 만료 시간 이후라면 false)
      return !new Date().after(body.getExpiration());
    } catch (Exception e) {
      return false;
    }
  }

  /**
   * JWT의 만료 시간 연장 (기존 Claims 유지하며 재생성)
   */
  public static String extendExpirationTime(String token, long expirationMillis) throws Exception {
    try {
      Jws<Claims> claimsJws = parseJwt(token);
      Claims claims = claimsJws.getBody();
      String id = claims.getId();

      // 기존에 담겨있던 커스텀 클레임 정보를 그대로 유지하면서 시간만 연장하려면 아래와 같이 활용 가능
      return createJWT(id, expirationMillis, claims);
    } catch (Exception e) {
      throw new SignatureException("API 토큰 검증 실패 또는 만료됨");
    }
  }

  /**
   * 오버로딩: 기본 1시간으로 연장
   */
  public static String extendExpirationTime(String token) throws Exception {
    return extendExpirationTime(token, DEFAULT_EXPIRATION_MILLIS);
  }

  /**
   * 토큰에서 ID 추출
   */
  public static String getId(String token) {
    if (!StringUtils.hasText(token)) {
      return "";
    }
    try {
      Jws<Claims> claimsJws = parseJwt(token);
      return claimsJws.getBody().getId();
    } catch (Exception e) {
      return "";
    }
  }

  private static Key getSignKey() {
    return Keys.hmacShaKeyFor(apikey.getBytes(StandardCharsets.UTF_8));
  }


  /**
   * 토큰 검증 및 내부 Body(Claims) 반환
   *
   * @param token
   * @return Claims 검증 성공 시 바디 데이터, 실패 시 null 반환
   */
  public static Claims getClaims(String token) {
    if (!verifyToken(token)) {
      return null; // 검증 실패 또는 만료 시 null 반환
    }
    try {
      return parseJwt(token).getBody();
    } catch (Exception e) {
      return null;
    }
  }


  /**
   * 토큰에서 남은 유효 시간(초 단위) 추출
   *
   * @param token
   * @return long 남은 초 (만료되었거나 유효하지 않으면 0 반환)
   */
  public static long getRemainingSeconds(String token) {
    try {
      Claims claims = getClaims(token); // 앞서 만든 검증+바디 추출 메서드
      if (claims == null) {
        return 0;
      }

      Date expiration = claims.getExpiration();
      long nowMillis = System.currentTimeMillis();
      long expirationMillis = expiration.getTime();

      long diffMillis = expirationMillis - nowMillis;
      return diffMillis > 0 ? diffMillis / 1000 : 0;
    } catch (Exception e) {
      return 0;
    }
  }
}
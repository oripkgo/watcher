package com.watcher.util;

import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.Map;
import java.util.Optional;


@Log4j2
@Component
public class CookieUtil {

    static private final int DEFAULT_MAX_AGE = 7 * 24 * 60 * 60; // 7일


    /**
     * 쿠키 생성 및 추가
     *
     * @param name
     * @param value
     * @param maxAge
     */
    public static void addCookie(String name, String value, int maxAge) {
        Cookie cookie = new Cookie(name, value);
        cookie.setPath("/"); // 모든 경로에서 접근 가능
        cookie.setHttpOnly(true); // JavaScript에서 접근 불가 (XSS 보호)
        cookie.setMaxAge(maxAge); // 쿠키 유효 시간
        ServletUtil.getCurrentResponse().addCookie(cookie);
    }

    /**
     * 쿠키 생성 (기본 유효시간 사용)
     *
     * @param name
     * @param value
     */
    public static void addCookie(String name, String value) {
        addCookie(name, value, DEFAULT_MAX_AGE);
    }

    /**
     * 쿠키 조회
     *
     * @param name
     * @return String
     */
    public static String getValue(String name) {

        HttpServletRequest request = ServletUtil.getCurrentRequest();

        if (request.getCookies() == null) {
            return "";
        }

        return Arrays.stream(request.getCookies())
                .filter(cookie -> cookie.getName().equals(name))
                .map(Cookie::getValue)
                .findFirst()
                .orElse("");
    }

    /**
     * 쿠키 삭제
     *
     * @param name
     */
    public static void deleteCookie(String name) {
        Cookie cookie = new Cookie(name, null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0); // 즉시 만료
        ServletUtil.getCurrentResponse().addCookie(cookie);
    }

}

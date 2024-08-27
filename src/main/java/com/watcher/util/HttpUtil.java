package com.watcher.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.stream.Collectors;


public class HttpUtil {
    private final static Logger logger = LoggerFactory.getLogger(HttpUtil.class);

    public static String requestHttp(String urlData, String method, Map<String, String> paramData, Map<String, String> headersData) {
        String totalUrl = urlData.trim();
        String returnData = "";

        HttpURLConnection conn = null;

        try {
            URL url = new URL(totalUrl);
            conn = (HttpURLConnection) url.openConnection();

            // 헤더 설정
            if (headersData != null) {
                headersData.forEach(conn::setRequestProperty);
            } else {
                conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            }

            // HTTP 메서드 설정
            conn.setRequestMethod(method.isEmpty() ? "POST" : method);
            conn.setDoOutput(true);

            // 요청 데이터 전송
            if (paramData != null && !paramData.isEmpty()) {
                String params = paramData.entrySet()
                        .stream()
                        .map(entry -> entry.getKey() + "=" + entry.getValue())
                        .collect(Collectors.joining("&"));

                try (OutputStream os = conn.getOutputStream();
                     BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, StandardCharsets.UTF_8))) {
                    writer.write(params);
                    writer.flush();
                }
            }

            // 응답 데이터 수신
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                returnData = br.lines().collect(Collectors.joining());
            }

            // 로그 출력
            logger.debug("HTTP 요청 방식: {}", method);
            logger.debug("HTTP 요청 주소: {}", urlData);
            logger.debug("HTTP 요청 데이터: {}", paramData);
            logger.debug("HTTP 응답 코드: {}", conn.getResponseCode());
            logger.debug("HTTP 응답 데이터: {}", returnData);

        } catch (IOException e) {
            logger.error("HTTP 요청 중 오류 발생: {}", e.getMessage(), e);
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }

        return returnData;
    }

    public static String requestHttp(String urlData, Map<String, String> paramData, Map<String, String> headersData) {
        return requestHttp(urlData, "", paramData, headersData);
    }

    public static String requestHttp(String urlData, Map<String, String> paramData) {
        return requestHttp(urlData, "", paramData, null);
    }
}
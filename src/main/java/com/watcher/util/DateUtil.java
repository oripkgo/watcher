package com.watcher.util;

import lombok.extern.log4j.Log4j2;

import java.text.SimpleDateFormat;
import java.util.Calendar;

@Log4j2
public class DateUtil {

    /** Default data format variable */
    private static String defaultDatePattern = null;
    private static String BUNDLE_KEY = null;
    /** Date format */
    public static final String DATE_PATTERN = "yyyy-MM-dd";
    public static final String DATE_PATTERN_FORMAT = "yyyyMMdd";
    /** Time format */
    public static final String TIME_PATTERN = "HH:mm";
    /** Date Time format */
    public static final String DATE_TIME_PATTERN = "yyyy-MM-dd HH:mm";
    /** Date HMS format */
    public static final String DATE_HMS_FORMAT = "yyyyMMddHHmmss";
    /** Time stamp format */
    public static final String TIMESTAMP_FORMAT = "yyyyMMddHHmmssSSS";

    /**
     * 현재 날짜를 가져온다.
     * @return String 현재 날짜(yyyy-MM-dd)
     */
    public static String getCurrentDay() {
        return getCurrentTime(DATE_PATTERN);
    }

    /**
     * 주어진 날짜 패턴의 현재 날짜를 가져온다.
     * @param pattern
     * @return String pattern에 의한 현재 날짜
     */
    public static String getCurrentDay(String pattern) {
        return getCurrentTime(pattern);
    }

    /**
     * yyyy-MM-dd HH:mm 패턴의 현재 시간을 가져온다.
     * @return String 현재 시간(yyyy-MM-dd HH:mm)
     */
    public static String getCurrentTime() {
        return getCurrentTime(DATE_TIME_PATTERN);
    }

    /**
     * 주어진 패턴의 현재시간을 가져온다.
     * @param pattern
     * @return String pattern에 의한 현재 시간
     */
    public static String getCurrentTime(String pattern) {
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        Calendar now = Calendar.getInstance();
        String nowTime = sdf.format(now.getTime());
        return nowTime;
    }

    /**
     * 년도를 포함한 현재월을 가져온다.
     * @return String 현재월(yyyy-MM)
     */
    public static String getThisMonth() {
        return getCurrentTime("yyyy-MM");
    }

    /**
     * 현재 년도를 가져온다.
     * @return String 현재 년도 (yyyy)
     */
    public static String getThisYear() {
        return getCurrentTime("yyyy");
    }

    /**
     * 현재시간을 가져온다.
     * @return String 현재시간 (HH:mm)
     */
    public static String getCurrentHour() {
        return getCurrentTime(TIME_PATTERN);
    }
}

package com.watcher.util;

import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.LinkedHashMap;
import java.util.Map;

@Component
@Log4j2
public class SessionUtil {

    // 세션시간 30분
    @Value("${spring.session.timeout}")
    private int SECONDS;

    private HttpSession getSession() {
        RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();
        if (requestAttributes == null) {
            log.warn("RequestAttributes is null. No HTTP request bound to the current thread.");
            return null;
        }
        HttpServletRequest request = ((ServletRequestAttributes) requestAttributes).getRequest();
        return request.getSession(false);  // false: 세션 없으면 null 반환, true: 새 세션 생성
    }

    public void set(String key, Object value) {
        HttpSession session = getSession();
        if (session != null) {
            session.setAttribute(key, value);
        } else {
            log.warn("HttpSession is null. Cannot set attribute.");
        }
    }

    public void setSession(String key, Object value) {
        this.setSession(key,value,SECONDS);
    }


    public void setSession(String key, Object value, int timeoutSeconds) {
        HttpSession session = getSession();
        if (session != null) {
            session.setAttribute(key, value);
            session.setMaxInactiveInterval(timeoutSeconds);
        } else {
            log.warn("HttpSession is null. Cannot set attribute or timeout.");
        }
    }

    public void remove(String key) {
        HttpSession session = getSession();
        if (session != null) {
            session.removeAttribute(key);
        } else {
            log.warn("HttpSession is null. Cannot remove attribute.");
        }
    }

    public Object get(String key) {
        HttpSession session = getSession();
        if (session != null) {
            return session.getAttribute(key);
        }
        log.warn("HttpSession is null. Cannot get attribute.");
        return null;
    }

    public String getString(String key) {
        Object obj = get(key);
        return obj != null ? obj.toString() : null;
    }

    public Map<String, String> getSession(String key) {
        Object obj = get(key);
        return obj != null ? (Map<String, String>) obj : new LinkedHashMap<>();
    }

//    final ValueOperations<String, RedisUserDto> valueOperations = redisTemplate.opsForValue();
//    valueOperations.set(redisUserDto.getId(), redisUserDto);

}

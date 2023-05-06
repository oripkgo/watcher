package com.watcher.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import java.util.Map;
import java.util.concurrent.TimeUnit;

@Configuration
public class RedisUtil {
    private final static Logger logger = LoggerFactory.getLogger(RedisUtil.class);

    static private RedisTemplate<String, Object> redisTemplate;

    // 세션시간 30분
    static final int SECONDS = (60*30);

    @Autowired
    public void setRedisTemplate(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    static public void set(String id, Object obj) {
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        valueOperations.set(id, obj);
    }

    static public void setSession(String id, Object obj) {
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        valueOperations.set(id, obj, SECONDS, TimeUnit.SECONDS);
    }

    static public void remove(String id) {
        redisTemplate.delete(id);
    }

    static public Object getRedisObj() {
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        return valueOperations;
    }

    static public Object get(String id) {
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        final Object result = valueOperations.get(id);
        return result;
    }

    static public String getString(String id) {
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        final Object result = valueOperations.get(id);
        return (String)result;
    }

    static public Map<String, String> getSession(String id) {
        redisTemplate.expire(id, SECONDS, TimeUnit.MINUTES);
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        final Object result = valueOperations.get(id);
        return (Map<String, String>)result;
    }

//    final ValueOperations<String, RedisUserDto> valueOperations = redisTemplate.opsForValue();
//    valueOperations.set(redisUserDto.getId(), redisUserDto);

}

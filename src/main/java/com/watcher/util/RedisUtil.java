package com.watcher.util;

import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Configuration
@Log4j2
public class RedisUtil {

    // 세션시간 30분
    @Value("${spring.session.timeout}")
    private int SECONDS;

    private RedisTemplate<String, Object> redisTemplate;


    @Autowired
    public void setRedisTemplate(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    public void set(String id, Object obj) {
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        valueOperations.set(id, obj);
    }

    public void setSession(String id, Object obj) {
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        valueOperations.set(id, obj, SECONDS, TimeUnit.SECONDS);
    }

    public void remove(String id) {
        redisTemplate.delete(id);
    }

     public Object getRedisObj() {
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        return valueOperations;
    }

    public Object get(String id) {
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        final Object result = valueOperations.get(id);
        return result;
    }

    public String getString(String id) {
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        final Object result = valueOperations.get(id);
        return (String)result;
    }

    public Map<String, String> getSession(String id) {
        redisTemplate.expire(id, SECONDS, TimeUnit.SECONDS);
        final ValueOperations<String, Object> valueOperations = redisTemplate.opsForValue();
        final Map<String, String> result = (Map<String, String>) valueOperations.get(id);
        return result == null ? new LinkedHashMap<>() : result;
    }

//    final ValueOperations<String, RedisUserDto> valueOperations = redisTemplate.opsForValue();
//    valueOperations.set(redisUserDto.getId(), redisUserDto);

}

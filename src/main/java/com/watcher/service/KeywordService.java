package com.watcher.service;

import com.watcher.mapper.BoardMapper;
import com.watcher.mapper.KeywordMapper;
import com.watcher.param.KeywordParam;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class KeywordService {
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    KeywordMapper keywordMapper;


    public Map<String, Object> insert(KeywordParam keywordParam){
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        if( StringUtils.hasText(keywordParam.getKeyword())){
            try{
                keywordMapper.insert(keywordParam);
            }catch (DuplicateKeyException e){
                LOGGER.debug("검색 키워드 중복");
            }
        }

        result.put("code","0000");
        result.put("message","OK");
        return result;
    }
}

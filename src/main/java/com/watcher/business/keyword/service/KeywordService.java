package com.watcher.business.keyword.service;

import com.watcher.business.keyword.mapper.KeywordMapper;
import com.watcher.business.keyword.param.KeywordParam;
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

    private static int POPULAR_KEYWORD_LIMIT = 10;
    private static int POPULAR_KEYWORD_SEARCH_LIMIT = 10;

    @Autowired
    KeywordMapper keywordMapper;


    public Map<String, Object> getPopularKeywordList(){
        return this.getPopularKeywordList(null);
    }


    public Map<String, Object> getPopularKeywordList(KeywordParam keywordParam){
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        Map<String,Object> param = new LinkedHashMap<>();
        param.put("limit", POPULAR_KEYWORD_LIMIT);

        if (keywordParam != null && StringUtils.hasText(keywordParam.getKeyword())) {
            param.put("searchKeyword", keywordParam.getKeyword());
            param.put("limit", POPULAR_KEYWORD_SEARCH_LIMIT);
        }

        result.put("list",keywordMapper.getPopularKeywordList(param));

        result.put("code","0000");
        result.put("message","OK");
        return result;
    }


    public Map<String, Object> insert(KeywordParam keywordParam) {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        if (StringUtils.hasText(keywordParam.getKeyword())) {
            try {
                keywordMapper.insert(keywordParam);
            } catch (DuplicateKeyException e) {
                LOGGER.debug("검색 키워드 중복");
            }
        }

        result.putAll(this.getPopularKeywordList(keywordParam));

        result.put("code", "0000");
        result.put("message", "OK");
        return result;
    }
}

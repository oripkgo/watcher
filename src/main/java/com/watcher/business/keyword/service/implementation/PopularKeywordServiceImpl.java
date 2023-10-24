package com.watcher.business.keyword.service.implementation;

import com.watcher.business.keyword.mapper.PopularKeywordMapper;
import com.watcher.business.keyword.param.PopularKeywordParam;
import com.watcher.business.keyword.service.PopularKeywordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class PopularKeywordServiceImpl implements PopularKeywordService {
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    private static int POPULAR_KEYWORD_LIMIT = 10;
    private static int POPULAR_KEYWORD_SEARCH_LIMIT = 10;

    @Autowired
    PopularKeywordMapper popularKeywordMapper;

    @Override
    public Map<String, Object> search(){
        return this.search(null);
    }

    @Override
    public Map<String, Object> search(PopularKeywordParam popularKeywordParam){
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        Map<String,Object> param = new LinkedHashMap<>();
        param.put("limit", POPULAR_KEYWORD_LIMIT);

        if (popularKeywordParam != null && StringUtils.hasText(popularKeywordParam.getKeyword())) {
            param.put("searchKeyword", popularKeywordParam.getKeyword());
            param.put("limit", POPULAR_KEYWORD_SEARCH_LIMIT);
        }

        result.put("list", popularKeywordMapper.search(param));

        result.put("code","0000");
        result.put("message","OK");
        return result;
    }

    @Override
    public Map<String, Object> insert(PopularKeywordParam popularKeywordParam) {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        if (StringUtils.hasText(popularKeywordParam.getKeyword())) {
            try {
                popularKeywordMapper.insert(popularKeywordParam);
            } catch (DuplicateKeyException e) {
                LOGGER.debug("검색 키워드 중복");
            }
        }

        result.putAll(this.search(popularKeywordParam));

        result.put("code", "0000");
        result.put("message", "OK");
        return result;
    }
}
package com.watcher.business.keyword.service.implementation;

import com.watcher.business.keyword.mapper.PopularKeywordMapper;
import com.watcher.business.keyword.param.PopularKeywordParam;
import com.watcher.business.keyword.service.PopularKeywordService;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
@Log4j2
public class PopularKeywordServiceImpl implements PopularKeywordService {

    private static int POPULAR_KEYWORD_LIMIT = 10;
    private static int POPULAR_KEYWORD_SEARCH_LIMIT = 10;

    @Autowired
    PopularKeywordMapper popularKeywordMapper;

    @Override
    public void validation(PopularKeywordParam popularKeywordParam) throws Exception {

    }

    @Override
    public List getList(){
        return this.getList(null);
    }

    @Override
    public List getList(PopularKeywordParam popularKeywordParam){
        popularKeywordParam.setListNo(POPULAR_KEYWORD_LIMIT);

        if (popularKeywordParam != null && StringUtils.hasText(popularKeywordParam.getKeyword())) {
            popularKeywordParam.setListNo(POPULAR_KEYWORD_SEARCH_LIMIT);
        }

        return popularKeywordMapper.select(popularKeywordParam);
    }

    @Override
    public void insert(PopularKeywordParam popularKeywordParam) {
        if (StringUtils.hasText(popularKeywordParam.getKeyword())) {
            try {
                popularKeywordMapper.insert(popularKeywordParam);
            } catch (DuplicateKeyException e) {
                log.debug("검색 키워드 중복");
            }
        }
    }
}

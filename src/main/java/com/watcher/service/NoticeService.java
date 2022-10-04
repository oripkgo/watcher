package com.watcher.service;

import com.watcher.mapper.NoticeMapper;
import com.watcher.param.NoticeParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;


@Service
public class NoticeService {


    @Autowired
    NoticeMapper noticeMapper;

    @Autowired
    BoardService boardService;


    public Map<String, Object> list(NoticeParam noticeParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        if( noticeParam.getSearch_level() == null || noticeParam.getSearch_level().isEmpty() ){
            noticeParam.setSearch_level("9");
        }

        noticeParam.setTotalCnt( noticeMapper.listCnt(noticeParam) );
        result.put("list", noticeMapper.list(noticeParam));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }


    @Transactional
    public Map<String, Object> view(NoticeParam noticeParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        result.put("view", noticeMapper.view(noticeParam));

        boardService.views_count("NOTICE", noticeParam.getId(), noticeParam.getRegId());

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }

    @Transactional
    public Map<String, Object> delete(NoticeParam noticeParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        noticeMapper.update(noticeParam);

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }

}

package com.watcher.service;

import com.watcher.mapper.NoticeMapper;
import com.watcher.vo.NoticeVo;
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


    public Map<String, Object> list(NoticeVo noticeVo) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        noticeVo.setTotalCnt( noticeMapper.listCnt(noticeVo) );
        result.put("list", noticeMapper.list(noticeVo));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }


    @Transactional(value = "transactionManager")
    public Map<String, Object> view(NoticeVo noticeVo) {
        Map<String, Object> result = new HashMap<String, Object>();

        result.put("view", noticeMapper.view(noticeVo));

        boardService.views_count("NOTICE",noticeVo.getId(),noticeVo.getRegId());

        try {
            throw new Exception();
        } catch (Exception e) {
            e.printStackTrace();
        }

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }

}

package com.watcher.service;

import com.watcher.mapper.NoticeMapper;
import com.watcher.param.FileParam;
import com.watcher.param.NoticeParam;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;


@Service
public class NoticeService {


    @Autowired
    NoticeMapper noticeMapper;

    @Autowired
    BoardService boardService;

    @Autowired
    FileService fileService;

    private String fileUploadPath = "/notice";

    public Map<String, Object> list(NoticeParam noticeParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        if (
                (noticeParam.getSearch_memId() == null || noticeParam.getSearch_memId().isEmpty()) &&
                        (noticeParam.getSearch_level() == null || noticeParam.getSearch_level().isEmpty())) {
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
    public Map<String, Object> updates(NoticeParam noticeParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        JSONArray noticeIds = new JSONArray(noticeParam.getParamJson());

        noticeParam.setId_list(noticeIds.toList());
        noticeMapper.update(noticeParam);

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }

    @Transactional
    public Map<String, Object> delete(NoticeParam noticeParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();
        noticeParam.setDeleteYn("Y");
        noticeMapper.update(noticeParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    public Map<String, Object> deletes(NoticeParam noticeParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        JSONArray noticeIds = new JSONArray(noticeParam.getParamJson());

        noticeParam.setId_list(noticeIds.toList());
        noticeParam.setDeleteYn("Y");
        noticeMapper.update(noticeParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    public Map<String, String> insert(NoticeParam noticeParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        if( noticeParam.getId() == null || noticeParam.getId().isEmpty() ){
            noticeMapper.insert(noticeParam);

            if (noticeParam.getAttachFiles() != null && noticeParam.getAttachFiles().length > 0) {
                FileParam fileParam = new FileParam();
                fileParam.setContentsId(noticeParam.getId());
                fileParam.setContentsType("NOTICE");
                fileParam.setRegId(noticeParam.getRegId());
                fileParam.setUptId(noticeParam.getRegId());

                fileService.upload(
                        noticeParam.getAttachFiles(),
                        fileUploadPath,
                        fileParam
                );
            }
        }else{
            noticeParam.setUptId(noticeParam.getRegId());
            noticeMapper.update(noticeParam);

            if (noticeParam.getAttachFiles() != null && noticeParam.getAttachFiles().length > 0) {
                FileParam fileParam = new FileParam();
                fileParam.setContentsId(noticeParam.getId());
                fileParam.setContentsType("NOTICE");
                fileParam.setRegId(noticeParam.getRegId());
                fileParam.setUptId(noticeParam.getRegId());

                fileService.upload(
                        noticeParam.getAttachFiles(),
                        fileUploadPath,
                        fileParam
                );
            }
        }

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }
}

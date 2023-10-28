package com.watcher.business.board.service.implementation;

import com.watcher.business.board.mapper.NoticeMapper;
import com.watcher.business.board.service.NoticeService;
import com.watcher.business.comm.param.FileParam;
import com.watcher.business.board.param.NoticeParam;
import com.watcher.business.comm.service.FileService;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;


@Service
public class NoticeServiceImpl implements NoticeService {
    @Autowired
    NoticeMapper noticeMapper;

    @Autowired
    BoardServiceImpl boardServiceImpl;

    @Autowired
    FileService fileService;

    private String fileUploadPath = "/notice";


    public Map<String, Object> getNoticeList(NoticeParam noticeParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        if (
            (noticeParam.getSearch_memId() == null || noticeParam.getSearch_memId().isEmpty()) &&
                (noticeParam.getSearch_level() == null || noticeParam.getSearch_level().isEmpty())) {
            noticeParam.setSearch_level("9");
        }

        noticeParam.setTotalCnt( noticeMapper.selectNoticeCnt(noticeParam) );
        result.put("list", noticeMapper.selectNotice(noticeParam));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }

    @Transactional
    @Override
    public Map<String, Object> view(NoticeParam noticeParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        result.put("view", noticeMapper.view(noticeParam));

        boardServiceImpl.views_count("NOTICE", noticeParam.getId(), noticeParam.getRegId());

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    @Override
    public void updateNoticesPublic(NoticeParam noticeParam) throws Exception {
        noticeParam.setSecretYn("N");
        JSONArray noticeIds = new JSONArray(noticeParam.getParamJson());

        noticeParam.setId_list(noticeIds.toList());
        noticeMapper.update(noticeParam);
    }

    @Transactional
    @Override
    public void updateNoticesPrivate(NoticeParam noticeParam) throws Exception {
        noticeParam.setSecretYn("Y");
        JSONArray noticeIds = new JSONArray(noticeParam.getParamJson());

        noticeParam.setId_list(noticeIds.toList());
        noticeMapper.update(noticeParam);
    }

    @Transactional
    @Override
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
    @Override
    public void delete(NoticeParam noticeParam) throws Exception {
        noticeParam.setDeleteYn("Y");
        noticeMapper.update(noticeParam);
    }

    @Transactional
    @Override
    public void deletes(NoticeParam noticeParam) throws Exception {
        JSONArray noticeIds = new JSONArray(noticeParam.getParamJson());

        noticeParam.setId_list(noticeIds.toList());
        noticeParam.setDeleteYn("Y");
        noticeMapper.update(noticeParam);
    }

    @Transactional
    @Override
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

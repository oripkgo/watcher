package com.watcher.service;

import com.watcher.mapper.CategoryMapper;
import com.watcher.param.CategoryParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Service
public class CategoryService {

    @Autowired
    CategoryMapper categoryMapper;

    public List<Map<String, Object>> category_list() throws Exception {
        List<Map<String,Object>> list = this.category_list(new LinkedHashMap());
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }

    public List<Map<String, Object>> category_list(LinkedHashMap param) throws Exception {
        List<Map<String,Object>> list = categoryMapper.category_list(param);
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }


    public List<Map<String, Object>> member_category_list(LinkedHashMap param) throws Exception {
        List<Map<String,Object>> list = categoryMapper.member_category_list(param);
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }


    public List<Map<String, Object>> story_category_serarch() throws Exception {

        List<Map<String,Object>> list = this.category_list();
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }

    @Transactional
    public Map<String, String> insert(CategoryParam categoryParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

//        if( noticeParam.getId() == null || noticeParam.getId().isEmpty() ){
//            noticeMapper.insert(noticeParam);
//
//            if (noticeParam.getAttachFiles() != null && noticeParam.getAttachFiles().length > 0) {
//                FileParam fileParam = new FileParam();
//                fileParam.setContentsId(noticeParam.getId());
//                fileParam.setContentsType("NOTICE");
//                fileParam.setRegId(noticeParam.getRegId());
//                fileParam.setUptId(noticeParam.getRegId());
//
//                fileService.upload(
//                        noticeParam.getAttachFiles(),
//                        fileUploadPath,
//                        fileParam
//                );
//            }
//        }else{
//            noticeParam.setUptId(noticeParam.getRegId());
//            noticeMapper.update(noticeParam);
//
//            if (noticeParam.getAttachFiles() != null && noticeParam.getAttachFiles().length > 0) {
//                FileParam fileParam = new FileParam();
//                fileParam.setContentsId(noticeParam.getId());
//                fileParam.setContentsType("NOTICE");
//                fileParam.setRegId(noticeParam.getRegId());
//                fileParam.setUptId(noticeParam.getRegId());
//
//                fileService.upload(
//                        noticeParam.getAttachFiles(),
//                        fileUploadPath,
//                        fileParam
//                );
//            }
//        }

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

}

package com.watcher.service;

import com.watcher.mapper.VisitorMapper;
import com.watcher.param.VisitorParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Service
public class VisitorService {

    @Autowired
    VisitorMapper visitorMapper;

    public List<Map<String, Object>> getVisitors(String memId) throws Exception {
        List<Map<String,Object>> list = null;
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }

    @Transactional
    public Map<String, String> insertVisitor(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        String accessTargets[] = new String[]{"naver","daum","yahoo","google","zoom"};
        String local = "localhost";


        visitorMapper.insert(visitorParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }
}

package com.watcher.service;

import com.watcher.mapper.VisitorMapper;
import com.watcher.param.VisitorParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Service
public class VisitorService {

    @Autowired
    VisitorMapper visitorMapper;

    @Value("${server_domain}")
    String serverDomain;


    @Transactional
    public Map<String, String> getVisitorSearchCnt(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();
        String accessTargets[] = new String[]{"NAVER","DAUM","YAHOO","GOOGLE","ZOOM"};

        visitorParam.setSearchTargetList(Arrays.asList(accessTargets));
        Map<String, Object> visitInfo = visitorMapper.getVisitorSearchCnt(visitorParam);
        result.put("visitInfo", visitInfo);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    public Map<String, String> getVisitorCnt(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        Map<String, Object> visitInfo = visitorMapper.getVisitorCnt(visitorParam);
        result.put("visitInfo", visitInfo);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @Transactional
    public Map<String, String> getChartVisitorCnt(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        List<Map<String, Object>> visitInfoList = visitorMapper.getChartVisitorCntList(visitorParam);
        result.put("visitInfoList", visitInfoList);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    public Map<String, String> getChartMonthVisitorCnt(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        List<Map<String, Object>> visitInfoList = visitorMapper.getChartMonthVisitorCntList(visitorParam);
        result.put("visitInfoList", visitInfoList);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @Transactional
    public Map<String, String> insertVisitor(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        String accessTargets[] = new String[]{"naver","daum","yahoo","google","zoom"};
        String local = serverDomain;

        for(String target:accessTargets){
            if( visitorParam.getAccessPath().indexOf(target) > -1){
                visitorParam.setAccessTarget(target);
                break;
            }

            if( visitorParam.getAccessPath().indexOf(local) > -1){
                visitorParam.setAccessTarget("local");
                break;
            }
        }

        visitorMapper.insert(visitorParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }
}

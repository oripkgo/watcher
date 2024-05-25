package com.watcher.business.visitor.service.implementation;

import com.watcher.business.visitor.mapper.VisitorMapper;
import com.watcher.business.visitor.param.VisitorParam;
import com.watcher.business.visitor.service.VisitorService;
import com.watcher.enums.ResponseCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Service
public class VisitorServiceImpl implements VisitorService {
    String visitorInflowSourceSiteDomain[] = new String[]{"NAVER","DAUM","YAHOO","GOOGLE","ZOOM"};

    @Autowired
    VisitorMapper visitorMapper;

    @Value("${server_domain}")
    String serverDomain;

    @Transactional
    @Override
    public Map<String, String> getVisitorInflowSourceCount(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        visitorParam.setSearchTargetList(Arrays.asList(visitorInflowSourceSiteDomain));
        Map<String, Object> visitInfo = visitorMapper.selectVisitorInflowSourceCount(visitorParam);
        result.put("visitInfo", visitInfo);

        result.put("code", ResponseCode.SUCCESS_0000.getCode());
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }

    @Transactional
    @Override
    public Map<String, String> getVisitorCount(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        Map<String, Object> visitInfo = visitorMapper.selectVisitorCount(visitorParam);
        result.put("visitInfo", visitInfo);

        result.put("code", ResponseCode.SUCCESS_0000.getCode());
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }

    @Transactional
    @Override
    public Map<String, String> getDailyChartVisitorCnt(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        List<Map<String, Object>> visitInfoList = visitorMapper.selectChartDailyVisitorCntList(visitorParam);
        result.put("visitInfoList", visitInfoList);

        result.put("code", ResponseCode.SUCCESS_0000.getCode());
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }

    @Transactional
    @Override
    public Map<String, String> getChartMonthVisitorCnt(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        List<Map<String, Object>> visitInfoList = visitorMapper.selectChartMonthVisitorCntList(visitorParam);
        result.put("visitInfoList", visitInfoList);

        result.put("code", ResponseCode.SUCCESS_0000.getCode());
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }

    @Transactional
    @Override
    public Map<String, String> insertVisitor(VisitorParam visitorParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        String local = serverDomain;

        for(String target:visitorInflowSourceSiteDomain){
            if( visitorParam.getAccessPath().indexOf(target.toLowerCase()) > -1){
                visitorParam.setAccessTarget(target.toLowerCase());
                break;
            }

            if( visitorParam.getAccessPath().indexOf(local) > -1){
                visitorParam.setAccessTarget("local");
                break;
            }
        }

        visitorMapper.insert(visitorParam);

        result.put("code", ResponseCode.SUCCESS_0000.getCode());
        result.put("message", ResponseCode.SUCCESS_0000.getMessage());

        return result;
    }
}

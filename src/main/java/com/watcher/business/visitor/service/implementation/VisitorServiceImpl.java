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
    public Map<String, Object> getVisitorInflowSourceCount(VisitorParam visitorParam) throws Exception {
        visitorParam.setSearchTargetList(Arrays.asList(visitorInflowSourceSiteDomain));
        return visitorMapper.selectVisitorInflowSourceCount(visitorParam);
    }

    @Transactional
    @Override
    public Map<String, Object> getVisitorCount(VisitorParam visitorParam) throws Exception {
        return visitorMapper.selectVisitorCount(visitorParam);
    }

    @Transactional
    @Override
    public List<Map<String, Object>> getDailyChartVisitorCnt(VisitorParam visitorParam) throws Exception {
        return visitorMapper.selectChartDailyVisitorCntList(visitorParam);
    }

    @Transactional
    @Override
    public List<Map<String, Object>> getChartMonthVisitorCnt(VisitorParam visitorParam) throws Exception {
        return visitorMapper.selectChartMonthVisitorCntList(visitorParam);
    }

    @Transactional
    @Override
    public void insertVisitor(VisitorParam visitorParam) throws Exception {
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
    }
}

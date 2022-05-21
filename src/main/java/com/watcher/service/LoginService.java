package com.watcher.service;

import com.watcher.param.LoginParam;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Service
public class LoginService {


    public Map<String,String> loginSuccessCallback(HttpServletRequest request, LoginParam loginVo) throws Exception{
        Map<String,String> result = new HashMap<String,String>();

        if( !( loginVo.getId() == null || loginVo.getId().isEmpty() ) ){
            request.getSession().setAttribute("loginInfo", loginVo);
        }

        result.put("code","0000");
        result.put("message","OK");


        return result;
    }


}

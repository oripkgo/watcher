package com.watcher.business.login.service;

import com.watcher.business.login.param.LoginParam;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

public interface LoginService {
    public Map<String, String> loginSuccessCallback(HttpServletRequest request, LoginParam loginVo) throws Exception;
}

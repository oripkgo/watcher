package com.watcher.business.login.service;

import com.watcher.business.login.param.SignParam;
import java.util.Map;

public interface SignService {
    public void validation(SignParam signParam) throws Exception;
    public void handleIn(SignParam signParam, String sessionId) throws Exception;
    public void handleOut(SignParam signParam, String sessionId) throws Exception;
    public Map getSessionUser(String sessionId) throws Exception;
    public String getSessionToken(String sessionId) throws Exception;
    public String getSessionId(String token) throws Exception;
    public String getToken(String sessionId) throws Exception;
}

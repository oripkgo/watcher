package com.watcher.business.comm.service;

import com.watcher.business.comm.param.FileParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface FileService {
    public List<Integer> uploadAfterSavePath(MultipartFile[] uploadFiles, String savePath, FileParam fileParam) throws Exception;

    public int uploadAfterSavePath(MultipartFile uploadfile,String savePath, FileParam fileParam) throws Exception;

    public Map<String, String> download(FileParam fileParam) throws Exception;
}

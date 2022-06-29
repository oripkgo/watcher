package com.watcher.service;

import com.watcher.mapper.BoardMapper;
import com.watcher.mapper.FileMapper;
import com.watcher.mapper.StoryMapper;
import com.watcher.param.StoryParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class FileService {

    @Autowired
    FileMapper fileMapper;

    @Transactional
    public Map<String, String> upload(MultipartFile[] uploadfile, String savePath, String id, String type) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        long millis = System.currentTimeMillis();

        for (MultipartFile file : uploadfile) {

            String original_filename = file.getOriginalFilename();
            String server_filename = String.valueOf(millis) + original_filename.substring(original_filename.lastIndexOf("."));
            String upload_full_path = savePath + "\\" + id + "\\" + server_filename;
            File newFileName = new File(upload_full_path);
            file.transferTo(newFileName);



        }


        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    public Map<String, String> upload(MultipartFile uploadfile,String savePath, String id, String type) throws Exception {
        return upload(new MultipartFile[]{uploadfile}, savePath, id, type);
    }

    @Transactional
    public Map<String, String> download(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }



}

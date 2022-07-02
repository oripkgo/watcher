package com.watcher.service;

import com.watcher.config.WatcherConfig;
import com.watcher.dto.FileDto;
import com.watcher.mapper.BoardMapper;
import com.watcher.mapper.FileMapper;
import com.watcher.mapper.StoryMapper;
import com.watcher.param.FileParam;
import com.watcher.param.StoryParam;
import jdk.nashorn.internal.runtime.regexp.joni.encoding.IntHolder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.*;

@Service
public class FileService {

    @Autowired
    FileMapper fileMapper;

    @Value("${upload.root}")
    String fileUploadRootPath;

    @Value("${upload.path}")
    String fileUploadPath;

    @Transactional
    public List<Integer> upload(MultipartFile[] uploadFiles, String savePath, FileParam fileParam) throws Exception {
        List<Integer> result = new ArrayList<>();

        long millis = System.currentTimeMillis();

        for(MultipartFile file : uploadFiles){
            String original_filename = file.getOriginalFilename();
            String server_filename = String.valueOf(millis) + original_filename.substring(original_filename.lastIndexOf("."));
            String upload_full_path = fileUploadPath + savePath + File.separator + fileParam.getContentsId();

            original_filename = original_filename.replaceAll("/",WatcherConfig.file_separator+WatcherConfig.file_separator);
            server_filename = server_filename.replaceAll("/",WatcherConfig.file_separator+WatcherConfig.file_separator);
            upload_full_path = upload_full_path.replaceAll("/",WatcherConfig.file_separator+WatcherConfig.file_separator);

            if( !new File(upload_full_path).exists() ){
                new File(upload_full_path).mkdirs();
            }

            File newFileName = new File(fileUploadRootPath + upload_full_path + File.separator + server_filename);
            file.transferTo(newFileName);


            fileParam.setRealFileName(original_filename);
            fileParam.setSavePath(upload_full_path);
            fileParam.setServerFileName(server_filename);
            fileParam.setPathSeparator(File.separator);

            fileMapper.insert(fileParam);
            result.add(Integer.valueOf(fileParam.getId()));

        }

        return result;
    }

    @Transactional
    public int upload(MultipartFile uploadfile,String savePath, FileParam fileParam) throws Exception {
        return upload(new MultipartFile[]{uploadfile}, savePath, fileParam).get(0);
    }

    @Transactional
    public Map<String, String> download(FileParam fileParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }



}

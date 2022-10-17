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

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.*;
import java.util.List;

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

            original_filename = changeFileSeparator(original_filename);
            server_filename = changeFileSeparator(server_filename);
            upload_full_path = changeFileSeparator(upload_full_path);

            String dirCheckPath = changeFileSeparator(fileUploadRootPath + upload_full_path);
            File dirCheck = new File(dirCheckPath);

            if( dirCheck.exists() ){
                dirCheck.delete();
            }

            dirCheck.mkdirs();

            String newFilePath = changeFileSeparator(fileUploadRootPath + upload_full_path + File.separator + server_filename);
            File newFileName = new File(newFilePath);

            BufferedImage bufferedImage = ImageIO.read(file.getInputStream());
            Image image = bufferedImage.getScaledInstance(400, 400, Image.SCALE_DEFAULT);

            BufferedImage newImage = new BufferedImage(400, 400, BufferedImage.TYPE_INT_RGB);
            Graphics graphics = newImage.getGraphics();
            graphics.drawImage(image, 0, 0, null);
            graphics.dispose();

            file.transferTo(newFileName);
            ImageIO.write(newImage, "png", new File(newFilePath));


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

    private String changeFileSeparator(String path){
        return path.replaceAll("/",WatcherConfig.file_separator+WatcherConfig.file_separator);
    }



}

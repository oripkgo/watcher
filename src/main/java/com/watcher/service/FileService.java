package com.watcher.service;

import com.watcher.config.WatcherConfig;
import com.watcher.mapper.FileMapper;
import com.watcher.param.FileParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
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
            String extension = server_filename.substring(server_filename.lastIndexOf(".")+1);

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

            BufferedImage inputImage = ImageIO.read(file.getInputStream());

            // 이미지 크기 결정
            int scaledWidth = 1000;
            int scaledHeight = 1000;

            // 스케일링을 위한 BufferedImage 생성
            BufferedImage outputImage = new BufferedImage(scaledWidth, scaledHeight, BufferedImage.TYPE_INT_RGB);

            // Graphics2D를 이용한 스케일링
            Graphics2D g2d = outputImage.createGraphics();
            g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            g2d.drawImage(inputImage, 0, 0, scaledWidth, scaledHeight, null);
            g2d.dispose();

            // 스케일링된 이미지 저장
            file.transferTo(newFileName);
            ImageIO.write(outputImage, extension, new File(newFilePath));

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

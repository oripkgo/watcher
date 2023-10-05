package com.watcher.business.comm.service.implementation;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.watcher.business.comm.service.FileService;
import com.watcher.config.WatcherConfig;
import com.watcher.business.comm.mapper.FileMapper;
import com.watcher.business.comm.param.FileParam;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.*;
import java.util.List;

@Service
public class FileServiceImpl implements FileService {
    private final static Logger logger = LoggerFactory.getLogger(FileServiceImpl.class);

    // 이미지 크기 결정
    private int scaledWidth = 1000;
    private int scaledHeight = 1000;

    @Autowired
    FileMapper fileMapper;

    @Value("${upload.root}")
    String fileUploadRootPath;

    @Value("${upload.path}")
    String fileUploadPath;

    @Value("${aws.bucket.name}")
    String bucketName;

    @Value("${aws.bucket.url}")
    String bucketUrl;

    @Value("${aws.separator}")
    String awsSeparator;


    @Transactional
    @Override
    public List<Integer> upload(MultipartFile[] uploadFiles, String savePath, FileParam fileParam) throws Exception {
        List<Integer> result = new ArrayList<>();

        long millis = System.currentTimeMillis();

        for(MultipartFile file : uploadFiles){
            String original_filename = file.getOriginalFilename();
            String server_filename = File.separator + String.valueOf(millis) + original_filename.substring(original_filename.lastIndexOf("."));
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
            File newFile = new File(newFilePath);

            BufferedImage inputImage = ImageIO.read(file.getInputStream());

            // 스케일링을 위한 BufferedImage 생성
            BufferedImage outputImage = new BufferedImage(scaledWidth, scaledHeight, BufferedImage.TYPE_INT_RGB);

            // Graphics2D를 이용한 스케일링
            Graphics2D g2d = outputImage.createGraphics();
            g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            g2d.drawImage(inputImage, 0, 0, scaledWidth, scaledHeight, null);
            g2d.dispose();

            // 스케일링된 이미지 저장
            file.transferTo(newFile);
            ImageIO.write(outputImage, extension, newFile);

            final AmazonS3 s3 = AmazonS3ClientBuilder.standard().withRegion(Regions.AP_NORTHEAST_2).build();
            try {
                s3.putObject(bucketName, upload_full_path+server_filename, newFile);
            } catch (AmazonServiceException e) {
                logger.error(e.getErrorMessage(), e);
            }

            newFile.delete();

            fileParam.setRealFileName(original_filename);
            fileParam.setSavePath(bucketUrl + changeFileSeparatorAws(upload_full_path));
            fileParam.setServerFileName(changeFileSeparatorAws(server_filename));
            fileParam.setPathSeparator(File.separator);

            fileMapper.insert(fileParam);
            result.add(Integer.valueOf(fileParam.getId()));
        }

        return result;
    }

    @Transactional
    @Override
    public int upload(MultipartFile uploadfile,String savePath, FileParam fileParam) throws Exception {
        return upload(new MultipartFile[]{uploadfile}, savePath, fileParam).get(0);
    }

    @Transactional
    @Override
    public Map<String, String> download(FileParam fileParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    private String changeFileSeparator(String path){
        if( "\\".equals(WatcherConfig.file_separator) ){
            return path.replaceAll("/",WatcherConfig.file_separator+WatcherConfig.file_separator);
        }

        return path.replaceAll("/", WatcherConfig.file_separator);
    }

    private String changeFileSeparatorAws(String path){
        String tempPath = path;

        tempPath = tempPath.replaceAll(WatcherConfig.file_separator+WatcherConfig.file_separator, awsSeparator);

        if( tempPath.indexOf(awsSeparator) == -1 ){
            tempPath = tempPath.replaceAll(WatcherConfig.file_separator, awsSeparator);
        }

        return tempPath;
    }
}

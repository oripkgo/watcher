package com.watcher.business.comm.controller;

import com.watcher.business.comm.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping(value = "/file")
public class FileController {

    @Autowired
    FileService fileService;

    @Value("${upload.path}")
    String fileUploadPath;

    @ResponseBody
    @RequestMapping(value = "/upload/image", method = RequestMethod.POST)
    public LinkedHashMap<String, Object> uploadImage(@RequestBody Map param) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        // 이후 작업 수행 (예: 이미지 저장 등)
        String fileName = UUID.randomUUID().toString();

        String S3savePath = fileService.upload(String.valueOf(param.get("base64Img")), fileUploadPath + "/" + fileName);

        result.put("path", S3savePath);
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

}

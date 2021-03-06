package com.watcher.service;

import com.watcher.mapper.BoardMapper;
import com.watcher.mapper.StoryMapper;
import com.watcher.param.FileParam;
import com.watcher.param.NoticeParam;
import com.watcher.param.StoryParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class StoryService {

    @Autowired
    StoryMapper storyMapper;

    @Autowired
    BoardMapper boardMapper;

    @Autowired
    FileService fileService;

    private String fileUploadPath = "/story";

    @Transactional
    public Map<String, String> story_insert(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();


        if( storyParam.getId() == null || storyParam.getId().isEmpty() ){
            storyMapper.insert(storyParam);

            if( !(storyParam.getTags() == null || storyParam.getTags().isEmpty()) ){
                Map<String,Object> tag_insert_param = new LinkedHashMap<String,Object>();
                tag_insert_param.put("contentsType" , "STORY"                   );
                tag_insert_param.put("contentsId"   , storyParam.getId()        );
                tag_insert_param.put("tags"         , storyParam.getTags()      );
                tag_insert_param.put("regId"        , storyParam.getRegId()     );
                tag_insert_param.put("uptId"        , storyParam.getUptId()     );

                boardMapper.tag_insert(tag_insert_param);

            }

            if( !storyParam.getThumbnailImgPathParam().isEmpty() ){
                FileParam fileParam = new FileParam();
                fileParam.setContentsId(storyParam.getId());
                fileParam.setContentsType("STORY");
                fileParam.setRegId(storyParam.getRegId());
                fileParam.setUptId(storyParam.getRegId());

                int file_id = fileService.upload(
                        storyParam.getThumbnailImgPathParam(),
                        fileUploadPath,
                        fileParam
                );

                storyParam.setThumbnailImgId(String.valueOf(file_id));
                storyMapper.update(storyParam);

            }


        }else{

            storyParam.setUptId(storyParam.getRegId());
            storyMapper.update(storyParam);

            if( !(storyParam.getTags() == null || storyParam.getTags().isEmpty()) ){

                Map<String,Object> tag_update_param = new LinkedHashMap<String,Object>();
                tag_update_param.put("contentsType" , "STORY"                   );
                tag_update_param.put("contentsId"   , storyParam.getId()        );
                tag_update_param.put("tags"         , storyParam.getTags()      );
                tag_update_param.put("regId"        , storyParam.getRegId()     );
                tag_update_param.put("uptId"        , storyParam.getUptId()     );

                boardMapper.tag_update(tag_update_param);
            }

            if( !storyParam.getThumbnailImgPathParam().isEmpty() ){
                FileParam fileParam = new FileParam();
                fileParam.setContentsId(storyParam.getId());
                fileParam.setContentsType("STORY");
                fileParam.setRegId(storyParam.getRegId());
                fileParam.setUptId(storyParam.getRegId());

                int file_id = fileService.upload(
                        storyParam.getThumbnailImgPathParam(),
                        fileUploadPath,
                        fileParam
                );

                storyParam.setThumbnailImgId(String.valueOf(file_id));
                storyMapper.update(storyParam);

            }

        }

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    public Map<String, String> story_update(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();
        storyMapper.update(storyParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    public Map<String, Object> list(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        storyParam.setTotalCnt( storyMapper.listCnt(storyParam) );
        result.put("list", storyMapper.list(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }

    public Map<String, Object> view(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        result.put("view", storyMapper.view(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }


}

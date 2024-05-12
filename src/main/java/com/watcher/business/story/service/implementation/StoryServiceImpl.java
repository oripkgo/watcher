package com.watcher.business.story.service.implementation;

import com.watcher.business.board.mapper.BoardMapper;
import com.watcher.business.comm.service.FileService;
import com.watcher.business.story.mapper.StoryMapper;
import com.watcher.business.comm.param.FileParam;
import com.watcher.business.story.param.StoryParam;
import com.watcher.business.story.service.StoryService;
import com.watcher.util.RequestUtil;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class StoryServiceImpl implements StoryService {

    @Autowired
    StoryMapper storyMapper;

    @Autowired
    BoardMapper boardMapper;

    @Autowired
    FileService fileService;

    private String fileUploadPath = "/story";

    @Override
    public void validation(StoryParam storyParam) throws Exception {

    }

    @Transactional
    @Override
    public Map<String, String> insertStory(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        // 스토리 내용에 script 제거
        storyParam.setSummary(RequestUtil.cleanXSS(storyParam.getSummary()));
        storyParam.setContents(RequestUtil.cleanXSS(storyParam.getContents()));

        if( storyParam.getId() == null || storyParam.getId().isEmpty() ){
            storyMapper.insert(storyParam);

            if( !(storyParam.getTags() == null || storyParam.getTags().isEmpty()) ){
                Map<String,Object> tag_insert_param = new LinkedHashMap<String,Object>();

                List<String> tagList = Arrays.asList(storyParam.getTags().split(","));

                tag_insert_param.put("contentsType" , "STORY"                   );
                tag_insert_param.put("contentsId"   , storyParam.getId()        );
                tag_insert_param.put("tags"         , tagList                   );
                tag_insert_param.put("regId"        , storyParam.getRegId()     );
                tag_insert_param.put("uptId"        , storyParam.getUptId()     );

                boardMapper.insertTag(tag_insert_param);

            }

            if( !storyParam.getThumbnailImgPathParam().isEmpty() ){
                FileParam fileParam = new FileParam();
                fileParam.setContentsId(storyParam.getId());
                fileParam.setContentsType("STORY");
                fileParam.setRegId(storyParam.getRegId());
                fileParam.setUptId(storyParam.getRegId());

                int file_id = fileService.uploadAfterSavePath(
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
                List<String> tagList = Arrays.asList(storyParam.getTags().split(","));

                tag_update_param.put("contentsType" , "STORY"                   );
                tag_update_param.put("contentsId"   , storyParam.getId()        );
                tag_update_param.put("tags"         , tagList                   );
                tag_update_param.put("regId"        , storyParam.getRegId()     );
                tag_update_param.put("uptId"        , storyParam.getUptId()     );

                boardMapper.deleteTag(tag_update_param);

                for(String tag : tagList ){
                    tag_update_param.put("tag", tag);
                    boardMapper.updateTag(tag_update_param);
                }

            }

            if( !storyParam.getThumbnailImgPathParam().isEmpty() ){
                FileParam fileParam = new FileParam();
                fileParam.setContentsId(storyParam.getId());
                fileParam.setContentsType("STORY");
                fileParam.setRegId(storyParam.getRegId());
                fileParam.setUptId(storyParam.getRegId());

                int file_id = fileService.uploadAfterSavePath(
                        storyParam.getThumbnailImgPathParam(),
                        fileUploadPath,
                        fileParam
                );

                storyParam.setThumbnailImgId(String.valueOf(file_id));
                storyMapper.update(storyParam);

            }

        }

        result.put("storyId", storyParam.getId());
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    @Override
    public Map<String, String> updateStory(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();
        storyMapper.update(storyParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    @Override
    public void updateStorysPublic(StoryParam storyParam) throws Exception {
        storyParam.setSecretYn("N");

        JSONArray storyIds = new JSONArray(storyParam.getParamJson());

        storyParam.setIdList(storyIds.toList());
        storyMapper.update(storyParam);
    }

    @Transactional
    @Override
    public void updateStorysPrivate(StoryParam storyParam) throws Exception {
        storyParam.setSecretYn("Y");

        JSONArray storyIds = new JSONArray(storyParam.getParamJson());

        storyParam.setIdList(storyIds.toList());
        storyMapper.update(storyParam);
    }

    @Transactional
    @Override
    public Map<String, String> updateStorys(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        JSONArray storyIds = new JSONArray(storyParam.getParamJson());

        storyParam.setIdList(storyIds.toList());
        storyMapper.update(storyParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    @Override
    public Map<String, String> deleteStory(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();
        storyParam.setDeleteYn("Y");
        storyMapper.update(storyParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Transactional
    @Override
    public Map<String, String> deleteStorys(StoryParam storyParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();

        JSONArray storyIds = new JSONArray(storyParam.getParamJson());

        storyParam.setIdList(storyIds.toList());
        storyParam.setDeleteYn("Y");
        storyMapper.update(storyParam);

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @Override
    public List<Map<String, Object>> getListManagemenPopular(StoryParam storyParam) throws Exception {
        storyParam.setSearch_secret_yn("ALL");
        storyParam.setSortByRecommendationYn("YY");
        storyParam.setLimitNum("4");
        return storyMapper.selectStory(storyParam);
    }


    @Override
    public Map<String, Object> getListManagement(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        storyParam.setSearch_secret_yn("ALL");
        storyParam.setTotalCnt( storyMapper.selectStoryCnt(storyParam) );
        result.put("list", storyMapper.selectStory(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Override
    public Map<String, Object> getListStoryPublic(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        storyParam.setSearch_secret_yn("NN");
        storyParam.setTotalCnt( storyMapper.selectStoryCnt(storyParam) );
        result.put("list", storyMapper.selectStory(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }


    @Override
    public Map<String, Object> getListMyStory(String sessionMemId, StoryParam storyParam) throws Exception {
        if( sessionMemId != null && sessionMemId.equals(storyParam.getSearch_memId()) ){
            storyParam.setSearch_secret_yn("ALL");
        }

        return this.getList(storyParam);
    }

    @Override
    public Map<String, Object> getList(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        storyParam.setTotalCnt( storyMapper.selectStoryCnt(storyParam) );
        result.put("list", storyMapper.selectStory(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

    @Override
    public Map<String, Object> getData(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        result.put("view", storyMapper.view(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");


        return result;
    }

    @Override
    public Map<String, Object> getPopularStoryMain(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        result.put("popularStorys", storyMapper.getPopularStoryMain(storyParam));

        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }
}

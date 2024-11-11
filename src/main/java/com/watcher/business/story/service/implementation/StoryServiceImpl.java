package com.watcher.business.story.service.implementation;

import com.watcher.business.board.mapper.BoardMapper;
import com.watcher.business.comm.service.FileService;
import com.watcher.business.story.mapper.StoryMapper;
import com.watcher.business.comm.param.FileParam;
import com.watcher.business.story.param.StoryParam;
import com.watcher.business.story.service.StoryService;
import com.watcher.util.RecommendUtil;
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


    // 관련게시물 조회 최대 갯수
    private int FeaturedPostListMax = 4;


    @Override
    public void validation(StoryParam storyParam) throws Exception {

    }


    @Transactional
    @Override
    public String insertStory(StoryParam storyParam) throws Exception {
        // 스토리 내용에 script 제거
        storyParam.setSummary(RequestUtil.cleanXSS(storyParam.getSummary()));
        storyParam.setContents(RequestUtil.cleanXSS(storyParam.getContents()));

        // 스토리 등록
        if( storyParam.getId() == null || storyParam.getId().isEmpty() ){
            storyMapper.insert(storyParam);
        }else{
            storyParam.setUptId(storyParam.getRegId());
            storyMapper.update(storyParam);
        }

        // 태그등록
        if( !(storyParam.getTags() == null || storyParam.getTags().isEmpty()) ){
            Map<String,Object> tagParam = new LinkedHashMap<String,Object>();
            List<String> tagList = Arrays.asList(storyParam.getTags().split(","));

            tagParam.put("contentsType" , "STORY"                   );
            tagParam.put("contentsId"   , storyParam.getId()        );
            tagParam.put("tags"         , tagList                   );
            tagParam.put("regId"        , storyParam.getRegId()     );
            tagParam.put("uptId"        , storyParam.getUptId()     );

            if( storyParam.getId() == null || storyParam.getId().isEmpty() ){
                boardMapper.insertTag(tagParam);
            }else{
                boardMapper.deleteTag(tagParam);

                for(String tag : tagList ){
                    tagParam.put("tag", tag);
                    boardMapper.updateTag(tagParam);
                }
            }
        }

        // 업로드 파일등록
        if( !storyParam.getThumbnailImgPathParam().isEmpty() ){
            FileParam fileParam = new FileParam();
            fileParam.setContentsId(storyParam.getId());
            fileParam.setContentsType("STORY");
            fileParam.setRegId(storyParam.getRegId());
            fileParam.setUptId(storyParam.getRegId());

            int fileId = fileService.uploadAfterSavePath(
                    storyParam.getThumbnailImgPathParam(),
                    fileUploadPath,
                    fileParam
            );

            storyParam.setThumbnailImgId(String.valueOf(fileId));
            storyMapper.update(storyParam);

        }

        return storyParam.getId();
    }


    @Transactional
    @Override
    public void updateStory(StoryParam storyParam) throws Exception {
        storyMapper.update(storyParam);
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
    public void updateStorys(StoryParam storyParam) throws Exception {
        JSONArray storyIds = new JSONArray(storyParam.getParamJson());

        storyParam.setIdList(storyIds.toList());
        storyMapper.update(storyParam);
    }


    @Transactional
    @Override
    public void deleteStory(StoryParam storyParam) throws Exception {
        storyParam.setDeleteYn("Y");
        storyMapper.update(storyParam);
    }


    @Transactional
    @Override
    public void deleteStorys(StoryParam storyParam) throws Exception {
        JSONArray storyIds = new JSONArray(storyParam.getParamJson());

        storyParam.setIdList(storyIds.toList());
        storyParam.setDeleteYn("Y");
        storyMapper.update(storyParam);
    }


    @Override
    public List<Map<String, Object>> getListManagemenPopular(StoryParam storyParam) throws Exception {
        storyParam.setSearchSecretYn("ALL");
        storyParam.setSortByRecommendationYn("YY");
        storyParam.setLimitNum("4");
        return storyMapper.selectStory(storyParam);
    }


    @Override
    public List<Map<String, Object>> getListManagement(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        storyParam.setSearchSecretYn("ALL");
        storyParam.setTotalCnt( storyMapper.selectStoryCnt(storyParam) );

        return storyMapper.selectStory(storyParam);
    }


    @Override
    public List<Map<String, Object>> getListStoryPublic(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();

        storyParam.setSearchSecretYn("NN");
        storyParam.setTotalCnt( storyMapper.selectStoryCnt(storyParam) );

        return storyMapper.selectStory(storyParam);
    }


    @Override
    public List<Map<String, Object>> getListMyStory(StoryParam storyParam) throws Exception {
        return this.getList(storyParam);
    }


    @Override
    public List<Map<String, Object>> getList(StoryParam storyParam) throws Exception {
        storyParam.setTotalCnt( storyMapper.selectStoryCnt(storyParam) );
        return storyMapper.selectStory(storyParam);
    }


    @Override
    public Map<String, Object> getData(StoryParam storyParam) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();
        return storyMapper.view(storyParam);
    }


    @Override
    public List<Map<String, Object>> getPopularStoryMain(StoryParam storyParam) throws Exception {
        return storyMapper.getPopularStoryMain(storyParam);
    }


    @Override
    public void insertViewsCount(StoryParam storyParam) throws Exception {
        storyMapper.updateViewCountUp(Integer.valueOf(storyParam.getId()));
    }


    @Override
    public void updateLikeCountUp(int id) throws Exception {
        storyMapper.updateLikeCountUp(id);
    }


    @Override
    public void updateLikeCountDown(int id) throws Exception {
        storyMapper.updateLikeCountDown(id);
    }


    @Override
    public List<Map<String, Object>> getFeaturedRelatedPostList(
            String memId,
            String targetContent,
            List<Map<String, Object>> storyList
    ) throws Exception {

        List<Map<String, Object>> result = new ArrayList<>();
        try(RecommendUtil recommendUtil = new RecommendUtil();){
            Map<String, Object> storyRepository = new HashMap<>();

            // 검색대상 문서들 저장
            for(Map<String, Object> obj : storyList){
                String storyKey     = obj.get("ID").toString();
                String storyContent = obj.get("CONTENTS").toString();

                storyRepository.put(storyKey, obj);
            }

            // 게시물 저장
            recommendUtil.addBlogPosts(storyList);

            // 관련 게시물 검색
            List<String> recommendations = recommendUtil.findRelatedPosts(targetContent, FeaturedPostListMax);

            // 반환할 유사 스토리 세팅
            for (String docId : recommendations) {
                result.add((Map<String, Object>) storyRepository.get(docId));
            }
        }


        return result;

    }

}

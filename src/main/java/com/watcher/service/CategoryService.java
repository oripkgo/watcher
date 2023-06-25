package com.watcher.service;

import com.watcher.mapper.CategoryMapper;
import com.watcher.param.MemberCategoryParam;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Service
public class CategoryService {

    @Autowired
    CategoryMapper categoryMapper;

    public List<Map<String, Object>> category_list() throws Exception {
        List<Map<String,Object>> list = this.category_list(new LinkedHashMap());
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }

    public List<Map<String, Object>> category_list(LinkedHashMap param) throws Exception {
        List<Map<String,Object>> list = categoryMapper.category_list(param);
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }


    public List<Map<String, Object>> member_category_list(LinkedHashMap param) throws Exception {
        List<Map<String,Object>> list = categoryMapper.member_category_list(param);
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }


    public List<Map<String, Object>> story_category_serarch() throws Exception {

        List<Map<String,Object>> list = this.category_list();
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }

    @Transactional
    public Map<String, String> insertOrUpdate(MemberCategoryParam memberCategoryParam) throws Exception {
        LinkedHashMap result = new LinkedHashMap();
        JSONObject insertIds = new JSONObject();
        JSONArray jsonArr = new JSONArray(memberCategoryParam.getParamJson());

        for(int i=0;i<jsonArr.length();i++){
            JSONObject obj = jsonArr.getJSONObject(i);

            MemberCategoryParam InsertOrUpdateParam = new MemberCategoryParam();

            InsertOrUpdateParam.setCategoryNm(obj.getString("CATEGORY_NM"));
            InsertOrUpdateParam.setCategoryComents(obj.getString("CATEGORY_COMENTS"));
            InsertOrUpdateParam.setShowYn(obj.getString("SHOW_YN"));
            InsertOrUpdateParam.setDefalutCategId(String.valueOf(obj.getInt("DEFALUT_CATEG_ID")));
            InsertOrUpdateParam.setRegId(memberCategoryParam.getRegId());
            InsertOrUpdateParam.setUptId(memberCategoryParam.getUptId());
            InsertOrUpdateParam.setLoginId(memberCategoryParam.getLoginId());

            if(obj.isNull("ID")){
                categoryMapper.insert(InsertOrUpdateParam);
                insertIds.put(String.valueOf(obj.get("TAG_ID")), InsertOrUpdateParam.getId());
            }else{
                InsertOrUpdateParam.setDeleteYn(obj.getString("DELETE_YN"));
                InsertOrUpdateParam.setId(String.valueOf(obj.getInt("ID")));
                categoryMapper.update(InsertOrUpdateParam);
            }
        }

        result.put("insertIds", insertIds.toString());
        result.put("code", "0000");
        result.put("message", "OK");

        return result;
    }

}

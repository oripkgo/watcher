package com.watcher.business.category.service.implementation;

import com.watcher.business.category.mapper.CategoryMapper;
import com.watcher.business.category.service.CategoryService;
import com.watcher.business.management.param.MemberCategoryParam;
import com.watcher.enums.ResponseCode;
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
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    CategoryMapper categoryMapper;

    @Override
    public List<Map<String, Object>> getListCategory() throws Exception {
        List<Map<String,Object>> list = this.getListCategory(new LinkedHashMap());
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }

    @Override
    public List<Map<String, Object>> getListCategory(LinkedHashMap param) throws Exception {
        List<Map<String,Object>> list = categoryMapper.selectListCategory(param);
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }

    @Override
    public List<Map<String, Object>> getListCategoryMember(LinkedHashMap param) throws Exception {
        List<Map<String,Object>> list = categoryMapper.selectListCategoryMember(param);
        if( list == null ){
            list = new ArrayList<>();
        }

        return list;
    }


    @Transactional
    @Override
    public String insertOrUpdate(MemberCategoryParam memberCategoryParam) throws Exception {
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

        return insertIds.toString();
    }
}

package com.watcher.service;

import com.watcher.mapper.BoardMapper;
import com.watcher.mapper.CategoryMapper;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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


    public List<Map<String, Object>> story_category_serarch(LinkedHashMap param) throws Exception {

       // List<Map<String,Object>> list = categoryMapper.member_category_list(param);
        List<Map<String,Object>> list = this.category_list();
        if( list == null ){
            list = new ArrayList<>();
        }

        /*
        if( list.size() <= 0 ){
            list = this.category_list();
        }
        */

        return list;

    }

}

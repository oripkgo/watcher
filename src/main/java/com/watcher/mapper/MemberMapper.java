package com.watcher.mapper;

import com.watcher.param.MemberParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.Map;


@Mapper
public interface MemberMapper {
    public Map<String, Object> userSearch(MemberParam memberParam);
    public void insert(MemberParam memberParam);
    public void insertDetail(MemberParam memberParam);
    public void insertManagement(MemberParam memberParam);
}

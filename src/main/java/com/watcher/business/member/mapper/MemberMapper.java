package com.watcher.business.member.mapper;

import com.watcher.business.member.param.MemberParam;
import org.apache.ibatis.annotations.Mapper;

import java.util.Map;


@Mapper
public interface MemberMapper {
    public Map<String, Object> search(MemberParam memberParam);
    public void insert(MemberParam memberParam);
    public void insertDetail(MemberParam memberParam);
}

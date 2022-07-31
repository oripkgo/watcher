package com.watcher.mapper;

import com.watcher.param.FileParam;
import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface FileMapper {
    public void insert(FileParam fileParam);
    public void update(FileParam fileParam);

}

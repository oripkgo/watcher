package com.watcher.business.comm.mapper;

import com.watcher.business.comm.param.FileParam;
import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface FileMapper {
    public void insert(FileParam fileParam);
    public void update(FileParam fileParam);

}

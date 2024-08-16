package com.watcher.business.visitor.param;


import com.watcher.business.visitor.dto.VisitorDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Setter
@Getter
@ToString
public class VisitorParam extends VisitorDto {

    String  memId;
    String  searchDate;
    List    searchTargetList;

}

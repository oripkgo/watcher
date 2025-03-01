package com.watcher.business.board.param;


import com.watcher.business.comm.dto.CommDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Setter
@Getter
@ToString
public class BoardParam extends CommDto {
    String contentsType;
    String contentsId;
    String loginId;
    String likeType;
    String likeId;
    String likeYn;
    List tags;

}

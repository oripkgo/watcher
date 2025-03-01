package com.watcher.business.board.param;


import com.watcher.business.comm.dto.CommDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class CommentParam extends CommDto {
    String id;
    String contentsType;
    String contentsId;
    String refContentsId;
    String comment;
    String confirmId;
    String commentId;

}

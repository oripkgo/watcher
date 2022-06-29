package com.watcher.param;


import com.watcher.dto.FileDto;

public class FileParam extends FileDto {

    String board_id;
    String board_type;

    String whereId;
    String whereContentsType;
    String whereContentsId;

    public String getBoard_id() {
        return board_id;
    }

    public void setBoard_id(String board_id) {
        this.board_id = board_id;
    }

    public String getBoard_type() {
        return board_type;
    }

    public void setBoard_type(String board_type) {
        this.board_type = board_type;
    }

    public String getWhereId() {
        return whereId;
    }

    public void setWhereId(String whereId) {
        this.whereId = whereId;
    }

    public String getWhereContentsType() {
        return whereContentsType;
    }

    public void setWhereContentsType(String whereContentsType) {
        this.whereContentsType = whereContentsType;
    }

    public String getWhereContentsId() {
        return whereContentsId;
    }

    public void setWhereContentsId(String whereContentsId) {
        this.whereContentsId = whereContentsId;
    }
}

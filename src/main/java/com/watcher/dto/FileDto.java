package com.watcher.dto;


public class FileDto extends CommDto {

    private String id;
    private String regId;
    private String regDate;
    private String uptId;
    private String uptDate;
    private String contentsType;
    private String contentsId;
    private String realFileName;
    private String serverFileName;
    private String savePath;
    private String deleteYn;
    private String pathSeparator;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Override
    public String getRegId() {
        return regId;
    }

    @Override
    public void setRegId(String regId) {
        this.regId = regId;
    }

    @Override
    public String getRegDate() {
        return regDate;
    }

    @Override
    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }

    @Override
    public String getUptId() {
        return uptId;
    }

    @Override
    public void setUptId(String uptId) {
        this.uptId = uptId;
    }

    @Override
    public String getUptDate() {
        return uptDate;
    }

    @Override
    public void setUptDate(String uptDate) {
        this.uptDate = uptDate;
    }

    public String getContentsType() {
        return contentsType;
    }

    public void setContentsType(String contentsType) {
        this.contentsType = contentsType;
    }

    public String getContentsId() {
        return contentsId;
    }

    public void setContentsId(String contentsId) {
        this.contentsId = contentsId;
    }

    public String getRealFileName() {
        return realFileName;
    }

    public void setRealFileName(String realFileName) {
        this.realFileName = realFileName;
    }

    public String getServerFileName() {
        return serverFileName;
    }

    public void setServerFileName(String serverFileName) {
        this.serverFileName = serverFileName;
    }

    public String getSavePath() {
        return savePath;
    }

    public void setSavePath(String savePath) {
        this.savePath = savePath;
    }

    public String getDeleteYn() {
        return deleteYn;
    }

    public void setDeleteYn(String deleteYn) {
        this.deleteYn = deleteYn;
    }

    public String getPathSeparator() {
        return pathSeparator;
    }

    public void setPathSeparator(String pathSeparator) {
        this.pathSeparator = pathSeparator;
    }
}

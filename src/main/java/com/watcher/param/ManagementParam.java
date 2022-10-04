package com.watcher.param;


import com.watcher.dto.ManagementDto;

public class ManagementParam extends ManagementDto {

    String search_login_id;

    public String getSearch_login_id() {
        return search_login_id;
    }

    public void setSearch_login_id(String search_login_id) {
        this.search_login_id = search_login_id;
    }
}

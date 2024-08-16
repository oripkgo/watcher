package com.watcher.business.login.param;


import com.watcher.business.comm.dto.CommDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class SignParam extends CommDto {

    private String accessToken;
    private String type;
    private String id;
    private String email;
    private String name;
    private String gender;
    private String birth;
    private String nickname;
    private String profile;

}

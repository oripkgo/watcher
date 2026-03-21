package com.watcher.business.board.param;


import com.watcher.business.board.dto.NoticeDto;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

@Setter
@Getter
@ToString
public class NoticeParam extends NoticeDto {

  private String searchId;
  private String searchKeyword;
  private String searchLevel;
  private String searchMemId;
  private String searchSecretYn;
  private String paramJson;
  private String editPermId;
  private Integer currentId;
  private String referrerPage;

  private List idList;
  private MultipartFile[] attachFiles;

}

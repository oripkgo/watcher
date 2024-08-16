package com.watcher.business.category.param;


import com.watcher.business.category.dto.CategoryDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Setter
@Getter
@ToString
public class CategoryParam extends CategoryDto {
    private List<MultipartFile> categoryImgFile;
}

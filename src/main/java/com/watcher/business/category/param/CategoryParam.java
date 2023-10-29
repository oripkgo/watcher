package com.watcher.business.category.param;


import com.watcher.business.category.dto.CategoryDto;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public class CategoryParam extends CategoryDto {

    private List<MultipartFile> categoryImgFile;

    public List<MultipartFile> getCategoryImgFile() {
        return categoryImgFile;
    }

    public void setCategoryImgFile(List<MultipartFile> categoryImgFile) {
        this.categoryImgFile = categoryImgFile;
    }
}

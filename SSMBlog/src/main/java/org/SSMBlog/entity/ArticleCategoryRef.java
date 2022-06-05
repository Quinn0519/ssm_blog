package org.SSMBlog.entity;

import lombok.Data;

@Data
public class ArticleCategoryRef {
    private Integer articleId;
    private Integer categoryId;
    public ArticleCategoryRef(Integer articleId, Integer categoryId) {
        this.articleId = articleId;
        this.categoryId = categoryId;
    }
}

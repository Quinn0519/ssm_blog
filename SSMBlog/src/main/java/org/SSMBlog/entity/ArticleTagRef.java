package org.SSMBlog.entity;

import lombok.Data;

@Data
public class ArticleTagRef {
    private Integer articleId;
    private Integer tagId;
    public ArticleTagRef() {
    }
    public ArticleTagRef(Integer articleId, Integer tagId) {
        this.articleId = articleId;
        this.tagId = tagId;
    }
}

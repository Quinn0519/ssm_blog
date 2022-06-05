package org.SSMBlog.entity;

import lombok.Data;

@Data
public class Tag {
    private Integer tagId;

    private String tagName;

    /**
     * 文章数量(不是数据库字段)
     */
    private Integer articleCount;

    public Tag() {
    }

    public Tag(Integer tagId) {
        this.tagId = tagId;
    }

    public Tag(Integer tagId, String tagName, Integer articleCount) {
        this.tagId = tagId;
        this.tagName = tagName;
        this.articleCount = articleCount;
    }
}

package org.SSMBlog.dto;

import lombok.Data;

import java.util.List;

@Data
public class ArticleParam {
    private Integer articleId;
    private String articleTitle;
    private String articleContent;
    private Integer articleCategoryId;
    private Integer articleOrder;
    private Integer articleStatus;
    private String articleThumbnail;
    private List<Integer> articleTagIds;
}

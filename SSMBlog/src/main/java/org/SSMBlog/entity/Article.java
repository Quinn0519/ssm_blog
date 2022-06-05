package org.SSMBlog.entity;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class Article {
    private Integer articleId;
    private Integer articleUserId;
    private String articleTitle;
    private String articleContent;
    private Date articleCreateTime;
    private Date articleUpdateTime;
    private String articleSummary;
    private String articleThumbnail;
    private Integer articleStatus;
    private User user;
    private List<Tag> tagList;
    private List<Category> categoryList;
}

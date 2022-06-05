package org.SSMBlog.mapper;

import org.SSMBlog.entity.ArticleCategoryRef;
import org.SSMBlog.entity.Category;

import java.util.List;

public interface ArticleCategoryRefMapper {
    /**
     * 插入文章和分类的关系
     * @param record 关联对象
     * @return 影响行数
     */
    int insert(ArticleCategoryRef record);

    /**
     * 根据分类ID删除关系
     * @param categoryId 分类ID
     * @return 影响行数
     */
    int deleteByCategoryId(Integer categoryId);

    /**
     * 根据文章ID删除关系
     * @param articleId 文章ID
     * @return 影响行数
     */
    int deleteByArticleId(Integer articleId);

    /**
     * 根据分类ID统计文章数
     * @param categoryId 分类ID
     * @return 文章数量
     */
    int countArticleByCategoryId(Integer categoryId);


    /**
     * 根据文章ID查询分类ID
     *
     * @param articleId 文章ID
     * @return 分类ID列表
     */
    List<Integer> selectCategoryIdByArticleId(Integer articleId);

    /**
     * 根据分类ID查询文章ID
     *
     * @param categoryId 分类ID
     * @return 文章ID列表
     */
    List<Integer> selectArticleIdByCategoryId(Integer categoryId);

    /**
     * 根据文章ID获得分类列表
     *
     * @param articleId 文章ID
     * @return 分类列表
     */
    List<Category> listCategoryByArticleId(Integer articleId);
}

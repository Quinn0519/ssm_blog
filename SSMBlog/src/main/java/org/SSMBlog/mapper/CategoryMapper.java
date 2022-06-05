package org.SSMBlog.mapper;

import org.SSMBlog.entity.Category;
import java.util.List;

public interface CategoryMapper {
    /**
     * 添加分类
     *
     * @param category 分类
     * @return 影响行数
     */
    int insert(Category category);

    /**
     * 删除分类
     *
     * @param id 文章ID
     */
    int deleteCategory(Integer id);

    /**
     * 更新分类
     *
     * @param category 分类
     * @return 影响行数
     */
    int update(Category category);

    /**
     * 获得分类总数
     *
     * @return 数量
     */
    Integer countCategory();

    /**
     * 获得分类列表
     *
     * @return 列表
     */
    List<Category> listCategory();

    /**
     * 根据分类id获得分类信息
     *
     * @param id ID
     * @return 分类
     */
    Category getCategoryById(Integer id);

    /**
     * 根据分类名查找分类
     *
     * @param name 名称
     * @return 分类
     */
    Category getCategoryByName(String name);
}

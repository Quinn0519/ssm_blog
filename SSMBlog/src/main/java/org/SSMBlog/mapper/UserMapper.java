package org.SSMBlog.mapper;

import org.SSMBlog.entity.User;

import java.util.List;

public interface UserMapper {
    /**
     * 添加用户
     *
     * @param user 用户
     * @return 影响行数
     */
    int insert(User user);

    /**
     * 根据ID删除用户
     *
     * @param userId 用户ID
     * @return 影响行数
     */
    int deleteById(Integer userId);

    /**
     * 更新用户信息
     *
     * @param user 用户
     * @return 影响行数
     */
    int update(User user);

    /**
     * 根据ID查询用户
     *
     * @param userId 用户ID
     * @return 用户
     */
    User getUserById(Integer userId);

    /**
     * 用户列表查询
     *
     * @return  用户列表
     */
    List<User> listUser() ;

    /**
     * 根据用户名或邮箱获得用户
     *
     * @param str 用户名或Email
     * @return 用户
     */
    User getUserByNameOrEmail(String str) ;

    /**
     * 根据用户名查用户
     *
     * @param name 用户名
     * @return 用户
     */
    User getUserByName(String name) ;

    /**
     * 根据Email查询用户
     *
     * @param email 邮箱
     * @return 用户
     */
    User getUserByEmail(String email) ;
}

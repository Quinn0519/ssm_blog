package org.SSMBlog.service;

import lombok.extern.slf4j.Slf4j;
import org.SSMBlog.entity.User;
import org.SSMBlog.mapper.ArticleMapper;
import org.SSMBlog.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Slf4j
public class UserService {
    @Autowired
    private UserMapper userMapper;

    @Autowired
    private ArticleMapper articleMapper;

    @Autowired
    private ArticleService articleService;

    public List<User> listUser() {
        List<User> userList = userMapper.listUser();
        for (int i = 0; i < userList.size(); i++) {
            Integer articleCount = articleMapper.countArticleByUser(userList.get(i).getUserId());
            userList.get(i).setArticleCount(articleCount);
        }
        return userList;
    }

    public User getUserById(Integer id) {
        return userMapper.getUserById(id);
    }

    public void updateUser(User user) {
        userMapper.update(user);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteUser(Integer id) {
        // 删除用户
        userMapper.deleteById(id);
        // 删除文章
        List<Integer> articleIds = articleMapper.listArticleIdsByUserId(id);
        if (articleIds != null && articleIds.size() > 0) {
            for (Integer articleId : articleIds) {
                articleService.deleteArticle(articleId);
            }
        }
    }

    public User insertUser(User user) {
        user.setUserRegisterTime(new Date());
        userMapper.insert(user);
        return user;
    }

    public User getUserByNameOrEmail(String str) {
        return userMapper.getUserByNameOrEmail(str);
    }

    public User getUserByName(String name) {
        return userMapper.getUserByName(name);
    }

    public User getUserByEmail(String email) {
        return userMapper.getUserByEmail(email);
    }
}

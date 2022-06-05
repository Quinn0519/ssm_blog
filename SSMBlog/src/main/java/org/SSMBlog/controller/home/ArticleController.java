package org.SSMBlog.controller.home;

import org.SSMBlog.entity.Article;
import org.SSMBlog.enums.ArticleStatus;
import org.SSMBlog.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

// 注解@Controller表示它是一个控制器
@Controller
public class ArticleController {

    @Autowired
    private ArticleService articleService;

    @RequestMapping(value = "/article/{articleId}")
    public String getArticleDetailPage(@PathVariable("articleId") Integer articleId, Model model) {

        //文章信息，分类，标签，作者
        Article article = articleService.getArticleByStatusAndId(ArticleStatus.PUBLISH.getValue(), articleId);

        //文章信息
        model.addAttribute("article", article);

        return "Home/Page/articleDetail";
    }
}

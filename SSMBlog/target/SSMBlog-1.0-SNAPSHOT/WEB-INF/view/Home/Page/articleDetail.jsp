<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="rapid" uri="http://www.rapid-framework.org.cn/rapid" %>

<rapid:override name="title">
    <title>${article.articleTitle}</title>
</rapid:override>

<rapid:override name="header-style">
    <rapid:override name="header-style">
        <link rel="stylesheet" href="/css/highlight.css">
        <style>
            .entry-title {
                background: #f8f8f8;
            }
        </style>
    </rapid:override>
</rapid:override>

<rapid:override name="left">
    <%--博客主体-左侧文章正文 start--%>
    <div class="main">
        <div class="main-inner">
            <main id="main" class="site-main" role="main">
                <article class="post" id="articleDetail" data-id="${article.articleId}">
                    <div class="entry-header">
                        <h1 class="entry-title">
                                ${article.articleTitle}
                        </h1>
                    </div><!-- .entry-header -->
                    <div class="single-cat">所属分类：
                        <c:forEach items="${article.categoryList}" var="c">
                            <a href="/category/${c.categoryId}">
                                    ${c.categoryName}
                            </a>
                        </c:forEach>
                    </div>
                    <div class="entry-content">
                        <div class='typora-export os-windows'>
                            <div class='typora-export-content'>
                                    ${article.articleContent}
                            </div>
                        </div><!-- .entry-content -->
                    </div>
                </article><!-- #post -->

                    <%--所属标签 start--%>
                <div class="single-tag">
                    <ul class="" data-wow-delay="0.3s">
                        <c:forEach items="${article.tagList}" var="t">
                            <li>
                                <a href="/tag/${t.tagId}" rel="tag"
                                   style="background:#666666">
                                        ${t.tagName}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
                    <%--所属标签 end--%>


                    <%--版权声明 start--%>
                <div class="authorbio wow_fadeInUp">
                    <img alt="${article.user.userNickname}" src="${article.user.userAvatar}"
                         class="avatar avatar-64 photo" height="64" width="64">
                    <ul class="postinfo">
                        <li></li>
                        <li><strong>版权声明：</strong>本站原创文章，于<fmt:formatDate
                                value="${article.articleCreateTime}"
                                pattern="yyyy-MM-dd"/>，由
                            <strong>
                                    ${article.user.userNickname}
                            </strong>
                            发表。
                        </li>
                        <li class="reprinted"><strong>转载请注明：</strong>
                            <a href="/article/${article.articleId}"
                               rel="bookmark"
                               title="本文固定链接 /article/${article.articleId}">
                                    ${article.articleTitle} | ${options.optionSiteTitle}</a>
                        </li>
                    </ul>
                    <div class="clear"></div>
                </div>
                    <%--版权声明 end--%>
            </main>
        </div>

        <!-- .site-main -->
    </div>
    <%--博客主体-左侧文章正文end--%>
</rapid:override>

<%@ include file="../Public/inner-framework.jsp" %>
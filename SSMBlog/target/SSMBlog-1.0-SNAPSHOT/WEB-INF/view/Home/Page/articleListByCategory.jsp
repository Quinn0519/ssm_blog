<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="rapid" uri="http://www.rapid-framework.org.cn/rapid" %>

<rapid:override name="description">
    <meta name="description" content="${category.categoryName}"/>
</rapid:override>
<rapid:override name="keywords">
    <meta name="keywords" content="${category.categoryName}"/>
</rapid:override>
<rapid:override name="title">
    <title>${category.categoryName}</title>
</rapid:override>

<rapid:override name="left">
    <%--博客主体-左侧正文 start--%>
    <c:choose>
        <c:when test="${pageInfo != null}">
            <c:choose>
                <c:when test="${pageInfo.list.size() != 0}">
                    <%--文章列表-start--%>
                    <c:forEach items="${pageInfo.list}" var="a">
                        <article class="blog">
                            <figure class="thumbnail">
                                <a href="/article/${a.articleId}">
                                    <img src="${a.articleThumbnail}"
                                         alt="${a.articleTitle}">
                                </a>
                            </figure>

                            <div class="blog-article">
                                <h2 class="article-top">
                                    <a href="/article/${a.articleId}"
                                       rel="bookmark">
                                            ${a.articleTitle}
                                    </a>
                                </h2>

                                <div class="article-middle">
                                        ${a.articleSummary}...
                                </div>

                                <div class="article-bottom">
                                    <div class="date">
                                        <fmt:formatDate value="${a.articleCreateTime}" pattern="yyyy年MM月dd日"/>
                                    </div>
                                    <a href="/article/${a.articleId}"
                                       rel="bookmark">
                                        阅读全文
                                    </a>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                    <%--文章列表-end--%>
                </c:when>
                <c:otherwise>
                    <section class="no-results not-found">
                        <div class="post">
                            <p>该分类目前还没有文章！</p>
                            <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                        </div>
                    </section>
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>
            <section class="no-results not-found">
                <div class="post">
                    <p>该分类不存在</p>
                    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                </div>
            </section>
        </c:otherwise>
    </c:choose>
    <%--  博客主体-左侧正文 end--%>
</rapid:override>

<%--侧边栏 start--%>
<rapid:override name="right">
    <%@include file="../Public/part/sidebar.jsp" %>
</rapid:override>
<%--侧边栏 end--%>

<%@ include file="../Public/Front-framework.jsp" %>
<!--首页侧边栏-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!--博客主体-右侧侧边栏 start-->
<div class="sidebar">



    <!--网站概况 start-->
    <aside id="php_text-22" class="widget php_text">
        <h3 class="widget-title">
            <i class="fa fa-bars fa-fw"></i>网站概况
        </h3>
        <div class="textwidget widget-text">
            <ul class="site-profile">
                <li><i class="fa fa-file-o fa-fw"></i> 文章总数：${siteBasicStatistics[0]} 篇</li>
                <li><i class="fa fa-folder-o fa-fw"></i> 分类数量：${siteBasicStatistics[1]} 个</li>
                <li><i class="fa fa-tags fa-fw"></i> 标签总数：${siteBasicStatistics[2]} 个</li>
                <li><i class="fa fa-link fa-fw"></i> 链接数量：${siteBasicStatistics[3]} 个</li>
                <li><i class="fa fa-pencil-square-o fa-fw"></i> 最后更新：
                    <span style="color:#2F889A">
                                        <fmt:formatDate value="${lastUpdateArticle.articleUpdateTime}" pattern="yyyy年MM月dd日"/>

                                   </span>
                </li>
            </ul>
        </div>
        <div class="clear"></div>
    </aside>
    <!--网站概况 end-->

    <!--所有标签 start-->
    <aside class="widget">
        <h3 class="widget-title">
            <i class="fa fa-bars fa-fw"></i>所有标签
        </h3>
        <div class="tagcloud">
            <c:forEach items="${allTagList}" var="tag">
                <a href="/tag/${tag.tagId}"
                   class="tag-link-129 tag-link-position-1"
                   style="font-size: 14px;">
                        ${tag.tagName}
                </a>
            </c:forEach>
            <div class="clear"></div>
        </div>
        <div class="clear"></div>
    </aside>
    <!--所有标签 end-->

    <!--关于本站 start-->
    <aside class="widget">
        <h3 class="widget-title">
            <i class="fa fa-bars fa-fw"></i>关于本站
        </h3>
        <div id="feed_widget">
            <div class="feed-about">
<%--                <div class="about-main">--%>
<%--                    <div class="about-img">--%>
<%--                        <img src="${options.optionAboutsiteAvatar}"--%>
<%--                             alt="QR Code">--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="clear"></div>--%>
                <ul>
                    <li class="feed">
                        <a title="" href="https://github.com/${options.optionAboutsiteGithub}" target="_blank"
                           rel="external nofollow">
                            <i class="fa fa-github"></i>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="clear"></div>
    </aside>
    <!--关于本站 start-->
</div>



<!--博客主体-右侧侧边栏 end-->

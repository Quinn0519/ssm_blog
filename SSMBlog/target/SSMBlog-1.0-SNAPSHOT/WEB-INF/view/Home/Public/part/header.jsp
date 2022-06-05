<!--博客顶部-->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<header>
    <nav id="navbar" class="navbar-top">
        <!--登陆注册/进入后台 start-->
        <div class="user-login">
            <c:choose>
                <c:when test="${sessionScope.user==null}">
                    <a href="/login">登录</a> | <a href="/register">注册</a>
                </c:when>
                <c:otherwise>
                    <a href="/admin">进入后台</a>
                </c:otherwise>
            </c:choose>
        </div>
        <!--登陆注册/进入后台 end-->

        <!--主要菜单 satrt-->
        <div class="right-header">
            <a href="/">
                <i class="fa-home fa fa-fw"></i>
                <span class="font-text">首页</span>
            </a>
        </div>
    </nav>

    <!--主要菜单 end-->

    </nav>
</header>
<!--搜索框 end-->
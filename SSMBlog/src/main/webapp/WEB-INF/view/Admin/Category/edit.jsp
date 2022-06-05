<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="rapid" uri="http://www.rapid-framework.org.cn/rapid" %>

<rapid:override name="title">
    - 分类列表
</rapid:override>
<rapid:override name="header-style">
    <style>
        .layui-input-block {
            margin: 0px 10px;
        }
    </style>
</rapid:override>

<rapid:override name="content">


    <blockquote class="layui-elem-quote">
        <span class="layui-breadcrumb" lay-separator="/">
              <a href="/admin">首页</a>
              <a href="/admin/category">分类列表</a>
              <a><cite>编辑分类</cite></a>
        </span>
    </blockquote>
    <div class="layui-row">
        <div class="layui-col-md4">
            <form class="layui-form" method="post" id="myForm" action="/admin/category/editSubmit">
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <strong>修改分类</strong>
                    </div>
                    <input type="hidden" name="categoryId" value="${category.categoryId}">
                    <div class="layui-input-block">
                        名称 <span style="color: #FF5722; ">*</span>
                        <input type="text" name="categoryName" value="${category.categoryName}" placeholder=""
                               autocomplete="off" class="layui-input" required>
                    </div>
                    <br>
                    <div class="layui-input-block">
                        图标样式
                        <input type="text" name="categoryIcon" value="${category.categoryIcon}" class="layui-input">
                    </div>
                    <br>
                    <div class="layui-input-block">
                        <button class="layui-btn" lay-filter="formDemo" type="submit">保存</button>
                    </div>
                </div>
            </form>
            <br><br>
        </div>
        <div class="layui-col-md8">
            <table class="layui-table">
                <colgroup>
                    <col width="300">
                    <col width="100">
                    <col width="100">
                    <col width="100">
                    <col width="50">
                    <col width="50">
                </colgroup>
                <thead>
                <tr>
                    <th>名称</th>
                    <th>文章数</th>
                    <th>操作</th>
                    <th>ID</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${categoryList}" var="c">

                    <tr>
                        <td>
                            <a href="/category/${c.categoryId}" target="_blank">${c.categoryName}</a>
                        </td>
                        <td>
                            <a href="/category/${c.categoryId}" target="_blank">${c.articleCount}</a>
                        </td>
                        <td>
                            <a href="/admin/category/edit/${c.categoryId}" class="layui-btn layui-btn-mini">编辑</a>
                            <c:if test="${c.articleCount==0}">
                                <a href="/admin/category/delete/${c.categoryId}"
                                   class="layui-btn layui-btn-danger layui-btn-mini"
                                   onclick="return confirmDelete()">删除</a>
                            </c:if>
                        </td>
                        <td>${c.categoryId}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <blockquote class="layui-elem-quote layui-quote-nm">
                温馨提示：
                <ul>
                    <li>如果该分类包含文章，将不可删除</li>
                </ul>
            </blockquote>
        </div>
    </div>

</rapid:override>
<rapid:override name="footer-script">

</rapid:override>

<%@ include file="../Public/framework.jsp" %>

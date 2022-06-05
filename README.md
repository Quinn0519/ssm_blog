# 基于SSM的个人博客——Quinn's Blog

## 如何搭建此项目

### 克隆此项目

将此代码仓库的内容克隆到本地，其中：

- `SSMBlog`：项目源码，使用IDEA等IDE导入或者打开。（注意：应打开`pom.xml`的父级目录）
- `quinns_blog.sql`：项目数据库脚本文件。

### 导入数据库

在MySQL中创建数据库`quinns_blog`，使用`quinns_blog.sql`导入数据。

> 注意：数据库的编码和排序规则是`utf-8`和`utf-8_general_ci`。推荐使用MySQL Workbench导入。

### 使用IDEA打开Maven项目

旧版本的IDEA需要使用导入项目，并在过程中选择已存在的项目，类型是Maven项目。

新版本的IDEA可以直接打开目录。

> 注意：导入完成后，如果出现Java类里红色报错，可能是Lombok插件没有安装。

### 修改项目中的数据库信息

修改位于`src/main/resources`的`db.properties`文件。

```properties
#MySQL
mysql.driver=com.mysql.cj.jdbc.Driver
mysql.url=jdbc:mysql://127.0.0.1:3306/quinns_blog?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC
mysql.username=root
mysql.password=123456
```

主要修改`mysql.url`、`mysql.username`、`mysql.password`与本机一致即可，否则项目无法启动。

### 配置Tomcat

### 配置`data`目录

在本项目中，文件上传功能将文件上传到本地目录`data`，该目录与源码分离。

想要通过`loclahost`访问`data`目录的文件，需要进行以下几步：

#### 修改`UploadFileController.java`中的上传路径

例如我的`data`目录位于`A:\SSM相关\SSM项目\SSMBlog\data`，则需要设置：

```java
/**
 * 文件保存目录，物理路径
 */
public final String rootPath = "A:\\SSM相关\\SSM项目\\SSMBlog\\data";
```

#### 为Tomcat设置`data`目录映射

以IDEA为例：在Tomcat的`部署`添加`外部源`：

<img src="https://raw.githubusercontent.com/Direct5dom/imageDB/main/202206021032680.png" style="zoom:50%;" />

<img src="https://raw.githubusercontent.com/Direct5dom/imageDB/main/img/202206051055408.png" style="zoom:50%;" />

<img src="https://raw.githubusercontent.com/Direct5dom/imageDB/main/202206021033352.png" style="zoom:50%;" />

### 运行项目
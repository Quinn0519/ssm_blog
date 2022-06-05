package org.SSMBlog.service;

import lombok.extern.slf4j.Slf4j;
import org.SSMBlog.entity.Tag;
import org.SSMBlog.mapper.ArticleTagRefMapper;
import org.SSMBlog.mapper.TagMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.util.List;

@Service
@Slf4j
public class TagService {

    @Autowired
    private TagMapper tagMapper;

    @Autowired
    private ArticleTagRefMapper articleTagRefMapper;

    public Integer countTag() {
        return tagMapper.countTag();
    }

    public List<Tag> listTag() {
        List<Tag> tagList = null;
        try {
            tagList = tagMapper.listTag();
        } catch (Exception e) {
            e.printStackTrace();
            log.error("获得所有标签失败, cause:{}", e);
        }
        return tagList;
    }

    public List<Tag> listTagWithCount() {
        List<Tag> tagList = null;
        try {
            tagList = tagMapper.listTag();
            for (int i = 0; i < tagList.size(); i++) {
                Integer count = articleTagRefMapper.countArticleByTagId(tagList.get(i).getTagId());
                tagList.get(i).setArticleCount(count);
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("获得所有标签失败, cause:{}", e);
        }
        return tagList;
    }


    public Tag getTagById(Integer id) {
        Tag tag = null;
        try {
            tag = tagMapper.getTagById(id);
        } catch (Exception e) {            e.printStackTrace();
            log.error("根据ID获得标签失败, id:{}, cause:{}", id, e);
        }
        return tag;
    }

    public Tag insertTag(Tag tag) {
        try {
            tagMapper.insert(tag);
        } catch (Exception e) {
            e.printStackTrace();
            log.error("添加标签失败, tag:{}, cause:{}", tag, e);
        }
        return tag;
    }

    public void updateTag(Tag tag) {
        try {
            tagMapper.update(tag);
        } catch (Exception e) {
            e.printStackTrace();
            log.error("更新标签失败, tag:{}, cause:{}", tag, e);
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteTag(Integer id) {
        try {
            tagMapper.deleteById(id);
            articleTagRefMapper.deleteByTagId(id);
        } catch (Exception e) {
            e.printStackTrace();
            log.error("删除标签失败, id:{}, cause:{}", id, e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }

    }

    public Tag getTagByName(String name) {
        Tag tag = null;
        try {
            tag = tagMapper.getTagByName(name);
        } catch (Exception e) {            e.printStackTrace();
            log.error("根据名称获得标签, name:{}, cause:{}", name, e);
        }
        return tag;
    }

    public List<Tag> listTagByArticleId(Integer articleId) {
        List<Tag> tagList = null;
        try {
            tagList = articleTagRefMapper.listTagByArticleId(articleId);
        } catch (Exception e) {
            e.printStackTrace();
            log.error("根据文章ID获得标签失败，articleId:{}, cause:{}", articleId, e);
        }
        return tagList;
    }
}
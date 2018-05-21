package com.cyl.manage.core.entity;

import com.cyl.manage.common.persistence.DataEntity;

import java.io.Serializable;

public class Assignment extends DataEntity<Assignment> implements Serializable {

    private static final long serialVersionUID = 1L;

    //题型 :选择、判断、填空、其他
    private String type ;

    //难度
    private String difficulty ;

    private String title ;

    //内容
    private String content ;

    //答案
    private String answer ;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    @Override
    public String toString() {
        return "Assignment{" +
                "type='" + type + '\'' +
                ", difficulty='" + difficulty + '\'' +
                "title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", answer='" + answer + '\'' +
                '}';
    }
}

package com.cyl.manage.core.entity;

import com.cyl.manage.common.persistence.DataEntity;

import java.io.Serializable;

public class Evaluation extends DataEntity<Evaluation> implements Serializable {

    private static final long serialVersionUID = 1L;

    private Teacher teacher ;

    //讲课模式
    private Integer teachModel ;

    //实验管理
    private Integer experimentManage ;

    //作业批改
    private Integer assignmentCorrecting ;

    //课后反馈
    private Integer feedBack ;

    //总分
    private Integer score ;

    //排名
    private Integer ranking ;

    public Teacher getTeacher() {
        return teacher;
    }

    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }

    public Integer getTeachModel() {
        return teachModel;
    }

    public void setTeachModel(Integer teachModel) {
        this.teachModel = teachModel;
    }

    public Integer getExperimentManage() {
        return experimentManage;
    }

    public void setExperimentManage(Integer experimentManage) {
        this.experimentManage = experimentManage;
    }

    public Integer getAssignmentCorrecting() {
        return assignmentCorrecting;
    }

    public void setAssignmentCorrecting(Integer assignmentCorrecting) {
        this.assignmentCorrecting = assignmentCorrecting;
    }

    public Integer getFeedBack() {
        return feedBack;
    }

    public void setFeedBack(Integer feedBack) {
        this.feedBack = feedBack;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Integer getRanking() {
        return ranking;
    }

    public void setRanking(Integer ranking) {
        this.ranking = ranking;
    }

    @Override
    public String toString() {
        return "Evaluation{" +
                "teacher='" + teacher + '\'' +
                ", teachModel=" + teachModel +
                ", experimentManage=" + experimentManage +
                ", assignmentCorrecting=" + assignmentCorrecting +
                ", feedBack=" + feedBack +
                ", score=" + score +
                ", ranking=" + ranking +
                '}';
    }
}

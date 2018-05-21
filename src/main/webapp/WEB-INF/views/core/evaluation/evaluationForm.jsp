<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta name="decorator" content="blank"/>
    <%@ include file="/WEB-INF/views/include/validation.jsp"%>
    <script type="text/javascript">

        $(document).ready(function() {

            var teachModel = '${evaluation.teachModel}';
            var experimentManage = '${evaluation.experimentManage}';
            var assignmentCorrecting = '${evaluation.assignmentCorrecting}';
            var feedBack = '${evaluation.feedBack}';

            var teachModelStar = parseInt(teachModel) / 5 ;
            var experimentManageStar = parseInt(experimentManage) / 5 ;
            var assignmentCorrectingStar = parseInt(assignmentCorrecting) / 5 ;
            var feedBackStar = parseInt(feedBack) / 5 ;
            $("#teachModel-result").html((teachModel =='')?'':'你的评分是'+teachModel+'分');
            $("#experimentManage-result").html((experimentManage =='')?'':'你的评分是'+experimentManage+'分');
            $("#assignmentCorrecting-result").html((assignmentCorrecting =='')?'':'你的评分是'+assignmentCorrecting+'分');
            $("#feedBack-result").html((feedBack =='')?'':'你的评分是'+feedBack+'分');

            $("#teachModel-star").raty({
                hints: ['5','10', '15', '20', '25'],//自定义分数
                starOff: 'iconpic-star-S-default.png',//默认灰色星星
                starOn: 'iconpic-star-S.png',//黄色星星
                path: '${ctxStatic}/h-ui/images/star',//可以是相对路径
                number: 5,//星星数量，要和hints数组对应
                showHalf: true,
                targetKeep : true,
                score:teachModelStar,
                click: function (score, evt) {//点击事件
                    var customScore = evt.target.title;
                    //第一种方式：直接取值
                    $("#teachModel-result").html('你的评分是'+customScore+'分');
                    $("#teachModel").val(customScore);
                }
            });

            $("#experimentManage-star").raty({
                hints: ['5','10', '15', '20', '25'],//自定义分数
                starOff: 'iconpic-star-S-default.png',//默认灰色星星
                starOn: 'iconpic-star-S.png',//黄色星星
                path: '${ctxStatic}/h-ui/images/star',//可以是相对路径
                number: 5,//星星数量，要和hints数组对应
                showHalf: true,
                targetKeep : true,
                score:experimentManageStar,
                click: function (score, evt) {//点击事件
                    var customScore = evt.target.title;
                    //第一种方式：直接取值
                    $("#experimentManage-result").html('你的评分是'+customScore+'分');
                    $("#experimentManage").val(customScore);
                }
            });

            $("#assignmentCorrecting-star").raty({
                hints: ['5','10', '15', '20', '25'],//自定义分数
                starOff: 'iconpic-star-S-default.png',//默认灰色星星
                starOn: 'iconpic-star-S.png',//黄色星星
                path: '${ctxStatic}/h-ui/images/star',//可以是相对路径
                number: 5,//星星数量，要和hints数组对应
                showHalf: true,
                targetKeep : true,
                score:assignmentCorrectingStar,
                click: function (score, evt) {//点击事件
                    var customScore = evt.target.title;
                    //第一种方式：直接取值
                    $("#assignmentCorrecting-result").html('你的评分是'+customScore+'分');
                    $("#assignmentCorrecting").val(customScore);
                }
            });

            $("#feedBack-star").raty({
                hints: ['5','10', '15', '20', '25'],//自定义分数
                starOff: 'iconpic-star-S-default.png',//默认灰色星星
                starOn: 'iconpic-star-S.png',//黄色星星
                path: '${ctxStatic}/h-ui/images/star',//可以是相对路径
                number: 5,//星星数量，要和hints数组对应
                showHalf: true,
                targetKeep : true,
                score:feedBackStar,
                click: function (score, evt) {//点击事件
                    var customScore = evt.target.title;
                    //第一种方式：直接取值
                    $("#feedBack-result").html('你的评分是'+customScore+'分');
                    $("#feedBack").val(customScore);
                }
            });

            $("#back_btn").click(function(){
                var index = parent.layer.getFrameIndex(window.name);
                parent.layer.close(index);
            });

            $('.skin-minimal input').iCheck({
                checkboxClass: 'icheckbox-blue',
                radioClass: 'iradio-blue',
                increaseArea: '20%'
            });

            $("#evaluationForm").validate({
                onsubmit:function(element) { $(element).valid(); },
                rules:{
                },
                onkeyup:false,
                focusCleanup:true,
                success:"valid",
                submitHandler:function(form){
                    submitForm(form);
                }
            });
        })

        function submitForm(form){
            var flag = true ;
            $("input.required").each(function(index,element){
                var val = $(element).val();
                var id = $(element).attr('id') ;
                if(val  == '' || isNaN(val)){
                    flag = false ;
                    var tipId ="#" + id + "-result";
                    console.log(tipId)
                    $(tipId).html('<font color="red">请先评分</font>');
                }
            })
            if(flag){
                var url = $(form).attr("action");
                var score = parseInt($("#teachModel").val()) + parseInt($("#experimentManage").val()) + parseInt($("#assignmentCorrecting").val()) + parseInt($("#feedBack").val());
                $("#score").val(score);
                var data = $(form).serialize() ;
                var load = layer.load({icon:1});
                $.ajax({
                    type:'POST',
                    url:url,
                    data:data,
                    success:function(data){
                        layer.close(load);
                        var index = parent.layer.getFrameIndex(window.name);
                        layer.msg(data.rtnMsg,{time:1000})
                        if('00000000'==data.rtnCode){
                            setTimeout(function(){
                                parent.location.replace(parent.location.href);
                                parent.layer.close(index);
                            },1000);

                        }else{
                            layer.close(load);
                            layer.msg(data.rtnMsg);
                        }
                    },
                    error:function(){
                        layer.close(load);
                        layer.msg('操作异常 ,请稍后重试');
                    }
                })
            }

        }

    </script>

    <style type="text/css">

    </style>
</head>
<body>
<article class="page-container">
    <form:form action="${ctx}/evaluation/save" modelAttribute="evaluation" method="post" class="form form-horizontal" id="evaluationForm">
        <form:hidden path="id" />
        <form:hidden path="teachModel" cssClass="required"/>
        <form:hidden path="experimentManage" cssClass="required"/>
        <form:hidden path="assignmentCorrecting" cssClass="required"/>
        <form:hidden path="feedBack" cssClass="required"/>
        <form:hidden path="score"/>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>教师：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <c:if test="${not empty evaluation.id}">
                    <lable>${evaluation.teacher.name}</lable>
                </c:if>
                <c:if test="${empty evaluation.id}">
                    <form:select path="teacher.id" cssClass="select required">
                        <form:option value="">请选择</form:option>
                        <form:options items="${fns:findListByNoEvaluation()}" itemLabel="name" itemValue="id"></form:options>
                    </form:select>
                </c:if>
            </div>
        </div>

        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>教学方式：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <div id="teachModel-star"  class="star-bar size-M f-l mr-10 va-m"></div>
                <strong id="teachModel-result" class="f-l va-m"></strong>
            </div>
        </div>

        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>实验管理：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <div id="experimentManage-star"  class="star-bar size-M f-l mr-10 va-m"></div>
                <strong id="experimentManage-result" class="f-l va-m"></strong>
            </div>
        </div>

        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>作业批改：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <div id="assignmentCorrecting-star"  class="star-bar size-M f-l mr-10 va-m"></div>
                <strong id="assignmentCorrecting-result" class="f-l va-m"></strong>
            </div>
        </div>

        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>课后反馈：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <div id="feedBack-star" class="star-bar size-M f-l mr-10 va-m"></div>
                <strong id="feedBack-result" class="f-l va-m"></strong>
            </div>
        </div>

        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">备注：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:textarea class="textarea" placeholder="备注" path="remarks"></form:textarea>
            </div>
        </div>
        <div class="row cl">
            <div class="col-xs-8 col-sm-9 col-xs-offset-4 col-sm-offset-3">
                <input class="btn btn-primary radius" type="submit" value="&nbsp;&nbsp;提交&nbsp;&nbsp;">
                <input class="btn btn-default radius" type="button" id="back_btn" value="&nbsp;&nbsp;返回&nbsp;&nbsp;">
            </div>
        </div>
    </form:form>
</article>
</body>
</html>
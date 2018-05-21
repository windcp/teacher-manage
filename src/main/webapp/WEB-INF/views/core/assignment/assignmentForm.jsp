<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta name="decorator" content="blank"/>
    <%@ include file="/WEB-INF/views/include/validation.jsp"%>
    <script type="text/javascript" src="${ctxStatic}/ueditor/1.4.3/ueditor.config.js"></script>
    <script type="text/javascript" src="${ctxStatic}/ueditor/1.4.3/ueditor.all.min.js"> </script>
    <script type="text/javascript">

        $(document).ready(function() {

            console.log('${assignment.answer}');

            UE.getEditor('answer').ready(function(){
                this.setContent('${assignment.answer}',true);
            });

            UE.getEditor('content').ready(function(){
                this.setContent('${assignment.content}');
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

            $("#assignmentForm").validate({
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
            var url = $(form).attr("action");
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

    </script>

    <style type="text/css">

    </style>
</head>
<body>
<article class="page-container">
    <form:form action="${ctx}/assignment/save" modelAttribute="assignment" method="post" class="form form-horizontal" id="assignmentForm">
        <form:hidden path="id"/>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>标题：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="标题" path="title" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">类型：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <form:select path="type" cssClass="select required">
                    <form:options items="${fns:getDictList('topic_type')}" itemLabel="label" itemValue="label"></form:options>
                </form:select>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">难度：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <form:select path="difficulty" cssClass="select required">
                    <form:options items="${fns:getDictList('topic_difficulty')}" itemLabel="label" itemValue="label"></form:options>
                </form:select>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">内容：</label>
            <div class="formControls col-xs-8 col-sm-9">
                 <script  name="content" id="content" type="text/plain" style="height:500px;"></script></div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">答案：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <script  type="text/plain" name="answer" id="answer" style="height:500px;"></script></div>
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
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>课程</title>
    <meta name="decorator" content="blank"/>
    <%@ include file="/WEB-INF/views/include/validation.jsp"%>
    <script type="text/javascript">

        $(document).ready(function() {

            $("#back_btn").click(function(){
                var index = parent.layer.getFrameIndex(window.name);
                parent.layer.close(index);
            });

            $('.skin-minimal input').iCheck({
                checkboxClass: 'icheckbox-blue',
                radioClass: 'iradio-blue',
                increaseArea: '20%'
            });

            $("#courseForm").validate({
                onsubmit:function(element) { $(element).valid(); },
                rules:{
                    name:{
                        required:true,
                        rangelength:[1,30]
                    },
                    credit:{
                        required:true,
                        isNumber:true,
                        range:[0,100]
                    },
                    amount:{
                        isIntGtZero:true,
                        max:2000
                    }
                },
                rules:{
                  credit:{
                      isNumber:'请输入数字'
                  },
                    amount:{
                        isIntGtZero:'请输入大于0的整数'
                    }
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
    <form:form action="${ctx}/course/save" modelAttribute="course" method="post" class="form form-horizontal" id="courseForm">
        <form:hidden path="id"/>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>课程名称：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="课程名称" path="name" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">开课学期：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <form:select path="term" cssClass="select">
                    <form:options items="${fns:getDictList('term')}" itemLabel="label" itemValue="label"></form:options>
                </form:select>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>学分：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="学分" path="credit" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">教室：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="教室" path="classRoom" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">人数：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="人数" path="amount" />
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
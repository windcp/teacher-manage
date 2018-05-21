<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生</title>
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

            $("#studentForm").validate({
                onsubmit:function(element) { $(element).valid(); },
                rules:{
                    name:{
                        required:true,
                        rangelength:[1,30]
                    },
                    classes:{
                        required:true
                    },
                    studentNo:{
                        required:true,
                        digits:true,
                        minlength:10,
                        remote:{
                            url:'${ctx}/student/validateStudentNo',
                            type:'POST',
                            data:{
                                studentNo:function(){return $("#studentNo").val();},
                                id:function(){return $("#id").val();}
                            }
                        }
                    }
                },
                messages:{
                    name:{
                        required:"这是必填字段",
                        rangelength:"字符最小1位，最大30位"
                    },
                    classes:{
                        required:"这是必填字段"
                    },
                    studentNo:{
                        required:"这是必填字段",
                        digits:"必须输入整数",
                        minlength:"输入长度最小是10位",
                        remote:"该学号已存在"
                    }
                },
                onkeyup:false,
                focusCleanup:true,
                success:"valid",
                submitHandler:function(form){
                    submitForm(form);
                }
            });

            //初始化班级
            initSelectClasses();
        })

        function initSelectClasses(){
            var classesId = '${student.classes.id}';
            $("#classes").select2('val',classesId) ;
        }

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
    <form:form action="${ctx}/student/save" modelAttribute="student" method="post" class="form form-horizontal" id="studentForm">
        <form:hidden path="id"/>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>姓名：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="姓名" path="name" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>班级：</label>
            <div class="formControls col-xs-8 col-sm-9">
                    <%--<form:input type="text" class="input-text required" placeholder="教授课程" path="course" />--%>
                <select class="select" size="1" id="classes" name="classes.id">
                    <option value="">请选择</option>
                    <c:forEach items="${classesList}" var="classes">
                        <option value="${classes.id}">${classes.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>学号：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="学号" path="studentNo" maxlength="10"/>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">年龄：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="年龄" path="age" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">性别：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <%--<form:input type="text" class="input-text" placeholder="人数" path="sex" />--%>
                    <form:radiobutton path="sex" placeholder="性别" value="1"/>男
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <form:radiobutton path="sex" placeholder="性别" value="2"/>女
            </div>
        </div>
        <%--<div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">总绩点：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="总绩点" path="point" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">总学分：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="总学分" path="grades" />
            </div>
        </div>--%>
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
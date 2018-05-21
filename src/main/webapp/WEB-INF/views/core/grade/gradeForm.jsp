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

            $("#classesSelect").change(function () {
                var url ="${ctx}/grade/getStudentList" ;
                var classesId= $("#classesSelect").val();
                //清空select2数据
                $("#studentNoSelect").select2("val", " ");
                $.ajax({
                    url:url,
                    dataType: "JSON",
                    data: {'classesId': classesId},
                    type: "GET",
                    success:function (data) {
                        var studentNum= data.length;
                        var option = "<option value=''>请选择</option>";
                        if(studentNum>0){
                            $("#studentNoSelect").html(option);
                            for(var i = 0;i<studentNum;i++){
                                option += "<option value='"+data[i].studentNo+"'>"+data[i].studentNo+"</option>";
                            }
                        }
                        $("#studentNoSelect").html(option);
                    },
                    error:function(e) {
                        layer.alert("系统异常，请稍候重试！");
                    }
                });
            });

            $("#studentNoSelect").change(function () {
                var url ="${ctx}/grade/getStudent" ;
                var studentNo= $("#studentNoSelect").val();
                $.ajax({
                    url:url,
                    dataType: "JSON",
                    data: {'studentNo': studentNo},
                    type: "GET",
                    success:function (data) {
                        var name = data.name;
                        var id = data.id;
                        $("#student\\.name").val(name);
                        $("#student\\.id").val(id);
                    },
                    error:function(e) {
                        layer.alert("系统异常，请稍候重试！");
                    }
                });
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

            $("#gradeForm").validate({
                onsubmit:function(element) { $(element).valid(); },
                rules:{
                    'student.name':{
                        required:true
                    },
                    'student.studentNo':{
                        required:true
                    },
                    'course.id':{
                       required:true
                        /*remote:{
                            url:'ctx}/grade/validateCourse',
                            type:'POST',
                            data:{
                                'course.id':function(){return $("#courseSelect").val();},
                                id:function(){return $("#id").val();},
                                'student.id':function () {
                                    return $("#student\\.id").val();
                                }
                            }
                        }*/
                    },
                    'classes.name':{
                        required:true
                    },
                    paperScore:{
                        required:true,
                        digits:true,
                        range:[0,100]
                    },
                    extraScore:{
                        required:true,
                        digits:true,
                        range:[0,100]
                    }
                },
                onkeyup:false,
                focusCleanup:true,
                success:"valid",
                submitHandler:function(form){
                    submitForm(form);
                }
            });

            initSelectClasses();
            initSelectCourse();

        })

        //初始化班级下拉框
        function initSelectClasses(){
            var classesId = '${grade.classes.id}';
            $("#classesSelect").select2('val',classesId) ;
        }

        //初始化课程下拉框
        function initSelectCourse(){
            var courseId = '${grade.course.id}';
            $("#courseSelect").select2('val',courseId) ;
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
    <form:form action="${ctx}/grade/save" modelAttribute="grade" method="post" class="form form-horizontal" id="gradeForm">
        <form:hidden path="id"/>
        <form:hidden path="student.id"/>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>班级：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <c:if test="${not empty grade.id}">
                    <form:input type="text" class="input-text" placeholder="班级" path="classes.name" disabled="true"/>
                </c:if>
                <c:if test="${empty grade.id}">
                    <select class="select" size="1" id="classesSelect" name="classes.id">
                        <option value="">请选择</option>
                        <c:forEach items="${classesList}" var="classes">
                            <option value="${classes.id}">${classes.name}</option>
                        </c:forEach>
                    </select>
                </c:if>
            </div>
        </div>
       <%-- <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>学号：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="学号" path="studentNo" />
            </div>
        </div>--%>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>学号：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <c:if test="${not empty grade.id}">
                    <form:input type="text" class="input-text" placeholder="学号" path="student.studentNo" disabled="true"/>
                </c:if>
                <c:if test="${empty grade.id}">
                <select class="select" size="1" id="studentNoSelect" name="student.studentNo">
                    <option value="">请选择</option>
                    <%--<c:forEach items="${classesList}" var="classes">
                        <option value="${classes.id}">${classes.name}</option>
                    </c:forEach>--%>
                </select>
                </c:if>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>姓名：</label>
            <div class="formControls col-xs-8 col-sm-9">
                    <input type="text" class="input-text" placeholder="姓名" name="student.name" value="${grade.student.name}" id="student.name"<c:if test='${not empty grade.id}'> disabled='true' </c:if>/>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>课程：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <select class="select" size="1" id="courseSelect" name="course.id" >
                    <option value="">请选择</option>
                    <c:forEach items="${courseList}" var="cour">
                        <option value="${cour.id}">${cour.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>卷面分：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="卷面分" path="paperScore" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>平时分：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="平时分" path="extraScore" />
            </div>
        </div>
      <%--  <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>总分：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="总分" path="amount" />
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
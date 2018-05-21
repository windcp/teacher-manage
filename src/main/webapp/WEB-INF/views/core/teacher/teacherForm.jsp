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

            $("#back_btn").click(function(){
                var index = parent.layer.getFrameIndex(window.name);
                parent.layer.close(index);
            });

            $('.skin-minimal input').iCheck({
                checkboxClass: 'icheckbox-blue',
                radioClass: 'iradio-blue',
                increaseArea: '20%'
            });

            $("#teacherForm").validate({
                onsubmit:function(element) { $(element).valid(); },
                rules:{
                    name:{
                        required:true,
                        ChsEn:true,
                        maxlength:16
                    },
                    'user.loginName':{
                        remote:{
                            url:'${ctx}/sys/user/checkLoginName',
                            data:{
                                loginName:function(){
                                    return $("#user\\.loginName").val();
                                }
                            }
                        }
                    },
                    confirmNewPassword:{
                        equalTo:"#user\\.newPassword"
                    },
                    age:{
                        isDigits:true,
                        range:[0,150]
                    },
                    phone:{
                        isMobile:true
                    }
                },
                messages:{
                  'user.loginName':{
                      remote:'该用户名已存在'
                  },
                  confirmNewPassword:{
                      equalTo:'密码输入不一致'
                  }
                },
                /*onkeyup:false,
                focusCleanup:true,
                success:"valid",*/
                submitHandler:function(form){
                    submitForm(form);
                }
            });


            initSelectCourses();
            initSelectClasses();
        })

        //班级下拉框回显
        function initSelectClasses(){
            var classesIds = '${teacher.classesIds}' ;
            if(classesIds != ''){
                var arr = classesIds.split(",");
                $("#classesIdsList").select2('val',arr) ;
            }
        }

        function initSelectCourses(){
            var courseIds = '${teacher.courseIds}' ;
            if(courseIds != ''){
                var arr = courseIds.split(",");
                $("#courseIdsList").select2('val',arr) ;
            }
        }

        function submitForm(form){
            var url = $(form).attr("action");
            if(null != $("#user\\.remarks").val()|| '' != $("#user\\.remarks").val() || 'undefined' !=$("#user\\.remarks").val()){
                $("#remarks").val($("#user\\.remarks").val());
                $("#user\\.name").val($("#name").val());
            }
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
    <form:form action="${ctx}/teacher/save" modelAttribute="teacher" method="post" class="form form-horizontal" id="teacherForm">
        <form:hidden path="id"/>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>姓名：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text required" placeholder="姓名" path="name" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>年龄：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text required" placeholder="年龄" path="age" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">性别：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <form:select path="sex" cssClass="select required">
                    <form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value"></form:options>
                </form:select>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>身份：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <form:select path="identity" cssClass="select required">
                    <form:options items="${fns:getDictList('identity')}" itemLabel="label" itemValue="label"></form:options>
                </form:select>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">联系电话：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="联系电话" path="phone" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>学历：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <form:select path="education" cssClass="select required">
                    <form:options items="${fns:getDictList('education')}" itemLabel="label" itemValue="label"></form:options>
                </form:select>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>教授课程：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <%--<form:input type="text" class="input-text required" placeholder="教授课程" path="course" />--%>
                    <select class="select" size="1" id="courseIdsList" name="courseIdsList" multiple="multiple" >
                        <option value="">请选择</option>
                        <c:forEach items="${allCourse}" var="cour">
                            <option value="${cour.id}">${cour.name}</option>
                        </c:forEach>
                    </select>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>教授班级：</label>
            <div class="formControls col-xs-8 col-sm-9">
                    <%--<form:input type="text" class="input-text required" placeholder="教授课程" path="course" />--%>
                <select class="select" size="1" id="classesIdsList" name="classesIdsList" multiple="multiple" >
                    <option value="">请选择</option>
                    <c:forEach items="${allClasses}" var="classes">
                        <option value="${classes.id}">${classes.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">论文发表：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="论文发表" path="thesis" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">所获奖项：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:textarea class="textarea" placeholder="所获奖项" path="awards"></form:textarea>
            </div>
        </div>
        <c:if test="${not empty teacher.id}">
            <div class="row cl">
                <label class="form-label col-xs-4 col-sm-3">备注：</label>
                <div class="formControls col-xs-8 col-sm-9">
                    <form:textarea class="textarea" placeholder="备注" path="remarks"></form:textarea>
                </div>
            </div>
        </c:if>
        <c:if test="${empty teacher.id}">
            <div class="row cl">
                <label class="form-label col-xs-4 col-sm-3">设置登录信息</label>
            </div>
            <form:hidden path="user.name" />
            <div class="row cl">
                <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>用户名:</label>
                <div class="formControls col-xs-8 col-sm-9">
                    <form:input type="text" class="input-text required" placeholder="用户名" path="user.loginName" />
                </div>
            </div>
            <div class="row cl">
                <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>邮箱:</label>
                <div class="formControls col-xs-8 col-sm-9">
                    <form:input type="text" class="input-text required" placeholder="邮箱" path="user.email" />
                </div>
            </div>
            <div class="row cl">
                <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>密码:</label>
                <div class="formControls col-xs-8 col-sm-9">
                    <form:input type="password" class="input-text required" path="user.newPassword" />
                </div>
            </div>
            <div class="row cl">
                <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>确认密码:</label>
                <div class="formControls col-xs-8 col-sm-9">
                    <input type="password" class="input-text required" id="confirmNewPassword" name="confirmNewPassword">
                </div>
            </div>
            <div class="row cl">
                <label class="form-label col-xs-4 col-sm-3">允许登录:</label>
                <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                    <div class="radio-box">
                        <form:radiobutton path="user.loginFlag" value="1"/>
                        <label>允许</label>
                    </div>
                    <div class="radio-box">
                        <form:radiobutton path="user.loginFlag" value="0"/>
                        <label>禁止</label>
                    </div>
                </div>
            </div>
            <div class="row cl">
                <label class="form-label col-xs-4 col-sm-3">角色：</label>
                <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                    <select class="select required" size="1" id="user.roleIdList" name="user.roleIdList" multiple="multiple">
                        <option value="">请选择</option>
                        <c:forEach items="${allRoles}" var="role">
                            <option value="${role.id}">${role.name}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="row cl">
                <label class="form-label col-xs-4 col-sm-3">备注：</label>
                <div class="formControls col-xs-8 col-sm-9">
                    <form:textarea class="textarea" placeholder="备注" path="user.remarks"></form:textarea>
                </div>
                <form:hidden path="remarks"/>
            </div>
        </c:if>
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
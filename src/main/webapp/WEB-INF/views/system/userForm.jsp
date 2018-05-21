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

            $("#userForm").validate({
                rules:{
                    name:{
                        required:true,
                        ChsEnNum:true,
                        maxlength:16
                    },
                    loginName:{
                        EnNum:true,
                        required:true,
                        remote:{
                            url:'${ctx}/sys/user/checkLoginName?oldLoginName='+$("#oldLoginName").val()
                        },
                        maxlength:20
                    },
                    confirmNewPassword:{
                        equalTo:'#newPassword'
                    },
                    email:{
                        email:true
                    },
                    newPassword:{
                        maxlength:12
                    }
                },
                messages:{
                  loginName:{
                      remote:'该用户名已存在'
                  },
                    confirmNewPassword:{
                      equalTo:'密码输入不一致'
                    }
                },
                onkeyup:false,
                focusCleanup:true,
                success:"valid",
                submitHandler:function(form){
                    submitForm(form);
                }
            });

            initSelectRoles();
        })

        function initSelectRoles(){
            var roleIds = '${user.roleIds}' ;
            if(roleIds != ''){
                var arr = roleIds.split(",");
                $("#roleIdList").select2('val',arr) ;
            }
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
    <form:form action="${ctx}/sys/user/save" modelAttribute="user" method="post" class="form form-horizontal" id="userForm">
        <form:hidden path="id"/>
        <div class="row cl">
            <form:hidden path="oldLoginName" value="${user.loginName}"/>
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>用户名:</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="用户名" path="loginName" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>姓名:</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="姓名" path="name" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>邮箱:</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="邮箱" path="email" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">密码:</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="password" class="input-text" path="newPassword" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">确认密码:</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input type="password" class="input-text" id="confirmNewPassword" name="confirmNewPassword" >
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">允许登录:</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <div class="radio-box">
                    <form:radiobutton path="loginFlag" value="1"/>
                    <label>允许</label>
                </div>
                <div class="radio-box">
                    <form:radiobutton path="loginFlag" value="0"/>
                    <label>禁止</label>
                </div>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">角色：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <select class="select" size="1" id="roleIdList" name="roleIdList" multiple="multiple" style="width: 200px">
                    <c:forEach items="${allRoles}" var="role">
                        <option value="${role.id}">${role.name}</option>
                    </c:forEach>
                </select>
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
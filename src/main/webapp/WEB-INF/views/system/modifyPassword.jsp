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
                removeIframe();
                /*var index = parent.layer.getFrameIndex(window.name);
                parent.layer.close(index);*/
            });

            $('.skin-minimal input').iCheck({
                checkboxClass: 'icheckbox-blue',
                radioClass: 'iradio-blue',
                increaseArea: '20%'
            });

            $("#userForm").validate({
                onsubmit:function(element) { $(element).valid(); },
                rules:{
                    newPassword:{
                        maxlength:12
                    }
                },
                messages:{
                    confirmPassword:{
                      equalTo:'输入密码不一致'
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
            $.ajax({
                type:'POST',
                url:url,
                data:data,
                success:function(data){
                    if('00000000'==data.rtnCode){
                        layer.msg(data.rtnMsg,{time:1000})
                        setTimeout(function(){
                            window.location.href ='${ctx}/logout';
                        },1000);

                    }else{
                        layer.msg(data.rtnMsg);
                    }
                },
                error:function(){
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
    <form action="${ctx}/sys/user/modifyPwd"  method="post" class="form form-horizontal" id="userForm">
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>旧密码：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input type="password" class="input-text required"id="oldPassword" name="oldPassword" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>新密码：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input type="password" class="input-text required"id="newPassword" name="newPassword" />
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>确认密码：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input type="password" class="input-text required " equalTo="#newPassword" id="confirmPassword" name="confirmPassword" />
            </div>
        </div>
        <div class="row cl">
            <div class="col-xs-8 col-sm-9 col-xs-offset-4 col-sm-offset-3">
                <input class="btn btn-primary radius" type="submit" value="&nbsp;&nbsp;提交&nbsp;&nbsp;">
                <input class="btn btn-default radius" type="button" id="back_btn" value="&nbsp;&nbsp;关闭&nbsp;&nbsp;">
            </div>
        </div>
    </form>
</article>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <meta name="decorator" content="blank"/>
    <title>教师管理系统-登录</title>
    <link href="${ctxStatic}/h-ui.admin/css/H-ui.login.css" type="text/css" rel="stylesheet">
    <%@ include file="/WEB-INF/views/include/validation.jsp"%>
</head>
<body>
<img src="${ctxStatic}/images/login-bg.png" class="login_bg">
<div id="main">
    <div class="header">
        <h1>${fns:getConfig('productName')}</h1>
    </div>
    <div class="loginWraper">
        <div class="loginBox">
            <form id="loginForm" class="form form-horizontal" action="${ctx}/login" method="post">
                <div class="row cl">
                    <label class="form-label col-xs-3" style="color: #FFFFFF"><i class="Hui-iconfont">&#xe60d;</i></label>
                    <div class="formControls col-xs-6">
                        <input id="username" name="username" type="text" placeholder="用户名" value="${username}" class="input-text size-L">
                    </div>
                    <div class="formControls col-xs-3"></div>
                </div>
                <div class="row cl">
                    <label class="form-label col-xs-3" style="color: #FFFFFF"><i class="Hui-iconfont">&#xe60e;</i></label>
                    <div class="formControls col-xs-6">
                        <input id="password" name="password" type="password" placeholder="密码" class="input-text size-L">
                    </div>
                    <div class="formControls col-xs-3"></div>
                </div>
                <c:if test="${isValidateCodeLogin}">
                <div class="row cl">
                    <div class="formControls col-xs-6 col-xs-offset-3">
                        <input class="input-text size-L" type="text" name="validateCode" placeholder="验证码" value="" style="width:150px;">
                        <img class="validateCode" src="${pageContext.request.contextPath}/servlet/validateCodeServlet" onclick="$('.validateCodeRefresh').click();"/>
                        <a href="javascript:"
                           onclick="$('.validateCode').attr('src','${pageContext.request.contextPath}/servlet/validateCodeServlet?'+new Date().getTime());"
                           class="validateCodeRefresh">看不清</a>
                    </div>
                    <div class="formControls col-xs-3"></div>
                </div>
                </c:if>
                <div class="row cl">
                    <div class="formControls col-xs-8 col-xs-offset-3">
                        <label for="rememberMe" style="color: #FFFFFF">
                            <input type="checkbox" id="rememberMe" name="rememberMe" ${rememberMe ? 'checked' : ''} />
                            使我保持登录状态</label>
                    </div>
                </div>
                <div class="row cl">
                    <div class="formControls col-xs-5 col-xs-offset-3">
                        <input name="" type="submit" class="btn btn-success radius size-L" value="&nbsp;登&nbsp;&nbsp;&nbsp;&nbsp;录&nbsp;">
                        <input name="" type="reset" style="margin-top: 1px" class="btn btn-default radius size-L" value="&nbsp;重&nbsp;&nbsp;&nbsp;&nbsp;置&nbsp;">
                    </div>
                    <div class="formControls col-xs-4 class="${empty message ? 'hide' : ''}"">
                    <label class="error">${message}</label>
                </div>
        </div>
        </form>
    </div>
    <div class="footer">
    Copyright &copy; ${fns:getConfig('copyrightYear')} ${fns:getConfig('productName')} - Powered By 陈雅梨 ${fns:getConfig('version')}
</div>
</div>
<script type="text/javascript">

    $(function() {

        init();

        $("#loginForm").validate({
            onsubmit:function(element) { $(element).valid(); },
            rules: {
                validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"},
                username:{required:true},password:{required:true}
            },
            messages: {
                username: {required: "请填写用户名"},password: {required: "请填写密码"},
                validateCode: {remote: "验证码不正确", required: "请填写验证码"}
            },
            errorPlacement: function(error, element) {
                error.appendTo(element.parent().next());
            }
        });
    });

    function init(){
        var length = window.parent.length ;
        if(length>0){
            var obj  = window ;
            for(var i=0 ; i<length ; i++){
                obj = obj.parent ;
            }
            obj.location.reload();
        }
    }
</script>
</body>
</html>
<%
    response.setStatus(500);

// 获取异常类
    Throwable ex = Exceptions.getThrowable(request);
    if (ex != null) {
        LoggerFactory.getLogger("500.jsp").error(ex.getMessage(), ex);
    }

// 编译错误信息
    StringBuilder sb = new StringBuilder("错误信息：\n");
    if (ex != null) {
        sb.append(Exceptions.getStackTraceAsString(ex));
    } else {
        sb.append("未知错误.\n\n");
    }

// 如果是异步请求或是手机端，则直接返回信息
    if (Servlets.isAjaxRequest(request)) {
        out.print(sb);
    }

// 输出异常信息页面
    else {
%>
<%@page import="org.slf4j.Logger,org.slf4j.LoggerFactory" %>
<%@page import="com.cyl.manage.common.web.Servlets" %>
<%@page import="com.cyl.manage.common.utils.Exceptions" %>
<%@page import="com.cyl.manage.common.utils.StringUtils" %>
<%@page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <script src="${ctxStatic}/h-ui/js/jquery.min.js" type="text/javascript"></script>
    <!--[if lt IE 9]>
    <script type="text/javascript" src="${ctxStatic}/js/html5shiv.js"></script>
    <script type="text/javascript" src="${ctxStatic}/js/respond.min.js"></script>
    <![endif]-->
    <link href="${ctxStatic}/Hui-iconfont/1.0.8/iconfont.css" rel="stylesheet" type="text/css" />
    <link href="${ctxStatic}/h-ui/css/H-ui.min.css" rel="stylesheet" type="text/css" />
    <link href="${ctxStatic}/h-ui.admin/css/H-ui.admin.css" rel="stylesheet" type="text/css" />
    <!--[if IE 6]>
    <script type="text/javascript" src="${ctxStatic}/DD_belatedPNG_0.0.8a-min.js" ></script>
    <script>DD_belatedPNG.fix('*');</script>
    <![endif]-->
    <title>500页面</title>
</head>
<body>
<section class="container-fluid page-404 minWP text-c">
    <p class="error-title"><i class="Hui-iconfont va-m" style="font-size:80px">&#xe688;</i>
        <span class="va-m"> 500</span>
    </p>
    <p class="error-description">诶~ 系统好像有点小问题</p>
    <p class="error-info">您可以：
         <a href="javascript:;" onclick="history.go(-1)" class="c-primary">&lt; 返回上一页</a>
         <span class="ml-20">|</span>
         <a onclick="$('.errorMessage').toggle();" class="c-primary ml-20">查看详细信息 &gt;</a>
     </p>
    <div class="errorMessage hide text-l" style="margin-left: 10%">
        <%=StringUtils.toHtml(sb.toString())%> <br/>
        <a href="javascript:" onclick="$('.errorMessage').toggle();" class="btn">隐藏详细信息</a>
        <br/> <br/>
    </div>
</section>
</body>
</html>

<%
    }
    out = pageContext.pushBody();
%>
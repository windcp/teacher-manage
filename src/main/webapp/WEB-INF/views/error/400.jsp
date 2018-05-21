<%@page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>
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
    <title>400页面</title>
</head>
<body>
<section class="container-fluid page-404 minWP text-c">
    <p class="error-title"><i class="Hui-iconfont va-m" style="font-size:80px">&#xe688;</i>
        <span class="va-m"> 400</span>
    </p>
    <p class="error-description">请求参数出错</p>
    <p class="error-info">您可以：
        <a href="javascript:;" onclick="history.go(-1)" class="c-primary">返回上一页</a>
    </p>
</section>
</body>
</html>

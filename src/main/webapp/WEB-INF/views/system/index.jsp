<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <meta name="decorator" content="blank"/>
    <title>教师管理系统</title>
</head>
<body>
<header class="navbar-wrapper">
    <div class="navbar navbar-fixed-top">
        <div class="container-fluid cl"> <a class="logo navbar-logo f-l mr-10 hidden-xs">教师管理系统</a>
            <nav id="Hui-userbar" class="nav navbar-nav navbar-userbar hidden-xs">
                <ul class="cl">
                    <li class="dropDown dropDown_hover"> <a href="#" class="dropDown_A">欢迎, ${fns:getUser().name} <i class="Hui-iconfont">&#xe6d5;</i></a>
                        <ul class="dropDown-menu menu radius box-shadow">
                            <%--<li><a href="#">个人信息</a></li>--%>
                            <li><a data-href="${ctx}/sys/user/modifyPwd" data-title="修改密码" onclick="Hui_admin_tab(this)" href="javascript:void(0)">修改密码</a></li>
                            <li><a href="${ctx}/logout">退出</a></li>
                        </ul>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</header>
<aside class="Hui-aside">
    <div id="menu-aside" class="menu_dropdown bk_2">
        <c:forEach items="${fns:getFirstMenuList()}" var="menu" varStatus="status">
            <dl id="${menu.id}">
                <dt><i class="Hui-iconfont">${menu.icon}</i> ${menu.name}<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
                <dd>
                    <c:forEach items="${fns:getSecondMenuList(menu.id)}" var="secondMenu" varStatus="stu">
                            <ul>
                                <li><a data-first="${menu.name}" data-second="${secondMenu.name}" data-href="${ctx}${secondMenu.href}" data-title="${secondMenu.name}" href="javascript:void(0)"><i class="Hui-iconfont">${secondMenu.icon}</i> ${secondMenu.name}</a></li>
                            </ul>
                    </c:forEach>
                </dd>
            </dl>
        </c:forEach>
    </div>
</aside>
<div class="dislpayArrow hidden-xs"><a class="pngfix" href="javascript:void(0);" onClick="displaynavbar(this)"></a></div>
<section class="Hui-article-box">
    <div id="Hui-tabNav" class="Hui-tabNav hidden-xs">
        <div class="Hui-tabNav-wp">
            <ul id="min_title_list" class="acrossTab cl">
            </ul>
        </div>
        <div class="Hui-tabNav-more btn-group"><a id="js-tabNav-prev" class="btn radius btn-default size-S" href="javascript:;"><i class="Hui-iconfont">&#xe6d4;</i></a><a id="js-tabNav-next" class="btn radius btn-default size-S" href="javascript:;"><i class="Hui-iconfont">&#xe6d7;</i></a></div>
    </div>
    <div id="iframe_box" class="Hui-article">
    </div>
</section>

<div class="contextMenu" id="Huiadminmenu">
    <ul>
        <li id="closethis">关闭当前 </li>
        <li id="closeall">关闭全部 </li>
    </ul>
</div>

<!--请在下方写此页面业务相关的脚本-->
<script type="text/javascript" src="${ctxStatic}/jquery-contextmenu/jquery.contextmenu.r2.js"></script>
<script type="text/javascript">
    $(function(){
           openFirstMenu();
    });

    function openFirstMenu(){
        $("#menu-aside").find("i").eq(0).trigger("click");
        $("#menu-aside").find("a").eq(0).trigger("click") ;
    }
    /*个人信息*/
    function myselfinfo(){
        layer.open({
            type: 1,
            area: ['300px','200px'],
            fix: false, //不固定
            maxmin: true,
            shade:0.4,
            title: '查看信息',
            content: '<div>个人信息</div>'
        });
    }




</script>
</body>
</html>

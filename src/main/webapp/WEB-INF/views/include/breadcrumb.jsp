<%@ page contentType="text/html;charset=UTF-8" %>
<nav class="breadcrumb">
    <i class="Hui-iconfont">&#xe67f;</i> 首页 <span class="c-gray en first-menu">&gt;</span>
     <script type="text/javascript">
         document.write(self.frameElement.getAttribute('data-first'))
     </script>
    <span class="c-gray en second-menu">&gt;</span>
    <script type="text/javascript">
        document.write(self.frameElement.getAttribute('data-second'))
    </script>
    <a class="btn btn-success radius r btn-refresh" style="line-height:1.6em;margin-top:3px" href="javascript:location.replace(location.href);" title="刷新" >
        <i class="Hui-iconfont">&#xe68f;</i>
    </a>
</nav>

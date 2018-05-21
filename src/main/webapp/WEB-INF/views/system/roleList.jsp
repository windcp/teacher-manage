<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>角色列表</title>
    <meta name="decorator" content="blank"/>
    <script type="text/javascript">

        $(document).ready(function() {

            $("#add_btn").click(function(){
                var title = '添加角色';
                var url = "${ctx}/sys/role/form";
                layer_show_full(title,url);
            })

        })

        function save(id){
            var title = '编辑角色';
            var url = "${ctx}/sys/role/form?id="+id;
            layer_show_full(title,url);
        }

        function del(id){
            layer.confirm('确定要删除吗？',{
                btn:['确定','取消']
            },function(index,layero){
                $.ajax({
                    type:"GET",
                    url:"${ctx}/sys/role/delete?id="+id,
                    success:function(data){
                        if("00000000"==data.rtnCode){
                            layer.msg(data.rtnMsg,{time:1000});
                            setTimeout(function(){
                                layer.close(index);
                                location.replace(location.href);
                            },1000)
                        }else{
                            layer.msg(rtnMsg);
                        }
                    },
                    error:function(){
                        layer.close(index);
                        layer.msg("操作异常 ，请稍后重试") ;
                    }
                });
            },function(){});
        }

    </script>

    <style type="text/css">

    </style>
</head>
<body>
<%@include file="/WEB-INF/views/include/breadcrumb.jsp"%>
<div class="page-container">
    <div class="cl pd-5 bg-1 bk-gray"> <span class="l"> <a class="btn btn-primary radius" href="javascript:;" id="add_btn"><i class="Hui-iconfont">&#xe600;</i> 添加角色</a> </span> </div>
    <table  class="table table-border table-bordered table-hover table-bg">
        <thead>
        <tr class="text-c">
            <td>角色名称</td><td>英文名称</td><shiro:hasPermission name="sys:role:edit"><td>操作</td></shiro:hasPermission>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="role">
            <tr class="text-c">
                <td>${role.name}</td>
                <td>${role.enname}</td>
                <shiro:hasPermission name="sys:role:edit">
                    <td class="f-14">
                        <a title="编辑" style="text-decoration:none" onclick="save('${role.id}')"><i class="Hui-iconfont">&#xe6df;</i></a>
                        <a title="删除" style="text-decoration:none" onclick="del('${role.id}')"><i class="Hui-iconfont">&#xe6e2;</i></a>
                    </td>
                </shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
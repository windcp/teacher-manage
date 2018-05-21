<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜单管理</title>
	<meta name="decorator" content="blank"/>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
        $(function(){

            $("#treeTable").treeTable({expandLevel : 2}).show();

        });

        function addMenu(){
            var title = '添加菜单';
            var url = "${ctx}/sys/menu/form";
            layer_show_full(title,url);
		}

        function editMenu(id){
            var title = '编辑菜单';
            var url = "${ctx}/sys/menu/form?id="+id;
            layer_show_full(title,url);
		}

		function deleteMenu(id){
            layer.confirm('确定要删除吗？',{
                btn:['确定','取消']
            },function(index,layero){
                $.ajax({
					type:"GET",
					url:"${ctx}/sys/menu/delete?id="+id,
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

		function addChildMenu(parentId){
            var title = '添加子级菜单';
            var url = "${ctx}/sys/menu/form?parent.id="+parentId;
            layer_show_full(title,url);
		}

	</script>
</head>
<body>
	<%@include file="/WEB-INF/views/include/breadcrumb.jsp"%>
	<div class="page-container">
		<div class="cl pd-5 bg-1 bk-gray"> <span class="l"> <a class="btn btn-primary radius" href="javascript:;" onclick="addMenu()"><i class="Hui-iconfont">&#xe600;</i> 添加菜单</a> </span> </div>
		<table id="treeTable" class="table table-border table-bordered table-hover table-bg">
			<thead>
				<tr class="text-c">
					<th>名称</th><th>链接</th><th style="text-align:center;">排序</th><th>可见</th><th>图标</th><th>权限标识</th><shiro:hasPermission name="sys:menu:edit"><th>操作</th></shiro:hasPermission>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${list}" var="menu">
					<tr class="text-c" id="${menu.id}" pid="${menu.parent.id ne '1'?menu.parent.id:'0'}">
						<td nowrap>${menu.name}</td>
						<td title="${menu.href}">${fns:abbr(menu.href,30)}</td>
						<td title="${menu.sort}" style="text-align:center;">
							${menu.sort}
						</td>
						<td><span class="label ${menu.isShow eq '1'?'label-success':''} raduis">${menu.isShow eq '1'?'显示':'隐藏'}</span></td>
						<td ><i class="Hui-iconfont" style="font-size: 24px">${menu.icon}</i></td>
						<td title="${menu.permission}">${fns:abbr(menu.permission,30)}</td>
						<shiro:hasPermission name="sys:menu:edit">
							<td class="f-14">
								<a title="编辑" style="text-decoration:none" onclick="editMenu('${menu.id}')"><i class="Hui-iconfont">&#xe6df;</i></a>
								<a title="删除" style="text-decoration:none" onclick="deleteMenu('${menu.id}')"><i class="Hui-iconfont">&#xe6e2;</i></a>
								<a title="添加下级菜单" style="text-decoration:none" onclick="addChildMenu('${menu.id}')"><i class="Hui-iconfont">&#xe604;</i></a>
							</td>
						</shiro:hasPermission>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>

</html>
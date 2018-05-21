<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta name="decorator" content="blank"/>
	<%@include file="/WEB-INF/views/include/bsTable.jsp"%>
	<script type="text/javascript" src="${ctxStatic}/laydate-v5.0.9/laydate.js"></script>
	<script type="text/javascript">
        var temp ;
        $(document).ready(function() {
            temp = {
				beginDate:$("#beginDate").val(),
				endDate:$("#endDate").val()
            };

			//执行一个laydate实例
			laydate.render({
				elem: '#beginDate', //指定元素
				type:'datetime',
                btns: ['now', 'confirm'],
				value:'${beginDate}'
			});

			//执行一个laydate实例
			laydate.render({
				elem: '#endDate', //指定元素
				type:'datetime',
                btns: ['now', 'confirm'],
                value:'${endDate}'
			});


            $("#search_btn").click(function(){
                temp = {
                    beginDate:$("#beginDate").val(),
                    endDate:$("#endDate").val(),
					requestUri:$("#requestUri").val(),
					title:$("#title").val(),
					type:$("#type").val(),
                    method:$("#method").val()
                }
                $("#logTable").bootstrapTable('refresh',{pageNum:1});
            })

            initTable();
        })

        function del(id){
            layer.confirm('确定要删除吗？',{
                btn:['确定','取消']
            },function(index,layero){
                $.ajax({
                    type:"GET",
                    url:"${ctx}/delete?id="+id,
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
            },function(){})
        }

        function initTable(){
            var url ="${ctx}/sys/log/getTableData" ;
            $("#logTable").bootstrapTable({
                method:'get',
                cache:'false',
                dataType:'JSON',
                pagination: true,
                pageNumber:1,
                pageSize: 10,
                pageList: [10,15,20],
                queryParams:requestParams,
                url:url,
                sidePagination:'server',
                search:false,
				escape:true,
                idField:'id',
                columns:[
                    {
                        field:'type',
                        title:'日志类型',
                        align:'center',
                        valign:'middle',
						formatter:function(value,row,index){
                            return value == '1' ? '接入日志':'错误日志'
                        }
                    },{
                        field:'title',
                        title:'操作菜单',
                        align:'center',
                        valign:'middle'
                    },{
                        field:'remoteAddr',
                        title:'IP地址',
                        align:'center',
                        valign:'middle'
                    },{
                        field:'requestUri',
                        title:'操作URI',
                        align:'center',
                        valign:'middle'
                    },{
                        field:'method',
                        title:'操作方式',
                        align:'center',
                        valign:'middle'
                    },{
                        field:'params',
                        title:'提交的数据',
						width:'20%',
                        align:'center',
                        valign:'middle'
                    },{
                        field:'exception',
                        title:'异常',
                        width:'20%',
                        align:'center',
                        valign:'middle',
                        formatter:function(value,row,index){
                            var e = '<div  style="overflow: hidden;display:-webkit-box;-webkit-box-orient: vertical;-webkit-line-clamp:3" title="'+value+'">'+value+'</div>';
                            return e;
                        }
                    },{
                        field:'createDate',
                        title:'时间',
                        align:'center',
                        valign:'middle'
                    }
                ]
            });
        }

        function requestParams(params){
            temp.pageNo = params.offset/params.limit+1 ;
            temp.pageSize = pageSize = params.limit ;
            return temp ;
        }

	</script>

	<style type="text/css">
		.table-box{
			margin:1% 0;
		}
		#logTable{
			display: table;
		}
		.breadcrumb{
			padding: 0 20px;
		}
	</style>
</head>
<body>
<%@include file="/WEB-INF/views/include/breadcrumb.jsp"%>
<div class="page-container">
	<div class="text-c">
		<form class="Huiform">
			URI: <input type="text" class="input-text" style="width:200px" placeholder="输入URI" id="requestUri" name="requestUri">
			&nbsp;&nbsp;&nbsp;&nbsp;
			操作菜单: <input type="text" class="input-text" style="width:200px" placeholder="输入标题" id="title" name="title">
			&nbsp;&nbsp;&nbsp;&nbsp;
			方式: <select class="select" size="1" id="method" name="method" style="width: 200px">
			<option value="">请选择</option>
			<option value="GET">GET</option>
			<option value="POST">POST</option>
		</select>
			&nbsp;&nbsp;&nbsp;&nbsp;
			类型: <select class="select" size="1" id="type" name="type" style="width: 200px">
			<option value="">请选择</option>
			<option value="1">接入日志</option>
			<option value="2">错误日志</option>
		</select>
			&nbsp;&nbsp;&nbsp;&nbsp;
			时间范围:<input type="text" class="input-text" style="width:200px"id="beginDate" name="beginDate">
			&nbsp;&nbsp;--&nbsp;&nbsp;
			<input type="text" class="input-text" style="width:200px"  id="endDate" name="endDate">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<button type="button" class="btn btn-success" id="search_btn"><i class="Hui-iconfont">&#xe665;</i> 搜索</button>
		</form>
	</div>
	<div class="table-box">
		<div id="logTable"></div>
	</div>
</div>
</body>
</html>


<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta name="decorator" content="blank"/>
    <%@include file="/WEB-INF/views/include/bsTable.jsp"%>
    <script type="text/javascript">
        var temp ;
        $(document).ready(function() {
            temp = {

            };

            $("#search_btn").click(function(){
                temp = {
                }
                $("#dictTable").bootstrapTable('refresh',{pageNum:1});
            })

            $("#add_btn").click(function(){
                var title = '添加';
                var url = "${ctx}/form";
                layer_show_full(title,url);
            })

            initTable();

        });

        function save(id){
            var title = '编辑';
            var url = "${ctx}/form?id="+id;
            layer_show_full(title,url);
        }

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
            var url ="${ctx}/teacher/getTableData" ;
            $("#dictTable").bootstrapTable({
                method:'get',
                cache:'false',
                dataType:'JSON',
                pagination: true,
                pageNumber:1,
                pageSize: 10,
                pageList: 'limit',
                queryParams:requestParams,
                url:url,
                sidePagination:'server',
                search:false,
                idField:'id',
                columns:[
                    {
                        field:'type',
                        title:'类型',
                        align:'center'
                    },{
                        field:'label',
                        title:'标签',
                        align:'center'
                    },{
                        field:'value',
                        title:'键值',
                        align:'center'
                    },{
                        field:'description',
                        title:'描述',
                        align:'center'
                    },{
                        field:'sort',
                        title:'排序',
                        align:'center'
                    },{
                        field:'operate',
                        title:'操作',
                        align:'center',
                        formatter:function(value,row,index){
                            var id = row.id ;
                            var e = '<shiro:hasPermission name="sys:user:edit"><a title="编辑" style="text-decoration:none" onclick="save(\''+id+'\')"><i class="Hui-iconfont">&#xe6df;</i></a></shiro:hasPermission> ';
                            var d = '<shiro:hasPermission name="sys:user:edit"><a title="删除" style="text-decoration:none"  onclick="del(\''+id+'\')"><i class="Hui-iconfont">&#xe6e2;</i></a></shiro:hasPermission>  ';
                            return e+d ;
                        }
                    }
                ]
            });
            var text = $("#add_btn").text() ;
            if('' == text || null == text ||'undefined' == text ){
                $("#dictTable").bootstrapTable('hideColumn','operate');
            }
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
        #dictTable{
            display: table;
        }
        .btn-primary{
            background-color: #5a98de;
            border-color: #5a98de;
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
                类型: <select class="select" size="1" id="type" name="type" style="width: 200px">
                <option value="">请选择</option>
                <c:forEach items="${typeList}" var="typ">
                    <option value="${typ}">${typ}</option>
                </c:forEach>
            </select>
                &nbsp;&nbsp;&nbsp;&nbsp;
                描述: <input type="text" class="input-text" style="width:200px" placeholder="输入类型" id="description" name="description">
                <button type="button" class="btn btn-success" id="search_btn"><i class="Hui-iconfont">&#xe665;</i> 搜索</button>
            </form>
        </div>
        <div class="table-box">
            <shiro:hasPermission name="sys:user:edit">
                <div class="cl pd-5 bg-1 bk-gray"> <span class="l"> <a class="btn btn-primary radius" href="javascript:;" id="add_btn"><i class="Hui-iconfont">&#xe600;</i> 添加字典</a> </span> </div>
            </shiro:hasPermission>
            <div id="dictTable"></div>
        </div>
    </div>
</body>
</html>
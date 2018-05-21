<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>课程列表</title>
    <meta name="decorator" content="blank"/>
    <%@include file="/WEB-INF/views/include/bsTable.jsp"%>
    <script type="text/javascript">
        var temp = {};
        $(document).ready(function() {

            $("#search_btn").click(function(){
                temp = {
                    name:$("#name").val(),
                    term:$("#term").val()
                }
                $("#courseTable").bootstrapTable('refresh',{pageNum:1});
            })

            $("#add_btn").click(function(){
                var title = '添加课程';
                var url = "${ctx}/course/form";
                layer_show_full(title,url);
            })

            initTable();

        });

        function save(id){
            var title = '编辑课程';
            var url = "${ctx}/course/form?id="+id;
            layer_show_full(title,url);
        }

        function del(id){
            layer.confirm('确定要删除吗？',{
                btn:['确定','取消']
            },function(index,layero){
                $.ajax({
                    type:"GET",
                    url:"${ctx}/course/delete?id="+id,
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
            var url ="${ctx}/course/getTableData" ;
            $("#courseTable").bootstrapTable({
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
                escape:true,
                search:false,
                idField:'id',
                columns:[
                    {
                        field:'name',
                        title:'课程名',
                        align:'center'
                    },{
                        field:'term',
                        title:'开课学期',
                        align:'center'
                    },{
                        field:'credit',
                        title:'学分',
                        align:'center'
                    },{
                        field:'classRoom',
                        title:'教室',
                        align:'center'
                    },{
                        field:'amount',
                        title:'人数',
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
                $("#userTable").bootstrapTable('hideColumn','operate');
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
        #courseTable{
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
            课程: <input type="text" class="input-text" style="width:200px" placeholder="输入课程名" id="name" name="name">
            &nbsp;&nbsp;&nbsp;&nbsp;
            开课学期: <select class="select" size="1" id="term" name="term" style="width: 200px">
            <option value="">请选择</option>
            <c:forEach items="${termList}" var="tem">
                <option value="${tem.label}">${tem.label}</option>
            </c:forEach>
        </select>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" class="btn btn-success" id="search_btn"><i class="Hui-iconfont">&#xe665;</i> 搜索</button>
        </form>
    </div>
    <div class="table-box">
        <shiro:hasPermission name="sys:user:edit">
            <div class="cl pd-5 bg-1 bk-gray"> <span class="l"> <a class="btn btn-primary radius" href="javascript:;" id="add_btn"><i class="Hui-iconfont">&#xe600;</i> 添加课程</a> </span> </div>
        </shiro:hasPermission>
        <div id="courseTable"></div>
    </div>
</div>
</body>
</html>
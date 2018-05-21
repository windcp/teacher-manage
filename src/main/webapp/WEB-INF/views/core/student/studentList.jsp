<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生列表</title>
    <meta name="decorator" content="blank"/>
    <%@include file="/WEB-INF/views/include/bsTable.jsp"%>
    <script type="text/javascript">
        var temp = {};
        $(document).ready(function() {

            $("#search_btn").click(function(){
                temp = {
                    classesId:$("#classes").val(),
                    studentNo:$("#studentNo").val()
                }
                $("#studentTable").bootstrapTable('refresh',{pageNum:1});
            })

            $("#add_btn").click(function(){
                var title = '添加学生';
                var url = "${ctx}/student/form";
                layer_show_full(title,url);
            })

            initTable();

        });

        function save(id){
            var title = '编辑学生';
            var url = "${ctx}/student/form?id="+id;
            layer_show_full(title,url);
        }

        function del(id){
            layer.confirm('确定要删除吗？',{
                btn:['确定','取消']
            },function(index,layero){
                $.ajax({
                    type:"GET",
                    url:"${ctx}/student/delete?id="+id,
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
            var url ="${ctx}/student/getTableData" ;
            $("#studentTable").bootstrapTable({
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
                        title:'姓名',
                        align:'center'
                    },{
                        field:'studentNo',
                        title:'学号',
                        align:'center'
                    },{
                        field:'classes.name',
                        title:'班级',
                        align:'center'
                    },{
                        field:'age',
                        title:'年龄',
                        align:'center'
                    },{
                        field:'sex',
                        title:'性别',
                        align:'center',
                        formatter:function(value,row,index){
                            var sex = '-' ;
                            if(value == '1'){sex = '男'}
                            else if(value == '2'){sex = '女'}
                            else{sex = '未知'} ;
                            return sex ;
                        }
                    },{
                        field:'point',
                        title:'总绩点',
                        align:'center'
                    },{
                        field:'grades',
                        title:'总学分',
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
        #studentTable{
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
            班级: <select class="select" size="1" id="classes" name="classes" style="width: 200px">
            <option value="">请选择</option>
            <c:forEach items="${classesList}" var="classes">
                <option value="${classes.id}">${classes.name}</option>
            </c:forEach>
        </select>
            &nbsp;&nbsp;&nbsp;&nbsp;
            学号: <input type="text" class="input-text" style="width:200px" placeholder="输入学号" id="studentNo" name="studentNo">
         <%--   &nbsp;&nbsp;&nbsp;&nbsp;
            开课学期: <select class="select" size="1" id="term" name="term" style="width: 200px">
            <option value="">请选择</option>
            <c:forEach items="${termList}" var="tem">
                <option value="${tem.label}">${tem.label}</option>
            </c:forEach>
        </select>--%>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" class="btn btn-success" id="search_btn"><i class="Hui-iconfont">&#xe665;</i> 搜索</button>
        </form>
    </div>
    <div class="table-box">
        <shiro:hasPermission name="sys:user:edit">
            <div class="cl pd-5 bg-1 bk-gray"> <span class="l"> <a class="btn btn-primary radius" href="javascript:;" id="add_btn"><i class="Hui-iconfont">&#xe600;</i> 添加学生</a> </span> </div>
        </shiro:hasPermission>
        <div id="studentTable"></div>
    </div>
</div>
</body>
</html>
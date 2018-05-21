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
        var orderBy = 'desc';
        $(document).ready(function() {
            temp = {
                orderBy:orderBy,
                studentNo:$("#studentNo").val(),
                studentName:$("#studentName").val()
            };

            $('#switch').on('switch-change', function (e, data) {
                var $el = $(data.el), value = data.value;
                //console.log(e, $el, value);
                orderBy = (value == true) ? 'desc':'asc';
            });

            $("#ranking_btn").click(function(){
                var load = layer.load(3,{shade: [0.3, '#000']});
                $.ajax({
                    type:"GET",
                    url:"${ctx}/grade/updateRanking",
                    success:function(data){
                        layer.close(load);
                        if("00000000"==data.rtnCode){
                            layer.msg(data.rtnMsg,{time:1000});
                            setTimeout(function(){
                                $("#gradeTable").bootstrapTable('refresh',{pageNum:1});
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
            });

            $("#export_btn").click(function(){
                var load = layer.load(3,{shade: [0.3, '#000']});
                $.ajax({
                    url:'${ctx}/grade/exportForExcel' ,
                    type:'POST',
                    data:temp,
                    success:function(data){
                        layer.close(load);
                        if('00000000'==data.rtnCode){
                            window.location.href = '${ctx}/grade/downloadExcel?url='+data.rtnData.url;
                        }else{
                            layer.msg(data.rtnMsg);
                        }
                    },
                    error:function(){
                        layer.close(load);
                        layer.msg('操作异常 , 请稍后再试',{time:1000});
                    }
                });
            });

            $("#search_btn").click(function(){
                temp = {
                    orderBy:orderBy,
                    'student.studentNo':$("#studentNo").val(),
                    'student.name':$("#studentName").val(),
                    'classes.id':$("#classes").val()
                }
                $("#gradeTable").bootstrapTable('refresh',{pageNum:1});
            })

            $("#add_btn").click(function(){
                var title = '添加成绩';
                var url = "${ctx}/grade/form";
                layer_show_full(title,url);
            })

            initTable();

        });

        function save(id){
            var title = '编辑成绩';
            var url = "${ctx}/grade/form?id="+id;
            layer_show_full(title,url);
        }

        function del(id){
            layer.confirm('确定要删除吗？',{
                btn:['确定','取消']
            },function(index,layero){
                $.ajax({
                    type:"GET",
                    url:"${ctx}/grade/delete?id="+id,
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
            var url ="${ctx}/grade/getTableData" ;
            $("#gradeTable").bootstrapTable({
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
                        field:'student.studentNo',
                        title:'学号',
                        align:'center'
                    },{
                        field:'student.name',
                        title:'姓名',
                        align:'center'
                    },{
                        field:'classes.name',
                        title:'班级',
                        align:'center'
                    },{
                        field:'course.name',
                        title:'课程',
                        align:'center'
                    },{
                        field:'paperScore',
                        title:'卷面分',
                        align:'center'
                    },{
                        field:'extraScore',
                        title:'平时分',
                        align:'center'
                    },{
                        field:'amount',
                        title:'总分',
                        align:'center'
                    },{
                        field:'ranking',
                        title:'排名',
                        align:'center'
                    },{
                        field:'point',
                        title:'获得绩点',
                        align:'center'
                    },{
                        field:'credit',
                        title:'获得学分',
                        align:'center'
                    },{
                        field:'operate',
                        title:'操作',
                        align:'center',
                        formatter:function(value,row,index){
                            var id = row.id ;
                            var e = '<shiro:hasPermission name="grade:edit"><a title="编辑" style="text-decoration:none" onclick="save(\''+id+'\')"><i class="Hui-iconfont">&#xe6df;</i></a></shiro:hasPermission> ';
                            var d = '<shiro:hasPermission name="grade:edit"><a title="删除" style="text-decoration:none"  onclick="del(\''+id+'\')"><i class="Hui-iconfont">&#xe6e2;</i></a></shiro:hasPermission>  ';
                            return e+d ;
                        }
                    }
                ]
            });
            var text = $("#add_btn").text() ;
            if('' == text || null == text ||'undefined' == text ){
                $("#gradeTable").bootstrapTable('hideColumn','operate');
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
        #gradeTable{
            display: table;
        }
        .btn-primary{
            background-color: #5a98de;
            border-color: #5a98de;
        }
        .breadcrumb{
            padding: 0 20px;
        }
        .has-switch span.switch-right{
            color:#000000;
            background: #fbb450;
        }
        .has-switch span.switch-right:hover{
            color:#000000;
            background: #fbb450;
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
            学号: <input type="text" class="input-text" style="width:200px" placeholder="输入学号" id="studentNo" name="grade.student.studentNo">
            &nbsp;&nbsp;&nbsp;&nbsp;
            姓名: <input type="text" class="input-text" style="width:200px" placeholder="输入姓名" id="studentName" name="grade.student.studentName">
            <%--课程: <select class="select" size="1" id="course" name="course" style="width: 200px">
            <option value="">请选择</option>
            <c:forEach items="${courseList}" var="cour">
                <option value="${cour.id}">${cour.name}</option>
            </c:forEach>
        </select>--%>
            &nbsp;&nbsp;&nbsp;&nbsp;
            总分:
            <div id="switch" class="switch"  style="top:10px;" data-on-label="从高到底" data-off-label="从低到高">
                <input type="checkbox" checked />
            </div>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" class="btn btn-success" id="search_btn"><i class="Hui-iconfont">&#xe665;</i> 搜索</button>
            <a class="btn btn-success" href="${ctx}/grade/test?test=sdasd"><i class="Hui-iconfont">&#xe665;</i> 测试</a>
        </form>
    </div>
    <div class="table-box">
        <shiro:hasPermission name="grade:edit">
            <div class="cl pd-5 bg-1 bk-gray">
                <shiro:hasRole name="teacher">
                <span class="l"> <a class="btn btn-primary radius" href="javascript:;" id="add_btn"><i class="Hui-iconfont">&#xe600;</i> 添加成绩</a> </span>
                </shiro:hasRole>
                <span class="l" style="margin-left: 5px"> <a class="btn btn-secondary radius" href="javascript:;" id="ranking_btn"><i class="Hui-iconfont">&#xe675;</i> 更新排名</a> </span>
                <span class="l" style="margin-left: 5px"> <a class="btn btn-success radius" href="javascript:;" id="export_btn"><i class="Hui-iconfont">&#xe640;</i> 导出成绩</a> </span>
            </div>
        </shiro:hasPermission>
        <div id="gradeTable"></div>
    </div>
</div>
</body>
</html>
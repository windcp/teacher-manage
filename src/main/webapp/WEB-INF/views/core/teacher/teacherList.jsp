<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta name="decorator" content="blank"/>
    <%@include file="/WEB-INF/views/include/bsTable.jsp"%>
    <script type="text/javascript">
        var temp = {} ;
        $(document).ready(function() {

            $("#search_btn").click(function(){
                temp = {
                    name:$("#name").val(),
                    sex:$("#sex").val(),
                    education:$("#education").val(),
                    identity:$("#identity").val()
                }
                $("#teacherTable").bootstrapTable('refresh',{pageNum:1});
            })

            $("#add_btn").click(function(){
                var title = '添加教师';
                var url = "${ctx}/teacher/form";
                layer_show_full(title,url);
            })

            initTable();

        });

        function comment(id){
            var title = '评价';
            var url = "${ctx}/evaluation/form?id="+id;
            layer_show_full(title,url);
        }

        function save(id){
            var title = '编辑教师';
            var url = "${ctx}/teacher/form?id="+id;
            layer_show_full(title,url);
        }

        function del(id){
            layer.confirm('确定要删除吗？',{
                btn:['确定','取消']
            },function(index,layero){
                $.ajax({
                    type:"GET",
                    url:"${ctx}/teacher/delete?id="+id,
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
            $("#teacherTable").bootstrapTable({
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
                        field:'name',
                        title:'姓名',
                        align:'center'
                    },{
                        field:'age',
                        title:'年龄',
                        align:'center'
                    },{
                        field:'sex',
                        title:'性别', //(1 : 男 ; 2:女; 3 : 未知)
                        align:'center',
                        formatter:function(value,row,index){
                            var sex = '-' ;
                            if(value == '1'){sex = '男'}
                            else if(value == '2'){sex = '女'}
                            else{sex = '未知'} ;
                            return sex ;
                        }
                    },{
                        field:'identity',
                        title:'身份',
                        align:'center'
                    },{
                        field:'phone',
                        title:'联系电话',
                        align:'center'
                    },{
                        field:'courses',
                        title:'教授课程',
                        align:'center'
                    },{
                        field:'classeses',
                        title:'教授班级',
                        align:'center'
                    },{
                        field:'education',
                        title:'学历',
                        align:'center'
                    },{
                        field:'thesis',
                        title:'论文发表',
                        align:'center'
                    },{
                        field:'awards',
                        title:'所获奖项',
                        align:'center'
                    },{
                        field:'evaluation.score',
                        title:'评价得分',
                        align:'center'
                    },{
                        field:'evaluation.ranking',
                        title:'排名',
                        align:'center'
                    },{
                        field:'operate',
                        title:'操作',
                        align:'center',
                        formatter:function(value,row,index){
                            var id = row.id ;
                            var commentId = (row.evaluation == null) ? '' : row.evaluation.id;
                            var e = '<shiro:hasPermission name="teacher:edit"><a title="编辑" style="text-decoration:none" onclick="save(\''+id+'\')"><i class="Hui-iconfont">&#xe6df;</i></a></shiro:hasPermission> ';
                            var f = '<shiro:hasPermission name="teacher:edit"><a title="评价" style="text-decoration:none" onclick="comment(\''+commentId+'\')"><i class="Hui-iconfont">&#xe622;</i></a></shiro:hasPermission> ';
                            var d = '<shiro:hasPermission name="teacher:edit"><a title="删除" style="text-decoration:none"  onclick="del(\''+id+'\')"><i class="Hui-iconfont">&#xe6e2;</i></a></shiro:hasPermission>  ';
                            return e+f+d ;
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
        #teacherTable{
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
            姓名: <input type="text" class="input-text" style="width:200px" placeholder="输入姓名" id="name" name="name">
            性别: <select id="sex" name="sex" class="select" size="1" style="width:150px">
                        <option value="">请选择</option>
                        <option value="1">男</option>
                        <option value="2">女</option>
                        <option value="3">未知</option>
                  </select>
            身份: <select id="identity" name="identity" class="select" size="1" style="width:150px">
                    <option value="">请选择</option>
                    <c:forEach items="${identityList}" var="ide">
                        <option value="${ide.label}">${ide.label}</option>
                    </c:forEach>
                </select>
            学历: <select id="education" name="education" class="select" size="1" style="width:150px">
                    <option value="">请选择</option>
                    <c:forEach items="${educationList}" var="edu">
                        <option value="${edu.label}">${edu.label}</option>
                    </c:forEach>
                </select>
            <button type="button" class="btn btn-success" id="search_btn"><i class="Hui-iconfont">&#xe665;</i> 搜索</button>
        </form>
    </div>
    <div class="table-box">
        <shiro:hasPermission name="teacher:edit">
                <div class="cl pd-5 bg-1 bk-gray"> <span class="l"> <a class="btn btn-primary radius" href="javascript:;" id="add_btn"><i class="Hui-iconfont">&#xe600;</i> 添加教师</a> </span> </div>
        </shiro:hasPermission>
        <div id="teacherTable"></div>
    </div>
</div>
</body>
</html>
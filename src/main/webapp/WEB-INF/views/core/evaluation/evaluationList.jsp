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
                'teacher.id':$("#teacherId").val()
            };

           $('#switch').on('switch-change', function (e, data) {
                var $el = $(data.el), value = data.value;
                //console.log(e, $el, value);
               orderBy = (value == true) ? 'desc':'asc';
            });

           $("#ranking_btn").click(function(){
               var load = layer.load({icon:1});
               $.ajax({
                   type:"GET",
                   url:"${ctx}/evaluation/updateRanking",
                   success:function(data){
                       layer.load(3,{shade: [0.3, '#000']});
                       if("00000000"==data.rtnCode){
                           layer.msg(data.rtnMsg,{time:1000});
                           setTimeout(function(){
                               $("#evaluationTable").bootstrapTable('refresh',{pageNum:1});
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

            $("#search_btn").click(function(){
                temp = {
                     orderBy:orderBy,
                    'teacher.id':$("#teacherId").val()
                }
                $("#evaluationTable").bootstrapTable('refresh',{pageNum:1});
            })

            $("#add_btn").click(function(){
                var title = '添加评价';
                var url = "${ctx}/evaluation/form";
                layer_show_full(title,url);
            })

            initTable();

        });

        function save(id){
            var title = '编辑评价';
            var url = "${ctx}/evaluation/form?id="+id;
            layer_show_full(title,url);
        }

        function del(id){
            layer.confirm('确定要删除吗？',{
                btn:['确定','取消']
            },function(index,layero){
                $.ajax({
                    type:"GET",
                    url:"${ctx}/evaluation/delete?id="+id,
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
            var url ="${ctx}/evaluation/getTableData" ;
            $("#evaluationTable").bootstrapTable({
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
                        field:'teacher.name',
                        title:'教师',
                        align:'center'
                    },{
                        field:'teachModel',
                        title:'讲课模式',
                        align:'center'
                    },{
                        field:'experimentManage',
                        title:'实验管理',
                        align:'center'
                    },{
                        field:'assignmentCorrecting',
                        title:'作业批改',
                        align:'center'
                    },{
                        field:'feedBack',
                        title:'课后反馈',
                        align:'center'
                    },{
                        field:'score',
                        title:'得分',
                        align:'center'
                    },{
                        field:'ranking',
                        title:'排名',
                        align:'center'
                    },{
                        field:'operate',
                        title:'操作',
                        align:'center',
                        formatter:function(value,row,index){
                            var id = row.id ;
                            var e = '<shiro:hasPermission name="evaluation:edit"><a title="编辑" style="text-decoration:none" onclick="save(\''+id+'\')"><i class="Hui-iconfont">&#xe6df;</i></a></shiro:hasPermission> ';
                            var d = '<shiro:hasPermission name="evaluation:edit"><a title="删除" style="text-decoration:none"  onclick="del(\''+id+'\')"><i class="Hui-iconfont">&#xe6e2;</i></a></shiro:hasPermission>  ';
                            return e+d ;
                        }
                    }
                ]
            });
            var text = $("#add_btn").text() ;
            if('' == text || null == text ||'undefined' == text ){
                $("#evaluationTable").bootstrapTable('hideColumn','operate');
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
        #evaluationTable{
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
        <form class="Huiform layui-form">
            教师: <select class="select" size="1" id="teacherId" name="teacherId" style="width: 200px">
            <option value="">请选择</option>
            <c:forEach items="${teacherList}" var="teacher">
                <option value="${teacher.id}">${teacher.name}</option>
            </c:forEach>
        </select>&nbsp;&nbsp;&nbsp;&nbsp;
            得分:
            <div id="switch" class="switch"  style="top:10px;" data-on-label="从高到低" data-off-label="从低到高">
                <input type="checkbox" checked />
            </div>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" class="btn btn-success" id="search_btn"><i class="Hui-iconfont">&#xe665;</i> 搜索</button>
        </form>
    </div>
    <div class="table-box">
        <shiro:hasPermission name="evaluation:edit">
            <div class="cl pd-5 bg-1 bk-gray">
                <span class="l"> <a class="btn btn-primary radius" href="javascript:;" id="add_btn"><i class="Hui-iconfont">&#xe600;</i> 添加评价</a> </span>
                <span class="l" style="margin-left: 5px"> <a class="btn btn-secondary radius" href="javascript:;" id="ranking_btn"><i class="Hui-iconfont">&#xe675;</i> 更新排名</a> </span>
            </div>
        </shiro:hasPermission>
        <div id="evaluationTable"></div>
    </div>
</div>
</body>
</html>
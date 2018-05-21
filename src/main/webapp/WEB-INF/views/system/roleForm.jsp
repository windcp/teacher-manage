<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta name="decorator" content="blank"/>
    <%@ include file="/WEB-INF/views/include/validation.jsp"%>
    <%@ include file="/WEB-INF/views/include/treeview.jsp"%>
    <script type="text/javascript">
        var tree ;

        $(document).ready(function() {

            $("#back_btn").click(function(){
                var index = parent.layer.getFrameIndex(window.name);
                parent.layer.close(index);
            });

            $('.skin-minimal input').iCheck({
                checkboxClass: 'icheckbox-blue',
                radioClass: 'iradio-blue',
                increaseArea: '20%'
            });

            $("#roleForm").validate({
                rules:{
                    name:{
                        required:true,
                        maxlength:30,
                        isChinese:true,
                        remote:{
                            url:'${ctx}/sys/role/checkName?oldName='+$("#name").val()
                        }
                    },
                    enname:{
                        required:true,
                        maxlength:30,
                        isEnglish:true,
                        remote:{
                            url:'${ctx}/sys/role/checkEnname?oldEnname='+$("#enname").val()
                        }
                    }
                },
                messages:{
                  name:{
                      remote:'该角色名已存在'
                  },
                  enname:{
                      remote:'该英文名已存在'
                  }
                },
                onkeyup:false,
                focusCleanup:true,
                success:"valid",
                submitHandler:function(form){
                    submitForm(form);
                }
            });

            var setting = {check:{enable:true,nocheckInherit:true},view:{selectedMulti:false},
                data:{simpleData:{enable:true}},callback:{beforeClick:function(id, node){
                        tree.checkNode(node, !node.checked, true, true);
                        return false;
                    }}};

            // 用户-菜单
            var zNodes=[
                    <c:forEach items="${menuList}" var="menu">{id:"${menu.id}", pId:"${not empty menu.parent.id?menu.parent.id:0}", name:"${not empty menu.parent.id?menu.name:'权限列表'}"},
                </c:forEach>];
            // 初始化树结构
            tree = $.fn.zTree.init($("#menuTree"), setting, zNodes);
            // 不选择父节点
            tree.setting.check.chkboxType = { "Y" : "ps", "N" : "s" };
            // 默认选择节点
            var ids = "${role.menuIds}".split(",");
            for(var i=0; i<ids.length; i++) {
                var node = tree.getNodeByParam("id", ids[i]);
                try{tree.checkNode(node, true, false);}catch(e){}
            }
            // 默认展开全部节点
            tree.expandAll(true);

        })

        function submitForm(form){
            var ids = [], nodes =  tree.getCheckedNodes(true);
            for(var i=0; i<nodes.length; i++) {
                ids.push(nodes[i].id);
            }
            $("#menuIds").val(ids);
            var url = $(form).attr("action");
            var data = $(form).serialize() ;
            $.ajax({
                type:'POST',
                url:url,
                data:data,
                dataType:'JSON',
                success:function(data){
                    var index = parent.layer.getFrameIndex(window.name);
                    if('00000000'==data.rtnCode){
                        layer.msg(data.rtnMsg,{time:1000})
                        setTimeout(function(){
                            parent.location.replace(parent.location.href);
                            parent.layer.close(index);
                        },1000);

                    }else{
                        layer.msg(data.rtnMsg);
                    }
                },
                error:function(){
                    layer.msg('操作异常 ,请稍后重试');
                }
            })
        }

    </script>

    <style type="text/css">

    </style>
</head>
<body>
<article class="page-container">
    <form:form action="${ctx}/sys/role/save" modelAttribute="role" method="post" class="form form-horizontal" id="roleForm">
        <form:hidden path="id"/>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>名称：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="名称" path="name" />
            </div>
        </div>

        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>英文名称：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <form:input type="text" class="input-text" placeholder="英文名称" path="enname" />
            </div>
        </div>

        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>分配菜单：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <div id="menuTree" class="ztree"></div>
                <form:hidden path="menuIds"/>
            </div>
        </div>

        <div class="row cl">
            <div class="col-xs-8 col-sm-9 col-xs-offset-4 col-sm-offset-3">
                <input class="btn btn-primary radius" type="submit" value="&nbsp;&nbsp;提交&nbsp;&nbsp;">
                <input class="btn btn-default radius" type="button" id="back_btn" value="&nbsp;&nbsp;返回&nbsp;&nbsp;">
            </div>
        </div>
    </form:form>
</article>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜单管理</title>
	<meta name="decorator" content="blank"/>
	<%@ include file="/WEB-INF/views/include/validation.jsp"%>
	<script type="text/javascript">
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

            $("#menuForm").validate({
                rules:{
                    name:{
                        isChinese:true,
                        required:true,
                        maxlength:16
                    },
					'parent.id':{
                        required:true,
                        maxlength:80
					},
					isShow:{
                        required:true
					},
                    permission:{
                        maxlength:30
					},
					sort:{
                        isIntGteZero:true,
						range:[0,100]
					}


                },
                onkeyup:false,
                focusCleanup:true,
                success:"valid",
                submitHandler:function(form){
                    /*$(form).ajaxSubmit();
                    var index = parent.layer.getFrameIndex(window.name);
                    //parent.$('.btn-refresh').click();
                    parent.location.replace(parent.location.href);
                    parent.layer.close(index);*/
                    submitForm(form);
                }
            });

		});

		function submitForm(form){
		    var url = $(form).attr("action");
		    var data = $(form).serialize() ;
		    $.ajax({
				type:'POST',
				url:url,
				data:data,
				success:function(data){
                    var index = parent.layer.getFrameIndex(window.name);
                    layer.msg(data.rtnMsg,{time:1000})
				    if('00000000'==data.rtnCode){
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
</head>
<body>
<article class="page-container">
	<form:form action="${ctx}/sys/menu/save" modelAttribute="menu" method="post" class="form form-horizontal" id="menuForm">
		<form:hidden path="id"/>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>名称：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<form:input type="text" class="input-text" placeholder="名称" path="name" />
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>上级菜单：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<sys:treeselect id="menu" name="parent.id" value="${menu.parent.id}" labelName="parent.name" labelValue="${menu.parent.name}"
								title="菜单" url="/sys/menu/treeData" extId="${menu.id}" cssClass="required"/>
			</div>
		</div>

		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3">链接：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<form:input type="text" class="input-text" placeholder="链接" path="href" />
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3">图标：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<sys:iconselect cssStyle="input-text" id="icon" name="icon" value="${menu.icon}"/>
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3">可见：</label>
			<div class="formControls col-xs-8 col-sm-9 skin-minimal">
					<div class="radio-box">
						<form:radiobutton path="isShow" value="1"/>
						<label>显示</label>
					</div>
					<div class="radio-box">
						<form:radiobutton path="isShow" value="0"/>
						<label>隐藏</label>
					</div>
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3">权限标识：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<form:input type="text" class="input-text" placeholder='控制器中定义的权限标识，如：@RequiresPermissions("权限标识")' path="permission" />
			</div>
		</div>

		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3">排序：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<form:input type="text" class="input-text" placeholder="升序排列" path="sort" />
			</div>
		</div>

		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3">备注：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<form:textarea class="textarea" placeholder="备注" path="remarks"></form:textarea>
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
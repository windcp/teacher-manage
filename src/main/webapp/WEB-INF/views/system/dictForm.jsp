<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title></title>
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

            $("#dictForm").validate({
                rules:{
                    type:{
                        required:true,
                        isEnglish:true,
                        maxlength:16
                    },
                    label:{
                        required:true,
                        isChinese:true,
                        maxlength:16
                    },
                    value:{
                        required:true,
                        maxlength:80
                    },
					sort:{
                        required:true,
                        isInteger:true,
                        maxlength:3
					}
                },
				messages:{
                    sort:{
                        isInteger:'只能输入0-100的整数'
					}
				},
                onkeyup:false,
                focusCleanup:true,
                success:"valid",
                submitHandler:function(form){
                    submitForm(form);
                }
            });
        })

        function submitForm(form){
            var url = $(form).attr("action");
            var data = $(form).serialize() ;
            $.ajax({
                type:'POST',
                url:url,
                data:data,
				dataType:'json',
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
	<form:form action="${ctx}/sys/dict/save" modelAttribute="dict" method="post" class="form form-horizontal" id="dictForm">
		<form:hidden path="id"/>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>类型：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<form:input type="text" class="input-text" placeholder="类型" path="type" />
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3">描述：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<form:input type="text" class="input-text" placeholder="描述" path="description" />
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>标签：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<form:input type="text" class="input-text" placeholder="标签" path="label" />
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>键值：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<form:input type="text" class="input-text" placeholder="键值" path="value" />
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3">排序：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<form:input type="text" class="input-text" placeholder="排序" path="sort" />
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


<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号" %>
<%@ attribute name="name" type="java.lang.String" required="true" description="输入框名称" %>
<%@ attribute name="value" type="java.lang.String" required="true" description="输入框值" %>
<%@ attribute name="cssStyle" type="java.lang.String" required="false" description="css样式" %>
<input id="${id}" name="${name}" type="hidden" value="${value}"/>
<i class="Hui-iconfont" style="font-size: 22px;margin-right: 5px;" id="${id}Display">${value}</i>
<a class="btn btn-primary radius" href="javascript:;" id="${id}Button"><i class="Hui-iconfont">&#xe600;</i> 选择图标</a>
<script type="text/javascript">
    $("#${id}Button").click(function () {
        var content = "${ctx}/tag/iconselect?value=" + $("#${id}").val() ;
        layer.open({
            type:2,
            area:['655px','500px'],
            fix: false, //不固定
            content:content,
            title:'选择图标',
            btn:['确定','取消'],
            yes:function(index,layero){
                var icon = layero.find("iframe")[0].contentWindow.$("#icon").val();
                $("#${id}").val(icon);
                $("#${id}Display").text(icon);
                layer.close(index);
            },
            btn2:function(){},
            btnAlign: 'c'
        });
        /*top.$.jBox.open("iframe:${ctx}/tag/iconselect?value=" + $("#${id}").val(), "选择图标", 700, $(top.document).height() - 180, {
            buttons: {"确定": "ok", "清除": "clear", "关闭": true}, submit: function (v, h, f) {
                if (v == "ok") {
                    var icon = h.find("iframe")[0].contentWindow.$("#icon").val();
                    $("#${id}Icon").attr("class", "icon-" + icon);
                    $("#${id}IconLabel").text(icon);
                    $("#${id}").val(icon);
                } else if (v == "clear") {
                    $("#${id}Icon").attr("class", "icon- hide");
                    $("#${id}IconLabel").text("无");
                    $("#${id}").val("");
                }
            }, loaded: function (h) {
                $(".jbox-content", top.document).css("overflow-y", "hidden");
            }
        });*/
    });
</script>
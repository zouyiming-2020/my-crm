<%@ page import="com.bjpowernode.crm.settings.domain.DicValue" %><%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>
		$(function () {
			$("#updateBtn").click(function () {
				$.ajax({
					url: "settings/dictionary/value/findByItv.do",
					data: {
						"id":"${dv.id}",
						"typeCode":$.trim($("#typeCode").val()),
						"value":$.trim($("#value").val())

					},
					type: "GET",
					dataType:"json",
					success: function(data){
						if(data.success){
							var a= $("#value").val();
							var b=$("#text").val();
							var c=$("#orderNo").val();
							var d=$("#typeCode").val();

							var param="?id=${dv.id}";
							param+="&value="+a+"&text="+b+"&orderNo="+c+"&typeCode="+d;

							window.location.href="settings/dictionary/value/updateDicValue.do"+param;

						}

					}
				});
			})
		})
	</script>

</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>修改字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" id="updateBtn" class="btn btn-primary">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal"  role="form">
					
		<div class="form-group">
			<label for="edit-dicTypeCode" class="col-sm-2 control-label">字典类型编码</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="typeCode" id="typeCode" style="width: 200%;" value="${dv.typeCode}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="value" id="value" style="width: 200%;" value="${dv.value}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="text" id="text" style="width: 200%;" value="${dv.text}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="orderNo" id="orderNo" style="width: 200%;" value="${dv.orderNo}">
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>
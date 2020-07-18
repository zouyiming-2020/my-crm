<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>
		$(function () {

		    $("#checkAll").click(function () {
				$("input[name=flag]").prop("checked",$("#checkAll").prop("checked"));

			})



			$("#editBtn").click(function () {

				//alert($("input[name=flag]:checked").length)
				if($("input[name=flag]:checked").length==0){
					alert("请勾选一条记录")
				}else if($("input[name=flag]:checked").length>1){
					alert("只能勾选一条记录")
				}else{
					//alert($("input[name=flag]:checked").val())
					//findDicTypeByCode.do?code="+code
					//window.location.href="settings/dictionary/type/findDicTypeByCode?code="+;
					window.location.href="settings/dictionary/type/findDicTypeByCode.do?code="+$("input[name=flag]:checked").val();
				}

			})
			
			
			
			$("#deleteBtn").click(function () {
				if($("input[name=flag]:checked").length==0){
					alert("请勾选要删除的数据")
					return ;
				}
				//alert($("input[name=flag]:checked").val(1))
				// var param="?";
				// $.each($("input[name=flag]:checked"),function(i,n) {
				// 	//alert(n.value)
				// 	param+="code="+n.value;
				// 	if(i<$("input[name=flag]:checked").length-1){
				// 		param+="&";
				// 	}
				// })

				var param = "?";
				$.each($("input[name=flag]:checked"),function (i, n) {
					param += "codes=" + $(n).val();
					if(i < $("input[name=flag]:checked").length -1){
						param += "&"
					}

				})

				$.ajax({
					url:"settings/dictionary/type/deleteDicType.do"+param,
					data:{},
					dataType:"json",
					type:"get",
					success:function (data) {
						if(data.success){
							alert(data.msg)
							window.location.href="settings/dictionary/type/toTypeIndex.do";
						}
					}

				});




			})
		})

		function reSelect(){
			$("#checkAll").prop(
					"checked",
					$("input[name=flag]").length==$("input[name=flag]:checked").length?true:false
			)
		}
		// $("#checkOne").click(function () {
		// 	$("#checkAll").prop(
		// 			"checked",
		// 			$("input[name=flag]").length==$("input[name=flag]:checked").length?true:false
		// })

	</script>

</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/type/toTypeSave.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" id="editBtn" class="btn btn-default" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="checkAll" /></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>

		<c:forEach items="${dList}" var="dt" varStatus="status">
			<tbody>
				<tr class="active">
					<td><input name="flag" value="${dt.code}" onclick="reSelect()" type="checkbox" /></td>
					<td>${status.count}</td>
					<td>${dt.code}</td>
					<td>${dt.name}</td>
					<td>${dt.description}</td>
				</tr>
			</tbody>
		</c:forEach>
		</table>
	</div>
	
</body>
</html>
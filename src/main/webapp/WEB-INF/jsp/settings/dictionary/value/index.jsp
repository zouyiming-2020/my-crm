<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" language="java" %>
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
				if($("input[name=flag]:checked").length==0){
					alert("请勾选一条记录")
					return;
				}else if($("input[name=flag]:checked").length>1){
					alert("只能勾选一条记录")
					return;
				}else{

					window.location.href="settings/dictionary/value/findDicValueById.do?id="+$("input[name=flag]:checked").val();
				}

			})

            $("#deleteBtn").click(function () {

                if($("input[name=flag]:checked").length==0){
                    alert("请勾选要删除的数据")
                    return ;
                }

                var param="?";

                $.each($("input[name=flag]:checked"),function (i,n) {
                    param += "ids="+$(n).val();
                    if(i < $("input[name=flag]:checked").length -1){
                        param += "&";
                    }
                })

                if(confirm("真的要删除么")) {
                    $.ajax({
                        url: "settings/dictionary/value/deleteDicValue.do" + param,
                        data: {},
                        dataType: "json",
                        type: "get",
                        success: function (data) {
                            if (data.success) {
                                alert(data.msg)
                                window.location.href = "settings/dictionary/value/toValueIndex.do";
                            }
                        }

                    });
                }

            })



		})

		function reSelect() {
			if($("input[name=flag]").length==$("input[name=flag]:checked").length){
				$("#checkAll").prop("checked",true);
			}
		}




	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/value/toValueSave.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="checkAll"/></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${dList}" var="d">
					<tr class="active">
						<td><input name="flag" value="${d.id}" onclick="reSelect()" type="checkbox" /></td>
						<td>${d.id}</td>
						<td>${d.value}</td>
						<td>${d.text}</td>
						<td>${d.orderNo}</td>
						<td>${d.typeCode}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	
</body>
</html>
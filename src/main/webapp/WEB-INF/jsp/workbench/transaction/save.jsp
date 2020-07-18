<%@ page import="com.bjpowernode.crm.workbench.domain.User" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
User user=(User)session.getAttribute("user");
	Map<String,String> sMap=(Map<String, String>) application.getAttribute("sMap");

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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script type="text/javascript">







		$(function(){
			var json = loadStagePossibilityJsonData();
			loadPossibilityByStage(json);



			//时间插件
			$(".dateTimeTop").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});
			$(".dateTimeBottom").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			//自动补全
			autoComplete();

			//点击市场活动源按钮
			$("#openActSource").on("click",function () {
				$.ajax({
					url: "workbench/transaction/getActSource.do",
					data: {

					},
					type: "get",
					dataType:"json",
					success: function(data){
						if(data.success){
							var html="";
							$.each(data.aList,function (i,n) {
							    html+='<tr>';
								html+='<td><input type="radio" name="activity" value="'+n.id+'"/></td> <td id="'+n.id+'">'+n.name+'</td>';
								html+='<td>'+n.startDate+'</td>';
								html+='<td>'+n.endDate+'</td>';
								html+='<td>'+n.owner+'</td>';
								html+='</tr>';


							})
							$("#actTbody").html(html);
							$("#findMarketActivity").modal("show");



						}else{
							alert("failed")
						}
					}
				});



			})
			//确定市场活动源
			$("#saveBtn").on("click",function () {
				var activityId=$("input[name=activity]:checked").val();
				$("#activityId").val(activityId);
				$("#create-activitySrc").val($("#"+activityId).html());
				$("#findMarketActivity").modal("hide");

			})

			//点击联系人按钮
			$("#openContacts").on("click",function () {
				$.ajax({
					url: "workbench/transaction/getContactsSource.do",
					data: {

					},
					type: "get",
					dataType:"json",
					success: function(data){
						if(data.success){
							var html="";
							$.each(data.aList,function (i,n) {
								html+='<tr>';
								html+='<td><input type="radio" name="contacts" value="'+n.id+'"/></td>';
								html+='<td id="co'+n.id+'">'+n.fullname+'</td>';
								html+='<td>'+n.email+'</td>';
								html+='<td>'+n.mphone+'</td>';
								html+='</tr>';


							})
							$("#actTbody").html(html);
							$("#findMarketActivity").modal("show");



						}else{
							alert("failed")
						}
					}
				});



			})

		});

		//根据stage获取possibility
		function loadPossibilityByStage(json) {
			$("#create-transactionStage").change(function () {

				var stage = $("#create-transactionStage").val();

				$("#create-possibility").val(json[stage]);
			})
		}

		//将Map集合转换为json对象的函数
		function loadStagePossibilityJsonData() {
			var j;
			j = {
				<%

					Set<String> keys = sMap.keySet();
					for(String key : keys){
						String value = sMap.get(key);

				%>

				"<%=key%>" : "<%=value%>" ,

				<%

					}
				%>
			}
			return j;
		}

		//自动补全
		function autoComplete() {
				$("#create-accountName").typeahead({
					source: function (query, process) {
						$.post(
								"workbench/transaction/getCustomerName.do",
								{"name": query},
								function (data) {
									//alert(data);
									process(data);
								},
								"json"
						);
					},
					delay: 500

				});
			}




	</script>


</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="actTbody">
							<%--<tr>--%>
								<%--<td><input type="radio" name="activity"/></td>--%>
								<%--<td>发传单</td>--%>
								<%--<td>2020-10-10</td>--%>
								<%--<td>2020-10-20</td>--%>
								<%--<td>zhangsan</td>--%>
							<%--</tr>--%>
							<%--<tr>--%>
								<%--<td><input type="radio" name="activity"/></td>--%>
								<%--<td>发传单</td>--%>
								<%--<td>2020-10-10</td>--%>
								<%--<td>2020-10-20</td>--%>
								<%--<td>zhangsan</td>--%>
							<%--</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" >关闭</button>
					<button id="saveBtn" type="button" class="btn btn-primary" >保存</button>
				</div>
			</div>

		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody>
							<%--<tr>--%>
								<%--<td><input type="radio" name="activity"/></td>--%>
								<%--<td>李四</td>--%>
								<%--<td>lisi@bjpowernode.com</td>--%>
								<%--<td>12345678901</td>--%>
							<%--</tr>--%>
							<%--<tr>--%>
								<%--<td><input type="radio" name="activity"/></td>--%>
								<%--<td>李四</td>--%>
								<%--<td>lisi@bjpowernode.com</td>--%>
								<%--<td>12345678901</td>--%>
							<%--</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<input type="hidden" name="activityId" id="activityId" >


		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
					<c:forEach items="${userList}" var="u">
						<option value="${u.id}"   ${u.id eq user.id ?"selected":"" }>${u.name}</option>
					</c:forEach>
				  <%--<option>zhangsan</option>--%>
				  <%--<option>lisi</option>--%>
				  <%--<option>wangwu</option>--%>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control dateTimeBottom" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
				  <c:forEach items="${stageList}" var="s">
					  <option value="${s.value}">${s.text}</option>
				  </c:forEach>
			  	<%--<option>资质审查</option>--%>
			  	<%--<option>需求分析</option>--%>
			  	<%--<option>价值建议</option>--%>
			  	<%--<option>确定决策者</option>--%>
			  	<%--<option>提案/报价</option>--%>
			  	<%--<option>谈判/复审</option>--%>
			  	<%--<option>成交</option>--%>
			  	<%--<option>丢失的线索</option>--%>
			  	<%--<option>因竞争丢失关闭</option>--%>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="tt">
						<option value="${tt.value}">${tt.text}</option>
					</c:forEach>
				  <%--<option>已有业务</option>--%>
				  <%--<option>新业务</option>--%>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
					<c:forEach items="${sourceList}" var="so">
						<option value="${so.value}">${so.text}</option>
					</c:forEach>
				  <%--<option>广告</option>--%>
				  <%--<option>推销电话</option>--%>
				  <%--<option>员工介绍</option>--%>
				  <%--<option>外部介绍</option>--%>
				  <%--<option>在线商场</option>--%>
				  <%--<option>合作伙伴</option>--%>
				  <%--<option>公开媒介</option>--%>
				  <%--<option>销售邮件</option>--%>
				  <%--<option>合作伙伴研讨会</option>--%>
				  <%--<option>内部研讨会</option>--%>
				  <%--<option>交易会</option>--%>
				  <%--<option>web下载</option>--%>
				  <%--<option>web调研</option>--%>
				  <%--<option>聊天</option>--%>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a id="openActSource" href="javascript:void(0);"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" readonly autocomplete="off" class="form-control" id="create-activitySrc">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a id="openContacts" href="javascript:void(0);" ><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" autocomplete="off" id="create-contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control dateTimeTop" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>
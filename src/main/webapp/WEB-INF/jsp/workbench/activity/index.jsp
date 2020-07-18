<%@ page import="com.bjpowernode.crm.workbench.domain.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
	User user=(User)session.getAttribute("user");
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

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>



<script>
	$(function(){
		//时间插件
		$(".dateTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		//TODO 全选
		$("#checkAll").click(function () {
			$("input[name=flag]").prop("checked",$("#checkAll").prop("checked"));
		})
		//TODO 创建
		$("#saveBtn").click(function () {
			$.ajax({
				data:{},
				type:"get",
				url:"workbench/activity/getUserList.do",
				dataType:"json",
				success:function (data) {
					if(data.success){
						var option="<option></option>";
						$.each(data.uList,function(i,n){
							option +="<option value="+n.id+">"+n.name+"</option>";
						})

						$("#create-owner").html(option);

						$("#create-owner").val("${user.id}");

						$("#createActivityModal").modal("show");
					}else{
						alert("failed")
					}

				}


			});
		})
		//创建后保存
		$("#addBtn").click(function () {
			$.ajax({
				url:"workbench/activity/saveActivity.do",
				data:{
					"owner":$("#create-owner").val(),
					"name":$("#name").val(),
					"startDate":$("#startDate").val(),
					"endDate":$("#endDate").val(),
					"cost":$("#cost").val(),
					"description":$("#description").val()
				},
				dataType:"json",
				type:"post",
				success:function (data) {
					if(data.success){
						// window.location.href="workbench/activity//toActIndex.do";


						getPage(1,5);

					}
				}


			});
		})

		//TODO 编辑
		$("#editBtn").click(function () {
			if($("input[name=flag]:checked").length==0){
				alert("请勾选一条数据")
				return;
			}else if($("input[name=flag]:checked").length>1){
				alert("只能勾选一条")
				return;
			}else{
				$.ajax({
					data:{
						"id":$("input[name=flag]:checked").val()
					},
					dataType:"json",
					url:"workbench/activity/getActAndUser.do",
					type:"get",
					success:function (data) {
						if(data.success){
							var option="<option></option>";
							$.each(data.uList,function (i,n) {
								option+="<option value="+n.id+">"+n.name+"</option>"
							})

							$("#edit-owner").html(option);
							var act=data.act;
							$("#edit-id").val(act.id);
							$("#edit-owner").val(act.owner);
							$("#edit-name").val(act.name);
							$("#edit-startDate").val(act.startDate);
							$("#edit-endDate").val(act.endDate);
							$("#edit-cost").val(act.cost);
							$("#edit-description").val(act.description);


							$("#editActivityModal").modal("show");
						}else{
							alert("failed")
						}
					}
				})
			}
		})

		//TODO 更新
		$("#updateBtn").click(function () {
			$.ajax({
				data:{
					"id":$("#edit-id").val(),
					"owner":$("#edit-owner").val(),
					"name":$("#edit-name").val(),
					"startDate":$("#edit-startDate").val(),
					"endDate":$("#edit-endDate").val(),
					"cost":$("#edit-cost").val(),
					"description":$("#edit-description").val()
				},
				dataType:"json",
				url:"workbench/activity/updateActById.do",
				type:"post",
				success:function (data) {
					if(data.success){
							//清理模态窗口的数据，关闭模态窗口，回到index页面
						$("#editActivityModal").modal("hide");
						//$("#edit-form").reset();

						getPage(
                            $("#actPage").bs_pagination('getOption', 'currentPage'),
                            $("#actPage").bs_pagination('getOption', 'rowsPerPage')
                        );

					}else{
						alert("failed")
						return;
					}
				}

			})

		})

		//TODO 反选
		$("#qwe").on("click",$("input[name=flag]"),function () {
			alert("hahah")
			$("#checkAll").prop("checked",
				$("input[name=flag]").length==$("input[name=flag]:checked").length
			)
		})

		//TODO 删除
		$("#deleteBtn").click(function () {
			if($("input[name=flag]:checked").length==0){
				alert("Please at least select  one ")
				return ;
			}else {
				var flags = $("input[name=flag]:checked");
				var param = "?";
				$.each(flags, function (i, n) {
					param += "ids=" + $(n).val();
					if (i < $("input[name=flag]:checked").length - 1) {
						param += "&";
					}
				})
				if (confirm("delete or not?")) {
					$.ajax({
						url: "workbench/activity/deleteActById.do" + param,
						dataType: "json",
						data: {},
						type: "get",
						success: function (data) {
							if (data.success) {
								alert(data.msg)
								getPage(1, 5);
							}
						}
					})
				}
			}
		})

		//TODO 批量下载
		$("#exportActivityAllBtn").click(function () {
			window.location.href="workbench/activity/toExportAllAct.do";
		})

		//TODO 选择下载
		$("#exportActivityXzBtn").click(function () {
			if ($("input[name=flag]:checked").length == 0) {
				alert("Please select at least one ")
				return;
			} else {
				var flags = $("input[name=flag]:checked");
				var param = "?";
				$.each(flags, function (i, n) {
					param += "ids=" + $(n).val();
					if (i < $("input[name=flag]:checked").length - 1) {
						param += "&";
					}
				})

				window.location.href="workbench/activity/toExportActXZ.do"+param;
			}
		})

		//TODO 上传文件
		$("#importActivityBtn").click(function () {
			var pageName=$("#activityFile").val();
			var suffix=pageName.substring(pageName.lastIndexOf(".")+1);
			//alert(suffix)
			if(suffix!="xls"){
				alert("Please select the file of right type")
				return;
			}

			var size=$("#activityFile")[0].files[0].size;
			//alert(size)
			if(size>1024*1024*5){
				alert("The file's size is over 5MB.Please select a smaller one")
				return;
			}


			var formData=new FormData();
			formData.append("myFile",$("#activityFile")[0].files[0]);


			$.ajax({
				url:'workbench/activity/importActivity.do',
				data:formData,
				type:'post',
				processData:false,
				contentType:false,
				success:function(data){
					if(data.success){
						alert("导入数据成功");
						$("#activityFile").val("");
						$("#importActivityModal").modal("hide");

						getPage(1,5);
					}else{
						alert("导入数据失败");
					}
				}
			});


		})

        //TODO 加载市场活动index页面内容
		getPage(1,5);
		
	});

	//复选
	//function reSelect() {
	// 	$("#checkAll").prop("checked",
	// 			$("input[name=flag]:checked").length==$("input[name=flag]").length)
	// }

	//TODO 加载市场活动index页面内容的函数
	function getPage(pageNo,pageSize) {

		var pageNumber=(pageNo-1)*pageSize;

		$.ajax({
			dataType:"json",
			url:"workbench/activity/getPage.do",
			data:{
				"id":"${user.id}",
				"pageNo":pageNumber,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"startDate":$("#search-startDate").val(),
				"endDate":$("#search-endDate").val()
			},
			type:"post",
			success:function (data) {
				if(data.success){
					var html="";
					$.each(data.aList,function (i,n) {
						html+='<tr class="active">';
						html+='<td><input type="checkbox" name="flag"  value='+n.id+'></td>';
                        //点击按钮，跳转到详情页。携带activity的id参数
						html+='<td><a style="text-decoration: none; cursor: pointer;" href="workbench/ActivityRemark/toDetail.do?actId='+n.id+'">'+n.name+'</a></td>';
						html+='<td>'+n.owner+'</td>';
						html+='<td>'+n.startDate+'</td>';
						html+='<td>'+n.endDate+'</td>';
						html+='</tr>';

					});

					$("#tBody").html(html);
					var totalPages=(data.total%pageSize==0)?data.total/pageSize:parseInt(data.total/pageSize)+1;

					$("#actPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.total, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						onChangePage : function(event, data){
							getPage(data.currentPage , data.rowsPerPage);
						}
					});


				}else{
					alert("炸了")
				}
			}
		})

	}
	
</script>

</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" readonly autocomplete="off" class="form-control dateTime" id="startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" readonly autocomplete="off" class="form-control dateTime" id="endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="addBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="edit-form"  role="form">
						<input id="edit-id" type="hidden" >
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" >
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label ">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" autocomplete="off" class="form-control dateTime" id="edit-startDate" >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label dataTime">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" autocomplete="off" class="form-control dateTime" id="edit-endDate" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="updateBtn" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls格式]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	<!--条件搜索 -->
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control dateTime"  autocomplete="off"   type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control dateTime" autocomplete="OFF" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" onclick="getPage(1,5)" class="btn btn-default">查询</button>
				  
				</form>
			</div>

            <!--操作按钮-->
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<%--<button id="saveBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>--%>
				  <button id="saveBtn" type="button" class="btn btn-primary" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">

					</tbody>
				</table>
			</div>


			<%--分页--%>
			<div id="actPage"></div>


		</div>
		
	</div>
</body>
</html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bjpowernode.crm.workbench.domain.User" %><%
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
<script type="text/javascript">

	$(function(){

		//TODO 创建线索
        $("#createBtn").click(function () {
            //拼接所有者下拉选
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

                        $("#createClueModal").modal("show");
                    }else{
                        alert("failed")
                    }

                }


            });
        })

		//getClueList();
		getPageListByPage(1,2);
		//TODO 保存线索
        $("#saveBtn").click(function () {
            $("#saveForm").submit();
        })

		//TODO 编辑线索
		$("#editBtn").click(function () {
			if($("input[name=flag]:checked").length==0){
				alert("please select one choice")
			}else if($("input[name=flag]:checked").length>1){
				alert("just one choice is neeeded")
			}else{
				var clueId=$("input[name=flag]:checked").val();

				$.ajax({
					url: "workbench/clue/findClueById.do",
					data: {
						"clueId":clueId
					},
					type: "get",
					dataType:"json",
					success: function(data){
						if(data.success){
							var clue=data.clue;
							$("#clueId").val(clue.id);
							$("#edit-fullname").val(clue.fullname);
							$("#edit-appellation").val(clue.appellation);
							$("#edit-owner").val(clue.owner);
							$("#edit-company").val(clue.company);
							$("#edit-job").val(clue.job);
							$("#edit-email").val(clue.email);
							$("#edit-phone").val(clue.phone);
							$("#edit-website").val(clue.website);
							$("#edit-mphone").val(clue.mphone);
							$("#edit-state").val(clue.state);
							$("#edit-source").val(clue.source);
							$("#edit-description").val(clue.description);
							$("#edit-contactSummary").val(clue.contactSummary);
							$("#edit-nextContactTime").val(clue.nextContactTime);
							$("#edit-address").val(clue.address);

							$("#editClueModal").modal("show");

						}else{
							alert("failed")
						}
					}
				});
			}
		})

		//TODO 更新线索
		$("#updateBtn").click(function () {
			$("#editForm").submit();

			// $("#editClueModal").modal("hide");
			//
			// getPageListByPage(1,2);
		})

		//TODO 删除线索
		$("#deleteBtn").click(function () {
			if($("input[name=flag]:checked").length==0){
				alert("u should at least select one choice ")
			}else{
				var ids="?";
				$.each($("input[name=flag]:checked"),function (i,n) {
					ids+="ids="+n.value;
					if(i<$("input[name=flag]:checked").length-1){
						ids+="&";
					}
				})

				if(confirm("delete or not!")){
					$.ajax({
						url: "workbench/clue/deleteClueByIds.do"+ids,
						data: {

						},
						type: "post",
						dataType:"json",
						success: function(data){
							if(data.success){
								getPageListByPage(1,2);
							}else{
								alert("failed")
							}
						}
					});
				}







			}
		})
		



	});
	<%--//没有分页的index页面显示--%>
	<%--function getClueList() {--%>
		<%--$.ajax({--%>
			<%--url: "workbench/clue/getClueList.do",--%>
			<%--data: {--%>
				<%--"owner":"${user.id}"--%>
			<%--},--%>
			<%--type: "get",--%>
			<%--dataType:"json",--%>
			<%--success: function(data){--%>
				<%--if(data.success){--%>
					<%--//alert("win")--%>
					<%--var html="";--%>

					<%--$.each(data.cList,function (i,n) {--%>
						<%--var param="?clueId="+n.id;--%>
					    <%--html+='<tr>';--%>
						<%--html+='<td><input type="checkbox" /></td>';--%>
						<%--html+='<td><a style="text-decoration: none; cursor: pointer;" href="workbench/clue/toDetail.do'+param+'" >'+n.fullname+''+ n.appellation+'</a></td>';--%>
						<%--html+='<td>'+n.company+'</td>';--%>
						<%--html+='<td>'+n.phone+'</td>';--%>
						<%--html+='<td>'+n.mphone+'</td>';--%>
						<%--html+='<td>'+n.source+'</td>';--%>
						<%--html+='<td>'+n.owner+'</td>';--%>
						<%--html+='<td>'+n.state+'</td>';--%>
						<%--html+='</tr>';--%>

					<%--})--%>

					<%--$("#tBody").html(html);--%>
				<%--}else{--%>
					<%--alert("failed")--%>
				<%--}--%>
			<%--}--%>
		<%--});--%>

	<%--}--%>

	//TODO 加入分页的页面显示
	function getPageListByPage(pageNo,pageSize) {
		var pageNumber=(pageNo-1)*pageSize;

		$.ajax({
			url: "workbench/clue/getClueListX.do",
			data: {
				"owner":"${user.id}",
				"pageNo":pageNumber,
				"pageSize":pageSize

			},
			type: "get",
			dataType:"json",
			success: function(data){
				if(data.success) {
					var html = "";

					$.each(data.cList, function (i, n) {
						var param = "?clueId=" + n.id;
						html += '<tr>';
						html += '<td><input type="checkbox" name="flag" value="'+n.id+'" /></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" href="workbench/clue/toDetail.do' + param + '" >' + n.fullname + '' + n.appellation + '</a></td>';
						html += '<td>' + n.company + '</td>';
						html += '<td>' + n.phone + '</td>';
						html += '<td>' + n.mphone + '</td>';
						html += '<td>' + n.source + '</td>';
						html += '<td>' + n.owner + '</td>';
						html += '<td>' + n.state + '</td>';
						html += '</tr>';

					})

					$("#tBody").html(html);

					var totalPages = (data.total % pageSize == 0) ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

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

						onChangePage: function (event, data) {
							getPageListByPage(data.currentPage, data.rowsPerPage);
						}
					})
				}else{
					alert("failed")
				}
			}
		})
	}



	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="saveForm" action="workbench/clue/saveClue.do" method="post" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner" name="owner" >
								  <%--<option>zhangsan</option>--%>
								  <%--<option>lisi</option>--%>
								  <%--<option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company" name="company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation" name="appellation">
								  <option></option>
                                    <c:forEach items="${appellationList}" var="a">
                                        <option value="${a.value}">${a.text}</option>
                                    </c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname" name="fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job" name="job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email" name="email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone" name="phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website" name="website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone" name="mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state" name="state">
                                    <option></option>
                                    <c:forEach items="${clueStateList}" var="c">
                                        <option value="${c.value}">${c.text}</option>
                                    </c:forEach>
                                </select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source" name="source">
                                    <option></option>
                                    <c:forEach items="${sourceList}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                     </c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description" name="description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime" name="nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address" name="address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" >关闭</button>
					<button id="saveBtn" type="button" class="btn btn-primary" >保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form id="editForm" class="form-horizontal" action="workbench/clue/updateClue.do" role="form">
						<input type="hidden"  id="clueId" name="id" >
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner" name="owner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" name="company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation" name="appellation">
								  <option></option>
								  <%--<option selected>先生</option>--%>
								  <%--<option>夫人</option>--%>
								  <%--<option>女士</option>--%>
								  <%--<option>博士</option>--%>
								  <%--<option>教授</option>--%>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" name="fullname" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" namme="job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" name="email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" name="phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" name="website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" name="mphone" >
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state" name="state">
								  <option></option>
								  <%--<option>试图联系</option>--%>
								  <%--<option>将来联系</option>--%>
								  <%--<option selected>已联系</option>--%>
								  <%--<option>虚假线索</option>--%>
								  <%--<option>丢失线索</option>--%>
								  <%--<option>未联系</option>--%>
								  <%--<option>需要条件</option>--%>
									<c:forEach items="${clueStateList}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source" name="source">
								  <option></option>
								  <%--<option selected>广告</option>--%>
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
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description" name="description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary" name="contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" name="nextContactTime" >
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address" name="address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="updateBtn" type="button" class="btn btn-primary" >更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control">
					  	  <option></option>
					  	  <option>广告</option>
						  <option>推销电话</option>
						  <option>员工介绍</option>
						  <option>外部介绍</option>
						  <option>在线商场</option>
						  <option>合作伙伴</option>
						  <option>公开媒介</option>
						  <option>销售邮件</option>
						  <option>合作伙伴研讨会</option>
						  <option>内部研讨会</option>
						  <option>交易会</option>
						  <option>web下载</option>
						  <option>web调研</option>
						  <option>聊天</option>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <%--<div class="form-group">--%>
				    <%--<div class="input-group">--%>
				      <%--<div class="input-group-addon">所有者</div>--%>
				      <%--<input class="form-control" type="text">--%>
				    <%--</div>--%>
				  <%--</div>--%>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control">
					  	<option></option>
					  	<option>试图联系</option>
					  	<option>将来联系</option>
					  	<option>已联系</option>
					  	<option>虚假线索</option>
					  	<option>丢失线索</option>
					  	<option>未联系</option>
					  	<option>需要条件</option>
					  </select>
				    </div>
				  </div>

				  <button type="submit" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createBtn" type="button" class="btn btn-primary" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr>--%>
							<%--<td><input type="checkbox" /></td>--%>
							<%--<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>--%>
							<%--<td>动力节点</td>--%>
							<%--<td>010-84846003</td>--%>
							<%--<td>12345678901</td>--%>
							<%--<td>广告</td>--%>
							<%--<td>zhangsan</td>--%>
							<%--<td>已联系</td>--%>
						<%--</tr>--%>
					</tbody>
				</table>
				<div id="actPage"></div>
			</div>


			<%--<div style="height: 50px; position: relative;top: 60px;">--%>
				<%--<div>--%>
					<%--<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
				<%--</div>--%>
				<%--<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
					<%--<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
					<%--<div class="btn-group">--%>
						<%--<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
							<%--10--%>
							<%--<span class="caret"></span>--%>
						<%--</button>--%>
						<%--<ul class="dropdown-menu" role="menu">--%>
							<%--<li><a href="#">20</a></li>--%>
							<%--<li><a href="#">30</a></li>--%>
						<%--</ul>--%>
					<%--</div>--%>
					<%--<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
				<%--</div>--%>
				<%--<div style="position: relative;top: -88px; left: 285px;">--%>
					<%--<nav>--%>
						<%--<ul class="pagination">--%>
							<%--<li class="disabled"><a href="#">首页</a></li>--%>
							<%--<li class="disabled"><a href="#">上一页</a></li>--%>
							<%--<li class="active"><a href="#">1</a></li>--%>
							<%--<li><a href="#">2</a></li>--%>
							<%--<li><a href="#">3</a></li>--%>
							<%--<li><a href="#">4</a></li>--%>
							<%--<li><a href="#">5</a></li>--%>
							<%--<li><a href="#">下一页</a></li>--%>
							<%--<li class="disabled"><a href="#">末页</a></li>--%>
						<%--</ul>--%>
					<%--</nav>--%>
				<%--</div>--%>
			<%--</div>--%>

		</div>

	</div>
</body>
</html>
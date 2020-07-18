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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

        //TODO 加载remark列表
        getActivityRemarkList();

		//TODO 解决异步刷新市场详情列表的图标不显示问题
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		//TODO 通过编辑窗口更新备注
		$("#updateRemarkBtn").click(function () {
			var id=$("#hiddenARId").val();
			//alert(id)
			var noteContent=$("#noteContent").val();

			$.ajax({
				url: "workbench/ActivityRemark/updateActRemark.do",
				data: {
					"id":id,
					"noteContent":noteContent
				},
				type: "post",
				dataType:"json",
				success: function(data){
						if(data.success){
							//清空隐藏域的activityId
							$("#hiddenARId").val("");
							//通过覆盖文本框更新noteContent
							$("#nc"+id).html(noteContent);
							//通过覆盖文本框更新createTime/editTime,createBy/editBy
							$("#ns"+id).html(data.editTime+" 由 "+data.editBy);
							$("#editRemarkModal").modal("hide");
						}else{
							alert("failed")
					}
				}
			});


		})


	});
    //加载remark列表的函数
    function getActivityRemarkList() {
        $.ajax({
            url: "workbench/ActivityRemark/getARListByActId.do",
            data: {
                "actId":"${act.id}"
            },
            type: "get",
            dataType:"json",
            success: function(data){
				if(data.success){
					var html="";
					$.each(data.arList,function (i,n) {
					html+='<div id="dl_'+n.id+'"class="remarkDiv" style="height: 60px;">';
					html+='<img title="${act.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html+='<div style="position: relative; top: -40px; left: 40px;" >';
					// html+='<h5 id="nc\''+n.id+'\'">'+n.noteContent+'</h5>';
						html += '<h5 id="nc'+n.id+'">'+n.noteContent+'</h5>';
						<%--html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${act.name}</b> <small style="color: gray;" id="s_'+n.id+'"> '+ (n.editFlag == "0" ? n.createTime : n.editTime) +'  由  '+ (n.editFlag == "0" ? n.createBy : n.editBy) +'</small>';--%>
						<%--html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${act.name}</b> <small style="color: gray;"> '+ (data.ar.editFlag == "0" ? data.ar.createTime : data.ar.editTime) +'  由  '+ (data.ar.editFlag == "0" ? data.ar.createBy : data.ar.editBy) +'</small>';--%>
						html+='<font color="gray">市场活动</font> <font color="gray">-</font> <b>${act.name}</b> <small id="ns'+n.id+'"style="color: gray;">'+(n.editFlag==0?n.createTime:n.editTime)+'由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html+='<a class="myHref" onclick="openEditRemarkModal(\''+n.id+'\')" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #00FF00;"></span></a>';
					html+='	&nbsp;&nbsp;&nbsp;&nbsp;';
					html+='<a class="myHref"  onclick="deleteRemark(\''+n.id+'\')" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
					html+='</div>';
					html+='</div>';
					html+='</div>';
					})
					$("#remark-t").before(html);

				}else{
					alert("failed")
				}

            }
        });

    }

    //TODO 打开备注的编辑窗口
	function openEditRemarkModal(id) {
    	//alert(id)
		$("#noteContent").val( $("#nc"+id).html());
		$("#hiddenARId").val(id);
		// var noteContent=$("#nc"+id).html();
		// //alert(noteContent)
		// $("#noteContent").val(noteContent);
		$("#editRemarkModal").modal("show");
	}

	//TODO 删除备注
	function deleteRemark(id) {
		if(confirm("delete or not")) {
			$.ajax({
				url: "workbench/ActivityRemark/deleteActRemark.do",
				data: {
					"id": id
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data.success) {
						$("#dl_" + id).remove();
					}
				}
			});
		}
	}
	
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
					<%--创建隐藏域存放activityRemark的id--%>
					<input id="hiddenARId" type="hidden" value="">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${act.name} <small> ${act.startDate}~${act.endDate} </small></h3>
		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${user.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${act.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${act.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${act.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${act.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;&nbsp;${act.createBy}</b><small style="font-size: 10px; color: gray;"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;&nbsp;${act.editBy}</b><small style="font-size: 10px; color: gray;"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>${act.description}</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div  id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div id="remark-h" class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">--%>
			<%--<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
			<%--<div style="position: relative; top: -40px; left: 40px;" >--%>
				<%--<h5>哎呦！</h5>--%>
				<%--<font color="gray">市场活动</font> <font color="gray">-</font> <b></b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
				<%--<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
					<%--<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
					<%--&nbsp;&nbsp;&nbsp;&nbsp;--%>
					<%--<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
				<%--</div>--%>
			<%--</div>--%>
		<%--</div>--%>

		
		<div id="remark-t" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>
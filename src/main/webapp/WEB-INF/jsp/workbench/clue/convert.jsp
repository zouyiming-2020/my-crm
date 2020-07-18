<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bjpowernode.crm.workbench.domain.Clue" %>
<%@ page import="com.bjpowernode.crm.workbench.domain.User" %><%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

Clue c=(Clue)request.getAttribute("c");
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


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
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
		<%--alert("${c.id}")--%>
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});


        //TODO 模糊查询市场活动
        $("#_actSearch").keydown(function (event){

            if(13==event.keyCode){
                alert("j")
                var name=$.trim($("#_actSearch").val());
                $.ajax({
                    url: "workbench/clue/getBindedAct.do",
                    data: {
                        "name":name,
                        "clueId":"${c.id}"
                    },
                    type: "get",
                    dataType:"json",
                    success: function(data){
                        if(data.success){
                            var html2="";
                            $.each(data.aList,function (i,n) {
                                html2+='<tr>';
                                html2+='<td><input type="radio" name="activity" value="'+n.id+'" /></td>';
                                html2+='<td id="'+n.id+'">'+n.name+'</td>';
                                html2+='<td>'+n.startDate+'</td>';
                                html2+='<td>'+n.endDate+'</td>';
                                html2+='<td>'+n.owner+'</td>';
                                html2+='</tr>';
                            })

                            $("#tBody").html(html2);


                            $("#searchActivityModal").modal("show");


                        }else{
                            alert("failed")
                        }
                    }
                })
            }
        })

        //TODO 确定市场源
        $("#selectAct").click(function () {
            var activityId=$("input[name=activity]:checked").val();
            $("#activityId").val(activityId);
            $("#activity").val($("#"+activityId).html());

            $("#searchActivityModal").modal("hide");

        })

       <%--var param="${c.id}";--%>
		//TODO 转换
		$("#transformBtn").click(function () {
			var flag=$("#isCreateTransaction").prop("checked");
			//alert(flag);
			$("#flag").val(flag);
			$("#transform").submit();
		})
	});


	function showAct() {
        $.ajax({
            url: "workbench/clue/getBindedAct.do",
            data: {
                "clueId":"${c.id}"
            },
            type: "get",
            dataType:"json",
            success: function(data){
                if(data.success){
                    var html="";
                    $.each(data.aList,function (i,n) {
                        html+='<tr>';
                        html+='<td><input type="radio" name="activity" value="'+n.id+'" /></td>';
                        html+='<td id="'+n.id+'">'+n.name+'</td>';
                        html+='<td>'+n.startDate+'</td>';
                        html+='<td>'+n.endDate+'</td>';
                        html+='<td>'+n.owner+'</td>';
                        html+='</tr>';
                    })

                    $("#tBody").html(html);
                    $("#searchActivityModal").modal("show");
                }else{
                    alert("failed")
                }
            }
        });


    }
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="_actSearch" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody">
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
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button id="selectAct" type="button"   class="btn btn-primary" data-dismiss="modal">确定</button>
                </div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${c.fullname}${c.appellation}-${c.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${c.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${c.fullname}${c.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form id="transform" method="post" action="workbench/clue/clueTransform.do">
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" name="money" id="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" name="name" id="name" >
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control dateTime" name="expectedDate" id="expectedDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage" name="stage" class="form-control">
		    	<option></option>
                <c:forEach items="${stageList}" var="s">
                    <option>${s.value}</option>
                </c:forEach>

		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" onclick="showAct()" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
              <input type="hidden" name="activityId" id="activityId" >
			  <input type="hidden" name="clueId" id="clueId" value="${c.id}">
			  <input type="hidden" name="flag" id="flag">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>zhangsan</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" id="transformBtn" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>
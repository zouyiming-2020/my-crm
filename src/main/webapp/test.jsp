<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
</head>
<body>
$.ajax({
        url: "",
        data: {

        },
        type: "",
        dataType:"json",
        success: function(data){

}
});

activity.setId(UUIDUtil.getUUID());
activity.setCreateTime(DateTimeUtil.getSysTime());//19位
activity.setCreateBy(((User)session.getAttribute("user")).getName());
</body>
</html>

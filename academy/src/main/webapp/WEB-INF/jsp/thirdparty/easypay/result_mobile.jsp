<%@ page import="java.util.Enumeration"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%
request.setCharacterEncoding("utf-8");

String res_cd = request.getAttribute("res_cd") == null ? "" : (String) request.getAttribute("res_cd");
String res_msg = request.getAttribute("res_msg") == null ? "" : (String) request.getAttribute("res_msg");
String bDBProc = request.getAttribute("bDBProc") == null ? "" : (String) request.getAttribute("bDBProc");

%>

<%
	System.out.println(">>> /WEB-INF/jsp/thirdparty/easypay/result_mobile.jsp");

	Enumeration<String> parameterNames = request.getParameterNames();
	while (parameterNames.hasMoreElements()) {
	
	    String paramName = parameterNames.nextElement();
	    System.out.println(paramName);
	
	    String[] paramValues = request.getParameterValues(paramName);
	    for (int i = 0; i < paramValues.length; i++) {
	        String paramValue = paramValues[i];
	        System.out.println("\t" + paramValue);
	        System.out.println("\t\n");
	    }
	}
%>

<script type="text/javascript">

	try{
		window.parent.hideLoading();
	}catch(e){
		
	}
	
	if ( "0000" == "<%=res_cd%>" && "<%=bDBProc%>" == "true") {
		
		alert("결제가 완료되었습니다.");
		window.parent.roomEduRsvDetail();
		
	} else if ( "0000" != "<%=res_cd%>" && "<%=bDBProc%>" == "false"){
		
		alert("<%=res_msg%> (CODE : <%=res_cd%>)");
		window.parent.refreshOrderPage();
		
	} else if ( "0000" == "<%=res_cd%>" && "<%=bDBProc%>" == "false"){
		
		alert("내부 서버 오류로 인해 결제가 실패했습니다. (CODE : <%=res_cd%>)");
		window.parent.refreshOrderPage();
		
	} else {
		
		alert("<%=res_msg%> (CODE : <%=res_cd%>)");
		window.parent.refreshOrderPage();
		
	}
</script>

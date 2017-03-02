<%@page import="java.util.Enumeration"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%
request.setCharacterEncoding("utf-8");

String res_cd = request.getAttribute("res_cd") == null ? "" : (String) request.getAttribute("res_cd");
String res_msg = request.getAttribute("res_msg") == null ? "" : (String) request.getAttribute("res_msg");
String bDBProc = request.getAttribute("bDBProc") == null ? "" : (String) request.getAttribute("bDBProc");

%>

<script type="text/javascript">

	try{
		if( "localhost" != document.domain){
    		document.domain="abnkorea.co.kr";
    	}
		
		window.parent.hideLoading();
	}catch(e){
		
	}
	
	if ( "0000" == "<%=res_cd%>" && "<%=bDBProc%>" == "true") {
		
		alert("결제가 완료되었습니다.");
		window.parent.roomEduRsvDetail();
		
	} else if ( "0000" != "<%=res_cd%>" && "<%=bDBProc%>" == "false"){
		
		var alertMessage = "<%=res_msg%>";
		
		if ( 0 < "<%=res_cd%>".length ) {
			alertMessage += " (CODE : <%=res_cd%>)";
		}
		
		alert(alertMessage);
		window.parent.refreshOrderPage();
		
	} else if ( "0000" == "<%=res_cd%>" && "<%=bDBProc%>" == "false"){
		
		var alertMessage = "내부 서버 오류로 인해 결제가 실패했습니다.";
		
		if ( 0 < "<%=res_cd%>".length ) {
			alertMessage += " (CODE : <%=res_cd%>)";
		}
		
		alert(alertMessage);
		window.parent.refreshOrderPage();
		
	} else {
		
		var alertMessage = "<%=res_msg%>";
		
		if ( 0 < "<%=res_cd%>".length ) {
			alertMessage += " (CODE : <%=res_cd%>)";
		}
		
		alert(alertMessage);
		window.parent.refreshOrderPage();
		
	}
</script>

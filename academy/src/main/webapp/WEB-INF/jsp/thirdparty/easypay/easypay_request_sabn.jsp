<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Enumeration"%>
<%
/* -------------------------------------------------------------------------- */
/* 캐쉬 사용안함                                                              */
/* -------------------------------------------------------------------------- */
response.setHeader("cache-control","no-cache");
response.setHeader("expires","-1");
response.setHeader("pragma","no-cache");

System.out.println(">>> /WEB-INF/jsp/thirdparty/easypay/easypay_request_sabn.jsp");

Enumeration<String> parameterNames = request.getParameterNames();
while (parameterNames.hasMoreElements()) {

    String paramName = parameterNames.nextElement();
    System.out.println(paramName);

    String[] paramValues = request.getParameterValues(paramName);
    for (int i = 0; i < paramValues.length; i++) {
        // String paramValue = paramValues[i];
        // System.out.println("\t" + paramValue);
        // System.out.println("\t\n");
    }
}

String resCode = (String) request.getAttribute("res_cd");
String resMsg = (String) request.getAttribute("res_msg");
String dbResult = (String) request.getAttribute("bDBProc");
String hybrisDomain = (String) request.getAttribute("hybrisDomain");
String invoiceQueue = (String) request.getAttribute("invoiceQueue");
String currentBusiness = (String) request.getAttribute("currentBusiness");

// System.out.println("resCode : " + resCode);
// System.out.println("resMsg : " + resMsg);
// System.out.println("dbResult : " + dbResult);
// System.out.println("hybrisDomain : " + hybrisDomain);
// System.out.println("invoiceQueue : " + invoiceQueue);
// System.out.println("currentBusiness : " + currentBusiness);
/*
if( "0000".equals(resCode.trim()) && "true".equals(dbResult.trim())){
	
	if( "edu".equals(currentBusiness) ) {
		RequestDispatcher rd = request.getRequestDispatcher(hybrisDomain + "/reservation/roomEduReservOk?invoiceQueue=" + invoiceQueue);
		rd.forward(request, response);
	} else {
		RequestDispatcher rd = request.getRequestDispatcher(hybrisDomain + "/reservation/roomQueenReservOk?invoiceQueue=" + invoiceQueue);
		rd.forward(request, response);
	}
	
} else if( !"0000".equals(resCode) && "false".equals(dbResult) ) {
	out.print("<script>alert('" + resMsg + "')</script>");
} else if( "0000".equals(resCode) && "false".equals(dbResult) ) {
	out.print("<script>alert('내부 서버 오류로 인해 결제가 실패했습니다.')</script>");
} else {
	out.print("<script>alert('" + resMsg + "')</script>");
}

String returnUrl = hybrisDomain;

if( "edu".equals(currentBusiness) ) {
	returnUrl = "/reservation/roomEduForm/";
} else {
	returnUrl = "/reservation/roomQueenForm/";
}

RequestDispatcher rd = request.getRequestDispatcher(hybrisDomain + returnUrl);
rd.forward(request, response);
*/
//response.sendRedirect(hybrisDomain + returnUrl);
%>
<html>
<meta name="robots" content="noindex, nofollow">
<head>
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
   	
   	try {
	   	if( "localhost" != document.domain){
	   		document.domain="abnkorea.co.kr";
	   	}
	   	
   		if ( "0000" == "${res_cd}" && "true" == "${bDBProc}" ) {

   			/* 정상 결제 완료 */
   	   		/* 1. virtualNumber / 2. resCode / 3. resMsg */
   	   		var virtualNumber = '${invoiceQueue}';
   	   		var resCode = '${res_cd}';
   	   		var resMsg = '${res_msg}';
   	   		
   	   		//currentBusiness
   	   		if ('edu' == '${currentBusiness}') {

   	   			alert("교육장 결제가 완료되었습니다.");

   	   			var frm = document.redrt;
   	   			frm.target = "_top";
				frm.action = "${hybrisDomain}/reservation/roomEduReservOk";
				frm.submit();
				
				//location.href = "${hybrisDomain}/reservation/roomEduReservOk?virtualNumber=" + virtualNumber;
				
   	   		} else {
   	   			
   	   			alert("퀸룸/파티룸의 결제가 완료되었습니다.");
   	   			
   	   			var frm = document.redrt;
   	   			frm.target = "_top";
				frm.action = "${hybrisDomain}/reservation/roomQueenReservOk";
				frm.submit();

   	   			//location.href = "${hybrisDomain}/reservation/roomQueenReservOk?virtualNumber=" + virtualNumber;
   	   		}
   			
   		} else if ( "0000" != "${res_cd}" && "${bDBProc}" == "false"){
   			
   			var alertMessage = "${res_msg}";
   			
   			if ( 0 < '${res_cd}'.length){
   				alertMessage += " (CODE : ${res_cd})";
   			}

   			alert(alertMessage);
   			
   			/* redirect */
   	   		if ('edu' == '${currentBusiness}') {
   				location.href = "${hybrisDomain}/reservation/roomEduForm";
   			} else {
   				location.href = "${hybrisDomain}/reservation/roomQueenForm";
   			}
   			
   		} else if ( "0000" == "${res_cd}" && "${bDBProc}" == "false"){
   			
   			var alertMessage = "내부 서버 오류로 인해 결제가 실패했습니다.";
   	   			
			if ( 0 < '${res_cd}'.length){
				alertMessage += " (CODE : ${res_cd})";
			}

			alert(alertMessage);
			
			/* redirect */
	   		if ('edu' == '${currentBusiness}') {
				location.href = "${hybrisDomain}/reservation/roomEduForm";
			} else {
				location.href = "${hybrisDomain}/reservation/roomQueenForm";
			}
   	   			
   		} else {
   			
			var alertMessage = "${res_msg}";
   			
   			if ( 0 < '${res_cd}'.length){
   				alertMessage += " (CODE : ${res_cd})";
   			}

   			alert(alertMessage);
   			
   			/* redirect */
   	   		if ('edu' == '${currentBusiness}') {
   				location.href = "${hybrisDomain}/reservation/roomEduForm";
   			} else {
   				location.href = "${hybrisDomain}/reservation/roomQueenForm";
   			}
   			
   		}
   		
   	} catch (e) {
   		alert(e);
   	}
   	
});
</script>
</head>
	<body>
		<form name="redrt" id="redrt" method="GET" >
			<input type="hidden" id="virtualNumber" name="virtualNumber" value="${invoiceQueue}" />
		</form>
		
		<%-- 
		. ${res_cd} <br/>
		. ${res_msg} <br/>
		. ${bDBProc} <br/>
		. ${hybrisDomain} <br/>
		. ${invoiceQueue} : 처리중입니다.
		 --%>
		 
		<div id="loading" style="position: fixed; top: 0px; right: 0px; width: 100%; height: 100%; display: block;">
			<div style="position: absolute; top: calc(50% - 75px); left:calc(50% - 75px);" >
				<img src="/_ui/desktop/images/common/loading.gif" alt="로딩중">
			</div>
		</div>
		<div class="loadMask" id="loadMask" style="display:block"></div>
	</body>
</html>
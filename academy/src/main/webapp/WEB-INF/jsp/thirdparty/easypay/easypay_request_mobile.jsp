<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Enumeration"%>
<%
/* -------------------------------------------------------------------------- */
/* 캐쉬 사용안함                                                              */
/* -------------------------------------------------------------------------- */
response.setHeader("cache-control","no-cache");
response.setHeader("expires","-1");
response.setHeader("pragma","no-cache");

System.out.println(">>> /WEB-INF/jsp/thirdparty/easypay/easypay_request_mobile.jsp");

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
<html>
<meta name="robots" content="noindex, nofollow">
<head>
<script type="text/javascript">
window.onload = function() {
    	
   	if( "localhost" != document.domain){
   		document.domain="abnkorea.co.kr";
   	}
   	
   	try {
   	
   		var res_msg = "<%=(String) request.getParameter("res_msg")  %>";
   		
   		if ( "<%=request.getParameter("res_cd") %>" == "0000" ){
   			
	        self.opener.document.getElementById("EP_res_cd").value         = "<%=request.getParameter("res_cd") %>";
	        self.opener.document.getElementById("EP_res_msg").value        = encodeURIComponent(res_msg);
	        self.opener.document.getElementById("EP_tr_cd").value          = "<%=request.getParameter("tr_cd") %>";
	        self.opener.document.getElementById("EP_ret_pay_type").value   = "<%=request.getParameter("pay_type") %>";
	        self.opener.document.getElementById("EP_card_code").value      = "<%=request.getParameter("card_cd") %>";
	        self.opener.document.getElementById("EP_card_req_type").value  = "<%=request.getParameter("card_no_7") %>";
	        self.opener.document.getElementById("EP_trace_no").value       = "<%=request.getParameter("m_cert_no") %>";
	        self.opener.document.getElementById("EP_sessionkey").value     = "<%=request.getParameter("sessionkey") %>";
	        self.opener.document.getElementById("EP_encrypt_data").value   = "<%=request.getParameter("encrypt_data") %>";

	       	self.opener.setProcessTrue();
	       	self.opener.doneReservation();
	       	self.opener.f_submit();
	        
   		}else if ( "<%=request.getParameter("EP_res_cd") %>" == "W002" ){
   			alert( "<%=request.getParameter("res_cd") %> : USER CANCEL" );
   			
   		}else{
   			alert( "<%=request.getParameter("res_cd") %> : ERROR" );
   		}

       	self.opener.setHideLoading();
       	//self.close();
       	//cross browsing
       	window.open("about:blank","_self").close();
   		
   	} catch (e) {
   		alert(e);
   	}
   	
}
</script>
</head>
<body>easypay_request_mobile</body>
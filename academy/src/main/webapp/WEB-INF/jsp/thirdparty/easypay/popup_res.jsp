<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.Enumeration"%>
<%@ page pageEncoding="EUC-KR"%>
<%
/* -------------------------------------------------------------------------- */
/* 캐쉬 사용안함                                                              */
/* -------------------------------------------------------------------------- */
response.setHeader("cache-control","no-cache");
response.setHeader("expires","-1");
response.setHeader("pragma","no-cache");

request.setCharacterEncoding("EUC-KR");

/* 
Enumeration e = request.getParameterNames();
String name = null;

while (e.hasMoreElements()){
	name = e.nextElement().toString();
	System.out.println(">> " + name + " : " + request.getParameter(name));
}
 */
%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=10" />
<meta name="robots" content="noindex, nofollow" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<script>

    window.onload = function()
    {
    	
    	if( "localhost" != document.domain){
    		document.domain="abnkorea.co.kr";
    	}
    	
    	try {
    		
	        /* UTF-8 사용가맹점의 경우 한글이 들어가는 값은 모두 decoding 필수 */
	        var res_msg = "<%=(String) request.getParameter("EP_res_msg")  %>";
	
	        if( "<%=request.getParameter("EP_res_cd") %>" == "0000" )
	        {
	        	
		        self.opener.document.getElementById("EP_res_cd").value         = "<%=request.getParameter("EP_res_cd") %>";
		        self.opener.document.getElementById("EP_res_msg").value        = encodeURIComponent(res_msg);
		        self.opener.document.getElementById("EP_tr_cd").value          = "<%=request.getParameter("EP_tr_cd") %>";
		        self.opener.document.getElementById("EP_ret_pay_type").value   = "<%=request.getParameter("EP_ret_pay_type") %>";
		        self.opener.document.getElementById("EP_ret_complex_yn").value = "<%=request.getParameter("EP_ret_complex_yn") %>";
		        self.opener.document.getElementById("EP_card_code").value      = "<%=request.getParameter("EP_card_code") %>";
		        self.opener.document.getElementById("EP_eci_code").value       = "<%=request.getParameter("EP_eci_code") %>";
		        self.opener.document.getElementById("EP_card_req_type").value  = "<%=request.getParameter("EP_card_req_type") %>";
		        self.opener.document.getElementById("EP_save_useyn").value     = "<%=request.getParameter("EP_save_useyn") %>";
		        self.opener.document.getElementById("EP_trace_no").value       = "<%=request.getParameter("EP_trace_no") %>";
		        self.opener.document.getElementById("EP_sessionkey").value     = "<%=request.getParameter("EP_sessionkey") %>";
		        self.opener.document.getElementById("EP_encrypt_data").value   = "<%=request.getParameter("EP_encrypt_data") %>";
		        self.opener.document.getElementById("EP_spay_cp").value        = "<%=request.getParameter("EP_spay_cp") %>";
		        self.opener.document.getElementById("EP_prepaid_cp").value     = "<%=request.getParameter("EP_prepaid_cp") %>";
		        
		        self.opener.setProcessTrue();
		        //self.opener.doneReservation();
	            self.opener.f_submit();
	            
	        }
	        else if ( "<%=request.getParameter("EP_res_cd") %>" == "W002" ) {
	        	alert( "<%=request.getParameter("EP_res_cd") %> : USER CANCEL" );
	        }
	        else
	        {
	            alert( "<%=request.getParameter("EP_res_cd") %> : ERROR" );
	        }
	    	
	        self.opener.setHideLoading();
	        self.close();
	        
    	} catch (e) {
    		alert(e);
    	}
    
    }
    
	function urldecode( str ) {
		// 공백 문자인 + 를 처리하기 위해 +('%20') 을 공백으로 치환
		return decodeURIComponent((str + '').replace(/\+/g, '%20'));
	}
</script>
<title>webpay 가맹점 test page</title>
</head>
<body>
</body>
</html>
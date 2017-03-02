<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Enumeration"%>
<%-- <%@ include file="../inc/easypay_config.jsp" %><!-- ' 환경설정 파일 include --> --%>
<%
	System.out.println(">>> /WEB-INF/jsp/thirdparty/easypay/order.jsp");
	Enumeration eHeader = request.getHeaderNames();

	while (eHeader.hasMoreElements()) {
		String hName = (String)eHeader.nextElement();
		String hValue = request.getHeader(hName);
	
		System.out.println(hName + " : " + hValue);
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>KICC EASYPAY 8.0 SAMPLE</title>
<meta name="robots" content="noindex, nofollow"> 
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="requiresActiveX=true">
<meta http-equiv="cache-control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<!-- <link href="../css/style.css" rel="stylesheet" type="text/css"> -->
<!-- <script language="javascript" src="../js/default.js" type="text/javascript"></script> -->

<script type="text/javascript">

	var currentLocation = "${currentDomain}";

	if( "localhost" != document.domain){
		document.domain="abnkorea.co.kr";
	}

	var ezPayPopup;

    /* 입력 자동 Setting */
    function f_init(){
    	
    	//alert('opener : ' + document.domain);
    	
        var frm_pay = document.frm_pay;
        
        var today = new Date();
        var year  = today.getFullYear();
        var month = today.getMonth() + 1;
        var date  = today.getDate();
        var time  = today.getTime();
        
        if(parseInt(month) < 10) {
            month = "0" + month;
        }

        if(parseInt(date) < 10) {
            date = "0" + date;
        }
        
        frm_pay.EP_vacct_end_date.value = "" + year + month + date;
        frm_pay.EP_vacct_end_time.value = "235959";
        frm_pay.EP_order_no.value = "AMWAY_" + year + month + date + time;   //가맹점주문번호
        frm_pay.EP_user_id.value = "${getMemberInformation.account}";
        frm_pay.EP_user_nm.value = "${getMemberInformation.accountname}";
        frm_pay.EP_user_mail.value = "";
        frm_pay.EP_user_phone1.value = "";
        frm_pay.EP_user_phone2.value = "01012344567";
        frm_pay.EP_user_addr.value = "";
        frm_pay.EP_product_nm_tmp.value = "교육장";
        frm_pay.EP_product_amt.value = "";
        
        //frm_pay.EP_return_url.value = currentLocation + "/thirdparty/easypay/popup_res.jsp";
        frm_pay.EP_return_url.value = currentLocation + "/easypay/popupResponse.do";
        
    }
    
    function f_start_pay() {
        var frm_pay = document.frm_pay;
		
		/* 가맹점사용카드리스트 */
        var usedcard_code = "";
        for( var i=0; i < frm_pay.usedcard_code.length; i++) {
            if (frm_pay.usedcard_code[i].checked) {
                usedcard_code += frm_pay.usedcard_code[i].value + ":";
            }
        }
        frm_pay.EP_usedcard_code.value = usedcard_code;
        
        /* 가상계좌은행리스트 */
        var vacct_bank = "";
        for( var i=0; i < frm_pay.vacct_bank.length; i++) {
            if (frm_pay.vacct_bank[i].checked) {
                vacct_bank += frm_pay.vacct_bank[i].value + ":";
            }
        }
        frm_pay.EP_vacct_bank.value = vacct_bank;
        
        /* 복합과세 가맹점만 사용 */
        if( frm_pay.EP_tax_flg.value == "TG01" ) {
					  if( !frm_pay.EP_com_tax_amt.value ) {
	              alert("과세 승인 금액을 입력하세요.!!");
	              frm_pay.EP_com_tax_amt.focus();
	              return;
	          }
            
	          if( !frm_pay.EP_com_free_amt.value ) {
	              alert("비과세 승인 금액을 입력하세요.!!");
	              frm_pay.EP_com_free_amt.focus();
	              return;
	          }
            
	          if( !frm_pay.EP_com_vat_amt.value ) {
	              alert("부가세 금액을 입력하세요.!!");
	              frm_pay.EP_com_vat_amt.focus();
	              return;
	          }
        }
		
		/* UTF-8 사용가맹점의 경우 EP_charset 값 셋팅 필수 */
        if( frm_pay.EP_charset.value == "UTF-8" ) {
            // 한글이 들어가는 값은 모두 encoding 필수.
            frm_pay.EP_mall_nm.value      = encodeURIComponent( encodeURIComponent( frm_pay.EP_mall_nm_tmp.value ) );
            frm_pay.EP_product_nm.value   = encodeURIComponent( encodeURIComponent( frm_pay.EP_product_nm_tmp.value ) );
            frm_pay.EP_user_nm.value      = encodeURIComponent( encodeURIComponent( frm_pay.EP_user_nm_tmp.value ) );
        }
		
        ezPayPopup = window.open("", "kicc_webpay", "width=816, height=546, innerWidth=823, innerHeight=500, location=no, menubar=no, resizable=no, scrollbars=no, status=no, toolbar=no");
        //ezPayPopup.onbeforeunload = function(){ alert('ezPayPopup');}
        
        frm_pay.target = "kicc_webpay";
        frm_pay.action = "/easypay/popupRequest.do";
        frm_pay.submit();
        
		openOrderPopup();
    }
    
    
    function openOrderPopup() {
    	
        var popupCheck = setInterval(function(){
        	
        	//console.log(ezPayPopup);
        	if( null == ezPayPopup || ezPayPopup.closed){
        		clearInterval(popupCheck);
        		//console.log(window.parent.resultKiccProcess.value);
        		
        		if("false" == window.parent.resultKiccProcess.value){
	        		alert('결제가 취소 되었습니다.');
	        		window.parent.hideLoading();
        		}
        	}
        	
        }, 500);
    }
    
    function setHideLoading(){
    	window.parent.hideLoading();
    }
    
    function setProcessTrue(){
    	window.parent.resultKiccProcess.value = 'true';
    }
    
    function doneReservation(){
    	window.parent.roomEduRsvDetail();
    }
    
    function f_submit() {
		var frm_pay = document.frm_pay;
		frm_pay.target = "_self";
		//frm_pay.action = "/easypay/easypayRequest.do";
		frm_pay.action = "/easypay/easypayRequestProcess.do";
		frm_pay.submit();
    }
    
</script>
<body onload="f_init();">

	<form name="frm_pay" method="post" action="">
	
	<!-- ---------------------------------------------------------------------------- -->
	<div id="reservationElements"></div>
	<!-- ---------------------------------------------------------------------------- -->
	
	<input type="hidden" id="EP_res_cd"         name="EP_res_cd"         value="">    <!-- [R] 응답코드 //-->
	<input type="hidden" id="EP_res_msg"        name="EP_res_msg"        value="">    <!-- [R] 응답메시지 //-->
	<input type="hidden" id="EP_tr_cd"          name="EP_tr_cd"          value="">    <!-- [R] 플러그인 요청구분 //-->
	<input type="hidden" id="EP_trace_no"       name="EP_trace_no"       value="">    <!-- [R] 거래추적번호 //-->
	<input type="hidden" id="EP_sessionkey"     name="EP_sessionkey"     value="">    <!-- [R] 암호화키 //-->
	<input type="hidden" id="EP_encrypt_data"   name="EP_encrypt_data"   value="">    <!-- [R] 암호화전문 //-->
	<input type="hidden" id="EP_card_req_type"  name="EP_card_req_type"  value="">    <!-- [R] 카드 요청구분(0:일반 1:ISP 2:MPI 3:UPOP) //-->
	<input type="hidden" id="EP_card_code"      name="EP_card_code"      value="">    <!-- [R] 인증카드코드 //-->
	<input type="hidden" id="EP_ret_pay_type"   name="EP_ret_pay_type"   value="">    <!-- [R] 결제수단 //-->
	<input type="hidden" id="EP_ret_complex_yn" name="EP_ret_complex_yn" value="">    <!-- [R] 복합결제여부 //-->
	<input type="hidden" id="EP_eci_code"       name="EP_eci_code"       value="">    <!-- [R] MPI인 경우 ECI코드 //-->
	<input type="hidden" id="EP_save_useyn"     name="EP_save_useyn"     value="">    <!-- [R] 카드사 세이브 여부 (Y/N) //-->
	<input type="hidden" id="EP_spay_cp"        name="EP_spay_cp"        value="">    <!-- [R] 간편결제 CP 코드 //-->
	<input type="hidden" id="EP_prepaid_cp"     name="EP_prepaid_cp"     value="">    <!-- [R/W] 선불결제 CP 코드 (CCB:캐시비, ECB:이지캐시) //-->
	                                            
	<input type="hidden" id="EP_user_define1"   name="EP_user_define1"   value="">    <!-- [R/W] 예비필드1 //-->
	<input type="hidden" id="EP_user_define2"   name="EP_user_define2"   value="">    <!-- [R/W] 예비필드2 //-->
	<input type="hidden" id="EP_user_define3"   name="EP_user_define3"   value="">    <!-- [R/W] 예비필드3 //-->
	<input type="hidden" id="EP_user_define4"   name="EP_user_define4"   value="">    <!-- [R/W] 예비필드4 //-->
	<input type="hidden" id="EP_user_define5"   name="EP_user_define5"   value="">    <!-- [R/W] 예비필드5 //-->
	<input type="hidden" id="EP_user_define6"   name="EP_user_define6"   value="">    <!-- [R/W] 예비필드6 //-->
	
	<!-- ---------------------------------------------------------------------------- -->
	
	<input type="hidden" id="EP_return_url"     name="EP_return_url"     value="">    <!-- [W] 인증응답 받을 callback URL -->
	<input type="hidden" id="EP_usedcard_code"  name="EP_usedcard_code"  value="">    <!-- [W] 카드사 리스트 -->
	<input type="hidden" id="EP_vacct_bank"     name="EP_vacct_bank"     value="">    <!-- [W] 가상계좌 은행 리스트 -->
	<input type="hidden" id="EP_os_cert_flag"   name="EP_os_cert_flag"   value="2">   <!-- [W] [변경불가] 해외카드인증구분 //-->
	
	<!-- ---------------------------------------------------------------------------- -->
	
	<%-- 
	
	<input type="hidden" name="EP_mall_id" value="05109649" >
	<input type="hidden" name="EP_mall_nm" value="한국암웨이" >
	<input type="hidden" name="EP_pay_type" value="11" >
	<input type="hidden" name="EP_currency" value="00" >
	<input type="hidden" name="EP_vacct_end_date" value="" >
	<input type="hidden" name="EP_vacct_end_time" value="" >
	<input type="hidden" name="EP_order_no" value="" >
	
	<input type="hidden" name="EP_user_id" value="" >
	<input type="hidden" name="EP_user_nm" value="" >
	<input type="hidden" name="EP_user_mail" value="" >
	<input type="hidden" name="EP_user_phone1" value="" >
	<input type="hidden" name="EP_user_phone2" value="" >
	<input type="hidden" name="EP_user_addr" value="" >
	<input type="hidden" name="EP_product_nm" value="" >
	<input type="hidden" name="EP_product_amt" value="" >
	<input type="hidden" name="EP_tax_flg" value="" >
	<input type="hidden" name="EP_charset" value="UTF-8" >
	
	<input type="hidden" name="usedcard_code" value="" >
	<input type="hidden" name="vacct_bank" value="" >
	--%>
	
	<input type="text" name="EP_mall_nm_tmp" value="${mallName}" size="50" class="input_A">
	<input type="text" name="EP_product_nm_tmp" value="" size="50" class="input_A">
	<input type="text" name="EP_user_nm_tmp" value="" size="50" class="input_A">
	
	<table border="0" width="910" cellpadding="10" cellspacing="0">
	<tr>
	    <td>
	    <!-- title start -->
	    <table border="0" width="900" cellpadding="0" cellspacing="0">
	    <tr>
	        <td height="30" bgcolor="#FFFFFF" align="left">&nbsp;<!-- <img src="../img/arow3.gif" border="0" align="absmiddle"> -->&nbsp;일반 > <b>결제</b></td>
	    </tr>
	    <tr>
	        <td height="2" bgcolor="#2D4677"></td>
	    </tr>
	    </table>
	    <!-- title end -->
		   
	    <!-- mallinfo start -->
	    <table border="0" width="900" cellpadding="0" cellspacing="0">
	    <tr>
	        <td height="30" bgcolor="#FFFFFF">&nbsp;<!-- <img src="../img/arow2.gif" border="0" align="absmiddle"> -->&nbsp;<b>가맹점정보</b>(*필수)</td>
	    </tr>
	    </table>
		
	    <table border="0" width="900" cellpadding="0" cellspacing="1" bgcolor="#DCDCDC">
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] *가맹점아이디</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_mall_id" value="${mallId}" size="50" maxlength="8" class="input_F"></td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W][준비] 가맹점패스워드</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_mall_pwd" value="" size="50" class="input_A"></td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 가맹점명</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_mall_nm" value="" size="50" class="input_A"></td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W][준비] 가맹점 CI URL</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_ci_url" value="" size="50" class="input_A"></td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W][준비] 영문버젼여부</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;
	            <select name="EP_lang_flag" class="input_A">
	                <option value="" selected>한글</option>
	                <option value="ENG">영문</option>
	            </select>
	        </td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W][준비] 가맹점개발언어</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;
	        	  <select name="EP_agent_ver" class="input_A">
	                <option value="JSP" selected>JSP</option>
	                <option value="PHP">PHP</option>
	                <option value="ASP">ASP</option>
	                <option value="NET">NET</option>
	            </select>
	        </td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] *Charset</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;
	            <select name="EP_charset" class="input_A">
	                <option value="EUC-KR" >EUC-KR</option>
	                <option value="UTF-8" selected>UTF-8</option>
	            </select>
	        </td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;</td>
	    </tr>
	    </table>
	    <!-- mallinfo end -->
	    
	    <!-- webpay start -->
	    <table border="0" width="900" cellpadding="0" cellspacing="0">
	    <tr>
	        <td height="30" bgcolor="#FFFFFF">&nbsp;<!-- <img src="../img/arow2.gif" border="0" align="absmiddle"> -->&nbsp;<b>결제창 정보</b>(*필수)</td>
	    </tr>
	    </table>
	
	    <table border="0" width="900" cellpadding="0" cellspacing="1" bgcolor="#DCDCDC">
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] *결제수단</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;
	            <select name="EP_pay_type" class="input_F">
	                <option value="11">신용카드</option>            
	                <option value="21">계좌이체</option>
	                <option value="22">무통장입금</option>
	                <option value="31">휴대폰</option>
	                <option value="50">선불결제</option>
	                <option value="60">간편결제</option>
	                <!-- 2015-06-10 모든결제수단 선택 금지!
			 <option value="11:21:22:31:50:60" selected>모든결제수단</option> 
	                -->
	            </select>
	        </td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] *통화코드</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;
	            <select name="EP_currency" class="input_F">
	                <option value="00" selected>원화</option>
	            </select>
	        </td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 사용가능 카드리스트</td>
	    	  <td bgcolor="#FFFFFF" width="300">&nbsp;
	    	  <!-- <input type="checkbox" name="usedcard_code" value="" checked>전체카드 -->
	    	  <input type="hidden" id="usedcard_code" name="usedcard_code" value="" />
	    	  </td>        
	        <!-- 가맹점에서 사용 가능한 카드만 노출하고 싶을 때 아래 코드를 삽입 하시기 바랍니다. -->
	        <td bgcolor="#FFFFFF" width="750" colspan="3">&nbsp;
	        	<!-- 
	        	<input type="checkbox" name="usedcard_code" value="016" checked>국민(016)
	            <input type="checkbox" name="usedcard_code" value="027" checked>현대(027)
	        	<input type="checkbox" name="usedcard_code" value="029" checked>신한(029)
	            <input type="checkbox" name="usedcard_code" value="031" checked>삼성(031)
	            <input type="checkbox" name="usedcard_code" value="002" checked>광주(002)
	            <input type="checkbox" name="usedcard_code" value="047" checked>롯데(047)
	            <input type="checkbox" name="usedcard_code" value="026" checked>비씨(026)
	            <input type="checkbox" name="usedcard_code" value="058" checked>산업(058)
	            <input type="checkbox" name="usedcard_code" value="017" checked>수협(017)
	            <input type="checkbox" name="usedcard_code" value="011" checked>제주(011)
	            <input type="checkbox" name="usedcard_code" value="022" checked>시티(022)
	            <input type="checkbox" name="usedcard_code" value="008" checked>외환(008)
	            <input type="checkbox" name="usedcard_code" value="010" checked>전북(010)
	            <input type="checkbox" name="usedcard_code" value="006" checked>하나SK(006)
	            <input type="checkbox" name="usedcard_code" value="018" checked>NH농협(018)
	            -->
	        </td>
	
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 할부개월</td>        
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" id="EP_quota" name="EP_quota" value="00:02:03:04:05:06:07:08:09:10:11:12" size="50" class="input_A"></td>      
	    </tr>
	    <tr height="25">
	    	<td bgcolor="#EDEDED" width="150">&nbsp;[W] 무이자사용여부</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;
	            <select name="EP_noinst_flag" class="input_A">
	                <option value="" selected>DB조회</option>
	                <option value="Y">무이자</option>
	                <option value="N">일반</option>
	            </select>
	        </td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 무이자설정<br>&nbsp;(카드코드-할부개월)</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_noinst_term" value="029-02:03:04:05:06,027-02:03" size="50" class="input_A"></td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 포인트카드 사용유무</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;
	            <select name="EP_set_point_card_yn" class="input_A">
	                <option value="Y">사용</option>
	                <option value="N" selected>미사용</option>
	            </select>
	        </td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 카드사 포인트 </td>
	        <!-- 동일 카드코드는 입력하지 마시요(027-40,027-60 X). -->
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_point_card" value="" size="50" class="input_A"></td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 가상계좌<br>&nbsp;은행 리스트</td>
	        <td bgcolor="#FFFFFF" width="750" colspan="3">&nbsp;
	            <input type="checkbox" name="vacct_bank" value="003" checked>기업은행(003)
	            <input type="checkbox" name="vacct_bank" value="004" checked>국민은행(004)
	            <input type="checkbox" name="vacct_bank" value="011" checked>농협중앙회(011)
	            <input type="checkbox" name="vacct_bank" value="020" checked>우리은행(020)<br>
	            &nbsp;<input type="checkbox" name="vacct_bank" value="023" checked>SC제일은행(023)
	            <input type="checkbox" name="vacct_bank" value="026" checked>신한은행(026)
	            <input type="checkbox" name="vacct_bank" value="032" checked>부산은행(032)
	            <input type="checkbox" name="vacct_bank" value="071" checked>우체국(071)
	            <input type="checkbox" name="vacct_bank" value="081" checked>하나은행(081)
	        </td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 가상계좌<br>&nbsp;입금만료일</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_vacct_end_date" value="" size="50" class="input_A"></td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 가상계좌<br>&nbsp;입금만료시간</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_vacct_end_time" value="" size="50" class="input_A"></td>
	    </tr>
	    </table>
	    <!-- webpay end -->
	   
	    <!-- order start -->
	    <table border="0" width="900" cellpadding="0" cellspacing="0">
	    <tr>
	        <td height="30" bgcolor="#FFFFFF">&nbsp;<!-- <img src="../img/arow2.gif" border="0" align="absmiddle"> -->&nbsp;<b>주문정보</b>(*필수)</td>
	    </tr>
	    </table>
	    <table border="0" width="900" cellpadding="0" cellspacing="1" bgcolor="#DCDCDC">
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] *주문번호</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_order_no" size="50" class="input_F"></td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 사용자구분</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;
	            <select name="EP_user_type" class="input_A">
	                <option value="1">일반</option>
	                <option value="2" selected>회원</option>
	            </select>
	        </td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 고객ID</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_user_id" size="50" class="input_A"></td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 고객명</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_user_nm" size="50" class="input_A"></td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 고객Email</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_user_mail" size="50" class="input_A"></td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 고객전화번호</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_user_phone1" size="50" class="input_A"></td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] *고객휴대폰</td>
	        <td bgcolor="#FFFFFF" width="750" colspan="3">&nbsp;<input type="text" name="EP_user_phone2" size="50" class="input_F"></td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 고객주소</td>
	        <td bgcolor="#FFFFFF" width="750" colspan="3">&nbsp;<input type="text" name="EP_user_addr" size="100" class="input_A"></td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] *상품명</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_product_nm" size="50" class="input_F"></td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] *상품금액</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_product_amt" size="50" class="input_F"></td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 상품구분</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;
	            <select name="EP_product_type" class="input_A">
	                <option value="0" selected>실물</option>
	                <option value="1">컨텐츠</option>
	            </select>
	        </td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 서비스기간</td>                                                      
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_product_expr" size="50" class="input_F"></td>
	    </tr>
	    <!-- 복합과세 가맹점만 사용 -->
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 과세구분</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;
	            <select name="EP_tax_flg" class="input_A">
	                <option value="" selected>일반</option>
	                <option value="TG01">복합과세</option>
	            </select>
	        </td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 과세 승인금액</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_com_tax_amt" size="50" class="input_A"></td>
	    </tr>
	    <tr height="25">
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 비과세 승인금액</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_com_free_amt" size="50" class="input_A"></td>
	        <td bgcolor="#EDEDED" width="150">&nbsp;[W] 부가세 금액</td>
	        <td bgcolor="#FFFFFF" width="300">&nbsp;<input type="text" name="EP_com_vat_amt" size="50" class="input_A"></td>
	    </tr>
	    </table>
	    <!-- order Data END -->
	
	    <table border="0" width="900" cellpadding="0" cellspacing="0">
	    <tr>
	        <td height="30" align="center" bgcolor="#FFFFFF"><input type="button" value="결 제" class="input_D" style="cursor:hand;" onclick="javascript:f_start_pay();"></td>
	    </tr>
	    </table>
	    </td>
	</tr>
	</table>
	</form>

</body>
</html>
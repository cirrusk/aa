<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration"%>
<%
	System.out.println(">>> /WEB-INF/jsp/thirdparty/easypay/order_mobile.jsp");
	Enumeration eHeader = request.getHeaderNames();

	while (eHeader.hasMoreElements()) {
		String hName = (String)eHeader.nextElement();
		String hValue = request.getHeader(hName);
	
		System.out.println(hName + " : " + hValue);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>KICC EASYPAY 8.0 SAMPLE</title>
<script type="text/javascript">

	var browser;
	
	//브라우저 종류 (for safari)    
	(function() {
	
	    // 브라우저 및 버전을 구하기 위한 변수들.
		'use strict';
	    var agent = navigator.userAgent.toLowerCase(),
	        name = navigator.appName;
	    
	    // MS 계열 브라우저를 구분하기 위함.
	    if(agent.indexOf('amway_') > -1){
	    	browser = 'sabn';
	    }else if(name === 'Microsoft Internet Explorer' || agent.indexOf('trident') > -1 || agent.indexOf('edge/') > -1) {
	        browser = 'ie';
	        if(name === 'Microsoft Internet Explorer') { // IE old version (IE 10 or Lower)
	            agent = /msie ([0-9]{1,}[\.0-9]{0,})/.exec(agent);
	            browser += parseInt(agent[1]);
	        } else { // IE 11+
	            if(agent.indexOf('trident') > -1) { // IE 11 
	                browser += 11;
	            } else if(agent.indexOf('edge/') > -1) { // Edge
	                browser = 'edge';
	            }
	        }
	    } else if(agent.indexOf('safari') > -1) { // Chrome or Safari
	        if(agent.indexOf('opr') > -1) { // Opera
	            browser = 'opera';
	        } else if(agent.indexOf('chrome') > -1) { // Chrome
	            browser = 'chrome';
	        } else { // Safari
	            browser = 'safari';
	        }
	    } else if(agent.indexOf('firefox') > -1) { // Firefox
	        browser = 'firefox';
	    }
	
	    // IE: ie7~ie11, Edge: edge, Chrome: chrome, Firefox: firefox, Safari: safari, Opera: opera
	    //document.getElementsByTagName('html')[0].className = browser;
	}());

	var currentLocation = "${currentDomain}";

	if( "localhost" != document.domain){
		document.domain="abnkorea.co.kr";
	}
	
	function f_init(){
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
        
        frm_pay.sp_order_no.value = "AMWAY_" + year + month + date + time;   //가맹점주문번호
        frm_pay.sp_user_id.value = "${getMemberInformation.account}";                           //고객ID
        frm_pay.sp_user_nm.value = "${getMemberInformation.accountname}";
        frm_pay.sp_user_mail.value = "";
        frm_pay.sp_user_phone1.value = "";
        frm_pay.sp_user_phone2.value = "";
        frm_pay.sp_user_addr.value = "";
        frm_pay.sp_product_nm.value = "";
        frm_pay.sp_pay_mny.value = "";
        
        //org : /easypay_request.jsp
        //sds : https://dev2.abnkorea.co.kr/shop/order/checkout/checkoutProcessForMobileMpiIsp
        if( 'sabn' == browser ){
        	frm_pay.sp_return_url.value = "${currentDomain}/easypay/easypayRequestSabn.do";
        } else {
	        frm_pay.sp_return_url.value = "${currentDomain}/easypay/easypayRequestMobile.do";
        }
    }
    
	var ezPayPopup;
	
	function f_start_pay() {
		
		if('safari' == browser){
			alert("사파리 브라우저의 경우 결제 앱 종료이후 특정 카드사에 한해 쇼핑몰 애플리케이션을 다시 실행하셔야 결제가 진행, 완료됩니다. 반드시 쇼핑몰 애플리케이션을 다시 띄워 결제 결과를 확인해 주시기 바랍니다.");
		}
		
		var bankId = document.getElementById("usedcard_code").value;
		var usedcardCode = "";

		if ("B" == bankId){
			usedcardCode = "016"; 
		}else if ("4" == bankId){
			usedcardCode = "027"; 
		}else if ("3" == bankId){
			usedcardCode = "029"; 
		}else if ("2" == bankId){
			usedcardCode = "031"; 
		}else if ("9" == bankId){
			usedcardCode = "002"; 
		}else if ("5" == bankId){
			usedcardCode = "047"; 
		}else if ("A" == bankId){
			usedcardCode = "026"; 
		}else if ("C" == bankId){
			usedcardCode = "058"; 
		}else if ("8" == bankId){
			usedcardCode = "017"; 
		}else if ("6" == bankId){
			usedcardCode = "011"; 
		}else if ("7" == bankId){
			usedcardCode = "022"; 
		}else if ("1" == bankId){
			usedcardCode = "008"; 
		}else if ("10" == bankId){
			usedcardCode = "010"; 
		}else if ("11" == bankId){
			usedcardCode = "006"; 
		}else if ("12" == bankId){
			usedcardCode = "018"; 
		}

		frm_pay.sp_usedcard_code.value = usedcardCode;
		
        //UTF-8 사용 시 한글이 들어가는 필드를 다음과 같이 추가하시기 바랍니다.
        //frm_pay.sp_user_nm.value = encodeURIComponent(frm_pay.sp_user_nm.value);
        frm_pay.sp_mall_nm.value = encodeURIComponent( "한국 암웨이" );
        frm_pay.sp_product_nm.value = encodeURIComponent( document.getElementById("product_nm").value );
        frm_pay.sp_user_nm.value = encodeURIComponent( document.getElementById("user_nm").value );
        
        if( 'sabn' == browser ){
        	/* app 에서는 popup이 만들어지지 않으므로 페이지 포워딩 후에 처리 페이지로 이동한다. */
        	setHideLoading();
        	frm_pay.target = "_top";
        	frm_pay.action = "${easypayRequestPage}";
	        frm_pay.submit();
        }else{
        	ezPayPopup = window.open("", "kicc_webpay", "width=816, height=546, innerWidth=823, innerHeight=500, location=no, menubar=no, resizable=no, scrollbars=no, status=no, toolbar=no");
	        
        	frm_pay.target = "kicc_webpay";
	        frm_pay.action = "${easypayRequestPage}";
	        frm_pay.submit();
	        
	        openOrderPopup();
        }
        
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
    	frm_pay.action = "/easypay/easypayRequestProcessMobile.do";
    	frm_pay.submit();
    }
</script>
</head>
<body onload="f_init();">
	<!-- <form name="frm_pay" method="post" action="http://testsp.easypay.co.kr/main/MainAction.do"> -->
	
	<input type="hidden" id="usedcard_code" />
	<input type="hidden" id="product_nm" />
	<input type="hidden" id="user_nm" />
	
	<form name="frm_pay" method="post">
		<!-- ---------------------------------------------------------------------------- -->
		<div id="reservationElements"></div>
		<!-- ---------------------------------------------------------------------------- -->
		<input type="hidden" name="EP_res_cd"           id="EP_res_cd"                value="" />
		<input type="hidden" name="EP_res_msg"          id="EP_res_msg"               value="" />
		<input type="hidden" name="EP_tr_cd"            id="EP_tr_cd"                 value="" />
		<input type="hidden" name="EP_ret_pay_type"     id="EP_ret_pay_type"          value="" />
		<input type="hidden" name="EP_card_code"        id="EP_card_code"             value="" />
		<input type="hidden" name="EP_card_req_type"    id="EP_card_req_type"         value="" />
		<input type="hidden" name="EP_trace_no"         id="EP_trace_no"              value="" />
		<input type="hidden" name="EP_sessionkey"       id="EP_sessionkey"            value="" />
		<input type="hidden" name="EP_encrypt_data"     id="EP_encrypt_data"          value="" />
		
		<input type="hidden" name="sp_mall_id"          value="${mallId}">                    <!-- * 몰아이디 //-->
		<input type="hidden" name="sp_mall_nm"          value="">                             <!--   몰명 //-->
		<input type="hidden" name="sp_ci_url"           value="">                             <!--   CI 이미지 파일의 URL //-->     
		<input type="hidden" name="sp_lang_flag"        value="KOR">                          <!--   KOR : 국문, ENG : 영문 //-->     
		<input type="hidden" name="sp_agent_ver"        value="JSP">                          <!-- * 이지페이 버젼 (ASP, JSP, PHP, NET) //-->     
		<input type="hidden" name="sp_tr_cd"            value="00101000">                     <!-- * 결제처리종류 //-->     
		<input type="hidden" name="sp_pay_type"         value="11">                           <!-- * 결제수단 (신용카드 호출 : 11) //-->     
		<input type="hidden" name="sp_currency"         value="00">                           <!-- * 통화코드 (00 : 원화, 01 : 달러) //-->     
		<input type="hidden" name="sp_version"          value="0">                            <!-- * 버젼 (0 : 웹, 1 : 앱) //-->     
		<input type="hidden" name="sp_client_ip"        value="">                             <!-- * 스마트폰 사용자 IP //-->
		<input type="hidden" name="sp_return_url"       value="">                             <!--   리턴URL (가맹점이 응답받을 주소) //-->
		<input type='hidden' name="sp_app_return_url"   value="mobileAbnKorea://ispReturnEndHost"/>     
		<input type="hidden" name="sp_session_useyn"    value="Y">                            <!--   세션사용 (Y : 사용, N : 미사용) //-->     
		<input type="hidden" name="sp_charset"          value="UTF-8">                        <!-- * CharSet //-->     
		
		<input type="hidden" name="sp_order_no"         value="">		                      <!-- * 주문번호 //-->
		<input type="hidden" name="sp_product_nm"       value="">		                      <!-- * 상품명 //-->
		<input type="hidden" name="sp_pay_mny"          value=""		id="sp_pay_mny">      <!-- * 주문총액 //-->     
		<input type="hidden" name="sp_user_type"        value="2">                            <!--   사용자 구분 (1 : 일반, 2 : 회원) //-->
		<input type="hidden" name="sp_user_id"          value="">                             <!-- * 고객ID //-->
		<input type="hidden" name="sp_user_nm"          value="">                             <!-- * 고객명 //-->
		<input type="hidden" name="sp_user_mail"        value="">   	                      <!-- * 고객E-mail //-->
		<input type="hidden" name="sp_user_phone1"      value="">		                      <!--   고객 전화번호 //-->
		<input type="hidden" name="sp_user_phone2"      value="">		                      <!-- * 고객 휴대폰번호 //-->
		<input type="hidden" name="sp_user_addr"        value="">                             <!--   구매자 주소 //-->
		
		<input type="hidden" name="sp_card_txtype"      value="20">                           <!-- * 신용카드 요청구분 (즉시승인 : 20) //-->
		<input type="hidden" name="sp_tcode"            value="KT">                           <!-- * 이동통신사 (KT,SKT,LGT) //-->
		<input type="hidden" name="sp_quota"            value=""		id="sp_quota">        <!--   할부개월 //-->
		<input type="hidden" name="sp_noint_yn"         value="">                             <!-- * 무이자 설정 (무이자:Y, 일반:N, DB:NULL ?) //-->
		<input type="hidden" name="sp_noinst_term"      value="">                             <!--   무이자 할부개월 (무이자 설정가 Y일 때 설정) //-->
		<input type="hidden" name="sp_usedcard_code"    value="031">                          <!-- * 사용가능 카드 (가맹점에서 사용할 카드 리스트 ?) //-->
		<input type="hidden" name="sp_point_useyn"      value="N">                            <!-- * 포인트 사용유무 (사용:Y, 미사용:N, DB:NULL ?) //-->
		<input type="hidden" name="sp_cert_type"        value="0">                            <!-- * 신용카드 인증방식 (0:일반. 1:KEY-IN(인증), 2:KEY-IN(비인증)) //-->
		<input type="hidden" name="sp_spay_cp"          value="paypin">                       <!-- * 간편결제 종류(?) //-->
		
		<input type="hidden" id="EP_user_define1"   	name="EP_user_define1"   value="">
		<input type="hidden" id="EP_user_define2"   	name="EP_user_define2"   value="">
		<input type="hidden" id="EP_user_define3"   	name="EP_user_define3"   value="">
		<input type="hidden" id="EP_user_define4"   	name="EP_user_define4"   value="">
		<input type="hidden" id="EP_user_define5"   	name="EP_user_define5"   value="">
		<input type="hidden" id="EP_user_define6"   	name="EP_user_define6"   value="">
		
		<input type="hidden" id="mobilereserved1"   	name="sp_mobilereserved1"   value="">
		<input type="hidden" id="mobilereserved2"   	name="sp_mobilereserved2"   value="">
		<input type="hidden" id="reserved1"   			name="sp_reserved1"   		 value="">
		<input type="hidden" id="reserved2"   			name="sp_reserved2"   		 value="">
		<input type="hidden" id="reserved3"   			name="sp_reserved3"   		 value="">
		<input type="hidden" id="reserved4"   			name="sp_reserved4"   		 value="">
	</form>
</body>
</html>
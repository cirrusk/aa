<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.net.URLDecoder"%>
<%@ page pageEncoding="EUC-KR"%>
<%
/* -------------------------------------------------------------------------- */
/* 캐쉬 사용안함                                                              */
/* -------------------------------------------------------------------------- */
response.setHeader("cache-control","no-cache");
response.setHeader("expires","-1");
response.setHeader("pragma","no-cache");

request.setCharacterEncoding("EUC-KR");

String easyPayMallName = URLDecoder.decode(URLDecoder.decode(request.getParameter("EP_mall_nm")));
String easyPayProductName = URLDecoder.decode(URLDecoder.decode(request.getParameter("EP_product_nm")));
String easyPayUserName = URLDecoder.decode(URLDecoder.decode(request.getParameter("EP_user_nm")));

String bankId = request.getParameter("usedcard_code");
String usedcardCode = "";

if ("B".equals(bankId)){
	usedcardCode = "016"; 
}else if ("4".equals(bankId)){
	usedcardCode = "027"; 
}else if ("3".equals(bankId)){
	usedcardCode = "029"; 
}else if ("2".equals(bankId)){
	usedcardCode = "031"; 
}else if ("9".equals(bankId)){
	usedcardCode = "002"; 
}else if ("5".equals(bankId)){
	usedcardCode = "047"; 
}else if ("A".equals(bankId)){
	usedcardCode = "026"; 
}else if ("C".equals(bankId)){
	usedcardCode = "058"; 
}else if ("8".equals(bankId)){
	usedcardCode = "017"; 
}else if ("6".equals(bankId)){
	usedcardCode = "011"; 
}else if ("7".equals(bankId)){
	usedcardCode = "022"; 
}else if ("1".equals(bankId)){
	usedcardCode = "008"; 
}else if ("10".equals(bankId)){
	usedcardCode = "010"; 
}else if ("11".equals(bankId)){
	usedcardCode = "006"; 
}else if ("12".equals(bankId)){
	usedcardCode = "018"; 
}

%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=10" />
<meta name="robots" content="noindex, nofollow" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<script>
    window.onload = function()
    {
        document.frm.submit();
    }
</script>
<title>webpay 가맹점 test page</title>
</head>
<body>
<form name="frm" method="post" action="${easypayRequestPage}">
    <input type="hidden" id="EP_return_url"        name="EP_return_url"        value="<%=request.getParameter("EP_return_url") %>" /> 
    <input type="hidden" id="EP_mall_id"           name="EP_mall_id"           value="<%=request.getParameter("EP_mall_id") %>" />
    <input type="hidden" id="EP_mall_pwd"          name="EP_mall_pwd"          value="<%=request.getParameter("EP_mall_pwd") %>" /> 
    <input type="hidden" id="EP_mall_nm"           name="EP_mall_nm"           value="<%=easyPayMallName%>" /> 
    <input type="hidden" id="EP_ci_url"            name="EP_ci_url"            value="<%=request.getParameter("EP_ci_url") %>" /> 
    <input type="hidden" id="EP_lang_flag"         name="EP_lang_flag"         value="<%=request.getParameter("EP_lang_flag") %>" /> 
    <input type="hidden" id="EP_agent_ver"         name="EP_agent_ver"         value="<%=request.getParameter("EP_agent_ver") %>" /> 
    <input type="hidden" id="EP_pay_type"          name="EP_pay_type"          value="<%=request.getParameter("EP_pay_type") %>" /> 
    <input type="hidden" id="EP_currency"          name="EP_currency"          value="<%=request.getParameter("EP_currency") %>" /> 
    <input type="hidden" id="EP_tax_flg"           name="EP_tax_flg"           value="<%=request.getParameter("EP_tax_flg") %>" /> 
    <input type="hidden" id="EP_com_tax_amt"       name="EP_com_tax_amt"       value="<%=request.getParameter("EP_com_tax_amt") %>" /> 
    <input type="hidden" id="EP_com_free_amt"      name="EP_com_free_amt"      value="<%=request.getParameter("EP_com_free_amt") %>" /> 
    <input type="hidden" id="EP_com_vat_amt"       name="EP_com_vat_amt"       value="<%=request.getParameter("EP_com_vat_amt") %>" /> 
    
    <input type="hidden" id="EP_order_no"          name="EP_order_no"          value="<%=request.getParameter("EP_order_no") %>" /> 
    <input type="hidden" id="EP_product_type"      name="EP_product_type"      value="<%=request.getParameter("EP_product_type") %>" /> 
    <input type="hidden" id="EP_product_nm"        name="EP_product_nm"        value="<%=easyPayProductName%>" /> 
    <input type="hidden" id="EP_product_amt"       name="EP_product_amt"       value="<%=request.getParameter("EP_product_amt") %>" /> 
    <input type="hidden" id="EP_product_expr"      name="EP_product_expr"      value="<%=request.getParameter("EP_product_expr") %>" /> 
    <input type="hidden" id="EP_user_type"         name="EP_user_type"         value="<%=request.getParameter("EP_user_type") %>" /> 
    <input type="hidden" id="EP_user_id"           name="EP_user_id"           value="<%=request.getParameter("EP_user_id") %>" /> 
    <input type="hidden" id="EP_memb_user_no"      name="EP_memb_user_no"      value="<%=request.getParameter("EP_memb_user_no") %>" /> 
    <input type="hidden" id="EP_user_nm"           name="EP_user_nm"           value="<%=easyPayUserName %>" /> 
    <input type="hidden" id="EP_user_mail"         name="EP_user_mail"         value="<%=request.getParameter("EP_user_mail") %>" /> 
    <input type="hidden" id="EP_user_phone1"       name="EP_user_phone1"       value="<%=request.getParameter("EP_user_phone1") %>" />
    <input type="hidden" id="EP_user_phone2"       name="EP_user_phone2"       value="<%=request.getParameter("EP_user_phone2") %>" />
    <input type="hidden" id="EP_user_addr"         name="EP_user_addr"         value="<%=request.getParameter("EP_user_addr") %>" /> 
    <input type="hidden" id="EP_os_cert_flag"      name="EP_os_cert_flag"      value="<%=request.getParameter("EP_os_cert_flag") %>" /> 
    <input type="hidden" id="EP_usedcard_code"     name="EP_usedcard_code"     value="<%=usedcardCode%>" /> 
    <input type="hidden" id="EP_quota"             name="EP_quota"             value="<%=request.getParameter("EP_quota") %>" /> 
    <input type="hidden" id="EP_noinst_flag"       name="EP_noinst_flag"       value="<%=request.getParameter("EP_noinst_flag") %>" /> 
    <input type="hidden" id="EP_noinst_term"       name="EP_noinst_term"       value="<%=request.getParameter("EP_noinst_term") %>" /> 
    <input type="hidden" id="EP_set_point_card_yn" name="EP_set_point_card_yn" value="<%=request.getParameter("EP_set_point_card_yn") %>" /> 
    <input type="hidden" id="EP_point_card"        name="EP_point_card"        value="<%=request.getParameter("EP_point_card") %>" />
    <input type="hidden" id="EP_vacct_bank"        name="EP_vacct_bank"        value="<%=request.getParameter("EP_vacct_bank") %>" />
    <input type="hidden" id="EP_vacct_end_date"    name="EP_vacct_end_date"    value="<%=request.getParameter("EP_vacct_end_date") %>" />
    <input type="hidden" id="EP_vacct_end_time"    name="EP_vacct_end_time"    value="<%=request.getParameter("EP_vacct_end_time") %>" />
    <input type="hidden" id="EP_prepaid_cp"        name="EP_prepaid_cp"        value="<%=request.getParameter("EP_prepaid_cp") %>" />
    <input type="hidden" id="EP_spay_cp"           name="EP_spay_cp"           value="<%=request.getParameter("EP_spay_cp") %>" />
    <input type="hidden" id="EP_user_define1"      name="EP_user_define1"      value="<%=request.getParameter("EP_user_define1") %>" />     
    <input type="hidden" id="EP_user_define2"      name="EP_user_define2"      value="<%=request.getParameter("EP_user_define2") %>" />
    <input type="hidden" id="EP_user_define3"      name="EP_user_define3"      value="<%=request.getParameter("EP_user_define3") %>" /> 
    <input type="hidden" id="EP_user_define4"      name="EP_user_define4"      value="<%=request.getParameter("EP_user_define4") %>" /> 
    <input type="hidden" id="EP_user_define5"      name="EP_user_define5"      value="<%=request.getParameter("EP_user_define5") %>" /> 
    <input type="hidden" id="EP_user_define6"      name="EP_user_define6"      value="<%=request.getParameter("EP_user_define6") %>" /> 
    
    <!-- 에스크로 -->
    <input type="hidden" id="EP_escr_type"         name="EP_escr_type"         value="<%=request.getParameter("EP_escr_type") %>" />
    <input type="hidden" id="EP_bk_cnt"            name="EP_bk_cnt"            value="<%=request.getParameter("EP_bk_cnt") %>" />
    <input type="hidden" id="EP_bk_totamt"         name="EP_bk_totamt"         value="<%=request.getParameter("EP_bk_totamt") %>" />
    <input type="hidden" id="EP_bk_goodinfo"       name="EP_bk_goodinfo"       value="<%=request.getParameter("EP_bk_goodinfo") %>" />
    <input type="hidden" id="EP_recv_id"           name="EP_recv_id"           value="<%=request.getParameter("EP_recv_id") %>" />
    <input type="hidden" id="EP_recv_nm"           name="EP_recv_nm"           value="<%=request.getParameter("EP_recv_nm") %>" />
    <input type="hidden" id="EP_recv_tel"          name="EP_recv_tel"          value="<%=request.getParameter("EP_recv_tel") %>" />
    <input type="hidden" id="EP_recv_mob"          name="EP_recv_mob"          value="<%=request.getParameter("EP_recv_mob") %>" />
    <input type="hidden" id="EP_recv_mail"         name="EP_recv_mail"         value="<%=request.getParameter("EP_recv_mail") %>" />
    <input type="hidden" id="EP_recv_zip"          name="EP_recv_zip"          value="<%=request.getParameter("EP_recv_zip") %>" />
    <input type="hidden" id="EP_recv_addr1"        name="EP_recv_addr1"        value="<%=request.getParameter("EP_recv_addr1") %>" />
    <input type="hidden" id="EP_recv_addr2"        name="EP_recv_addr2"        value="<%=request.getParameter("EP_recv_addr2") %>" />
    <input type="hidden" id="EP_deli_type"         name="EP_deli_type"         value="<%=request.getParameter("EP_deli_type") %>" />
</form>
</body>
</html>
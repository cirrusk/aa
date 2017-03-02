<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>

<html style="margin: 0; height: 100%" lang="ko">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta charset="utf-8">
		
		<title>신용카드영수증 미리보기</title>
		<link rel="stylesheet" type="text/css" href="http://dev.abnkorea.co.kr/rd/ReportingServer/html5/css/crownix-viewer.min.css">
		<style type="text/css">
 			a[class^=btnBasic]:hover, a[class^=btnBasic]:focus, a[class^=btnBasic]:visited{color: #fff;}
 			a[class^=btnBasic]{line-height: 34px; height: 33px; line-height: 36px; display: inline-block;vertical-align: middle; text-align: center;}
 			a:visited{color: #831e88;}
 			.btnBasicGs, .btnBasicRS{width: 98px;}
 			.btnBasicGs{background-color: #6f6f6f; border: 1px solid #575757; font-size: 14px; color: #fff; font-weight: bold; margin: 0 7px;}
 			.btnBasicGs{background-color: #e81135; border: 1px solid #c60425; font-size: 14px; color: #fff; font-weight: bold; margin: 0 7px;}
 			a{text-decoration: none}
		</style>
		
		<script src="http://dev.abnkorea.co.kr/rd/ReportingServer/html5/js/jquery-1.11.0.min.js"></script>
		<script src="http://dev.abnkorea.co.kr/rd/ReportingServer/html5/js/crownix-viewer.storage.min.js"></script>
		<script src="http://dev.abnkorea.co.kr/_ui/desktop/common/js/apps/rd.solution.js?=2016071811"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				var domain = '';
				
				if(domain != "" || domain.length != 0){
					docment.domain = domain;
				}
				
				$.rdSolution.data.xml = 
				'<?xml version="1.0" encoding="UTF-8" standalone="yes"?> '
				+'<CARDRECEIPT>'
				+'<CARDREADERNUMBER></CARDREADERNUMBER>'
				+'<CARDTYPE>'+$("#cardName").val()+'</CARDTYPE>'
				+'<CARDNUMBER>'+$('#cardNumber').val()+'</CARDNUMBER>'
				+'<EXPIRYDATE>**/**</EXPIRYDATE>'
				+'<DEALDATE>'+$('#paymentsDate').val()+'</DEALDATE>'
				+'<CANCELDATE></CANCELDATE>'
				+'<DEALTYPE>승인</DEALTYPE>'
				+'<PRODUCTNAME>'+$('#typeName').val()+' 예약</PRODUCTNAME>'
				+'<PAYMENTMETHOD>'+$('#instalment').val()+'</PAYMENTMETHOD>'
				+'<AMOUNT>'+$('#amount').val()+'</AMOUNT>'
				+'<TAX>'+$('#surtax').val()+'</TAX>'
				+'<SERVICECHARGE>0</SERVICECHARGE>'
				+'<TOTALAMOUNT>'+$('#orderPayment').val()+'</TOTALAMOUNT>'
				+'<CARDRECEIPTCOMPANYINFO>'
				+'	<CEONAME>박세준</CEONAME>'
				+'	<APPROVALNUMBER>'+$('#aceptNumber').val()+'</APPROVALNUMBER>'
				+'	<FRANCHISENAME>한국암웨이(주)</FRANCHISENAME>'
				+'	<STORENAME>한국암웨이(주)</STORENAME>'
				+'	<ADDRESS>서울특별시 강남구 테헤란로 518 섬유센터 빌딩</ADDRESS>'
				+'	<FRANCHISENUMBER></FRANCHISENUMBER>'
				+'	<LICENSENUMBER>120-81-03391</LICENSENUMBER>'
				+'	<TELNAME>(02)1588-0080</TELNAME>'
				+'</CARDRECEIPTCOMPANYINFO>'
				+'</CARDRECEIPT>';
				
			
				$.rdSolution.data.mrdPath = 'http://dev.abnkorea.co.kr/document/CARDRECEIPT.mrd';
				$.rdSolution.data.mrdParam = '';
				$.rdSolution.data.serverUrl = 'http://dev.abnkorea.co.kr/rd/ReportingServer/service';
				
				window.setTimeout(function () {
					$.rdSolution.rdopen();
				}, 1000);
				
			});
		
		</script>
		
	</head>
<!-- 	<body onload="$.rdSolution.rdopen()" leftmargin="0px" rightmargin="0px" topmargin="0px" bottommargin="0px"> -->
	<body leftmargin="0px" rightmargin="0px" topmargin="0px" bottommargin="0px">
	<div class="pbLayerPopup" id="uiLayerPop_receipt" style="display: block; top: 15px;" tabindex="0">
				<div class="pbLayerHeader">
					<strong>신용카드영수증</strong>
				</div>
				<div class="pbLayerContent">
					<div id="crownix-viewer" style="position: absolute;width: 0%; height: 0px; border: 0"></div>
							
							<iframe id="pdfframe" name="pdfframe" style="position: absolute;width: 0%; height: 0px; border: 0"></iframe>
							
							<form id="form1" name="form1" action="http://dev.abnkorea.co.kr/rd/ReportionServer/service" method="post" target="pdfframe">
								<input type="hidden" name="opcode" />
								<input type="hidden" name="mrd_data" />
								<input type="hidden" name="mrd_path" />
								<input type="hidden" name="mrd_param" />
								<input type="hidden" name="export_type" />
								<input type="hidden" name="protocol" />
								
								
							</form>
							<form id="tempForm" name="tempForm">
								<input type="hidden" id="orderPayment" value="${getReceiptTempInfo.orderPayment}">
								<input type="hidden" id="cardExp" value="${getReceiptTempInfo.cardExp}">
								<input type="hidden" id="paymentsDate" value="${getReceiptTempInfo.paymentsDate}">
								<input type="hidden" id="aceptNumber" value="${getReceiptTempInfo.aceptNumber}">
								<input type="hidden" id="instalment" value="${getReceiptTempInfo.instalment}">
								<input type="hidden" id="surtax" value="${getReceiptTempInfo.surtax}">
								<input type="hidden" id="cardNumber" value="${getReceiptTempInfo.cardNumber}">
								<input type="hidden" id="amount" value="${getReceiptTempInfo.orderPayment - getReceiptTempInfo.surtax}">
								<input type="hidden" id="typeName" value="${getReceiptTempInfo.typeName}">
								<input type="hidden" id="cardName" value="${getReceiptTempInfo.cardName}">
							
							</form>
					<div class="receipt"></div>
				</div>
				<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>    
	
		
	</body>
	
</html>
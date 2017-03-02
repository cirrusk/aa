<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<!-- BARCODE POPUP용 CSS -->
<link rel="stylesheet" href="../../../../../../../se2/css/popup.css" type="text/css" />
<style type="text/css">
@charset "utf-8";
html, body, div, span, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
abbr, address, cite, code,
del, dfn, em, img, ins, kbd, q, samp,
small, strong, sub, sup, var,
b, i,dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td,
article, aside, canvas, details, figcaption, figure,
footer, header, hgroup, menu, nav, section, summary,
time, mark, audio, video{margin:0; padding:0; border:0;}
body{padding:0; margin:0; background:#FFF; color:#666; font-size:12px; line-height:normal; font-family:"돋움",Dotum,"굴림",Gulim,Arial,"Trebuchet MS",Verdana,"Sans-serif";}
h1,h2,h3,h4,h5,h6{font-size:100%; color:#666; line-height:normal;}
ul,ol{list-style:none;}
em,address{font-style:normal;}
hr{display:none;}
img{border:0 none;}
pre{white-space:pre-wrap;}
q:before,q:after{content:'';}
sub,sup{line-height:0; vertical-align:baseline;}
sup{top:-0.5em; vertical-align: super;}
sub{bottom:-0.25em;}
input[type=button]{-webkit-appearance:none; -moz-appearance:none; appearance:none; -webkit-border-radius:0; border-radius:none;}

/* a */
a{color:inherit; text-decoration:none;}
a:hover,a:focus,a:active{color:inherit; text-decoration:underline;}

table{border-collapse:collapse; border-spacing:0px;}
caption{overflow:hidden; width:0; height:0; font-size:0; line-height:0}

.rela{position:relative;}
.btn_exeption{position:absolute;top:0;right:5px;}

/* tblInput */
.tblInput{width:100%; border-top:2px solid #a4adb6;}
.tblInput th{color:#444; background-color:#f7f7f7; border:1px solid #e7ecf0; padding:12px 5px 10px 15px; text-align:left; line-height:20px; vertical-align:middle;font-weight:normal;}
.tblInput td{color:#444; background-color:#fff; border:1px solid #e7ecf0; padding:5px 0 4px 15px; line-height:20px; vertical-align:middle;}
.tblInput td input[type="checkbox"] + label{margin:0 0 0 4px}
.tblInput input[type="text"]{height:26px;border:1px solid #ddd;color:#444;}
.tblInput .btnG{margin:0 5px;padding:0 10px;height:30px;color:#fff;background:#8d8d8d;border:0;font:bold 14px/30px dotum,"돋움";vertical-align:top;}

.tblInputCol{width:100%; border-top:2px solid #a4adb6;}
.tblInputCol th{color:#444; background-color:#f7f7f7; border:1px solid #e7ecf0; padding:12px 5px; font-size:14px;}
.tblInputCol td{color:#444; background-color:#fff; border:1px solid #e7ecf0; padding:10px 0; line-height:20px; font-size:14px; font-weight:bold; text-align:center;}
td.seatNum{padding:40px 0;  font-size:24px;}

.btnWrapC{margin:30px 0 0;text-align:center;}
.btnG{display:inline-block; padding:0 35px; height:35px; color:#fff; background:#6f6f6f; border:1px solid #575757; font:bold 14px/35px dotum,"돋움"; vertical-align:top;}
</style>



<script type="text/javascript">	

//tab초기 설정
var iniObjectD = {
		optionValue : "D2"
		,optionText : "출석처리"
		,tabId : "D2"
}



function barcodeAttend()
{
var param = $("#frm").serialize();
	
	
	$.ajaxCall({
		url:"<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailOfflineAttendBarcodeAjax.do"/>"
		,data:param
		,success:function( data, textStatus, jqXHR){
			
			if(data.uidCheck == "Y")
				{
			//교육신청자인경우
			if(data.applicantCheck == "Y")
				{	
						//동반허용이면서 동반출석신청인경우
						if(data.togetherCheck == "Y")
						{		
							
								//var result = confirm("ABO번호 :"+data.uid+"\r\n이름 :"+data.name+"&"+data.partnerinfoname+"\r\n생년월일:"+data.ssn+"&"+data.partnerinfossn);
								var result = confirm("ABO번호 : "+data.uid+"\r주사업자 : "+data.mainname+"\r주사업자 생년월일 : "+data.ssn +"\r부사업자 : "+data.partnerinfoname+"\r부사업자 생년월일:"+data.partnerinfossn);
								//확인창 보여주기
								$("#memberInfoDiv").hide();
								
								//confirm확인 클릭시
								if(result)
									{
										var param = $("#frm").serialize();
										
										$.ajaxCall({
									   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailOfflineAttendBarcodeMemberInfoConfirmAjax.do"/>"
									   		, data: param
									   		, success: function( data, textStatus, jqXHR){
									   			
									   			$("#uid").val("");
									   			$("#uid").focus();
									   			
									   			if(data.comment != null && data.comment != "")
												{
													alert(data.comment);
												}
									   			else
									   				{
									   				
											   			if(data.comment2 != null && data.comment2 != "")
														{
															alert(data.comment2);
														}
											   			$("#memberInfoUid").html(dataMask(data.uid,"uid"));
														$("#memberInfoName").html(dataMask(data.mainname,"name")+"&"+dataMask(data.partnerinfoname,"name"));
														$("#memberInfoType").html("( "+data.membertype+" )");
														$("#memberInfoSeatNum").html(data.seatnumber);
														
											   			$("#memberInfoDiv").show();
											   			
									   				}
									   		},
									   		error: function( jqXHR, textStatus, errorThrown) {
									           	alert("<spring:message code="errors.load"/>");
									           	alert("error"+textStatus);
									   		}
									   	});
									}
								//});
								
								//취소 클릭시
								$("#cancelBtn").on("click",function(){
									$("#confirmDiv").remove();
									$("#uid").val("");
									$("#uid").focus();
								});
						}
						//동반신청 아닌경우
						else if(data.togetherCheck == "N")
						{	
							$("#uid").val("");
				   			$("#uid").focus();
				   			
							if(data.comment != null && data.comment != "")
							{
								alert(data.comment);
							}
							else
								{
							   			if(data.comment2 != null && data.comment2 != "")
										{
											alert(data.comment2);
										}
										$("#memberInfoUid").html(dataMask(data.uid,"uid"));
										$("#memberInfoName").html(dataMask(data.mainname,"name"));
										$("#memberInfoType").html("( "+data.membertype+" )");
										$("#memberInfoSeatNum").html(data.seatnumber);
										
										$("#memberInfoDiv").show();
										
								}
						}
					}
				else if(data.applicantCheck == "N")
					{	
								alert("ABO번호 : "+data.uid+" , 핀레벨 : "+data.pincode+" , 이름 : "+data.name+" 님은 신청자가 아닙니다.");
								$("#uid").val("");
					   			$("#uid").focus();
					}
				}///end CheckUid
				else
					{	
						alert(data.comment);
						$("#uid").val("");
			   			$("#uid").focus();
					}
			
		}
		,error:function( jqXHR, textStatus, errorThrown){
		 	alert("<spring:message code="errors.load"/>");
           	alert("error"+textStatus);
		}
		
	});	
}
	
$(document.body).ready(function(){
$("#memberInfoDiv").hide();
	
//onload되자마자 포커싱 맞추기
$("#uid").focus();

//팝업 닫기
$("#closeBtn").on("click",function(){
	closeManageLayerPopup("attendBarcodePop");
	$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.attendList.doSearch();
});
$(".btnPopClose").on("click",function(){
	closeManageLayerPopup("attendBarcodePop");
	$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.attendList.doSearch();
});

$("#uid").keydown(function(e){
	
	if(e.keyCode == 13	)
		{
			barcodeAttend();
		}
});

//POPUP창 메인 확인버튼 클릭시
$("#submitBtn").on("click",function(){
	barcodeAttend();
});

//예외처리 버튼 클릭시
 $("#exceptBtn").on("click",function(){
	var param = $("#frm").serialize();
	
	$.ajaxCall({
   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailOfflineAttendBarcodeExceptionAjax.do"/>"
   		, data: param
   		, success: function( data, textStatus, jqXHR){
   			
   			$("#uid").val("");
   			$("#uid").focus();
   			
   			if(data.comment != null && data.comment != "")
			{
				alert(data.comment);
			}
   			else
   				{
	   			if(data.comment2 != null && data.comment2 != "")
				{
					alert(data.comment2);
				}
	   			$("#memberInfoUid").html(dataMask(data.uid,"uid"));
	   			if(data.partnerinfoname == null || data.partnerinfoname == "")
	   				{	
						$("#memberInfoName").html(dataMask(data.mainname,"name"));
	   				}
	   			else
	   				{
						$("#memberInfoName").html(dataMask(data.mainname,"name")+"&"+dataMask(data.partnerinfoname,"name"));
	   				}
	   				$("#memberInfoType").html("( "+data.membertype+" )");
					$("#memberInfoSeatNum").html(data.seatnumber);
					
		   			$("#memberInfoDiv").show();
		   			
   				}
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	alert("error"+textStatus);
   		}
   	});
}); 

});

//마스킹 함수
function dataMask(data,type)
{	
	var regular = /[^0-9]/;
	var form = "";
	//이름일 경우 마스킹
	if(type == "name")
		{	
			var mask = "";
			if(data.length > 2)
				{
					for(var i=0;i<data.length - 2;i++)
						{
							mask += "*";
						}
					regular = /([가-힣])[가-힣]+([가-힣])/;
					form = "$1"+mask+"$2";
					data = data.replace(regular,form);
				}
			else if(data.length = 2)
				{
					regular = /([가-힣])[가-힣]/;
					form = "$1*";
					data = data.replace(regular,form);
				}
			return data;
		}
	//ABO번호일 경우 마스킹
	 else if(type == "uid")
		{
			regular = /([0-9]+)[0-9]{4}/;
			form = "$1****";
			data = data.replace(regular,form);
			return data;
		} 
}

	
</script>


</head>

<body class="bgw">
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="../../../../../../../se2/img/h1_barcode.gif" alt="교육 신청자 바코드 출석 처리" /></h1>
	</header>
	<a href="#"  class="btnPopClose"><img src="../../../../../../../se2/img/btn_close.gif" alt="팝업창 닫힘" /></a>
	<div id="pbPopContent">
	
	<form id="frm" method="post" enctype="multipart/form-data">
		<input type="hidden" id="stepcourseid"  name="stepcourseid" value="${param.stepcourseid }">
		<input type="hidden" id="courseid"  name="courseid" value="${param.courseid }">
		<input type="hidden"  id="stepseq" name="stepseq" value="${param.stepseq }">
		<table class="tblInput">
			<caption>교육 신청자 바코드 출석 처리</caption>
			<colgroup>
				<col style="width:150px" />
				<col style="width:auto" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="row">ABO번호</th>
				<td>
					<div class="rela">
					<input type="text" id="uid" name="uid"  class="required"  style="width:auto; min-width:200px" required="required">
					<input type="button" id="submitBtn" value="확인" class="btnG" />
						<a href="#" class="btn_exeption" id="exceptBtn"><img src="../../../../../../../se2/img/btn_exeption.gif" alt="예외처리" /></a>
					</div>
				</td>
			</tr>
			<tr style="display:none;">
				<th>tr지우지 말 것</th>
				<td><input type="text" ></td>
			</tr>
			<tr>
				<th scope="row">과정명</th>
				<td>${detail.coursename } [${detail.apname }]</td>
			</tr>
			<tr>
				<th scope="row">교육일시</th>
				<td>${detail.edudate }</td>
			</tr>
			</tbody>
		</table>
	</form>
		
		<br/><br/><br/>
			
		<div id="memberInfoDiv">
			<table class="tblInputCol">
				<caption>회원정보 테이블</caption>
				<colgroup>
					<col style="width:50%" span="2" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col" colspan="2" style="background-color:#f7f7f7; border:1px solid #e7ecf0; padding:12px 5px; font-size:15px; text-align: center;"><strong style="color:#444;">회원정보</strong></th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td><strong id="memberInfoUid" style="color:#444;"></strong></td>
					<td><strong id="memberInfoType" style="color:#444;"></strong> <strong id="memberInfoName" style="color:#444;"></strong></td>
				</tr>
				<tr>
					<td colspan="2" class="seatNum"><strong style="color:#277021;">좌석번호 : </strong><strong id="memberInfoSeatNum" style="color:#277021;"></strong></td>
				</tr>
				</tbody>
			</table>
		</div>
		
		<div class="btnWrapC">
			<a href="#"  id="closeBtn" class="btnG">닫기</a>
		</div>
		
	</div>
</div>

</div>
</body>
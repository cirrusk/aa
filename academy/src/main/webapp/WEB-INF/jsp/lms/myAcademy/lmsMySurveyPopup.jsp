<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
<html lang="ko">
<head>
<!-- page common -->
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- //page common -->
<!-- page unique -->
<meta name="Description" content="설명들어감">
<meta http-equiv="Last-Modified" content="">
<!-- //page unique -->
<title>정규과정 설문 - ABN Korea</title>
<!--[if lt IE 9]>
<script src="/_ui/desktop/common/js/html5.js"></script>
<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->
<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsComm.js"></script>
<script type="text/javascript">
var submitFlag = true;
$(document).ready(function(){
	//이름, ABO번호 마스크 처리
	$("#aboNo").text( dataMask( $("#aboNo").text(), "uid") );
	$("#aboName").text( dataMask( $("#aboName").text(), "name") );

	//설문상태 체크하기
	if( "${data.surveystatus}" == "END" ) {
		alert("설문이 종료되었습니다.");
		window.close();
		return;
	} else if( "${data.surveystatus}" == "READY" ) {
		alert("설문이 준비중입니다.");
		window.close();
		return;
	}
	
	$(".btnPopClose").on("click", function(){
		if( $("#submitflag").val() != "Y" ) {
			if( !confirm("현재 설문이 진행중에 있습니다.\n창을 닫으시면 설문지가 제출되지 않습니다.\n창을 닫겠습니까?")) {
				return;
			}
		}	
		window.close();
	});
	$("#testCancelButton").on("click", function(){
		if( !confirm("취소 시 지금까지 작성된 설문은 제출 및 저장되지 않습니다.\n설문을 종료하시겠습니까?")) {
			return;
		}
		window.close();
	});
	
	$("#submitButton").on("click", function(){
		//입력되지 않은 설문 체크할 것
		var surveycount = parseInt($("#surveycount").val());
		
		//문제 체크할 것
		for( var i=1; i<=surveycount; i++ ) {
			if($("#surveytype_"+i).val() == "1" || $("#surveytype_"+i).val() == "2") {
				//객관식은 정답을 reponse에 담기
				var samplecount = parseInt($("#samplecount_"+i).val());
				var opinionContent = "";
				for( var k=1; k<=samplecount; k++) {
					if( $("#sampleseq_"+i+"_"+k).is(":checked") ) {
						opinionContent += k + ",";
					}
				}
				if( opinionContent == "" ) {
					alert( i + "번째 설문에 참여해 주세요.");
					return;
				} else {
					$("#response_"+i).val( opinionContent.substring(0,opinionContent.length-1));
				}
			} else {
				if( $("#response_"+i).val() == "" ) {
					alert( i + "번째 설문에 참여해 주세요.");
					return;
				}
			}
		}

		if( !confirm("설문을 제출하겠습니까?")) {
			return;
		}
		
		$.ajaxCall({
			url : "/lms/myAcademy/lmsMySurveySubmitAjax.do"
			, data : $("#surveySubmit").serialize()
			, success : function(data, textStatus, jqXHR) {
				if( data.session == "F" ) { //세션 끊기면 함수 호출하기
					fnSessionCall("Y");
					return;
				}
				if( data.result < 0 ) {
					alert("설문 제출 중 오류가 발생하였습니다.");
					return;
				}
				
				//설문종료 후 메시지 출력
				$("#commitArea").show();
				$("#sampleArea").hide();
				$("#buttonArea").hide();
				
				//하위의 리플래시 함수 호출
				try {
					opener.fnRefresh();
				} catch( e ) {}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("<spring:message code="errors.load"/>");
			}
		});		
	});
	$("#surveyCloseButton").on("click", function(){
		window.close();		
	});

});
var fnCheckLength = function( idxVal, chkLength ) {
	var objValue = $("#response_"+idxVal).val();
	if( objValue.length > chkLength ) {
		$("#response_"+idxVal).val(objValue.substring(0,chkLength)); 
	}
	$("#responseCheck_"+idxVal).html( $("#response_"+idxVal).val().length + "/" + chkLength + "자" );
};
</script>
</head>

<body>
<div id="pbPopWrap" style="width:712px">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w0300100240.gif" alt="설문참여" /></h1>
	</header>
	<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="설문참여 팝업창 닫힘"></a>
	
	<section id="pbPopContent">
		<p class="listDotFS">
			<strong>[정규과정] ${data.coursename}</strong>
		</p>
		<!-- @edit 20160808 -->
		<table class="tblList lineLeft mgtS">
			<caption>설문참여</caption>
			<colgroup>
				<col style="width:20%">
				<col style="width:25%">
				<col style="width:20%">
				<col style="width:35%">
			</colgroup>
			<tbody>
			<tr>
				<th scope="row" class="bg">설문명</th>
				<td colspan="3" class="textL">${data.surveyname}</td>
			</tr>
			<tr>
				<th scope="row" class="bg">대상</th>
				<td class="textL"><span id="aboNo">${sessionUid}</span> <span id="aboName">${sessionName}</span></td>
				<th scope="row" class="bg">기간</th>
				<td class="textL">${data.edudate}</td>
			</tr>
			</tbody>
		</table>
		
		<form id="surveySubmit" name="surveySubmit" method="post">
		<input type="hidden" id="stepcourseid" name="stepcourseid" value="${param.stepcourseid}"/>
		<input type="hidden" id="courseid" name="courseid" value="${param.courseid}"/>
		<input type="hidden" id="stepseq" name="stepseq" value="${param.stepseq}"/>
		<input type="hidden" id="surveycount" name="surveycount" value="${data.surveycount}"/>
		<input type="hidden" id="submitflag" name="submitflag" value="${data.submitflag}"/>
		<div id="sampleArea" class="testBox noline" <c:if test="${data.submitflag eq 'Y' }">style="display:none"</c:if>>
			<c:forEach var="dataList" items="${dataList}" varStatus="idx">
			<input type="hidden" id="surveyseq_${dataList.surveyseq}" name="surveyseq" value="${dataList.surveyseq}"/>
			<input type="hidden" id="surveytype_${dataList.surveyseq}" name="surveytype" value="${dataList.surveytype}"/>
			<input type="hidden" id="samplecount_${dataList.surveyseq}" name="samplecount" value="${dataList.samplecount}"/>
			<p class="quest">${dataList.surveyname}</p>
			<div class="formBox">
				<c:if test="${dataList.surveytype eq '1'}">
					<input type="hidden" id="response_${dataList.surveyseq}" name="response" />
					<c:forEach var="sampleList" items="${dataList.sampleList}" varStatus="idx2">
					<input type="radio" id="sampleseq_${dataList.surveyseq}_${sampleList.sampleseq}" name="sampleseq_${dataList.surveyseq}" value="${sampleList.sampleseq}" />
					<label for="sampleseq_${dataList.surveyseq}_${sampleList.sampleseq}">${sampleList.samplename}</label>
					<input type="hidden" id="directyn_${dataList.surveyseq}_${sampleList.sampleseq}" name="directyn_${dataList.surveyseq}" value="${sampleList.directyn}"/>
					<c:if test="${sampleList.directyn eq 'Y'}">
						<input type="text" id="opinioncontent_${dataList.surveyseq}_${sampleList.sampleseq}" name="opinioncontent_${dataList.surveyseq}" style="width:100px;" maxlength="50" />
					</c:if>
					<c:if test="${sampleList.directyn ne 'Y'}">
						<input type="hidden" id="opinioncontent_${dataList.surveyseq}_${sampleList.sampleseq}" name="opinioncontent_${dataList.surveyseq}" value="" />
					</c:if>
					<c:if test="${sampleList.samplevalue ne '0'}"><br/></c:if>
					</c:forEach>
				</c:if>
				
				<c:if test="${dataList.surveytype eq '2'}">
					<input type="hidden" id="response_${dataList.surveyseq}" name="response" />
					<c:forEach var="sampleList" items="${dataList.sampleList}" varStatus="idx2">
					<input type="checkbox" id="sampleseq_${dataList.surveyseq}_${sampleList.sampleseq}" name="sampleseq_${dataList.surveyseq}" value="${sampleList.sampleseq}" />
					<label for="sampleseq_${dataList.surveyseq}_${sampleList.sampleseq}">${sampleList.samplename}</label>
					<input type="hidden" id="directyn_${dataList.surveyseq}_${sampleList.sampleseq}" name="directyn_${dataList.surveyseq}" value="${sampleList.directyn}"/>
					<c:if test="${sampleList.directyn eq 'Y'}">
						<input type="text" id="opinioncontent_${dataList.surveyseq}_${sampleList.sampleseq}" name="opinioncontent_${dataList.surveyseq}" style="width:100px;" maxlength="50" />
					</c:if>
					<c:if test="${sampleList.directyn ne 'Y'}">
						<input type="hidden" id="opinioncontent_${dataList.surveyseq}_${sampleList.sampleseq}" name="opinioncontent_${dataList.surveyseq}" value="" />
					</c:if>
					<c:if test="${sampleList.samplevalue ne '0'}"><br/></c:if>
					</c:forEach>
				</c:if>
				
				<c:if test="${dataList.surveytype eq '3'}">
					<input type="text" id="response_${dataList.surveyseq}" name="response" title="단답입력" maxlength="50" />
				</c:if>
				
				<c:if test="${dataList.surveytype eq '4'}">
					<textarea id="response_${dataList.surveyseq}" name="response" onkeyup="javascript:fnCheckLength('${dataList.surveyseq}',200);" onkeydown="javascript:fnCheckLength('${dataList.surveyseq}',200);" style="width:670px; height:100px;" title="주관식 질문"></textarea>
					<span class="byte" id="responseCheck_${dataList.surveyseq}">0/200자</span>
				</c:if>
			</div>
			</c:forEach>
		</div>
		</form>
		
		<div id="buttonArea" class="btnWrapC" <c:if test="${data.submitflag eq 'Y'}">style="display:none"</c:if>>
			<a href="#none" id="testCancelButton" class="btnBasicAcGS">취소</a>
			<a href="#none" id="submitButton" class="btnBasicAcGNS">설문제출</a>
		</div>
		
		<!-- 종료 메세지 -->
		<div class="testBox noline textC" id="commitArea" <c:if test="${data.submitflag ne 'Y'}">style="display:none"</c:if>>
			<p class="quest">수고하셨습니다.</p>
			<p class="mgtM">설문에 참여해 주셔서 감사합니다.</p>
			<div class="btnWrapC">
				<a href="#none" id="surveyCloseButton" class="btnBasicAcGL">닫기</a>
			</div>
		</div>
		<!-- //종료 메세지 -->
		<!-- //@edit 20160808 -->
	</section>
</div>
</body>
</html>
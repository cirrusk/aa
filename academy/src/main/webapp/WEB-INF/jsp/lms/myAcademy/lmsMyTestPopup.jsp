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
<title>정규과정 평가 - ABN Korea</title>
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
//마우스 오른쪽 버튼 막기
var stoWatchFlag = true;
var limittimesecond = 0;
var submitFlag = true;
var startTime = new Date();
var answerseq = 0;
var closeCheck = false;
$(document).ready(function(){

	//이름, ABO번호 마스크 처리
	$("#aboNo").text( dataMask( $("#aboNo").text(), "uid") );
	$("#aboName").text( dataMask( $("#aboName").text(), "name") );

	//시험상태 체크하기
	if( "${data.teststatus}" == "END" ) {
		alert("시험이 종료되었습니다.");
		closeCheck = true;
		window.close();
		return;
	} else if( "${data.teststatus}" == "READY" ) {
		alert("시험이 준비중입니다.");
		closeCheck = true;
		window.close();
		return;
	}
	
	//시험타입 확인
	if( "${data.testtype}" != "O" ) {
		alert("온라인 시험이 아닙니다.");
		closeCheck = true;
		window.close();
		return;
	}

	//현재 문제번호
	answerseq = parseInt($("#answerseq").val());
	
	//남은시간 계산
	limittimesecond = parseInt($("#limittimesecondint").val());
	fnSecondPrint(limittimesecond);

	if( $("#submitflag").val() != "Y" ) {
		if( limittimesecond > 0 ) {
			fnInitStopWatch("N",fnLastTime);
		} else {
			fnAutoSibmit();
		}
	}
	
	$(".btnPopClose").on("click", function(){
		if( $("#submitflag").val() != "Y" ) {
			if( !confirm("현재 시험이 진행중에 있습니다.\n창을 닫으시면 답안지가 제출되지 않습니다.\n창을 닫겠습니까?")) {
				return;
			}
		}	
		closeCheck = true;
		window.close();
	});
	$("#testCancelButton").on("click", function(){
		if( !confirm("시험을 취소하겠습니까?")) {
			return;
		}
		closeCheck = true;
		window.close();
	});
	$("#prevButton").on("click", function(){
		//이전문제 보여주기
		var answerseq = parseInt($("#answerseq").val());
		if( answerseq == 1 ) {
			alert("처음 문제입니다.");
			return;
		}
		
		// 문제 보여주기 : 숨길것, 보여줄것
		fnShowSample(answerseq,answerseq-1);

		$("#answerseq").val(answerseq-1);
		
	});
	$("#nextButton").on("click", function(){
		//다음문제 보여주기 : --> 답안지 저장후 문제 보여주기
		var answerseq = parseInt($("#answerseq").val());
		var answertype = $("#answertype_"+answerseq).val();
		
		var objectanswer = "";
		var subjectanswer = "";
		if( answertype == "1" || answertype == "2" ) {
			$("input[name=answerseq_"+ answerseq +"]:checked").each( function () {
				objectanswer += this.value + ",";
			});
			if( objectanswer != "") objectanswer = objectanswer.substring(0,objectanswer.length-1);
		} else {
			subjectanswer = $("textarea[name=answerseq_"+ answerseq +"]").val();
		}
		
		if( objectanswer == "" && subjectanswer == "" ) {
			alert("문제의 답을 선택 또는 작성해 주세요.");
			return;
		}
		
		$("#submitFrm > input[name=stepcourseid]").val( $("#stepcourseid").val() );
		$("#submitFrm > input[name=courseid]").val( $("#courseid").val() );
		$("#submitFrm > input[name=answerseq]").val( answerseq );
		$("#submitFrm > input[name=objectanswer]").val( objectanswer );
		$("#submitFrm > input[name=subjectanswer]").val( subjectanswer );
		
		$.ajaxCall({
			url : "/lms/myAcademy/lmsMyTestAnswerAjax.do"
			, data : $("#submitFrm").serialize()
			, success : function(data, textStatus, jqXHR) {
				//시작 메시지 제거 및 시험진행상태, 시험문제 보여주기
				if( data.session == "F" ) { //세션 끊기면 함수 호출하기
					fnSessionCall("Y");
					return;
				}
				if( data.result < 0 ) {
					alert("답안지 저장 중 오류가 발생하였습니다.");
					return;
				}
				
				// 문제 보여주기 : 숨길것, 보여줄것
				fnShowSample(answerseq,answerseq+1);

				$("#answerseq").val(answerseq+1);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("<spring:message code="errors.load"/>");
			}
		});
	});
	
	$("#submitButton").on("click", function(){
		//마지막 문제 입력 여부 확인
		var answerseq = parseInt($("#answerseq").val());
		var answertype = $("#answertype_"+answerseq).val();
		
		var objectanswer = "";
		var subjectanswer = "";
		if( answertype == "1" || answertype == "2" ) {
			$("input[name=answerseq_"+ answerseq +"]:checked").each( function () {
				objectanswer += this.value + ",";
			});
			if( objectanswer != "") objectanswer = objectanswer.substring(0,objectanswer.length-1);
		} else {
			subjectanswer = $("textarea[name=answerseq_"+ answerseq +"]").val();
		}
		
		if( objectanswer == "" && subjectanswer == "" ) {
			alert("문제의 답을 선택 또는 작성해 주세요.");
			return;
		}
		
		//답안지 제출하기
		if( !confirm("답안지를 제출하겠습니까?")) {
			return;
		}
		fnSubmit();		
	});
	
	$("#testCloseButton").on("click", function(){
		closeCheck = true;
		window.close();		
	});
	
	$("#testStartButton").on("click", function(){
		if( !confirm("시험을 시작하겠습니까?")) {
			return;
		}
		
		//시작시간 저장 및 시작시간 세팅처리
		var params = {
			stepcourseid : $("#stepcourseid").val()
			, courseid : $("#courseid").val()
			, inputtype : "I"
		};
		
		$.ajax({
			url : "/lms/myAcademy/lmsMyTestInitAjax.do",
			method : "GET",
			data : params,
			success : function(data, textStatus, jqXHR) {
				//시작 메시지 제거 및 시험진행상태, 시험문제 보여주기
				if( data.session == "F" ) { //세션 끊기면 함수 호출하기
					fnSessionCall("Y");
					return;
				}
				if( data.result < 0 ) {
					alert("답안지 생성 중 오류가 발생하였습니다.");
					return;
				}
				
				//시간 처리 stopWatch 작동할 것
				startTime = new Date();
				fnInitStopWatch("Y", fnLastTime);
				
				//문제 보일 것
				$("#testStartText").hide();
				$("#sampleArea").show();
				$("#smpleButtonArea").show();
				
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("<spring:message code="errors.load"/>");
			}
		});
	});
});
$(window).on("beforeunload", function(){
	if( $("#submitflag").val() != "Y" && closeCheck == false) {
		return "현재 시험이 진행중에 있습니다.\n창을 닫으시면 답안지가 제출되지 않습니다.\n창을 닫겠습니까?";
	}
});
var fnShowSample = function( hideAnswerseqVal, showAnswerseqVal ) {
	//문제 보여주기
	$("#testName_"+ hideAnswerseqVal).hide();
	$("#testImage_"+ hideAnswerseqVal).hide();
	$("#testFormBox_"+ hideAnswerseqVal).hide();
	
	$("#testName_"+ showAnswerseqVal).show();
	$("#testImage_"+ showAnswerseqVal).show();
	$("#testFormBox_"+ showAnswerseqVal).show();
	
	$("#currPerTotal").html(showAnswerseqVal + "/" + $("#answercount").val());
	
	if( showAnswerseqVal == parseInt($("#answercount").val()) ) {
		//마지막은 제출로 변경함
		$("#nextButton").hide();
		$("#submitButton").show();
	} else {
		$("#nextButton").show();
		$("#submitButton").hide();
	}
}
var fnInitStopWatch = function( initFlag, initFn ) {
	if( stoWatchFlag ) {
		if( initFlag == "Y" ) {
			setInterval(initFn,1000);	
		} else if( initFlag == "N" ) {
			if( "${data.studyflag}" == "Y" ) {
				setInterval(initFn,1000);
			}
		}
	}
};
var fnLastTime = function() {
	//현재와 시작시간 계산하여 기준 초에서 빼줄 것
	var curTime = new Date();
	
	var curSeconds = curTime.getTime();
	var startSeconds = startTime.getTime();
	
	var diff = Math.floor((curSeconds - startSeconds) / 1000);
	
	if( limittimesecond - diff < 0 ) {
		fnSecondPrint(0);
		stoWatchFlag = false;
		//시험자동 제출하기
		fnAutoSibmit();
	}	
	else fnSecondPrint(limittimesecond - diff);
};
var fnSecondPrint = function( secondVal ) {
	var minutes = parseInt(secondVal / 60); 
	var seconds = secondVal % 60;
	
	var limittimesecondHtml = "";
	if( minutes < 10 ) limittimesecondHtml = "0" + minutes + "분 ";
	else limittimesecondHtml = minutes + "분 ";
	
	if( seconds < 10 ) limittimesecondHtml += "0" + seconds + "초";
	else limittimesecondHtml += seconds + "초";
	
	$("#limittimesecond").html(limittimesecondHtml);
}
var fnAutoSibmit = function() {
	if( submitFlag ) {
		submitFlag = false;
		
		alert("시험이 종료되어 자동 제출됩니다.");
		//시험 제출 화면 호출하기
		stoWatchFlag = false;
		//자동 시험 제출
		fnSubmit();
	}	
};
var fnSubmit = function() {
	//마지막 문제 입력하기
	var answerseq = parseInt($("#answerseq").val());
	var answertype = $("#answertype_"+answerseq).val();
	
	var objectanswer = "";
	var subjectanswer = "";
	if( answertype == "1" || answertype == "2" ) {
		$("input[name=answerseq_"+ answerseq +"]:checked").each( function () {
			objectanswer += this.value + ",";
		});
		if( objectanswer != "") objectanswer = objectanswer.substring(0,objectanswer.length-1);
	} else {
		subjectanswer = $("textarea[name=answerseq_"+ answerseq +"]").val();
	}
	
	$("#submitFrm > input[name=stepcourseid]").val( $("#stepcourseid").val() );
	$("#submitFrm > input[name=courseid]").val( $("#courseid").val() );
	$("#submitFrm > input[name=stepseq]").val( $("#stepseq").val() );
	$("#submitFrm > input[name=answerseq]").val( answerseq );
	$("#submitFrm > input[name=objectanswer]").val( objectanswer );
	$("#submitFrm > input[name=subjectanswer]").val( subjectanswer );
	
	$.ajaxCall({
		url : "/lms/myAcademy/lmsMyTestAnswerSubmitAjax.do"
		, data : $("#submitFrm").serialize()
		, success : function(data, textStatus, jqXHR) {
			if( data.session == "F" ) { //세션 끊기면 함수 호출하기
				fnSessionCall("Y");
				return;
			}
			if( data.result < 0 ) {
				alert("답안지 제출 중 오류가 발생하였습니다.");
				return;
			}
			
			$("#sampleArea").hide();
			$("#smpleButtonArea").hide();
			$("#endArea").show();
			
			//하위의 리플래시 함수 호출
			try {
				opener.fnRefresh();
			} catch( e ) {}
			
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("<spring:message code="errors.load"/>");
		}
	});
};
var fnCheckLength = function( idxVal, chkLength ) {
	var objValue = $("#answerseq_"+idxVal).val();
	if( objValue.length > chkLength ) {
		$("#answerseq_"+idxVal).val(objValue.substring(0,chkLength)); 
	}
	$("#answerseqCheck_"+idxVal).html( $("#answerseq_"+idxVal).val().length + "/" + chkLength + "자" );
};
</script>
</head>

<body>
<div id="pbPopWrap" style="width:712px">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w0300100230.gif" alt="정규과정 평가" /></h1>
	</header>
	<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="정규과정 평가 팝업창 닫힘"></a>
	
	<section id="pbPopContent">
		<p class="listDotFS"><strong>[정규과정] ${data.coursename}</strong>
			<span class="fr">남은시간 : <em id="limittimesecond" class="fcR"></em></span>
		</p>
		
		<table class="tblList lineLeft mgtS">
			<caption>정규과정 평가</caption>
			<colgroup>
				<col style="width:20%">
				<col style="width:30%">
				<col style="width:20%">
				<col style="width:30%">
			</colgroup>
			<tbody>
			<tr>
				<th scope="row" class="bg">시험명</th>
				<td colspan="3" class="textL">${data.testname}</td>
			</tr>
			<tr>
				<th scope="row" class="bg">대상</th>
				<td class="textL"><span id="aboNo">${sessionUid}</span> <span id="aboName">${sessionName}</span></td>
				<th scope="row" class="bg">총 문제수</th>
				<td class="textL">객관식 ${data.objectcount}, 주관식 ${data.subjectcount}</td>
			</tr>
			</tbody>
		</table>
		<p class="listWarning mgbS">※ 주어진 시간내에 답안지를 제출해야하며, 시간이 초과될 경우 작성된 부분까지 답안지가 자동 제출됩니다.</p>
		
		<!-- @edit 20160808 -->
		<!-- 시작 메세지 -->
		<div id="testStartText" class="testBox" <c:if test="${data.studyflag eq 'Y'}">style="display:none"</c:if>>
			지금부터 시험을 시작하겠습니다.<br/>
			시험시간은 총 ${data.limittime}분이며, 시간이 초과될 경우 작성된 부분까지 답안지가 자동 제출됩니다.<br/>  
			준비가 되셨으면 [시작] 버튼을 누르시기 바랍니다.
			<p class="listWarning">※ 바로시작이 어려울 경우 ${data.enddate}까지 완료하시기 바랍니다.</p>
			<div class="btnWrapC">
				<a href="#none" class="btnBasicAcGS" id="testCancelButton">취소</a>
				<a href="#none" class="btnBasicAcGNS" id="testStartButton">시작</a>
			</div>
		</div>
		<!-- //시작 메세지 -->
		<!-- 시험시작 -->
		<p id="currPerTotal" class="textR mgbS" <c:if test="${data.studyflag ne 'Y' or data.submitflag eq 'Y'}">style="display:none"</c:if>>${data.answerseq}/${data.answercount}</p>
		
		<form id="frm" name="frm" method="post">
		<input type="hidden" id="stepcourseid" name="stepcourseid" value="${param.stepcourseid}"/>
		<input type="hidden" id="courseid" name="courseid" value="${param.courseid}"/>
		<input type="hidden" id="stepseq" name="stepseq" value="${param.stepseq}"/>
		<input type="hidden" id="limittimesecondint" name="limittimesecondint" value="${data.limittimesecond}"/>
		<input type="hidden" id="answerseq" name="answerseq" value="${data.answerseq}"/>
		<input type="hidden" id="answercount" name="answercount" value="${data.answercount}"/>
		<input type="hidden" id="submitflag" name="submitflag" value="${data.submitflag}"/>
		<div id="sampleArea" class="testBox" <c:if test="${data.studyflag ne 'Y' or data.submitflag eq 'Y' }">style="display:none"</c:if>>
			<c:forEach var="dataList" items="${dataList}" varStatus="idx">
			<p id="testName_${dataList.answerseq}" class="quest" <c:if test="${data.answerseq ne dataList.answerseq}">style="display:none;"</c:if>>${dataList.answerseq}. ${dataList.testpoolnote} [${dataList.answertypename} ${dataList.testpoolpoint}점]</p>
			<c:if test="${dataList.testpoolimage ne ''}">
				<div id="testImage_${dataList.answerseq}" <c:if test="${data.answerseq ne dataList.answerseq}">style="display:none;"</c:if>>
					<img src="/lms/common/imageView.do?file=${dataList.testpoolimage}&mode=test" alt="${dataList.testpoolimagenote}" style="max-width:670px;"/>
				</div>
			</c:if>
			<div class="formBox" id="testFormBox_${dataList.answerseq}" <c:if test="${data.answerseq ne dataList.answerseq}">style="display:none;"</c:if>>
				<input type="hidden" id="answertype_${dataList.answerseq}" name="answertype_${dataList.answerseq}" value="${dataList.answertype}"/>
				<c:if test="${dataList.answertype eq '1'}">
					<c:forEach var="sampleList" items="${dataList.sampleList}" varStatus="idx2">
						<input type="radio" id="answerseq_${dataList.answerseq}_${sampleList.sampleno}" name="answerseq_${dataList.answerseq}" value="${sampleList.sampleno}" <c:if test="${fn:indexOf(dataList.answer,sampleList.sampleno)>=0}">checked="checked"</c:if> />
						<label for="answerseq_${dataList.answerseq}_${sampleList.sampleno}">${sampleList.samplename}</label><br/>
					</c:forEach>
				</c:if>	
				<c:if test="${dataList.answertype eq '2'}">
					<c:forEach var="sampleList" items="${dataList.sampleList}" varStatus="idx2">
						<input type="checkbox" id="answerseq_${dataList.answerseq}_${sampleList.sampleno}" name="answerseq_${dataList.answerseq}" value="${sampleList.sampleno}" <c:if test="${fn:indexOf(dataList.answer,sampleList.sampleno)>=0}">checked="checked"</c:if> />
						<label for="answerseq_${dataList.answerseq}_${sampleList.sampleno}">${sampleList.samplename}</label><br/>
					</c:forEach>
				</c:if>
				<c:if test="${dataList.answertype eq '3'}">
					<textarea id="answerseq_${dataList.answerseq}" name="answerseq_${dataList.answerseq}" onkeyup="javascript:fnCheckLength('${dataList.answerseq}',200);" onkeydown="javascript:fnCheckLength('${dataList.answerseq}',200);" style="width:670px; height:100px;" title="주관식 질문">${dataList.answer}</textarea>
					<span class="byte" id="answerseqCheck_${dataList.answerseq}">0/200자</span>
				</c:if>	
			</div>
			</c:forEach>
		</div>
		</form>
		
		<div id="smpleButtonArea" class="btnWrapC2 mgtL" <c:if test="${data.studyflag ne 'Y' or data.submitflag eq 'Y'}">style="display:none"</c:if>>
			<span class="btnL"><a href="#none" id="prevButton" class="btnBasicAcGS">&lt; 이전문제</a></span>
			<span class="btnR"><a href="#none" id="nextButton" class="btnBasicAcGS" <c:if test="${data.answerseq eq data.answercount}">style="display:none;"</c:if>>다음문제 &gt;</a></span>
			<span class="btnR"><a href="#none" id="submitButton" class="btnBasicAcGS" <c:if test="${data.answerseq ne data.answercount}">style="display:none;"</c:if>>답안지제출 &gt;</a></span>
		</div>
		
		<!-- 종료 메세지 -->
		<div id="endArea" class="testBox textC" <c:if test="${data.submitflag ne 'Y'}">style="display:none"</c:if>>
			<p class="quest">수고하셨습니다.</p>
			<p class="mgtM">채점결과는 ${data.noticedate}에 발표 예정입니다.<br/>
			결과 확인은 통합교육 신청현황 해당교육 상세페이지에서 확인 가능합니다.</p>
			<div class="btnWrapC">
				<a href="#none" id="testCloseButton" class="btnBasicAcGNL">닫기</a>
			</div>
		</div>
		<!-- //종료 메세지 -->
	</section>
	
	<form name="submitFrm" id="submitFrm" method="post">
		<input type="hidden" name="stepcourseid" value="">
		 <input type="hidden" name="courseid" value="">
		 <input type="hidden" name="stepseq" value="">
		 <input type="hidden" name="answerseq" value="">
		 <input type="hidden" name="objectanswer" value="">
		 <input type="hidden" name="subjectanswer" value="">
	</form>
	
</div>
</body>
</html>
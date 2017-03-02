<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html>
<head>
<title></title>
<script type="text/javascript">
var forInsert = null;
var forUpload = null;
var swfu = null;
var	returnValue = [];
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. uploader
	swfu = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/excel/save.do"/>",
				fileTypes : "*.xls;*.xlsx",
				fileTypesDescription : "Excel Files",
				fileSizeLimit : "10 MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputHeight : 22, // default : 22
				immediatelyUpload : false,
				successCallback : function(id, file) {
					var serverData = file["serverData"];
					if (serverData.success == 1) {
						
						var ckeckProgress = true;
						var examInfo = {scoreTypeCd : '', totalScore : 0, totalExamItemCount : 0};
						var form = UT.getById(forInsert.config.formId);
						examInfo.scoreTypeCd = form.elements["scoreTypeCd"].value;
						if ('paper' === examInfo.scoreTypeCd) {
							examInfo.totalScore = parseInt(form.elements["totalScore"].value);
							examInfo.totalExamItemCount = parseInt(form.elements["isExamItemCount"].value) + parseInt(serverData.list.length);
							if (examInfo.totalScore > 0 && examInfo.totalScore % examInfo.totalExamItemCount != 0) {
								$.alert({message : "<spring:message code="글:과정:문항당점수가유효한점수가아닙니다"/><br><spring:message code="글:과정:출제문제수를수정하십시오"/><br>(<spring:message code="필드:과정:문항당점수" />:<b>\""+(examInfo.totalScore / examInfo.totalExamItemCount)+"\"</b><spring:message code="글:과정:점" />)"});
								ckeckProgress = false;
							}
						}
						if (ckeckProgress) {
							doInsertlist(serverData.list);
						}
					}
				}
			}
		}]
	);	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forUpload = $.action("script", {formId : "FormUpload"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpload.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>";
	forUpload.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpload.config.fn.exec = doStartUpload;

	forInsert = $.action("ajax", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.type = "json";
	forInsert.config.url = "<c:url value="/course/exam/paper/excel/insert.do"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete = function() {
	};

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpload.validator.set(function() {
		if (UI.uploader.isAppendedFiles(swfu, "uploader") == false) {
			$.alert({
				message : "<spring:message code="글:X을선택하십시오"/>".format({
					0 : "<spring:message code="필드:과정:엑셀파일"/>"
				})
			});
			return false;
		}
		return true;
	});	
	
};
/**
 * 업로드
 */
doUpload = function() {
	forUpload.run();
};
/**
 * 파일업로드 시작
 */
doStartUpload = function() {
	if (UI.uploader.isAppendedFiles(swfu, "uploader") == true) {
		UI.uploader.runUpload(swfu, "uploader");
		return false;
	} else {
		return true;
	}
};
/**
 * 데이타저장
 */
doInsertlist = function(list) {
	jQuery("#input").hide();
	var $result = jQuery("#result").show();
	var $resultText = jQuery("#resultText");
	if (list == null || list.length == 0) {
		var html = [];
		html.push("<div>완료</div>");
		jQuery(html.join("")).appendTo($resultText);
		$resultText.scrollTop($resultText.get(0).scrollHeight);
		var par = $layer.dialog("option").parent;
		if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
			par["<c:out value="${param['callback']}"/>"].call(this, returnValue);
		}
		//$layer.dialog("close");
	} else {
		var html = [];
		var index = list[0].shift(); // 0 번째 값은 라인번호.
		
		var mapPKs = {};
	
		//문항제목
		mapPKs["examItemTitle"] = list[0].length >= 0 ? list[0][0] : "";
		//문항해설
		mapPKs["examItemDescription"] = list[0].length >= 1 ? list[0][1] : "";
		//첨삭기준
		mapPKs["examItemComment"] = list[0].length >= 2 ? list[0][2] : "";
		//출제그룹
		mapPKs["groupKey"] = list[0].length >= 3 ? list[0][3] : "";
		//난이도
		mapPKs["examItemDifficultyCd"] = list[0].length >= 4 ? list[0][4] : "";
		//문항유형
		mapPKs["examItemTypeCd"] = list[0].length >= 5 ? list[0][5] : "";
		//보기수
		mapPKs["exampleCount"] = list[0].length >= 6 ? list[0][6] : "";
		//보기정렬
		mapPKs["examItemAlignCd"] = list[0].length >= 7 ? list[0][7] : "";
		//보기1		
		mapPKs["examExampleTitle1"] = list[0].length >= 8 ? list[0][8] : "";
		//보기2		
		mapPKs["examExampleTitle2"] = list[0].length >= 9 ? list[0][9] : "";
		//보기3		
		mapPKs["examExampleTitle3"] = list[0].length >= 10 ? list[0][10] : "";
		//보기4
		mapPKs["examExampleTitle4"] = list[0].length >= 11 ? list[0][11] : "";
		//보기5
		mapPKs["examExampleTitle5"] = list[0].length >= 12 ? list[0][12] : "";
		//정답 객관식 당일형,진워형 1개 ,객곽식 복수형 2개 [ , ] 형태로 할것 , 주관식 답
		mapPKs["correctAnswer"] = list[0].length >= 13 ? list[0][13] : "";
		//유사정답 주관식 단답형 유사 정답 넣어주는
		mapPKs["similarAnswer"] = list[0].length >= 14 ? list[0][14] : "";
		
		UT.getById(forInsert.config.formId).reset();
		UT.copyValueMapToForm(mapPKs, forInsert.config.formId);
		
		 forInsert.config.fn.complete = function(action, data) {
			html.push("<div " );
			if (data.success != 0) {
				html.push(" class='error'");
			}
			html.push(">");
			html.push("[line " + index + "] = " + list[0].join(" | "));

			switch (data.success) {
			case 0:
				html.push(" - 성공");
				var values = {
						examSeq : data.examSeq
					};
				returnValue.push(values);
				break;
			case 1:
				html.push(" - 등록 오류");
				break;
			case 2:
				html.push(" - exist data");
				break;
			case 3:
				html.push(" - not found member");
				break;
			case 6:
				html.push(" - system process error");
				break;
			case 7:
				html.push(" - status code invalid");
				break;
			case 8:
				html.push(" - required data");
				break;
			case 9:
				html.push(" - data invalid 입력값 속성 오류");
				break;
			case 10:
				html.push(" - 시험문제속성 오류");
				break;
			case 11:
				html.push(" - 마스터 과정 오류");
				break;
			case 12:
				html.push(" - 문항제목 오류");
				break;
			case 13:
				html.push(" - 문항유형 오류");
				break;
			case 14:
				html.push(" - 문항해설 오류");
				break;
			case 15:
				html.push(" - 참삭기준 오류");
				break;
			case 16:
				html.push(" - 난이도 오류");
				break;
			case 17:
				html.push(" - 보기정렬 오류");
				break;
			case 18:
				html.push(" - 정답 오류");
				break;
			case 19:
				html.push(" - 출제그룹 오류");
				break;
			case 20:
				html.push(" - 유사정답 오류");
				break;
			case 21:
				html.push(" - 시험문제속성 오류");
				break;
			case 22:
				html.push(" - 난이도 오류");
				break;
			case 23:
				html.push(" - 문항유형 오류");
				break;
			case 24:
				html.push(" - 보기정렬 오류");
				break;
			case 25:
				html.push(" - 보기 오류");
				break;
			case 26:
				html.push(" - 보기수 오류");
				break;
			default:
				html.push(" - unknwon error");
				break;
			}
			html.push("</div>");
			jQuery(html.join("")).appendTo($resultText);
			$resultText.scrollTop($resultText.get(0).scrollHeight);
			setTimeout(function() {
				doInsertlist(list.slice(1));
			}, 100);
		};
		forInsert.run(); 
	}
};
/**
 * 샘플다운로드
 */
doDownloadSample = function() {
	self.location.href = "<c:url value="/common/excel/course_exam_paper_new.xls"/>";
};
/*
 * 닫기
 */
doCancel = function(){

	$layer.dialog("close");
}
</script>
<style type="text/css">
.error {color:red;}
</style>
<c:import url="/WEB-INF/view/include/upload.jsp" />
</head>
<body>	
	<div id="input"> 
			<table class="detail">
			<colgroup>
				<col style="width: 100px" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th><spring:message code="필드:엑셀파일" /></th>
					<td>
						<form id="FormUpload" name="FormUpload" method="post" onsubmit="return false;">
						<div id="uploader" class="uploader"></div>
						</form>
					</td>
				</tr>
			</tbody>
			</table>	
			<ul class="buttons">
				<li class="left">
					<a href="javascript:void(0)" onclick="doDownloadSample();" class="btn blue"><span class="mid"><spring:message code="버튼:과정:샘플다운로드" /></span></a>
				</li>
				<li class="right">
					<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
						<a href="javascript:void(0)" onclick="doUpload();" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
					</c:if>
					<a href="#" onclick="doCancel();" class="btn blue"><span class="mid"><spring:message code="버튼:취소" /></span></a>
				</li>
			</ul>
	<spring:message code="글:엑셀업로드참고사항글" />
	</div>
	
	<aof:session key="regMemberSeq" var="regMemberSeq"/>
	<aof:session key="updMemberSeq" var="updMemberSeq"/>
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
		<input type="hidden" name="examTypeCd" value="${courseExam.examTypeCd}"/>
		<input type="hidden" name="courseMasterSeq" value="${courseExam.courseMasterSeq}"/>		
		<input type="hidden" name="examItemTitle"/>
		<input type="hidden" name="examItemDescription"/>
		<input type="hidden" name="examItemComment"/>
		<input type="hidden" name="groupKey"/>
		<input type="hidden" name="examItemDifficultyCd"/>
		<input type="hidden" name="examItemTypeCd"/>
		<input type="hidden" name="exampleCount"/>
		<input type="hidden" name="examItemAlignCd"/>
		<input type="hidden" name="examExampleTitle1"/>
		<input type="hidden" name="examExampleTitle2"/>
		<input type="hidden" name="examExampleTitle3"/>
		<input type="hidden" name="examExampleTitle4"/>
		<input type="hidden" name="examExampleTitle5"/>
		<input type="hidden" name="correctAnswer"/>
		<input type="hidden" name="similarAnswer"/>
		<input type="hidden" name="examItemSortOrder" value="1">
		<input type="hidden" name="regMemberSeq" value="${regMemberSeq }"/>
		<input type="hidden" name="updMemberSeq" value="${updMemberSeq }"/>
		
		<input type="hidden" name="scoreTypeCd"        value="<c:out value="${param['scoreTypeCd']}"/>" />
		<input type="hidden" name="totalScore"        value="<c:out value="${param['totalScore']}"/>" />
		<input type="hidden" name="isExamItemCount"        value="<c:out value="${param['isExamItemCount']}"/>" />
	</form>

	<div class="clear"></div>
	<div  id="result" style="display: none;">
		<div id="resultText" style="text-align:left; height:100%; width:100%; border:solid #cdcdcd 1px; "></div>
		<ul class="buttons">
			<li class="right">
				<a href="#" onclick="doCancel();" class="btn blue"><span class="mid"><spring:message code="버튼:목록" /></span></a>
			</li>
		</ul>
	</div>
</body>
</html>
<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdate		= null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url = "<c:url value="/univ/course/exam/offline/answer/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		var par = $layer.dialog("option").parent;
		if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
			par["<c:out value="${param['callback']}"/>"].call(this);
		}
		$layer.dialog("close");
	};
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:점수"/>",
		name : "takeScore",
		data : ["!null", "decimalnumber"],
		check : {
			maxlength : 3
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:점수"/>",
		name : "takeScore",
		data : ["!null", "decimalnumber"],
		check : {
			le : 100
		}
	});
};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
};
</script>
</head>

<body>
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveExamPaperSeq"  	 value="${detailCourseExamPaper.courseActiveExamPaperTarget.courseActiveExamPaperSeq}">
		<input type="hidden" name="courseApplySeq"  	 value="${detailCourseExamPaper.courseApplyElement.courseApplySeq}">
		<input type="hidden" name="activeElementSeq"  	 value="${detailCourseExamPaper.courseApplyElement.activeElementSeq}">
		<input type="hidden" name="courseActiveSeq"  	 value="${detailCourseExamPaper.courseApplyElement.courseActiveSeq}">
		<input type="hidden" name="evaluateScore"  	 value="${detailCourseExamPaper.courseActiveExamPaperTarget.takeScore}">
		
		<table class="tbl-detail">
			<colgroup>
				<col style="width: 100px" />
				<col style="width: 250px" />
				<col style="width: 100px" />
				<col style="width: 250px" />
			</colgroup>
			<tbody>
				<tr>
					<th><spring:message code="필드:시험:이름" /></th>
					<td><c:out value="${detailCourseExamPaper.member.memberName}"/></td>
					<th><spring:message code="필드:시험:아이디" /></th>
					<td><c:out value="${detailCourseExamPaper.member.memberId}"/></td>
				</tr>
				<tr>
					<th><spring:message code="필드:시험:시험제목" /></th>
					<td colspan="3"><c:out value="${detailCourseExamPaper.courseExamPaper.examPaperTitle}"/></td>
				</tr>
				<tr>
					<th><spring:message code="필드:시험:참조파일" /></th>
					<td colspan="3">
						<c:if test="${!empty detailCourseExamPaper.courseActiveExamPaperTarget.attachList}">
							<c:forEach var="rowSub" items="${detailCourseExamPaper.courseActiveExamPaperTarget.attachList}" varStatus="j">
								<div class="vspace"></div>
								<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(rowSub.attachSeq, pageContext.request)}"/>')"><c:out value="${rowSub.realName}"/>&nbsp;&nbsp;<aof:img src="icon/ico_file.gif"/></a>
							</c:forEach>
						</c:if>
					</td>
				</tr>
				<tr>
					<th><spring:message code="필드:시험:점수" /></th>
					<td>
						<input type="text" name="takeScore" style="width: 60px; text-align: right;" value="<aof:number value="${detailCourseExamPaper.courseActiveExamPaperTarget.takeScore}" pattern="##" />">&nbsp;<spring:message code="글:시험:점"/>
					</td>
					<th><spring:message code="필드:시험:채점일" /></th>
					<td><aof:date datetime="${detailCourseExamPaper.courseApplyElement.scoreDtime}" /></td>
				</tr>
				<tr>
					<th><spring:message code="필드:시험:코멘트" /></th>
					<td colspan="3">
						<textarea name="comment" style="width: 600px;"><c:out value="${detailCourseExamPaper.courseActiveExamPaperTarget.comment}" /></textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
	    		<a href="javascript:void(0)" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
      		</c:if>
		</div>
	</div>
	
</body>
</html>
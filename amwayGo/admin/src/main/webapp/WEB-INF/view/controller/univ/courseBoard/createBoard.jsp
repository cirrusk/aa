<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_REPLY_TYPE_1" value="${aoffn:code('CD.BOARD_REPLY_TYPE.1')}"/>
<c:set var="CD_BOARD_TYPE_DYNAMIC" value="${aoffn:code('CD.BOARD_TYPE.DYNAMIC')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/board/list.do"/>";

	forInsert = $.action("submit", {formId : "FormInsert"});
	forInsert.config.url             = "<c:url value="/univ/course/board/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.fn.complete = function() {
		doList();
	};
	
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:게시판명"/>",
		name : "boardTitle",
		data : ["!null"],
		check : {
			maxlength : 30
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:사용여부"/>",
		name : "useYn",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:비밀글"/><spring:message code="필드:게시판:여부"/>",
		name : "secretYn",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:에디터"/><spring:message code="필드:게시판:여부"/>",
		name : "editorYn",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:댓글"/><spring:message code="필드:게시판:여부"/>",
		name : "commentYn",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:답글"/><spring:message code="필드:게시판:여부"/>",
		name : "replyTypeCd",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:첨부파일"/><spring:message code="필드:게시판:여부"/>",
		name : "attachCount",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:제한용량"/>",
		name : "attachSize",
		data : ["!null", "number"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:제한용량"/>",
		name : "attachSize",
		check : {
			maxlength : 3,
			le : 100,
			gt : 0
		},
		when : function() {
			var form = UT.getById(forInsert.config.formId);
			var field = "attachCount";
			var value = parseInt(form.elements[field].value, 10);
			if (value > 0) {
				return true;
			} else {
				return false;
			}
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:제한용량"/>",
		name : "attachSize",
		check : {
			eq : 0
		},
		when : function() {
			var form = UT.getById(forInsert.config.formId);
			var field = "attachCount";
			var value = parseInt(form.elements[field].value, 10);
			if (value == 0) {
				return true;
			} else {
				return false;
			}
		}
	});

};
/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
	forListdata.run();
};
/**
 * 목록에서 삭제할 때 호출되는 함수
 */
doInsert = function() { 
	forInsert.run();
};
/**
 * 첨부파일 수 변경
 */
doChangeAttachCount = function(element) {
	var form = UT.getById(forInsert.config.formId);
	var value = parseInt(element.value, 10);
	if (value == 0) {
		form.elements["attachSize"].value = "0";
	}
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<c:import url="../include/commonCourseActive.jsp"></c:import>
	
	<form id="FormList" name="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="shortcutYearTerm"        value="<c:out value="${param['shortcutYearTerm']}"/>" />
		<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
		<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
		<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="referenceSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>">
	<input type="hidden" name="referenceType" value="course">
	<input type="hidden" name="boardTypeCd" value="<c:out value="${CD_BOARD_TYPE_DYNAMIC}"/>">
	<table id="listTable" class="tbl-detail">
	<colgroup>
		<col style="width:120px;" />
		<col style="width:auto;" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:게시판:게시판명" /></th>
			<td><input type="text" name="boardTitle" style="width:200px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:사용여부" /></th>
			<td><aof:code type="radio" codeGroup="YESNO" name="useYn" selected="Y" removeCodePrefix="true" ref="2"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:비밀글" /></th>
			<td><aof:code type="radio" codeGroup="YESNO" name="secretYn" selected="N" removeCodePrefix="true" ref="2"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:에디터" /></th>
			<td><aof:code type="radio" codeGroup="YESNO" name="editorYn" selected="N" removeCodePrefix="true" ref="2"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:댓글" /></th>
			<td><aof:code type="radio" codeGroup="YESNO" name="commentYn" selected="Y" removeCodePrefix="true" ref="2"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:답글" /></th>
			<td>
				<select name="replyTypeCd">
					<aof:code type="option" codeGroup="BOARD_REPLY_TYPE"  selected="${CD_BOARD_REPLY_TYPE_1}"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:첨부파일" /></th>
			<td>
				<c:set var="BOARD_ATTACH_COUNT" value=""/>
				<c:forEach var="rowSub" begin="0" end="10" step="1" varStatus="iSub">
					<c:if test="${iSub.first ne true}">
						<c:set var="BOARD_ATTACH_COUNT"><c:out value="${BOARD_ATTACH_COUNT}"/>,</c:set>
					</c:if>
					<c:set var="BOARD_ATTACH_COUNT"><c:out value="${BOARD_ATTACH_COUNT}"/><c:out value="${rowSub}"/>=<c:out value="${rowSub}"/><spring:message code="글:개" /></c:set>
				</c:forEach>
				
				<select name="attachCount" onchange="doChangeAttachCount(this)">
					<aof:code type="option" codeGroup="${BOARD_ATTACH_COUNT}"  selected="1"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:제한용량" /></th>
			<td><input type="text" name="attachSize" value="10" class="align-c" style="width:30px;">MB</td>
		</tr>
	</tbody>
	</table>	
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="#" onclick="doInsert()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>

</body>
</html>
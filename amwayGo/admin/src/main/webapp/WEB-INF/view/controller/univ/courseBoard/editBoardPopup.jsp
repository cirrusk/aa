<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_TYPE_DYNAMIC" value="${aoffn:code('CD.BOARD_TYPE.DYNAMIC')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdate = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forUpdate = $.action("submit", {formId : "FormUpdate"});
	forUpdate.config.url             = "<c:url value="/board/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.fn.complete = function() {
		var par = $layer.dialog("option").parent;
		if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
			par["<c:out value="${param['callback']}"/>"].call(this);
		}
		doClose();
	};
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:게시판명"/>",
		name : "boardTitle",
		data : ["!null"],
		check : {
			maxlength : 30
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:사용여부"/>",
		name : "useYn",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:비밀글"/><spring:message code="필드:게시판:여부"/>",
		name : "secretYn",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:에디터"/><spring:message code="필드:게시판:여부"/>",
		name : "editorYn",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:댓글"/><spring:message code="필드:게시판:여부"/>",
		name : "commentYn",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:답글"/><spring:message code="필드:게시판:여부"/>",
		name : "replyTypeCd",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:첨부파일"/><spring:message code="필드:게시판:여부"/>",
		name : "attachCount",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:제한용량"/>",
		name : "attachSize",
		data : ["!null", "number"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:제한용량"/>",
		name : "attachSize",
		check : {
			maxlength : 3,
			le : 100,
			gt : 0
		},
		when : function() {
			var form = UT.getById(forUpdate.config.formId);
			var field = "attachCount";
			var value = parseInt(form.elements[field].value, 10);
			if (value > 0) {
				return true;
			} else {
				return false;
			}
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:제한용량"/>",
		name : "attachSize",
		check : {
			eq : 0
		},
		when : function() {
			var form = UT.getById(forUpdate.config.formId);
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
 * 저장 함수
 */
doUpdate = function() { 
	forUpdate.run();
};
/**
 * 첨부파일 수 변경
 */
doChangeAttachCount = function(element) {
	var form = UT.getById(forUpdate.config.formId);
	var value = parseInt(element.value, 10);
	if (value == 0) {
		form.elements["attachSize"].value = "0";
	}
};
/**
 * 닫기
 */
doClose = function() {
	$layer.dialog("close");
};
</script>
</head>

<body>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="boardSeq" value="<c:out value="${detailBoard.board.boardSeq}"/>">
	<table id="listTable" class="tbl-detail">
	<colgroup>
		<col style="width:120px;" />
		<col style="width:auto;" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:게시판:게시판명" /></th>
			<td>
				<c:choose>
					<c:when test="${detailBoard.board.boardTypeCd eq CD_BOARD_TYPE_DYNAMIC}">
						<input type="text" name="boardTitle" value="<c:out value="${detailBoard.board.boardTitle}"/>" style="width:200px;">
					</c:when>
					<c:otherwise>
						<c:out value="${detailBoard.board.boardTitle}"/>
						<input type="hidden" name="boardTitle" value="<c:out value="${detailBoard.board.boardTitle}"/>">
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:사용여부" /></th>
			<td><aof:code type="radio" codeGroup="YESNO" name="useYn" selected="${detailBoard.board.useYn}" removeCodePrefix="true" ref="2"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:비밀글" /></th>
			<td><aof:code type="radio" codeGroup="YESNO" name="secretYn" selected="${detailBoard.board.secretYn}" removeCodePrefix="true" ref="2"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:에디터" /></th>
			<td><aof:code type="radio" codeGroup="YESNO" name="editorYn" selected="${detailBoard.board.editorYn}" removeCodePrefix="true" ref="2"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:댓글" /></th>
			<td><aof:code type="radio" codeGroup="YESNO" name="commentYn" selected="${detailBoard.board.commentYn}" removeCodePrefix="true" ref="2"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:답글" /></th>
			<td>
				<select name="replyTypeCd">
					<aof:code type="option" codeGroup="BOARD_REPLY_TYPE"  selected="${detailBoard.board.replyTypeCd}"/>
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
					<aof:code type="option" codeGroup="${BOARD_ATTACH_COUNT}"  selected="${detailBoard.board.attachCount}"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:제한용량" /></th>
			<td><input type="text" name="attachSize" value="<c:out value="${detailBoard.board.attachSize}"/>" class="align-c" style="width:30px;">MB</td>
		</tr>
	</tbody>
	</table>	
	</form>

	<c:set var="boardMenu" value="" scope="request"/>
	<c:forEach var="row" items="${appMenuList}">
		<c:if test="${row.menu.url eq '/univ/course/board/list.do'}">
			<c:set var="boardMenu" value="${row.rolegroupMenu}" scope="request"/>
		</c:if>
	</c:forEach>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(boardMenu, 'U')}">
				<a href="#" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
			</c:if>
		</div>
	</div>

</body>
</html>
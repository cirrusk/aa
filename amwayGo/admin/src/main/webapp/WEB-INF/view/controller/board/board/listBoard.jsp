<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdatelist = null;
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
	forListdata.config.url    = "<c:url value="/board/list.do"/>";
	
	forUpdatelist = $.action("submit", {formId : "FormData"});
	forUpdatelist.config.url             = "<c:url value="/board/updatelist.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelist.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdatelist.config.fn.complete = function() {
		doList();
	};
	
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
	forUpdatelist.validator.set({
		title : "<c:out value="${row.board.boardTitle}"/>&nbsp;<spring:message code="필드:게시판:사용여부"/>",
		name : "useYnList[<c:out value="${i.index}"/>]",
		data : ["!null"]
	});
	forUpdatelist.validator.set({
		title : "<c:out value="${row.board.boardTitle}"/>&nbsp;<spring:message code="필드:게시판:비밀글"/><spring:message code="필드:게시판:여부"/>",
		name : "secretYnList[<c:out value="${i.index}"/>]",
		data : ["!null"]
	});
	forUpdatelist.validator.set({
		title : "<c:out value="${row.board.boardTitle}"/>&nbsp;<spring:message code="필드:게시판:에디터"/><spring:message code="필드:게시판:여부"/>",
		name : "editorYnList[<c:out value="${i.index}"/>]",
		data : ["!null"]
	});
	forUpdatelist.validator.set({
		title : "<c:out value="${row.board.boardTitle}"/>&nbsp;<spring:message code="필드:게시판:댓글"/><spring:message code="필드:게시판:여부"/>",
		name : "commentYnList[<c:out value="${i.index}"/>]",
		data : ["!null"]
	});
	forUpdatelist.validator.set({
		title : "<c:out value="${row.board.boardTitle}"/>&nbsp;<spring:message code="필드:게시판:답글"/><spring:message code="필드:게시판:여부"/>",
		name : "replyTypeCdList[<c:out value="${i.index}"/>]",
		data : ["!null"]
	});
	forUpdatelist.validator.set({
		title : "<c:out value="${row.board.boardTitle}"/>&nbsp;<spring:message code="필드:게시판:첨부파일"/><spring:message code="필드:게시판:여부"/>",
		name : "attachCountList[<c:out value="${i.index}"/>]",
		data : ["!null"]
	});
	forUpdatelist.validator.set({
		title : "<c:out value="${row.board.boardTitle}"/>&nbsp;<spring:message code="필드:게시판:제한용량"/>",
		name : "attachSizeList[<c:out value="${i.index}"/>]",
		data : ["!null", "number"]
	});
	forUpdatelist.validator.set({
		title : "<c:out value="${row.board.boardTitle}"/>&nbsp;<spring:message code="필드:게시판:제한용량"/>",
		name : "attachSizeList[<c:out value="${i.index}"/>]",
		check : {
			maxlength : 3,
			le : 100,
			gt : 0
		},
		when : function() {
			var form = UT.getById(forUpdatelist.config.formId);
			var field = "attachCountList[<c:out value="${i.index}"/>]";
			var value = parseInt(form.elements[field].value, 10);
			if (value > 0) {
				return true;
			} else {
				return false;
			}
		}
	});
	forUpdatelist.validator.set({
		title : "<c:out value="${row.board.boardTitle}"/>&nbsp;<spring:message code="필드:게시판:제한용량"/>",
		name : "attachSizeList[<c:out value="${i.index}"/>]",
		check : {
			eq : 0
		},
		when : function() {
			var form = UT.getById(forUpdatelist.config.formId);
			var field = "attachCountList[<c:out value="${i.index}"/>]";
			var value = parseInt(form.elements[field].value, 10);
			if (value == 0) {
				return true;
			} else {
				return false;
			}
		}
	});
	
	</c:forEach>

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
doUpdatelist = function() { 
	forUpdatelist.run();
};
/**
 * 첨부파일 수 변경
 */
doChangeAttachCount = function(element, index) {
	var form = UT.getById(forUpdatelist.config.formId);
	var value = parseInt(element.value, 10);
	if (value == 0) {
		form.elements["attachSizeList[" + index + "]"].value = "0";
	}
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
	
	<form id="FormList" name="FormList" method="post" onsubmit="return false;">
	</form>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-detail">
	<colgroup>
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: auto" />
	</colgroup>
	<thead>
		<tr>
			<th class="align-c"><spring:message code="필드:게시판:게시판명" /></th>
			<th class="align-c"><spring:message code="필드:게시판:사용여부" /></th>
			<th class="align-c"><spring:message code="필드:게시판:비밀글" /></th>
			<th class="align-c"><spring:message code="필드:게시판:에디터" /></th>
			<th class="align-c"><spring:message code="필드:게시판:댓글" /></th>
			<th class="align-c"><%-- <spring:message code="필드:게시판:글쓰기허용" /> --%></th>
			<th class="align-c"><spring:message code="필드:게시판:첨부파일" /></th>
			<th class="align-c"><spring:message code="필드:게시판:제한용량" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<input type="hidden" name="boardSeqList[${i.index}]" value="<c:out value="${row.board.boardSeq}"/>">
		<tr>
			<th><c:out value="${row.board.boardTitle}"/></th>
			<td class="align-c">
				<div class="align-l inline-block" style="width:80px;">
					<aof:code type="radio" codeGroup="YESNO" name="useYnList[${i.index}]" selected="${row.board.useYn}" removeCodePrefix="true" cols="1" ref="2"/>
				</div>
			</td>
			<td class="align-c">
				<div class="align-l inline-block" style="width:80px;">
					<aof:code type="radio" codeGroup="YESNO" name="secretYnList[${i.index}]" selected="${row.board.secretYn}" removeCodePrefix="true" cols="1" ref="2"/>
				</div>
			</td>
			<td class="align-c">
				<div class="align-l inline-block" style="width:80px;">
					<aof:code type="radio" codeGroup="YESNO" name="editorYnList[${i.index}]" selected="${row.board.editorYn}" removeCodePrefix="true" cols="1" ref="2"/>
				</div>
			</td>
			<td class="align-c">
				<div class="align-l inline-block" style="width:80px;">
					<aof:code type="radio" codeGroup="YESNO" name="commentYnList[${i.index}]" selected="${row.board.commentYn}" removeCodePrefix="true" cols="1" ref="2"/>
				</div>
			</td>
			<td class="align-c">
				<select name="replyTypeCdList[${i.index}]">
					<aof:code type="option" codeGroup="BOARD_REPLY_TYPE"  selected="${row.board.replyTypeCd}"/>
				</select>
			</td>
			<td class="align-c">
				<c:set var="BOARD_ATTACH_COUNT" value=""/>
				<c:forEach var="rowSub" begin="0" end="10" step="1" varStatus="iSub">
					<c:if test="${iSub.first ne true}">
						<c:set var="BOARD_ATTACH_COUNT"><c:out value="${BOARD_ATTACH_COUNT}"/>,</c:set>
					</c:if>
					<c:set var="BOARD_ATTACH_COUNT"><c:out value="${BOARD_ATTACH_COUNT}"/><c:out value="${rowSub}"/>=<c:out value="${rowSub}"/><spring:message code="글:개" /></c:set>
				</c:forEach>
				
				<select name="attachCountList[${i.index}]" onchange="doChangeAttachCount(this, '${i.index}')">
					<aof:code type="option" codeGroup="${BOARD_ATTACH_COUNT}"  selected="${row.board.attachCount}"/>
				</select>
			</td>
			<td class="align-c">
				<input type="text" name="attachSizeList[${i.index}]" value="<c:out value="${row.board.attachSize}"/>" class="align-c" style="width:30px;">MB
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="8" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</tbody>
	</table>	
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doUpdatelist()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
			</c:if>
		</div>
	</div>

</body>
</html>
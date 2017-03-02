<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">

var REPLY = {
	forListdata : null,
	forDetail : null,
	
	/**
	 * 설정
	 */
	doInitializeLocal : function() {
		REPLY.forListdata = $.action();
		REPLY.forListdata.config.formId = "FormReplyList";
		REPLY.forListdata.config.url    = "<c:url value="/univ/course/discuss/result/reply/list/ajax.do"/>";
		
		REPLY.forDetail = $.action();
		REPLY.forDetail.config.formId = "FormDetail";
		REPLY.forDetail.config.url    = "<c:url value="/univ/course/discuss/result/bbs/detail/iframe.do"/>";
	
	},
	/**
	 * 목록페이지 이동. page navigator에서 호출되는 함수
	 */
	doPage : function(pageno) {
		var form = UT.getById(REPLY.forListdata.config.formId);
		if(form.elements["currentPage"] != null && pageno != null) {
			form.elements["currentPage"].value = pageno;
		}
		REPLY.doList();
	},
	/**
	 * 목록보기 가져오기 실행.
	 */
	doList : function() {
		REPLY.forListdata.run();
	},
	/**
	 * 상세보기 화면을 호출하는 함수
	 */
	doDetail : function(mapPKs) {
		// 상세화면 form을 reset한다.
		UT.getById(REPLY.forDetail.config.formId).reset();
		// 상세화면 form에 키값을 셋팅한다.
		UT.copyValueMapToForm(mapPKs, REPLY.forDetail.config.formId);
		// 상세화면 실행
		REPLY.forDetail.run();
	}
}

</script>
</head>

<body>

	<div class="vspace mt10"></div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width:120px;" />
		<col style="width:auto;" />
		<col style="width:100px;" />
	</colgroup>
	<tbody>
		<tr>
	        <th><spring:message code="글:게시판:원게시글" /></th>
			<td>
				<c:if test="${detailBbs.bbs.groupLevel gt 1}">
					re:
				</c:if>
				<c:if test="${detailBbs.bbs.secretYn eq 'Y'}">
					[<spring:message code="필드:게시판:비밀글" />]
				</c:if>
				<a href="#" onclick="REPLY.doDetail({'bbsSeq' : '${detailBbs.bbs.bbsSeq}'});"><c:out value="${detailBbs.bbs.bbsTitle}" /></a>
				<c:if test="${detailBbs.bbs.attachCount gt 0}">
					<aof:img src="icon/ico_file.gif"/>
				</c:if>
			</td>
			<td class="align-c"><c:out value="${detailBbs.bbs.regMemberName}"/></td>
		</tr>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
		        <th>
		        	<c:if test="${i.first}">
		        		<spring:message code="글:게시판:답변게시글" />
		        	</c:if>
		        </th>
				<td>
					<c:if test="${row.bbs.groupLevel gt 1}">
						re:
					</c:if>
					<c:if test="${row.bbs.secretYn eq 'Y'}">
						[<spring:message code="필드:게시판:비밀글" />]
					</c:if>
					<a href="#" onclick="REPLY.doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
					<c:if test="${row.bbs.attachCount gt 0}">
						<aof:img src="icon/ico_file.gif"/>
					</c:if>
				</td>
				<td class="align-c"><c:out value="${row.bbs.regMemberName}"/></td>
			</tr>
		</c:forEach>
	</tbody>
	</table>

	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
		<c:param name="func" value="REPLY.doPage"/>
	</c:import>

	<script type="text/javascript">
	REPLY.doInitializeLocal();
	</script>
	
</body>
</html>
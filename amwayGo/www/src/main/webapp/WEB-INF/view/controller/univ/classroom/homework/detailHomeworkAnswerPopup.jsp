<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ONOFF_TYPE_ON" value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>

<html>
<head>

<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>

<title></title>
<script type="text/javascript">

initPage = function() {
   
};

/**
 * 첨부파일 다운로드
 */
doAttachDownload = function(attachSeq) {
	var action = $.action();
	action.config.formId = "FormParameters";
	action.config.url = "<c:url value="/attach/file/response.do"/>";
	jQuery("#" + action.config.formId).find(":input[name='attachSeq']").remove();
	jQuery("#" + action.config.formId).find(":input[name='module']").remove();
	var param = [];
	param.push("attachSeq=" + attachSeq);
	param.push("module=univ");
	action.config.parameters = param.join("&");
	action.run();
};

</script>
</head>

<body>	
	<form name="FormInsert" id="FormInsert" method="post" onsubmit="return false;">

		<h3 class="content-title"><spring:message code="필드:과제응답:제출정보"/></h3>

		<table class="tbl-detail">
	 		<colgroup>
	     		<col style="width: 20%" />
	     		<col style="width: 30%" />
	     		<col style="width: 20%" />
	     		<col style="width: 30%" />
	 		</colgroup>
	 		<tbody>
	 			<c:if test="${param['onoffCd'] eq CD_ONOFF_TYPE_ON}">
			     	<tr>
			         	<th><spring:message code="필드:과제응답:제목"/></th>
			         	<td colspan="3">
			            	<c:out value="${answer.answer.homeworkAnswerTitle}"/>
			         	</td>
		     		</tr>
		     		<tr>
		         		<th><spring:message code="필드:과제응답:내용"/></th>
		         		<td colspan="3">
		             		<aof:text type="whiteTag" value="${answer.answer.description}"/>
		         		</td>
		     		</tr>	 		
	 			</c:if>
	     		<tr>
	         		<th><spring:message code="필드:과제응답:제출파일"/></th>
					<td colspan="3">
			        	<c:forEach var="row" items="${answer.answer.unviAttachList}" varStatus="i">
							<a href="javascript:void(0)" onclick="doAttachDownload('<c:out value="${row.attachSeq}"/>')"><c:out value="${row.realName}"/></a>
							[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
						</c:forEach>
					</td>
	     		</tr>
	     		<tr>
	         		<th><spring:message code="필드:과제응답:제출차수"/></th>
					<td>
			        	<aof:text type="whiteTag" value="${answer.answer.sendDegree}"/><spring:message code="필드:과제응답:차"/>
					</td>
					<th><spring:message code="필드:과제응답:제출일"/></th>
					<td>
			        	<aof:date datetime="${answer.answer.sendDtime}" pattern="${aoffn:config('format.datetime')}"/>
					</td>					
	     		</tr>
	     		<tr>
	         		<th><spring:message code="필드:과제응답:점수"/></th>
					<td>
			        	<aof:text type="whiteTag" value="${answer.answer.scaledScore}"/>
					</td>
					<th><spring:message code="필드:과제응답:채점일"/></th>
					<td>
			        	<aof:date datetime="${answer.answer.scoreDtime}" pattern="${aoffn:config('format.datetime')}"/>
					</td>					
	     		</tr>
	     		<tr>
	         		<th><spring:message code="필드:과제응답:코멘트"/></th>
	         		<td colspan="3">
	             		<aof:text type="whiteTag" value="${answer.answer.comment}"/>
	         		</td>
	     		</tr>	     			     			     		
	    	</tbody>
		</table>
		
		<div class="lybox-btn">
			<div class="lybox-btn-r">
				<a href="#" onclick="javascript:$layer.dialog('close');" class="btn blue"><span class="mid"><spring:message code="버튼:닫기"/></span></a>
			</div>
		</div>
		
	</form>
</body>
</html>
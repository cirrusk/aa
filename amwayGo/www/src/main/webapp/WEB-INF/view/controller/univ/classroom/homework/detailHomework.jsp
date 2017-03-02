<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ONOFF_TYPE_ON" value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>

<html decorator="${decorator}">
<head>
<title></title>
<script type="text/javascript">

var forListdata = null;
var forCreateAnswerPopup = null;
var forDetail = null;

initPage = function() {
	doInitializeLocal();
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/usr/classroom/homework/list.do"/>";
	
    forCreateAnswerPopup = $.action("layer");
    forCreateAnswerPopup.config.formId         = "FormDetail";
    forCreateAnswerPopup.config.url            = "<c:url value="/usr/classroom/homework/create/answer/popup.do"/>";
    forCreateAnswerPopup.config.options.width  = 800;
    forCreateAnswerPopup.config.options.height = 500;
    
    forDetail = $.action();
    forDetail.config.formId = "FormDetail";
    forDetail.config.url    = "<c:url value="/usr/classroom/homework/detail.do"/>";

};

/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

/**
 * 과제제출 팝업호출
 */
doHomeWorkSubmit = function(mapPKs){
    UT.getById(forCreateAnswerPopup.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forCreateAnswerPopup.config.formId);
    
    if(mapPKs.homeworkAnswerSeq == null || mapPKs.homeworkAnswerSeq == ""){
    	forCreateAnswerPopup.config.options.title  = "<spring:message code="필드:과제응답:과제제출"/>";
    }else{
    	forCreateAnswerPopup.config.options.title  = "<spring:message code="필드:과제응답:제출정보수정"/>";
    }
    
	forCreateAnswerPopup.run();
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

/**
 * 과제제출 팝업종료
 */
doHomeWorkSubmitClose = function(mapPKs){
    UT.getById(forDetail.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	forDetail.run();
};

</script>
</head>

<body>

<c:import url="srchHomework.jsp"></c:import>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div id="tabContainer">

	<div class="lybox-title">
	    <h4 class="section-title"><spring:message code="필드:과제응답:과제정보"/></h4>
	</div>
	
	<table class="tbl-detail">
	<colgroup>
	    <col style="width: 140px" />
	    <col/>
	</colgroup>
	<tbody>
		<tr>
	    	<th>
	            <spring:message code="필드:과제:과제제목"/>
	        </th>
	        <td>
	            <c:out value="${detail.courseHomework.homeworkTitle}"/>
	        </td>
	   	</tr>
	    <tr>
	        <th>
	            <spring:message code="필드:과제:과제내용"/>
	        </th>
	        <td>
	            <aof:text type="whiteTag" value="${detail.courseHomework.description}"/>
	        </td>
	    </tr>
	    <c:if test="${!empty detail.courseHomework.attachList}">
			<tr>
				<th><spring:message code="필드:게시판:첨부파일"/></th>
				<td>
					<c:forEach var="row" items="${detail.courseHomework.attachList}" varStatus="i">
						<a href="javascript:void(0)" onclick="doAttachDownload('<c:out value="${row.attachSeq}"/>')"><c:out value="${row.realName}"/></a>
						[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
					</c:forEach>
				</td>
			</tr>
		</c:if>
	    <tr>
	         <th>
	             <spring:message code="필드:과제:1차제출기간"/>
	         </th>
	         <td>
	         	<aof:date datetime="${detail.courseHomework.startDtime}"/>&nbsp;
	         	<aof:date datetime="${detail.courseHomework.startDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
	         	<aof:date datetime="${detail.courseHomework.startDtime}" pattern="mm"/><spring:message code="글:분"/>
	         	~
	         	<aof:date datetime="${detail.courseHomework.endDtime}"/>&nbsp;
	         	<aof:date datetime="${detail.courseHomework.endDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
	         	<aof:date datetime="${detail.courseHomework.endDtime}" pattern="mm"/><spring:message code="글:분"/>
	         </td>
	    </tr>
	    <c:if test="${detail.courseHomework.useYn eq 'Y'}">
		    <tr>
		        <th>
		             <spring:message code="필드:과제:2차제출기간"/>
		        </th>
		        <td>
		         	<aof:date datetime="${detail.courseHomework.start2Dtime}"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.start2Dtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.start2Dtime}" pattern="mm"/><spring:message code="글:분"/>
		         	~
		         	<aof:date datetime="${detail.courseHomework.end2Dtime}"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.end2Dtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
		         	<aof:date datetime="${detail.courseHomework.end2Dtime}" pattern="mm"/><spring:message code="글:분"/>
		         	|
		         	<spring:message code="글:과제:1차대비배점"/> :
		         	<c:out value="${detail.courseHomework.rate2}"/> %
		    	</td>
			</tr>
		</c:if>
	</tbody>
	</table>
	 
	<c:if test="${!empty answer}" > 
		<br/> 
		<div class="lybox-title">
		    <h4 class="section-title"><spring:message code="필드:과제응답:제출정보"/></h4>
		</div>
		
		<table class="tbl-detail">
			<colgroup>
				<col style="width: 140px" />
			    <col/>
			</colgroup>
			<tbody>
				<c:if test="${detail.courseHomework.onoffCd eq CD_ONOFF_TYPE_ON}">
				    <tr>
				        <th><spring:message code="필드:과제응답:제목"/></th>
				        <td>
				            <c:out value="${answer.answer.homeworkAnswerTitle}"/>
				        </td>
				    </tr>
				    <tr>
				        <th><spring:message code="필드:과제응답:내용"/></th>
				        <td>
				        	<aof:text type="whiteTag" value="${answer.answer.description}"/>
				        </td>
				    </tr>
			    </c:if>
			    <tr>
			        <th><spring:message code="필드:과제응답:제출파일"/></th>
			        <td>
			        	<c:forEach var="row" items="${answer.answer.unviAttachList}" varStatus="i">
							<a href="javascript:void(0)" onclick="doAttachDownload('<c:out value="${row.attachSeq}"/>')"><c:out value="${row.realName}"/></a>
							[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
						</c:forEach>
			        </td>
			    </tr>			    
			    <tr>
			        <th><spring:message code="필드:과제응답:제출일"/></th>
			        <td>
			        	<aof:date datetime="${answer.answer.sendDtime}" pattern="${aoffn:config('format.datetime')}"/>
			        </td>
			    </tr>
			</tbody>
		</table>	 
	</c:if>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${detail.courseHomework.onoffCd eq CD_ONOFF_TYPE_ON}">
		    	<c:if test="${detail.courseHomework.homeworkStatus eq 'D' and empty detail.answer.homeworkAnswerSeq}">
					<a href="#" onclick="javascript:doHomeWorkSubmit({'homeworkAnswerSeq' : '', 'openYn' : '<c:out value="${detail.courseHomework.openYn}" />', 'useYn' : '<c:out value="${detail.courseHomework.useYn}" />'});" class="btn blue">
						<span class="mid"><spring:message code="버튼:과제응답:제출하기"/></span>
					</a>
				</c:if>
				<c:if test="${empty detail.answer.scoreDtime}">
					<c:if test="${detail.courseHomework.homeworkStatus eq 'D' and not empty detail.answer.homeworkAnswerSeq}">
						<a href="#" onclick="javascript:doHomeWorkSubmit({'homeworkAnswerSeq' : '<c:out value="${detail.answer.homeworkAnswerSeq}"/>', 'openYn' : '<c:out value="${detail.courseHomework.openYn}" />', 'useYn' : '<c:out value="${detail.courseHomework.useYn}" />'});" class="btn blue">
							<span class="mid"><spring:message code="버튼:과제응답:제출정보수정"/></span>
						</a>
					</c:if>		
				</c:if>
			</c:if>      
			<a href="#" onclick="javascript:doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

</div>

</body>
</html>
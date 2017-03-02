<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"      value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT" value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_MIDDLE"    value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.MIDDLE')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_FINAL"     value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.FINAL')}"/>
<c:set var="CD_ONOFF_TYPE_ON"               value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_ONOFF_TYPE_OFF"              value="${aoffn:code('CD.ONOFF_TYPE.OFF')}"/>

<html decorator="classroom-layer">
<head>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>

<c:set var="title"/>

<c:if test="${homeworkInfo.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC and homeworkInfo.courseHomework.replaceYn eq 'N'}">
	<c:set var="title"><spring:message code="필드:과제:일반과제"/></c:set>
</c:if>
<c:if test="${homeworkInfo.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT  and homeworkInfo.courseHomework.replaceYn eq 'N'}">
	<c:set var="title"><spring:message code="필드:과제:보충과제"/></c:set>
</c:if>
<c:if test="${homeworkInfo.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC and homeworkInfo.courseHomework.replaceYn eq 'Y' and CD_MIDDLE_FINAL_TYPE_MIDDLE eq homeworkInfo.courseHomework.middleFinalTypeCd}">
	<c:set var="title"><spring:message code="필드:과제:중간고사대체과제"/></c:set>
</c:if>
<c:if test="${homeworkInfo.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT and homeworkInfo.courseHomework.replaceYn eq 'Y' and CD_MIDDLE_FINAL_TYPE_MIDDLE eq homeworkInfo.courseHomework.middleFinalTypeCd}">
	<c:set var="title"><spring:message code="필드:과제:중간고사보충과제"/></c:set>
</c:if>
<c:if test="${homeworkInfo.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC and homeworkInfo.courseHomework.replaceYn eq 'Y' and CD_MIDDLE_FINAL_TYPE_FINAL eq homeworkInfo.courseHomework.middleFinalTypeCd}">
	<c:set var="title"><spring:message code="필드:과제:기말고사대체과제"/></c:set>
</c:if>
<c:if test="${homeworkInfo.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT and homeworkInfo.courseHomework.replaceYn eq 'Y' and CD_MIDDLE_FINAL_TYPE_FINAL eq homeworkInfo.courseHomework.middleFinalTypeCd}">
	<c:set var="title"><spring:message code="필드:과제:기말고사보충과제"/></c:set>
</c:if>

<title><c:out value="${title}"/></title>
<script type="text/javascript">

var forInsert = null;
var forUpdate = null;
var forDetail = null;
var swfu = null;

initPage = function() {
	
	doInitializeLocal();
	
	// uploader
	swfu = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/file/save.do"/>",
				fileTypes : "*.*",
				fileTypesDescription : "All Files",
				fileSizeLimit : "10MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				immediatelyUpload : true,
				successCallback : function(id, file) {}
			}
		}]
	);
  
	<c:if test="${empty answer}" >
		setTimeout("forCreateEditor()", 600);
	</c:if>
	
};

forCreateEditor = function(){
	UI.editor.create("description");
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
	forInsert = $.action("submit", {formId : "FormInsert"});
	forInsert.config.url             = "<c:url value="/usr/classroom/homework/insert/answer.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:과제응답:입력한내용으로과제를제출합니다진행하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.message.success = "<spring:message code="글:과제응답:제출되었습니다"/>"
	forInsert.config.fn.before       = doSetUploadInfo;
	forInsert.config.fn.complete     = doSubmitComplete;
	
	forUpdate = $.action("submit", {formId : "FormInsert"});
	forUpdate.config.url             = "<c:url value="/usr/classroom/homework/update/answer.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:과제응답:저장하시겠습니까"/>";
	forUpdate.config.message.success = "<spring:message code="글:과제응답:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before       = doSetUploadInfo;
	forUpdate.config.fn.complete     = doSubmitComplete;
	
	forHomeworkCompleteDetail = $.action();
	forHomeworkCompleteDetail.config.formId = "FormHomeworkCompleteDetail";
	forHomeworkCompleteDetail.config.url    = "<c:url value="/usr/classroom/homework/create/answer/popup.do"/>";
	
	setValidate();
	
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	
	forInsert.validator.set({
		title : "<spring:message code="필드:과제응답:제목"/>",
		name : "homeworkAnswerTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:과제응답:내용"/>",
		name : "description",
		data : ["!null"]
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:과제응답:제목"/>",
		name : "homeworkAnswerTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:과제응답:내용"/>",
		name : "description",
		data : ["!null"]
	});

};

/**
 * 파일정보 저장
 */
doSetUploadInfo = function() {
	
	if (swfu != null) {
		var form = UT.getById(forInsert.config.formId);
		form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
	}
	return true;
	
};

/**
 * 파일삭제
 */
doDeleteFile = function(element, seq) {
	
	var $element = jQuery(element);
	var $file = $element.closest("div");
	var $uploader = $element.closest(".uploader");
	var $attachDeleteInfo = $uploader.siblings(":input[name='attachDeleteInfo']");
	var seqs = $attachDeleteInfo.val() == "" ? [] : $attachDeleteInfo.val().split(","); 
	seqs.push(seq);
	$attachDeleteInfo.val(seqs.join(","));
	$file.remove();
	
};

/**
 * 생성 호출
 */
doInsert = function() { 
	
	UI.editor.copyValue();
	forInsert.run();
	
};

/**
 * 수정 호출
 */
doUpdate = function() { 
	
	UI.editor.copyValue();
	forUpdate.run();
	
};

/**
 * 저장 완료
 */
doSubmitComplete = function() { 
	forHomeworkCompleteDetail.run();
};

/**
 * 생성, 수정 분기
 */
doSubmit = function() { 
	
	var homeworkAnswerSeq = $("#FormInsert input[name=homeworkAnswerSeq]").val();
	
	if(doAutoSendDegree()){
		if(homeworkAnswerSeq != null && homeworkAnswerSeq != "" && homeworkAnswerSeq != "0"){
			doUpdate();
		}else{
			doInsert();
		}	
	}
	
};

/**
 * 차수 데이터 자동 처리
 */
doAutoSendDegree = function() {
	
	"<c:set var='dateformat' value='${aoffn:config(\"format.date\")}'/>";
	"<c:set var='today' value='${aoffn:today()}'/>";
	"<c:set var='appToday'><aof:date datetime='${today}' pattern='${aoffn:config(\"format.dbdatetime\")}'/></c:set>";

	var selectDate = "<c:out value="${appToday}"/>";
	var useYn = "<c:out value="${homeworkInfo.courseHomework.useYn}"/>";
	var dbStartDtime = "<c:out value="${detail.courseHomework.startDtime}"/>";
	var dbEndDtime = "<c:out value="${detail.courseHomework.endDtime}"/>";
	var dbStart2Dtime = "<c:out value="${homeworkInfo.courseHomework.start2Dtime}"/>";
	var dbEnd2Dtime = "<c:out value="${homeworkInfo.courseHomework.end2Dtime}"/>";
	
	if(useYn == "Y"){
		if(selectDate < dbStartDtime){
			$.alert({
				message : "<spring:message code="글:과제응답:제출기간이종료되었습니다"/>"
			});
			$("#sendDtime").val("");
			return false;
		}else if(selectDate >= dbStartDtime && selectDate <= dbEndDtime){
			$("#sendDegree").val("1");
			$("#sendDtime").val(selectDate);
			return true;
		}else if(selectDate > dbStart2Dtime && selectDate <= dbEnd2Dtime){
			$("#sendDegree").val("2");
			$("#sendDtime").val(selectDate);
			return true;
		}else{
			$.alert({
				message : "<spring:message code="글:과제응답:제출기간이종료되었습니다"/>"
			});
			$("#sendDtime").val("");
			return false;
		};
	}else{
		if(selectDate < dbStartDtime){
			$.alert({
				message : "<spring:message code="글:과제응답:제출기간이종료되었습니다"/>"
			});
			$("#sendDtime").val("");
			return false;
		}else if(selectDate >= dbStartDtime && selectDate <= dbEndDtime){
			$("#sendDegree").val("1");
			$("#sendDtime").val(selectDate);
			return true;
		}else{
			$.alert({
				message : "<spring:message code="글:과제응답:제출기간이종료되었습니다"/>"
			});
			$("#sendDtime").val("");
			return false;
		};
	};
	
};

var editorViewCheck = false;
/**
 * 수정하기
 */
doUpdateShow = function(){
	jQuery("#detail_tbl").hide();
	jQuery("#detail_lybox").hide();
	jQuery("#insert_tbl").show();
	jQuery("#insert_lybox").show();
	
	if(editorViewCheck == false){
		UI.editor.create("description");
		editorViewCheck = true;
	}
	parent.doNoscrollIframeClassroom();//상단 프레임 사이즈 조절
};

/**
 * 수정 취소하기
 */
doUpdateHide = function(){
	jQuery("#detail_tbl").show();
	jQuery("#detail_lybox").show();
	jQuery("#insert_tbl").hide();
	jQuery("#insert_lybox").hide();
	parent.doNoscrollIframeClassroom();
};

</script>
</head>

<body>	
	
	<!-- 과제 폼 -->
	<form name="FormHomeworkCompleteDetail" id="FormHomeworkCompleteDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${_CLASS_courseActiveSeq}"/>"/>
		<input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>">
		<input type="hidden" name="homeworkSeq" value="<c:out value="${param['homeworkSeq']}"/>"/>
		<input type="hidden" name="courseTypeCd" value="<c:out value="${_CLASS_courseTypeCd}"/>">
	</form>

	<div class="lybox-title">
	    <h4 class="section-title"><spring:message code="필드:과제응답:과제정보"/></h4>
	</div>
	
	<div class="vspace"></div>
	
	<table class="tbl-detail">
	<colgroup>
	    <col style="width: 140px" />
	    <col/>
	</colgroup>
	<tbody>
		<tr>
	         <th>
	             <spring:message code="필드:과제:온오프라인"/>
	         </th>
	         <td>
	             <aof:code name="onoffCd" type="print" codeGroup="ONOFF_TYPE" selected="${detail.courseHomework.onoffCd}" ></aof:code>
	         </td>
	     </tr>
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
	         	<aof:date datetime="${detail.courseHomework.startDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
	         	~
	         	<aof:date datetime="${detail.courseHomework.endDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
	         </td>
	    </tr>
	    <c:if test="${detail.courseHomework.useYn eq 'Y'}">
		    <tr>
		        <th>
		             <spring:message code="필드:과제:2차제출기간"/>
		        </th>
		        <td>
		        	<aof:date datetime="${detail.courseHomework.start2Dtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
		         	~
		         	<aof:date datetime="${detail.courseHomework.end2Dtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
		         	|
		         	<spring:message code="글:과제:1차대비배점"/> :
		         	<c:out value="${detail.courseHomework.rate2}"/> %
		    	</td>
			</tr>
		</c:if>
		<tr>
		    <th>
		         <spring:message code="필드:과제:성적공개여부"/>
		    </th>
		    <td>
	            <%/** TODO : 코드*/ %>
	            <aof:code type="print" codeGroup="OPEN_YN" name="openYn" defaultSelected="Y" removeCodePrefix="true" selected="${detail.courseHomework.openYn}"/>
	        </tr>
			</td>
	</tr>
	</tbody>
	</table>
	
	<form name="FormInsert" id="FormInsert" method="post" onsubmit="return false;">
		
		<input type="hidden" name="courseApplySeq" 		value="<c:out value="${homework.courseApplySeq}"/>"/>
		<input type="hidden" name="rate2" 				value="<c:out value="${homeworkInfo.courseHomework.rate2}"/>"/>
		<input type="hidden" name="middleFinalTypeCd" 	value="<c:out value="${homeworkInfo.courseHomework.middleFinalTypeCd}"/>"/>
		<input type="hidden" name="replaceYn" 			value="<c:out value="${homeworkInfo.courseHomework.replaceYn}"/>"/>
		<input type="hidden" name="basicSupplementCd" 	value="<c:out value="${homeworkInfo.courseHomework.basicSupplementCd}"/>"/>
		<input type="hidden" name="homeworkAnswerSeq" 	value="<c:out value="${answer.answer.homeworkAnswerSeq}"/>"/>
		<input type="hidden" name="homeworkSeq" 		value="<c:out value="${homeworkInfo.courseHomework.homeworkSeq}"/>"/>
		<input type="hidden" name="courseActiveSeq" 	value="<c:out value="${homeworkInfo.courseHomework.courseActiveSeq}"/>"/>
		<input type="hidden" name="openYn" 				value="<c:out value="${homeworkInfo.courseHomework.openYn}"/>"/>
		<input type="hidden" name="onoffCd" 			value="<c:out value="${homeworkInfo.courseHomework.onoffCd}"/>"/>
		<input type="hidden" name="activeElementSeq" 	value="<c:out value="${homeworkInfo.courseHomework.activeElementSeq}"/>"/>
		
		<div class="vspace"></div>
			
		<div class="lybox-title">
			<h4 class="section-title"><spring:message code="필드:과제응답:제출정보"/></h4>
		</div>
			
		<div class="vspace"></div>
		
		<c:if test="${!empty answer}" > 
			
			<table class="tbl-detail" id="detail_tbl">
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
				    <c:if test="${not empty answer.answer.unviAttachList}">
					    <tr>
					        <th><spring:message code="필드:과제응답:제출파일"/></th>
					        <td>
					        	<c:forEach var="row" items="${answer.answer.unviAttachList}" varStatus="i">
									<a href="javascript:void(0)" onclick="doAttachDownload('<c:out value="${row.attachSeq}"/>')"><c:out value="${row.realName}"/></a>
									[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
								</c:forEach>
					        </td>
					    </tr>
				    </c:if>  
				    <tr>
				        <th><spring:message code="필드:과제응답:제출일"/></th>
				        <td>
				        	<aof:date datetime="${answer.answer.sendDtime}" pattern="${aoffn:config('format.datetime')}"/>
				        </td>
				    </tr>
				    <c:if test="${detail.courseHomework.openYn eq 'Y'}">
				    	<c:if test="${empty answer.answer.scoreDtime}">
					    	<tr>
						        <th><spring:message code="필드:과제응답:점수"/></th>
						        <td>
						        	<spring:message code="필드:과제응답:채점중"/>
						        </td>
						    </tr>
				    	</c:if>
				    	<c:if test="${empty answer.answer.scoreDtime}">
					    	<tr>
						        <th><spring:message code="필드:과제응답:코멘트"/></th>
						        <td>
						        	<spring:message code="필드:과제응답:채점중"/>
						        </td>
						    </tr>
				    	</c:if>
					    <c:if test="${not empty answer.answer.scoreDtime}">
						    <tr>
						    	<tr>
							        <th><spring:message code="필드:과제응답:점수"/></th>
							        <td>
							        	<c:out value="${answer.answer.scaledScore}"/> <spring:message code="글:과제:점"/>
							        </td>
							    </tr>
							    <c:if test="${not empty answer.answer.comment and '' ne answer.answer.comment}">
							    	<tr>
								        <th><spring:message code="필드:과제응답:코멘트"/></th>
								        <td>
								        	<c:out value="${answer.answer.comment}"/>
								        </td>
								    </tr>
							    </c:if>
						        <th><spring:message code="필드:과제응답:채점일"/></th>
						        <td>
						        	<aof:date datetime="${answer.answer.scoreDtime}" pattern="${aoffn:config('format.datetime')}"/>
						        </td>
						    </tr>
					    </c:if>
				    </c:if>
				</tbody>
			</table>	 
		</c:if>
		
		<c:if test="${empty answer and detail.courseHomework.homeworkStatus eq '3'}" ><!-- 제출기간이 종료 되었는데 과제를 제출 하지 않은 경우 -->
			<table class="tbl-detail" id="detail_tbl">
				<tbody>
					<tr>
					   <td class="align-c">
					       <spring:message code="글:과제:과제물을제출하지않았습니다"/>
					   </td>  
				    </tr>
				</tbody>
			</table>
		</c:if>
		<c:if test="${empty answer and detail.courseHomework.homeworkStatus eq '2'}" ><!-- 제출기간 전인 경우 -->
			<table class="tbl-detail" id="detail_tbl">
				<tbody>
					<tr>
					   <td class="align-c">
					       <spring:message code="글:과제:제출기간이아닙니다"/>
					   </td>  
				    </tr>
				</tbody>
			</table>
		</c:if>
		
		<c:if test="${detail.courseHomework.homeworkStatus eq '1' and detail.courseHomework.onoffCd eq CD_ONOFF_TYPE_OFF}">
			<table class="tbl-detail" id="detail_tbl">
				<tbody>
					<tr>
					   <td class="align-c">
					       <spring:message code="글:과제:등록된과제제출정보가없습니다"/>
					   </td>  
				    </tr>
				</tbody>
			</table>
		</c:if>
		
		<c:if test="${detail.courseHomework.homeworkStatus eq '1' and detail.courseHomework.onoffCd eq CD_ONOFF_TYPE_ON}"><!-- 제출일시가 아니면 아예 출력하지 않는다. -->
			<table class="tbl-detail" id="insert_tbl" <c:if test="${!empty answer}" >style="display: none;"</c:if>>
		 		<colgroup>
		     		<col style="width: 140px" />
		     		<col style="width: auto" />
		 		</colgroup>
		 		<tbody>
		     		<tr>
			         	<th><spring:message code="필드:과제응답:제목"/></th>
			         	<td>
			            	<input type="text" name="homeworkAnswerTitle" style="width:350px;" value="<c:out value="${answer.answer.homeworkAnswerTitle}"/>">
			            	<input type="hidden" id="sendDtime" name="sendDtime" value="">
			            	<input type="hidden" id="sendDegree" name="sendDegree" value="">
			         	</td>
		     		</tr>
		     		<tr>
		         		<th><spring:message code="필드:과제응답:내용"/></th>
		         		<td>
		             		<textarea name="description" id="description" style="width:98%; height:220px"><c:out value="${answer.answer.description}"/></textarea>
		         		</td>
		     		</tr>
		     		<tr>
		         		<th><spring:message code="필드:과제응답:제출파일"/></th>
						<td>
							<c:if test="${empty answer.answer.unviAttachList}">
								<input type="hidden" name="attachUploadInfo"/>
				                <div id="uploader" class="uploader"></div>	 
		        			</c:if>
							<c:if test="${!empty answer.answer.unviAttachList}">
								<input type="hidden" name="attachUploadInfo"/>
								<input type="hidden" name="attachDeleteInfo">
								<div id="uploader" class="uploader">
									
									<c:forEach var="row" items="${answer.answer.unviAttachList}" varStatus="i">
										<div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>')" class="previousFile">
											<c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
										</div>
									</c:forEach>
							
								</div>
							</c:if>
						</td>
		     		</tr>
		    	</tbody>
			</table>
		</c:if>
		
		<div class="lybox-btn" id="detail_lybox" <c:if test="${empty answer}" >style="display: none;"</c:if>>
			<div class="lybox-btn-r">
				<c:if test="${detail.courseHomework.onoffCd eq CD_ONOFF_TYPE_ON}">
					<c:if test="${empty detail.answer.scoreDtime}">
						<c:if test="${detail.courseHomework.homeworkStatus eq '1' and not empty detail.answer.homeworkAnswerSeq}">
							<a href="#" onclick="javascript:doUpdateShow();" class="btn blue">
								<span class="mid"><spring:message code="버튼:과제응답:제출정보수정"/></span>
							</a>
						</c:if>		
					</c:if>
				</c:if>      
			</div>
		</div>
		<c:if test="${detail.courseHomework.homeworkStatus eq '1' and detail.courseHomework.onoffCd eq CD_ONOFF_TYPE_ON}"><!-- 제출일시가 아니면 아예 출력하지 않는다. -->
			<div class="lybox-btn" id="insert_lybox" <c:if test="${!empty answer}" >style="display: none;"</c:if>>
				<div class="lybox-btn-r">
					<a href="#" onclick="javascript:doSubmit();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
					<c:if test="${!empty answer}" ><a href="#" onclick="javascript:doUpdateHide();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a></c:if>
				</div>
			</div>
		</c:if>
		
	</form>
</body>
</html>
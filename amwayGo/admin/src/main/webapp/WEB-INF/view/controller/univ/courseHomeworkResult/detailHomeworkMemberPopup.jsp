<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS" value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_ONOFF_TYPE_ON"      value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>

<html>
<head>

<c:set var="selectDegree">1=<spring:message code="필드:과제:1차"/>,2=<spring:message code="필드:과제:2차"/></c:set>

<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<title></title>
<script type="text/javascript">

var forUpdate = null;
var swfu = null;

var useYn = '${answer.courseHomework.useYn}';
var startDtime = '<aof:date datetime="${answer.courseHomework.startDtime}" pattern="${aoffn:config('format.date')}"/>';
var endDtime = '<aof:date datetime="${answer.courseHomework.endDtime}" pattern="${aoffn:config('format.date')}"/>';
var start2Dtime = '<aof:date datetime="${answer.courseHomework.start2Dtime}" pattern="${aoffn:config('format.date')}"/>';
var end2Dtime = '<aof:date datetime="${answer.courseHomework.end2Dtime}" pattern="${aoffn:config('format.date')}"/>';

initPage = function() {

	doInitializeLocal();
	if(useYn == "Y"){
        UI.datepicker(".datepicker",{ 
            showOn: "both", 
            buttonImage: '<aof:img type='print' src='common/calendar.gif'/>', 
            minDate : startDtime,
            maxDate : end2Dtime
            });     
    }else{
        UI.datepicker(".datepicker",{ 
            showOn: "both", 
            buttonImage: '<aof:img type='print' src='common/calendar.gif'/>', 
            minDate : startDtime,
            maxDate : endDtime
            }); 
    }
	
	<c:if test="${answer.courseHomework.onoffCd eq CD_ONOFF_TYPE_ON}">
	UI.editor.create("description");
	</c:if>
	
	UI.editor.create("comment");
	
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
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
	forUpdate = $.action("submit", {formId : "FormInsert"});
	forUpdate.config.url             = "<c:url value="/univ/course/homework/member/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:과제응답:저장하시겠습니까"/>";
	forUpdate.config.message.success = "<spring:message code="글:과제응답:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before       = doSetUploadInfo;
	forUpdate.config.fn.complete     = doSubmitSuccess;
	
	setValidate();
	
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	
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
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:과제응답:제출일"/>",
		name : "sendDtime",
		data : ["!null"]
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:과제응답:점수"/>",
		name : "homeworkScore",
        data : ["!null","decimalnumber"],
        check : {
        	le : 100,
        	gt : -1
        }
	});
	
};

/**
 * 파일정보 저장
 */
doSetUploadInfo = function() {
	
	if (swfu != null) {
		var form = UT.getById(forUpdate.config.formId);
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
 * 수정 호출
 */
doUpdate = function() { 
	
	UI.editor.copyValue();
	forUpdate.run();
	
};

/**
 * 저장 완료
 */
doSubmitSuccess = function() { 
	
	$layer.dialog("option").parent.doList();
	$layer.dialog("close");
	
};

/**
 * 차수 데이터 자동 처리
 */
doAutoSendDegree = function() {
	
	if($("#sendDay").val() != ""){
		
		var selectDate = $("#sendDay").val().replace(/-/gi, "") + $("#sendHour").val() + $("#sendMin").val();
		
		//1차 시작시간 셋팅
		var dbStartDtime = "${answer.courseHomework.startDtime}";
		var dbStartDate = "<aof:date datetime="${answer.courseHomework.startDtime}" pattern="${aoffn:config('format.date')}"/>";
		var dbStartHour = "${fn:substring(answer.courseHomework.startDtime, 8, 10)}";
		var dbStartMin = "${fn:substring(answer.courseHomework.startDtime, 10, 12)}";
		
		//1차 종료시간 셋팅
		var dbEndDtime = "${answer.courseHomework.endDtime}";
		var dbEndDate = "<aof:date datetime="${answer.courseHomework.endDtime}" pattern="${aoffn:config('format.date')}"/>";
		var dbEndHour = "${fn:substring(answer.courseHomework.endDtime, 8, 10)}";
		var dbEndMin = "${fn:substring(answer.courseHomework.endDtime, 10, 12)}";
		
		//2차 시작시간 셋팅
		var dbStart2Dtime = "${answer.courseHomework.start2Dtime}";
		
		var dbEnd2Dtime = "${answer.courseHomework.end2Dtime}";
		var dbEnd2Date = "<aof:date datetime="${answer.courseHomework.end2Dtime}" pattern="${aoffn:config('format.date')}"/>";
		var dbEnd2Hour = "${fn:substring(answer.courseHomework.end2Dtime, 8, 10)}";
		var dbEnd2Min = "${fn:substring(answer.courseHomework.end2Dtime, 10, 12)}";
		
		var sec = $("#sendSec").val().length == 2 ? $("#sendSec").val() : "00";
		
		if(useYn == "Y"){
			if(selectDate < dbStartDtime){
				$.alert({
					message : "<spring:message code="글:과제:제출일은제출기간보다작을수없습니다"/>"
				});
				
				$("#degree").val("1");
				$("#sendDtime").val(dbStartDate);
				$("#sendHour").val(dbStartHour);
				$("#sendMin").val(dbStartMin);
				return;
			}else if(selectDate >= dbStartDtime && selectDate <= dbEndDtime){
				$("#degreeView").empty();
				$("#degreeView").append("<spring:message code="필드:과제:1차"/>");
				$("#degree").val("1");
				$("#sendDtime").val(selectDate + sec);
			}else if(selectDate > dbStart2Dtime && selectDate <= dbEnd2Dtime){
				$("#degreeView").empty();
				$("#degreeView").append("<spring:message code="필드:과제:2차"/>");
				$("#degree").val("2");
				$("#sendDtime").val(selectDate + sec);
			}else{
				$.alert({
					message : "<spring:message code="글:과제:제출일은제출기간보다클수없습니다"/>"
				});
				
				$("#degree").val("2");
				$("#sendDtime").val(dbEnd2Date);
				$("#sendHour").val(dbEnd2Hour);
				$("#sendMin").val(dbEnd2Min);
				return;
			};
		}else{
			if(selectDate < dbStartDtime){
				$.alert({
					message : "<spring:message code="글:과제:제출일은제출기간보다작을수없습니다"/>"
				});
				
				$("#degree").val("1");
				$("#sendDtime").val(dbStartDate);
				$("#sendHour").val(dbStartHour);
				$("#sendMin").val(dbStartMin);
				return;
			}else if(selectDate >= dbStartDtime && selectDate <= dbEndDtime){
				$("#degreeView").empty();
				$("#degreeView").append("<spring:message code="필드:과제:1차"/>");
				$("#degree").val("1");
				$("#sendDtime").val(selectDate + sec);
			}else{
				$.alert({
					message : "<spring:message code="글:과제:제출일은제출기간보다클수없습니다"/>"
				});
				
				$("#degree").val("1");
				$("#sendDtime").val(dbEndDate);
				$("#sendHour").val(dbEndHour);
				$("#sendMin").val(dbEndMin);
				return;
			};
		};
	};
	
};

/**
 * 시간 셀렉트 박스 생성
 */
doCreateTimeBox = function(hour, min) {
	
	var hourString = "";
	var minString = "";
	var plusStrng = "";
	
	for(var i = 0; i <= 23; i++){
		if(i < 10){
			plusStrng = "0";
		}else{
			plusStrng = "";
		}
		
		if(hour == (plusStrng + "" + i)){
			hourString += ("<option value=" + plusStrng + "" + i + " selected='selected' >" + plusStrng + "" + i + "</option>");	
		}else{
			hourString += ("<option value=" + plusStrng + "" + i + ">" + plusStrng + "" + i + "</option>");				
		};
	};
	
	for(var i = 0; i <= 59; i++){
		if(i < 10){
			plusStrng = "0";
		}else{
			plusStrng = "";
		}
		
		if(min == (plusStrng + "" + i)){
			minString += ("<option value=" + plusStrng + "" + i + " selected='selected' >" + plusStrng + "" + i + "</option>");	
		}else{
			minString += ("<option value=" + plusStrng + "" + i + ">" + plusStrng + "" + i + "</option>");				
		};
	};
	
	$("#sendHour").append(hourString);
	$("#sendMin").append(minString);
	
};


</script>
</head>

<body>	
	<form name="FormInsert" id="FormInsert" method="post" onsubmit="return false;">
		
		<input type="hidden" name="homeworkAnswerSeq" 	value="<c:out value="${answer.answer.homeworkAnswerSeq}"/>"/>
		<input type="hidden" name="homeworkSeq" 		value="<c:out value="${answer.courseHomework.homeworkSeq}"/>"/>
		<input type="hidden" name="courseActiveSeq" 	value="<c:out value="${answer.courseHomework.courseActiveSeq}"/>"/>
		<input type="hidden" name="rate2" 				value="<c:out value="${answer.courseHomework.rate2}"/>"/>
		<input type="hidden" name="middleFinalTypeCd" 	value="<c:out value="${answer.courseHomework.middleFinalTypeCd}"/>"/>
		<input type="hidden" name="replaceYn" 			value="<c:out value="${answer.courseHomework.replaceYn}"/>"/>
		<input type="hidden" name="basicSupplementCd" 	value="<c:out value="${answer.courseHomework.basicSupplementCd}"/>"/>
    	<input type="hidden" name="courseApplySeq" 		value="<c:out value="${answer.apply.courseApplySeq}"/>"/>
		<input type="hidden" name="openYn" 				value="<c:out value="${answer.courseHomework.openYn}"/>"/>
		<input type="hidden" name="activeElementSeq" 	value="<c:out value="${answer.courseHomework.activeElementSeq}"/>"/>
		<input type="hidden" name="profCommentMemberSeq"value="<c:out value="${appCourseActiveLecturer.profMemberSeq}"/>"/>
		
		<h3 class="content-title"><spring:message code="필드:과제응답:제출정보"/></h3>

		<table class="tbl-detail">
	 		<colgroup>
	     		<col style="width: 20%" />
	     		<col style="width: 30%" />
	     		<col style="width: 20%" />
	     		<col style="width: 30%" />	     		
	 		</colgroup>
	 		<tbody>
	 			<tr>
		         	<th><spring:message code="필드:과제:이름"/></th>
		         	<td>
		            	<c:out value="${answer.member.memberName}"/>
		         	</td>
		         	<th><spring:message code="필드:과제:아이디"/></th>
		         	<td>
		            	<c:out value="${answer.member.memberId}"/>
		         	</td>		         	
	     		</tr>
	     		<c:if test="${answer.courseHomework.onoffCd eq CD_ONOFF_TYPE_ON}">
		     		<tr>
			         	<th><spring:message code="필드:과제응답:제목"/> <span class="star">*</span></th>
			         	<td colspan="3">
			            	<input type="text" name="homeworkAnswerTitle" style="width:350px;" value="<c:out value="${answer.answer.homeworkAnswerTitle}"/>">
			         	</td>
		     		</tr>
		     		<tr>
		         		<th><spring:message code="필드:과제응답:내용"/> <span class="star">*</span></th>
		         		<td colspan="3">
		             		<textarea name="description" id="description" style="width:98%; height:100px"><c:out value="${answer.answer.description}"/></textarea>
		         		</td>
		     		</tr>
	     		</c:if>
	     		<tr>
	         		<th><spring:message code="필드:과제:첨부파일"/></th>
					<td colspan="3">
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
	 			<tr>
	 				<th><spring:message code="필드:과제응답:제출일"/> <span class="star">*</span></th>
		         	<td <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">colspan="3"</c:if>>
		            	<input type="text" class="datepicker" id="sendDay" readonly="readonly" style="width: 70px;" 
		            	value="<aof:date datetime="${answer.answer.sendDtime}" 
		            	pattern="${aoffn:config('format.date')}"/>" 
		            	onchange="javascript:doAutoSendDegree();" />

		            	<select id="sendHour" onchange="javascript:doAutoSendDegree();"></select>시
		            	<select id="sendMin" onchange="javascript:doAutoSendDegree();"></select>분
		            	<input type="hidden" id="sendSec" value="<c:out value="${fn:substring(answer.answer.sendDtime, 12, 14)}"/>">
		            	
		            	<script>doCreateTimeBox('${fn:substring(answer.answer.sendDtime, 8, 10)}', '${fn:substring(answer.answer.sendDtime, 10, 12)}');</script>
		                
		                <input type="hidden" name="sendDtime" id="sendDtime" value="<c:out value="${answer.answer.sendDtime}"/>">
		         	</td>	
		         	<th <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">style="display: none;"</c:if>><spring:message code="필드:과제응답:제출차수"/></th>
		         	<td <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">style="display: none;"</c:if>>
			         	<c:choose>
							<c:when test="${!empty answer.answer.sendDtime}">
								<span id="degreeView"><c:out value="${answer.answer.sendDegree}"/><spring:message code="필드:과제응답:차"/></span>
								<input type="hidden" id="degree" name="sendDegree" value="${answer.answer.sendDegree}">
							</c:when>
							<c:otherwise>
								<span id="degreeView">-</span>
								<input type="hidden" id="degree" name="sendDegree" value="">
							</c:otherwise>
						</c:choose>
		         	</td>
	     		</tr>
	 			<tr>
		         	<th><spring:message code="필드:과제응답:점수"/> <span class="star">*</span></th>
		         	<td>
		            	<input type="text" name="homeworkScore" size="6" class="align-r" value="${answer.answer.homeworkScore}" />
		         	</td>
		         	<th><spring:message code="필드:과제응답:채점일"/></th>
		         	<td>
			         	<c:choose>
							<c:when test="${!empty answer.answer.scoreDtime}">
								<aof:date datetime="${answer.answer.scoreDtime}" pattern="${aoffn:config('format.datetime')}"/>
							</c:when>
							<c:otherwise>
								<span>-</span>
							</c:otherwise>
						</c:choose>
		         	</td>
	     		</tr>
	     		<tr>
	         		<th><spring:message code="필드:과제응답:코멘트"/></th>
	         		<td colspan="3">
	             		<textarea name="comment" id="comment" style="width:98%; height:100px"><c:out value="${answer.answer.comment}"/></textarea>
	         		</td>
	     		</tr>	     			     			     		
	    	</tbody>
		</table>
		
		<div class="lybox-btn">
			<div class="lybox-btn-r">
				<a href="#" onclick="javascript:doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
				<a href="#" onclick="javascript:$layer.dialog('close');" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
			</div>
		</div>
		
	</form>
</body>
</html>
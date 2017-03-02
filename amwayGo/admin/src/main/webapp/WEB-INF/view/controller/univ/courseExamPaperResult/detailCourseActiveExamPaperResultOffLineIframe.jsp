<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"      value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT" value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata 		= null;
var forDetail			= null;
var forUpdateList		= null;
var forExamResultPopup 	= null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2] upload
	swfu = UI.uploader.create(function() {
		forUpdateList.run("continue");
	});
	
	doUpload();
	
	// [3] comment  
	UI.inputComment("FormSubList");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/course/active/${examType}/exampaper/result/list/iframe.do"/>";

    forDetail = $.action();
    forDetail.config.formId = "FormSubList";
    forDetail.config.url    = "<c:url value="/univ/course/active/${examType}/exampaper/result/detail/iframe.do"/>";
    
    forUpdateList = $.action("submit", {formId : "FormSubList"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdateList.config.url             = "<c:url value="/univ/course/exam/offline/answer/updatelist.do"/>";
    forUpdateList.config.target          = "hiddenframe";
    forUpdateList.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forUpdateList.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdateList.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateList.config.fn.before       = doStartUpload;
    forUpdateList.config.fn.complete     = function() {
		doDetail();
	};
	
	forExamResultPopup = $.action("layer");
    forExamResultPopup.config.formId         = "FormExamPaper";
    forExamResultPopup.config.url            = "<c:url value="/univ/course/active/exam/offline/result/detail/popup.do"/>";
    forExamResultPopup.config.options.width  = 750;
    forExamResultPopup.config.options.height = 300;
    forExamResultPopup.config.options.title = "<spring:message code="필드:시험:시험"/>";
    
    setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdateList.validator.set({
		title : "<spring:message code="필드:시험:점수"/>",
		name : "takeScores",
		data : ["number"],
		check : {
            maxlength : 3
        }
	});
	forUpdateList.validator.set({
		title : "<spring:message code="필드:시험:점수"/>",
		name : "takeScores",
		data : ["number"],
		check : {
            le : 100
        }
	});
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
	var form = UT.getById(forDetail.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doDetail();
};
/**
 * 상세보기
 */
doDetail = function(rows) {
	var form = UT.getById(forDetail.config.formId);
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forDetail.run();
};
/**
 * 파일업로드
 */
doUpload = function() {
	jQuery("#tabContainer").find(".uploader").each(function(){
		var $uploader = jQuery(this);
		var upload = [];
		upload.push({
			elementId : $uploader.attr("id"),
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/file/save.do"/>",
				fileTypes : "*.*",
				fileTypesDescription : "All Files",
				fileSizeLimit : "10 MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputWidth : 260,	
				immediatelyUpload : false,
				successCallback : function(id, file) {
					jQuery("#"+id).closest("td").find("#attachUploadInfos").val(UI.uploader.getUploadedData(swfu, id));
				}
			}
		});
		
		swfu = UI.uploader.generate(swfu, upload);	
	});
};
/**
 * 파일업로드 시작
 */
doStartUpload = function() {
	var isAppendedFiles = false;
	var count = jQuery("#listMember").find(".uploader").length;
	var isAppendedFiles = false;
	for (var i = 0; i <= count; i++) {
		if (UI.uploader.isAppendedFiles(swfu, "uploader-" + i) == true) {
			isAppendedFiles = true;
			break;
		}
	}
	if (isAppendedFiles == true) {
		UI.uploader.runUpload(swfu);
		return false;
	} else {
		return true;
	}
};
/**
 * 파일삭제
 */
doDeleteFile = function(element, seq) {
	var $element = jQuery(element);
	var $file = $element.closest("div");
	var $uploader = $element.closest(".uploader");
	var $attachDeleteInfo = $uploader.siblings(":input[name='attachDeleteInfos']");
	var seqs = $attachDeleteInfo.val() == "" ? [] : $attachDeleteInfo.val().split(","); 
	seqs.push(seq);
	$attachDeleteInfo.val(seqs.join(","));
	$file.remove();
};
/** 배점 비율 변경이 한번이라도 일어나면 저장 옆에 경고 문구 띄운다.*/
changeShow = function() {
	jQuery("#warning").show();
	var changeCount = jQuery("#changeCount").val();
	jQuery("#changeCount").val(Number(changeCount) + 1);
};
/**
 * 점수 저장 함수
 */
doUpdateList = function() {
		forUpdateList.run();
		// 현재 저장 시점이 정해지지 않음 아래 프로세스 변경으로 저장시점 변경가능
// 	var changeCount = jQuery("#changeCount").val();
// 	if (changeCount > 0) {
// 	} else {
// 		$.alert({
// 			message : "<spring:message code="글:시험:변경내용이없습니다"/>"
// 		});
// 	}
};
/**
 * 채점하기 팝업
 */
doExamResultPopup = function(mapPKs) {
	// 상세화면 form을 reset한다.
    UT.getById(forExamResultPopup.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forExamResultPopup.config.formId);
    // 팝업 실행
	forExamResultPopup.run();
}; 
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>
<c:import url="srchCourseActiveExamPaperResult.jsp" />

<div class="vspace"></div>

<div id="tabContainer">
	<table class="tbl-detail mt10">
		<colgroup>
		<col style="width: 150px" />
		<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:시험:온오프라인"/></th>
				<td>
		            <aof:code name="onOffCd" type="print" codeGroup="ONOFF_TYPE" selected="${detail.courseActiveExamPaper.onOffCd}" />
		        </td>
			</tr>
			<tr>
				<th><spring:message code="필드:시험:시험제목"/></th>
				<td>
					<c:out value="${detail.courseExamPaper.examPaperTitle}"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:시험:시험기간"/></th>
				<td>
		         	<aof:date datetime="${detail.courseActiveExamPaper.startDtime}" />&nbsp;
				    <aof:date datetime="${detail.courseActiveExamPaper.startDtime}" pattern="HH:mm:ss"/>
	                <spring:message code="글:시험:부터" /> ~
	                <aof:date datetime="${detail.courseActiveExamPaper.endDtime}" />&nbsp;
				    <aof:date datetime="${detail.courseActiveExamPaper.endDtime}" pattern="HH:mm:ss"/>
				    <spring:message code="글:시험:까지" />
		         </td>
			</tr>
			<tr>
				<th><spring:message code="필드:시험:시험시간"/></th>
				<td>
					<c:out value="${detail.courseActiveExamPaper.examTime}" />&nbsp;<spring:message code="글:분" />
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:시험:성적공개여부"/></th>
				<td>
					<aof:code type="print" codeGroup="OPEN_YN" name="openYn" selected="${detail.courseActiveExamPaper.openYn}" removeCodePrefix="true"/>
				</td>
			</tr>
			<tr>
				<th>
					<spring:message code="필드:시험:응시" />(<spring:message code="필드:시험:채점" />)|<spring:message code="필드:시험:미응시" />|<spring:message code="필드:시험:대상자" />
				</th>
				<td>
					<c:choose>
	            		<c:when test="${detail.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
	            			<c:out value="${detail.courseActiveExamPaper.answerCount}" />
	            			(<c:out value="${detail.courseActiveExamPaper.scoredCount}" />)&nbsp;&nbsp;|&nbsp;&nbsp;
	            			<c:out value="${detail.courseActiveSummary.memberCount - detail.courseActiveExamPaper.answerCount}"/>&nbsp;&nbsp;|&nbsp;&nbsp;
	            			<c:out value="${detail.courseActiveSummary.memberCount}" />
	            		</c:when>
	            		<c:otherwise>
	            			<c:out value="${detail.courseActiveExamPaper.answerCount}" />
	            			(<c:out value="${detail.courseActiveExamPaper.scoredCount}" />)&nbsp;&nbsp;|&nbsp;&nbsp;
	            			<c:out value="${detail.courseActiveExamPaper.targetCount - detail.courseActiveExamPaper.answerCount}"/>&nbsp;&nbsp;|&nbsp;&nbsp;
	            			<c:out value="${detail.courseActiveExamPaper.targetCount}"/>
	            		</c:otherwise>
	            	</c:choose>
				</td>
			</tr>
			<c:if test="${detail.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
				<tr>
					<th><spring:message code="필드:시험:배점비율" /></th>
					<td>
						<c:out value="${detail.courseActiveExamPaper.rate}" />%
					</td>
				</tr>
			</c:if>
			<tr>
				<th><spring:message code="필드:시험:상태" /></th>
				<td>
					<c:choose>
	            		<c:when test="${appToday ge detail.courseActiveExamPaper.startDtime and appToday le detail.courseActiveExamPaper.endDtime}">
	            			<spring:message code="글:시험:진행중" />
	            		</c:when>
	            		<c:when test="${appToday gt detail.courseActiveExamPaper.endDtime}">
	            			<spring:message code="글:시험:종료" />
	            		</c:when>
	            		<c:when test="${appToday lt detail.courseActiveExamPaper.startDtime}">
	            			<spring:message code="글:시험:진행전" />
	            		</c:when>
	            	</c:choose>
				</td>
			</tr>
		</tbody>
	</table>
	
	<div class="lybox-btn">
        <div class="lybox-btn-r">
            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
        </div>
    </div>

<c:set var="srchKey">memberName=<spring:message code="필드:시험:이름"/>,memberId=<spring:message code="필드:시험:아이디"/></c:set>

	<form name="FormSubList" id="FormSubList" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="courseActiveExamPaperSeq"     value="<c:out value="${detail.courseActiveExamPaper.courseActiveExamPaperSeq}"/>" />
				<input type="hidden" name="courseActiveSeq"     value="<c:out value="${detail.courseActiveExamPaper.courseActiveSeq}"/>" />
				<input type="hidden" name="activeElementSeq"     value="<c:out value="${detail.courseActiveExamPaper.activeElementSeq}"/>" />
			
				<input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
			    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
			    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
			    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
			    
			    <input type="hidden" id="changeCount" name="changeCount" value="0"/>
				
				<span>
					<input type="text" name="srchCategoryName" value="${condition.srchCategoryName }" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doDetail);" />
					<span class="comment"><spring:message code="글:멤버:교과목분류"/></span>
				</span>
				
				<div class="vspace"></div>
				
				<select name="srchKey">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doDetail);"/>
				<a href="#" onclick="doDetail()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			</fieldset>
		</div>
		
		<c:import url="/WEB-INF/view/include/perpage.jsp">
			<c:param name="onchange" value="doDetail"/>
			<c:param name="selected" value="${condition.perPage}"/>
		</c:import>
		
		<div id="listMember">
			<table id="listTable" class="tbl-list mt20">
				<colgroup>
					<col style="width: 40px" />
					<col style="width: 40px" />
					<col style="width: 80px" />
					<col style="width: 100px" />
					<col style="width: 100px" />
					<col style="width: 250px" />
					<col style="width: 100px" />
					<col style="width: 100px" />
					<col style="width: 80px" />
				</colgroup>
				<thead>
					<tr>
						<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormSubList','checkkeys','checkButton','');" /></th>
						<th><spring:message code="필드:번호"/></th>
						<th><spring:message code="필드:시험:이름"/></th>
						<th><spring:message code="필드:시험:아이디"/></th>
						<th><spring:message code="필드:시험:학과"/></th>
						<th><spring:message code="필드:시험:참조파일"/></th>
						<th><spring:message code="필드:시험:점수입력"/></th>
						<th><spring:message code="필드:시험:채점일"/></th>
						<th><spring:message code="필드:시험:상세"/></th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
					<tr>
						<td>
							<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', '')">
							<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
							<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
							<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
							<input type="hidden" name="courseApplySeqs" value="<c:out value="${row.courseApplyElement.courseApplySeq}" />">
							<input type="hidden" name="basicSupplementCd" value="<c:out value="${detail.courseActiveExamPaper.basicSupplementCd}" />">
							<input type="hidden" name="scoreYns"  	 value="${empty row.courseActiveExamPaperTarget.scoreYn ? 'W' : row.courseActiveExamPaperTarget.scoreYn}">
							<input type="hidden" name="activeExamPaperTargetSeqs"  	 value="${row.courseActiveExamPaperTarget.activeExamPaperTargetSeq}">
						</td>
						<td>
							<c:out value="${paginate.descIndex - i.index}"/>
						</td>
						<td><c:out value="${row.member.memberName}"/></td>
						<td><c:out value="${row.member.memberId}"/></td>
						<td><c:out value="${row.category.categoryName}"/></td>
						<td>
							<input type="hidden" name="attachUploadInfos" id="attachUploadInfos" />
							<input type="hidden" name="attachDeleteInfos" id="attachDeleteInfos" />
							<div id="uploader-<c:out value="${i.count}"/>" class="uploader" style="float: left;">
								<c:if test="${!empty row.courseActiveExamPaperTarget.attachList}">
									<c:forEach var="rowSub" items="${row.courseActiveExamPaperTarget.attachList}" varStatus="j">
										<div onclick="doDeleteFile(this, '<c:out value="${rowSub.attachSeq}"/>')" class="previousFile">
											<c:out value="${rowSub.realName}"/>[<c:out value="${aoffn:getFilesize(rowSub.fileSize)}"/>]
										</div>
									</c:forEach>
								</c:if>
							</div>
							<div style="float: left; padding-left: 10px;">
								<c:if test="${!empty row.courseActiveExamPaperTarget.attachList}">
									<c:forEach var="rowSub" items="${row.courseActiveExamPaperTarget.attachList}" varStatus="j">
										<div class="vspace"></div>
										<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(rowSub.attachSeq, pageContext.request)}"/>')"><aof:img src="icon/ico_file.gif"/></a>
									</c:forEach>
								</c:if>
							</div>
						</td>
						<td>
							<input type="text" name="takeScores" style="width: 60px; text-align: right;" onchange="changeShow();" value="<aof:number value="${row.courseApplyElement.takeScore}" pattern="##" />">&nbsp;<spring:message code="글:시험:점"/>
						</td>
						<c:choose>
							<c:when test="${!empty row.courseApplyElement.scoreDtime}">
								<td>
									<aof:date datetime="${row.courseApplyElement.scoreDtime}" />
								</td>
								<td>
									<a href="#" onclick="doExamResultPopup({'courseApplySeq' : '<c:out value="${row.courseApplyElement.courseApplySeq}"/>', 'activeElementSeq' : '<c:out value="${row.courseApplyElement.activeElementSeq}"/>'});" class="btn black"><span class="small"><spring:message code="버튼:시험:보기"/></span></a>
								</td>
							</c:when>
							<c:otherwise>
								<td>
									<spring:message code="필드:시험:미응시"/>
								</td>	
								<td>
									<spring:message code="필드:시험:미응시"/>
								</td>	
							</c:otherwise>
						</c:choose>
					</tr>
				</c:forEach>
				<c:if test="${empty paginate.itemList}">
					<tr>
						<td colspan="9" align="center"><spring:message code="글:데이터가없습니다" /></td>
					</tr>
				</c:if>
				</tbody>
			</table>
		</div>
	</form>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<div style="overflow: hidden;">
				 <div style="float: right">
					<c:if test="${!empty paginate.itemList}">
			    		<span id="warning" style="display: none; color: red;"><spring:message code="글:과제:저장되지않은데이터가존재합니다" /></span>
			    		<a href="javascript:void(0)" onclick="doUpdateList()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
		      		</c:if>
				 </div>
				 <div id="checkButton" style="float: right; display: none; padding-right: 4px;">
					<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
						<%--				
							<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormSubList','doDetail')" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
							<a href="javascript:void(0)" onclick="FN.doCreateSms('FormSubList','doDetail')" class="btn blue"><span class="mid"><spring:message code="버튼:SMS" /></span></a>
							<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormSubList','doDetail')" class="btn blue"><span class="mid"><spring:message code="버튼:이메일" /></span></a>
							 --%>
					</c:if>
				 </div>
				 <div style="clear: both;"></div>
			</div>
		</div>
	</div>
	
	<form name="FormExamPaper" id="FormExamPaper" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveExamPaperSeq" value="<c:out value="${detail.courseActiveExamPaper.courseActiveExamPaperSeq}"/>" />
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.courseActiveExamPaper.courseActiveSeq}"/>" />
		<input type="hidden" name="activeElementSeq" />
		<input type="hidden" name="courseApplySeq" />
		<input type="hidden" name="callback" value="doDetail" />
	</form>
	
</div>
</body>
</html>
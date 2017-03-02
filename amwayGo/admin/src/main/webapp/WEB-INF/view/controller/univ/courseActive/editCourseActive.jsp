<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD"      value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_COURSE_TYPE_ALWAYS"      value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE"    value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_CATEGORY_TYPE_NONDEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.NONDEGREE')}"/>

<c:set var="categoryUrlPath" value="/non"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata    = null;
var forPopdata    = null;
var forPopinset = null;
var swfuAppendix                = null;
var swfu = null;
var imageContext = "<c:out value="${aoffn:config('upload.context.image')}"/>";
var imageBlank = "<aof:img type="print" src="bg/bg_white.png"/>";
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    UI.editor.create("introduction");
    
   // UI.editor.create("goal");
    
	UI.datepicker("#studyStartDate,#studyEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
    
    UI.datepicker("#applyStartDate,#applyEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
    
    UI.datepicker("#cancelStartDate,#cancelEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
    
    UI.datepicker("#openStartDate,#openEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
    
    UI.datepicker("#studyEndDate,#resumeEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
 
    
  //uploader 별첨
/* 	swfuAppendix = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader-0",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/file/save.do"/>",
				//fileTypes : "*.*",
				fileTypes : "*.jpg;*.gif;*.jpeg;*.png;",
				fileTypesDescription : "All Files",
				fileSizeLimit : "10MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				immediatelyUpload : true,
				successCallback : function(id, file) {
					doSuccessCallback(id, file);
				}
			}
		}]
	); */
    
  // 시간표
/*     swfu = UI.uploader.create(function() { // completeCallback
		forUpdate.run("continue");
	}); */
    
    //setUploadGenrate();
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/courseactive${categoryUrlPath}/list.do"/>";
    
    forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdate.config.url             = "<c:url value="/univ/courseactive/update.do"/>";
    forUpdate.config.target          = "hiddenframe";
    forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    //forUpdate.config.fn.before       = doStartUpload;
    forUpdate.config.fn.complete     = function() {
        doList();
    };
    
    forPopdata = $.action("layer");
    forPopdata.config.formId = "FormBrowsePopup";
	forPopdata.config.url = "<c:url value="/agreement/popup.do"/>";
	forPopdata.config.options.width = 700;
	forPopdata.config.options.height = 400;
	
    forPopinset = $.action("layer");
    forPopinset.config.formId = "FormBrowsePopup";
    forPopinset.config.url = "<c:url value="/course/agreement/list/popup.do"/>";
    forPopinset.config.options.width = 700;
    forPopinset.config.options.height = 400;

	swfu = UI.uploader.create(function() {}, // completeCallback
			[{
				elementId : "uploader",
				postParams : {
					thumbnailWidth : 120,
					thumbnailHeight : 120,
					thumbnailCrop : "Y"
				},
				options : {
					uploadUrl : "<c:url value="/attach/image/save.do"/>",
					buttonImageUrl : '<aof:img type="print" src="btn/photo_22x22.png"/>',
					buttonWidth: 23,
					inputWidth : 0,	
    				fileTypes : "*.jpg;*.gif;*.jpeg;*.png;",
					fileTypesDescription : "Image Files",
					fileSizeLimit : "10 MB",
					immediatelyUpload : true,
					successCallback : function(id, file) {
						if (id == "uploader") {
							var form = UT.getById(forUpdate.config.formId);
							var fileInfo = file.serverData.fileInfo;
							form.elements["thumNail"].value = fileInfo.savePath + "/" + fileInfo.saveName;
							
							var $photo = jQuery("#member-photo");
							$photo.attr("src", imageContext + form.elements["thumNail"].value);
							$photo.siblings(".delete").show();
						}
					}
				}
			}]
		);		
	
	
    setValidate();
};

/*
 * 시간표 uploader
 */
/* setUploadGenrate = function(){
	var upload = [];
    var $uploader = $(".uploader");
    
    for (var i = 1; i < $uploader.length; i++) {
    	 upload.push({
    			elementId : $uploader.eq(i).attr("id"),
    			postParams : {
    				thumbnailWidth : 200,
    				thumbnailHeight : 200,
    				thumbnailCrop : "Y"
    			},
    			options : {
    				uploadUrl : "<c:url value="/attach/image/save.do"/>",
    				fileTypes : "*.jpg;*.gif;*.jpeg;*.png;",
    				fileTypesDescription : "Image Files",
    				fileSizeLimit : "10 MB",
    				fileUploadLimit : 0, // default : 1, 0이면 제한없음.
    				inputHeight : 22, // default : 22
    				immediatelyUpload : false,
    				successCallback : function(id, file) {
    					doSuccessCallback(id, file);
    				}
    			}
    		});
	}
   
    swfu = UI.uploader.generate(swfu, upload);
} */

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	/*forUpdate.validator.set({
        title : "<spring:message code="필드:개설과목:기수"/>",
        name : "periodNumber",
        data : ["!null","number"]
    });
	*/
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:개설과목:박"/>",
        name : "workDay1",
        data : ["number"]
    });
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:개설과목:일"/>",
        name : "workDay2",
        data : ["number"]
    });
	
// 	forUpdate.validator.set({
//         title : "<spring:message code="필드:개설과목:박"/>",
//         name : "workDay1",
//         check : {
// 			lt : {name : "workDay2", title : "<spring:message code="필드:개설과목:일"/>"}
// 		}
//     });
};
/**
 * 목록보기
 */
doList = function() {
    forListdata.run();
};

/**
 * 저장
 */
doUpdate = function() { 
    // editor 값 복사
    UI.editor.copyValue();
    forUpdate.run();
};

/**
 * 파일삭제
 */
doDeleteFile = function(element, seq, index) {
    
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
 * 시간표 삭제
 */
doDeleteTimeTable = function(element, index){
	var $element = jQuery(element);
    var $file = $element.closest("div");
    var timetableIndex = "timetable"+index;
    var $attachDeleteInfo = $(":input[name='"+timetableIndex+"']").val("");
    
    $file.remove();
}

/**
 * 파일업로드 시작
 */
doStartUpload = function() {
	
	var isAppendedFiles = false;
	if (UI.uploader.isAppendedFiles(swfu, "uploader") == true) {
		isAppendedFiles = true;
	}
	
	if (isAppendedFiles == true) {
		UI.uploader.runUpload(swfu);
		return false;
	} else {
		return true;
	}
};

/**
 * 파일업로드 완료 Callback
 */
doSuccessCallback = function(id, file) {
	var fileInfo = file.serverData.fileInfo;
	
	var ids = id.split("-");
	if (ids.length == 2) {
		
		var indexId = parseInt(ids[1], 10);
		
		if(indexId > 0 ){
			var timetableIndex = "timetable" + indexId;
			
			$("input[name="+ timetableIndex +"]").val(fileInfo.savePath + "/" + fileInfo.saveName);	
		} else {
			$("input[name=attachUploadInfo").val(UI.uploader.getUploadedData(swfuAppendix, "uploader-0"));
		}
		
	}
};

doPopup = function(mapPKs) {
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forPopdata.config.formId);
	// 등록화면 실행
	forPopdata.run();
};

doPopupInsert = function(mapPKs) {
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forPopdata.config.formId);
	// 등록화면 실행
	forPopinset.run();
};

/**
 * 키 값 선택
 */
doSelectCourse = function(returnValue) {
	console.log(returnValue);
	if (returnValue != null) {
		var form = UT.getById(forUpdate.config.formId);
		form.elements["agreementSeq1"].value = returnValue.agreementSeq1 != null ? returnValue.agreementSeq1 : ""; 
		form.elements["agreementSeq2"].value = returnValue.agreementSeq2 != null ? returnValue.agreementSeq2 : ""; 
		form.elements["agreementSeq3"].value = returnValue.agreementSeq3 != null ? returnValue.agreementSeq3 : "";
		$("#agreeOK").css("display", "block");
	}
};


/**
 * 사진 삭제
 */
doDeletePhoto = function() {
	var form = UT.getById(forUpdate.config.formId);
	form.elements["thumNail"].value = "";
	
	var $photo = jQuery("#member-photo");
	$photo.attr("src", imageBlank);
	$photo.siblings(".delete").hide();
};

</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>
<body>
    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
    
    </c:import>
    <div style="display:none;">
        <c:import url="srchCourseActive.jsp"/>
    </div>
	<c:import url="../include/commonCourseActive.jsp">
        <c:param name="shortcutCourseActiveSeq" value="${detail.courseActive.courseActiveSeq}"></c:param>
        <c:param name="shortcutYearTerm" value="${detail.courseActive.yearTerm}"></c:param>
        <c:param name="shortcutCategoryTypeCd" value="${detail.category.categoryTypeCd}"></c:param>
        <c:param name="shortcutCourseTypeCd" value="${detail.courseActive.courseTypeCd}"></c:param>
    </c:import>
    
    <form id="FormPopup" name="" method="post" onsubmit="return false;">
    	 <input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.courseActive.courseActiveSeq}"/>"/>
    	 <input type="hidden" name="courseTypeCd" value="<c:out value="${detail.courseActive.courseTypeCd}"/>"/>
    </form>
    
    <form name="FormBrowsePopup" id="FormBrowsePopup" method="post" onsubmit="return false;">
    	<input type="hidden" name="callback" value="doSelectCourse"/>
		<input type="hidden" name="agreementSeq" value=""/>
	</form>
    
    <form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.courseActive.courseActiveSeq}"/>"/>
    <input type="hidden" name="courseTypeCd" value="<c:out value="${detail.courseActive.courseTypeCd}"/>"/>
    <input type="hidden" name="periodNumber" style="width:40px;text-align: center;" value="<c:out value="${detail.courseActive.periodNumber}"/>">
    <input type="hidden" name="thumNail" value="<c:out value="${detail.courseActive.thumNail}"/>"/>
    <table class="tbl-detail">
        <colgroup>
            <col style="width:120px" />
            <col/>
        </colgroup>
        <tbody>
            <tr>
                <th><spring:message code="필드:개설과목:교과목명"/></th>
                <td>
                    <input type="text" name="courseActiveTitle" style="width:350px;" value="<c:out value="${detail.courseActive.courseActiveTitle}"/>">
                </td>
            </tr>
            <tr>
                <th><spring:message code="필드:개설과목:과목분류"/></th>
                <td>
                    <c:out value="${detail.category.categoryString}"/>
                </td>
            </tr>
            <tr>
                <th><spring:message code="필드:개설과목:교과목소개"/></th>
                <td>
                    <textarea name="introduction" id="introduction" style="width:100%; height:100px"><c:out value="${detail.courseActive.introduction}"/></textarea>
                </td>
            </tr>
            <c:choose>
                <c:when test="${detail.courseActive.courseTypeCd eq CD_COURSE_TYPE_ALWAYS}">
                    <tr>
		                 <th><spring:message code="필드:개설과목:오픈기간"/></th>
		                 <td>
		                 	<input type="text" name="openStartDate" id="openStartDate" value="<aof:date datetime="${detail.courseActive.openStartDate}"/>" class="datepicker" readonly="readonly" style="width: 70px;">
		                    ~
		                    <input type="text" name="openEndDate" id="openEndDate" value="<aof:date datetime="${detail.courseActive.openEndDate}"/>" class="datepicker" readonly="readonly" style="width: 70px;">
		                 </td>
		             </tr>
		             <tr>
		                 <th><spring:message code="필드:개설과목:학습기간"/></th>
		                 <td>
		                 	<input type="text" name="studyDay" id="studyDay" value="<c:out value="${detail.courseActive.studyDay}"/>" class="align-c" style="width: 30px;"/>
		                    <spring:message code="필드:개설과목:일간"/>
		                 </td>
		             </tr>
		             <tr>
		                 <th><spring:message code="필드:개설과목:수강취소기간"/></th>
		                 <td>
		                 	<input type="text" name="cancelDay" id="cancelDay" value="<c:out value="${detail.courseActive.cancelDay}"/>" class="align-c" style="width: 30px;"/>
		                    <spring:message code="필드:개설과목:일간"/>
		                 </td>
		             </tr>
		             <tr>
		                 <th><spring:message code="필드:개설과목:복습기간"/></th>
		                 <td>
		                 	<spring:message code="필드:개설과목:학습종료일부터"/>
		                 	~
		                 	<input type="text" name="resumeDay" id="resumeDay" value="<c:out value="${detail.courseActive.resumeDay}"/>" class="align-c" style="width: 30px;"/>
		                    <spring:message code="필드:개설과목:일간"/>
		                 </td>
		             </tr>
                </c:when>
                <c:otherwise>
		             <tr>
		                 <th><spring:message code="필드:개설과목:학습기간"/></th>
		                 <td>
		                 	<input type="text" name="studyStartDate" id="studyStartDate" value="<aof:date datetime="${detail.courseActive.studyStartDate}"/>" class="datepicker" readonly="readonly" style="width: 70px;">
		                    ~
		                    <input type="text" name="studyEndDate" id="studyEndDate" value="<aof:date datetime="${detail.courseActive.studyEndDate}"/>" class="datepicker" readonly="readonly" style="width: 70px;">
		                    (<input type="text" name="workDay1" id="workDay1" value="<c:out value="${detail.courseActive.workDay1}"/>" style="width: 30px;text-align: center;" maxlength="3"/>박 
		                     <input type="text" name="workDay2" id="workDay2" value="<c:out value="${detail.courseActive.workDay2}"/>" style="width: 30px;text-align: center;" maxlength="3"/>일)
		                 </td>
		             </tr>
                </c:otherwise>
            </c:choose>
	        <tr>
	            <th>그룹방 이름</th>
	            <td>
	                <input type="text" name="courseGroupTitle" id="courseGroupTitle" value="<c:out value="${detail.courseActive.courseGroupTitle}"/>">
	            </td>
	        </tr>
	        <tr>
	            <th>약관 선택</th>
	            <td>
	            	<c:if test="${!empty detail.courseActive.agreementSeq1}">
	            		<a href="#" onclick="doPopup({'agreementSeq': '${detail.courseActive.agreementSeq1}'});"><c:out value="${detail.courseActive.agreementTilte1}" /></a><br/>
	            	</c:if>
	            	<c:if test="${!empty detail.courseActive.agreementSeq2}">
	            		<a href="#" onclick="doPopup({'agreementSeq': '${detail.courseActive.agreementSeq2}'});"><c:out value="${detail.courseActive.agreementTilte2}" /></a><br/>
	            	</c:if>
	            	<c:if test="${!empty detail.courseActive.agreementSeq3}">
	            		<a href="#" onclick="doPopup({'agreementSeq': '${detail.courseActive.agreementSeq3}'});"><c:out value="${detail.courseActive.agreementTilte3}" /></a>
	            	</c:if>
	            	<c:if test="${(empty detail.courseActive.agreementSeq1) && (empty detail.courseActive.agreementSeq2) && (empty detail.courseActive.agreementSeq3)}">
	            		 <a href="javascript:void(0)" onclick="doPopupInsert({'srchNotInCourseActiveSeq': '${detail.courseActive.courseActiveSeq}'})" class="btn black"><span class="mid">약관 등록</span></a>
	            		 <span id="agreeOK" style="display:none;">약관 등록 성공</span>	
	            	</c:if>
	            		<input type="hidden" id="agreementSeq1" name="agreementSeq1" value="<c:out value="${detail.courseActive.agreementSeq1}"/>" style="width: 30px;"/>
					    <input type="hidden" id="agreementSeq2" name="agreementSeq2" value="<c:out value="${detail.courseActive.agreementSeq2}"/>" style="width: 30px;"/>
					    <input type="hidden" id="agreementSeq3" name="agreementSeq3" value="<c:out value="${detail.courseActive.agreementSeq3}"/>" style="width: 30px;"/>
	            </td>
	        </tr>
	        <tr>
	            <th>정보 폐기 기간</th>
	            <td>
	            	운영 기간 시작일부터 <input type="text" name="expireStartDate" id="expireStartDate" value="<c:out value="${detail.courseActive.expireStartDate}"/>" style="width: 30px;"/> 년 뒤 폐기
	            </td>
	        </tr>   
	        <tr>
	            <th>썸네일</th>
	            <td>
 				<c:choose>
					<c:when test="${!empty detail.courseActive.thumNail}">
						<c:set var="memberPhoto" value ="${aoffn:config('upload.context.image')}${detail.courseActive.thumNail}.thumb.jpg"/>
					</c:when>
					<c:otherwise>
						<c:set var="memberPhoto"><aof:img type="print" src="bg/bg_white.png"/></c:set>
					</c:otherwise>
				</c:choose> 
	               <%-- <a href="javascript:void(0)" onclick="javascript:void(0)" class="btn black" id="uploader"><span class="mid"><spring:message code="버튼:찾아보기" />찾아보기</span></a> --%>
					<div class="photo photo-60">
 						<img src="<c:out value="${memberPhoto}"/>" id="member-photo" title="썸네일">
						<div id="uploader" class="uploader"></div>
						<div class="delete" 
						     style="display:<c:out value="${empty detail.courseActive.thumNail ? 'none' : ''}"/>;" 
						     onclick="doDeletePhoto()" title="<spring:message code="버튼:삭제"/>"></div>
					</div>	               
	            </td>
	        </tr>
        	</tr>
            <tr>
                <th><spring:message code="필드:개설과목:상태"/></th>
                <td><aof:code type="radio" name="courseActiveStatusCd" codeGroup="COURSE_ACTIVE_STATUS" selected="${detail.courseActive.courseActiveStatusCd}"></aof:code></td>
            </tr>
        </tbody>
    </table>
    </form>
    
    <div class="lybox-btn">
        <div class="lybox-btn-l">
        </div>
        <div class="lybox-btn-r">
           <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
                <a href="javascript:void(0)" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
            </c:if>
            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
        </div>
    </div>
</body>
</html>
<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_TEAMPROJECT" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.TEAMPROJECT')}"/>

<c:set var="attachSize" value="10"/>
<aof:session key="currentRolegroupSeq" var="ssCurrentRolegroupSeq"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata         = null;
var forInsert           = null;
var swfu                = null;
var forTemplateLayer    = null;
var forCreateTeamPopup  = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
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
				fileSizeLimit : "<c:out value='${attachSize}'/>MB",
				fileUploadLimit : 0, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				immediatelyUpload : true,
				successCallback : function(id, file) {}
			}
		}]
	);
	
	UI.datepicker("#startDate,#endDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
	UI.datepicker("#homeworkStartDate,#homeworkEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});

	
	
	// editor
	UI.editor.create("description");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/active/teamproject/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/course/active/teamproject/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before       = doSetUploadInfo;
	forInsert.config.fn.complete     = function() {
		doList();
	};
	
	// 탬플릿
	forTemplateLayer = $.action("layer");
    forTemplateLayer.config.formId         = "FormBrowseTemplate";
    forTemplateLayer.config.url            = "<c:url value="/univ/course/teamproject/template/list/popup.do"/>";
    forTemplateLayer.config.options.width  = 700;
    forTemplateLayer.config.options.height = 500;
    forTemplateLayer.config.options.title  = "<spring:message code="필드:팀프로젝트:팀프로젝트매핑"/>";

    // 탬플릿 내용 호출
    forTemplate = $.action();
    forTemplate.config.formId = "FormCreate";
    forTemplate.config.url    = "<c:url value="/univ/course/active/teamproject/create.do"/>";

	setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:팀프로젝트:프로젝트제목"/>",
		name : "teamProjectTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:팀프로젝트:팀프로젝트내용"/>",
		name : "description",
		data : ["!null"]
	});
	<%--
	forInsert.validator.set({
        title : "<spring:message code="필드:팀프로젝트:과제평가"/>",
        name : "rateHomework",
        data : ["!null","decimalnumber"]
    });
	
	forInsert.validator.set({
        title : "<spring:message code="필드:팀프로젝트:상호평가"/>",
        name : "rateRelation",
        data : ["!null","decimalnumber"]
    });
	
	forInsert.validator.set(function(){
		var rateHomework = parseInt($("input[name=rateHomework]").val());
		var rateRelation = parseInt($("input[name=rateRelation]").val());
		
		if((rateHomework+rateRelation) == 100){
			return true;
		} else {
			$.alert({message : "<spring:message code='글:팀프로젝트:평가비율총합은100%이어야합니다.'/>",
					button1 : {
			            callback : function() {
			            	$("input[name=rateHomework]").focus();
			                }
				         }
			        });
			return false;
		}
	});
	
	forInsert.validator.set({
        title : "<spring:message code="필드:팀프로젝트:프로젝트시작기간"/>",
        name : "startDate",
        data : ["!null"],
        check : {
            le : {name : "endDate", title : "<spring:message code="필드:팀프로젝트:프로젝트종료기간"/>"}
        }
    });
	
	forInsert.validator.set({
        title : "<spring:message code="필드:팀프로젝트:프로젝트종료기간"/>",
        name : "endDate",
        data : ["!null"]
    });
	
	forInsert.validator.set({
        title : "<spring:message code="필드:팀프로젝트:과제제출시작기간"/>",
        name : "homeworkStartDate",
        data : ["!null"],
        check : {
            le : {name : "homeworkEndDate", title : "<spring:message code="필드:팀프로젝트:과제제출종료기간"/>"}
        }
    });
	
	forInsert.validator.set({
        title : "<spring:message code="필드:팀프로젝트:과제제출종료기간"/>",
        name : "homeworkEndDate",
        data : ["!null"]
    });
--%>
};
/**
 * 저장
 */
doInsert = function() {
	
	
	//var startDate = $("input[name=startDate]").val();
	//var startTime = $("select[name=startTime]").val();
	
	//var endDate = $("input[name=endDate]").val();
    //var endTime = $("select[name=endTime]").val();
    
    //var homeworkStartDate = $("input[name=homeworkStartDate]").val();
    //var homeworkStartTime = $("select[name=homeworkStartTime]").val();
    
    //var homeworkEndDate = $("input[name=homeworkEndDate]").val();
    //var homeworkEndTime = $("select[name=homeworkEndTime]").val();
	
    //$("input[name=startDtime]").val(replaceAll(startDate)+startTime+"00");
    //$("input[name=endDtime]").val(replaceAll(endDate)+endTime+"00");
    
   // $("input[name=homeworkStartDtime]").val(replaceAll(homeworkStartDate)+homeworkStartTime+"00");
   // $("input[name=homeworkEndDtime]").val(replaceAll(homeworkEndDate)+homeworkEndTime+"00");
    
	// editor 값 복사
	UI.editor.copyValue();
	forInsert.run();
};

replaceAll = function(str)
{
    return str.split("-").join("");
};

/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
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
 * 탬플릿 상세정보
 */
doDetailTemplate = function(mapPKs){
	 // 상세화면 form을 reset한다.
    UT.getById(forTemplate.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forTemplate.config.formId);
    // 상세화면 실행
    forTemplate.run();
};

/**
 * 탬플릿 팝업
 */
doTemplatePopup = function(){
	forTemplateLayer.run();
};

/**
 * 파일삭제
 */
doDeleteFile = function(element, seq, copyId) {
    var $element = jQuery(element);
    var $file = $element.closest("div");
    var $uploader = $element.closest(".uploader");
    var $attachDeleteInfo = $uploader.siblings(":input[name='attachDeleteInfo']");
    var seqs = $attachDeleteInfo.val() == "" ? [] : $attachDeleteInfo.val().split(","); 
    seqs.push(seq);
    $attachDeleteInfo.val(seqs.join(","));
    $file.remove();
    
    // 탬플릿 정보 삭제
    $("#"+ copyId + seq).remove();
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>
<c:import url="srchTeamProject.jsp"></c:import>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<!-- 교과목 구성정보 Tab Area Start -->
<c:import url="../include/commonCourseActiveElement.jsp">
    <c:param name="courseActiveSeq" value="${teamProject.courseActiveSeq}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_TEAMPROJECT}"/>
</c:import>
<!--  교과목 구성정보 Tab Area End -->

<div class="lybox-title mt10">
    <h4 class="section-title"><spring:message code="필드:팀프로젝트:팀프로젝트"/>&nbsp;<spring:message code="글:신규등록" /></h4>
</div>

<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${teamProject.courseActiveSeq}"/>"/>
    <input type="hidden" name="courseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
    <input type="hidden" name="profMemberSeq" value="<c:out value="${appCourseActiveLecturer.profMemberSeq}"/>"/>
    
    <input type="hidden" name="startDtime"/>
    <input type="hidden" name="endDtime"/>
    <input type="hidden" name="homeworkStartDtime"/>
    <input type="hidden" name="homeworkEndDtime"/>
    
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>

    <table class="tbl-detail">
    <colgroup>
        <col style="width: 140px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀프로젝트제목"/>
            </th>
            <td>
               <%-- <a href="javascript:void(0)" onclick="doTemplatePopup()" class="pop-call-btn" title="<spring:message code="필드:팀프로젝트:탬플릿"/>"></a>
                --%>
                <input type="text" name="teamProjectTitle" value="<c:out value="${template.teamProjectTemplate.templateTitle}"/>" style="width:350px;">
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀프로젝트내용"/>
            </th>
            <td>
                <input type="hidden" name="editorPhotoInfo">
                <textarea name="description" id="description" style="width:100%; height:300px"><c:out value="${template.teamProjectTemplate.templateDescription}"/></textarea>
            </td>
        </tr>
        <tr>
			<th><spring:message code="필드:게시판:다운로드가능여부"/></th>
			<td>
				<aof:code type="radio" name="downloadYn" codeGroup="YESNO" selected="Y" removeCodePrefix="true"/>
	            </span>
			</td>
		</tr>
        <tr>
            <th><spring:message code="필드:게시판:첨부파일"/></th>
            <td>
                <!-- 탬플릿 파일-->
                <c:forEach var="row" items="${template.teamProjectTemplate.attachList}" varStatus="i">
                    <input type="hidden" name="attachSeqs" id="templateFile${row.attachSeq}" value="${row.attachSeq}"/>
                </c:forEach>
                
                <!--  신규 파일-->
                <input type="hidden" name="attachUploadInfo"/>
                <input type="hidden" name="attachDeleteInfo">
                <div id="uploader" class="uploader">
                    <c:if test="${!empty template.teamProjectTemplate.attachList}">
                        <c:forEach var="row" items="${template.teamProjectTemplate.attachList}" varStatus="i">
                            <div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>', 'templateFile')" class="previousFile">
                                <c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
                <span class="vbom"><c:out value="${attachSize}"/>MB</span>
            </td>
        </tr>
        <%--
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:평가비율"/>
            </th>
            <td>
                <spring:message code="필드:팀프로젝트:과제평가"/> : <input type="text" name="rateHomework" style="width: 30px;" maxlength="3">%
                <spring:message code="필드:팀프로젝트:상호평가"/> : <input type="text" name="rateRelation" style="width: 30px;" maxlength="3">%
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:프로젝트기간"/>
            </th>
            <td>
                <input type="text" name="startDate" id="startDate" class="datepicker" readonly="readonly" style="width: 70px;">
                <select name="startTime">
                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
                </select>
                <input type="text" name="endDate" id="endDate" class="datepicker" readonly="readonly" style="width: 70px;">
                <select name="endTime">
                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제제출기간"/>
            </th>
            <td>
                <input type="text" name="homeworkStartDate" id="homeworkStartDate" class="datepicker" readonly="readonly" style="width: 70px;">
                <select name="homeworkStartTime">
                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
                </select>
                <input type="text" name="homeworkEndDate" id="homeworkEndDate" class="datepicker" readonly="readonly" style="width: 70px;">
                <select name="homeworkEndTime">
                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
                </select>
            </td>
        </tr>
        --%>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제물공개여부"/>
            </th>
            <td>
                
                <aof:code type="radio" codeGroup="OPEN_YN" name="openYn" defaultSelected="Y" removeCodePrefix="true"/>
            </td>
        </tr>
        <%--
        <c:if test="${ssCurrentRolegroupSeq > 1}">
            <tr>
                <th>
                    <spring:message code="필드:팀프로젝트:템플릿저장"/>
                </th>
                <td>
                    
                    <aof:code type="radio" codeGroup="SAVE_YN" name="saveYn" defaultSelected="N" removeCodePrefix="true"/>
                </td>
            </tr>
        </c:if>
         --%>
    </tbody>
    </table>
    </form>
    <div class="lybox-btn">
    	<%--
        <div class="lybox-btn-l">
            <div class="comment">※  <spring:message code="글:팀프로젝트:과제평가비율과상호평가비율의합은100%이어야합니다."/></div>
        </div>
         --%>
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
            </c:if>
            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
        </div>
    </div>
</body>
</html>
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
var forUpdate           = null;
var swfu                = null;
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
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/course/active/teamproject/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before       = doSetUploadInfo;
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:팀프로젝트:프로젝트제목"/>",
		name : "teamProjectTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:팀프로젝트:팀프로젝트내용"/>",
		name : "description",
		data : ["!null"]
	});
	<%--
	forUpdate.validator.set({
        title : "<spring:message code="필드:팀프로젝트:과제평가"/>",
        name : "rateHomework",
        data : ["!null","decimalnumber"]
    });
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:팀프로젝트:상호평가"/>",
        name : "rateRelation",
        data : ["!null","decimalnumber"]
    });
	
	forUpdate.validator.set(function(){
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
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:팀프로젝트:프로젝트시작기간"/>",
        name : "startDate",
        data : ["!null"],
        check : {
            le : {name : "endDate", title : "<spring:message code="필드:팀프로젝트:프로젝트종료기간"/>"}
        }
    });
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:팀프로젝트:프로젝트종료기간"/>",
        name : "endDate",
        data : ["!null"]
    });
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:팀프로젝트:과제제출시작기간"/>",
        name : "homeworkStartDate",
        data : ["!null"],
        check : {
            le : {name : "homeworkEndDate", title : "<spring:message code="필드:팀프로젝트:과제제출종료기간"/>"}
        }
    });
	
	forUpdate.validator.set({
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
	<%--
	var startDate = $("input[name=startDate]").val();
	var startTime = $("select[name=startTime]").val();
	
	var endDate = $("input[name=endDate]").val();
    var endTime = $("select[name=endTime]").val();
    
    var homeworkStartDate = $("input[name=homeworkStartDate]").val();
    var homeworkStartTime = $("select[name=homeworkStartTime]").val();
    
    var homeworkEndDate = $("input[name=homeworkEndDate]").val();
    var homeworkEndTime = $("select[name=homeworkEndTime]").val();
	
    $("input[name=startDtime]").val(replaceAll(startDate)+startTime+"00");
    $("input[name=endDtime]").val(replaceAll(endDate)+endTime+"00");
    
    $("input[name=homeworkStartDtime]").val(replaceAll(homeworkStartDate)+homeworkStartTime+"00");
    $("input[name=homeworkEndDtime]").val(replaceAll(homeworkEndDate)+homeworkEndTime+"00");
    --%>
	// editor 값 복사
	UI.editor.copyValue();
	forUpdate.run();
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
		var form = UT.getById(forUpdate.config.formId);
		form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
	}
	return true;
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
    <h4 class="section-title"><spring:message code="필드:팀프로젝트:팀프로젝트"/>&nbsp;<spring:message code="글:수정" /></h4>
</div>


<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${teamProject.courseActiveSeq}"/>"/>
    <input type="hidden" name="courseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
    <input type="hidden" name="courseTeamProjectSeq" value="<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>"/>
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
                <input type="text" name="teamProjectTitle" value="<c:out value="${detail.courseTeamProject.teamProjectTitle}"/>" style="width:350px;">
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀프로젝트내용"/>
            </th>
            <td>
                <input type="hidden" name="editorPhotoInfo">
                <textarea name="description" id="description" style="width:100%; height:300px"><c:out value="${detail.courseTeamProject.description}"/></textarea>
            </td>
        </tr>
        <c:if test="${!empty detail.courseTeamProject.attachList}">
	        <tr>
				<th><spring:message code="필드:게시판:다운로드가능여부"/></th>
				<td>
					<aof:code type="radio" name="downloadYn" codeGroup="YESNO" selected="${detail.courseTeamProject.downloadYn}" removeCodePrefix="true"/>
		            </span>
				</td>
			</tr>
		</c:if>
        <tr>
            <th><spring:message code="필드:게시판:첨부파일"/></th>
            <td>
                <!--  신규 파일-->
                <input type="hidden" name="attachUploadInfo"/>
                <input type="hidden" name="attachDeleteInfo">
                <div id="uploader" class="uploader">
                    <c:if test="${!empty detail.courseTeamProject.attachList}">
                        <c:forEach var="row" items="${detail.courseTeamProject.attachList}" varStatus="i">
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
                <spring:message code="필드:팀프로젝트:과제평가"/> : <input type="text" name="rateHomework" value="<c:out value="${detail.courseTeamProject.rateHomework}"/>" style="width: 30px;" maxlength="3">%
                <spring:message code="필드:팀프로젝트:상호평가"/> : <input type="text" name="rateRelation" value="<c:out value="${detail.courseTeamProject.rateRelation}"/>" style="width: 30px;" maxlength="3">%
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:프로젝트기간"/>
            </th>
            <td>
                <c:set var="startTime">
                    <aof:date datetime="${detail.courseTeamProject.startDtime}" pattern="HHmm"></aof:date>
                </c:set>
                <c:set var="endTime">
                    <aof:date datetime="${detail.courseTeamProject.endDtime}" pattern="HHmm"></aof:date>
                </c:set>
                
                <input type="text" name="startDate" id="startDate" value="<aof:date datetime="${detail.courseTeamProject.startDtime}"/>" class="datepicker" readonly="readonly" style="width: 70px;">
                <select name="startTime">
                    <aof:code type="option" codeGroup="TIME" selected="${startTime}" removeCodePrefix="true"/>
                </select>
                <input type="text" name="endDate" id="endDate" value="<aof:date datetime="${detail.courseTeamProject.endDtime}"/>" class="datepicker" readonly="readonly" style="width: 70px;">
                <select name="endTime">
                    <aof:code type="option" codeGroup="TIME" selected="${endTime}" removeCodePrefix="true"/>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제제출기간"/>
            </th>
            <td>
                <c:set var="homeworkStartTime">
                    <aof:date datetime="${detail.courseTeamProject.homeworkStartDtime}" pattern="HHmm"></aof:date>
                </c:set>
                <c:set var="homeworkEndTime">
                    <aof:date datetime="${detail.courseTeamProject.homeworkEndDtime}" pattern="HHmm"></aof:date>
                </c:set>
                
                <input type="text" name="homeworkStartDate" id="homeworkStartDate" value="<aof:date datetime="${detail.courseTeamProject.homeworkStartDtime}"/>" class="datepicker" readonly="readonly" style="width: 70px;">
                <select name="homeworkStartTime">
                    <aof:code type="option" codeGroup="TIME" selected="${homeworkStartTime}" removeCodePrefix="true"/>
                </select>
                <input type="text" name="homeworkEndDate" id="homeworkEndDate" value="<aof:date datetime="${detail.courseTeamProject.homeworkEndDtime}"/>" class="datepicker" readonly="readonly" style="width: 70px;">
                <select name="homeworkEndTime">
                    <aof:code type="option" codeGroup="TIME" selected="${homeworkEndTime}" removeCodePrefix="true"/>
                </select>
            </td>
        </tr>
         --%>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제물공개여부"/>
            </th>
            <td>
                
                <aof:code type="radio" codeGroup="OPEN_YN" name="openYn" defaultSelected="Y" selected="${detail.courseTeamProject.openYn}" removeCodePrefix="true"/>
            </td>
        </tr>
    </tbody>
    </table>
    </form>
    <div class="lybox-btn">
       <%-- <div class="lybox-btn-l">
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
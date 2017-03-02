<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_TEAM_WAY_COPY"    value="${aoffn:code('CD.TEAM_WAY.COPY')}"/>
<c:set var="CD_TEAM_WAY_BATCH"    value="${aoffn:code('CD.TEAM_WAY.BATCH')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forCreateTeam      = null;
var forEditTeamMember        = null;
var forDeatilTeamPopup       = null;
var forCopyTeam              = null;
var forUploadPopup = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
    
    forCreateTeam = $.action("submit", {formId : "FormCreate"});
    forCreateTeam.config.url    = "<c:url value="/univ/course/active/teamproject/team/insert.do"/>";
    forCreateTeam.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forCreateTeam.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forCreateTeam.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forCreateTeam.config.target          = "hiddenframe";
    forCreateTeam.config.fn.complete     = function() {
    	doEditTeamMember();
    };
    
    forEditTeamMember = $.action();
    forEditTeamMember.config.formId = "FormCreate";
    forEditTeamMember.config.target = "_self";
    forEditTeamMember.config.url    = "<c:url value="/univ/course/active/teamproject/member/popup.do"/>";
    
    
    // 팀구성 조회
    forDeatilTeamPopup = $.action();
    forDeatilTeamPopup.config.formId         = "FormDetailProjectTeam";
    forDeatilTeamPopup.config.url            = "<c:url value="/univ/course/active/teamproject/team/detail/popup.do"/>";
    
    // 팀복사
    forCopyTeam = $.action("submit", {formId : "FormProjectTeamCopy"});
    forCopyTeam.config.url    = "<c:url value="/univ/course/active/teamproject/copy/insert.do"/>";
    forCopyTeam.config.message.confirm = "<spring:message code="글:팀프로젝트:복사하시겠습니까?"/>"; 
    forCopyTeam.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forCopyTeam.config.target          = "hiddenframe";
    
 // 팀일괄등록
	forUploadPopup = $.action("layer");
    forUploadPopup.config.formId         = "FormUploadExcel";
    forUploadPopup.config.url            = "<c:url value="/univ/course/active/teamproject/excel/popup.do"/>";
    //forUploadPopup.config.options.title  = "<spring:message code="필드:멤버:회원등록"/>";
    forUploadPopup.config.options.width  = 600;
    forUploadPopup.config.options.height = 140;
    forUploadPopup.config.options.callback = doList;   
    
    setValidate();
};

setValidate = function() {
	forCreateTeam.validator.set({
        title : "<spring:message code="필드:팀프로젝트:설정팀수"/>",
        name : "projectTeamCount",
        data : ["!null"],
        check : {
            gt : 0,
            lt : 99
        }
    });
};

doList = function(){
	$layer.dialog("close");
};


/**
 * 팀 생성을 호출하는 함수
 */
doCreateTeam = function() {
    forCreateTeam.run();
};

/**
 * 팀 일괄등록 호출하는 함수
 */
 doUploadTeam = function() {
	var TeamCount = $("#uploadProjectTeamCount").val();
	if(TeamCount != null && TeamCount != ""){
		if(TeamCount >= 99){
			$.alert({message : "설정 팀 수를 99보다 작은 값으로 입력하십시오"});
			return;
		}else if(TeamCount <= 0){
			$.alert({message : "설정 팀 수를 0보다 큰 값으로 입력하십시오"});
			return;
		}
	}else{
		$.alert({message : "설정 팀 수를 입력하십시오"});
		return;
	}
	forUploadPopup.run();
};

/**
 * 팀원 수정을 호출하는 함수
 */
doEditTeamMember = function(){
	forEditTeamMember.run();
};

/**
 * 구성방식에 따라 해당 영역을 show/hide  한다.
 */
doClickTeamWayArea = function(teamWay){
	if(teamWay == '${CD_TEAM_WAY_COPY}'){
		$("#randomArea").hide();
		$("#copyArea").show();
		$("#rightBtnArea").hide();
		$("#excelArea").hide();
		$("#rightBtnArea2").hide();
	} else if(teamWay == '${CD_TEAM_WAY_BATCH}'){
		$("#randomArea").hide();
		$("#copyArea").hide();
		$("#rightBtnArea").hide();
		$("#rightBtnArea2").show();
		$("#excelArea").show();
	}else {
		$("#randomArea").show();
        $("#copyArea").hide();
        $("#rightBtnArea").show();
        $("#excelArea").hide();
        $("#rightBtnArea2").hide();
	}
}

/**
 * 팀 구성 조회
 */
doDetailTeamMember = function(mapPKs){
	 // 상세화면 form을 reset한다.
    UT.getById(forDeatilTeamPopup.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDeatilTeamPopup.config.formId);
    // 상세화면 실행
    forDeatilTeamPopup.run();
};

/**
 * 팀복사
 */
doCopyTeamMember = function(mapPKs){
    // 상세화면 form을 reset한다.
   UT.getById(forCopyTeam.config.formId).reset();
   // 상세화면 form에 키값을 셋팅한다.
   UT.copyValueMapToForm(mapPKs, forCopyTeam.config.formId);
   
   forCopyTeam.config.fn.complete     = function() {
       doDetailTeamMember(mapPKs);
   };
   // 상세화면 실행
   forCopyTeam.run();
};

</script>
</head>

<body>

<form name="FormProjectTeamCopy" id="FormProjectTeamCopy" method="post" onsubmit="return false;">
    <input type="hidden" name="targetCourseTeamProjectSeq"/>
    <input type="hidden" name="sourceCourseTeamProjectSeq"/>
    <input type="hidden" name="courseActiveSeq">
</form>

<form name="FormDetailProjectTeam" id="FormDetailProjectTeam" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"/>
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="callback" value="doList"/>
</form>

<!-- 팀프로젝트 정보 상세 Start -->
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
            <c:out value="${detail.courseTeamProject.teamProjectTitle}"/>
        </td>
    </tr>
    <%--
    <tr>
        <th>
            <spring:message code="필드:팀프로젝트:프로젝트기간"/>
        </th>
        <td>
            <aof:date datetime="${detail.courseTeamProject.startDtime}"/>
            ~
            <aof:date datetime="${detail.courseTeamProject.endDtime}"/>
        </td>
    </tr>
     --%>
    <tr>
        <th>
            <spring:message code="필드:팀프로젝트:팀구성상태"/>
        </th>
        <td>
            <c:choose>
                <c:when test="${detail.courseTeamProject.projectTeamCount > 0}">
                    <spring:message code="필드:팀프로젝트:완료"/>
                </c:when>
                <c:otherwise>
                    <spring:message code="필드:팀프로젝트:미완료"/>
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
</tbody>
</table>
<!-- 팀프로젝트 정보 상세 End -->
<br/>
<!-- 팀프로젝트 구성 방식 Start -->
<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
<table class="tbl-detail">
<colgroup>
    <col style="width: 140px" />
    <col/>
</colgroup>
<tbody>
    <tr>
        <th>
            <spring:message code="필드:팀프로젝트:구성방식선택"/>
        </th>
        <td>
            <c:if test="${empty itemList}">
                <c:set var="exceptTeamWay" value="COPY"/>
            </c:if>
            <aof:code type="radio" name="teamWay" codeGroup="TEAM_WAY" defaultSelected="${CD_TEAM_WAY_COPY}" onclick="doClickTeamWayArea(this.value)" except="${exceptTeamWay}"/>
        </td>
    </tr>
</tbody>
</table>
<!-- 팀프로젝트 구성 방식 End -->

<br/>

<!-- 팀프로젝트 랜덤 구성 방식 Start -->
<input type="hidden" name="courseTeamProjectSeq" value="<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}" />">
<input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.courseTeamProject.courseActiveSeq}" />">
<table class="tbl-detail" id="randomArea" <c:if test="${not empty itemList}">style="display: none;"</c:if>>
<colgroup>
    <col style="width: 140px" />
    <col/>
</colgroup>
<tbody>
    <tr>
        <th>
            <spring:message code="필드:팀프로젝트:설정팀수"/>
        </th>
        <td>
            <input type="text" name="projectTeamCount" style="width: 20px;">
            <spring:message code="필드:팀프로젝트:팀"/>
        </td>
    </tr>
</tbody>
</table>
</form>
<!-- 팀프로젝트 랜덤 구성 방식 End -->

<form name="FormUploadExcel" id="FormUploadExcel" method="post" onsubmit="return false;">
    <input type="hidden" name="callback" value="doSearch"/>
	<input type="hidden" name="courseTeamProjectSeq" value="<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}" />">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.courseTeamProject.courseActiveSeq}" />">
	<table class="tbl-detail" id="excelArea" style="display: none;">
	<colgroup>
	    <col style="width: 140px" />
	    <col/>
	</colgroup>
	<tbody>
	    <tr>
	        <th>
	            <spring:message code="필드:팀프로젝트:설정팀수"/>
	        </th>
	        <td>
	            <input type="text" id="uploadProjectTeamCount" name="projectTeamCount" style="width: 20px;">
	            <spring:message code="필드:팀프로젝트:팀"/>
	        </td>
	    </tr>    
	</tbody>
	</table>	    
</form>
	<div class="lybox-btn">
		<div class="lybox-btn-l">
    	</div>
   		<div class="lybox-btn-r" id="rightBtnArea2" <c:if test="${not empty itemList}">style="display: none;"</c:if>>
			<a href="#"  onclick="doUploadTeam()" class="btn blue"><span class="mid"><spring:message code="버튼:팀프로젝트:다음"/></span></a>
		</div>
	</div>


<!-- 팀프로젝트 목록 Start -->
<table id="copyArea" class="tbl-list" <c:if test="${empty itemList}">style="display: none;"</c:if>>
<colgroup>
    <col style="width: 50px" />
    <col style="width: auto" />
   <%-- <col style="width: 180px" /> --%>
    
    <col style="width: 60px" />
    <col style="width: 60px" />
   <col style="width: 80px" />
</colgroup>
<thead>
    <tr>
        <th><spring:message code="필드:번호" /></th>
        <th><spring:message code="필드:팀프로젝트:프로젝트제목" /></th>
       <%-- <th><spring:message code="필드:팀프로젝트:프로젝트기간" /></th> --%>
        <th><spring:message code="필드:팀프로젝트:팀수" /></th>
        <th><spring:message code="필드:팀프로젝트:팀구성" /></th>
        <th><spring:message code="필드:팀프로젝트:복사" /></th>
    </tr>
</thead>
<tbody>
<c:forEach var="row" items="${itemList}" varStatus="i">
    <tr>
        <td><c:out value="${i.count}"/></td>
        
        <td class="align-l">
            <c:out value="${row.courseTeamProject.teamProjectTitle}"/>
        </td>
        <%--
        <td>
            <aof:date datetime="${row.courseTeamProject.startDtime}"/>
            ~
            <aof:date datetime="${row.courseTeamProject.endDtime}"/>
        </td>
         --%>
        <td>
            <c:choose>
                <c:when test="${row.courseTeamProject.projectTeamCount > 0}">
                    <c:out value="${row.courseTeamProject.projectTeamCount}"/>
                    <spring:message code="필드:팀프로젝트:팀" />
                </c:when>
                <c:otherwise>
                    -
                </c:otherwise>
            </c:choose>
        </td>
        <td>
            <c:choose>
                <c:when test="${row.courseTeamProject.projectTeamCount > 0}">
                    <a href="#" onclick="doDetailTeamMember({courseActiveSeq: <c:out value="${row.courseTeamProject.courseActiveSeq}"/>,courseTeamProjectSeq : <c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>})" class="btn gray">
                        <span class="small"><spring:message code="필드:팀프로젝트:보기" /></span>
                    </a>
                </c:when>
                <c:otherwise>
                    -
                </c:otherwise>
            </c:choose>
        </td>
        <td>
            <c:choose>
                <c:when test="${row.courseTeamProject.projectTeamCount > 0}">
                    <a href="javascript:void(0)" onclick="doCopyTeamMember({courseActiveSeq: <c:out value="${row.courseTeamProject.courseActiveSeq}"/>,courseTeamProjectSeq : <c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>,targetCourseTeamProjectSeq : <c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>, sourceCourseTeamProjectSeq : <c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>})" class="btn gray">
                        <span class="small"><spring:message code="필드:팀프로젝트:복사하기" /></span>
                    </a>
                </c:when>
                <c:otherwise>
                    -
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
</c:forEach>

<c:if test="${empty itemList}">
    <tr>
    
        <td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
    </tr>
</c:if>
</tbody>
</table>
<!-- 팀프로젝트 목록 End -->

<div class="lybox-btn">
    <div class="lybox-btn-l">
    </div>
    <div class="lybox-btn-r" id="rightBtnArea" <c:if test="${not empty itemList}">style="display: none;"</c:if>>
        <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
            <a href="#"  onclick="doCreateTeam()" class="btn blue"><span class="mid"><spring:message code="버튼:팀프로젝트:다음"/></span></a>
        </c:if>
    </div>
</div>
</body>
</html>
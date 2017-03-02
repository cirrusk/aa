<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">
var forListBbsdata  = null;
var forDetailResult = null;
var forEvalPopup    = null;
var forMessage      = null;
var hiddenFormClone = null; 
var forFileDownload = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    // 쪽지, SMS, 이메일을 보내기 위함 Form html 을 복사해놓은다.
    hiddenFormClone = $("#FormMessage").clone();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forListBbsdata = $.action();
	forListBbsdata.config.formId = "FormSrch";
	forListBbsdata.config.url    = "<c:url value="/univ/bbs/teamproject/list.do"/>";
	
	forList = $.action();
	forList.config.formId = "FormData";
	forList.config.url    = "<c:url value="/univ/teamproject/result/list.do"/>";

    forEvalPopup = $.action("layer");
    forEvalPopup.config.formId = "FormEvalPopup";
    forEvalPopup.config.url    = "<c:url value="/univ/teamproject/eval/popup.do"/>";
    forEvalPopup.config.options.width = 800;
    forEvalPopup.config.options.height = 600;
    forEvalPopup.config.options.title = "<spring:message code="필드:팀프로젝트:팀프로젝트평가"/>";
    
    forSavelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forSavelist.config.url             = "<c:url value="/univ/teamproject/score/updatelist.do"/>";
    forSavelist.config.target          = "hiddenframe";
    forSavelist.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forSavelist.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forSavelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forSavelist.config.fn.complete     = function() {
    	doProjectResult();
    };
    	
    forDetailResult = $.action();
    forDetailResult.config.formId = "FormTeamProjectResult";
    forDetailResult.config.url    = "<c:url value="/univ/teamproject/result/detail.do"/>";
    
    
	forMessage = $.action("ajax");
    forMessage.config.formId = "FormData";
    forMessage.config.type   = "json";
    forMessage.config.url    = "<c:url value="/univ/teamproject/member/ajax.do"/>";
  
    forFileDownload = $.action();
    forFileDownload.config.formId = "FormFileDownload";
    forFileDownload.config.url    = "<c:url value="/univ/teamproject/collective/file/response.do"/>";
    
    setValidate();
};

setValidate = function() {
	forSavelist.validator.set({
        title : "<spring:message code="필드:팀프로젝트:점수"/>",
        name : "homeworkScores",
        data : ["!null","decimalnumber"]
    });
};

/**
 * 점수 저장
 */
doSaveScore = function(){
	forSavelist.run();
};

/**
 * 참여게시판 가져오기 실행.
 */
doListBoard = function(mapPKs) {
    UT.copyValueMapToForm(mapPKs, forListBbsdata.config.formId);
    forListBbsdata.run();
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
    param.push("module=board");
    action.config.parameters = param.join("&");
    action.run();
};

/**
 * 미제출 메시지
 */
doAlertMsg = function(){
	$.alert({
        message : "<spring:message code="글:팀프로젝트:제출정보가없습니다." />"
    });	
};

/**
 * 팀프로젝트  결과(reload)
 */
doProjectResult = function(mapPKs){
	if(!mapPKs){
		mapPKs = {courseTeamProjectSeq : '<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>'};	
	}
	
	UT.copyValueMapToForm(mapPKs, forDetailResult.config.formId);
	forDetailResult.run();
};

/**
 * 팀프로젝트 목록
 */
doList = function(){
	forList.run();
};

/**
 * 과제 제출 정보 상세 보기
 */
doEvalPopup = function(mapPKs){
	UT.copyValueMapToForm(mapPKs, forEvalPopup.config.formId);
	forEvalPopup.run();
};

/**
 * 메세지 전송
 */
doSendMessage = function(type) {
	forMessage.config.fn.complete = function(action, data) {
        if (data.result != null) {
            var result = data.result;
            
           // var hiddenHtml = $("#FormMessage").clone();
            var formHidden = "";
            
            $.each( result, function( idx) {
            	  hiddenFormClone.find("input[name=checkkeys]").attr("value",idx);
                  hiddenFormClone.find("input[name=memberSeqs]").attr("value",result[idx].courseTeamProjectMember.teamMemberSeq);
                  hiddenFormClone.find("input[name=memberNames]").attr("value",result[idx].member.memberName);
                  hiddenFormClone.find("input[name=phoneMobiles]").attr("value",result[idx].member.phoneMobile);
                  
                  formHidden += hiddenFormClone.html();
            });
            
            $("#FormMessage").html(formHidden);
            
            switch (type) {
            case "MEMO":
                FN.doMemoCreate('FormMessage',doFormEmpty);
                break;
            case "SMS":
                FN.doCreateSms('FormMessage',doFormEmpty);
                break;
            case "EMAIL":
                FN.doCreateEmail('FormMessage',doFormEmpty);
            break;
            }
        }
    };
    
	forMessage.run();
};

/**
 * Form을 비운다. 
 */
doFormEmpty = function(){
	$("#FormMessage").empty();
};

/**
 * 일괄 다운로드 실행.
 */
doCollectiveFile = function(mapPKs){
    UT.copyValueMapToForm(mapPKs, forFileDownload.config.formId);
	forFileDownload.run();

};
</script>
</head>

<body>
<div style="display: none;">
    <c:import url="board/bbs/srchBbs.jsp"/>
    <c:import url="srchTeamProjectResult.jsp"/>
</div>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<div class="lybox-title">
    <h4 class="section-title">
    <spring:message code="필드:팀프로젝트:팀프로젝트정보" />
    </h4>
</div>
<table class="tbl-detail">
    <colgroup>
        <col style="width:140px" />
        <col style="width:200px" />
        <col style="width:120px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀프로젝트주제" />
            </th>
            <td colspan="3" class="align-l">
                <c:out value="${detail.courseTeamProject.teamProjectTitle}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:내용" />
            </th>
            <td colspan="3" class="align-l">
                <aof:text type="whiteTag" value="${detail.courseTeamProject.description}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:첨부파일" />
            </th>
            <td colspan="3" class="align-l">
                <c:forEach var="row" items="${detail.courseTeamProject.attachList}" varStatus="i">
                    <a href="javascript:void(0)" onclick="doAttachDownload('<c:out value="${row.attachSeq}"/>')"><c:out value="${row.realName}"/></a>
                    [<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                    <c:if test="${!i.last}"><br/></c:if>
                </c:forEach>
            </td>
        </tr>
        <%--
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제평가비율" />
            </th>
            <td>
                <c:out value="${detail.courseTeamProject.rateHomework}"/>%
            </td>
           
            <th>
                <spring:message code="필드:팀프로젝트:상호평가비율" />
            </th>
            <td>
                <c:out value="${detail.courseTeamProject.rateRelation}"/>%
            </td>
        </tr>
       
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:프로젝트기간" />
            </th>
            <td colspan="3" class="align-l">
                <spring:message code="필드:팀프로젝트:진행기간" /> 
                : 
                <aof:date datetime="${detail.courseTeamProject.startDtime}"/>
                ~
                <aof:date datetime="${detail.courseTeamProject.endDtime}"/>
                <br/>
                <spring:message code="필드:팀프로젝트:과제제출" />
                :
                <aof:date datetime="${detail.courseTeamProject.homeworkStartDtime}"/>
                ~
                <aof:date datetime="${detail.courseTeamProject.homeworkEndDtime}"/>
            </td>
        </tr>
         --%>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제물공개" />
            </th>
            <td colspan="3" class="align-l">
                <%/** TODO : 코드*/ %>
                <aof:code type="print" codeGroup="OPEN_YN" name="openYn" selected="${detail.courseTeamProject.openYn}" removeCodePrefix="true"/>
            </td>
        </tr>
    </tbody>
</table>

<div class="lybox-title mt10">
    <h4 class="section-title">
    <spring:message code="필드:팀프로젝트:팀구성정보" />
    </h4>
</div>
<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
<input type="hidden" name="activeElementSeq" value="<c:out value="${teamList[0].courseActiveElement.activeElementSeq}"/>"/>

<table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 40px" />
        <col style="width: 50px" />
        <col/>
        <col style="width: 80px" />
        <col style="width: 80px" />

        <col style="width: 80px" />
        <col style="width: 80px" />
        <col style="width: 80px" />
        <col style="width: 100px" />
        <col style="width: 100px" />
    </colgroup>
    <thead>
        <tr>
            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButtonBottom');" /></th>
            <th><spring:message code="필드:번호" /></th>
            <th><spring:message code="필드:팀프로젝트:팀명" /></th>
            <th><spring:message code="필드:팀프로젝트:팀장" /></th>
            <th><spring:message code="필드:팀프로젝트:팀원(명)" /></th>
            <th><spring:message code="필드:팀프로젝트:게시글수" /></th>
            
            <th><spring:message code="필드:팀프로젝트:제출정보" /></th>
            <th><spring:message code="필드:팀프로젝트:제출일" /></th>
            <th><spring:message code="필드:팀프로젝트:점수" /></th>
            <th><spring:message code="필드:팀프로젝트:과제체점일" /></th>
        </tr>
    </thead>
    <tbody>
    <c:set var="nonSavingData" value="0"></c:set>
    <c:forEach var="row" items="${teamList}" varStatus="i">
        <tr>
            <td>
                <input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
            </td>
            <td>
                <c:out value="${i.count}"/>
            </td>
            <td class="align-l">
                <c:out value="${row.courseTeamProjectTeam.teamTitle}"/>
            </td>
            <td>
                <c:out value="${row.member.memberName}"/>
            </td>
            <td>
                <c:out value="${row.courseTeamProjectTeam.memberCount}"/>
                <spring:message code="필드:팀프로젝트:명" />
            </td>
            <td>
                <a href="javascript:void(0)" onclick="doListBoard({courseTeamProjectSeq : '<c:out value="${row.courseTeamProjectTeam.courseTeamProjectSeq}"/>',
                                                                   courseTeamSeq : '<c:out value="${row.courseTeamProjectTeam.courseTeamSeq}"/>'})">
                    <c:out value="${row.courseActiveBbs.bbsCount}"/>
                </a>
            </td>
            <td>
                <c:choose>
                    <c:when test="${empty row.courseHomeworkAnswer.sendDtime}">
                         <a href="javascript:void(0)" onclick="doAlertMsg()" class="btn gray">
                            <span class="mid"><spring:message code="버튼:팀프로젝트:보기" /></span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="javascript:void(0)" onclick="doEvalPopup({courseTeamProjectSeq : '<c:out value="${row.courseTeamProjectTeam.courseTeamProjectSeq}"/>',
                                                                           courseTeamSeq : '<c:out value="${row.courseTeamProjectTeam.courseTeamSeq}"/>'})" class="btn black">
                            <span class="mid"><spring:message code="버튼:팀프로젝트:보기" /></span>
                        </a>
                    </c:otherwise>
                </c:choose>
                
                
            </td>
            <td>
                <c:choose>
                    <c:when test="${empty row.courseHomeworkAnswer.sendDtime}">
                        <spring:message code="필드:팀프로젝트:미제출" />
                    </c:when>
                    <c:otherwise>
                        <aof:date datetime="${row.courseHomeworkAnswer.sendDtime}"/>
                    </c:otherwise>
                </c:choose>
            </td>
            <td>
                <input type="text" name="homeworkScores" value="<c:out value="${row.courseHomeworkAnswer.homeworkScore}"/>" style="width: 40px;text-align: center;">
                <input type="hidden" name="oldHomeworkScores" value="<c:out value="${row.courseHomeworkAnswer.homeworkScore}"/>">
                <input type="hidden" name="courseTeamSeqs" value="<c:out value="${row.courseTeamProjectTeam.courseTeamSeq}"/>">
            </td>
            <td>
                <c:choose>
                    <c:when test="${empty row.courseHomeworkAnswer.scoreDtime}">
                        -
                    </c:when>
                    <c:otherwise>
                        <aof:date datetime="${row.courseHomeworkAnswer.scoreDtime}"/>
                    </c:otherwise>
                </c:choose>
                
            </td>
            <c:if test="${not empty row.courseHomeworkAnswer.homeworkScore}">
                <c:set var="nonSavingData" value="${nonSavingData + 1}"></c:set>
            </c:if>
        </tr>
        
    </c:forEach>
    <c:if test="${empty teamList}">
        <tr>
            <td colspan="10" align="center"><spring:message code="글:데이터가없습니다" /></td>
        </tr>
    </c:if>
    </tbody>
    </table>
</form>
<div class="lybox-btn">
    <div class="lybox-btn-l">
<%--         <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}"> --%>
<%--             <a href="javascript:void(0)" onclick="doCollectiveFile({courseTeamProjectSeq : '<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>', courseActiveSeq : '<c:out value="${detail.courseTeamProject.courseActiveSeq}"/>'})" class="btn blue"> --%>
<%--                 <span class="mid"><spring:message code="필드:팀프로젝트:일괄다운로드" /></span> --%>
<!--             </a> -->
<%--         </c:if> --%>
    </div>
    <div class="lybox-btn-r">
        
            <span id="warning" style="<c:if test="${nonSavingData > 0}">display: none;</c:if>color: red;">
                <spring:message code="글:평가기준:저장되지않는데이터가존재합니다" />
            </span>
            <c:if test="${not empty teamList}">
               <span style="display: none;" id="checkButtonBottom">
               	<%--
                   <a href="javascript:void(0)" onclick="doSendMessage('MEMO')" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
                   <a href="javascript:void(0)" onclick="doSendMessage('SMS')" class="btn blue"><span class="mid"><spring:message code="버튼:SMS"/></span></a>
                   <a href="javascript:void(0)" onclick="doSendMessage('EMAIL')" class="btn blue"><span class="mid"><spring:message code="버튼:이메일"/></span></a>
                    --%>
               </span>
	           <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
	                <a href="javascript:void(0)" onclick="doSaveScore()" class="btn blue">
	                    <span class="mid"><spring:message code="버튼:저장" /></span>
	                </a>
	            </c:if>
        	</c:if>
        <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'R')}">
            <a href="javascript:void(0)" onclick="doList()" class="btn blue">
                <span class="mid"><spring:message code="버튼:목록" /></span>
            </a>
        </c:if>
    </div>
</div>
</body>
</html>
<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<html decorator="classroom-layer">
<head>
<title><spring:message code="필드:팀프로젝트:팀프로젝트" /></title>
<script type="text/javascript">
var forDetailHomework   = null;
var forTeamProjectHome  = null;
var forMutualeval       = null;
var forListBbsdata      = null;
var forUpdateHomework   = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    swfu = UI.uploader.create(function() {}, // completeCallback
        [{
            elementId : "uploader",
            postParams : {},
            options : {
                uploadUrl : "<c:url value="/attach/file/save.do"/>",
                fileTypes : "*.*",
                fileTypesDescription : "All Files",
                fileSizeLimit : "10 MB",
                fileUploadLimit : 1, // default : 1, 0이면 제한없음.
                inputHeight : 20, // default : 20
                immediatelyUpload : true,
                successCallback : function(id, file) {}
            }
        }]
    );
    // editor
    
    UI.editor.create("description");
};
/**
 * 설정
 */
doInitializeLocal = function() {
    
    forDetailHomework = $.action();
    forDetailHomework.config.formId = "FormDetailHomework";
    forDetailHomework.config.url    = "<c:url value="/usr/classroom/teamproject/homework/detail.do"/>";
    
    forTeamProjectHome = $.action();
    forTeamProjectHome.config.formId = "FormProjectTeamHome";
    forTeamProjectHome.config.url    = "<c:url value="/usr/classroom/teamproject/list.do"/>";

    forMutualeval = $.action();
    forMutualeval.config.formId = "FormMutualeval";
    forMutualeval.config.url    = "<c:url value="/usr/classroom/teamproject/mutualeval/list.do"/>";
    
    forListBbsdata = $.action();
    forListBbsdata.config.formId = "FormSrch";
    forListBbsdata.config.url    = "<c:url value="/usr/classroom/bbs/teamproject/list.do"/>";
    
    forUpdateHomework = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdateHomework.config.url             = "<c:url value="/usr/classroom/teamproject/homework/update.do"/>";
    forUpdateHomework.config.target          = "hiddenframe";
    forUpdateHomework.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forUpdateHomework.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdateHomework.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateHomework.config.fn.before       = doSetUploadInfo;
    forUpdateHomework.config.fn.complete     = function() {
        doDetailHomework({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})
    };
    
    setValidate();
};

setValidate = function() {
};

/**
 * 과제물 등록 화면 이동
 */
doCreateHomework = function(mapPKs){
	UT.getById(forCreateHomework.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forCreateHomework.config.formId);
	forCreateHomework.run();
};

/**
 * 과제물상세보기 가져오기 실행.
 */
 doDetailHomework = function(mapPKs) {
    UT.getById(forDetailHomework.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetailHomework.config.formId);
    forDetailHomework.run();
};

/**
 * 팀프로젝트 홈 이동
 */
doTeamProjectHome = function(mapPKs){
    UT.getById(forTeamProjectHome.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forTeamProjectHome.config.formId);
    forTeamProjectHome.run();
};

/**
 * 상호평가 이동
 */
doMutualeval = function(mapPKs){
    UT.getById(forMutualeval.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forMutualeval.config.formId);
    
    forMutualeval.run();
};

/**
 * 참여게시판 가져오기 실행.
 */
 doListBoard = function(mapPKs) {
    UT.getById(forListBbsdata.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forListBbsdata.config.formId);
    forListBbsdata.run();
};

/**
 * 파일정보 저장
 */
doSetUploadInfo = function() {
    if (swfu != null) {
        var form = UT.getById(forUpdateHomework.config.formId);
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

doUpdateHomework = function(){
	// editor 값 복사
    UI.editor.copyValue();
    forUpdateHomework.run();
}

</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>
<!-- 팀 프로젝트 팀 정보 Start -->
<c:import url="../include/commonTeamProject.jsp"></c:import>
<!-- 팀 프로젝트 팀 정보 End -->

<div id="tabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all"
    style="width: 100%; border-top-color: currentColor; border-right-color: currentColor; border-bottom-color: currentColor; border-left-color: currentColor; border-top-width: medium; border-right-width: medium; border-bottom-width: medium; border-left-width: medium; border-top-style: none; border-right-style: none; border-bottom-style: none; border-left-style: none;">
    <ul class="ui-widget-header-tab-custom ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
        <li class="ui-state-default ui-corner-top">
            <a onclick="doListBoard({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>', courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})"><spring:message code="필드:팀프로젝트:게시판" /></a>
        </li>
        <li class="ui-state-default ui-corner-top">
        <a onclick="doMutualeval({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>', courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})">
            <spring:message code="필드:팀프로젝트:상호평가" />
        </a>
        </li>
        <li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active">
            <a href="#"><spring:message code="필드:팀프로젝트:과제물" /></a>
        </li>
    </ul>
</div>
<div style="display: none;">
<c:import url="../board/bbs/srchBbs.jsp"/>
<c:import url="../srchTeamProject.jsp"></c:import>
</div>
<c:choose>
    <c:when test="${empty homework}">
        <div class="lybox align-c mt10"><spring:message code="글:팀프로젝트:제출된과제물이없습니다." /></div>
        <div class="lybox-btn">
            <div class="lybox-btn-l">
            </div>
            <div class="lybox-btn-r">
                <c:if test="${detail.member.memberSeq == ssMemberSeq}">
                    <a href="javascript:void(0)" onclick="doCreateHomework({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>', courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})" class="btn blue">
                        <span class="mid"><spring:message code="버튼:등록" /></span>
                    </a>
                </c:if>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
        <input type="hidden" name="courseApplySeq" value="<c:out value="${courseApply.courseApplySeq}"/>">
        <input type="hidden" name="courseTeamSeq" value="<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>">
        <input type="hidden" name="homeworkAnswerSeq" value="<c:out value="${homework.answer.homeworkAnswerSeq}"/>">
        <input type="hidden" name="activeElementSeq" value="<c:out value="${detail.courseActiveElement.activeElementSeq}"/>">
        <table id="listTable" class="tbl-list mt10">
            <colgroup>
                <col style="width: 140px;" />
                <col/>
            </colgroup>
            <tbody>
            <table class="tbl-detail">
                <colgroup>
                    <col style="width:120px" />
                    <col/>
                </colgroup>
                <tbody>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:제목"/>
                        </th>
                        <td>
                            <input type="text" name="homeworkAnswerTitle" value="<c:out value="${homework.answer.homeworkAnswerTitle}"/>" style="width:350px;">
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:내용"/>
                        </th>
                        <td>
                            <textarea name="description" id="description" style="width:98%; height:300px"><c:out value="${homework.answer.description}"/></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:첨부파일"/>
                        </th>
                        <td>
                            <input type="hidden" name="attachUploadInfo"/>
                            <input type="hidden" name="attachDeleteInfo">
                            <div id="uploader" class="uploader">
                                <c:if test="${!empty homework.answer.unviAttachList}">
                                    <c:forEach var="row" items="${homework.answer.unviAttachList}" varStatus="i">
                                        <div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>')" class="previousFile">
                                            <c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </tbody>
                </table>
            </tbody>
        </table>
        </form>
        <div class="lybox-btn">
            <div class="lybox-btn-l">
            </div>
            <div class="lybox-btn-r">
                <c:if test="${detail.member.memberSeq == ssMemberSeq}">
                    <a href="javascript:void(0)" onclick="doUpdateHomework()" class="btn blue">
                        <span class="mid"><spring:message code="버튼:저장" /></span>
                    </a>
                </c:if>
                <a href="javascript:void(0)" onclick="doDetailHomework({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})" class="btn blue">
                    <span class="mid"><spring:message code="버튼:취소" /></span>
                </a>
            </div>
        </div>
    </c:otherwise>
</c:choose>
</body>
</html>
<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdateTeamMember   = null;
var forListdata           = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
    
	forUpdateTeamMember = $.action("submit", {formId : "FormData"});
	forUpdateTeamMember.config.url    = "<c:url value="/univ/course/active/teamproject/member/updatelist.do"/>";
	forUpdateTeamMember.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdateTeamMember.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdateTeamMember.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateTeamMember.config.fn.before          = function(){
		$("select[name=assignCourseTeamSeqs],select[name=unassignCourseTeamSeqs]").each(function(){
			$(this).attr("disabled",false);
		});
		return true;
	}
	forUpdateTeamMember.config.target          = "hiddenframe";
	forUpdateTeamMember.config.fn.complete     = function() {
		doList();
	};
	
	forListdata = $.action();
    forListdata.config.formId = "FormData";
    forListdata.config.url    = "<c:url value="/univ/course/active/teamproject/member/popup.do"/>";
    
    setValidate();
};

setValidate = function() {
	forUpdateTeamMember.validator.set(function(){
        var chiefCnt = 0;
        
        $("#AssignTeamMemberArea select[name=assignChiefYns]").each(function(){
            if($(this).val() == 'Y') {
            	chiefCnt = chiefCnt+1;
            }
        });
        
        $("#AssignTeamMemberArea select[name=unassignChiefYns]").each(function(){
            if($(this).val() == 'Y') {
            	chiefCnt = chiefCnt+1;
            }
        });
        
        if(chiefCnt == 1){
            return true;
        } else if(chiefCnt == 0){
        	$.alert({message : "<spring:message code='글:팀프로젝트:팀장1명을선택하여야합니다.'/>"});
            return false;
        } else {
            $.alert({message : "<spring:message code='글:팀프로젝트:팀장은1명만가능합니다.'/>"});
            return false;
        }
    });
};

/**
 * 팀원 목록보기 가져오기 실행.
 */
doList = function() {
    forListdata.run();
};

/**
 * 팀 생성을 호출하는 함수
 */
doUpdateTeamMember = function() {
	forUpdateTeamMember.run();
};


/**
 * 팀으로 할당
 */
doAssignMember = function(){
	$("#UnassignTeamMemberArea input:checkbox:checked").each(function(){
        
		var teamMemberSeq = $(this).val();
        var htmlObj = $("#"+ teamMemberSeq);
		
		if(htmlObj.find("input[name=unassignTransferYns]").length > 0){
			htmlObj.find("input[name=unassignTransferYns]").val("Y");	
			htmlObj.find("#chifYnArea_"+teamMemberSeq).show();
            htmlObj.find("#courseTeamArea_"+teamMemberSeq).show();
		} else {
			htmlObj.find("input[name=assignTransferYns]").val("N");
	        htmlObj.find("#chifYnArea_"+teamMemberSeq).show();
	        htmlObj.find("#courseTeamArea_"+teamMemberSeq).show();	
		}
		
        $("#AssignTeamMemberArea").append("<tr id="+teamMemberSeq+">"+htmlObj.html()+"</tr>");
        
        htmlObj.remove();
    });
	
	doToggleBtn();
};

/**
 * 대기자로 할당
 */
doUnassignMember = function(){
	
	$("#AssignTeamMemberArea input:checkbox:checked").each(function(){
		var teamMemberSeq = $(this).val();
		var htmlObj = $("#"+ teamMemberSeq);
		
		if(htmlObj.find("input[name=unassignTransferYns]").length > 0){
            htmlObj.find("input[name=unassignTransferYns]").val("N");  
            htmlObj.find("#chifYnArea_"+teamMemberSeq).hide();
            htmlObj.find("#courseTeamArea_"+teamMemberSeq).hide();
        } else {
            htmlObj.find("input[name=assignTransferYns]").val("Y");
            htmlObj.find("#chifYnArea_"+teamMemberSeq).hide();
            htmlObj.find("#courseTeamArea_"+teamMemberSeq).hide();  
        }
		
	    $("#UnassignTeamMemberArea").append("<tr id="+teamMemberSeq+">"+htmlObj.html()+"</tr>");
	    
	    htmlObj.remove();
	});
	
	doToggleBtn();
};

/**
 * 버튼 및 No Data Area Show/hide
 */
doToggleBtn = function(){
	// 대기자 영역
	if($("#UnassignTeamMemberArea  input:checkbox").length > 0){
		$("#btnMoveRight").show();	
		$("#UnassignNoDataArea").hide();
	} else {
		$("#btnMoveRight").hide();
		$("#UnassignNoDataArea").show();
	}
	
	// 팀원 영역
	if($("#AssignTeamMemberArea input:checkbox").length > 0){
        $("#btnMoveLeft").show();  
        $("#AssignNoDataArea").hide();
    } else {
        $("#btnMoveLeft").hide();
        $("#AssignNoDataArea").show();
    }
};

/**
 * 팀장 <=> 팀원 변경
 */
doChangeChief = function(obj,teamMemberSeq) {
	 var selectObj = $("#courseTeamArea_"+teamMemberSeq).find("select");
	
	 if($(obj).val() == 'Y'){
		// 팀장은 팀이동이 불가능하고, 원래 팀으로 롤백한다.
		 selectObj.attr("disabled",true);
		var originCourseTeamSeq = $("select[name=courseTeamSeq]").val();
		selectObj.val(originCourseTeamSeq);
		
	} else {
		selectObj.attr("disabled",false);
	}
};
 
/**
 * 전체 체크/해제
 */
doChkAll = function(obj,id){
	if($(obj).is(":checked")){
		$("#"+ id+" :checkbox").attr("checked", true);	
	} else {
		$("#"+ id+" :checkbox").attr("checked", false);
	}
};
</script>
</head>

<body>
<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<input type="hidden" name="courseTeamProjectSeq" value="<c:out value='${projectTeamMamber.courseTeamProjectSeq}'/>">
<input type="hidden" name="courseActiveSeq" value="<c:out value="${projectTeamMamber.courseActiveSeq}" />">
<!-- 타이틀 박스 -->
<table class=""><!-- tbl-2column 테이블 상단에 오는 제목 테이블, 별도 클래스는 필요없음-->
    <colgroup>
        <col style="width:9%;" />
        <col style="width:30%;" />
        <col style="width:1%;" /><!-- blank 칼럼(좌우 구분 빈셀) -->
        <col style="width:30%;" />
        <col style="width:30%;" />
    </colgroup>
    <thead>
        <tr>
            <th colspan="2"><!-- colspan = blank 칼럼을 제외한 좌측 칼럼 병합 -->
                <div class="lybox-title">
                    <h4 class="section-title"><spring:message code="필드:팀프로젝트:대기자목록"/></h4>
                </div>
            </th>
            <th colspan="2"><!-- colspan = blank 칼럼을 포함한 우측 칼럼 병합 -->
                <div class="lybox-title">
                    <h4 class="section-title"><spring:message code="필드:팀프로젝트:팀분류"/></h4>
                    <select name="courseTeamSeq" onchange="doList()" style="width: 140px;">
                        <c:forEach var="row" items="${teamList}" varStatus="i">
                            <option value="${row.courseTeamProjectTeam.courseTeamSeq}" <c:if test="${projectTeamMamber.courseTeamSeq == row.courseTeamProjectTeam.courseTeamSeq}">selected="selected"</c:if>>${row.courseTeamProjectTeam.teamTitle}</option>
                            
                            <c:if test="${projectTeamMamber.courseTeamSeq == row.courseTeamProjectTeam.courseTeamSeq}">
                                <c:set var="teamTitle" value="${row.courseTeamProjectTeam.teamTitle}"></c:set>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
            </th>
            <th>
                <c:if test="${empty teamTitle}">
                    <c:set var="teamTitle" value="${teamList[0].courseTeamProjectTeam.teamTitle}"></c:set>
                </c:if>
                <div class="lybox-title">
                   <h4 class="section-title"><spring:message code="필드:팀프로젝트:팀이름"/></h4>
                   <input type="text" name="teamTitle" value="<c:out value='${teamTitle}'/>">
                </div>
            </th>
        </tr>
    </thead>
</table>
<!-- //타이틀 박스 -->
<table class="tbl-layout"><!-- table-layout -->
    <colgroup>
        <col style="width:40%;">
        <col style="width:auto;">
    </colgroup>
    <tbody>
        <tr>
            <td class="first"><!-- first -->
                <!-- 대기자 목록 Start -->
                <div class="scroll-y" style="height:360px;">
                    <table class="tbl-list"><!-- tbl-list -->
                        <colgroup>
                            <col style="width: 30px;">
                            <col style="width: 90px;">
                            <col/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th><input type="checkbox" name="checkall" onclick="doChkAll(this,'UnassignTeamMemberArea')" /></th>
                                <th><spring:message code="필드:팀프로젝트:이름"/></th>
                                <th><spring:message code="필드:팀프로젝트:아이디" /></th>
                            </tr>
                        </thead>
                        <tbody id="UnassignTeamMemberArea">
                            <c:forEach var="row" items="${unAssignMemberList}" varStatus="i">
                            <tr id="<c:out value="${row.member.memberSeq}"/>">
                                <td>
                                    <input type="checkbox" name="checkkeys" value="<c:out value="${row.member.memberSeq}"/>" onclick="FN.onClickCheckbox(this)">
                                    <input type="hidden" name="unassignTeamMemberSeqs" value="<c:out value="${row.member.memberSeq}"/>">
                                    <input type="hidden" name="unassignTransferYns" value="N">
                                </td>
                                <td>
                                    <c:out value="${row.member.memberName}"/>
                                </td>
                                <td>
                                    <c:out value="${row.member.memberId}"/>
                                </td>
                                <td id="chifYnArea_<c:out value="${row.member.memberSeq}"/>" style="display: none;">
                                    <select name="unassignChiefYns" onchange="doChangeChief(this,<c:out value="${row.member.memberSeq}"/>)">
                                        <aof:code type="option" codeGroup="CHIF_YN" defaultSelected="N" removeCodePrefix="true"></aof:code>
                                    </select>
                                </td>
                                <td id="courseTeamArea_<c:out value="${row.member.memberSeq}"/>" style="display: none;">
                                    <select name="unassignCourseTeamSeqs">
                                        <c:forEach var="subRow" items="${teamList}" varStatus="i">
                                            <option value="${subRow.courseTeamProjectTeam.courseTeamSeq}" <c:if test="${projectTeamMamber.courseTeamSeq == subRow.courseTeamProjectTeam.courseTeamSeq}">selected="selected"</c:if>>${subRow.courseTeamProjectTeam.teamTitle}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            </c:forEach>
                            <tr id="UnassignNoDataArea" <c:if test="${not empty unAssignMemberList}">style="display: none;"</c:if>>
                                <td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- 대기자 목록 End -->
            </td>

            <td>
                <!--  팀원 목록 Start -->
                <div class="scroll-y" style="height:360px;">
                    <table class="tbl-list">
                        <colgroup>
                            <col style="width: 30px;">
                            <col style="width: 100px;">
                            <col/>
                            <col style="width: 70px">
                            <col style="width: 70px">
                        </colgroup>
                        <thead>
                             <tr>
                                <th><input type="checkbox" name="checkall" onclick="doChkAll(this,'AssignTeamMemberArea')" /></th>
                                <th><spring:message code="필드:팀프로젝트:이름"/></th>
                                <th><spring:message code="필드:팀프로젝트:아이디" /></th>
                                <th><spring:message code="필드:팀프로젝트:역활" /></th>
                                <th><spring:message code="필드:팀프로젝트:팀이동" /></th>
                            </tr>
                        </thead>
                        <tbody id="AssignTeamMemberArea">
                           <c:forEach var="row" items="${assignMemberList}" varStatus="i">
                            <tr id="<c:out value="${row.courseTeamProjectMember.teamMemberSeq}"/>">
                                <td>
                                    <input type="checkbox" name="checkkeys" value="<c:out value="${row.courseTeamProjectMember.teamMemberSeq}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
                                    <input type="hidden" name="assignTeamMemberSeqs" value="<c:out value="${row.courseTeamProjectMember.teamMemberSeq}"/>">
                                    <input type="hidden" name="oldAssignChiefYns" value="<c:out value="${row.courseTeamProjectMember.chiefYn}"/>">
                                    <input type="hidden" name="oldAssignCourseTeamSeqs" value="<c:out value="${row.courseTeamProjectMember.courseTeamSeq}"/>">
                                    <input type="hidden" name="assignTransferYns" value="N">
                                </td>
                                <td>
                                    <c:out value="${row.member.memberName}"/>
                                </td>
                                <td>
                                    <c:out value="${row.member.memberId}"/>
                                </td>
                                <td id="chifYnArea_<c:out value="${row.courseTeamProjectMember.teamMemberSeq}"/>">
                                
                                    <select name="assignChiefYns" onchange="doChangeChief(this,<c:out value="${row.courseTeamProjectMember.teamMemberSeq}"/>)">
                                        <aof:code type="option" codeGroup="CHIF_YN" selected="${row.courseTeamProjectMember.chiefYn}" removeCodePrefix="true"></aof:code>
                                    </select>
                                </td>
                                <td id="courseTeamArea_<c:out value="${row.courseTeamProjectMember.teamMemberSeq}"/>">
                                    <select name="assignCourseTeamSeqs" <c:if test="${row.courseTeamProjectMember.chiefYn eq 'Y'}">disabled="disabled"</c:if>>
                                        <c:forEach var="subRow" items="${teamList}" varStatus="i">
                                            <option value="${subRow.courseTeamProjectTeam.courseTeamSeq}" <c:if test="${row.courseTeamProjectMember.courseTeamSeq == subRow.courseTeamProjectTeam.courseTeamSeq}">selected="selected"</c:if>>${subRow.courseTeamProjectTeam.teamTitle}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            </c:forEach>
                            <tr id="AssignNoDataArea" <c:if test="${not empty assignMemberList}">style="display: none;"</c:if>>
                                <td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div><!-- //scroll-y -->
                <!--  팀원 목록 Start -->
            </td>
        </tr>
        <tr>
            <td>
                <div class="section-stats"><!-- section-stats -->
                    <span><spring:message code="필드:팀프로젝트:총"/> : </span>
                    <span class="count"><c:out value="${fn:length(unAssignMemberList)}"/><spring:message code="필드:팀프로젝트:명"/></span>
                </div>
                <div class="lybox-btn">
                    <div class="lybox-btn-r"><!-- lybox-btn-r -->
                        <a href="javascript:void(0)" onclick="doAssignMember()" class="btn gray" id="btnMoveRight" <c:if test="${empty unAssignMemberList}">style="display: none;"</c:if>>
                            <span class="mid">
                            <spring:message code="필드:팀프로젝트:지정"/>
                            >
                            </span>
                        </a>
                    </div>
                </div>
            </td>
            <td>
                <div class="section-stats"><!-- section-stats -->
                    <span><spring:message code="필드:팀프로젝트:총"/> : </span>
                    <span class="count"><c:out value="${fn:length(assignMemberList)}"/><spring:message code="필드:팀프로젝트:명"/></span>
                </div>
                <div class="lybox-btn">
                    <div class="lybox-btn-l">
                        <a href="javascript:void(0)" onclick="doUnassignMember()" class="btn gray" id="btnMoveLeft" <c:if test="${empty assignMemberList}">style="display: none;"</c:if>>
                            <span class="mid">
                                <
                            <spring:message code="필드:팀프로젝트:제외"/></span>
                        </a>
                    </div>
                    <div class="lybox-btn-r">
                        <a href="javascript:void(0)" onclick="doList()" class="btn gray" id="btnMoveRight" <c:if test="${empty assignMemberList}">style="display: none;"</c:if>>
                            <span class="mid">초기화</span>
                        </a>
                    </div>
                </div>
            </td>
        </tr>
    </tbody>
</table>
</form>
<div class="lybox-btn">
    <div class="lybox-btn-l">
                    ※ <spring:message code="글:팀프로젝트:그룹이동전[저장]버튼을클릭해야변경사항이반영됩니다."/>
    </div>
    <div class="lybox-btn-r">
        <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
            <a href="javascript:void(0)" onclick="doUpdateTeamMember()" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
        </c:if>
    </div>
</div>
</body>
</html>
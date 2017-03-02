<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata     = null;
var forSave       = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
	forListdata = $.action();
	forListdata.config.formId = "FormData";
	forListdata.config.url    = "<c:url value="/univ/competition/list.do"/>";
	
	forSave = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forSave.config.url             = "<c:url value="/univ/competition/update.do"/>";
    forSave.config.target          = "hiddenframe";
    forSave.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forSave.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forSave.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forSave.config.fn.complete     = function() {
    	doList();
    };
    
    
};

doList = function() {
	forListdata.run();
};

/** 학습일자 중복검사 후 저장*/
doCreate = function() {
	forSave.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list mt10">
	<colgroup>
		<col style="width: 80px" />
		<col style="width: 160px" />
	</colgroup>
	<thead>
	    <tr>
        	<td>대회여부</td>
        	<td>
				<aof:code type="radio" codeGroup="YESNO" name="competitionYn" defaultSelected="N" selected="${detail.competition.competitionYn}" removeCodePrefix="true"/>
			</td>
        </tr>
        <tr>
        	<td>대회상태</td>
        	<td>
				<aof:code type="radio" codeGroup="COMPETITION_STATUS_CD"	 name="competitionStatusCd" defaultSelected="BEFORE" selected="${detail.competition.competitionStatusCd}" removeCodePrefix="true"/>
			</td>
        </tr>
    </tbody>
	</table>
	</form>
	<div class="lybox-btn">
        <div class="lybox-btn-l">
        </div>
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
            </c:if>
        </div>
    </div>
</body>
</html>
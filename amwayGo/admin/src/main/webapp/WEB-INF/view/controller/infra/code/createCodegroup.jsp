<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/code/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/code/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = function(statusCode) {
		if(statusCode == ""){
			$.alert({
				message : "<spring:message code="글:저장되었습니다"/>",
				button1 : {
					callback : function() {
						doList();
					}
				}
			});
		} else {
			$.alert({
				message : "<spring:message code="글:코드:삭제된코드와중복혹은DBAccess에러입니다"/>"
			});
		}
	};

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		message : "<spring:message code="글:코드:코드중복검사를실시하십시오"/>",
		name : "duplicatedCode",
		check : {
			eq : "N"
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:코드:그룹코드명"/>",
		name : "codeName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:코드:코드"/>",
		name : "code",
		data : ["!null"],
		check : {
			maxlength : 50
		}
	});
};
/**
 * 저장
 */
doInsert = function() { 
	forInsert.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

/**
 * 코드중복검사
 */
doCheckDuplicate = function() {
	var form = UT.getById(forInsert.config.formId);	
	var codeVal = form.elements["code"].value;
	form.elements["code"].value = codeVal.toUpperCase();
	
	var action = $.action("ajax", {formId : "FormInsert"});
	action.config.type   = "json";
	action.config.url    = "<c:url value="/code/duplicate.do"/>";
	action.config.parameters = "codeGroup=" + codeVal.toUpperCase();
	action.validator.set({
		title : "<spring:message code="필드:코드:코드"/>",
		name : "code",
		data : ["!null"],
		check : {
			maxlength : 50
		}
	});
	
	action.config.fn.complete = function(action, data) {
		if (data.duplicated == true) {
			form.elements["duplicatedCode"].value = "Y";
			$.alert({
				message : "<spring:message code="글:코드:이미사용중인코드입니다"/>"
			});
		} else {
			form.elements["duplicatedCode"].value = "N";
			$.alert({
				message : "<spring:message code="글:코드:사용가능한코드입니다"/>" 
			});
		}
	};
	
	action.run();
};

/**
 * 아이디 변경됨
 */
 onChangeCode = function() {
	var form = UT.getById(forInsert.config.formId);
	form.elements["duplicatedCode"].value = "Y";
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCodegroup.jsp"/>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="duplicatedCode" value="Y">
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:코드:그룹코드명"/></th>
			<td><input type="text" name="codeName" maxlength="200"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:그룹코드"/></td>
			<td>
				<input type="text" name="code" maxlength="50" style="ime-mode:disabled;" onchange="onChangeCode()">
				<a href="javascript:void(0)" onclick="doCheckDuplicate()" class="btn gray"><span class="small"><spring:message code="버튼:중복검사"/></span></a>
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
                <a href="#" onclick="doInsert()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
            </c:if>
            <a href="#" onclick="doList()" class="btn blue"><span class="mid"><spring:message code="버튼:취소" /></span></a>
        </div>
    </div>
</body>
</html>
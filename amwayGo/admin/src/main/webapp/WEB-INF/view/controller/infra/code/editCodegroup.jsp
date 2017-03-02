<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
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
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/code/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function(statusCode) {
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
				message : "<spring:message code="글:코드:삭제된코드와중복혹은DBAccess에러입니다"/>".format({0:statusCode})
			});		
		}
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete";
	forDelete.config.url             = "<c:url value="/code/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:코드:그룹코드명"/>",
		name : "codeName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forUpdate.validator.set({
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
doUpdate = function() { 
	forUpdate.run();
};
/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCodegroup.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="codeGroup" value="<c:out value="${detail.code.codeGroup}"/>"/>
	<input type="hidden" name="code" value="<c:out value="${detail.code.code}"/>"/>
	<input type="hidden" name="sortOrder" value="<c:out value="${detail.code.sortOrder}"/>"/>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:코드:그룹코드명"/></th>
			<td><input type="text" name="codeName" value="<c:out value="${detail.code.codeName}"/>"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:그룹코드"/></td>
			<td>
				<c:out value="${detail.code.code}"/>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="codeGroup" value="<c:out value="${detail.code.codeGroup}"/>"/>
	</form>

    <div class="lybox-btn">
        <div class="lybox-btn-l">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
            <a href="#" onclick="doDelete()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
            </c:if>
        </div>
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
                <a href="#" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
            </c:if>
            <a href="#" onclick="doList()" class="btn blue"><span class="mid"><spring:message code="버튼:취소" /></span></a>
        </div>
    </div>
</body>
</html>
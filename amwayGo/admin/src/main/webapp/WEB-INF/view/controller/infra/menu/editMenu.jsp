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

	onChangeMenuId();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/menu/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/menu/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before     = function() {
		var form = UT.getById(forUpdate.config.formId);
		var menuId = form.elements["menuId"].value;
		var newMenuId = form.elements["newMenuId"].value;
		if (menuId == newMenuId) {
			form.elements["newMenuId"].value = "";
		}
		return true;
	};
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete";
	forDelete.config.url             = "<c:url value="/menu/delete.do"/>";
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
		title : "<spring:message code="필드:메뉴:메뉴아이디"/>",
		name : "newMenuId",
		data : ["!null", "!space", "number"],
		check : {
			maxlength : 20
		}
	});
	forUpdate.validator.set(function() {
		var form = UT.getById(forUpdate.config.formId);
		var newMenuId = form.elements["newMenuId"].value;
		if (newMenuId.length % 3 == 0) {
			return true;
		} else {
			$.alert({
				message : "<spring:message code="글:메뉴:메뉴아이디의자릿수는3의배수로구성되어야합니다"/>"
			});
			return false;
		}
	});
	forUpdate.validator.set({
		message : "<spring:message code="글:메뉴:메뉴아이디중복검사를실시하십시오"/>",
		name : "duplicatedMenuId",
		check : {
			eq : "N"
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:메뉴:메뉴명"/>",
		name : "menuName",
		data : ["!null"],
		check : {
			maxlength : 30
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:메뉴:url"/>",
		name : "url",
		data : ["!space"],
		check : {
			maxlength : 200
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:메뉴:urlTarget"/>",
		name : "urlTarget",
		check : {
			maxlength : 50
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:메뉴:설명"/>",
		name : "description",
		check : {
			maxbyte : 1000
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:메뉴:노출여부"/>",
		name : "displayYn",
		data : ["!null"]
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
/**
 * 아이디 변경됨
 */
onChangeMenuId = function() {
	var form = UT.getById(forUpdate.config.formId);
	var newMenuId = form.elements["newMenuId"].value;
	var menuId = form.elements["menuId"].value;
	if (menuId == newMenuId) {
		form.elements["duplicatedMenuId"].value = "N";
		jQuery("#duplicateCheckButton").hide();
	} else {
		form.elements["duplicatedMenuId"].value = "Y";
		jQuery("#duplicateCheckButton").show();
	}
	
};
/**
 * 중복검사
 */
doCheckDuplicate = function() {
	var form = UT.getById(forUpdate.config.formId);	
	var newMenuId = form.elements["newMenuId"].value;
	var menuId = form.elements["menuId"].value;
	if (menuId == newMenuId) {
		return;
	}
	
	var action = $.action("ajax");
	action.config.type   = "json";
	action.config.url    = "<c:url value="/menu/duplicate.do"/>";
	action.config.parameters = "menuId=" + newMenuId;

	action.config.fn.validate = function() {

		var msg = "";
		if (Global.validator.checker["!null"](newMenuId) == false) {
			msg = Global.validator.getMessage("!null", "<spring:message code="필드:메뉴:메뉴아이디"/>", "enter");

		} else if (Global.validator.checker["!space"](newMenuId) == false) {
			msg = Global.validator.getMessage("!space", "<spring:message code="필드:메뉴:메뉴아이디"/>", "enter");

		} else if (Global.validator.checker["number"](newMenuId) == false) {
			msg = Global.validator.getMessage("number", "<spring:message code="필드:메뉴:메뉴아이디"/>", "enter");

		} else if (newMenuId.length % 3 != 0) {
			msg = "<spring:message code="글:메뉴:메뉴아이디의자릿수는3의배수로구성되어야합니다"/>";
		}
		
		if (msg != "") {
			$.alert({
				message : msg, 
				button1 : {
					callback : function() {
						form.elements["newMenuId"].focus();
					}
				}
			});
			return false;	
		}
		return true;
	};
	action.config.fn.complete = function(action, data) {
		if (data.duplicated == true) {
			form.elements["duplicatedMenuId"].value = "Y";
			$.alert({
				message : "<spring:message code="글:메뉴:이미사용중인아이디입니다"/>"
			});
		} else {
			form.elements["duplicatedMenuId"].value = "N";
			$.alert({
				message : "<spring:message code="글:메뉴:사용가능한아이디입니다"/>" 
			});
		}
	};
	action.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchMenu.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="duplicatedMenuId" value="N">
	<input type="hidden" name="menuId" value="<c:out value="${detail.menu.menuId}"/>">
	<input type="hidden" name="menuSeq" value="<c:out value="${detail.menu.menuSeq}"/>">
	<input type="hidden" name="dependent" value="<c:out value="${detail.menu.dependent}"/>">
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:메뉴:메뉴아이디"/></th>
			<td>
				<input type="text" name="newMenuId" value="<c:out value="${detail.menu.menuId}"/>" onchange="onChangeMenuId()">
				<a href="javascript:void(0)" id="duplicateCheckButton" onclick="doCheckDuplicate()" class="btn gray"><span class="small"><spring:message code="버튼:중복검사"/></span></a>
				<span class="comment"><spring:message code="글:메뉴:메뉴아이디는대중소3자리씩구성됩니다" /></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:메뉴명"/></td>
			<td><input type="text" name="menuName" value="<c:out value="${detail.menu.menuName}"/>" style="width:350px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:url"/></td>
			<td><input type="text" name="url" value="<c:out value="${detail.menu.url}"/>" style="width:350px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:urlTarget"/></td>
			<td><input type="text" name="urlTarget" value="<c:out value="${detail.menu.urlTarget}"/>"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:설명"/></td>
			<td><textarea name="description" style="width:350px;height:50px;"><c:out value="${detail.menu.description}"/></textarea></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:노출여부"/></td>
			<td>
				<c:if test="${detail.menu.mandatoryYn ne 'Y'}">
					<aof:code type="radio" codeGroup="YESNO" name="displayYn" selected="${detail.menu.displayYn}" removeCodePrefix="true"/>
				</c:if>
				<c:if test="${detail.menu.mandatoryYn eq 'Y'}">
					<input type="hidden" name="displayYn" value="${detail.menu.displayYn}"/>
					<aof:code type="print" codeGroup="YESNO" name="displayYn" selected="${detail.menu.displayYn}" removeCodePrefix="true"/>
				</c:if>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="menuSeq" value="<c:out value="${detail.menu.menuSeq}"/>">
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<c:if test="${detail.menu.mandatoryYn ne 'Y'}">
					<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
				</c:if>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
		
	
</body>
</html>
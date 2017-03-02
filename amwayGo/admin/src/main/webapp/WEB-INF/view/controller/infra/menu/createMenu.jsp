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
	forListdata.config.url    = "<c:url value="/menu/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/menu/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = function() {
		doList();
	};

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:메뉴:메뉴아이디"/>",
		name : "menuId",
		data : ["!null", "!space", "number"],
		check : {
			maxlength : 20
		}
	});
	forInsert.validator.set(function() {
		var form = UT.getById(forInsert.config.formId);
		var menuId = form.elements["menuId"].value;
		if (menuId.length % 3 == 0) {
			return true;
		} else {
			$.alert({
				message : "<spring:message code="글:메뉴:메뉴아이디의자릿수는3의배수로구성되어야합니다"/>"
			});
			return false;
		}
	});
	forInsert.validator.set({
		message : "<spring:message code="글:메뉴:메뉴아이디중복검사를실시하십시오"/>",
		name : "duplicatedMenuId",
		check : {
			eq : "N"
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:메뉴:메뉴명"/>",
		name : "menuName",
		data : ["!null"],
		check : {
			maxlength : 30
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:메뉴:url"/>",
		name : "url",
		data : ["!space"],
		check : {
			maxlength : 200
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:메뉴:urlTarget"/>",
		name : "urlTarget",
		check : {
			maxlength : 50
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:메뉴:설명"/>",
		name : "description",
		check : {
			maxbyte : 1000
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:메뉴:노출여부"/>",
		name : "displayYn",
		data : ["!null"]
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
 * 아이디 변경됨
 */
onChangeMenuId = function() {
	var form = UT.getById(forInsert.config.formId);
	form.elements["duplicatedMenuId"].value = "Y";
};
/**
 * 중복검사
 */
doCheckDuplicate = function() {
	var form = UT.getById(forInsert.config.formId);	
	var menuId = form.elements["menuId"].value;

	var action = $.action("ajax");
	action.config.type   = "json";
	action.config.url    = "<c:url value="/menu/duplicate.do"/>";
	action.config.parameters = "menuId=" + menuId;

	action.config.fn.validate = function() {

		var msg = "";
		if (Global.validator.checker["!null"](menuId) == false) {
			msg = Global.validator.getMessage("!null", "<spring:message code="필드:메뉴:메뉴아이디"/>", "enter");

		} else if (Global.validator.checker["!space"](menuId) == false) {
			msg = Global.validator.getMessage("!space", "<spring:message code="필드:메뉴:메뉴아이디"/>", "enter");

		} else if (Global.validator.checker["number"](menuId) == false) {
			msg = Global.validator.getMessage("number", "<spring:message code="필드:메뉴:메뉴아이디"/>", "enter");

		} else if (menuId.length % 3 != 0) {
			msg = "<spring:message code="글:메뉴:메뉴아이디의자릿수는3의배수로구성되어야합니다"/>";
		}
		
		if (msg != "") {
			$.alert({
				message : msg, 
				button1 : {
					callback : function() {
						form.elements["menuId"].focus();
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
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchMenu.jsp"/>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="duplicatedMenuId" value="Y">
	<input type="hidden" name="dependent" value="">
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:메뉴:메뉴아이디"/></th>
			<td>
				<input type="text" name="menuId" onchange="onChangeMenuId()">
				<a href="javascript:void(0)" onclick="doCheckDuplicate()" class="btn gray"><span class="small"><spring:message code="버튼:중복검사"/></span></a>
				<span class="comment"><spring:message code="글:메뉴:메뉴아이디는대중소3자리씩구성됩니다" /></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:메뉴명"/></td>
			<td><input type="text" name="menuName" style="width:350px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:url"/></td>
			<td><input type="text" name="url" style="width:350px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:urlTarget"/></td>
			<td><input type="text" name="urlTarget"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:설명"/></td>
			<td><textarea name="description"  style="width:350px;height:50px;"></textarea></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:노출여부"/></td>
			<td><aof:code type="radio" codeGroup="YESNO" name="displayYn" defaultSelected="Y" removeCodePrefix="true"/></td>
		</tr>
	</tbody>
	</table>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>
<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSubUpdatelist = null;
initSubPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doSubInitializeLocal();

};
/**
 * 설정
 */
doSubInitializeLocal = function() {

	forSubUpdatelist = $.action("submit", {formId : "SubFormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forSubUpdatelist.config.url             = "<c:url value="/rolegroup/menu/updatelist.do"/>";
	forSubUpdatelist.config.target          = "hiddenframe";
	forSubUpdatelist.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forSubUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubUpdatelist.config.fn.complete     = doSubCompleteUpdatelist;
};
/**
 * 목록에서 저장할 때 호출되는 함수
 */
doSubUpdatelist = function() { 
	forSubUpdatelist.run();
};
/**
 * 목록저장 완료
 */
doSubCompleteUpdatelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가저장되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doRolegroupMenuRefresh();
			}
		}
	});
};
/**
 * 권한 선택
 */
doClickCrud = function(element, type) {
	var crud = [];
	var $element = jQuery(element);
	//필수 메뉴인지 확인후 필수 메뉴이면 읽기 권한 해제를 못하게 합니다.
	if($element.siblings(":input[name='menuMandatoryYn']").val() == 'Y' && element.value == 'R'){
		if (element.checked == false){
			element.checked = true;
			if(type == 'solo'){
				$.alert({
			         message : "<spring:message code="글:메뉴:읽기권한필수메뉴입니다"/>"
			      });
			}
		}
	}
	
	
	if (element.checked == true) {
		crud.push(element.value);
	}	
	
	$element.siblings(":checkbox").each(function() {
		if (this.checked == true) {
			crud.push(this.value);
		}
	});
	if (crud.length > 0) {
		var $tr = $element.closest("tr");
		if ($tr.hasClass("selected") == false) {
			$tr.addClass("selected");
		}
		var thisDepth = parseInt($element.siblings(":input[name='depth']").val(), 10);
		if (thisDepth > 1) {
			$tr.prevAll().each(function() {
				var $this = jQuery(this);
				var parentDepth = $this.find(":input[name='depth']").val();
				if (parentDepth < thisDepth) {
					$this.find(":checkbox[value='R']").each(function() {
						if (this.checked == false) {
							this.checked = true;
							doClickCrud(this);
						}
					});
					return false;
				}
			});
		}
	} else {
		var $tr = $element.closest("tr");
		if ($tr.hasClass("selected") == true) {
			$tr.removeClass("selected");
		}
		var thisDepth = parseInt($element.siblings(":input[name='depth']").val(), 10);
		$tr.nextAll().each(function() {
			var $this = jQuery(this);
			var parentDepth = $this.find(":input[name='depth']").val();
			if (parentDepth > thisDepth) {
				$this.find(":checkbox").each(function() {
					this.checked = false;
				});
				$this.find(":checkbox").each(function() {
					doClickCrud(this);
				});
			} else {
				return false;
			}
		});
	}
	$element.siblings(":input[name='cruds']").val(crud.join(","));
};
/**
 * 전체선택/전체해제
 */
doCheckAll = function(element) {
	
	var $form = jQuery("#" + forSubUpdatelist.config.formId);
	$form.find(".crud").each(function() {
		if (this.value == element.value) {
			this.checked = element.checked;
		}
	});
	
	$form.find(".crud").each(function() {
		if (this.value == element.value) {
			doClickCrud(this,'all');
		}
	});
	
};
</script>
<style>
.selected {background-color:#eeeeee;}
</style>
</head>

<body>

<form id="SubFormData" name="SubFormData" method="post" onsubmit="return false;">
<table id="listTable" class="tbl-list">
<colgroup>
	<col style="width: 50px" />
	<col style="width: 120px" />
	<col style="width: auto" />
<!-- 	<col style="width: 100px" /> -->
	<col style="width: auto" />
	<col style="width: 280px" />
</colgroup>
<thead>
	<tr>
		<th><spring:message code="필드:번호" /></th>
		<th><spring:message code="필드:메뉴:메뉴아이디" /></th>
		<th><spring:message code="필드:메뉴:메뉴명" /></th>
		<%-- <th><spring:message code="필드:메뉴:필수여부" /></th> --%>
		<th><spring:message code="필드:메뉴:url" /></th>
		<th><aof:code type="checkbox" codeGroup="CRUD" name="check" onclick="doCheckAll(this)" labelStyle="margin-right:3px;" removeCodePrefix="true"/></th>
	</tr>
</thead>
<tbody>
<c:forEach var="row" items="${list}" varStatus="i">
	<c:set var="depth" value="${aoffn:toInt(fn:length(row.menu.menuId)/3)}"/>
	<tr class="<c:out value="${!empty row.rolegroupMenu.crud ? 'selected' : ''}"/>">
        <td><c:out value="${i.count}"/></td>
        <td class="align-l"><c:out value="${row.menu.menuId}"/></td>
		<td class="align-l">
			<div style="padding-left:<c:out value="${(depth - 1) * 15}"/>px;">
				<c:out value="${row.menu.menuName}"/>
			</div>
		</td>
		<td style="display: none;">
			<select name="mandatoryYns">${row.rolegroupMenu.mandatoryYn}
				<aof:code type="option" codeGroup="YESNO" removeCodePrefix="true" defaultSelected="N" selected="${row.rolegroupMenu.mandatoryYn}"/>
			</select>
		</td>
		<td class="align-l"><c:out value="${row.menu.url}"/></td>
		<td>
			<input type="hidden" name="rolegroupSeqs" value="<c:out value="${appRolegroupSeq}" />">
			<input type="hidden" name="menuSeqs" value="<c:out value="${row.menu.menuSeq}"/>">
			<input type="hidden" name="oldCruds" value="<c:out value="${row.rolegroupMenu.crud}"/>"/>
			<input type="hidden" name="oldMandatoryYns" value="<c:out value="${row.rolegroupMenu.mandatoryYn}"/>"/>
			<input type="hidden" name="menuMandatoryYn" value="<c:out value="${row.menu.mandatoryYn}"/>"/><!-- 롤그룹에서 해당 메뉴를 제거 하지 못하게 하기위한 값입니다. 해당 값은 UI상으로 컨트롤 안되며 개발자가 지정한 값입니다. -->
			<input type="hidden" name="cruds" value="<c:out value="${row.rolegroupMenu.crud}"/>"/>
			<input type="hidden" name="depth" value="<c:out value="${depth}"/>"/>
			<c:choose>
				<c:when test="${row.menu.mandatoryYn eq 'Y'}"><!-- 필수메뉴 읽기 기본값 셋팅 되게 하기 위한 구분 -->
					<c:if test="${empty row.rolegroupMenu.crud}">
						<aof:code type="checkbox" codeGroup="CRUD" name="crud-${row.menu.menuId}" selected="R" onclick="doClickCrud(this,'solo')" removeCodePrefix="true" styleClass="crud" labelStyle="margin-right:3px;"/>
					</c:if>
					<c:if test="${not empty row.rolegroupMenu.crud}">
						<aof:code type="checkbox" codeGroup="CRUD" name="crud-${row.menu.menuId}" selected="${row.rolegroupMenu.crud}" onclick="doClickCrud(this,'solo')" removeCodePrefix="true" styleClass="crud" labelStyle="margin-right:3px;"/>
					</c:if>
				</c:when>
				<c:otherwise>
					<aof:code type="checkbox" codeGroup="CRUD" name="crud-${row.menu.menuId}" selected="${row.rolegroupMenu.crud}" onclick="doClickCrud(this,'solo')" removeCodePrefix="true" styleClass="crud" labelStyle="margin-right:3px;"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
</c:forEach>
<c:if test="${empty list}">
	<tr>
		<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
	</tr>
</c:if>
</table>
</form>

<div class="lybox-btn">
	<div class="lybox-btn-r">
		<c:if test="${!empty list and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
			<a href="javascript:void(0)" onclick="doSubUpdatelist()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
		</c:if>
	</div>
</div>


<script type="text/javascript">
initSubPage();
</script>
</body>
</html>
<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forInsert   = null;
var forDeletelist = null;
var forUpdatelist = null;
var forScript = null;
initSubPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doSubInitializeLocal();

};
/**
 * 설정
 */
doSubInitializeLocal = function() {

	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/category/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before     = function() {
		var form = UT.getById(forInsert.config.formId);
		var level = form.elements["groupLevel"].value; 
		if (parseInt(level, 10) == 1) {
			form.elements["categoryString"].value = form.elements["categoryName"].value; 
		} else {
			form.elements["categoryString"].value = form.elements["categoryString"].value + "::" + form.elements["categoryName"].value;
		}
		return true;
	};
	forInsert.config.fn.complete     = function() {
		doListRefresh();
		doDetail();
	};

	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/category/deletelist.do"/>";
	forDeletelist.config.target          = "hiddenframe";
	forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelist.config.fn.complete     = doCompleteDeletelist;
	
	forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelist.config.url             = "<c:url value="/category/updatelist.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdatelist.config.message.success = "<spring:message code="글:저장되었습니다"/>"; 
	forUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelist.config.fn.before       = function() {
		var $form = jQuery("#" + forUpdatelist.config.formId);
		$form.find(":input[name='categoryNames']").each(function() {
			var $this = jQuery(this);
			var $string = $this.siblings(":input[name='categoryStrings']");
			var $oldName = $this.siblings(":input[name='oldCategoryNames']");
			
			if ($this.val() != $oldName.val()) {
				var path = [].concat($string.val().split("::"));
				if (path.length > 0) {
					path.pop(); // 마지막것 제거
				}
				path.push($this.val());
				$string.val(path.join("::"));
			}			
		});
		return true;
	};
	forUpdatelist.config.fn.complete     = function() {
		doListRefresh();
		doDetail();
	};
	
	forScript = $.action("script", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	
	setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:분류:분류제목"/>",
		name : "categoryName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});

	forDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	forDeletelist.validator.set(function() {
		var $form = jQuery("#" + forDeletelist.config.formId);
		var result = true;
		$form.find(":input[name='checkkeys']").filter(":checked").each(function() {
			var $this = jQuery(this);
			var useYn = $this.siblings(":input[name='useYn']").val();
			if (useYn == "Y") {
				result = false;
				return false;
			}
		});
		if (result == false) {
			$.alert({message : "<spring:message code="글:분류:사용중인분류는삭제할수없습니다"/>"});
			return false;
		} else {
			return true;
		}
	});

	forScript.validator.set({
		title : "<spring:message code="필드:이동할데이터"/>",
		name : "checkkeys",
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
 * 목록에서 삭제할 때 호출되는 함수
 */
doDeletelist = function() { 
	forDeletelist.run();
};
/**
 * 목록삭제 완료
 */
doCompleteDeletelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가삭제되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doListRefresh();
				doDetail();
			}
		}
	});
};
/**
 * 위로
 */
doUp = function() {
	var valid = forScript.validator.isValid();
	if (valid == false) {
		return;
	}
	var selects = new Array();
	jQuery("#" + forScript.config.formId + " :input[name=checkkeys]").each(
		function() {
			if (this.checked == true) {
				selects.push(jQuery(this).closest("tr").get(0));
			}
		}
	);
	var firstRow = null;
	var table = null;
	jQuery(selects).each(
		function() {
			table = jQuery(this).closest("table").get(0);
			if (this.rowIndex == 1) {
				firstRow = this;
				return;
			} 
			UT.moveTableRow(table, this.rowIndex, this.rowIndex - 1);
		}
	);
	if (firstRow != null) {
		UT.moveTableRow(table, firstRow.rowIndex, 1);
	}
};
/**
 * 아래로
 */
doDown = function() {
	var valid = forScript.validator.isValid();
	if (valid == false) {
		return;
	}
	var selects = new Array();
	jQuery("#" + forScript.config.formId + " :input[name=checkkeys]").each(
		function() {
			if (this.checked == true) {
				selects.push(jQuery(this).closest("tr").get(0));
			}
		}
	);
	var lastRow = null;
	var table = null;
	jQuery(selects.reverse()).each(
		function() {
			table = jQuery(this).closest("table").get(0);
			if (this.rowIndex == table.rows.length - 1) {
				lastRow = this;
				return;
			}
			UT.moveTableRow(table, this.rowIndex, this.rowIndex + 1);
		}
	);
	if (lastRow != null) {
		UT.moveTableRow(table, lastRow.rowIndex, table.rows.length - 1);
	}
};
/**
 * 순서 수정하기
 */
doUpdatelist = function() {
	var $form = jQuery("#" + forUpdatelist.config.formId);
	$form.find(":input[name=sortOrders]").each(function(index) {
		this.value = index + 1;
	});
	forUpdatelist.run();
}; 
</script>
</head>

<body>

	<c:set var="migCategorySeq" value=""/>
	<c:set var="categorySeq" value="0"/>
	<c:set var="groupSeq" value="0"/>
	<c:set var="groupLevel" value="1"/>
	<c:set var="categoryTypeCd" value="${condition.srchCategoryTypeCd}"/>
	<c:set var="categoryName"><spring:message code="글:분류:최상위"/></c:set>
	<c:set var="categoryString" value=""/>
	<c:if test="${!empty detail}">
		<c:set var="migCategorySeq"><c:out value="${detail.category.migCategorySeq}"/></c:set>
		<c:set var="categorySeq"><c:out value="${detail.category.categorySeq}"/></c:set>
		<c:set var="groupSeq"><c:out value="${detail.category.groupSeq}"/></c:set>
		<c:set var="groupLevel"><c:out value="${detail.category.groupLevel + 1}"/></c:set>
		<c:set var="categoryName"><c:out value="${detail.category.categoryName}"/></c:set>
		<c:set var="categoryTypeCd"><c:out value="${detail.category.categoryTypeCd}"/></c:set>
		<c:set var="categoryString"><c:out value="${detail.category.categoryString}"/></c:set>
	</c:if>

	<c:choose>
	<c:when test="${categoryTypeCd ne CD_CATEGORY_TYPE_DEGREE}">
		<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
		<input type="hidden" name="parentSeq" value="<c:out value="${categorySeq}"/>">
		<input type="hidden" name="groupSeq" value="<c:out value="${groupSeq}"/>">
		<input type="hidden" name="groupLevel" value="<c:out value="${groupLevel}"/>">
		<input type="hidden" name="categoryTypeCd" value="<c:out value="${categoryTypeCd}"/>">
		<input type="hidden" name="categoryString" value="<c:out value="${categoryString}"/>">
		
		<table class="tbl-detail-row">
		<colgroup>
			<col style="width:20%;" />
			<col style="width:auto;" />
		</colgroup>
		<thead>
			<tr>
				<th colspan="2">
					<strong id="categoryName"><c:out value="${categoryName}"/></strong><span style="font-weight:normal;"><spring:message code="글:분류:에분류추가"/></span>
				</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><spring:message code="필드:분류:분류제목"/></td>
				<td class="align-l">
					<input type="text" name="categoryName" style="width:60%">
					<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
						<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
					</c:if>
				</td>
			</tr>
		</tbody>
		</table>
		</form>
	
		<div class="vspace"></div>
		<div class="lybox-title">
			<h4 class="section-title"><spring:message code="글:분류:하위분류"/></h4>
		</div>
		<form id="FormData" name="FormData" method="post" onsubmit="return false;">
			<input type="hidden" name="groupLevel" value="<c:out value="${groupLevel}"/>">
			<table id="listTable" class="tbl-list">
			<colgroup>
				<col style="width:10%;" />
				<col style="width:auto;" />
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
					<th><spring:message code="필드:분류:분류제목"/></th>
				</tr>
			<thead>
			<tbody>
			<c:forEach var="row" items="${listCategory}" varStatus="i">
				<tr>
					<td>
						<c:set var="display" value=""/>
						<c:if test="${!empty row.category.migCategorySeq}">
							<c:set var="display" value="display:none;"/>
						</c:if>
						<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')"
							style="<c:out value="${display}"/>"
						>
						<input type="hidden" name="categorySeqs" value="<c:out value="${row.category.categorySeq}" />">
						<input type="hidden" name="sortOrders" value="<c:out value="${row.category.sortOrder}"/>">
						<c:choose>
							<c:when test="${row.category.useCount gt 0 or row.category.childCount gt 0}">
								<input type="hidden" name="useYn" value="Y">
							</c:when>
							<c:otherwise>
								<input type="hidden" name="useYn" value="N">
							</c:otherwise>
						</c:choose>
					</td>
					<td class="align-l">
						<input type="hidden" name="oldCategoryStrings" value="<c:out value="${row.category.categoryString}"/>">
						<input type="hidden" name="oldCategoryNames" value="<c:out value="${row.category.categoryName}"/>">
						<input type="hidden" name="categoryStrings" value="<c:out value="${row.category.categoryString}"/>">
						<input type="text" name="categoryNames" value="<c:out value="${row.category.categoryName}" />" style="width:95%">
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty listCategory}">
				<tr>
					<td colspan="2" align="center"><spring:message code="글:데이터가없습니다" /></td>
				</tr>
			</c:if>
			</table>
		</form>
	
		<div class="lybox-btn">	
			<div class="lybox-btn-l" id="checkButton" style="display:none;">
				<c:if test="${!empty listCategory and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
					<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
				</c:if>
				<c:if test="${aoffn:size(listCategory) ge 2 and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
					<a href="javascript:void(0)" onclick="doUp()" class="btn blue"><span class="mid"><spring:message code="버튼:위로"/></span></a>
					<a href="javascript:void(0)" onclick="doDown()" class="btn blue"><span class="mid"><spring:message code="버튼:아래로"/></span></a>
				</c:if>
			</div>
			<div class="lybox-btn-r">
				<c:if test="${!empty listCategory and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
					<a href="javascript:void(0)" onclick="doUpdatelist()" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
				</c:if>
			</div>
			
		</div>
	</c:when>
	<c:otherwise>
	
		<table class="tbl-detail">
		<colgroup>
			<col style="width:20%;" />
			<col style="width:auto;" />
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:분류:분류제목"/></th>
				<td>
					<c:out value="${detail.category.categoryName}"/>
					<c:if test="${!empty detail.category.migCategorySeq}">
						(<c:out value="${detail.category.migCategorySeq}"/>)
					</c:if>
				</td>
			</tr>
		</tbody>
		</table>
	
		<div class="vspace"></div>
		<div class="lybox-title">
			<h4 class="section-title"><spring:message code="글:분류:하위분류"/></h4>
		</div>
		<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width:30%;" />
			<col style="width:auto;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:교과목그룹:학사코드"/></th>
				<th><spring:message code="필드:분류:분류제목"/></th>
			</tr>
		<thead>
		<tbody>
		<c:forEach var="row" items="${listCategory}" varStatus="i">
			<tr>
				<td><c:out value="${row.category.migCategorySeq}" /></td>
				<td class="align-l"><c:out value="${row.category.categoryName}" /></td>
			</tr>
		</c:forEach>
		<c:if test="${empty listCategory}">
			<tr>
				<td colspan="2" class="align-c"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
		</c:if>
		</table>
	</c:otherwise>
	</c:choose>
	
	<script type="text/javascript">
	initSubPage();
	</script>
</body>
</html>
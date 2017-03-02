<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="rootCategorySeq" value="0"/>
<c:set var="rootCategoryLevel" value="0"/>
<c:set var="rootCategoryName" value=""/>
<c:if test="${!empty detailRoot}">
	<c:set var="rootCategorySeq" value="${detailRoot.category.categorySeq}"/>
	<c:set var="rootCategoryLevel" value="${detailRoot.category.groupLevel}"/>
	<c:set var="rootCategoryName" value="${detailRoot.category.categoryName}"/>
</c:if>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doList('<c:out value="${rootCategorySeq}"/>', '<c:out value="${rootCategoryLevel}"/>');
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action("ajax");
	forListdata.config.formId      = "FormList";
	forListdata.config.url         = "<c:url value="/category/list/ajax.do"/>";
	forListdata.config.type        = "html";
	forListdata.config.fn.complete = function() {};
	
};
/**
 * 트리에서 하위 목록(펼치기)
 */
doList = function(seq, level) {
	var form = UT.getById(forListdata.config.formId);
	if (seq != null && level != null) {
		form.elements["srchParentSeq"].value = seq;
		form.elements["srchGroupLevel"].value = parseInt(level, 10) + 1;
	} else {
		seq = form.elements["srchParentSeq"].value;
		level = form.elements["srchGroupLevel"].value;
	}
	forListdata.config.containerId = "category-" + seq; 
	var $container = jQuery("#" + forListdata.config.containerId);

	$container.closest("ul").prev().find("a").each(function(index) {
		if (index == 1) {
			jQuery(this).hide();
		} else {
			jQuery(this).show();
		}
	});

	setTimeout(function() {	
		forListdata.run();
	}, 100);
};
/**
 * 하위 트리 접기
 */
doHide = function(element) {
	var $element = jQuery(element);
	$element.hide();
	$element.next().show();
	var $container = $element.closest("ul").next();
	$container.hide();
};
/**
 * 분류선택
 */
doDetail = function(element, returnValue) {
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this, returnValue);
	}
	$layer.dialog("close");
};
/**
 * 목록데이타 없음.
 */
doNoListdata = function() {
	if (typeof forListdata.config.containerId === "string") {
		var $container = jQuery("#" + forListdata.config.containerId);
		$container.hide();
	}
};
</script>
</head>

<body>

	<form id="FormList" name="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="srchCategoryTypeCd" value="<c:out value="${category.categoryTypeCd}"/>">
		<input type="hidden" name="srchParentSeq">
		<input type="hidden" name="srchGroupLevel">
		<input type="hidden" name="limitCategoryLevel" value="<c:out value="${param['limitCategoryLevel']}"/>">
	</form>
	
	<table class="tbl-detail">
	<tbody>
		<tr>
			<td>
				<div class="scroll-y" style="height:330px;">
					<div class="group-list">
						<ul>
							<li style="padding:3px 0;">
								<a href="javascript:void(0)" onclick="doHide(this)" style="display:none;"><aof:img src="icon/tree_branch_closed.gif" style="width:11px;height:13px;"/></a>
								<a href="javascript:void(0)" onclick="doList('<c:out value="${rootCategorySeq}"/>', '<c:out value="${rootCategoryLevel}"/>')" id="root"><aof:img src="icon/tree_branch_opened.gif" style="width:15px;height:15px;"/></a>
								<a href="javascript:void(0)" id="rootTitle" style="cursor:default;"><c:out value="${rootCategoryName}"/></a>
							</li>
						</ul>
						<ul id="category-<c:out value="${rootCategorySeq}"/>" style="display:none;padding-left:20px;"></ul>
					</div>
				</div>
			</td>
		</tr>
	</tbody>
	</table>

</body>
</html>
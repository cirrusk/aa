<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doList('0', '0');
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
		form.elements["srchLevel"].value = parseInt(level, 10) + 1;
	} else {
		seq = form.elements["srchParentSeq"].value;
		level = form.elements["srchLevel"].value;
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
		<input type="hidden" name="srchCategoryType" value="<c:out value="${category.categoryType}"/>">
		<input type="hidden" name="srchParentSeq">
		<input type="hidden" name="srchLevel">
		<input type="hidden" name="limitCategoryLevel" value="<c:out value="${param['limitCategoryLevel']}"/>">
	</form>
	
	<table class="tbl-detail">
	<tbody>
		<tr>
			<td style="vertical-align:top;height:300px;overflow-x:hidden;overflow-y:auto">
				<div>
					<ul>
						<li>
							<a href="javascript:void(0)" onclick="doHide(this)" style="display:none;"><aof:img src="icon/tree_branch_closed.gif"/></a>
							<a href="javascript:void(0)" onclick="doList('0', '0')" id="root"><aof:img src="icon/tree_branch_opened.gif"/></a>
							<a href="javascript:void(0)" id="rootTitle" style="cursor:default;"><spring:message code="글:분류:최상위"/></a>
						</li>
					</ul>
					<ul id="category-0" style="display:none;padding-left:20px;"></ul>
				</div>

			</td>
		</tr>
	</tbody>
	</table>

</body>
</html>
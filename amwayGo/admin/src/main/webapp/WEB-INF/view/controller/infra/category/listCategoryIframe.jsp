<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE"        value="${aoffn:code('CD.CATEGORY_TYPE')}"/>
<c:set var="CD_CATEGORY_TYPE_ADDSEP" value="${CD_CATEGORY_TYPE}::"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

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
<%-- 공통코드 --%>
var CD_CATEGORY_TYPE_ADDSEP = "<c:out value="${CD_CATEGORY_TYPE_ADDSEP}"/>";

var forListdata = null;
var forListdataRefresh = null;
var forDetaildata = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doStartRoot();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forDetaildata = $.action("ajax");
	forDetaildata.config.formId      = "FormDetail";
	forDetaildata.config.url         = "<c:url value="/category/detail/ajax.do"/>";
	forDetaildata.config.type        = "html";
	forDetaildata.config.containerId = "containerRight"; 
	forDetaildata.config.fn.before = function() {
		jQuery("#" + forDetaildata.config.formId).find(":input[name='srchYearTerm']").val(jQuery("#" + forListdata.config.formId).find(":input[name='srchYearTerm']").val());
		return true;
	};
	forDetaildata.config.fn.complete = function() {};
	
	forListdata = $.action("ajax");
	forListdata.config.formId      = "FormList";
	forListdata.config.url         = "<c:url value="/category/list/ajax.do"/>";
	forListdata.config.type        = "html";
	forListdata.config.fn.complete = function() {};
	
	forListdataRefresh = $.action("ajax");
	forListdataRefresh.config.formId      = "FormListRefresh";
	forListdataRefresh.config.url         = "<c:url value="/category/list/ajax.do"/>";
	forListdataRefresh.config.type        = "html";
	forListdataRefresh.config.fn.before = function() {
		jQuery("#" + forListdataRefresh.config.formId).find(":input[name='srchYearTerm']").val(jQuery("#" + forListdata.config.formId).find(":input[name='srchYearTerm']").val());
		return true;
	};
	forListdataRefresh.config.fn.complete = function() {};

};
/**
 * 상세정보(오른쪽 신규등록화면/목록수정화면)
 */
doDetail = function(element, mapPKs) {
	if (mapPKs != null) {
		// 상세화면 form을 reset한다.
		UT.getById(forDetaildata.config.formId).reset();
		// 상세화면 form에 키값을 셋팅한다.
		UT.copyValueMapToForm(mapPKs, forDetaildata.config.formId);
		
		// 목록화면 form에 키값을 셋팅한다.
		if (mapPKs.categorySeq != null && mapPKs.groupLevel != null) {
			mapPKs["srchParentSeq"] = mapPKs.categorySeq;
			mapPKs["srchGroupLevel"] = parseInt(mapPKs.groupLevel, 10) + 1;
			UT.copyValueMapToForm(mapPKs, forListdataRefresh.config.formId);
		}
	}
	// 상세화면 실행
	forDetaildata.run();
	if (element != null) {
		jQuery(".selected").removeClass("selected");
		jQuery(element).addClass("selected");
	}
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
 * 트리에서 하위 목록(펼치기) - 등록/수정 후 새로고침
 */
doListRefresh = function() {
	var form = UT.getById(forListdataRefresh.config.formId);
	var seq = form.elements["srchParentSeq"].value;
	var level = form.elements["srchGroupLevel"].value;

	if (parseInt(level, 10) == 1) {
		var action = $.action();
		action.config.formId = "FormReload";
		action.config.url = "<c:url value="/category/{0}/list/iframe.do"/>".format({0:"<c:out value="${category.categoryTypeCd}"/>".replace(CD_CATEGORY_TYPE_ADDSEP, "").toLowerCase()});
		action.run();
	} else {
		forListdataRefresh.config.containerId = "category-" + seq; 
		var $container = jQuery("#" + forListdataRefresh.config.containerId);
		$container.closest("ul").prev().children("a").each(function(index) {
			if (index == 1) {
				jQuery(this).hide();
			} else {
				jQuery(this).show();
			}
		});
		setTimeout(function() {	
			forListdataRefresh.run();
		}, 100);
	}
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
 * 목록데이타 없음.
 */
doNoListdata = function() {
	if (typeof forListdata.config.containerId === "string") {
		var $container = jQuery("#" + forListdata.config.containerId);
		$container.hide();
	}
};
/**
 * 루트 분류 시작 
 */
doStartRoot = function() {
	doList('<c:out value="${rootCategorySeq}"/>', '<c:out value="${rootCategoryLevel}"/>');
	doDetail(jQuery("#rootTitle"), {
		categorySeq : '<c:out value="${rootCategorySeq}"/>', 
		groupLevel : '<c:out value="${rootCategoryLevel}"/>', 
		categoryName : '<c:out value="${rootCategoryName}"/>'
	});
};
</script>
<style type="text/css">
.selected {background-color:#0000ff; color:#ffffff !important; padding:2px 5px;}
</style>
</head>

<body>

	<form id="FormDetail" name="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="srchCategoryTypeCd" value="<c:out value="${category.categoryTypeCd}"/>">
		<input type="hidden" name="srchYearTerm">
		<input type="hidden" name="categorySeq">
	</form>

	<form id="FormReload" name="FormReload" method="post" onsubmit="return false;">
	</form>

	<form id="FormListRefresh" name="FormListRefresh" method="post" onsubmit="return false;">
		<input type="hidden" name="srchCategoryTypeCd" value="<c:out value="${category.categoryTypeCd}"/>">
		<input type="hidden" name="srchYearTerm">
		<input type="hidden" name="srchParentSeq">
		<input type="hidden" name="srchGroupLevel">
		<input type="hidden" name="limitCategoryLevel" value="regist">
	</form>
	
	<table class="tbl-layout">
	<colgroup>
		<col style="width:50%;" />
		<col style="width:auto;" />
	</colgroup>
	<tbody>
	<tr>
		<td id="containerLeft" class="first">
			<table class="tbl-detail">
			<tbody>
				<tr>
					<td>
						<div class="scroll-y" style="height:450px;">
							<div class="group-list">
								<form id="FormList" name="FormList" method="post" onsubmit="return false;">
									<input type="hidden" name="srchCategoryTypeCd" value="<c:out value="${category.categoryTypeCd}"/>">
									<input type="hidden" name="srchParentSeq">
									<input type="hidden" name="srchGroupLevel">
									<input type="hidden" name="limitCategoryLevel" value="regist">
									<c:if test="${category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
										<select name="srchYearTerm" onchange="doStartRoot()">
											<c:forEach var="row" items="${yearTerms}" varStatus="i">
												<option value="<c:out value="${row.yearTerm}"/>"
													<c:out value="${row.yearTerm eq systemYearTerm ? 'selected' : ''}"/>
												><c:out value="${row.yearTermName}"/></option>
											</c:forEach>
										</select>
									</c:if>
								</form>
								<ul>
									<li style="padding:3px 0;">
										<a href="javascript:void(0)" onclick="doHide(this)" style="display:none;"><aof:img src="icon/tree_branch_closed.gif" style="width:11px;height:13px;"/></a>
										<a href="javascript:void(0)" onclick="doList('<c:out value="${rootCategorySeq}"/>', '<c:out value="${rootCategoryLevel}"/>')" id="root"><aof:img src="icon/tree_branch_opened.gif" style="width:15px;height:15px;"/></a>
										<a href="javascript:void(0)" onclick="doDetail(this, {categorySeq : '<c:out value="${rootCategorySeq}"/>', groupLevel : '<c:out value="${rootCategoryLevel}"/>', categoryName : '<c:out value="${rootCategoryName}"/>'})" id="rootTitle"><c:out value="${rootCategoryName}"/></a>
									</li>
								</ul>
								<ul id="category-<c:out value="${rootCategorySeq}"/>" style="display:none;padding-left:20px;"></ul>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
			</table>
			
		</td>
		<td id="containerRight">
		</td>
	</tr>
	</tbody>
	</table>

	<c:if test="${category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
		<p class="mt10">
			<spring:message code="글:교과목그룹:학위는학사에서생성된교과목그룹입니다" />
			<br>
			<spring:message code="글:교과목그룹:조회만가능합니다" />
		</p>
	</c:if>

</body>
</html>
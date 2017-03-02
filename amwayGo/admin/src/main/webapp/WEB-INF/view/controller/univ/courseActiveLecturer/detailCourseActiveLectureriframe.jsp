<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ACTIVE_LECTURER_TYPE_PROF"   value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.PROF')}"/>
<c:set var="CD_ACTIVE_LECTURER_TYPE_ASSIST" value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.ASSIST')}"/>
<c:set var="CD_ACTIVE_LECTURER_TYPE_TUTOR"  value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.TUTOR')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata    = null;
var forDetail      = null;
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
	forListdata.config.url    = "<c:url value="/univ/course/active/lecturer/list/iframe.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/course/active/lecturer/detail/iframe.do"/>";
	
	forSubUpdatelist = $.action("submit", {formId : "SubFormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forSubUpdatelist.config.url             = "<c:url value="/univ/course/active/lecturer/menu/updatelist.do"/>";
	forSubUpdatelist.config.target          = "hiddenframe";
	forSubUpdatelist.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forSubUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubUpdatelist.config.fn.complete     = doSubCompleteUpdatelist;
	
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function() {
	// 상세화면 form을 reset한다.
	UT.getById(forDetail.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	jQuery("#" + forDetail.config.formId).find(":input[name='courseActiveProfSeq']").val("<c:out value="${detail.univCourseActiveLecturer.courseActiveProfSeq}"/>");
	// 상세화면 실행
	forDetail.run();
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
				doList();
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
	if($element.siblings(":input[name='roleMandatoryYn']").val() == 'Y' && element.value == 'R'){
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

/**
 * 목록보기
 */
doList = function() {
	//접근권한 설정에서 늘어난 사이즈 강제로 줄이기
	parent.doParentNoscrollIframe();
	
	forListdata.run();
};

</script>
<style>
.selected {background-color:#eeeeee;}
</style>
</head>

<body>

	<div style="display:none;">
		<c:import url="srchCourseActiveLeturer.jsp"/>
	</div>
	
	<div class="lybox-title">
		<c:choose>
			<c:when test="${condition.srchActiveLecturerTypeCd eq CD_ACTIVE_LECTURER_TYPE_PROF }">
				<h4 class="section-title"><spring:message code="필드:교강사권한관리:교강사상세정보"/></h4>
			</c:when>
			<c:when test="${condition.srchActiveLecturerTypeCd eq CD_ACTIVE_LECTURER_TYPE_ASSIST }">
				<h4 class="section-title"><spring:message code="필드:교강사권한관리:선임상세정보"/></h4>
			</c:when>
			<c:when test="${condition.srchActiveLecturerTypeCd eq CD_ACTIVE_LECTURER_TYPE_TUTOR }">
				<h4 class="section-title"><spring:message code="필드:교강사권한관리:강사상세정보"/></h4>
			</c:when>
		</c:choose>
	</div>
<!-- 상세 테이블 -->	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
		<col style="width: 120px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:이름"/></th>
			<td colspan="3"><c:out value="${detail.member.memberName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:아이디"/></th>
			<td colspan="3"><c:out value="${detail.member.memberId}"/></td>
		</tr>
		<%--<tr>
			<th><spring:message code="필드:멤버:소속"/></th>
			<td colspan="3"><c:out value="${detail.member.organizationString}"/></td>
		</tr>
		 --%>
		<tr>
			<th><spring:message code="필드:멤버:업무"/></th>
			<td colspan="3"><aof:code type="print" codeGroup="PROF_TYPE" selected="${detail.admin.profTypeCd }" /></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이메일"/></th>
			<td colspan="3"><c:out value="${detail.member.email}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:전화번호"/></th>
			<td><c:out value="${detail.member.phoneHome}"/></td>
			<th><spring:message code="필드:멤버:모바일전화번호"/></th>
			<td><c:out value="${detail.member.phoneMobile}"/></td>
		</tr>
		<tr>
			<c:choose>
				<c:when test="${condition.srchActiveLecturerTypeCd eq CD_ACTIVE_LECTURER_TYPE_PROF }">
					<th><spring:message code="필드:등록일"/></th>
					<td colspan="3"><aof:date datetime="${detail.univCourseActiveLecturer.regDtime}"/></td>
				</c:when>
				<c:otherwise>
					<th><spring:message code="필드:교강사권한관리:권한배정자"/></th>
					<td><c:out value="${detail.univCourseActiveLecturer.profMemberName}" /></td>
					<th><spring:message code="필드:등록일"/></th>
					<td><aof:date datetime="${detail.univCourseActiveLecturer.regDtime}"/></td>
				</c:otherwise>
			</c:choose>
		</tr>
	</tbody>
	</table>
	
	<div class="lybox-btn">	
		<div class="lybox-btn-r">
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
	
	<div class="lybox-title">
		<c:choose>
			<c:when test="${condition.srchActiveLecturerTypeCd eq CD_ACTIVE_LECTURER_TYPE_PROF }">
				<h4 class="section-title"><spring:message code="필드:교강사권한관리:교강사권한설정"/></h4>
			</c:when>
			<c:when test="${condition.srchActiveLecturerTypeCd eq CD_ACTIVE_LECTURER_TYPE_ASSIST }">
				<h4 class="section-title"><spring:message code="필드:교강사권한관리:선임권한설정"/></h4>
			</c:when>
			<c:when test="${condition.srchActiveLecturerTypeCd eq CD_ACTIVE_LECTURER_TYPE_TUTOR }">
				<h4 class="section-title"><spring:message code="필드:교강사권한관리:강사권한설정"/></h4>
			</c:when>
		</c:choose>
	</div>
	
<!-- 메뉴권한 수정 테이블 -->
<form id="SubFormData" name="SubFormData" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveProfSeq" value="${detail.univCourseActiveLecturer.courseActiveProfSeq}"/>
	<input type="hidden" name="courseActiveSeq" value="${detail.univCourseActiveLecturer.courseActiveSeq}"/>
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 50px" />
		<col style="width: 120px" />
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: 280px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:메뉴:메뉴아이디" /></th>
			<th><spring:message code="필드:메뉴:메뉴명" /></th>
			<th><spring:message code="필드:메뉴:url" /></th>
			<th><aof:code type="checkbox" codeGroup="CRUD" name="check" onclick="doCheckAll(this)" labelStyle="margin-right:3px;"/></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${list}" varStatus="i">
		<c:set var="depth" value="${aoffn:toInt(fn:length(row.menu.menuId)/3)}"/>
		<tr class="<c:out value="${!empty row.univCourseActiveLecturerMenu.crud ? 'selected' : ''}"/>">
	        <td><c:out value="${i.count}"/></td>
	        <td class="align-l"><c:out value="${row.menu.menuId}"/></td>
			<td class="align-l">
				<div style="padding-left:<c:out value="${(depth - 1) * 15}"/>px;">
					<c:out value="${row.menu.menuName}"/>
				</div>
			</td>
			<td class="align-l"><c:out value="${row.menu.url}"/></td>
			<td>
				<input type="hidden" name="rolegroupSeqs" value="<c:out value="${appRolegroupSeq}" />">
				<input type="hidden" name="menuSeqs" value="<c:out value="${row.menu.menuSeq}"/>">
				<input type="hidden" name="oldCruds" value="<c:out value="${row.univCourseActiveLecturerMenu.crud}"/>"/>
				<input type="hidden" name="roleMandatoryYn" value="<c:out value="${row.rolegroupMenu.mandatoryYn}"/>"/><!-- 롤그룹에서 해당 메뉴를 제거 하지 못하게 하기위한 값입니다. 해당 값은 UI상으로 컨트롤 안되며 개발자가 지정한 값입니다. -->
				<input type="hidden" name="cruds" value="<c:out value="${row.univCourseActiveLecturerMenu.crud}"/>"/>
				<input type="hidden" name="depth" value="<c:out value="${depth}"/>"/>
				<c:choose>
					<c:when test="${row.menu.mandatoryYn eq 'Y'}"><!-- 필수메뉴 읽기 기본값 셋팅 되게 하기 위한 구분 -->
						<c:if test="${empty row.univCourseActiveLecturerMenu.crud}">
							<aof:code type="checkbox" codeGroup="CRUD" name="crud-${row.menu.menuId}" selected="R" onclick="doClickCrud(this,'solo')" removeCodePrefix="true" styleClass="crud" labelStyle="margin-right:3px;"/>
						</c:if>
						<c:if test="${not empty row.rolegroupMenu.crud}">
							<aof:code type="checkbox" codeGroup="CRUD" name="crud-${row.menu.menuId}" selected="${row.univCourseActiveLecturerMenu.crud}" onclick="doClickCrud(this,'solo')" removeCodePrefix="true" styleClass="crud" labelStyle="margin-right:3px;"/>
						</c:if>
					</c:when>
					<c:otherwise>
						<aof:code type="checkbox" codeGroup="CRUD" name="crud-${row.menu.menuId}" selected="${row.univCourseActiveLecturerMenu.crud}" onclick="doClickCrud(this,'solo')" removeCodePrefix="true" styleClass="crud" labelStyle="margin-right:3px;"/>
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
</body>
</html>
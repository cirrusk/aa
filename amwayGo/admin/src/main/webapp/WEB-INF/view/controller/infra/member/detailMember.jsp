<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<aof:session key="currentRolegroupSeq" var="ssCurrentRolegroupSeq"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit     = null;
var forCourseApplyList     = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. 썸네일의 원본 이미지 보기
	UI.originalOfThumbnail();
	
	// [3]. 회원수강 이력 정보
	forCourseApplyList.run();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/member/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/member/edit.do"/>";
	
	forCourseApplyList = $.action("ajax");
	forCourseApplyList.config.formId      = "FormCourseApplyList";
	forCourseApplyList.config.type        = "html";
	forCourseApplyList.config.containerId = "courseApplyList";
	forCourseApplyList.config.url         = "<c:url value="/member/detail/course/apply/list/ajax.do"/>";	
	forCourseApplyList.config.fn.complete = function() {};
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
	var form = UT.getById(forCourseApplyList.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	forCourseApplyList.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};
/**
 * 사용자 아이디로 프론트 로그인 하기. 
 */
doMemberLogin = function() {
	var action = $.action("ajax");
	action.config.formId      = "FormMemberLogin";
	action.config.url         = "<c:url value="/common/access/signature.do"/>";
	action.config.type        = "json";
	action.config.fn.complete = function(action, data) {
		if (data.signature !== "") {
			var action2 = $.action();
			action2.config.formId = "FormMemberLogin";
			action2.config.url    = "<c:out value="${aoffn:config('domain.www')}"/>" + "<c:url value="/security/login"/>";
			action2.config.target = "_blank";
			var form = UT.getById(action2.config.formId); 
			form.elements["j_username"].value = data.signature;
			form.elements["j_password"].value = data.password;
			form.elements["j_rolegroup"].value = "2";
			action2.run();
		}
	};
	action.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchMember.jsp"/>
	</div>

	<div class="lastupdate">
		<strong><spring:message code="필드:수정자"/></strong>
		<c:out value="${detail.member.updMemberName}"/>
		&nbsp;
		<strong><spring:message code="필드:수정일시"/></strong>
		<aof:date datetime="${detail.member.updDtime}" pattern="${aoffn:config('format.datetime')}"/>
	</div>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
		<col style="width: 140px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:아이디"/></th>
			<td>
				<c:out value="${detail.member.memberId}"/>
				<c:if test="${ssCurrentRolegroupSeq eq 1}">
					&nbsp;
					<a href="javascript:void(0)" onclick="doMemberLogin()" class="btn gray"><span class="small"><spring:message code="버튼:로그인"/></span></a>
				</c:if>
			</td>
			<td class="align-c" rowspan="5">
				<c:choose>
					<c:when test="${!empty detail.member.photo}">
						<c:set var="memberPhoto" value ="${aoffn:config('upload.context.image')}${detail.member.photo}.thumb.jpg"/>
					</c:when>
					<c:otherwise>
						<c:set var="memberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
					</c:otherwise>
				</c:choose>
				<div class="photo photo-120">
					<img src="${memberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이름"/></th>
			<td><c:out value="${detail.member.memberName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:닉네임"/></th>
			<td><c:out value="${detail.member.nickname}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:소속"/></th>
			<td><c:out value="${detail.company.companyName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:업무"/></th>
			<td><aof:code type="print" codeGroup="TASK" selected="${detail.member.taskCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이메일"/></th>
			<td colspan="2"><c:out value="${detail.member.email}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:모바일전화번호"/></th>
			<td colspan="2"><c:out value="${detail.member.phoneMobile}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:집전화번호"/></th>
			<td colspan="2"><c:out value="${detail.member.phoneHome}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:주소"/></th>
			<td colspan="2">
				<c:if test="${!empty detail.member.zipcode and !empty detail.member.address}">
					<c:out value="${fn:substring(detail.member.zipcode, 0, 3)}"/>-<c:out value="${fn:substring(detail.member.zipcode, 3, 6)}"/> 
					&nbsp;<c:out value="${detail.member.address}"/>&nbsp;<c:out value="${detail.member.addressDetail}"/>
				</c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:상태"/></th>
			<td colspan="2"><aof:code type="print" codeGroup="MEMBER_STATUS" selected="${detail.member.statusCd}"/></td>
		</tr>
		<tr>
			<c:choose>
				<c:when test="${detail.member.statusCd eq 'leave'}">
					<th><spring:message code="필드:멤버:회원탈퇴일"/></th>
					<td colspan="2"><aof:date datetime="${detail.member.leaveDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
				</c:when>
				<c:otherwise>
					<th><spring:message code="필드:멤버:회원가입일"/></th>
					<td colspan="2"><aof:date datetime="${detail.member.regDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
				</c:otherwise>
			</c:choose>
		</tr>
		<tr>
			<th><spring:message code="필드:롤그룹:롤그룹명"/></th>
			<td colspan="2">
				<c:forEach var="row" items="${listRolegroup}" varStatus="i">
					<c:if test="${i.index gt 0}">, </c:if>
					<c:out value="${row.rolegroupName}"/>
				</c:forEach>
			</td>
		</tr>
	</tbody>
	</table>

	<form name="FormMemberLogin" id="FormMemberLogin" method="post" onsubmit="return false;">
		<input type="hidden" name="j_username">
		<input type="hidden" name="j_password">
		<input type="hidden" name="j_rolegroup">
		<input type="hidden" name="memberId" value="<c:out value="${detail.member.memberId}"/>">
	</form>

	<ul class="buttons">	
		<li class="right">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'memberSeq' : '<c:out value="${detail.member.memberSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</li>
	</ul>
	
	<div class="clear"><br></div>
	<div class="section_title align-l"><spring:message code="필드:과정:수강이력"/></div>
	<form name="FormCourseApplyList" id="FormCourseApplyList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="1"/>
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="0" />
		<input type="hidden" name="srchWord"    value="" />
		<input type="hidden" name="srchMemberSeq" value="<c:out value="${detail.member.memberSeq}"/>"/>
		<div id ="courseApplyList"></div>
	</form>
</body>
</html>
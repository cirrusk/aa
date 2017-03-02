<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<aof:session key="currentRolegroupSeq" var="ssCurrentRolegroupSeq"/>

<html decorator="<c:out value="${decorator }"/>">
<head>
<title></title>
<script type="text/javascript">
var forListdata 		  = null;
var forEdit     		  = null;
var forUpdatePassword     = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. 썸네일의 원본 이미지 보기
	UI.originalOfThumbnail();
	
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/member/admin/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/member/admin/edit.do"/>";
	
	forUpdatePassword = $.action("layer", {formId : "FormData"});
	forUpdatePassword.config.url = "<c:url value="/member/password/popup.do"/>";
	forUpdatePassword.config.options.width  = 500;
	forUpdatePassword.config.options.height = 350;
	forUpdatePassword.config.options.position = "middle";
	forUpdatePassword.config.options.title  = "<spring:message code="글:멤버:비밀번호변경"/>";
	
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
 * 비밀번호 변경 팝업
 */
 doUpdatePassword = function() {
	 forUpdatePassword.run();
};

/**
 * 학사연동 정보갱신
 */
doReNewData = function() {
	
};
</script>
</head>

<body>
<c:if test="${empty decorator }">
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>
</c:if>
	<div style="display:none;">
		<c:import url="srchMember.jsp"/>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:아이디"/></th>
			<td>
				<c:out value="${detail.member.memberId}"/> 
				<a href="javascript:void(0)" onclick="doUpdatePassword()" class="btn black"><span class="mid"><spring:message code="버튼:비밀번호변경"/></span></a>
			</td>
		</tr>
	</tbody>
	</table>
	<div class="vspace"></div>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
		<col style="width: 120px" />
		<col/>
		<col style="width: 150px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:이름"/></th>
			<td><c:out value="${detail.member.memberName}"/></td>
			<th><spring:message code="필드:멤버:회원구분"/></th>
			<td><aof:code type="print" codeGroup="JOB_TYPE" selected="${detail.admin.jobTypeCd}" /></td>
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
			<th><spring:message code="필드:멤버:소속"/></th>
			<td colspan="3"><c:out value="${detail.category.categoryString}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:학사상태"/></th>
			<td colspan="3"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:자택전화번호"/></th>
			<td><c:out value="${detail.member.phoneHome}"/></td>
			<th><spring:message code="필드:멤버:휴대전화"/></th>
			<td><c:out value="${detail.member.phoneMobile}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이메일개인"/></th>
			<td colspan="3"><c:out value="${detail.member.email}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:계정상태"/></th>
			<td colspan="4"><aof:code type="print" codeGroup="MEMBER_STATUS" selected="${detail.member.memberStatusCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:롤그룹:권한그룹"/></th>
			<td colspan="4">
				<c:forEach var="row" items="${listRolegroup}" varStatus="i">
					<c:if test="${i.index gt 0}">, </c:if>
					<c:out value="${row.rolegroupName}"/>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:최종동기화일시"/></th>
			<td colspan="4">
				<aof:date datetime="${detail.member.migLastTime}" pattern="${aoffn:config('format.datetime')}"/>
			</td>
		</tr>
	</tbody>
	</table>
<c:if test="${empty decorator }">
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<a href="#" onclick="doReNewData();" class="btn blue"><span class="mid"><spring:message code="버튼:정보갱신"/></span></a>
		</div>	
		<div class="lybox-btn-r">
			<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData','doCreateMemoComplete')" class="btn blue">
               	<span class="mid"><spring:message code="버튼:쪽지" /></span>
               </a>
			<a href="javascript:void(0)" onclick="FN.doCreateSms('FormData','doCreateMemoComplete')" class="btn blue">
				<span class="mid"><spring:message code="버튼:SMS" /></span>
			</a>
			<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData','doCreateMemoComplete')" class="btn blue">
				<span class="mid"><spring:message code="버튼:이메일" /></span>
			</a>
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'memberSeq' : '<c:out value="${detail.member.memberSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
</c:if>
	<form name="FormData" id="FormData" method="post" onsubmit="return false;">
		<input type="hidden" name="memberSeq" value="<c:out value="${detail.member.memberSeq}"/>" />
		<input type="hidden" name="memberName" value="<c:out value="${detail.member.memberName}" />" />
		<input type="hidden" name="phoneMobile" value="<c:out value="${detail.member.phoneMobile}" />" />
	</form>
	
	<form name="FormMemberLogin" id="FormMemberLogin" method="post" onsubmit="return false;">
		<input type="hidden" name="j_username">
		<input type="hidden" name="j_password">
		<input type="hidden" name="j_rolegroup">
		<input type="hidden" name="memberId" value="<c:out value="${detail.member.memberId}"/>">
	</form>
	
</body>
</html>
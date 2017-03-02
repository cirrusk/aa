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
var forListCourseActive   = null;
var forListCourseApply    = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. 썸네일의 원본 이미지 보기
	UI.originalOfThumbnail();
	
	// [3] tab
	//UI.tabs("#tabs").show();
	
	//doTab(0);
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/member/prof/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/member/prof/edit.do"/>";
	
	forUpdatePassword = $.action("layer", {formId : "FormData"});
	forUpdatePassword.config.url = "<c:url value="/member/password/popup.do"/>";
	forUpdatePassword.config.options.width  = 500;
	forUpdatePassword.config.options.height = 350;
	forUpdatePassword.config.options.position = "middle";
	forUpdatePassword.config.options.title  = "<spring:message code="글:멤버:비밀번호변경"/>";
	
	forListCourseActive = $.action();
	forListCourseActive.config.formId = "FormCourseData";
	forListCourseActive.config.url = "<c:url value="/member/detail/course/active/list/iframe.do"/>";
	forListCourseActive.config.target = "frame-courseActvie";
	
	forListCourseApply = $.action();
	forListCourseApply.config.formId = "FormCourseData";
	forListCourseApply.config.target = "frame-courseApply";
	forListCourseApply.config.url    = "<c:url value="/member/detail/course/apply/list/iframe.do"/>";
	
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

/**
 * 탭열기
 */
doTab = function(index) {
	$('#tabs').tabs({selected : index});
};

/**
 * 운영과목정보 목록
 */
doCourseActiveList = function(){
	forListCourseActive.run();
};

/**
 * 수강이력 목록
 */
doProfHistoryList = function(){
	forListCourseApply.run();
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
			<th><spring:message code="필드:멤버:아이디"/><span class="star">*</span></th>
			<td>
				<c:out value="${detail.member.memberId}"/>&nbsp;
				<%-- <a href="javascript:void(0)" onclick="doUpdatePassword()" class="btn black"><span class="mid"><spring:message code="버튼:비밀번호변경"/></span></a> --%>
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
		<col style="width: 115px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:이름국문"/><span class="star">*</span></th>
			<td><c:out value="${detail.member.memberName}"/></td>
			<th><spring:message code="필드:멤버:성별"/></th>
			<td><aof:code type="print" codeGroup="SEX" selected="${detail.member.sexCd }" /></td>
			<td class="align-c" rowspan="2">
				<c:choose>
					<c:when test="${!empty detail.member.photo}">
						<c:set var="memberPhoto" value ="${aoffn:config('upload.context.image')}${detail.member.photo}.thumb.jpg"/>
					</c:when>
					<c:otherwise>
						<c:set var="memberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
					</c:otherwise>
				</c:choose>
				<div class="photo photo-90">
					<img src="${memberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:회원구분"/></th>
			<td><aof:code type="print" codeGroup="PROF_TYPE" selected="${detail.admin.profTypeCd }" /></td>
			<%--<th><spring:message code="필드:멤버:국적"/></th>
			<td><aof:code type="print" codeGroup="COUNTRY" selected="${detail.member.countryCd}" /></td>
			 --%>
			<th><spring:message code="필드:멤버:좌우명"/></th>
			<td>
				<c:out value="${detail.member.motto}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:직급"/></th>
			<td colspan="3">
				<aof:code type="print" codeGroup="POSITION" selected="${detail.member.position}" />
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
		<col style="width: 115px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:휴대전화"/><span class="star"></span></th>
			<td colspan="4">
				<c:out value="${detail.member.phoneMobile}"/>
			</td>
			<%-- 
			<th><spring:message code="필드:멤버:SMS수신여부"/></th>
			<td colspan="2">
				<aof:code type="print" codeGroup="YESNO" name="smsYn" removeCodePrefix="true" selected="${detail.member.smsYn }" />
			</td>
			--%>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이메일개인"/></th>
			<td colspan="4">
				<c:out value="${detail.member.email}"/>
			</td>
			<%--
			<th><spring:message code="필드:멤버:이메일수신여부"/></th>
			<td colspan="2">
				<aof:code type="print" codeGroup="YESNO" name="smsYn" removeCodePrefix="true" selected="${detail.member.emailYn }" />
			</td>
			 --%>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:계정상태"/></th>
			<td colspan="4"><aof:code type="print" codeGroup="MEMBER_STATUS" selected="${detail.member.memberStatusCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:개인정보동의여부"/></th>
			<td><aof:code type="print" codeGroup="YESNO" selected="${detail.member.agreementYn}" removeCodePrefix="true"/></td>
			<th><spring:message code="필드:멤버:개인정보동의일시"/></th>
			<td colspan="2"><aof:date datetime="${detail.member.agreementDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
		</tr>
		<%--
		<tr>
			<th><spring:message code="필드:멤버:최종동기화일시"/></th>
			<td colspan="4">
				<aof:date datetime="${detail.member.migLastTime}" pattern="${aoffn:config('format.datetime')}"/>
			</td>
		</tr>
		 --%>
	</tbody>
	</table>

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
<c:if test="${empty decorator }">
	<div class="lybox-btn">
		<%-- 
		<div class="lybox-btn-l">
			<a href="#" onclick="doReNewData();" class="btn blue"><span class="mid"><spring:message code="버튼:정보갱신"/></span></a>
		</div>
		--%>	
		<div class="lybox-btn-r">
			<%--
			<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData','doCreateMemoComplete')" class="btn blue">
               	<span class="mid"><spring:message code="버튼:쪽지" /></span>
               </a>
			<a href="javascript:void(0)" onclick="FN.doCreateSms('FormData','doCreateMemoComplete')" class="btn blue">
				<span class="mid"><spring:message code="버튼:SMS" /></span>
			</a>
			<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData','doCreateMemoComplete')" class="btn blue">
				<span class="mid"><spring:message code="버튼:이메일" /></span>
			</a>
			 --%>
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doEdit({'memberSeq' : '<c:out value="${detail.member.memberSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="javascript:void(0)" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
	
	<form name="FormCourseData" id="FormCourseData" method="post" onsubmit="return false;">
		<input type="hidden" name="srchMemberSeq" value="<c:out value="${detail.member.memberSeq}"/>" />
		<input type="hidden" name="srchMemberId" value="<c:out value="${detail.member.memberId}"/>" />
	</form>
	<%-- 
	<div id="tabs" style="display:none;">
		<ul class="ui-widget-header-tab-custom">
			<li><a href="#tabContainer1" onclick="doCourseActiveList()"><spring:message code="필드:맴버:운영과목정보"/></a></li>
			<li><a href="#tabContainer2" onclick="doProfHistoryList()"><spring:message code="필드:맴버:수강이력"/></a></li>
		</ul>
		<div id="tabContainer1" style="padding:0;">
			<iframe id="frame-courseActvie" name="frame-courseActvie" frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
		</div>
		<div id="tabContainer2" style="padding:0;">
			<iframe id="frame-courseApply" name="frame-courseApply" frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
		</div>
	</div>
	--%>
</c:if>	
</body>
</html>
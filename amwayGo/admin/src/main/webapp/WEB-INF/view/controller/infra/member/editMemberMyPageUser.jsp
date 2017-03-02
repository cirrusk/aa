<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdate   		= null;
var forMypageEdit 		= null;
var swfu = null;
var imageContext = "<c:out value="${aoffn:config('upload.context.image')}"/>";
var imageBlank = "<aof:img type="print" src="common/blank.gif"/>";
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/member/user/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = doUpdateComplete;
	
	forMypageEdit = $.action();
	forMypageEdit.config.formId = "FormDetail";
	forMypageEdit.config.url    = "<c:url value="/mypage/member/edit.do"/>";

	setValidate();
	
	// [2]. uploader
	swfu = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader",
			postParams : {
				thumbnailWidth : 120,
				thumbnailHeight : 120,
				thumbnailCrop : "Y"
			},
			options : {
				uploadUrl : "<c:url value="/attach/image/save.do"/>",
				buttonImageUrl : '<aof:img type="print" src="btn/photo_22x22.png"/>',
				buttonWidth: 23,
				inputWidth : 0,	
				fileTypes : "*.jpg;*.gif",
				fileTypesDescription : "Image Files",
				fileSizeLimit : "10 MB",
				immediatelyUpload : true,
				successCallback : function(id, file) {
					if (id == "uploader") {
						var form = UT.getById(forUpdate.config.formId);
						var fileInfo = file.serverData.fileInfo;
						form.elements["photo"].value = fileInfo.savePath + "/" + fileInfo.saveName;
						
						var $photo = jQuery("#member-photo");
						$photo.attr("src", imageContext + form.elements["photo"].value);
						$photo.siblings(".delete").show();
					}
				}
			}
		}]
	);	
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:이름국문"/>",
		name : "memberName",
		data : ["!null"],
		check : {
			maxlength : 30
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:휴대전화"/>",
		name : "phoneMobile",
		data : ["!null","number"],
		check : {
			maxlength : 12
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:이메일개인"/>",
		name : "email",
		data : ["email"],
		check : {
			maxlength : 200
		}
	});
};
/**
 * 저장
 */
doUpdate = function() {
	forUpdate.run();
};
/**
 * 사진 삭제
 */
doDeletePhoto = function() {
	var form = UT.getById(forUpdate.config.formId);
	form.elements["photo"].value = "";
	
	var $photo = jQuery("#member-photo");
	$photo.attr("src", imageBlank);
	$photo.siblings(".delete").hide();
};

/**
 * 회원수정후 호출
 */
doUpdateComplete = function(result){
	doEdit({'memberSeq' : '<c:out value="${detail.member.memberSeq}"/>'});
};

/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forMypageEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forMypageEdit.config.formId);
	// 수정화면 실행
	forMypageEdit.run();
};

/**
 * 학사연동 정보갱신
 */
doReNewData = function() {
	
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchMember.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="memberSeq" value="<c:out value="${detail.member.memberSeq}"/>"/>
	<input type="hidden" name="duplicatedMemberId" value="N">
	<input type="hidden" name="duplicatedNickname" value="N">
	<input type="hidden" name="photo" value="<c:out value="${detail.member.photo}"/>"/>
	
	<div class="clear"><br></div>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
		<col style="width: 120px" />
		<col/>
		<col style="width: 120px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:이름국문"/><span class="star">*</span></th>
			<td colspan="3"><c:out value="${detail.member.memberName}"/></td>
			<td class="align-c" rowspan="2">
				<c:choose>
					<c:when test="${!empty detail.member.photo}">
						<c:set var="memberPhoto" value ="${aoffn:config('upload.context.image')}${detail.member.photo}.thumb.jpg"/>
					</c:when>
					<c:otherwise>
						<c:set var="memberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
					</c:otherwise>
				</c:choose>
				<div class="photo photo-60">
					<img src="<c:out value="${memberPhoto}"/>" id="member-photo" title="<spring:message code="필드:멤버:사진"/>">
					<div id="uploader" class="uploader"></div>
					<div class="delete" 
					     style="display:<c:out value="${empty detail.member.photo ? 'none' : ''}"/>;" 
					     onclick="doDeletePhoto()" title="<spring:message code="버튼:삭제"/>"></div>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:아이디"/></th>
			<td colspan="3"><c:out value="${detail.member.memberId}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:회원구분"/></th>
			<td>
				<select name="profTypeCd" class="select">
					<aof:code type="option" codeGroup="MEMBER_EMP_TYPE" selected="${detail.member.memberEmsTypeCd }" />
				</select>
			</td>
			<th><spring:message code="필드:멤버:학년"/></th>
			<td colspan="2"><input type="text" name="studentYear" value="<c:out value="${detail.member.studentYear}"/>" style="width:150px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:성별"/></th>
			<td colspan="3">
				<select name="sexCd" class="select">
					<aof:code type="option" codeGroup="SEX" selected="${detail.member.sexCd }"></aof:code>
				</select>
			</td>
			<%-- 
			<th><spring:message code="필드:멤버:국적"/></th>
			<td colspan="2">
				<select name="countryCd" class="select">
					<aof:code type="option" codeGroup="COUNTRY" selected="${detail.member.countryCd }" />
				</select>
			</td>
			--%>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이메일개인"/></th>
			<td colspan="4">
				<input type="text" name="email" value="<c:out value="${detail.member.email}"/>" style="width:250px;">
				<%-- <span class="comment"><spring:message code="글:멤버:수신여부"/></span>
				<aof:code type="radio" codeGroup="YESNO" name="emailYn" removeCodePrefix="true" selected="${detail.member.emailYn }" />
				--%>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:휴대전화"/><span class="star">*</span></th>
			<td colspan="4">
				<input type="text" name="phoneMobile" value="<c:out value="${detail.member.phoneMobile}"/>" style="width:250px;">
				<%--<span class="comment"><spring:message code="글:멤버:수신여부"/></span>
				<aof:code type="radio" codeGroup="YESNO" name="smsYn" removeCodePrefix="true" selected="${detail.member.smsYn }" />
				 --%>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:계정상태"/></th>
			<td colspan="4">
				<aof:code type="print" codeGroup="MEMBER_STATUS" name="memberStatusCd" selected="${detail.member.memberStatusCd}"/>
			</td>
			<%--
			<th><spring:message code="필드:멤버:학적상태"/></th>
			<td colspan="2"><aof:code type="print" codeGroup="STUDENT_STATUS" selected="${detail.member.studentStatusCd }" /></td>
			 --%>
		</tr>
		<tr>
			<th><spring:message code="필드:롤그룹:롤그룹명"/></th>
			<td colspan="4">
				<c:forEach var="row" items="${listRolegroup}" varStatus="i">
					<c:if test="${i.index gt 0}">, </c:if>
					<c:out value="${row.rolegroupName}"/>
				</c:forEach>
			</td>
		</tr>
	</tbody>
	</table>

	<div class="lybox-btn">
		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
			<div class="lybox-btn-l">
				<a href="#" onclick="doReNewData();" class="btn blue"><span class="mid"><spring:message code="버튼:정보갱신"/></span></a>
			</div>
		</c:if>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doEdit({'memberSeq' : '<c:out value="${detail.member.memberSeq}"/>'});" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>
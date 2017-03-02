<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_MEMBER_EMP_TYPE_003"  value="${aoffn:code('CD.MEMBER_EMP_TYPE.003')}"/>

<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_CATEGORY_TYPE_DEGREE = "<c:out value="${CD_CATEGORY_TYPE_DEGREE}"/>";

var forRefresh 		= null;
var forUpdate   		= null;
var swfu = null;
var imageContext = "<c:out value="${aoffn:config('upload.context.image')}"/>";
var imageBlank = "<aof:img type="print" src="common/blank.gif"/>";
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [3] 카테고리 select 설정
	BrowseCategory.create({
		"categoryTypeCd" : CD_CATEGORY_TYPE_DEGREE,
		"callback" : "doSetCategorySeq",
		"selectedSeq" : "<c:out value="${detail.member.categoryOrganizationSeq }" />",
		"appendToId" : "categoryStep",
		"selectOption" : "regist"
	});
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forRefresh = $.action();
	forRefresh.config.formId = "FormRefresh";
	forRefresh.config.url    = "<c:url value="/usr/member/edit.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/usr/member/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doRefresh();
	};

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
 * 페이지 새로고침
 */
 doRefresh = function() {
	 forRefresh.run();
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
 * 분류정보 세팅
 */
doSetCategorySeq = function(seq) {
	var form = UT.getById(forUpdate.config.formId);
	form.elements["categoryOrganizationSeq"].value = (typeof seq === "undefined" || seq == null ? "" : seq);
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="memberSeq" value="<c:out value="${detail.member.memberSeq}"/>"/>
	<input type="hidden" name="photo" value="<c:out value="${detail.member.photo}"/>"/>
	
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
			<th><spring:message code="필드:멤버:이름국문"/><span class="star">*</span></th>
			<td><c:out value="${detail.member.memberName}"/></td>
			<th><spring:message code="필드:멤버:성별"/></th>
			<td>
				<aof:code type="print" codeGroup="SEX" selected="${detail.member.sexCd }" />
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
					<img src="<c:out value="${memberPhoto}"/>" id="member-photo" title="<spring:message code="필드:멤버:사진"/>">
					<div id="uploader" class="uploader"></div>
					<div class="delete" 
					     style="display:<c:out value="${empty detail.member.photo ? 'none' : ''}"/>;" 
					     onclick="doDeletePhoto()" title="<spring:message code="버튼:삭제"/>"></div>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:회원구분"/></th>
			<td>
				<aof:code type="print" codeGroup="MEMBER_EMP_TYPE" selected="${detail.member.memberEmsTypeCd }" />
			</td>
			<th><spring:message code="필드:멤버:국적"/></th>
			<td>
				<aof:code type="print" codeGroup="COUNTRY" selected="${detail.member.countryCd }" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:학년"/></th>
			<td><c:out value="${detail.member.studentYear}"/><spring:message code="필드:멤버:학년"/></td>
			<th><spring:message code="필드:멤버:학적상태"/></th>
			<td><aof:code type="print" codeGroup="STUDENT_STATUS" selected="${detail.member.studentStatusCd }" /></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:전공"/>(<spring:message code="필드:멤버:학부"/>/<spring:message code="필드:멤버:학과"/>)</th>
			<td colspan="3">
				<c:choose>
	        		<c:when test="${detail.member.memberEmsTypeCd eq CD_MEMBER_EMP_TYPE_003}">
	        			<input type="text" name="organizationString" value="<c:out value="${detail.member.organizationString }" />" />
	        		</c:when>
	        		<c:otherwise>
	        			<div id="categoryStep"></div>
						<input type="hidden" name="categoryOrganizationSeq" value="<c:out value="${detail.member.categoryOrganizationSeq }" />" />
	        		</c:otherwise>
	        	</c:choose>
			</td>
		</tr>
	</tbody>
	</table>
	<div class="vsapce"></div>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:휴대전화"/><span class="star">*</span></th>
			<td colspan="3">
				<input type="text" name="phoneMobile" value="<c:out value="${detail.member.phoneMobile}"/>" style="width:250px;">
				<span class="comment"><spring:message code="글:멤버:수신여부"/></span>
				<aof:code type="radio" codeGroup="YESNO" name="smsYn" removeCodePrefix="true" selected="${detail.member.smsYn }" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이메일개인"/></th>
			<td colspan="3">
				<input type="text" name="email" value="<c:out value="${detail.member.email}"/>" style="width:250px;">
				<span class="comment"><spring:message code="글:멤버:수신여부"/></span>
				<aof:code type="radio" codeGroup="YESNO" name="emailYn" removeCodePrefix="true" selected="${detail.member.emailYn }" />
			</td>
		</tr>
	</tbody>
	</table>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<a href="javascript:void(0)" onclick="" class="btn blue"><span class="mid"><spring:message code="버튼:정보갱신"/></span></a>
		</div>
		<div class="lybox-btn-r">
			<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			<a href="#" onclick="doRefresh();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
	<form id="FormRefresh" name="FormRefresh" method="post" onsubmit="return false;">
		<input type="hidden" name="memberSeq" value="<c:out value="${detail.member.memberSeq}"/>"/>
	</form>
	
</body>
</html>
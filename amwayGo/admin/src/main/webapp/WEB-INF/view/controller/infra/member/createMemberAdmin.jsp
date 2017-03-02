<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_MEMBER_STATUS_APPROVAL" value="${aoffn:code('CD.MEMBER_STATUS.APPROVAL')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE"   value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_CATEGORY_TYPE_DEGREE = "<c:out value="${CD_CATEGORY_TYPE_DEGREE}"/>";

var forListdata = null;
var forInsert   = null;
var swfu = null;
var imageContext = "<c:out value="${aoffn:config('upload.context.image')}"/>";
var imageBlank = "<aof:img type="print" src="common/blank.gif"/>";
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// uploader
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
						var form = UT.getById(forInsert.config.formId);
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
	<%--
	// [3] 카테고리 select 설정
	BrowseCategory.create({
		"categoryTypeCd" : CD_CATEGORY_TYPE_DEGREE,
		"callback" : "doSetCategorySeq",
		"selectedSeq" : "",
		"appendToId" : "categoryStep",
		"selectOption" : "regist"
	});
	--%>
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/member/admin/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/member/admin/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = function() {
		doList();
	};

	setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:멤버:아이디"/>",
		name : "memberId",
		data : ["!null", "!space"],
		check : {
			maxlength : 30,
			minlength : 5
		}
	});
	forInsert.validator.set({
		message : "<spring:message code="글:멤버:아이디는영문숫자특수문자만가능합니다"/>",
		name : "memberId",
		check : {
			regex : "^[A-z0-9._@]{4,29}$"
		}
	});
	forInsert.validator.set({
		message : "<spring:message code="글:멤버:아이디중복검사를실시하십시오"/>",
		name : "duplicatedMemberId",
		check : {
			eq : "N"
		}
	});
	/*
	forInsert.validator.set({
		title : "<spring:message code="필드:멤버:비밀번호"/>",
		name : "password",
		data : ["!null", "!space"],
		check : {
			maxlength : 30,
			minlength : 6,
			regex :"(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,16}"
		}
	});
	*/
	forInsert.validator.set({
		message : "<spring:message code="글:멤버:비밀번호가일치하지않습니다"/>",
		name : "password",
		check : {
			eq : {name : "verifyPassword", title : ""}
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:멤버:이름"/>",
		name : "memberName",
		data : ["!null"],
		check : {
			maxlength : 30
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:멤버:이메일개인"/>",
		name : "email",
		data : ["email"],
		check : {
			maxlength : 200
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:멤버:휴대전화"/>",
		name : "phoneMobile",
		data : ["number"],
		check : {
			maxlength : 12
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:멤버:자택전화번호"/>",
		name : "phoneHome",
		data : ["number"],
		check : {
			maxlength : 12
		}
	});

};
/**
 * 저장
 */
doInsert = function() { 
	forInsert.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * memberId, nickname 중복검사
 */
doCheckDuplicate = function(field) {
	var form = UT.getById(forInsert.config.formId);	
	var action = $.action("ajax");
	action.config.type   = "json";
	action.config.url    = "<c:url value="/member/duplicate.do"/>";
	if (field == "memberId") {
		action.config.parameters = "memberId=" + form.elements[field].value;

		action.config.fn.validate = function() {

			var msg = "";
			if (Global.validator.checker["!null"](form.elements[field].value) == false) {
				msg = Global.validator.getMessage("!null", "<spring:message code="필드:멤버:아이디"/>", "enter");

			} else if (Global.validator.checker["!space"](form.elements[field].value) == false) {
				msg = Global.validator.getMessage("!space", "<spring:message code="필드:멤버:아이디"/>", "enter");

			} else if (Global.validator.checker["regex"](form.elements[field].value, "^[A-z0-9._@]{4,29}$") == false) {
				msg = "<spring:message code="글:멤버:아이디는영문숫자특수문자만가능합니다"/>";

			} else if (Global.validator.checker["maxlength"](form.elements[field].value, 50) == false) {
				msg = Global.validator.getMessage("maxlength", "<spring:message code="필드:멤버:아이디"/>", "enter", 50);
					
			} else if (Global.validator.checker["minlength"](form.elements[field].value, 5) == false) {
				msg = Global.validator.getMessage("minlength", "<spring:message code="필드:멤버:아이디"/>", "enter", 5);

			}
			if (msg != "") {
				$.alert({
					message : msg, 
					button1 : {
						callback : function() {
							form.elements[field].focus();
						}
					}
				});
				return false;	
			}
			return true;
		};
		action.config.fn.complete = function(action, data) {
			if (data.duplicated == true) {
				form.elements["duplicatedMemberId"].value = "Y";
				$.alert({
					message : "<spring:message code="글:멤버:이미사용중인아이디입니다"/>"
				});
			} else {
				form.elements["duplicatedMemberId"].value = "N";
				$.alert({
					message : "<spring:message code="글:멤버:사용가능한아이디입니다"/>" 
				});
			}
		};
	} else if (field == "nickname") {
		action.config.parameters = "nickname=" + form.elements[field].value;
	
		action.config.fn.validate = function() {
			var msg = "";
			if (Global.validator.checker["!null"](form.elements[field].value) == false) {
				msg = Global.validator.getMessage("!null", "<spring:message code="필드:멤버:닉네임"/>", "enter");

			}
			if (Global.validator.checker["maxlength"](form.elements[field].value, 50) == false) {
				msg = Global.validator.getMessage("maxlength", "<spring:message code="필드:멤버:닉네임"/>", "enter", 50);

			}
			if (msg != "") {
				$.alert({
					message : msg, 
					button1 : {
						callback : function() {
							form.elements[field].focus();
						}
					}
				});
				return false;	
			}
			return true;
		};
		action.config.fn.complete = function(action, data) {
			if (data.duplicated == true) {
				form.elements["duplicatedNickname"].value = "Y";
				$.alert({
					message : "<spring:message code="글:멤버:이미사용중인닉네임입니다"/>"
				});
			} else {
				form.elements["duplicatedNickname"].value = "N";
				$.alert({
					message : "<spring:message code="글:멤버:사용가능한닉네임입니다"/>" 
				});
			}
		};
	}
	action.run();
};
/**
 * 아이디 변경됨
 */
onChangeMemberId = function() {
	var form = UT.getById(forInsert.config.formId);
	form.elements["duplicatedMemberId"].value = "Y";
};
/**
 * 사진 삭제
 */
doDeletePhoto = function() {
	var form = UT.getById(forInsert.config.formId);
	form.elements["photo"].value = "";
	
	var $photo = jQuery("#member-photo");
	$photo.attr("src", imageBlank);
	$photo.siblings(".delete").hide();
};

/**
 * 분류정보 세팅
 */
doSetCategorySeq = function(seq) {
	var form = UT.getById(forInsert.config.formId);
	form.elements["categoryOrganizationSeq"].value = (typeof seq === "undefined" || seq == null ? "" : seq);
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchMember.jsp"/>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="statusCd" value="approval">
	<input type="hidden" name="joiningRolegroupSeq" value="1">
	<input type="hidden" name="duplicatedMemberId" value="Y">
	<input type="hidden" name="duplicatedNickname" value="Y">
	<input type="hidden" name="photo"/>
	<input type="hidden" name="memberStatusCd" value="<c:out value="${CD_MEMBER_STATUS_APPROVAL}"/>"/>
	<input type="hidden" name="smsYn" value="Y"/>
	<input type="hidden" name="emailYn" value="Y"/>
	<input type="hidden" name="password" value="111111" />
	<input type="hidden" name="verifyPassword" value="111111" />
	<input type="hidden" name="nickname" value="운영자" />
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:아이디"/><span class="star">*</span></th>
			<td colspan="4">
				<input type="text" name="memberId" style="width:150px;ime-mode:disabled;" onchange="onChangeMemberId()">
				<a href="javascript:void(0)" onclick="doCheckDuplicate('memberId')" class="btn gray"><span class="small"><spring:message code="버튼:중복검사"/></span></a>
				<span class="comment"><spring:message code="글:X자이상입력하십시오" arguments="5"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이름"/><span class="star">*</span></th>
			<td colspan="4"><input type="text" name="memberName" style="width:150px;"></td>
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
<%-- 			<th><spring:message code="필드:멤버:이름"/><span class="star">*</span></th>
			<td><input type="text" name="memberName" style="width:150px;"></td> --%>
			<%-- <th><spring:message code="필드:멤버:회원구분"/></th>
			<td>
				<select name="jobTypeCd" class="select">
					<aof:code type="option" codeGroup="JOB_TYPE" />
				</select>
			</td>
			--%>
<%-- 			<th><spring:message code="필드:멤버:이메일개인"/></th>
			<td><input type="text" name="email" style="width:250px;"></td>
			<td rowspan="2">
				<c:set var="memberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
				<div class="photo photo-120">
					<img src="${memberPhoto}" id="member-photo" title="<spring:message code="필드:멤버:사진"/>">
					<div id="uploader" class="uploader"></div>
					<div class="delete" 
					     style="display:none;" 
					     onclick="doDeletePhoto()" title="<spring:message code="버튼:삭제"/>">
					</div>
				</div>
			</td> --%>
		</tr>
	</tbody>
	</table>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="javascript:void(0)" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>
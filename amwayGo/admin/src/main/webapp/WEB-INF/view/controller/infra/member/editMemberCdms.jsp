<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata 		= null;
var forUpdate   		= null;
var forDelete   		= null;
var forUpdatePassword   = null;
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

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/member/cdms/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/member/cdms/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/member/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};
	
	forUpdatePassword = $.action("layer", {formId : "FormUpdate"});
	forUpdatePassword.config.url = "<c:url value="/member/password/popup.do"/>";
	forUpdatePassword.config.options.width  = 500;
	forUpdatePassword.config.options.height = 350;
	forUpdatePassword.config.options.position = "middle";
	forUpdatePassword.config.options.title  = "<spring:message code="글:멤버:비밀번호변경"/>";

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
		title : "<spring:message code="필드:멤버:이메일"/>",
		name : "email",
		data : ["email"],
		check : {
			maxlength : 200
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:모바일전화번호"/>",
		name : "phoneMobile",
		data : ["number"],
		check : {
			maxlength : 12
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:집전화번호"/>",
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
doUpdate = function() {
	forUpdate.run();
};
/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
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
	var form = UT.getById(forUpdate.config.formId);	
	var action = $.action("ajax");
	action.config.type   = "json";
	action.config.url    = "<c:url value="/member/duplicate.do"/>";
	if (field == "memberId") {
		action.config.parameters = "memberId=" + form.elements[field].value;
		action.config.parameters += "&memberSeq=" + form.elements["memberSeq"].value;

		action.config.fn.validate = function() {

			var msg = "";
			if (Global.validator.checker["!null"](form.elements[field].value) == false) {
				msg = Global.validator.getMessage("!null", "<spring:message code="필드:멤버:아이디"/>", "enter");

			} else if (Global.validator.checker["!space"](form.elements[field].value) == false) {
				msg = Global.validator.getMessage("!space", "<spring:message code="필드:멤버:아이디"/>", "enter");

			} else if (Global.validator.checker["regex"](form.elements[field].value, "[0-9A-Za-z.-_@]") == false) {
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
		action.config.parameters += "&memberSeq=" + form.elements["memberSeq"].value;
	
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
	var form = UT.getById(forUpdate.config.formId);
	form.elements["duplicatedMemberId"].value = "Y";
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
 * 비밀번호 변경 팝업
 */
 doUpdatePassword = function() {
	 forUpdatePassword.run();
};

/**
 * 소속선택
 */
doBrowseCompany = function() {
	FN.doOpenCompanyPopup({url:"<c:url value="/company/cdms/list/popup.do"/>", title: "<spring:message code="필드:멤버:소속"/>", callback:"doSetCompany"});
};

/**
 * 소속 선택
 */
doSetCompany = function(returnValue) {
	if (returnValue != null) {
		var form = UT.getById(forUpdate.config.formId);	
		form.elements["companySeq"].value = returnValue.companySeq;
		form.elements["companyName"].value = returnValue.companyName;
	}
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
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 110px" />
		<col/>
		<col style="width: 150px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:이름"/>*</th>
			<td><c:out value="${detail.member.memberName}"/></td>
			<td class="align-c" rowspan="4">
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
			<th><spring:message code="필드:멤버:아이디"/></th>
			<td>
				<c:out value="${detail.member.memberId}"/>&nbsp;
				<a href="javascript:void(0)" onclick="doUpdatePassword()" class="btn black"><span class="mid"><spring:message code="버튼:비밀번호변경"/></span></a>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:소속"/></th>
			<td>
				<input type="hidden" name="companySeqOld" value="${detail.company.companySeq }" />
				<input type="hidden" name="companySeq" value="${detail.company.companySeq }" />
				<input type="text" name="companyName" value="${detail.company.companyName }" />
				<a href="javascript:void(0)" onclick="doBrowseCompany()" class="btn black"><span class="mid"><spring:message code="버튼:소속선택"/></span></a>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:업무"/></th>
			<td>
				<select name="cdmsTaskTypeCd">
					<aof:code type="option" codeGroup="CDMS_TASK" selected="${detail.admin.cdmsTaskTypeCd }" />
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이메일"/></th>
			<td colspan="2"><input type="text" name="email" value="<c:out value="${detail.member.email}"/>" style="width:250px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:모바일전화번호"/></th>
			<td colspan="2"><input type="text" name="phoneMobile" value="<c:out value="${detail.member.phoneMobile}"/>" style="width:250px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:집전화번호"/></th>
			<td colspan="2"><input type="text" name="phoneHome" value="<c:out value="${detail.member.phoneHome}"/>" style="width:250px;"></td>
		</tr>
	</tbody>
	</table>
	</form>
	
	<div class="lybox-btn">
		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
			<div class="lybox-btn-l">
				<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
			</div>
		</c:if>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="memberSeq" value="<c:out value="${detail.member.memberSeq}"/>"/>
	</form>
	
</body>
</html>
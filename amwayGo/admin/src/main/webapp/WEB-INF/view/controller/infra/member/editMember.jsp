<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
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
	forListdata.config.url    = "<c:url value="/member/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/member/update.do"/>";
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
		title : "<spring:message code="필드:멤버:아이디"/>",
		name : "memberId",
		data : ["!null", "!space"],
		check : {
			maxlength : 30,
			minlength : 5
		}
	});
	forUpdate.validator.set({
		message : "<spring:message code="글:멤버:아이디는영문숫자특수문자만가능합니다"/>",
		name : "memberId",
		check : {
			regex : "[0-9A-Za-z.-_@]"
		}
	});
	forUpdate.validator.set({
		message : "<spring:message code="글:멤버:아이디중복검사를실시하십시오"/>",
		name : "duplicatedMemberId",
		check : {
			eq : "N"
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:이름"/>",
		name : "memberName",
		data : ["!null"],
		check : {
			maxlength : 30
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:닉네임"/>",
		name : "nickname",
		check : {
			maxlength : 30
		}
	});
	forUpdate.validator.set({
		message : "<spring:message code="글:멤버:닉네임중복검사를실시하십시오"/>",
		name : "duplicatedNickname",
		check : {
			eq : "N"
		}
	});
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
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:상세주소"/>",
		name : "addressDetail",
		when : function() {
			var form = UT.getById(forUpdate.config.formId);
			if (form.elements["zipcode"].value != "" || form.elements["address"].value != "") {
				return true;
			}
			return false;
		},
		data : ["!null"],
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
 * 닉네임 변경됨
 */
onChangeNickname = function() {
	var form = UT.getById(forUpdate.config.formId);
	form.elements["duplicatedNickname"].value = "Y";
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
 * 우편번호찾기
 */
doBrowseZipcode = function() {
	FN.doOpenZipcodePopup({url:"<c:url value="/zipcode/main/popup.do"/>", title: "<spring:message code="필드:우편번호"/>", callback:"doSetAddress"});
};
/**
 * 우편번호(주소) 선택
 */
doSetAddress = function(returnValue) {
	if (returnValue != null) {
		var form = UT.getById(forUpdate.config.formId);	
		form.elements["zipcode"].value = returnValue.zipcode;
		form.elements["address"].value = returnValue.address;
		form.elements["addressDetail"].focus();
	}
};
/**
 * 소속선택
 */
doBrowseCompany = function() {
	FN.doOpenCompanyPopup({url:"<c:url value="/company/list/popup.do"/>", title: "<spring:message code="필드:멤버:소속"/>", callback:"doSetCompany"});
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
		<col style="width: 100px" />
		<col/>
		<col style="width: 140px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:아이디"/></th>
			<td>
				<input type="text" name="memberId" value="<c:out value="${detail.member.memberId}"/>" style="width:150px;ime-mode:disabled;" onchange="onChangeMemberId()">
				<a href="javascript:void(0)" onclick="doCheckDuplicate('memberId')" class="btn gray"><span class="small"><spring:message code="버튼:중복검사"/></span></a>
				<span class="comment"><spring:message code="글:X자이상입력하십시오" arguments="5"/></span>
			</td>
			<td rowspan="5">
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
			<th><spring:message code="필드:멤버:이름"/></th>
			<td><input type="text" name="memberName" value="<c:out value="${detail.member.memberName}"/>" style="width:150px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:닉네임"/></th>
			<td>
				<input type="text" name="nickname" value="<c:out value="${detail.member.nickname}"/>" style="width:150px;" onchange="onChangeNickname()">
				<a href="javascript:void(0)" onclick="doCheckDuplicate('nickname')" class="btn gray"><span class="small"><spring:message code="버튼:중복검사"/></span></a>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:소속"/></th>
			<td>
				<input type="hidden" name="oldCompanySeq" value="<c:out value="${detail.member.companySeq}"/>">
				<input type="hidden" name="companySeq" value="<c:out value="${detail.member.companySeq}"/>">
				<input type="text" name="companyName" value="<c:out value="${detail.company.companyName}"/>" style="width:350px;">
				<a href="javascript:void(0)" onclick="doBrowseCompany()" class="btn gray"><span class="small"><spring:message code="버튼:소속선택"/></span></a>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:업무"/></th>
			<td colspan="2">
				<select name="taskCd">
					<option value=""></option>
					<aof:code type="option" codeGroup="TASK" selected="${detail.member.taskCd}"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이메일"/></th>
			<td colspan="2"><input type="text" name="email" value="<c:out value="${detail.member.email}"/>" style="width:350px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:모바일전화번호"/></th>
			<td colspan="2">
				<input type="text" name="phoneMobile" value="<c:out value="${detail.member.phoneMobile}"/>" style="width:150px;">
				<span class="comment"><spring:message code="글:멤버:구분자없이숫자만입력하십시오"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:집전화번호"/></th>
			<td colspan="2">
				<input type="text" name="phoneHome" value="<c:out value="${detail.member.phoneHome}"/>" style="width:150px;">
				<span class="comment"><spring:message code="글:멤버:구분자없이숫자만입력하십시오"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:주소"/></th>
			<td colspan="2">
				<input type="text" name="zipcode" value="<c:out value="${detail.member.zipcode}"/>" style="width:50px;text-align:center;">
				<a href="javascript:void(0)" onclick="doBrowseZipcode()" class="btn gray"><span class="small"><spring:message code="버튼:우편번호찾기"/></span></a>
				<br>
				<input type="text" name="address" value="<c:out value="${detail.member.address}"/>" style="width:350px;">
				<input type="text" name="addressDetail" value="<c:out value="${detail.member.addressDetail}"/>" style="width:350px;">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:상태"/></th>
			<td colspan="2">
				<select name="statusCd">
					<option value=""></option>
					<aof:code type="option" codeGroup="MEMBER_STATUS" selected="${detail.member.statusCd}"/>
				</select>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="memberSeq" value="<c:out value="${detail.member.memberSeq}"/>"/>
	</form>

	<ul class="buttons">
		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
			<li class="left"><a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a></li>
		</c:if>
		
		<li class="right">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</li>
	</ul>
	
</body>
</html>
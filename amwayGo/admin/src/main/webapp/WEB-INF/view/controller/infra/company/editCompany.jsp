<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
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
	forListdata.config.url    = "<c:url value="/company/cdms/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/company/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/company/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = doCompleteDelete;

	setValidate();
	
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:소속:소속"/>",
		name : "companyName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:소속:사업자번호"/>",
		name : "businessNumber",
		data : ["number"],
		check : {
			maxlength : 20
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:소속:전화번호"/>",
		name : "phoneCompany",
		data : ["number"],
		check : {
			maxlength : 12
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:소속:팩스번호"/>",
		name : "phoneFax",
		data : ["number"],
		check : {
			maxlength : 12
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:소속:상세주소"/>",
		name : "addressDetail",
		when : function() {
			var form = UT.getById(forUpdate.config.formId);
			if (form.elements["zipcode"].value != "" || form.elements["address"].value != "") {
				return true;
			}
			return false;
		},
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
 * 목록삭제 완료
 */
doCompleteDelete = function(success) {
	if(success > 0){
		$.alert({
			message : "<spring:message code="글:소속:X명의소속회원이있습니다"/>".format({0:success}),
			button1 : {
				callback : function() {
					doList();
				}
			}
		});
	} else {
		$.alert({
			message : "<spring:message code="글:삭제되었습니다"/>",
			button1 : {
				callback : function() {
					doList();
				}
			}
		});
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
		<c:import url="srchCompany.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="companySeq" value="<c:out value="${detail.company.companySeq}"/>"/>
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:소속:소속"/><span class="star">*</span></th>
			<td><input type="text" name="companyName" value="<c:out value="${detail.company.companyName}"/>" style="width:300px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:사업자번호"/></th>
			<td>
				<input type="text" name="businessNumber" value="<c:out value="${detail.company.businessNumber}"/>" style="width:150px;">
				<span class="comment"><spring:message code="글:소속:구분자없이숫자만입력하십시오"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:전화번호"/></th>
			<td>
				<input type="text" name="phoneOffice" value="<c:out value="${detail.company.phoneOffice}"/>" style="width:150px;">
				<span class="comment"><spring:message code="글:소속:구분자없이숫자만입력하십시오"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:팩스번호"/></th>
			<td>
				<input type="text" name="phoneFax" value="<c:out value="${detail.company.phoneFax}"/>" style="width:150px;">
				<span class="comment"><spring:message code="글:소속:구분자없이숫자만입력하십시오"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:주소"/></th>
			<td>
				<input type="text" name="zipcode" value="<c:out value="${detail.company.zipcode}"/>" style="width:60px;text-align:center;">
				<a href="javascript:void(0)" onclick="doBrowseZipcode()" class="btn black"><span class="mid"><spring:message code="버튼:우편번호찾기"/></span></a>
				<br>
				<input type="text" name="address" value="<c:out value="${detail.company.address}"/>" style="width:350px;">
				<input type="text" name="addressDetail" value="<c:out value="${detail.company.addressDetail}"/>" style="width:350px;">
			</td>
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
		<input type="hidden" name="companySeq" value="<c:out value="${detail.company.companySeq}"/>"/>
	</form>
	
</body>
</html>
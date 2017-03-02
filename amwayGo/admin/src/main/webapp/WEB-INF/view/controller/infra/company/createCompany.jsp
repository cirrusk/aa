<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COMPANY_TYPE_CDMS" value="${aoffn:code('CD.COMPANY_TYPE.CDMS')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
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
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/company/insert.do"/>";
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
		title : "<spring:message code="필드:소속:소속"/>",
		name : "companyName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:소속:사업자번호"/>",
		name : "businessNumber",
		data : ["number"],
		check : {
			maxlength : 20
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:소속:전화번호"/>",
		name : "phoneCompany",
		data : ["number"],
		check : {
			maxlength : 12
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:소속:팩스번호"/>",
		name : "phoneFax",
		data : ["number"],
		check : {
			maxlength : 12
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:소속:상세주소"/>",
		name : "addressDetail",
		when : function() {
			var form = UT.getById(forInsert.config.formId);
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
		var form = UT.getById(forInsert.config.formId);	
		form.elements["zipcode"].value = returnValue.zipcode;
		form.elements["address"].value = returnValue.address;
		form.elements["addressDetail"].focus();
	}
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCompany.jsp"/>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
		<input type="hidden" name="companyTypeCd" value="<c:out value="${CD_COMPANY_TYPE_CDMS}"/>" />
		
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:소속:소속"/><span class="star">*</span></th>
			<td><input type="text" name="companyName" style="width:350px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:사업자번호"/></th>
			<td>
				<input type="text" name="businessNumber" style="width:150px;">
				<span class="comment"><spring:message code="글:소속:구분자없이숫자만입력하십시오"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:전화번호"/></th>
			<td>
				<input type="text" name="phoneOffice" style="width:150px;">
				<span class="comment"><spring:message code="글:소속:구분자없이숫자만입력하십시오"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:팩스번호"/></th>
			<td>
				<input type="text" name="phoneFax" style="width:150px;">
				<span class="comment"><spring:message code="글:소속:구분자없이숫자만입력하십시오"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:주소"/></th>
			<td>
				<input type="text" name="zipcode" style="width:60px;text-align:center;">
				<a href="javascript:void(0)" onclick="doBrowseZipcode()" class="btn black"><span class="mid"><spring:message code="버튼:우편번호찾기"/></span></a>
				<br>
				<input type="text" name="address" style="width:350px;">
				<input type="text" name="addressDetail" style="width:350px;">
			</td>
		</tr>
	</tbody>
	</table>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>
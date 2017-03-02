<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forInsert   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	// validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert = $.action("submit", {formId : "FormInsert"}); 
	forInsert.config.url             = "<c:url value="/code/sub/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = function(statusCode) {
		if(statusCode == ""){
			$.alert({
				message : "<spring:message code="글:저장되었습니다"/>",
				button1 : {
					callback : function() {
						var par = $layer.dialog("option").parent;
						if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
							par["<c:out value="${param['callback']}"/>"].call(this);
						}
						$layer.dialog("close");
					}
				}
			});
		} else {
			$.alert({
				message : "<spring:message code="글:코드:삭제된코드와중복혹은DBAccess에러입니다"/>".format({0:statusCode})
			});
		}
	};
	
	setValidate();
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		message : "<spring:message code="글:코드:코드중복검사를실시하십시오"/>",
		name : "duplicatedCode",
		check : {
			eq : "N"
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:코드:코드"/>",
		name : "code",
		data : ["!null"],
		check : {
			maxlength : 50
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:코드:코드명"/>",
		name : "codeName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:코드:참조1"/>",
		name : "codeNameEx1",
		check : {
			maxlength : 100
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:코드:참조2"/>",
		name : "codeNameEx2",
		check : {
			maxlength : 100
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:코드:참조3"/>",
		name : "codeNameEx3",
		check : {
			maxlength : 100
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:코드:설명"/>",
		name : "description",
		check : {
			maxlength : 1000
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
 * 코드중복검사
 */
doCheckDuplicate = function() {
	var form = UT.getById(forInsert.config.formId);	
	var codeVal = form.elements["code"].value;
	form.elements["code"].value = codeVal.toUpperCase();
	
	var action = $.action("ajax", {formId : "FormInsert"});
	action.config.type   = "json";
	action.config.url    = "<c:url value="/code/duplicate.do"/>";
	action.validator.set({
		title : "<spring:message code="필드:코드:코드"/>",
		name : "code",
		data : ["!null"],
		check : {
			maxlength : 50
		}
	});
	
	action.config.fn.complete = function(action, data) {
		if (data.duplicated == true) {
			form.elements["duplicatedCode"].value = "Y";
			$.alert({
				message : "<spring:message code="글:코드:이미사용중인코드입니다"/>"
			});
		} else {
			form.elements["duplicatedCode"].value = "N";
			$.alert({
				message : "<spring:message code="글:코드:사용가능한코드입니다"/>" 
			});
		}
	};
	
	action.run();
};

/**
 * 아이디 변경됨
 */
 onChangeCode = function() {
	var form = UT.getById(forInsert.config.formId);
	form.elements["duplicatedCode"].value = "Y";
};
</script>
</head>

<body>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
		<input type="hidden" name="duplicatedCode" value="Y">
	<table id="insertTable" class="tbl-detail">
	<colgroup>
		<col style="width: 30%" />
		<col style="width: 70%" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:코드:코드" /></th>
			<td>
				<input type="hidden" name="codeGroup" value="<c:out value="${condition.srchCodeGroup}"/>">
				<input type="text" name="code" maxlength="50" style="ime-mode:disabled;" onchange="onChangeCode()">
				<a href="javascript:void(0)" onclick="doCheckDuplicate()" class="btn gray"><span class="small"><spring:message code="버튼:중복검사"/></span></a>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:코드명" /></th>
			
			<td>
				<input type="text" name="codeName" maxlength="200">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:참조1" /></th>
			<td>
				<input type="text" name="codeNameEx1" maxlength="200">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:참조2" /></th>
			<td>
				<input type="text" name="codeNameEx2" maxlength="200">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:참조3" /></th>
			<td>
				<input type="text" name="codeNameEx3" maxlength="200">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:설명" /></th>
			<td>
				<textarea name="description" rows="5" cols="32" maxlength="2000"></textarea>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:사용" /></th>
			<td>
				<aof:code type="radio" codeGroup="YESNO" name="useYn" defaultSelected="Y" removeCodePrefix="true"/>
			</td>
		</tr>
	</table>
	</form>
	
    <div class="lybox-btn">
        <div class="lybox-btn-l">
        </div>
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <a href="#" onclick="doInsert()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>
            </c:if>
        </div>
    </div>
</body>
</html>
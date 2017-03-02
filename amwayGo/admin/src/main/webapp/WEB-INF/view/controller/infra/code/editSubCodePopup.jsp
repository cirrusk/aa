<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdate   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	// validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate = $.action("submit", {formId : "FormUpdate"}); 
	forUpdate.config.url             = "<c:url value="/code/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function(statusCode) {
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
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:코드:코드"/>",
		name : "code",
		data : ["!null"],
		check : {
			maxlength : 50
		}
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:코드:코드명"/>",
		name : "codeName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:코드:참조1"/>",
		name : "reference1",
		check : {
			maxlength : 100
		}
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:코드:참조2"/>",
		name : "reference2",
		check : {
			maxlength : 100
		}
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:코드:참조3"/>",
		name : "reference3",
		check : {
			maxlength : 100
		}
	});
	
	forUpdate.validator.set({
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
doUpdate = function() { 
	forUpdate.run();
};

</script>
</head>

<body>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<table id="insertTable" class="tbl-detail">
	<colgroup>
		<col style="width: 30%" />
		<col style="width: 70%" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:코드:코드" /></th>
			<td>
				<input type="hidden" name="codeGroup" value="<c:out value="${detail.code.codeGroup}"/>">
				<input type="hidden" name="code" value="<c:out value="${detail.code.code}"/>">
				<input type="hidden" name="sortOrder" value="<c:out value="${detail.code.sortOrder}"/>">
				<c:out value="${fn:replace(fn:replace(detail.code.code,detail.code.codeGroup,''),'::','')}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:코드명" /></th>
			
			<td>
				<input type="text" name="codeName" value="<c:out value="${detail.code.codeName}"/>" maxlength="200">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:참조1" /></th>
			<td>
				<input type="text" name="codeNameEx1" value="<c:out value="${detail.code.codeNameEx1}"/>" maxlength="200">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:참조2" /></th>
			<td>
				<input type="text" name="codeNameEx2" value="<c:out value="${detail.code.codeNameEx2}"/>" maxlength="200">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:참조3" /></th>
			<td>
				<input type="text" name="codeNameEx3" value="<c:out value="${detail.code.codeNameEx3}"/>" maxlength="200">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:설명" /></th>
			<td>
				<textarea name="description" rows="5" cols="32" maxlength="2000"><c:out value="${detail.code.description}"/></textarea>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:사용" /></th>
			<td>
				<aof:code type="radio" codeGroup="YESNO" name="useYn" selected="${detail.code.useYn}" defaultSelected="N" removeCodePrefix="true"/>
			</td>
		</tr>
	</table>
	</form>
	
    <div class="lybox-btn">
        <div class="lybox-btn-l">
        </div>
        <div class="lybox-btn-r">
            <a href="#" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
        </div>
    </div>
</body>
</html>
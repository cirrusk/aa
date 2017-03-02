<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSortOrderUpdate   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doSubInitializeLocal();
};
/**
 * 설정
 */
doSubInitializeLocal = function() {
	
	// 정렬순서 저장
	// validator를 사용하는 action은 formId를 생성시 setting한다
	forSortOrderUpdate = $.action("submit", {formId : "SubFormData"});
	forSortOrderUpdate.config.url             = "<c:url value="/code/sortorder/update.do"/>";
	forSortOrderUpdate.config.target          = "hiddenframe";
	forSortOrderUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>";
	forSortOrderUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forSortOrderUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSortOrderUpdate.config.fn.complete     = function() {
		
		var par = $layer.dialog("option").parent;
		if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
			par["<c:out value="${param['callback']}"/>"].call(this);
		}
		$layer.dialog("close");
	};
	
	setValidate();
};

setValidate = function() {
	forSortOrderUpdate.validator.set({
		title : "<spring:message code="필드:코드:정렬"/>",
		name : "sortOrders",
		data : ["!null"],
	});
	
	forSortOrderUpdate.validator.set({
		title : "<spring:message code="필드:코드:정렬"/>",
		name : "sortOrders",
		data : ["number"],
	});
	
	forSortOrderUpdate.validator.set(function(){
		var subCodeLength = parseInt('<c:out value="${fn:length(itemList)}"/>');

		var tempCnt = 0;
		
		//sequence map을 만든다.
		var map = new Map();
		for ( var i = 0; i < subCodeLength; i++) {
			map.put("key"+i, i+1);
		}
		
		// sequence가 제대로 들어가 있는지 확인할 map을 만든다.
		var compareMap = new Map();
		for ( var i = 0; i < subCodeLength; i++) {
			
			var sortOrderArr = $("input[name=sortOrders]");
			for ( var j = 0; j < sortOrderArr.length; j++) {
				if(sortOrderArr.eq(j).val() == map.get("key"+i)){
					compareMap.put("key"+i,sortOrderArr.eq(j).val());
				}
			}
		}
		
		if(compareMap.size() == subCodeLength){
			return true;
		} else {
			$.alert({
				message : "<spring:message code="글:코드:정렬순서가잘못되었습니다"/>"
			});
			return false;	
		}
			
	});
	
};

/**
 * 정렬순서를 저장하는 함수
 */
doUpdateSortUpdate = function() { 
	forSortOrderUpdate.run();
};
/**
 * 맵정의
 */
Map = function() {
	this.map = new Object();
};
Map.prototype = {
	put : function(key, value) {
		this.map[key] = value;
	},
	get : function(key) {
		return this.map[key];
	},
	containsKey : function(key) {
		return key in this.map;
	},
	containsValue : function(value) {
		for ( var prop in this.map) {
			if (this.map[prop] == value) {
				return true;
			}
		}
		return false;
	},
	isEmpty : function(key) {
		return (this.size() == 0);
	},
	clear : function() {
		for ( var prop in this.map) {
			delete this.map[prop];
		}
	},
	remove : function(key) {
		delete this.map[key];
	},
	keys : function() {
		var keys = new Array();
		for ( var prop in this.map) {
			keys.push(prop);
		}
		return keys;
	},
	values : function() {
		var values = new Array();
		for ( var prop in this.map) {
			values.push(this.map[prop]);
		}
		return values;
	},
	size : function() {
		var count = 0;
		for ( var prop in this.map) {
			count++;
		}
		return count;
	},
	toString : function() {
		var buffer = [];
		for ( var key in this.map) {
			var type = typeof this.map[key];
			var value = '"' + key + '":';

			value += type === "string" ? '"' : '';
			value += this.map[key];
			value += type === "string" ? '"' : '';
			buffer.push(value);
		}
		return "{" + buffer + "}";
	}
};
</script>
</head>

<body>

	<table>
	<colgroup>
		<col style="width: 100%" />
	</colgroup>
	<tr>
		<td id="containerLeft" style="vertical-align:top;">
			<form id="SubFormData" name="SubFormData" method="post" onsubmit="return false;">
			<table id="listSubTable" class="tbl-list">
			<colgroup>
				<col style="width: 40px" />
				<col style="width: auto;" />
				<col style="width: 60px;" />
			</colgroup>
			<thead>
				<tr>
					<th><spring:message code="필드:번호" /></th>
					<th><spring:message code="필드:코드:코드명" /></th>
					<th><spring:message code="필드:코드:정렬" /></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="row" items="${itemList}" varStatus="i">
				<tr>
			        <td><c:out value="${i.count}"/></td>
					<td>
						<c:out value="${row.codeName}" />
					</td>
					<td>
						<input type="text" name="sortOrders" value="<c:out value="${row.sortOrder}" />" style="width: 30px;text-align: center;">
						<input type="hidden" name="codeGroups" value="<c:out value="${row.codeGroup}" />">
						<input type="hidden" name="codes" value="<c:out value="${row.code}" />">
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty itemList}">
				<tr>
					<td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
				</tr>
			</c:if>
			</table>
			</form>
            <div class="lybox-btn">
                <div class="lybox-btn-l">
                </div>
                <div class="lybox-btn-r">
                    <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                        <a href="#" onclick="doUpdateSortUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
                    </c:if>
                </div>
            </div>
		</td>
	</tr>
	</table>
	
</body>
</html>
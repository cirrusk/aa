<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>

<html decorator="guideApi">
<head>
<title>API</title>
<script type="text/javascript">
var objectMenu = {
    menus : [
		{
			name : "login",
			menus : [
				{name : "로그인", file : "login/login"},
				{name : "로그인아웃", file : "login/loginOut"}
			]
		},
		{
			name : "myPage",
			menus : [
				{name : "주소록 목록", file : "mypage/messageAddressGroupList"},
				{name : "쪽지 목록", file : "mypage/messageReceiveList"},
				{name : "쪽지 삭제", file : "mypage/messageDelete"},
				{name : "쪽지 보내기", file : "mypage/messageSend"} 
			]
		},
		{
			name : "helpDesk",
			menus : [
				{name : "학습지원센터 게시판 목록", file : "helpdesk/listBoard"},
				{name : "학습지원센터 게시판 글 목록", file : "helpdesk/listBbs"},
				{name : "학습지원센터 게시판 카테고리 목록", file : "helpdesk/listCatagory"}
			]
		},
		{
			name : "ClassRoom",
			menus : [
				{name : "연도학기 코드목록", file : "classroom/listYear"},
				{name : "수강과정 조회", file : "classroom/listMyCourse"},
				{name : "수강취소", file : "classroom/editCourseApply"},
				{name : "온라인학습 목록", file : "classroom/listOrganization"},
				{name : "유형별 학습 리스트", file : "classroom/listElement"},
				{name : "과정게시판 목록", file : "classroom/listBoard"},
				{name : "과정게시판 글 목록", file : "classroom/listBbs"},
				{name : "과정게시판 카테고리 목록", file : "classroom/listCatagory"},
				{name : "강의실 홈", file : "classroom/mainClassroom"}
			]
		}
		
	]
};
var forApiJson = null;
var forApiFile = null;
var startTime = 0;
initPage = function() {
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forApiJson = $.action("ajax");
	forApiJson.config.formId = "FormApi";
	forApiJson.config.type = "json";
	forApiJson.config.fn.before = function() {
		startTime = (new Date()).getTime();
		return true;
	};
	forApiJson.config.fn.complete = function(action, data) {
		doResponseData(data);
	};
	forApiJson.config.fn.validate = function() {
		var url = forApiJson.config.url;
		if (url.indexOf("{") > -1 || url.indexOf("}") > -1) {
			$.alert({message : "URL의경로변수를완성하십시오"});
			return false;
		}
		
		var $form = jQuery("#" + forApiJson.config.formId);
		var valid = true;
		$form.find(".required").each(function(){
			var $this = jQuery(this);
			if ($this.val() == "") {
				$.alert({message : "필수파라미터를입력하십시오"});
				valid = false;
				return false;
			}
		});
		return valid;
	};
	
	forApiFile = $.action("submit");
	forApiFile.config.formId = "FormApi";
	forApiFile.config.target = "hiddenframeapi";
	forApiFile.config.containerId = "executeResult";
	forApiFile.config.fn.before = function() {
		startTime = (new Date()).getTime();
		return true;
	};
	forApiFile.config.fn.validate = function() {
		var url = forApiFile.config.url;
		if (url.indexOf("{") > -1 || url.indexOf("}") > -1) {
			$.alert({message : "URL의경로변수를완성하십시오"});
			return false;
		}
		
		var $form = jQuery("#" + forApiFile.config.formId);
		var valid = true;
		$form.find(".required").each(function(){
			var $this = jQuery(this);
			if ($this.val() == "") {
				$.alert({message : "필수파라미터를입력하십시오"});
				valid = false;
				return false;
			}
		});
		return valid;
	};
	
};
/**
 * 개발가이드 상세정보
 */
doDetail = function(element) {
	doSelectedMenu(element);
	
	var $element = jQuery(element);
	var action = $.action("ajax");
	action.config.url = "<c:url value="/usr/api/file.do"/>";
	action.config.type = "json";
	action.config.parameters = "filename=" + $element.attr("file");
	action.config.containerId = "container";
	action.config.fn.complete = function(action, data) {
		doCallbackApi(data);
	};
	action.run();
};
/**
 * Api 상세정보 callback
 */
doCallbackApi = function(data) {
	if (typeof data === "object") {
		var $section = jQuery("#container");
		$section.empty();
		
		var html = [];
		html.push(UT.formatString(templateApi.api1(), {
			description : data.description,
			url : data.url,
			method : data.method
		}));
        if (typeof data.rest === "string") {
            html.push("<div class='description'>" + data.rest + "</div>");
        }
		
		if (typeof data.request === "object") {
			var sub = [];
			for (var index in data.request) {
				var req = data.request[index];
				var input = UT.formatString(templateApi.api5(), {
					name : req.name, 
					value : typeof req.value === "string" ? req.value : "",
					type : "file" == req.type ? "file" : "text",
					required : true === req.required ? "required" : ""  
				});
				sub.push(UT.formatString(templateApi.api3(), {
					name : req.name, 
					type : req.type,
					length : req.length,
					input : input,
					defaults : typeof req.defaults === "undefined" ? '' : req.defaults,
					description : req.description
				}));
			}
			html.push(UT.formatString(templateApi.api2(), {request : sub.join("")}));
		} else {
			html.push(UT.formatString(templateApi.api2(), {request : templateApi.api4()}));
		}
		
		
		if (typeof data.response === "object") {
			var sub = [];
			for (var index in data.response) {
				var res = data.response[index];
				sub.push(UT.formatString(templateApi.api7(), {
					name : res.name, 
					type : res.type,
					description : res.description,
					list : ""
				}));
				if (("list" == res.type || "object" == res.type) && typeof res.children === "object") {
					for (var x in res.children) {
						var row = res.children[x];
						sub.push(UT.formatString(templateApi.api7(), {
							name : row.name, 
							type : row.type,
							description : row.description,
							indent : "indent-data"
						}));
					}
				}
			}
			html.push(UT.formatString(templateApi.api6(), {response : sub.join("")}));
		} else {
			html.push(UT.formatString(templateApi.api6(), {response : templateApi.api8()}));
		}

		html.push(templateApi.api9());
		
		$section.append(html.join(""));
	}
};
/**
 * api를 실행시킨다
 */
doRunApi = function() {
	var $form = jQuery("#" + forApiJson.config.formId);
	var $file = $form.find(":input[type='file']");
	if ($file.length > 0 && $file.val() != "") {
		forApiFile.config.url = jQuery("#apiUrl").val();
		if (jQuery.browser.msie) {
			forApiFile.config.url += "?ie=ie";
		}
		forApiFile.config.method = jQuery("#apiMethod").text();
		var $target = jQuery("#" + forApiFile.config.target);
		$target.load(function() {
			var html = "";
			if(this.contentWindow) {
				 html = this.contentWindow.document.body ? this.contentWindow.document.body.innerHTML : "";
			} else if (this.contentDocument) {
				 html = this.contentDocument.document.body ? this.contentDocument.document.body.innerHTML : "";
			}
			var data = jQuery.parseJSON(jQuery(html).text());
			doResponseData(data);
			$form.get(0).reset();
			$target.unbind("load");
		});
		setTimeout(function() {
			forApiFile.run();
		}, 500);
	} else {
		forApiJson.config.url = jQuery("#apiUrl").val();
		forApiJson.config.method = jQuery("#apiMethod").text();
		forApiJson.run();
	}
};
/**
 * 응답 정보
 */
doResponseData = function(data) {
	var executeTime = String((new Date()).getTime() - startTime).toComma();
	var html = [];
	html.push(UT.formatString(templateApi.api10(), {executeTime : executeTime}));
	if (typeof data === "object") {
		html.push("<div class='result'>");
		html.push(doJsonToString(data, 0));
		html.push("</div>");
	} else {
        html.push("<div class='result'>");
        html.push(data);
        html.push("</div>");
	}
	jQuery("#executeResult").html(html.join("")).show();
	
	var $right = jQuery(".section-right");
	$right.scrollTop($right.get(0).scrollHeight);
};
/**
 * json 을 string으로 만들기
 */
doJsonToString = function (json, depth) {
	var indent = "style='padding-left:" + ((depth + 1) * 10) + "px;'";
	if (json instanceof Object) {  
		var sOutput = [];  
		if (json.constructor === Array) {  
			for (var nId = 0; nId < json.length; nId++) {
				sOutput.push(doJsonToString(json[nId], depth + 1));
			}
			return "[" + sOutput.join("") + "]";  
		}  
		if (json.toString !== Object.prototype.toString) { 
			return "\"" + json.toString().replace(/"/g, "\\$&") + "\""; 
		}  
		for (var sProp in json) { 
			sOutput.push("<li " + indent + ">\"" + sProp.replace(/"/g, "\\$&") + "\":" + doJsonToString(json[sProp], depth + 1) + "</li>"); 
		}  
		return "<ul><li>{</li>" + sOutput.join("") + "<li>}</li></ul>";
	}  
	return typeof json === "string" ? "\"" + json.replace(/"/g, "\\$&") + "\"" : String(json);  
};
/**
 * 영역을 토글 시킨다
 */
doToggle = function(element) {
	var $element = jQuery(element);
	$element.closest("h4").next("div").toggle("blind");
};
/**
 * 목록형일경우 들여쓰기를 한다
 */
doIndent = function(depth) {
	var html = [];
	for (var i = 0; i < depth; i++) {
		html.push("&nbsp;&nbsp;&nbsp;");
	}
	return html.join("");
};
templateApi = {
	api1 : function() {
		var html = [];
		html.push("<h4>설명</h4>");
		html.push("<div class='description'>{description}</div>");
		html.push("<h4>URL</h4>");
		html.push("<div class='description'>");
		html.push("  <input type='text' id='apiUrl' value='{url}' class='input-url' style='margin-right:5px;'/>");
		html.push("  <strong id='apiMethod' style='margin-right:5px;'>{method}</strong>");
		html.push("  <button onclick='doRunApi()' class='button button-m button-color-3'>실행</button>");
		html.push("</div>");
		return html.join("");
	},
	api2 : function() {
		var html = [];
		html.push("<h4>파라미터</h4>");
		html.push("<div class='description'>");
		html.push("<form id='FormApi' name='FormApi' method='post' onsubmit='return false;' enctype='multipart/form-data'>");
		html.push("<table class='detail' id='requestInfo'>");
		html.push("<colgroup>");
		html.push("  <col style='width:170px;' />");
		html.push("  <col style='width:70px;' />");
		html.push("  <col style='width:50px;' />");
		html.push("  <col style='width:170px;' />");
		html.push("  <col style='width:100px;' />");
		html.push("  <col style='width:auto;' />");
		html.push("  <col />");
		html.push("</colgroup>");
		html.push("<thead>");
		html.push("  <tr>");
		html.push("    <th>요청변수</th>");
		html.push("    <th>변수타입</th>");
		html.push("    <th>길이</th>");
		html.push("    <th>변수값</th>");
		html.push("    <th>디폴트값</th>");
		html.push("    <th>설명</th>");
		html.push("  </tr>");
		html.push("</thead>");
		html.push("<tbody>{request}</tbody>");
		html.push("</table>");
		html.push("</form>");
		html.push("</div>");
		return html.join("");
	},
	api3 : function() {
		var html = [];
		html.push("<tr>");
		html.push("  <td>{name}</td>");
		html.push("  <td class='align-c'>{type}</td>");
		html.push("  <td class='align-c'>{length}</td>");
		html.push("  <td class='align-c'>{input}</td>");
		html.push("  <td class='align-c'>{defaults}</td>");
		html.push("  <td>{description}</td>");
		html.push("</tr>");
		return html.join("");
	},
	api4 : function() {
		var html = [];
		html.push("<tr>");
		html.push("  <td class='align-c' colspan='6'>파라미터가없습니다</td>");
		html.push("</tr>");
		return html.join("");
	},
	api5 : function() {
		var html = [];
		html.push("<input type='{type}' name='{name}' value='{value}' class='{required}'>");
		return html.join("");
	},
	api6 : function() {
		var html = [];
		html.push("<h4><a href='javascript:void(0)' onclick='doToggle(this)'>응답정보</a></h4>");
		html.push("<div class='description'>");
		html.push("<table class='detail' id='responseInfo'>");
		html.push("<colgroup>");
		html.push("  <col style='width:290px;' />");
		html.push("  <col style='width:70px;' />");
		html.push("  <col style='width:auto;' />");
		html.push("</colgroup>");
		html.push("<thead>");
		html.push("  <tr>");
		html.push("    <th>응답변수</th>");
		html.push("    <th>변수타입</th>");
		html.push("    <th>설명</th>");
		html.push("  </tr>");
		html.push("</thead>");
		html.push("<tbody>{response}</tbody>");
		html.push("</table>");
		html.push("</div>");
		return html.join("");
	},
	api7 : function() {
		var html = [];
		html.push("<tr>");
		html.push("  <td class='{indent}'>{name}</td>");
		html.push("  <td class='align-c'>{type}</td>");
		html.push("  <td>{description}</td>");
		html.push("</tr>");
		return html.join("");
	},
	api8 : function() {
		var html = [];
		html.push("<tr>");
		html.push("  <td class='align-c' colspan='3'>응답정보가없습니다</td>");
		html.push("</tr>");
		return html.join("");
	},
	api9 : function() {
		var html = [];
		html.push("<h4>실행결과</h4>");
		html.push("<div id='executeResult' class='description' style='display:none;'>");
		html.push("</div'>");
		return html.join("");
	},
	api10 : function() {
		var html = [];
		html.push("<div>");
		html.push("<span>실행시간 : </span>");
		html.push("<span style='color:#ff0000; font-weight:bold; margin-right:5px;'>{executeTime}</span>");
		html.push("<span style='margin-right:10px;'>milliseconds</span>");
		html.push("<a href='javascript:void(0)' onclick='doDetailResultCode()'>결과코드</a>");
		html.push("</div>");
		return html.join("");
	}
};
doDetailResultCode = function() {
	jQuery("#resultCode").dialog({
		title : "결과코드",
		width : 400,
		height : "auto",
	    resizable : false,
	    draggable : true,
	    modal : true,
	    closeOnEscape : true
	});
};
</script>
</head>
<body>

	<div class="section-right">
		<h3 class="breadcrumb"></h3>
		<div class="section-content" id="container"></div>
	</div>

	<div id="resultCode" style="display:none;">
		<table class="detail">
		<colgroup>
			<col style="width:100px;">
			<col style="width:auto;">
		</colgroup>
		<tr>
			<th>코드값</th>
			<th>설명</th>
		</tr>
		<tr>
			<td class="align-c">0</td>
			<td>성공</td>
		</tr>
		<tr>
			<td class="align-c">1000</td>
			<td>세션 없음</td>
		</tr>
		<tr>
			<td class="align-c">2000</td>
			<td>접근 권한 없음</td>
		</tr>
		<tr>
			<td class="align-c">3000</td>
			<td>필수 데이타</td>
		</tr>
		<tr>
			<td class="align-c">4000</td>
			<td>동일한 데이타 존재</td>
		</tr>
		<tr>
			<td class="align-c">4100</td>
			<td>하위 데이타 존재</td>
		</tr>
		<tr>
			<td class="align-c">5000</td>
			<td>파일 처리 에러</td>
		</tr>
		<tr>
			<td class="align-c">6000</td>
			<td>파라미터가 유효하지 않음</td>
		</tr>
		<tr>
			<td class="align-c">7000</td>
			<td>데이터가 유효하지 않음</td>
		</tr>
		<tr>
			<td class="align-c">9000</td>
			<td>기타</td>
		</tr>
		</table>
	</div>

</body>
</html>
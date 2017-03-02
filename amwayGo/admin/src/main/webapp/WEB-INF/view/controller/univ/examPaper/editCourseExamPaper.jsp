<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ONOFF_TYPE_OFF" value="${aoffn:code('CD.ONOFF_TYPE.OFF')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_ONOFF_TYPE_OFF = "<c:out value="${CD_ONOFF_TYPE_OFF}"/>";

var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
var forBrowseMaster = null;
var forListGroupkey = null;
var forBrowseProfessor = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doChangeRandom();
	
	doChangeOnOff();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/exampaper/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/exampaper/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/univ/exampaper/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};

	setValidate();

	forBrowseMaster = $.action("layer");
	forBrowseMaster.config.formId         = "FormBrowseCourse";
	forBrowseMaster.config.url            = "<c:url value="/univ/coursemaster/popup.do"/>";
	forBrowseMaster.config.options.width  = 700;
	forBrowseMaster.config.options.height = 500;
	forBrowseMaster.config.options.title  = "<spring:message code="필드:시험:교과목선택"/>";
	
	forBrowseProfessor = $.action("layer");
	forBrowseProfessor.config.formId         = "FormBrowseProfessor";
	forBrowseProfessor.config.url            = "<c:url value="/member/prof/list/popup.do"/>";
	forBrowseProfessor.config.options.width  = 700;
	forBrowseProfessor.config.options.height = 500;
	forBrowseProfessor.config.options.title  = "<spring:message code="글:시험:교수선택"/>";

	forListGroupkey = $.action("ajax");
	forListGroupkey.config.type = "json";
	forListGroupkey.config.formId = "FormGroupkey";
	forListGroupkey.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forListGroupkey.config.url  = "<c:url value="/univ/exampaper/groupkeys/ajax.do"/>";
	forListGroupkey.config.fn.complete = function(action, data) {
		if (data.listGroupKey != null) {
			var html = [];
			html.push("");
			for (var i = 0; i < data.listGroupKey.length; i++) {
				html.push("<input type='checkbox' name='groupKey' value='" + data.listGroupKey[i] + "'>");
				html.push("<label style='margin-right:5px;'> " + data.listGroupKey[i] + "</label>");
			}	
			jQuery("#listGroupkey").html(html.join(""));
		}
	};
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:시험지구분"/>",
		name : "examPaperTypeCd",
		data : ["!null","trim"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:교과목선택"/>",
		name : "courseMasterSeq",
		data : ["!null","trim"]
	});
	forUpdate.validator.set({
		message : "<spring:message code="글:시험:교수를선택하세요"/>",
		name : "profMemberSeq",
		data : ["!null","trim"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:시험지제목" />",
		name : "examPaperTitle",
		data : ["!null","trim"],
		check : {
			maxlength : 200
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:점수구분" />",
		name : "scoreTypeCd",
		data : ["!null","trim"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:점수" />",
		name : "score",
		data : ["!null","trim", "number"],
		check : {
			maxlength : 3,
			gt : 0
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:문제랜덤여부" />",
		name : "randomYn",
		data : ["!null","trim"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:출제그룹" />",
		name : "groupKey",
		data : ["!null","trim"],
		when : function() {
			var randomYn = UT.getCheckedValue(forUpdate.config.formId, "randomYn", "");
			return randomYn == "Y" ? true : false;
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
 * 교과목 찾기
 */
 doBrowseCourseMaster = function() {
	forBrowseMaster.run();
};
/**
 * 교수 찾기
 */
 doBrowseProfessor = function() {
	 forBrowseProfessor.run();
};
/**
 * 과정 선택
 */
doSelectCourse = function(returnValue) {
	if (returnValue != null) {
		var form = UT.getById(forUpdate.config.formId);
		form.elements["courseMasterSeq"].value = returnValue.courseMasterSeq != null ? returnValue.courseMasterSeq : ""; 
		form.elements["courseMasterTitle"].value = returnValue.courseTitle != null ? returnValue.courseTitle : ""; 

		var form2 = UT.getById(forListGroupkey.config.formId);
		form2.elements["courseMasterSeq"].value = form.elements["courseMasterSeq"].value;
		forListGroupkey.run();
	}
};
/**
 * 교강사 검색 팝업 리턴값 셋팅
 */
doSelectProfessor = function(returnValue) {
	var $form = jQuery("#"+forInsert.config.formId);
	$form.find(":input[name='profMemberSeq']").val(returnValue.memberSeq);
	$form.find(":input[name='profMemberName']").val(returnValue.memberName);
};
/**
 * 문제랜덤여부
 */
doChangeRandom = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var randomYn = $form.find(":input[name='randomYn']").filter(":checked").val();
	if (randomYn == "Y") {
		jQuery("#paparCount").hide(); 
		jQuery("#groupKeys").show(); 
		$form.find(":input[name='paperCount']").val("1");
	} else {
		jQuery("#paparCount").show();
		jQuery("#groupKeys").hide();
	}
	doChangePaperCount();
};
/**
 * 문제지수변경
 */
doChangePaperCount = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var randomYn = $form.find(":input[name='randomYn']").filter(":checked").val();
	if (randomYn == "Y") {
		$form.find(":input[name='shuffleYn']").each(function() {
			if (this.value == "N") {
				this.checked = true;
			}
		});
		jQuery("#shuffle").hide();
	} else {
		jQuery("#shuffle").show();
	}
};
/**
 * 온라인오프라인 변경
 */
doChangeOnOff = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var onOffCd = $form.find(":input[name='onOffCd']").val();
	if(onOffCd == CD_ONOFF_TYPE_OFF) {
		jQuery("#randomCd").hide();
		jQuery("#paparCount").hide();
	} else {
		jQuery("#randomCd").show();
		jQuery("#paparCount").show();
	}
}; 
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCourseExamPaper.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="examPaperSeq" value="<c:out value="${detail.courseExamPaper.examPaperSeq}"/>"/>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:시험:시험지구분"/></th>
			<td>
				<select name="examPaperTypeCd">
					<aof:code type="option" codeGroup="EXAM_PAPER_TYPE" selected="${detail.courseExamPaper.examPaperTypeCd}"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:교과목선택"/></th>
			<td>
				<input type="hidden" name="courseMasterSeq"   value="<c:out value="${detail.courseExamPaper.courseMasterSeq}"/>"/>
				<c:out value="${detail.courseMaster.courseTitle}"/>
<%-- 				<a href="javascript:void(0)" onclick="doBrowseCourseMaster()" class="btn gray"><span class="small"><spring:message code="버튼:시험:시험선택"/></span></a> --%>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:교수선택"/></th>
			<td>
				<span id="selectProfessor" style="padding-right: 10px;">
					<input type="hidden" name="profMemberSeq" value="<c:out value="${detail.courseExamPaper.profMemberSeq}"/>"/>
					<c:out value="${detail.courseExamPaper.profMemberName}" />
<%-- 					<a href="#" onclick="doBrowseProfessor()" class="btn gray"><span class="small"><spring:message code="버튼:시험:교수선택"/></span></a> --%>
				</span>
				<input type="checkbox" name="openYn" value="Y"  <c:if test="${detail.courseExamPaper.openYn eq 'Y'}">checked=checked</c:if> /><spring:message code="필드:시험:전체공개"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:시험지제목" /></th>
			<td><input type="text" name="examPaperTitle" value="<c:out value="${detail.courseExamPaper.examPaperTitle}"/>" style="width:90%;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:시험지형태"/></th>
			<td>
                <%/** TODO : 코드*/ %>
                <aof:code type="print" codeGroup="ONOFF_TYPE" name="onOffCdView" selected="${detail.courseExamPaper.onOffCd}"  />
                <input type="hidden" name="onOffCd" value="<c:out value="${detail.courseExamPaper.onOffCd}"/>"/>
            </td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:시험지설명"/></th>
			<td><textarea name="description" style="width:90%;height:30px;"><c:out value="${detail.courseExamPaper.description}"/></textarea></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:점수구분"/></th>
			<td>
				<select name="scoreTypeCd">
					<aof:code type="option" codeGroup="SCORE_TYPE" selected="${detail.courseExamPaper.scoreTypeCd}"/>
				</select>
				<input type="text" name="examPaperScore" value="<c:out value="${detail.courseExamPaper.examPaperScore}"/>" style="text-align:center; width:50px;"><spring:message code="글:시험:점"/>
			</td>
		</tr>
		<tr id="randomCd">
			<th><spring:message code="필드:시험:문제랜덤여부"/></th>
			<td><aof:code type="radio" name="randomYn" codeGroup="YESNO" selected="${detail.courseExamPaper.randomYn}" onclick="doChangeRandom()" labelStyleClass="radioLabel" removeCodePrefix="true"/></td>
		</tr>
		<tr id="groupKeys" style="display:<c:if test="${detail.courseExamPaper.randomYn eq 'N'}">none</c:if>;">
			<c:set var="groupKeys" value=""/>
			<c:forEach var="row" items="${listGroupKey}" varStatus="i">
				<c:if test="${i.first eq false}">
					<c:set var="groupKeys" value="${groupKeys},"/>
				</c:if>
				<c:set var="groupKeys" value="${groupKeys}${row}= ${row}"/>
			</c:forEach>
			<th><spring:message code="필드:시험:출제그룹"/></th>
			<td id="listGroupkey">
				<aof:code type="checkbox" name="groupKey" codeGroup="${groupKeys}" selected="${detail.courseExamPaper.groupKey}" labelStyleClass="checkboxLabel"/>
			</td>
		</tr>
		<tr id="paparCount" style="display:none;">
			<th><spring:message code="필드:시험:문제지수"/></th>
			<td>
				<select name="paperCount" style="width:50px;" onchange="doChangePaperCount()">
					<aof:code type="option" codeGroup="1=1,2=2,3=3,4=4,5=5" selected="${detail.courseExamPaper.paperCount}"/>
				</select>
				<span id="shuffle">
					<strong><spring:message code="필드:시험:문제순서섞기"/></strong>
					<aof:code type="radio" name="shuffleYn" codeGroup="YESNO" selected="${detail.courseExamPaper.shuffleYn}" labelStyleClass="radioLabel"/>
				</span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:사용여부"/></th>
			<td><aof:code type="radio" name="useYn" codeGroup="YESNO" ref="2" selected="${detail.courseExamPaper.useYn}" labelStyleClass="radioLabel" removeCodePrefix="true"/></td>
		</tr>
	</tbody>
	</table>
	</form>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="examPaperSeq" value="<c:out value="${detail.courseExamPaper.examPaperSeq}"/>"/>
	</form>
	
	<form id="FormGroupkey" name="FormGroupkey" method="post" onsubmit="return false;">
		<input type="hidden" name="courseMasterSeq">
	</form>
	
<div class="lybox-btn">
	<div class="lybox-btn-l">
		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
			<c:choose>
				<c:when test="${detail.courseExamPaper.useCount gt 0}">
					<div class="comment"><spring:message code="글:시험:활용중인데이터는삭제할수없습니다"/></div>
				</c:when>
				<c:otherwise>
					<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
				</c:otherwise>
			</c:choose>
		</c:if>
	</div>
	<div class="lybox-btn-r">
		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
			<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
		</c:if>
		<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
	</div>
</div>
	
</body>
</html>
<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ONOFF_TYPE_ON"        value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_ONOFF_TYPE_OFF"       value="${aoffn:code('CD.ONOFF_TYPE.OFF')}"/>
<c:set var="CD_EXAM_PAPER_TYPE_EXAM" value="${aoffn:code('CD.EXAM_PAPER_TYPE.EXAM')}"/>
<c:set var="CD_EXAM_PAPER_TYPE_QUIZ" value="${aoffn:code('CD.EXAM_PAPER_TYPE.QUIZ')}"/>
<c:set var="CD_SCORE_TYPE_001"       value="${aoffn:code('CD.SCORE_TYPE.001')}"/>
<c:set var="CD_SCORE_TYPE_002"       value="${aoffn:code('CD.SCORE_TYPE.002')}"/>
<c:set var="CD_SCORE_TYPE_003"       value="${aoffn:code('CD.SCORE_TYPE.003')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_ONOFF_TYPE_ON  = "<c:out value="${CD_ONOFF_TYPE_ON}"/>";
var CD_ONOFF_TYPE_OFF = "<c:out value="${CD_ONOFF_TYPE_OFF}"/>";
var CD_SCORE_TYPE_001 = "<c:out value="${CD_SCORE_TYPE_001}"/>";
var CD_SCORE_TYPE_002 = "<c:out value="${CD_SCORE_TYPE_002}"/>";
var CD_SCORE_TYPE_003 = "<c:out value="${CD_SCORE_TYPE_003}"/>";
var CD_CATEGORY_TYPE_DEGREE = "<c:out value="${CD_CATEGORY_TYPE_DEGREE}"/>";
var CD_EXAM_PAPER_TYPE_EXAM = "<c:out value="${CD_EXAM_PAPER_TYPE_EXAM}"/>";
var CD_EXAM_PAPER_TYPE_QUIZ = "<c:out value="${CD_EXAM_PAPER_TYPE_QUIZ}"/>";

var forListdata = null;
var forInsert   = null;
var forDetail = null;
var forBrowseMaster = null;
var forListGroupkey = null;
var forBrowseProfessor = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doChangeRandom();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/exampaper/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/exampaper/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = doCompleteInsert;

	setValidate();

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/exampaper/detail.do"/>";
	
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
				html.push("<input type='checkbox' name='groupKey' value='" + data.listGroupKey[i] + "'/>");
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
	forInsert.validator.set({
		message : "<spring:message code="글:시험:교과목을선택하세요"/>",
		name : "courseMasterSeq",
		data : ["!null","trim"]
	});
	forInsert.validator.set({
		message : "<spring:message code="글:시험:교수를선택하세요"/>",
		name : "profMemberSeq",
		data : ["!null","trim"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:시험지제목" />",
		name : "examPaperTitle",
		data : ["!null","trim"],
		check : {
			maxlength : 200
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:점수구분" />",
		name : "scoreTypeCd",
		data : ["!null","trim"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:점수" />",
		name : "examPaperScore",
		data : ["!null","trim", "number"],
		check : {
			maxlength : 3,
			gt : 0
		},
		when : function() {
			var $form = jQuery("#" + forInsert.config.formId);
			var examScoreType = $form.find(":input[name='scoreTypeCd']").val();
			return examScoreType == CD_SCORE_TYPE_002 ? false : true;
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:문제랜덤여부" />",
		name : "randomYn",
		data : ["!null","trim"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:출제그룹" />",
		name : "groupKey",
		data : ["!null","trim"],
		when : function() {
			var randomYn = UT.getCheckedValue(forInsert.config.formId, "randomYn", "");
			return randomYn == "Y" ? true : false;
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
 * 저장완료
 */
 doCompleteInsert = function(result) {
	result = result.replaceAll("&#034;", '"');
	result = jQuery.parseJSON(result);
	if (result.success == 1) {
		$.alert({
			message : "<spring:message code="글:저장되었습니다"/>",
			button1 : {
				callback : function() {
					doDetail({'examPaperSeq' : result.examPaperSeq});
				}
			}
		});
	} else {
		$.alert({
			message : "<spring:message code="글:저장되지않았습니다"/>"
		});
	}
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forDetail.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 수정화면 실행
	forDetail.run();
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
		var form = UT.getById(forInsert.config.formId);
		form.elements["courseMasterSeq"].value = returnValue.courseMasterSeq != null ? returnValue.courseMasterSeq : ""; 
		form.elements["courseMasterTitle"].value = returnValue.courseTitle != null ? returnValue.courseTitle : ""; 
		form.elements["categoryTypeCd"].value = returnValue.categoryTypeCd != null ? returnValue.categoryTypeCd : ""; 
		
		var form2 = UT.getById(forListGroupkey.config.formId);
		form2.elements["courseMasterSeq"].value = form.elements["courseMasterSeq"].value;
		forListGroupkey.run();
		
		doDisableOffLine();
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
	var $form = jQuery("#" + forInsert.config.formId);
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
	var $form = jQuery("#" + forInsert.config.formId);
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
doChangeOnOff = function(){
	var $form = jQuery("#" + forInsert.config.formId);
	var onOffCd = $form.find(":input[name='onOffCd']").filter(":checked").val();
	if(onOffCd == CD_ONOFF_TYPE_OFF) {
		jQuery("#randomCd").hide();
		jQuery("#paparCount").hide();
	} else {
		jQuery("#randomCd").show();
		jQuery("#paparCount").show();
	}
};
/**
 * 점수타입에 따른 변동
 */
doChangeExamScore = function() {
	var $form = jQuery("#" + forInsert.config.formId);
	var examScoreType = $form.find(":input[name='scoreTypeCd']").val();
	var $totalExamScore = $form.find("#totalExamScore");
	if (examScoreType == CD_SCORE_TYPE_002) {
		$totalExamScore.hide();
	} else {
		$totalExamScore.show();
	}
}
/**
 * 퀴즈 선택시 오프라인 선택 불가
 */
 doDisableOffLine = function() {
	var $form = jQuery("#" + forInsert.config.formId);

	var examPaperTypeCd = $form.find(":input[name='examPaperTypeCd']").val();
	var onOffType = $form.find(".onOffType");
	var onOffCd = $form.find(":input[name='onOffCd']");
	var categoryTypeCd = $form.find(":input[name='categoryTypeCd']").val();
	onOffCd.val(CD_ONOFF_TYPE_ON);
	
	if(examPaperTypeCd == CD_EXAM_PAPER_TYPE_QUIZ){
		onOffType.hide();
	} else {
		if (categoryTypeCd == CD_CATEGORY_TYPE_DEGREE){
			onOffType.show();
		} else {
			onOffType.hide();
		}
	}
};
</script>
</head>

<body>
	
	<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->
	<aof:session key="memberSeq" var="memberSeq"/><!-- 교강사일 경우사용-->
	<aof:session key="memberName" var="profMemberName"/><!-- 교강사일 경우사용-->

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCourseExamPaper.jsp"/>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:시험:시험지구분"/></th>
			<td>
				<select name="examPaperTypeCd" onchange="doDisableOffLine()">
					<aof:code type="option" codeGroup="EXAM_PAPER_TYPE" defaultSelected="${CD_EXAM_PAPER_TYPE_EXAM}"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:교과목선택"/><span class="star">*</span></th>
			<td>

				<span id="selectCourseMaster">
					<input type="hidden" name="courseMasterSeq"/>
					<input type="hidden" name="categoryTypeCd"/>
					<input type="text"   name="courseMasterTitle" style="width:365px;" readonly="readonly"/>
					<a href="javascript:void(0)" onclick="doBrowseCourseMaster()" class="btn gray"><span class="small"><spring:message code="버튼:시험:교과목선택"/></span></a>
				</span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:교수선택"/><span class="star">*</span></th>
			<td>
				<span id="selectProfessor">
					<c:if test="${currentRoleCfString ne 'PROF'}"><!-- 관리자, 선임, 강사 -->
					<input type="hidden" name="profMemberSeq"/>
					<input type="text"   name="profMemberName" style="width:365px;" readonly="readonly"/>
					<a href="#" onclick="doBrowseProfessor()" class="btn gray"><span class="small"><spring:message code="버튼:시험:교수선택"/></span></a>
					</c:if>
					<c:if test="${currentRoleCfString eq 'PROF'}">
						<input type="hidden" name="profMemberSeq" value="${memberSeq}"/>
						<input type="text" name="profMemberName" value="${profMemberName}" style="width:150px;" readonly="readonly">
					</c:if>
				</span>
				<input type="checkbox" name="openYn" value="Y"/><spring:message code="필드:시험:전체공개"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:시험지제목" /><span class="star">*</span></th>
			<td><input type="text" name="examPaperTitle" style="width:90%;"></td>
		</tr>
		<tr class="onOffType">
			<th><spring:message code="필드:시험:시험지형태"/></th>
			<td>
                <%/** TODO : 코드*/ %>
                <aof:code type="radio" codeGroup="ONOFF_TYPE" name="onOffCd" defaultSelected="${CD_ONOFF_TYPE_ON}" onclick="doChangeOnOff();"/>
            </td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:시험지설명"/></th>
			<td><textarea name="description" style="width:90%;height:30px;"></textarea></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:점수"/><span class="star">*</span></th>
			<td>
				<select name="scoreTypeCd" onchange="doChangeExamScore();">
					<aof:code type="option" codeGroup="SCORE_TYPE" defaultSelected="${CD_SCORE_TYPE_003}"/>
				</select>
				<span id="totalExamScore">
					<input type="text" name="examPaperScore" style="text-align:center; width:50px;"><spring:message code="글:시험:점"/>
				</span>
			</td>
		</tr>
		<tr id="randomCd">
			<th><spring:message code="필드:시험:문제랜덤여부"/></th>
			<td><aof:code type="radio" name="randomYn" codeGroup="YESNO" defaultSelected="N" onclick="doChangeRandom()" labelStyleClass="radioLabel" removeCodePrefix="true"/></td>
		</tr>
		<tr id="groupKeys" style="display:none;">
			<th><spring:message code="필드:시험:출제그룹"/></th>
			<td id="listGroupkey"><spring:message code="글:시험:교과목이선택되지않았습니다"/></td>
		</tr>
		<tr id="paparCount" style="display:none;">
			<th><spring:message code="필드:시험:문제지수"/></th>
			<td>
				<select name="paperCount" style="width:50px;" onchange="doChangePaperCount()">
					<aof:code type="option" codeGroup="1=1,2=2,3=3,4=4,5=5" defaultSelected="1"/>
				</select>
				<span id="shuffle">
					<strong><spring:message code="필드:시험:문제순서섞기"/></strong>
					<aof:code type="radio" name="shuffleYn" codeGroup="YESNO" defaultSelected="N" labelStyleClass="radioLabel" removeCodePrefix="true"/>
				</span>
			</td>
		</tr>
	</tbody>
	</table>
	</form>
	
	<form id="FormGroupkey" name="FormGroupkey" method="post" onsubmit="return false;">
		<input type="hidden" name="courseMasterSeq">
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
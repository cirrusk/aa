<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_APPLY_STATUS_002"    value="${aoffn:code('CD.APPLY_STATUS.002')}"/>
<c:set var="CD_APPLY_STATUS_003"    value="${aoffn:code('CD.APPLY_STATUS.003')}"/>
<c:set var="CD_APPLY_KIND_TYPE_001" value="${aoffn:code('CD.APPLY_KIND_TYPE.001')}"/>
<c:set var="CD_APPLY_KIND_TYPE_002" value="${aoffn:code('CD.APPLY_KIND_TYPE.002')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forUpdatelist = null;
var forDeletelist = null;
var forMemberPopup = null;
var forAgreePopup = null;
var forUpdateDivision = null;
var forUpdateInitDivision = null;
var forUpdateRandomDivision = null;
var forDownloadExcel = null;
var forUploadPopup = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
 // [2] sorting 설정
    FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
	forSearch = $.action();
    forSearch.config.formId = "FormSrch";
    forSearch.config.url    = "<c:url value="/univ/course/apply/list.do"/>";

    forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/course/apply/list.do"/>";

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/course/apply/detail.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdate.config.url             = "<c:url value="/univ/course/apply/status/update.do"/>";
    forUpdate.config.target          = "hiddenframe";
    forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdate.config.fn.complete     = doList;
	
	forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelist.config.url             = "<c:url value="/univ/course/apply/status/updatelist.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelist.config.fn.complete     = doList;
    
    forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forDeletelist.config.url             = "<c:url value="/univ/course/apply/deletelist.do"/>";
    forDeletelist.config.target          = "hiddenframe";
    forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
    forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forDeletelist.config.fn.complete     = doList;
    forDeletelist.validator.set({
        title : "<spring:message code="필드:삭제할데이터"/>",
        name : "checkkeys",
        data : ["!null"]
    });
    
    forMemberPopup = $.action("layer");
    forMemberPopup.config.formId         = "FormMemberPopup";
    forMemberPopup.config.url            = "<c:url value="/univ/course/apply/member/popup.do"/>";
    forMemberPopup.config.options.width  = 700;
    forMemberPopup.config.options.height = 660;
    
    forAgreePopup = $.action("layer");
    forAgreePopup.config.formId         = "FormAgree";
    forAgreePopup.config.url            = "<c:url value="/member/Agreement/popup.do"/>";
    forAgreePopup.config.options.width  = 900;
    forAgreePopup.config.options.height = 600;
    
    forUpdateRandomDivision = $.action("submit", {formId : "FormRandomDivision"});
    forUpdateRandomDivision.config.target          = "hiddenframe";
    forUpdateRandomDivision.config.url             = "<c:url value="/univ/course/apply/random/division/update.do"/>";
    forUpdateRandomDivision.config.message.confirm = "<spring:message code="글:수강신청:분반을나누시겠습니까?"/>";
    forUpdateRandomDivision.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateRandomDivision.config.fn.complete     = function(data) {
        if(data == 0){
            $.alert({
                message : "<spring:message code="글:수강신청:교강사를등록후분반을나눌수있습니다."/>"
            });
        } else {
            $.alert({
                message : "<spring:message code="글:수강신청:분반이저장되었습니다."/>",
                button1 : {
                    callback : function() {
                        doList();
                    }
                }
            });
        }
    };
    
    forUpdateDivision = $.action("submit", {formId : "FormUpdateDivision"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdateDivision.config.url             = "<c:url value="/univ/course/apply/division/update.do"/>";
    forUpdateDivision.config.target          = "hiddenframe";
    forUpdateDivision.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdateDivision.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateDivision.config.fn.complete     = doList;
    
    forUpdateInitDivision = $.action("submit", {formId : "FormUpdateInitDivision"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdateInitDivision.config.url             = "<c:url value="/univ/course/apply/init/division/update.do"/>";
    forUpdateInitDivision.config.target          = "hiddenframe";
    forUpdateInitDivision.config.message.confirm = "<spring:message code="글:수강신청:분반을초기화하시겠습니까?"/>";
    forUpdateInitDivision.config.message.success = "<spring:message code="글:수강신청:초기화되었습니다"/>";
    forUpdateInitDivision.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateInitDivision.config.fn.complete     = doList;
    
    forDownloadExcel = $.action("submit", {formId : "FormDownloadExcel"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forDownloadExcel.config.url             = "<c:url value="/univ/course/apply/excel.do"/>";
    
    forUploadPopup = $.action("layer");
    forUploadPopup.config.formId         = "FormUploadExcel";
    forUploadPopup.config.url            = "<c:url value="/univ/course/apply/member/upload/popup.do"/>";
    forUploadPopup.config.options.title         = "<spring:message code="필드:수강신청:수강신청일괄등록"/>";
    forUploadPopup.config.options.width  = 400;
    forUploadPopup.config.options.height = 140;
};

/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function(rows) {
    var form = UT.getById(forSearch.config.formId);
    
    // 목록갯수 셀렉트박스의 값을 변경 했을 때
    if (rows != null && form.elements["perPage"] != null) {  
        form.elements["perPage"].value = rows;
    }
    forSearch.run();
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forDetail.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 상세화면 실행
	forDetail.run();
};

/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
    var form = UT.getById(forListdata.config.formId);
    if(form.elements["currentPage"] != null && pageno != null) {
        form.elements["currentPage"].value = pageno;
    }
    doList();
};
/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
    forListdata.run();
};

/**
 *  수강상태 승인
 */
doUpdatelistApprove = function(mapPKs) {
	
    forUpdatelist.config.message.confirm = "<spring:message code="글:수강신청:승인을하시겠습니까?"/>";
    // form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forUpdatelist.config.formId);
    // 실행
    forUpdatelist.run();
};

/**
 * 수강상태 승인취소
 */
doUpdatelistApplyCancel = function(mapPKs) {
    
    forUpdatelist.config.message.confirm = "<spring:message code="글:수강신청:수강취소를하시겠습니까?"/>";
    // form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forUpdatelist.config.formId);
    // 실행
    forUpdatelist.run();
};

/**
 * 개별 승인 상태 수정
 */
doUpdateApplyStatus = function(obj,mapPKs){
	mapPKs.applyStatusCd = $(obj).val();
	
    // form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forUpdate.config.formId);
    // 실행
    forUpdate.run();
};

/**
 * 수강생 삭제
 */
doDeletelistApply = function(){
	forDeletelist.run();
}

/**
 * 청강생 등록
 */
doAddSpecialStudent = function(mapPKs){
	forMemberPopup.config.options.title  = "<spring:message code="필드:수강신청:청강생등록"/>";
	// form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forMemberPopup.config.formId);
    // 실행
    forMemberPopup.run();
};

/**
 * 수강 등록
 */
doAddStudent = function(mapPKs){
	forMemberPopup.config.options.title  = "<spring:message code="필드:수강신청:수강등록"/>";
    // form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forMemberPopup.config.formId);
    // 실행
    forMemberPopup.run();
};

/**
 * 약관정보관리 팝업
 */
 doCallAgreement = function(courseActiveSeqs, memberSeq){
	 var form = UT.getById(forAgreePopup.config.formId);
	 form.elements["memberSeq"].value = memberSeq;
	 form.elements["srchCourseActiveSeq"].value = courseActiveSeqs;
	 
	 forAgreePopup.run();
	 //FN.doDetailMemberPopup({url:"<c:url value="/member/Agreement/popup.do"/>", title: "<spring:message code="필드:수강신청:약관동의"/>", srchCourseActiveSeq:courseActiveSeqs, memberSeq:memberSeq});
};
/*
 * 개인정보관리 팝업
 */
doDetailPopup = function(memberSeq){
	FN.doDetailMemberPopup({url:"<c:url value="/member/detail/popup.do"/>", title: "<spring:message code="필드:맴버:개인정보관리"/>", memberSeq:memberSeq});
};

/**
 * 분반나누기
 */
doRandomDivision = function(){
    forUpdateRandomDivision.run();
};

/**
 * 분반 수정
 */
doUpdateDivision = function(obj,mapPKs){
    mapPKs.division = $(obj).val();
    
    // form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forUpdateDivision.config.formId);
    // 실행
    forUpdateDivision.run();
};

/**
 * 분반 초기화
 */
doInitDivision = function(){
    forUpdateInitDivision.run();
};

/**
 * 엑셀다운로드
 */
doDownLoadExcel = function(){
	forDownloadExcel.run();
};

/**
 * 엑셀 업로드
 */
doUploadExcel = function(){
	forUploadPopup.run();
};

</script>
</head>

<body>
    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
        <c:param name="suffix"><spring:message code="글:목록" /></c:param>
    </c:import>
    
    <div class="lybox-title"><!-- lybox-title -->
        <div class="right">
            <!-- 년도학기 / 개설과목 Shortcut Area Start -->
            <c:import url="../include/commonCourseActive.jsp"></c:import>
            <!-- 년도학기 / 개설과목 Shortcut Area End -->
        </div>
    </div>
    
    <c:import url="srchCourseApply.jsp"/>
    
    <c:import url="/WEB-INF/view/include/perpage.jsp">
        <c:param name="onchange" value="doSearch"/>
        <c:param name="selected" value="${condition.perPage}"/>
    </c:import>
    
    <form id="FormAgree" name="FormAgree" method="post" onsubmit="return false;">
    	<input type="hidden" name="memberSeq" value="">
    	<input type="hidden" name="srchCourseActiveSeq" value="">
    </form>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <input type="hidden" name="applyStatusCd">
    <input type="hidden" name="courseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    <table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 30px" />
        <col style="width: 40px" />
        <col style="width: 60px" />
        <col style="width: 80px" />
        <col style="width: 180px" />
        <col style="width: 70px" />
        <col style="width: 70px" />
    </colgroup>
    <thead>
        <tr>
            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton-l','checkButton-r');" /></th>
            <th><spring:message code="필드:번호" /></th>
            <th><span class="sort" sortid="1"><spring:message code="필드:수강신청:이름" /></span></th>
            <th><span class="sort" sortid="2"><spring:message code="필드:수강신청:닉네임" /></span></th>
            <th>
                <spring:message code="필드:수강신청:ABO" />
            </th>
            <th>
            	<spring:message code="필드:수강신청:약관동의" />
            </th>
            <th>
                <spring:message code="필드:수강신청:상태" />
            </th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
            <tr>
                <td>
                    <input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton-l','checkButton-r')">
                </td>
                <td><c:out value="${paginate.descIndex - i.index}"/></td>
                <td>
                    <%-- <a href="javascript:void(0);" onclick="doDetailPopup('<c:out value="${row.apply.memberSeq}" />')"></a> --%>
                    <c:out value="${row.member.memberName}"/>
                    <input type="hidden" name="courseMasterSeqs" value="<c:out value="${row.apply.courseMasterSeq}"/>">
                    <input type="hidden" name="courseActiveSeqs" value="<c:out value="${row.apply.courseActiveSeq}"/>">
                    <input type="hidden" name="courseApplySeqs" value="<c:out value="${row.apply.courseApplySeq}"/>">
                    <input type="hidden" name="yearTerms" value="<c:out value="${row.apply.yearTerm}"/>">
                    <input type="hidden" name="memberSeqs" value="<c:out value="${row.apply.memberSeq}" />">
                    <input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
                    <input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
                </td>
                <td>
                    <c:out value="${row.member.nickname}"/> 
                </td>
                <td>
                    <%-- <aof:code type="print" codeGroup="SEX" defaultSelected="${row.member.sexCd}"/> --%>
                    <c:out value="${row.member.memberId}"/> 
                </td>
                <td>
	                <a href="javascript:void(0)" onclick="doCallAgreement('<c:out value="${row.apply.courseActiveSeq}"/>', '<c:out value="${row.apply.memberSeq}"/>')" class="btn blue">
	                    <span class="mid"><spring:message code="버튼:수강신청:현황보기" /></span>
	                </a>                
                </td>
<%--                 <td>
                    <c:choose>
                        <c:when test="${empty row.device.deviceId}">
                            <c:set var="pushYn" value="N"/>
                            <input type="hidden" name="pushYns" value="N">
                        </c:when>
                        <c:otherwise>
                            <c:set var="pushYn" value="Y"/>
                            <input type="hidden" name="pushYns" value="Y">
                        </c:otherwise>
                    </c:choose>
                    <aof:code type="print" codeGroup="YESNO" selected="${pushYn}" removeCodePrefix="true"/>                
                </td> --%>
                 <td>
                  <aof:code type="print" codeGroup="APPLY_STATUS" selected="${row.apply.applyStatusCd}"/>    
                    <%-- <select name="applyStatusCds" onchange="doUpdateApplyStatus(this,{courseApplySeq : '<c:out value="${row.apply.courseApplySeq}"/>'})">
                        <aof:code type="option" codeGroup="APPLY_STATUS" selected="${row.apply.applyStatusCd}"/>    
                    </select> --%>
                </td>                
            </tr>
        </c:forEach>
        <c:if test="${empty paginate.itemList}">
            <tr>
                <td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:if>
    </tbody>
    </table>
    </form>
    
    <c:import url="/WEB-INF/view/include/paging.jsp">
        <c:param name="paginate" value="paginate"/>
    </c:import>
    
    <div class="lybox-btn">
        <div class="lybox-btn-l" id="checkButton-l" style="display:none;">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') && not empty paginate.itemList}">
                <!-- // 프로젝트에서 개별 구현 
                <a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:수강신청:정보갱신" /></span></a>
                 -->
            </c:if>
            
            <%/** 학기가 시작하면 삭제가 불가능하다.*/ %>
            <c:set var="appToday"><aof:date datetime="${aoffn:today()}" pattern="${aoffn:config('format.dbdatetimeStart')}"/></c:set>
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C') && not empty paginate.itemList  && yearTermDeatil.univYearTerm.studyStartDate > appToday}">
                <a href="javascript:void(0)" onclick="doDeletelistApply()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
            </c:if>
        </div>
        <div class="lybox-btn-r" >
            <span id="checkButton-r"  style="display:none;">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C') && not empty paginate.itemList}">
                <a href="javascript:void(0)" onclick="doUpdatelistApprove({applyStatusCd :'<c:out value="${CD_APPLY_STATUS_002}"/>'})" class="btn blue">
                    <span class="mid"><spring:message code="버튼:수강신청:승인" /></span>
                </a>
                <a href="javascript:void(0)" onclick="doUpdatelistApplyCancel({applyStatusCd :'<c:out value="${CD_APPLY_STATUS_003}"/>'})" class="btn blue">
                    <span class="mid"><spring:message code="버튼:수강신청:수강취소" /></span>
                </a>
                <%--
                <a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData')" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
                <a href="javascript:void(0)" onclick="FN.doCreateSms('FormData')" class="btn blue"><span class="mid"><spring:message code="버튼:SMS"/></span></a>
                 <a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData')" class="btn blue"><span class="mid"><spring:message code="버튼:이메일"/></span></a>
                 --%>
                <a href="javascript:void(0)" onclick="FN.doCreatePush('FormData')" class="btn blue"><span class="mid"><spring:message code="버튼:push:PUSH"/></span></a>
                
            </c:if>
            </span>
             <%--
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
               <a href="javascript:void(0)" onclick="doRandomDivision()" class="btn blue">
                    <span class="mid"><spring:message code="버튼:수강신청:자동분반나누기" /></span>
                </a>
                
                <c:if test="${not empty paginate.itemList[0].active.divisionCount}">
                    <a href="javascript:void(0)" onclick="doInitDivision()" class="btn blue">
                        <span class="mid"><spring:message code="버튼:수강신청:분반초기화" /></span>
                    </a>
                </c:if>
                 
            </c:if>
            --%>
<%--             <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
            	
                <a href="javascript:void(0)" onclick="doAddSpecialStudent({srchApplyKindCd : '<c:out value="${CD_APPLY_KIND_TYPE_002}"/>'})" class="btn blue">
                    <span class="mid"><spring:message code="버튼:수강신청:청강생등록" /></span>
                </a>
                
                <a href="javascript:void(0)" onclick="doAddStudent({srchApplyKindCd : '<c:out value="${CD_APPLY_KIND_TYPE_001}"/>'})" class="btn blue">
                    <span class="mid"><spring:message code="버튼:수강신청:수강등록" /></span>
                </a>
            </c:if>
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'E')}">
            	<a href="javascript:void(0)" onclick="doUploadExcel()" class="btn blue">
                    <span class="mid"><spring:message code="버튼:수강신청:수강신청일괄등록" /></span>
                </a>
                <a href="javascript:void(0)" onclick="doDownLoadExcel()" class="btn blue">
                    <span class="mid"><spring:message code="버튼:수강신청:엑셀다운로드" /></span>
                </a>
            </c:if> --%>
        </div>
    </div>
</body>
</html>
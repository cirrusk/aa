<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<%-- 공통코드 --%>
<c:set var="CD_ACTIVE_LECTURER_TYPE_PROF" value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.PROF')}"/>
<c:set var="CD_ACTIVE_LECTURER_TYPE_ASSIST" value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.ASSIST')}"/>
<c:set var="CD_ACTIVE_LECTURER_TYPE_TUTOR" value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.TUTOR')}"/>


<html>
<head>
<title></title>
<script type="text/javascript">
    <%-- 공통코드 --%>
    var CD_ACTIVE_LECTURER_TYPE_PROF = "<c:out value="${CD_ACTIVE_LECTURER_TYPE_PROF}"/>";
    
	var forListdata = null;
	var forCreate = null;
	var forDetail = null;
	var forInsertlist = null;
	var forDeletelist = null;
	initPage = function() {
		// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
		doInitializeLocal();

		// [2] sorting 설정
		FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>","FormSrch", doSearch);
	};

	doInitializeLocal = function() {

		forSearch = $.action();
		forSearch.config.formId = "FormSrch";
		forSearch.config.url = "<c:url value="/univ/course/active/lecturer/list/iframe.do"/>";

		forDetail = $.action();
		forDetail.config.formId = "FormDetail";
		forDetail.config.url = "<c:url value="/univ/course/active/lecturer/detail/iframe.do"/>";

		forCreate = $.action("layer");
		forCreate.config.formId = "FormBrowseMember";
		forCreate.config.url = "<c:url value="/member/prof/list/popup.do"/>";
		forCreate.config.options.width = 700;
		forCreate.config.options.height = 500;
		forCreate.config.options.title = "<spring:message code="버튼:교강사권한관리:교강사추가"/>";

		forInsertlist = $.action("submit", {formId : "FormInsert"});
		forInsertlist.config.url = "<c:url value="/univ/course/active/lecturer/insertlist.do"/>";
		forInsertlist.config.target = "hiddenframe";
		forInsertlist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
		forInsertlist.config.fn.complete = doCompleteInsertlist;

		forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
		forDeletelist.config.url = "<c:url value="/univ/course/active/lecturer/deletelist.do"/>";
		forDeletelist.config.target = "hiddenframe";
		<c:if test="${condition.srchActiveLecturerTypeCd ne CD_ACTIVE_LECTURER_TYPE_PROF}">
		forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>";
		</c:if>
		<c:if test="${condition.srchActiveLecturerTypeCd eq CD_ACTIVE_LECTURER_TYPE_PROF}">
		forDeletelist.config.message.confirm = "<spring:message code="글:교강사권한관리:강사가지정한선임도같이삭제됩니다"/>";
		</c:if>
		forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
		forDeletelist.config.fn.complete = doCompleteDeletelist;
		forDeletelist.validator.set({
			title : "<spring:message code="필드:삭제할데이터"/>",
			name : "checkkeys",
			data : [ "!null" ]
		});
	}

	/**
	 * 등록화면을 호출하는 함수
	 */
	doCreate = function(mapPKs) {
		// 등록화면 form에 키값을 셋팅한다.
		UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
		// 등록화면 실행
		forCreate.run();
	};

	/**
	 * 교강사추가
	 */
	doInsert = function(returnValue) {
		if (returnValue != null && returnValue.length) {
			var $form = jQuery("#" + forInsertlist.config.formId);
			
			for ( var i in returnValue) {
				var inputTags = "<input type='hidden' name='memberSeqs' value='" + returnValue[i].memberSeq + "'>";
				if( $.isNumeric(returnValue[i].profMemberSeq)){
					inputTags += "<input type='hidden' name='profMemberSeqs' value='" + returnValue[i].profMemberSeq + "'>";
				}
				$(inputTags).appendTo($form);
			}
			forInsertlist.run();
		}
	};

	/**
	 * 교강사추가 완료
	 */
	doCompleteInsertlist = function(success) {
		$.alert({
			message : "<spring:message code="글:X건의데이터가추가되었습니다"/>".format({
				0 : success
			}),
			button1 : {
				callback : function() {
					doList();
				}
			}
		});
	};
	/**
	 * 목록삭제 완료
	 */
	doCompleteDeletelist = function(success) {
		$.alert({
			message : "<spring:message code="글:X건의데이터가삭제되었습니다"/>".format({
				0 : success
			}),
			button1 : {
				callback : function() {
					doList();
				}
			}
		});
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
	 * 목록보기 가져오기 실행.
	 */
	doList = function() {
		forSearch.run();
	};

	/**
	 * 정렬및 출력개수 수정시 사용
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
	 * 목록페이지 이동. page navigator에서 호출되는 함수
	 */
	doPage = function(pageno) {
		var form = UT.getById(forSearch.config.formId);
		if (form.elements["currentPage"] != null && pageno != null) {
			form.elements["currentPage"].value = pageno;
		}
		doList();
	};

	/**
	 * 목록에서 삭제할 때 호출되는 함수
	 */
	doDeletelist = function() {
		forDeletelist.run();
	};
</script>
</head>

<body>
    <aof:session key="currentRoleCfString" var="currentRoleCfString" />
    <!-- 권한 가져오기 -->

    <div style="display: none;">
        <c:import url="srchCourseActiveLeturer.jsp" />
    </div>

    <c:import url="/WEB-INF/view/include/perpage.jsp">
        <c:param name="onchange" value="doSearch" />
        <c:param name="selected" value="${condition.perPage}" />
    </c:import>

    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
        <input type="hidden" name="activeLecturerTypeCd" value="${condition.srchActiveLecturerTypeCd}" /> 
        <input type="hidden" name="courseActiveSeq" value="${condition.srchCourseActiveSeq}" />
    	<div class="lybox-btn-l">
    	 	※ 운영자를 모두 삭제해야 새로운 운영자를 추가할 수 있습니다.
        </div>
        <table id="listTable" class="tbl-list">
            <colgroup>
                <col style="width: 40px" />
                <col style="width: 80px" />
                <col style="width: 120px" />
                <col style="width: 120px" />
                <c:if test="${condition.srchActiveLecturerTypeCd ne CD_ACTIVE_LECTURER_TYPE_PROF}">
                    <col style="width: 120px" />
                </c:if>
                <col style="width: 120px" />
            </colgroup>
            <thead>
                <tr>
                    <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
                    <th><spring:message code="필드:번호" /></th>
                    <th><span class="sort" sortid="1"><spring:message code="필드:멤버:이름" /></span></th>
                    <th><span class="sort" sortid="2"><spring:message code="필드:멤버:아이디" /></span></th>
                    <c:if test="${condition.srchActiveLecturerTypeCd ne CD_ACTIVE_LECTURER_TYPE_PROF}">
                        <th><span class="sort" sortid="4"><spring:message code="필드:교강사권한관리:권한배정자" /></span></th>
                    </c:if>
                    <th><spring:message code="필드:등록일" /></th>
                    <%-- <th><spring:message code="필드:교강사권한관리:접근권한" /></th> --%>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
                    <tr>
                        <td>
                            <input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
                            <input type="hidden" name="courseActiveProfSeqs" value="<c:out value="${row.univCourseActiveLecturer.courseActiveProfSeq}" />">
                            <input type="hidden" name="memberSeqs" value="<c:out value="${row.univCourseActiveLecturer.memberSeq}" />">
                        </td>
                        <td>
                            <c:out value="${paginate.descIndex - i.index}" /></td>
                        <td><c:out value="${row.member.memberName}" /></td>
                        <td><c:out value="${row.member.memberId}" /></td>
                        <c:if test="${condition.srchActiveLecturerTypeCd ne CD_ACTIVE_LECTURER_TYPE_PROF}">
                            <td><c:out value="${row.univCourseActiveLecturer.profMemberName}" /></td>
                        </c:if>
                        <td><aof:date datetime="${row.univCourseActiveLecturer.regDtime}" /></td>
<%--                         <td>
                            <c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
                                <a href="javascript:void(0)"
                                    onclick="doDetail({'courseActiveProfSeq' : '${row.univCourseActiveLecturer.courseActiveProfSeq}'});"
                                    class="btn gray">
                                    <span class="small"><spring:message code="버튼:교강사권한관리:설정" /></span>
                                </a>
                            </c:if>
                        </td> --%>
                    </tr>
                </c:forEach>
                <c:if test="${empty paginate.itemList}">
                    <tr>
                        <c:set var="colspan" value="0"/>
                        <c:choose>
                            <c:when test="${condition.srchActiveLecturerTypeCd eq CD_ACTIVE_LECTURER_TYPE_PROF}">
                                <c:set var="colspan" value="5"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="colspan" value="5"/>
                            </c:otherwise>
                        </c:choose>
                        <td colspan="${colspan}" align="center"><spring:message code="글:데이터가없습니다" /></td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </form>

    <c:import url="/WEB-INF/view/include/paging.jsp">
        <c:param name="paginate" value="paginate" />
    </c:import>
            
    <c:if test="${currentRoleCfString eq 'PROF'}">
        <!-- 교강사일때 선임 강사 추가 가능 -->
        <div class="lybox-btn">
            <div class="lybox-btn-l" id="checkButton" style="display: none;">
                <c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
                    <a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue">
                        <span class="mid"><spring:message code="버튼:삭제" /></span>
                    </a>
                </c:if>
            </div>
            <div class="lybox-btn-r">
                <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                    <a href="javascript:void(0)" onclick="doCreate({'srchNotInCourseActiveSeq': '${condition.srchCourseActiveSeq}'})" class="btn blue">
                        <span class="mid"><spring:message code="버튼:추가" /></span>
                     </a>
                </c:if>
            </div>
        </div>
    </c:if>
    <c:if test="${currentRoleCfString eq 'ADM'}">
        <!-- 관리자일때는 교강사만 추가 가능 -->
        <div class="lybox-btn">
            <div class="lybox-btn-l" id="checkButton" style="display: none;">
                <c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
                    <a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue">
                        <span class="mid"><spring:message code="버튼:삭제" /></span></a>
                </c:if>
            </div>

            <div class="lybox-btn-r">
                <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                    <c:choose>
                        <c:when test="${condition.srchActiveLecturerTypeCd eq CD_ACTIVE_LECTURER_TYPE_PROF}">
                            <c:if test="${empty paginate.itemList}">
                            <a href="javascript:void(0)" onclick="doCreate({'srchNotInCourseActiveSeq': '${condition.srchCourseActiveSeq}'})" class="btn blue">
		                       <span class="mid">운영자설정</span>
		                    </a>
		                    </c:if>
                        </c:when>
                        <c:otherwise>
                            <%-- // 교강사가 등록되어있지 않을 경우 선임과 강사를 등록할수 없다. --%>
                            <c:choose>
                                <c:when test="${profCount > 0}">
                                    <a href="javascript:void(0)" onclick="doCreate({'srchNotInCourseActiveSeq': '${condition.srchCourseActiveSeq}','srchActiveLecturerTypeCd' : '${CD_ACTIVE_LECTURER_TYPE_PROF}'})" class="btn blue">
                                       <span class="mid"><spring:message code="버튼:추가" /></span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span id="warning" style="color: red;">
                                                                                                    ※ <spring:message code="글:교강사권한관리:교강사가등록되어있지않을경우튜터혹은강사를추가할수없습니다" />
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </div>
        </div>
    </c:if>
</body>
</html>
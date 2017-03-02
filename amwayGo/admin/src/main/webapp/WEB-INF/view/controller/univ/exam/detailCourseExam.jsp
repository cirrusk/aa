<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_ITEM_ALIGN_H"    value="${aoffn:code('CD.EXAM_ITEM_ALIGN.H')}"/>
<c:set var="CD_EXAM_ITEM_ALIGN_M"    value="${aoffn:code('CD.EXAM_ITEM_ALIGN.M')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_EXAM_ITEM_ALIGN_H = "<c:out value="${CD_EXAM_ITEM_ALIGN_H}"/>";
var CD_EXAM_ITEM_ALIGN_M = "<c:out value="${CD_EXAM_ITEM_ALIGN_M}"/>";

var forListdata = null;
var forEdit = null;
var forEditItem = null;
var forCreate = null;
var forDetail = null;
var forDelete = null;
var forDeleteItem = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	jQuery(".video").media({width:200, height:200, autoplay:false});
	jQuery(".audio").media({autoplay:false});
	
	doAdjust();

	// [2]. 썸네일의 원본 이미지 보기
	UI.originalOfThumbnail();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/exam/list.do"/>";

	forEdit = $.action("layer");
	forEdit.config.formId = "FormLayer";
	forEdit.config.url    = "<c:url value="/univ/exam/edit.do"/>";
	forEdit.config.options.width = 800;
	forEdit.config.options.height = 500;
	forEdit.config.options.title = "<spring:message code="글:시험:문제수정" />";
	forEdit.config.callback = doRefresh;

	forEditItem = $.action("layer");
	forEditItem.config.formId = "FormLayer";
	forEditItem.config.url    = "<c:url value="/univ/exam/item/edit.do"/>";
	forEditItem.config.options.width = 420;
	forEditItem.config.options.height = 480;
	forEditItem.config.options.title = "퀴즈수정";
	forEditItem.config.options.callback = doRefresh;
	
	forCreate = $.action("layer");
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/univ/exam/item/create.do"/>";
	forCreate.config.options.width = 860;
	forCreate.config.options.height = 600;
	forCreate.config.options.title = "퀴즈추가";
	forCreate.config.callback = doRefresh;
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/exam/detail.do"/>";

	forDelete = $.action("submit");
	forDelete.config.formId = "FormDelete";
	forDelete.config.url             = "<c:url value="/univ/exam/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};

	forDeleteItem = $.action("submit");
	forDeleteItem.config.url             = "<c:url value="/univ/exam/item/delete.do"/>";
	forDeleteItem.config.target          = "hiddenframe";
	forDeleteItem.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeleteItem.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDeleteItem.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeleteItem.config.fn.complete     = function() {
		doRefresh();
	};
	
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 시험문제 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};
/**
 * 문제문항 수정화면을 호출하는 함수
 */
doEditItem = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEditItem.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEditItem.config.formId);
	// 수정화면 실행
	forEditItem.run();
};
/**
 * 등록화면을 호출하는 함수
 */
doCreate = function(mapPKs) {
	// 등록화면 form을 reset한다.
	UT.getById(forCreate.config.formId).reset();
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
	// 등록화면 실행
	forCreate.run();
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
 * 시험문제 삭제
 */
doDelete = function() {
	forDelete.run();
};
/**
 * 문제문항 삭제
 */
doDeleteItem = function(index) {
	forDeleteItem.config.formId = "FormDeleteItem-" + index; 
	forDeleteItem.run();
};
/**
 * 새로고침
 */
doRefresh = function() {
	doDetail({'examSeq' : '${detail.courseExam.examSeq}'});
};
/**
 * 보기 정렬 
 */
doAdjust = function() {
	jQuery(".examExample").each(function() {
		var $this = jQuery(this);
		var $examples = $this.find(".example");
		var exampleLength = $examples.length;

		var width = 88;
		if ($this.hasClass(CD_EXAM_ITEM_ALIGN_H)) {
			width = width / exampleLength; 
		} else if ($this.hasClass(CD_EXAM_ITEM_ALIGN_M)) {
			width = width / 2;
		}
		$examples.css("width", width + "%");
		var childWidth = 0;
		$examples.find(".video, .audio").each(function() {
			var w = jQuery(this).width();
			childWidth = w > childWidth ? w : childWidth;
		});
		if (childWidth > $examples.width()) {
			$examples.css("width", childWidth + "px");
		}
		
		if ($this.hasClass(CD_EXAM_ITEM_ALIGN_H) || $this.hasClass(CD_EXAM_ITEM_ALIGN_M)) {
			var height = 0;
			$examples.each(function() {
				var h = parseInt(jQuery(this).css("height"), 10);
				height = h > height ? h : height;
			});
			$examples.css("height", height + "px");
		}
	});
};
</script>
<c:import url="./include/courseExamStyle.jsp"/>
<c:import url="/WEB-INF/view/include/mediaPlayer.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCourseExam.jsp"/>
	</div>
	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<span><c:out value="${detail.courseExam.updMemberName}"/></span>
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.courseExam.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>
	
	<c:set var="questionCount" value="1" scope="request"/>
	<c:set var="itemSize"   value="${aoffn:size(detail.listCourseExamItem)}" scope="request"/>
	<c:set var="courseExam" value="${detail.courseExam}" scope="request"/>
	
	<c:if test="${itemSize gt 1}">
		<div>
			<div class="label align-l" style="padding-left:5px;">
				<c:import url="./include/courseExam.jsp"/>
			</div>
			<div class="align-l" style="padding-left:5px;position:relative;">
				<c:import url="./include/courseExam2.jsp"/>

				<ul style="position:absolute;right:0px; top:5px;">	
					<li>
						<c:if test="${detail.courseExam.useCount gt 0}">
							<span class="comment"><spring:message code="글:시험:활용중인데이터는수정및삭제를할수없습니다"/></span>
						</c:if>
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and detail.courseExam.useCount eq 0}">
							<a href="javascript:void(0)" onclick="doEdit({'examSeq' : '<c:out value="${detail.courseExam.examSeq}"/>'});"
								class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
						</c:if>
					</li>
				</ul>
			</div>
		</div>
		<div class="clear"><br></div>
	</c:if>

	<div style="<c:if test="${itemSize gt 1}">padding-left:15px;</c:if>">
	
	 	<c:forEach var="row" items="${detail.listCourseExamItem}" varStatus="i">
			<c:set var="courseExamItem"        value="${row.courseExamItem}"        scope="request"/>
			<c:set var="listCourseExamExample" value="${row.listCourseExamExample}" scope="request"/>

			<div>
				<div class="label align-l" style="padding-left:5px;position:relative;">
					<c:import url="./include/courseExamItem.jsp"/>
				</div>
				<div class="align-l" style="padding-left:5px;position:relative;">
					<c:import url="./include/courseExamItem2.jsp"/>
					
					<ul style="position:absolute;right:0px; top:5px;">	
						<li>
							<c:if test="${detail.courseExam.useCount gt 0}">
								<span class="comment"><spring:message code="글:시험:활용중인데이터는수정및삭제를할수없습니다"/></span>
							</c:if>
							<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and detail.courseExam.useCount eq 0}">
								<a href="javascript:void(0)" 
									onclick="doEditItem({
										'examItemSeq' : '<c:out value="${courseExamItem.examItemSeq}"/>',
										'examSeq' : '<c:out value="${courseExamItem.examSeq}"/>'
									});"
									class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
							</c:if>
							<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') and detail.courseExam.useCount eq 0}">
								<c:choose>
									<c:when test="${itemSize gt 1}">
										<c:choose>
											<c:when test="${detail.courseExam.useCount gt 0}">
												<a href="javascript:void(0)" title="<spring:message code="글:시험:활용중인데이터는수정및삭제를할수없습니다"/>"
													class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
											</c:when>
											<c:otherwise>
												<a href="javascript:void(0)" onclick="doDeleteItem('<c:out value="${i.index}"/>');"
													class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
												<form name="FormDeleteItem-<c:out value="${i.index}"/>" id="FormDeleteItem-<c:out value="${i.index}"/>" method="post" onsubmit="return false;">
													<input type="hidden" name="examSeq" value="<c:out value="${detail.courseExam.examSeq}"/>"/>
													<input type="hidden" name="examItemSeq" value="<c:out value="${courseExamItem.examItemSeq}"/>"/>
													<c:forEach var="rowSub" items="${listCourseExamExample}" varStatus="iSub">
														<input type="hidden" name="examExampleSeqs" value="<c:out value="${rowSub.courseExamExample.examExampleSeq}"/>"/>
													</c:forEach>
												</form>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${detail.courseExam.useCount gt 0}">
												<a href="javascript:void(0)" title="<spring:message code="글:시험:활용중인데이터는수정및삭제를할수없습니다"/>"
													class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
											</c:when>
											<c:otherwise>
												<a href="javascript:void(0)" onclick="doDelete();"
													class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
												<form name="FormDelete" id="FormDelete" method="post" onsubmit="return false;">
													<input type="hidden" name="examSeq" value="<c:out value="${detail.courseExam.examSeq}"/>"/>
													<input type="hidden" name="examItemSeq" value="<c:out value="${courseExamItem.examItemSeq}"/>"/>
													<c:forEach var="rowSub" items="${listCourseExamExample}" varStatus="iSub">
														<input type="hidden" name="examExampleSeqs" value="<c:out value="${rowSub.courseExamExample.examExampleSeq}"/>"/>
													</c:forEach>
												</form>
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
							
							</c:if>
						</li>
					</ul>
				</div>
				<div class="text">
					<c:import url="./include/courseExamExample.jsp"/>
				</div>
			</div>

			
			<div class="clear"><br></div>
			<c:set var="questionCount" value="${aoffn:toInt(questionCount) + 1}" scope="request"/>
		
		</c:forEach>
		
	</div>

	<div class="lybox-btn">
		<div class="lybox-btn-l">
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
			
				<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
					<input type="hidden" name="examSeq" />
					<input type="hidden" name="examItemSeq" />
					<input type="hidden" name="examItemSortOrder" value="<c:out value="${itemSize + 1}"/>"/>
					<input type="hidden" name="decorator" value="iframe"/>
					<input type="hidden" name="confirm" value="true"/>
				</form>
			
<%-- 				 <a href="javascript:void(0)" onclick="doCreate({ --%>
<%-- 					'examSeq' : '<c:out value="${detail.courseExam.examSeq}"/>' --%>
<%-- 				});" class="btn blue"><span class="mid"><spring:message code="버튼:시험:문항추가"/></span></a>  --%>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
	
</body>
</html>
<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="popupAsk">
<head>
<title></title>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/admin/common_exam.css" type="text/css"/>
<script type="text/javascript">
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	var scroll_hg = $('.wrapper').height() - ($('#header').height() + $('#footer').height());
	$('#container').css('height',scroll_hg+'px');
	
	// [2] 10초마다 게시글 정보를 가져온다.
	var timer = null;
	clearInterval(timer);
	timer = setInterval(function() {
		doAjax();
	}, 3000);
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forCreate = $.action();
	forCreate.config.formId = "FormData";
	forCreate.config.url    = "<c:url value="/univ/course/bbs/${boardType}/create.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormList";
	forDetail.config.url    = "<c:url value="/univ/course/active/session/detail.do"/>";
	
};

/**
 * 등록화면을 호출하는 함수
 */
doCreate = function() {
	UT.getById(forCreate.config.formId).reset();
	//UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
	forCreate.run();
	
};
doAjax = function(){
	//마지막 게시글의 seq값만 controller로 전달
	var bbsSeq = $("#bbsSeqs").val();
	/* var bbsSeq = 218; */
	$("#srchBbsSeq").val(bbsSeq);
	var action = $.action("ajax");
	action.config.type        = "json";
	action.config.formId	  = "FormData";
	action.config.url         = "<c:url value="/univ/course/bbs/celebrate/ajax.do" />";
	action.config.fn.complete = function(action, data) {
		var innerHtml = "";
		for(var index in data.paginate.itemList){
			var name = data.paginate.itemList[index].bbs.regMemberName;
			var title = data.paginate.itemList[index].bbs.bbsTitle;
			var bbsSeq = data.paginate.itemList[index].bbs.bbsSeq;
			var regMemberPhoto = data.paginate.itemList[index].bbs.regMemberPhoto;
			var bgImage = "<aof:img type='print' src='common/post_img_bg.png'/>";
			if(regMemberPhoto == ""){
				regMemberPhoto = "<aof:img type='print' src='common/no_photo_img.png'/>";
			}else{
				regMemberPhoto = "${aoffn:config('upload.context.image')}" + regMemberPhoto +".thumb.jpg";
			}
			
			innerHtml += "<div class=\'congt\'>"
			+ "<div class='titWrap'>"
			+ "<div class='imgWrap'>"
			+ "<img src=\'"+ regMemberPhoto + "\'/><img src=\'"+ bgImage + "\'/>"
		    + "</div><p>" + name + "</p></div>"
		    + "<div class='congt_comment'>" + title +"</div></div>"
		    + "	<input type=\"hidden\" name=\"bbsSeqs\" id=\"bbsSeqs\" value=\"" + bbsSeq + "\" />";
		}	
		$("#FormData").prepend(innerHtml);
	};
	action.run();
};

/**
 * 메뉴목록
 */
doDetail = function() {
	
	forDetail.run();
	
};

</script>
</head>
<body>
<form name="FormList" id="FormList" method="post" onsubmit="return false;">

    <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	<input type="hidden" name="srchClassificationCode"  value="<c:out value="${param['classificationCode']}"/>" />
	<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
</form>
<div class="wrapper">	
	<div id="header">
		<h1 class="logo"><a href="#" onclick="doDetail();"><aof:img src="common/logo_t.png"/></a></h1>
		<h2 class="tit">축하하기</h2>
	</div>
	<div id="container" style="position:relative;">
		<div id="content">
<c:choose>
	<c:when test="${empty detailBoard}"> <%-- 생성되지 않은 게시판 --%>
		<div class="lybox align-c">
			<spring:message code="글:게시판:생성되지않은게시판입니다" />
		</div>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${detailBoard.board.useYn ne 'Y'}"> <%-- 사용하지 않는 게시판 --%>
				<div class="lybox align-c">
					<spring:message code="글:게시판:사용하지않는게시판입니다" />
				</div>
			</c:when>
			<c:otherwise>
				<c:set var="flatModeYn" value="N"/>
				<c:if test="${condition.srchSearchYn eq 'Y'}">
					<c:set var="flatModeYn" value="Y"/>
				</c:if>
				<c:if test="${!empty condition.orderby and condition.orderby ne 0}">
					<c:set var="flatModeYn" value="Y"/>
				</c:if>
			
				<form id="FormData" name="FormData" method="post" onsubmit="return false;">
				<c:choose>
					<c:when test="${!empty paginate.itemList}">
						<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
							<div class="congt">
								<c:set var="regMemberPhoto"><aof:img type="print" src="common/no_photo_img.png"/></c:set>
								<c:if test="${!empty row.bbs.regMemberPhoto}">
									<c:set var="regMemberPhoto" value ="${aoffn:config('upload.context.image')}${row.bbs.regMemberPhoto}.thumb.jpg"/>
								</c:if>
								<div class="titWrap">
									<div class="imgWrap">
										<img src="${regMemberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
										<aof:img src="common/post_img_bg.png"/>
									</div>
									<p><c:out value="${row.bbs.regMemberName}"/></p>
								</div>
								<div class="congt_comment"><c:out value="${row.bbs.bbsTitle}" /></div>
							</div>
							<input type="hidden" name="bbsSeqs" id="bbsSeqs"  value="<c:out value="${row.bbs.bbsSeq}"/>" />
						</c:forEach>
					</c:when>
					<c:otherwise>
						<input type="hidden" name="bbsSeqs" id="bbsSeqs"  value="0" />
					</c:otherwise>
				</c:choose>
				<input type="hidden" name="srchBbsSeq" id="srchBbsSeq"/>	
				<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
				<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
				<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
				<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
			
				<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
				</form>
				<%-- <div class="lybox-btn">
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
							<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
							<a href="#" onclick="doAjax()" class="btn blue"><span class="mid">ajax</span></a>
						</c:if>
					</div>
				</div> --%>
			</c:otherwise>
		</c:choose>
	
	</c:otherwise>
</c:choose>
		</div>
	</div>
</div>	
</body>
</html>
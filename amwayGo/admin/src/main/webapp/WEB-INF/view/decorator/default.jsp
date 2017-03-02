<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<!doctype html>
<!--[if IE 7]><html lang="ko" class="old ie7"><![endif]-->
<!--[if IE 8]><html lang="ko" class="old ie8"><![endif]-->
<!--[if IE 9]><html lang="ko" class="modern ie9"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="ko" class="modern">
<!--<![endif]--><head>
<title><c:out value="${aoffn:config('system.name')}"/></title>
<c:import url="/WEB-INF/view/include/meta.jsp"/>
<c:import url="/WEB-INF/view/include/css.jsp"/>
<c:import url="/WEB-INF/view/include/javascript.jsp"/>
<decorator:head />
<c:set var="startPage" scope="request"><c:url value="${aoffn:config('system.startPage')}"/></c:set>
<script type="text/javascript">
var forFavoriteInsert = null;
var forFavoriteList = null;
var forFavoriteDelete    = null;

jQuery(document).ready(function(){
	jQuery(document).keydown(function(event) {
		UT.preventBackspace(event); // backspace 막기.
		UT.preventF5(event); // F5 막기.
	});
	Global.parameters = jQuery("#FormGlobalParameters").serialize(); // 공통파라미터

	initPage();
	
	forFavoriteList = $.action("ajax");
	forFavoriteList.config.formId = "FormFavoriteList";
	forFavoriteList.config.type = "html";
	forFavoriteList.config.containerId = "containerFavorite";
	forFavoriteList.config.url = "<c:url value="/infra/bookmark/list/ajax.do"/>";
	forFavoriteList.config.fn.complete = function() {
	};
	
	forFavoriteInsert = $.action("submit", {formId : "FormFavoriteInsert"});
	forFavoriteInsert.config.url    = "<c:url value="/infra/bookmark/insert.do"/>";
	forFavoriteInsert.config.target = "favoriteHiddenframe";
	forFavoriteInsert.config.message.confirm = "<spring:message code="글:헤더:즐겨찾기추가"/>";
	forFavoriteInsert.config.fn.complete = function() {
		doFavoriteList();
		doSetFavoriteStar(false);
	};
		
	forFavoriteDelete = $.action("submit");
	forFavoriteDelete.config.formId          = "FormFavoriteDelete";
	forFavoriteDelete.config.url 			 = "<c:url value="/infra/bookmark/delete.do"/>";
	forFavoriteDelete.config.target 		 = "favoriteHiddenframe";
	forFavoriteDelete.config.fn.complete 	 = function() {
		doFavoriteList();
	};
	
	doInitMenu();

	doUnreadMemoAjax();

});

/**
 * 메뉴 초기화
 */
doInitMenu = function() {
	jQuery(".dependent-menu").each(function() {
		var $this = jQuery(this);
		var dependent = $this.attr("dependent"); 
		if (typeof dependent === "string" && dependent.length > 0) {
			if (jQuery("#" + dependent).length > 0) {
				$this.show();
			} else {
				$this.hide();
			}
		}
	});
	jQuery("ul.menu li").hover(
		function() {
			var $this = jQuery(this);
			$this.find(">ul:not(:animated)").slideDown("fast");
		}, 
		function() {
			var $this = jQuery(this);
			$this.find(">ul").hide();
		}
	);
	jQuery(".snb>ul>li").hover(
		function() {
			var $this = jQuery(this);
			$this.find(">ul.manage-menu").show();
		}, 
		function() {
			var $this = jQuery(this);
			$this.find(">ul.manage-menu").hide();
		}
	);
	jQuery(".admin-group").hover(
		function() {
			jQuery(this).find("ul").show();
		},
		function() {
			jQuery(this).find("ul").hide();
		}
	);
	
	var scroller = jQuery.aosButtonScroller("nav");
	var setHeight = function() {
		scroller.height(jQuery(window).height() - jQuery(".header").height() - 80); // 상하 버튼 공간 만큼 빼준다.
	};
	setHeight();
	jQuery(window).resize(function() {
		setHeight();
	});
};


//즐겨찾기 리스트 호출
doFavoriteList = function() {
	forFavoriteList.run();
};

//즐겨찾기 등록
doFavoriteInsert = function(mapPKs) {

	var favoriteLimitCount = 5;
	var bookMarkCount = jQuery("#bookmarkSize").val();
	
	//즐겨찾기 최대갯수 제한 체크
	if(favoriteLimitCount <= bookMarkCount){
		$.alert({
	         message : "<spring:message code="글:헤더:즐겨찾기는최대5개까지만등록가능합니다"/>"
	      });
		return false;
	}else{
		// 상세화면 form을 reset한다.
		UT.getById(forFavoriteInsert.config.formId).reset();
		// 상세화면 form에 키값을 셋팅한다.
		UT.copyValueMapToForm(mapPKs, forFavoriteInsert.config.formId);
		// 상세화면 실행
		forFavoriteInsert.run();	
	}
};

/*
 * 즐겨찾기 삭제
 */
doFavoriteDelete = function(mapPKs) {
	UT.getById(forFavoriteDelete.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forFavoriteDelete.config.formId);
	
	// 현 메뉴의 즐겨찾기토글 상태를 수정한다.
	doSetFavoriteStar(mapPKs.isShow);
	forFavoriteDelete.run();
};

/*
 * 즐겨찾기 토글
 */
doSetFavoriteStar = function(isShow) {
    if (isShow) {
        $(".favicon_on").hide();
        $(".favicon_off").show();
    } else {
        $(".favicon_off").hide();
        $(".favicon_on").show();
    } 
};

/*
 * 미확인 쪽지 개수 조회
 */
doUnreadMemoAjax = function() {
	var action = $.action("ajax");
	action.config.type = "json";
	action.config.formId = "FormFavoriteList";
	action.config.url  = "<c:url value="/message/receive/unread/ajax.do"/>";
	action.config.fn.complete = function(action, data) {
		if (data != null && data.unreadMessage != null) {
			if(data.unreadMessage != 0){
				jQuery("#unreadMessage").html(data.unreadMessage);
			}else{
				jQuery("#unreadMessage").html(0);
			}
		}else{
			jQuery("#unreadMessage").html(0);
		}
		
	};
	action.run();
};
</script>
</head>

<body onload="<decorator:getProperty property="body.onload" />" style="overflow:auto; overflow-y:scroll;">

<c:import url="/WEB-INF/view/include/header.jsp"/>

<!-- 즐겨찾기용 form -->
<form name="FormFavoriteInsert" id="FormFavoriteInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="menuSeq" />
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
</form>

<form name="FormFavoriteList" id="FormFavoriteList" method="post" onsubmit="return false;">
	<input type="hidden" name="menuSeq" value="<c:out value="${appCurrentMenu.menu.menuSeq}" />" />
</form>

<form name="FormFavoriteDelete" id="FormFavoriteDelete" method="post" onsubmit="return false;">
	<input type="hidden" name="bookMarkSeq" />
</form>
<!-- 즐겨찾기 form 종료 -->

<div id="layout" class="wrap">
	<!-- header -->
	<div class="header">
		<h1 class="logo"><a href="<c:out value="${startPage}"/>"><aof:img src="common/logo-black.png"/></a></h1>
		<div class="gnb">
			<div class="admin">
				<p class="admin-name dot"><c:out value="${ssMemberName}"/>[<c:out value="${ssCurrentRoleCfString}"/>]</p>
				
				<c:set var="checkCourseActiveSeq" value="${param['shortcutCourseActiveSeq']}" />
				<c:set var="requestUri" value="${pageContext.request.requestURI}" />

				<!-- 읽지않은 쪽지 -->
				<%--
				<p class="admin-name dot"><a href="/message.do"><spring:message code="글:쪽지:쪽지"/>(<span id="unreadMessage">${ssMemoCount}</span>)</a></p>
				 --%>
				<!-- 즐겨찾기 -->			
				<div class="admin-group">
					<a href="#"><spring:message code="글:헤더:즐겨찾기"/></a>
					<ul class="manage-menu favorite">
						<li class="bg-top"></li>
							<span id="containerFavorite" name="containerFavorite">
							     <c:import url="/WEB-INF/view/controller/infra/bookmark/listBookmarkAjax.jsp"></c:import>
							</span>
						<li class="bg-bot"></li>
					</ul>			
				</div>
				<%--
				<c:import url="/WEB-INF/view/include/crossSite.jsp"/>
 				--%>
				<c:if test="${!empty ssMemberName}">
					<a href="<c:url value="/security/logout"/>" class="dot logout"><spring:message code="버튼:로그아웃"/></a>
				</c:if>
			</div>
		</div>
	</div>
	<!-- //header -->

	<!-- container -->
	<div id="container" class="container">
		<div class="section-content">
			<div id="section_west" class="aside">
				<c:import url="/WEB-INF/view/decorator/menu.jsp">
					<c:param name="menu" value="nav"/>
				</c:import>
			</div>
			
			<div id="section_2column" class="content-wrap">
				<div class="content">
				
					<c:import url="/WEB-INF/view/decorator/menu.jsp">
						<c:param name="menu" value="snb"/>
					</c:import>
				
					<decorator:body/>

				</div>
			</div>
		</div>
	</div>
	<!-- //container -->

	<!-- footer -->
	<c:import url="/WEB-INF/view/include/footer.jsp"/>
	<!-- //footer -->
	
	<iframe name="hiddenframe" id="hiddenframe" height="0" width="0" style="display:none;"></iframe>
	<iframe name="favoriteHiddenframe" id="favoriteHiddenframe" height="0" width="0" style="display:none;"></iframe>
</div>

</body>
</html>
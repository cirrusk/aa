<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="learning">
<head>

<title></title>
<c:import url="simpleLearningScript.jsp"/>
</head>
<body>
	<div class="learning" style="height:805px;">
		<div class="pop-header">
			<h3><span class="pop-header-online"></span><c:out value="${learning.organizationTitle}"/> - <c:out value="${learning.itemTitle}"/></h3>
			<a href="javascript:void(0)" onclick="SUB.doClose()" class="close"><aof:img src="common/pop_close.gif" alt="버튼:닫기" /></a>
		</div>
	
		<div class="section-contents">
			<div class="data-study" style="width:1000px; height:700px;">
				<iframe id="contentsFrame" name="contentsFrame" frameborder="no" scrolling="no" onload="SUB.onLoadIframe()" style="width:100%; height:100%; display:none;"></iframe>
			</div>
		</div>
		
		<div class="tabs-www-bottom-left" style="">
			<a class="tab" site="YouTube" onclick="SUB.doToggleTab(this, 'external-search')"><spring:message code="글:콘텐츠:유투브"/></a>
		</div>
				
		<div class="tabs-content" >
			<div id="external-search" class="tab-section tab-section-bottom" style="bottom: 50px;">
				<div class="close" onclick="SUB.doCloseTab(this)" style="top:10px;"></div>
				<div class="search" style="width:989px;">
					<form name="SubFormSrch" id="SubFormSrch" method="post" onsubmit="return false;">
						<input type="hidden" name="site">
						<input type="text" name="srchWord" class="input" value="<c:out value="${learning.keyword}"/>" title="<spring:message code="글:콘텐츠:검색키워드"/>" 
							onkeyup="UT.callFunctionByEnter(event, SUB.doExternalSearch);"
						/><span class="srch-btn-set">
						<aof:img src="common/blank.gif" styleClass="vline"/><a onclick="SUB.doExternalSearch()"><aof:img src="common/blank.gif" styleClass="srch-btn" alt="버튼:검색"/></a>
						</span>
					</form>
				</div>
				<div class="data-study" style="width:989px;overflow:hidden; padding-left: 0px;">
					<iframe id="searchFrame" name="searchFrame" frameborder="no" scrolling="no" style="width:100%; height:100%; overflow-x:hidden; overflow-y:auto;"></iframe>
				</div>
			</div>
		</div>
	
	</div>
	
</html>
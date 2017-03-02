<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="learning">
<head>
<title></title>
<c:import url="simpleLearningScript.jsp"/>
</head>
<body>

	<div class="learning" style="height:765px;">
		<div class="section-head">
			<div class="title" style="width:960px;"><c:out value="${learning.organizationTitle}"/><span class="subtitle">- <c:out value="${learning.itemTitle}"/></span></div>
			<div class="close" onclick="SUB.doClose()" title="<spring:message code="버튼:닫기"/>"></div>
		</div>
	
		<div class="section-contents">
			<div class="data" style="width:1000px; height:700px;">
				<iframe id="contentsFrame" name="contentsFrame" frameborder="no" scrolling="no" onload="SUB.onLoadIframe()" style="width:100%; height:100%; display:none;"></iframe>
			</div>
		</div>

		<div class="tabs-bottom-left">
			<a class="tab" site="YouTube" onclick="SUB.doToggleTab(this, 'external-search')"><spring:message code="글:콘텐츠:유투브"/></a>
		</div>

		<div class="tabs-bottom-right">
			<a class="tab" onclick="SUB.doToggleTab(this, 'log')"><spring:message code="글:콘텐츠:로그"/></a>
		</div>
				
		<div class="tabs-content">
			<div id="log" class="tab-section tab-section-bottom">
				<div class="close" onclick="SUB.doCloseTab(this)" style="top:10px;"></div>
				<div class="search" style="width:989px;">
					<form id="SubFormLog" name="SubFormLog" method="post" onsubmit="return false;"></form>
					<span class="margin-r-10">
						<span class="margin-r-5"><spring:message code="글:콘텐츠:시작"/></span>
						<aof:img src="common/blank.gif" id="initialize-false" styleClass="success-circle"                      alt="글:콘텐츠:초기화되지않았습니다"/>
						<aof:img src="common/blank.gif" id="initialize-true"  styleClass="failure-circle" style="display:none" alt="글:콘텐츠:초기화되었습니다"/>
					</span>

					<span class="margin-r-10">
						<span class="margin-r-5"><spring:message code="글:콘텐츠:데이터"/></span>
						<aof:img src="common/blank.gif"  id="values-false" styleClass="success-circle"                      alt="글:콘텐츠:학습이력정보가정상적으로처리되지않았습니다"/>
						<aof:img src="common/blank.gif" id="values-true"   styleClass="failure-circle" style="display:none" alt="글:콘텐츠:학습이력정보가정상적으로처리되었습니다"/>
					</span>

					<span class="margin-r-10">
						<span class="margin-r-5"><spring:message code="글:콘텐츠:종료"/></span>
						<aof:img src="common/blank.gif"  id="terminate-false" styleClass="success-circle"                      alt="글:콘텐츠:종료되지않았습니다"/>
						<aof:img src="common/blank.gif" id="terminate-true"   styleClass="failure-circle" style="display:none" alt="글:콘텐츠:정상종료되었습니다"/>
					</span>
					
					<span class="margin-r-10">
						<a onclick="SUB.doButton('exit')" class="btn gray"><span class="small"><spring:message code="버튼:콘텐츠:학습종료"/></span></a>
					</span>
					<span class="margin-r-10">
						<a onclick="SUB.doButton('clear')" class="btn gray"><span class="small"><spring:message code="버튼:콘텐츠:로그지우기"/></span></a>
					</span>
				</div>
				<div class="data" style="width:989px; overflow:hidden;">
					<iframe id="logFrame" name="logFrame" frameborder="no" scrolling="no" style="width:100%; height:100%; overflow-x:hidden; overflow-y:auto;"></iframe>
				</div>
			</div>
			<div id="external-search" class="tab-section tab-section-bottom">
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
				<div class="data" style="width:989px;overflow:hidden;">
					<iframe id="searchFrame" name="searchFrame" frameborder="no" scrolling="no" style="width:100%; height:100%; overflow-x:hidden; overflow-y:auto;"></iframe>
				</div>
			</div>
		</div>
	
	</div>
</body>
</html>
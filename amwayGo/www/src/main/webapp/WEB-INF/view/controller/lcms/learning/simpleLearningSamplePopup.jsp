<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<c:if test="${learning.contentTypeCd eq 'general' and fn:contains(header['user-agent'], 'MSIE')}">
	<meta name="quirks" content="<!-- quirks mode -->">
</c:if>
<title></title>
<c:import url="simpleLearningScript.jsp"/>
<style>
body {padding:0px;margin:0px;}
</style>
</head>

<body>

	<table>
	<tbody>
	<tr>
		<td style="height:33px;line-height:33px;text-align:left;padding-left:30px;">
			<div style="position:relative;">
				<span><strong style="font-size:150%;"><c:out value="${learning.organizationTitle}"/></strong></span>
				<span style="maring-left:10px;"> - <c:out value="${learning.itemTitle}"/></span>
	
				<div style="position:absolute;right:10px;top:0px;"> 
					<a href="#" onclick="doButton('exit')" class="btn black"><span class="mid"><spring:message code="버튼:닫기"/></span></a>
				</div>
			</div>
		</td>
	</tr>	
	<tr>
		<td style="vertical-align:top;">
			<iframe id="contentsFrame" name="contentsFrame" frameborder="no" scrolling="no" onload="onLoadIframe()" style="border:gray 1px solid;display:none;"></iframe>
		</td>
	</tr>
	</tbody>
	</table>

</body>
</html>
<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<form id="FormGlobalParameters" name="FormGlobalParameters" method="post" onsubmit="return false;">
<input type="hidden" name="currentMenuId" value="<c:out value="${param['currentMenuId']}"/>"/>
</form>
<form id="FormParameters" name="FormParameters" method="post" onsubmit="return false;">
</form>
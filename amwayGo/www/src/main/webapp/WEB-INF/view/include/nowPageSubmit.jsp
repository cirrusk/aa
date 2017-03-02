<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%@ page import="java.util.Enumeration;" %>
<%--
	2014.06.23 김현우
	
	OCW에서 상단 로그인 UI로 로그인시 현재 페이지를 유지하기 위하여 추가 하였다.
	
 --%>
<script type="text/javascript">

doNowPageSubmit = function() {
	var action = $.action();
	action.config.formId      = "FormNowPage";
	action.config.url = "<c:url value="${servletPath}"/>";
	action.run();
};

</script>

<form id="FormNowPage" name="FormNowPage" method="get" onsubmit="return false;">
<%

	Enumeration parameters = request.getParameterNames();
	String name = "";
	String value = "";
	while (parameters.hasMoreElements()) {
		name = (String)parameters.nextElement();
		value = request.getParameter(name);
	%>
	<input type="hidden" name="<%=name %>" value="<%=value%>">
	<%	
	}
%>
</form>
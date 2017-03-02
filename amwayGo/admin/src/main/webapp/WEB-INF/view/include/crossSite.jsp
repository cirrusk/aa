<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_ROLE_USR" value="${aoffn:code('CD.ROLE.USR')}"/>
<c:set var="CD_ROLE_ADM" value="${aoffn:code('CD.ROLE.ADM')}"/>

<c:if test="${aoffn:size(ssRoleGroups) gt 1}">
	<script type="text/javascript">
	<%-- 공통코드 --%>
	var CD_ROLE_USR = "<c:out value="${CD_ROLE_USR}"/>";
	var CD_ROLE_ADM = "<c:out value="${CD_ROLE_ADM}"/>";

	_doChangeRolegroup = function(element) {
		var $element = jQuery(element);
		
		// JSONArray형식으로 데이터를 넣으면 member.getExtendData(map)에 값이 담긴다. ex) [{"name":"observerYn", "value":"Y"},{"name":"memberSeq", "value":"1"}]
		var extendData = '';
		document.getElementById("j_extendData").value = extendData;
		
		var role = $element.attr("info").split("@");
		if (role.length == 3) {
			switch(role[1]) {
			case CD_ROLE_USR:
				var action = $.action("ajax");
				action.config.formId      = "_FormChangeAccess";
				action.config.url         = "<c:url value="/common/access/signature.do"/>";
				action.config.type        = "json";
				action.config.fn.complete = function(action, data) {
					if (data.signature !== "") {
						var action2 = $.action();
						action2.config.formId = "_FormChangeAccess";
						action2.config.url    = "<c:out value="${aoffn:config('domain.www')}"/>" + "<c:url value="/security/login"/>";
						action2.config.target = "_blank";
						var form = UT.getById(action2.config.formId); 
						form.elements["j_username"].value = data.signature;
						form.elements["j_password"].value = data.password;
						form.elements["j_rolegroup"].value = role[0];
						action2.run();
					}
				};
				action.run();
				break;
			case CD_ROLE_ADM:
				var action = $.action("ajax");
				action.config.formId      = "_FormChangeAccess";
				action.config.url         = "<c:url value="/common/access/change.do"/>";
				action.config.type        = "json";
				UT.getById(action.config.formId).elements["j_rolegroup"].value = role[0];
				UT.getById(action.config.formId).elements["j_roleCfString"].value = role[2];
				action.config.fn.complete = function(action, data) {
					if (data.change == true) {
						self.location.href = "<c:out value="${aoffn:config('system.startPage')}"/>";
					}
				};
				action.run();
				break;
			}
		}
	};
	</script>

	<c:set var="ssCurrentRolegroupName" value=""/>
	<c:forEach var="row" items="${ssRoleGroups}" varStatus="i">
		<c:if test="${row.rolegroupSeq eq ssCurrentRolegroupSeq}">
			<c:set var="ssCurrentRolegroupName" value="${row.rolegroupName}"/>
		</c:if>
	</c:forEach>
	<div class="admin-group">
		<a href="#"><c:out value="${ssCurrentRolegroupName}"/></a>
		<ul class="manage-menu">
			<li class="bg-top"></li>
			<c:forEach var="row" items="${ssRoleGroups}" varStatus="i">
				<li><a href="javascript:void(0)" onclick="_doChangeRolegroup(this)" info="<c:out value="${row.rolegroupSeq}@${row.roleCd}@${row.cfString}"/>"><c:out value="${row.rolegroupName}"/></a></li>
			</c:forEach>
			<li class="bg-bot"></li>
		</ul>			
	</div>
 
	<form name="_FormChangeAccess" id="_FormChangeAccess" method="post" onsubmit="return false;" class="inline">
		<input type="hidden" name="j_username">
		<input type="hidden" name="j_password">
		<input type="hidden" name="j_rolegroup">
		<input type="hidden" name="j_roleCfString">
		<input type="hidden" name="j_extendData" id="j_extendData">
		<input type="hidden" name="memberId" value="<c:out value="${ssMemberId}"/>">
	</form>
</c:if>
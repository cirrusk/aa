<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<script type="text/javascript">
	$(document).ready(function(){
		$("#btnLogoug").on("click", function(){
			location.href="/manager/common/main/logout.do";
		});
	});

	function changeRole() {
		$("#roleCd").val($('#changeRoleSelectId').val());
		document.changeRoleForm.action = "<c:url value='/manage/main/changeRole.mvc'/>";
		document.changeRoleForm.submit();
	}
	
</script>

    <div id="header">
    
  		<form class="changeRole" id="changeRoleForm" name="changeRoleForm" action="/manage/main/changeRole.mvc" method="post">
			<input type="hidden" id="roleCd" name="roleCd" value=""/>
		</form>
  
		<ul>
			<li class="hlogo">
				<h1>
					<p style="color:white;padding-top:20px;"><img src="/static/axisj/ui/arongi/images/logo.png" width="30%" alt="Amway" />Academy Admin</p>
				</h1>
			</li>
			<li class="hinfo" style="float:right;">
				<span><strong><%=request.getSession().getAttribute("sessionAdno")%></strong>님 환영합니다.</span>
				<!-- select name="changeRoleSelectId" id="changeRoleSelectId" onchange="changeRole();">
					<option value="US">총괄관리자</option>
					<c:forEach var="role" items="${sessionScope.HRD_SESSION_KEY.roleList}">
						<c:if test="${role.levelCd != 'US'}">
							<option value="${role.levelCd}" <c:if test="${sessionScope.HRD_SESSION_KEY.roleCd==role.levelCd}">selected</c:if> >${role.levelNm}</option>
						</c:if>
					</c:forEach>
			  	</select> -->
				<input type="button" id="btnLogoug" name="btnLogout" value="로그아웃" />
			</li>
		</ul>
    </div>
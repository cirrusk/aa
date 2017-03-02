<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<html>
<body>
<div id="rightTable" style="margin:0px; width:100%;">
		<div class="tbl_write"  style="margin:0px; width:100%;">
				<div style="font-size: 20px; font-weight: bold;">${managerInfo.adno }&nbsp;&nbsp;&nbsp;${managerInfo.managename }(${managerInfo.managedepart})</div>
				<br/>
				<div class="contents_title clear authWrite">
					<div class="fl">
						<label style="font-size: 15px;">
							<input type="checkbox" style="width:30px; height:20px; border:1px;" id="allCheck">전체조회권한
						</label>
					</div>
					<div class="fr">
						<a href="javascript:;"  id="save_Btn" class="btn_green">저장</a>
						<a href="javascript:;"  class="btn_green" id="resetBtn">초기화</a>
						<a href="javascript:;"  id="delete_manager" class="btn_gray">운영자삭제</a>
					</div>
				</div>
				<div style="width:100%; height:600px;overflow-y:scroll;">
				<form id="menuForm">
						<table id="tblLecInfo1"  border="0" cellspacing="0" cellpadding="0" width="100%">
						<input type="hidden" id="curAdno" name="adno" value="${managerInfo.adno }">
						<colgroup>
							<col style="width: 8%;">
							<col style="width: 52%;">
							<col style="width: 40%; min-width: 200px;">
						</colgroup>
						<tr>
							<th></th>
							<th style="text-align: center;">메뉴</th>
							<th style="text-align: center;">권한</th>
						</tr>
						<tr>
							<th></th>
							<th style="text-align: center;">시설/체험관리</th>
							<th style="text-align: center;"></th>
						</tr>
						<c:forEach items="${menuList }" var="menuList">
							<c:choose>
								<c:when test="${menuList.menulevel eq 1 }">
									<tr >
										<td style="background-color: #E4FAC8;">
											<c:if test="${not empty menuList.menuauth }">
												&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" value="${menuList.menucode }" class="menu${menuList.menulevel } ${menuList.sort }"  id="${menuList.menucode }" name="menucodes" checked="checked">
											</c:if>
											<c:if test="${empty menuList.menuauth }">
												&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" value="${menuList.menucode }" class="menu${menuList.menulevel } ${menuList.sort }"  id="${menuList.menucode }"  name="menucodes" >
											</c:if>
										</td>
										<td style="background-color: #E4FAC8; font-weight: bold; font-size: 16px;">
										 	&nbsp;&nbsp;&nbsp;${menuList.menuname }
										</td>
										<td style="background-color: #E4FAC8;">
											<c:choose>
												<c:when test="${menuList.menuauth eq 'R' }">
													&nbsp;&nbsp;<input type="radio"  name="${menuList.menucode }authradio" id="authradio${menuList.menucode }"  value="R"  class="authradio ${menuList.sort }"  checked>  읽기  &nbsp;&nbsp;
													<input type="radio"  name="${menuList.menucode }authradio" value="W"  id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }" > 읽기 & 수정 
												</c:when>
												<c:when test="${menuList.menuauth eq 'W' }">
													&nbsp;&nbsp; <input type="radio"  name="${menuList.menucode }authradio" id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }"  value="R" >  읽기 &nbsp;&nbsp;
													<input type="radio"  name="${menuList.menucode }authradio" value="W" id="authradio${menuList.menucode }" class="authradio ${menuList.sort }"  checked> 읽기 & 수정 
												</c:when>
												<c:otherwise>
													&nbsp;&nbsp;<input type="radio"  name="${menuList.menucode }authradio" id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }"  value="R" >  읽기 &nbsp;&nbsp;
													<input type="radio"  name="${menuList.menucode }authradio" value="W" id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }" > 읽기 &수정 
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:when>
								<c:when test="${menuList.menulevel eq 2 }">
									<tr>
										<td style="background-color: #F7F9CE;">
											<c:if test="${not empty menuList.menuauth }">
												&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" value="${menuList.menucode }" class="menu${menuList.menulevel } ${menuList.sort }"  id="${menuList.menucode }"  name="menucodes" checked="checked">
											</c:if>
											<c:if test="${empty menuList.menuauth }">
												&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" value="${menuList.menucode }" class="menu${menuList.menulevel } ${menuList.sort }"  id="${menuList.menucode }"   name="menucodes" >
											</c:if>
										</td>
										<td style="background-color: #F7F9CE; font-size: 15px;">
									 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${menuList.menuname }
										</td>
										<td style="background-color: #F7F9CE;">
											<c:choose>
												<c:when test="${menuList.menuauth eq 'R' }">
													&nbsp;&nbsp; <input type="radio"  name="${menuList.menucode }authradio" id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }"  value="R"  checked> 읽기 &nbsp;&nbsp;
													<input type="radio"  name="${menuList.menucode }authradio" value="W" id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }" > 읽기 & 수정 
												</c:when>
												<c:when test="${menuList.menuauth eq 'W' }">
													&nbsp;&nbsp;<input type="radio"  name="${menuList.menucode }authradio" id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }" value="R" >  읽기  &nbsp;&nbsp;
													<input type="radio"  name="${menuList.menucode }authradio" value="W"  id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }"  checked> 읽기 & 수정 
												</c:when>
												<c:otherwise>
													&nbsp;&nbsp;<input type="radio"  name="${menuList.menucode }authradio" id="authradio${menuList.menucode }"   class="authradio ${menuList.sort }" value="R" >  읽기 &nbsp;&nbsp;
													<input type="radio"  name="${menuList.menucode }authradio" value="W" id="authradio${menuList.menucode }"   class="authradio ${menuList.sort }" > 읽기 &수정 
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:when>
								<c:otherwise>
									<tr>
										<td>
											<c:if test="${not empty menuList.menuauth }">
												&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" value="${menuList.menucode }" class="menu${menuList.menulevel } ${menuList.sort }"   id="${menuList.menucode }" name="menucodes" checked="checked">
											</c:if>
											<c:if test="${empty menuList.menuauth }">
												&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" value="${menuList.menucode }" class="menu${menuList.menulevel } ${menuList.sort }"   id="${menuList.menucode }" name="menucodes" >
											</c:if>
										</td>
										<td>
										 	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${menuList.menuname }
										</td>
										<td>
											<c:choose>
												<c:when test="${menuList.menuauth eq 'R' }">
													&nbsp;&nbsp;<input type="radio"  name="${menuList.menucode }authradio"  id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }" value="R"  checked> 읽기  &nbsp;&nbsp;
													<input type="radio"  name="${menuList.menucode }authradio" value="W" id="authradio${menuList.menucode }"   class="authradio ${menuList.sort }" > 읽기 & 수정 
												</c:when>
												<c:when test="${menuList.menuauth eq 'W' }">
													&nbsp;&nbsp;<input type="radio"  name="${menuList.menucode }authradio"  id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }" value="R" >  읽기  &nbsp;&nbsp;
													<input type="radio"  name="${menuList.menucode }authradio" value="W"  id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }"  checked> 읽기 & 수정 
												</c:when>
												<c:otherwise>
													&nbsp;&nbsp;<input type="radio"  name="${menuList.menucode }authradio" id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }"  value="R" >  읽기 &nbsp;&nbsp;
													<input type="radio"  name="${menuList.menucode }authradio" value="W"  id="authradio${menuList.menucode }"  class="authradio ${menuList.sort }" > 읽기 &수정 
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</table>
				</form>
				</div>
			</div>
</div>

</body>
</html>
<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:if test="${param['menu'] eq 'nav'}">
	<div class="nav" id="nav">
		<ul class="menu scroll-content">
			<c:forEach var="depth1" items="${appMenuList}" varStatus="i1">
	
				<%-- 1 depth --%>
				<c:if test="${aoffn:toInt(fn:length(depth1.menu.menuId) / 3) eq 1 and depth1.menu.displayYn eq 'Y'}"> 
					<li>
						<c:set var="_onclick"/>
						<c:if test="${!empty depth1.menu.url}">
							<c:set var="_onclick">FN.doGoMenu('<c:url value="${depth1.menu.url}"/>','<c:out value="${aoffn:encrypt(depth1.menu.menuId)}"/>','<c:out value="${depth1.menu.dependent}"/>','<c:out value="${depth1.menu.urlTarget}"/>');</c:set>
						</c:if>
						<a href="javascript:void(0)" <c:if test="${!empty _onclick}">onclick="<c:out value="${_onclick}" escapeXml="false"/>"</c:if>
						   ><span class="nav-icon<c:out value="${depth1.menu.menuId}"/>"></span><c:out value="${depth1.menu.menuName}"/></a> 
										
						<%-- 2 depth --%>
						<c:set var="existDepth2" value="false"/>
						<c:forEach var="depth2" items="${appMenuList}" varStatus="i2">
							<c:if test="${fn:startsWith(depth2.menu.menuId, depth1.menu.menuId) eq true and aoffn:toInt(fn:length(depth2.menu.menuId) / 3) eq 2}"> 
								<c:set var="existDepth2" value="true"/>
							</c:if>
						</c:forEach>
						<c:if test="${existDepth2 eq true}">
							<ul class="submenu01">
								<c:forEach var="depth2" items="${appMenuList}" varStatus="i2">
									<c:if test="${fn:startsWith(depth2.menu.menuId, depth1.menu.menuId) eq true and aoffn:toInt(fn:length(depth2.menu.menuId) / 3) eq 2 and depth2.menu.displayYn eq 'Y'}">
										<%-- 3 depth --%>
										<c:set var="existDepth3" value="false"/>
										<c:forEach var="depth3" items="${appMenuList}" varStatus="i3">
											<c:if test="${fn:startsWith(depth3.menu.menuId, depth2.menu.menuId) eq true and aoffn:toInt(fn:length(depth3.menu.menuId) / 3) eq 3}"> 
												<c:set var="existDepth3" value="true"/>
											</c:if>
										</c:forEach>
										
										<%-- 4 depth 하위메뉴가 없을수 영역이 안보이게 하기위해 추가--%>
										<c:set var="existDepth4" value="false"/>
										<c:forEach var="depth4" items="${appMenuList}" varStatus="i3">
											<c:if test="${fn:startsWith(depth4.menu.menuId, depth2.menu.menuId) eq true and aoffn:toInt(fn:length(depth4.menu.menuId) / 3) eq 3 and depth4.menu.displayYn eq 'Y'}"> 
												<c:set var="existDepth4" value="true"/>
											</c:if>
										</c:forEach>
									 	
										<li class="<c:out value="${existDepth3 eq true and existDepth4 eq true ? 'submenu' : ''}"/> - <c:out value="${!empty depth2.menu.dependent ? 'dependent-menu' : ''}"/>" 
											<c:if test="${!empty depth2.menu.dependent}">
												dependent="<c:out value="${depth2.menu.dependent}"/>"
												style="display:none;"
											</c:if>>
											<c:set var="_onclick"/>
											<c:if test="${!empty depth2.menu.url}">
												<c:set var="_onclick">FN.doGoMenu('<c:url value="${depth2.menu.url}"/>','<c:out value="${aoffn:encrypt(depth2.menu.menuId)}"/>','<c:out value="${depth2.menu.dependent}"/>','<c:out value="${depth2.menu.urlTarget}"/>');</c:set>
											</c:if>
											<a href="javascript:void(0)" <c:if test="${!empty _onclick}">onclick="<c:out value="${_onclick}" escapeXml="false"/>"</c:if>
											   ><c:out value="${depth2.menu.menuName}"/></a> 
										
											<c:if test="${existDepth4 eq true}">
												<ul class="submenu02">
													<c:forEach var="depth3" items="${appMenuList}" varStatus="i3">
														<c:if test="${fn:startsWith(depth3.menu.menuId, depth2.menu.menuId) eq true and aoffn:toInt(fn:length(depth3.menu.menuId) / 3) eq 3 and depth3.menu.displayYn eq 'Y'}"> 
															<li>
																<c:set var="_onclick"/>
																<c:if test="${!empty depth3.menu.url}">
																	<c:set var="_onclick">FN.doGoMenu('<c:url value="${depth3.menu.url}"/>','<c:out value="${aoffn:encrypt(depth3.menu.menuId)}"/>','<c:out value="${depth3.menu.dependent}"/>','<c:out value="${depth3.menu.urlTarget}"/>');</c:set>
																</c:if>
																<a href="javascript:void(0)" <c:if test="${!empty _onclick}">onclick="<c:out value="${_onclick}" escapeXml="false"/>"</c:if>
																   ><c:out value="${depth3.menu.menuName}"/></a> 
															</li>													
														</c:if>
													</c:forEach>
												</ul>
											</c:if>
										</li>				
									</c:if>
								</c:forEach>
							</ul>
						</c:if>
					</li>
				</c:if>
			</c:forEach>
		</ul>
		<a href="javascript:void(0)" class="prev scroll-top" title="이전 메뉴"></a>
		<a href="javascript:void(0)" class="next scroll-bottom" title="다음 메뉴"></a>
	</div>
</c:if>

<c:if test="${param['menu'] eq 'snb'}">
	<c:set var="currentMenuDepth" value="${aoffn:toInt(fn:length(appCurrentMenu.menu.menuId) / 3)}"/>
	<c:set var="currentDepth1Id" value="${fn:substring(appCurrentMenu.menu.menuId, 0, 3)}"/>
	<c:if test="${currentMenuDepth gt 1}">
		<c:set var="currentDepth2Id" value="${fn:substring(appCurrentMenu.menu.menuId, 0, 6)}"/>
	</c:if>
	
	<div class="snb">
		<ul>
			<li class="home"><a href="<c:out value="${startPage}"/>"></a></li>

			<%-- 1 depth --%>
			<li>
				<c:set var="depth1Menu" value="${appCurrentMenu}"/>
				<c:forEach var="depth1" items="${appMenuList}" varStatus="i2">
					<c:if test="${currentDepth1Id eq depth1.menu.menuId and aoffn:toInt(fn:length(depth1.menu.menuId) / 3) eq 1}">
						<c:set var="depth1Menu" value="${depth1}"/>
					</c:if>
				</c:forEach>
				<a href="javascript:void(0)"><c:out value="${depth1Menu.menu.menuName}"/></a>
				<ul class="manage-menu">
					<li class="bg-top"></li>
					<c:forEach var="depth1" items="${appMenuList}" varStatus="i2">
						<c:if test="${aoffn:toInt(fn:length(depth1.menu.menuId) / 3) eq 1 and depth1.menu.displayYn eq 'Y'}">
							<c:set var="_onclick"/>
							<c:choose>
								<c:when test="${!empty depth1.menu.url}">
									<c:set var="_onclick">FN.doGoMenu('<c:url value="${depth1.menu.url}"/>','<c:out value="${aoffn:encrypt(depth1.menu.menuId)}"/>','<c:out value="${depth1.menu.dependent}"/>','<c:out value="${depth1.menu.urlTarget}"/>');</c:set>
								</c:when>
								<c:otherwise>
									<%-- 2, 3 depth 에서 url이 존재하는 메뉴 --%>
									<c:forEach var="depth3" items="${appMenuList}" varStatus="i3">
										<c:if test="${fn:startsWith(depth3.menu.menuId, depth1.menu.menuId) eq true and aoffn:toInt(fn:length(depth3.menu.menuId) / 3) gt 1 and depth3.menu.displayYn eq 'Y'}">
											<c:if test="${empty _onclick and !empty depth3.menu.url}">
												<c:set var="_onclick">FN.doGoMenu('<c:url value="${depth3.menu.url}"/>','<c:out value="${aoffn:encrypt(depth3.menu.menuId)}"/>','<c:out value="${depth3.menu.dependent}"/>','<c:out value="${depth3.menu.urlTarget}"/>');</c:set>
											</c:if>
										</c:if>
									</c:forEach>									
								</c:otherwise>
							</c:choose>
							<li <c:if test="${!empty depth1.menu.dependent}">
									dependent="<c:out value="${depth1.menu.dependent}"/>"
									style="display:none;"
									class="dependent-menu"
								</c:if>
							>
								<a href="javascript:void(0)" <c:if test="${!empty _onclick}">onclick="<c:out value="${_onclick}" escapeXml="false"/>"</c:if>
								   ><c:out value="${depth1.menu.menuName}"/></a> 
							</li>
						</c:if>
					</c:forEach>
					<li class="bg-bot"></li>
				</ul>
			</li>

			<%-- 2 depth --%>
			<c:set var="depth2Menu"/>
			<c:set var="existDepth2" value="false"/>
			<c:forEach var="depth2" items="${appMenuList}" varStatus="i2">
				<c:if test="${currentDepth2Id eq depth2.menu.menuId and aoffn:toInt(fn:length(depth2.menu.menuId) / 3) eq 2}">
					<c:set var="depth2Menu" value="${depth2}"/>
				</c:if>
				<c:if test="${fn:startsWith(depth2.menu.menuId, currentDepth1Id) eq true and aoffn:toInt(fn:length(depth2.menu.menuId) / 3) eq 2 and depth2.menu.displayYn eq 'Y'}"> 
					<c:set var="existDepth2" value="true"/>
				</c:if>
			</c:forEach>
			<c:if test="${(existDepth2 eq true and currentMenuDepth eq 1) or currentMenuDepth ge 2}">
				<li>
					<a href="javascript:void(0)"><c:out value="${!empty depth2Menu ? depth2Menu.menu.menuName : '----------'}"/></a>
					<ul class="manage-menu">
						<li class="bg-top"></li>
						<c:forEach var="depth2" items="${appMenuList}" varStatus="i2">
							<c:if test="${fn:startsWith(depth2.menu.menuId, currentDepth1Id) eq true and aoffn:toInt(fn:length(depth2.menu.menuId) / 3) eq 2 and depth2.menu.displayYn eq 'Y'}"> 
								<c:set var="_onclick"/>
								<c:choose>
									<c:when test="${!empty depth2.menu.url}">
										<c:set var="_onclick">FN.doGoMenu('<c:url value="${depth2.menu.url}"/>','<c:out value="${aoffn:encrypt(depth2.menu.menuId)}"/>','<c:out value="${depth2.menu.dependent}"/>','<c:out value="${depth2.menu.urlTarget}"/>');</c:set>
									</c:when>
									<c:otherwise>
										<%-- 3 depth 에서 url이 존재하는 메뉴 --%>
										<c:forEach var="depth3" items="${appMenuList}" varStatus="i3">
											<c:if test="${fn:startsWith(depth3.menu.menuId, depth2.menu.menuId) eq true and aoffn:toInt(fn:length(depth3.menu.menuId) / 3) eq 3 and depth3.menu.displayYn eq 'Y'}">
												<c:if test="${empty _onclick and !empty depth3.menu.url}">
													<c:set var="_onclick">FN.doGoMenu('<c:url value="${depth3.menu.url}"/>','<c:out value="${aoffn:encrypt(depth3.menu.menuId)}"/>','<c:out value="${depth3.menu.dependent}"/>','<c:out value="${depth3.menu.urlTarget}"/>');</c:set>
												</c:if>
											</c:if>
										</c:forEach>									
									</c:otherwise>
								</c:choose>
								<li <c:if test="${!empty depth2.menu.dependent}">
										dependent="<c:out value="${depth2.menu.dependent}"/>"
										style="display:none;"
										class="dependent-menu"
									</c:if>
								>
									<a href="javascript:void(0)" <c:if test="${!empty _onclick}">onclick="<c:out value="${_onclick}" escapeXml="false"/>"</c:if>
									   ><c:out value="${depth2.menu.menuName}"/></a> 
								</li>
							</c:if>
						</c:forEach>
						<li class="bg-bot"></li>
					</ul>
				</li>
			</c:if>
			
			<%-- 3 depth --%>
			<c:set var="depth3Menu"/>
			<c:set var="existDepth3" value="false"/>
			<c:forEach var="depth3" items="${appMenuList}" varStatus="i2">
				<c:if test="${fn:startsWith(appCurrentMenu.menu.menuId, depth3.menu.menuId) eq true and aoffn:toInt(fn:length(depth3.menu.menuId) / 3) eq 3}">
					<c:set var="depth3Menu" value="${depth3}"/>
				</c:if>
				<c:if test="${fn:startsWith(depth3.menu.menuId, currentDepth2Id) eq true and aoffn:toInt(fn:length(depth3.menu.menuId) / 3) eq 3 and depth3.menu.displayYn eq 'Y'}">
					<c:set var="existDepth3" value="true"/>
				</c:if>
			</c:forEach>
			
			<c:if test="${(existDepth3 eq true and currentMenuDepth eq 2) or currentMenuDepth ge 3}">
				<li>
					<a href="javascript:void(0)"><c:out value="${!empty depth3Menu ? depth3Menu.menu.menuName : '----------'}"/></a>
					<ul class="manage-menu">
						<li class="bg-top"></li>
						<c:forEach var="depth3" items="${appMenuList}" varStatus="i3">
							<c:if test="${fn:startsWith(depth3.menu.menuId, depth2Menu.menu.menuId) eq true and aoffn:toInt(fn:length(depth3.menu.menuId) / 3) eq 3 and depth3.menu.displayYn eq 'Y'}"> 
								<c:set var="_onclick"/>
								<c:if test="${!empty depth3.menu.url}">
									<c:set var="_onclick">FN.doGoMenu('<c:url value="${depth3.menu.url}"/>','<c:out value="${aoffn:encrypt(depth3.menu.menuId)}"/>','<c:out value="${depth3.menu.dependent}"/>','<c:out value="${depth3.menu.urlTarget}"/>');</c:set>
								</c:if>
								<li <c:if test="${!empty depth3.menu.dependent}">
										dependent="<c:out value="${depth3.menu.dependent}"/>"
										style="display:none;"
										class="dependent-menu"
									</c:if>
								>
									<a href="javascript:void(0)" <c:if test="${!empty _onclick}">onclick="<c:out value="${_onclick}" escapeXml="false"/>"</c:if>
									   ><c:out value="${depth3.menu.menuName}"/></a> 
								</li>
							</c:if>
						</c:forEach>
						<li class="bg-bot"></li>
					</ul>
				</li>
			</c:if>
		</ul>

		<!-- 즐겨찾기 -->
        <c:set var="startPage"><c:url value="${aoffn:config('system.startPage')}"/></c:set>
        <c:set var="currentPage" value="${pageContext.request.requestURI}" />
        
        <c:choose>
            <c:when test="${startPage eq currentPage || (not empty param['shortcutCourseActiveSeq'] && currentPage != '/corp/courseactive/list.do' && currentPage != '/corp/courseactive/non/list.do')}">
                <%//greeting 페이지와 개설과목 상세 페이지 안쪽의 메뉴는 즐겨찾기 불가능 %>
                <p class="favicon_not" style="display:none;"><a href="#"><aof:img src="common/favicon_not.png" alt="글:헤더:즐겨찾기비활성화"/></a></p>
            </c:when>
            <c:otherwise>
                
                <c:set var="bookCount" value="0"/>
                <c:forEach var="row" items="${ssBookmarks}" varStatus="i">
                    <c:if test="${appCurrentMenu.menu.menuSeq ==  row.bookMark.menuSeq}">
                        <c:set var="bookCount" value="${bookCount+1}"/>
                    </c:if>
                </c:forEach>

                <c:choose>
                    <c:when test="${bookCount > 0}">
                        <p class="favicon_on"><a href="#"><aof:img src="common/favicon_on.png" alt="글:헤더:즐겨찾기체크온"/></a></p>  
                        <p class="favicon_off" style="display:none;"><a href="#" onclick="doFavoriteInsert({'menuSeq' : '${appCurrentMenu.menu.menuSeq}'});"><aof:img src="common/favicon_off.png" alt="글:헤더:즐겨찾기체크오프"/></a></p>
                    </c:when>
                    <c:otherwise>
                        <p class="favicon_on" style="display:none;"><a href="#"><aof:img src="common/favicon_on.png" alt="글:헤더:즐겨찾기체크온"/></a></p>   
                        <p class="favicon_off"><a href="#" onclick="doFavoriteInsert({'menuSeq' : '${appCurrentMenu.menu.menuSeq}'});"><aof:img src="common/favicon_off.png" alt="글:헤더:즐겨찾기체크오프"/></a></p>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
	</div>
</c:if>
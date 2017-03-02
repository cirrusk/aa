<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:set var="startPage"><c:url value="${aoffn:config('system.startPage')}"/></c:set>
<c:set var="bookmarkSize" value="${fn:length(ssBookmarks)}" />
<input type="hidden" id="bookmarkSize" value="${bookmarkSize}" />
<c:set var="appCurrentMenuId" value="${appCurrentMenu.menu.menuId}" />
            
<c:forEach var="row" items="${ssBookmarks}" varStatus="i">
    <li>
        <a href="#" onclick="FN.doGoFavoriteMenu('<c:out value="${appSystemDomain}"/><c:url value="${row.menu.url}"/>', 
                                '<c:out value="${aoffn:encrypt(row.menu.menuId)}"/>',
                                '<c:out value="${row.bookMark.courseActiveSeq}"/>'
                                );" >
            <c:out value="${row.menu.menuName}" />
        </a>
        
        <%-- 현메뉴의 즐겨찾기가 삭제되면 즐겨찾기 토글된다. --%>
        <c:choose>
        	<c:when test="${row.menu.menuId eq appCurrentMenu.menu.menuId}">
        		<c:set var="isShow" value="true"></c:set>
        	</c:when>
        	<c:otherwise>
        		<c:set var="isShow" value="false"></c:set>
        	</c:otherwise>
        </c:choose>
        <a href="#" class="delete" onclick="doFavoriteDelete({'bookMarkSeq':'${row.bookMark.bookMarkSeq}','isShow':${isShow}});" >
            <aof:img src="icon/icon_del.gif" alt="글:헤더:즐겨찾기삭제" />
        </a>                
    </li>
</c:forEach>
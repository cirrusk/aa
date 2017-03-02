<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<aof:session key="memberName"          var="ssMemberName"          scope="request"/>
<aof:session key="memberSeq"           var="ssMemberSeq"           scope="request"/>
<aof:session key="memberId"            var="ssMemberId"            scope="request"/>
<aof:session key="admin"               var="ssMemberAdmin"         scope="request"/>
<aof:session key="currentRolegroupSeq" var="ssCurrentRolegroupSeq" scope="request"/>
<aof:session key="currentRoleCfString" var="ssCurrentRoleCfString" scope="request"/>
<aof:session key="roleGroups"          var="ssRoleGroups"          scope="request"/>
<aof:session key="memoCount"           var="ssMemoCount"           scope="request"/>
<aof:session key="bookmarks"           var="ssBookmarks"           scope="request"/>
<aof:session key="photo"               var="memberPhoto"/>

<%// 롤그룹의 권한에 따라 시스템에 설정된 년도학기를 셋팅한다.  %>
<aof:session key="extendData"  var="ssExtendData"  scope="request"/>
<c:if test="${not empty extendData}">
	<aof:session key="extendData.systemYearTerm.yearTerm"  var="systemYearTerm"  scope="request"/>
	<aof:session key="extendData.systemYearTerm.year"      var="systemYear"      scope="request"/>
	<aof:session key="extendData.systemYearTerm.term"      var="systemTerm"      scope="request"/>
</c:if>

<c:choose>
	<c:when test="${!empty memberPhoto}">
		<c:set var="ssMemberPhoto" value ="${aoffn:config('upload.context.image')}${memberPhoto}.thumb.jpg" scope="request"/>
	</c:when>
	<c:otherwise>
		<c:set var="ssMemberPhoto" scope="request"><aof:img type="print" src="common/blank.gif"/></c:set>
	</c:otherwise>
</c:choose>

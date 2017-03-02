<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<aof:session key="memberName"          var="ssMemberName"          scope="request"/>
<aof:session key="memberSeq"           var="ssMemberSeq"           scope="request"/>
<aof:session key="memberId"            var="ssMemberId"            scope="request"/>
<aof:session key="admin"               var="ssMemberAdmin"         scope="request"/>
<aof:session key="currentRolegroupSeq" var="ssCurrentRolegroupSeq" scope="request"/>
<aof:session key="currentRoleCfString" var="ssCurrentRoleCfString" scope="request"/>
<aof:session key="roleGroups"          var="ssRoleGroups"          scope="request"/>
<aof:session key="memberEmsTypeCd"     var="ssMemberEmsTypeCd"     scope="request"/>
<aof:session key="studentStatusCd"     var="ssStudentStatusCd"     scope="request"/>

<aof:session key="photo" var="memberPhoto"/>
<c:choose>
	<c:when test="${!empty memberPhoto}">
		<c:set var="ssMemberPhoto" value ="${aoffn:config('upload.context.image')}${memberPhoto}.thumb.jpg" scope="request"/>
	</c:when>
	<c:otherwise>
		<c:set var="ssMemberPhoto" scope="request"><aof:img type="print" src="common/blank.gif"/></c:set>
	</c:otherwise>
</c:choose>

<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SCHEDULE_TYPE_01"  value="${aoffn:code('CD.SCHEDULE_TYPE.01')}"/>
<c:set var="CD_SCHEDULE_TYPE_02"  value="${aoffn:code('CD.SCHEDULE_TYPE.02')}"/>
<c:set var="CD_SCHEDULE_TYPE_03"  value="${aoffn:code('CD.SCHEDULE_TYPE.03')}"/>
<c:set var="CD_SCHEDULE_TYPE_04"  value="${aoffn:code('CD.SCHEDULE_TYPE.04')}"/>
<c:set var="CD_SCHEDULE_TYPE_05"  value="${aoffn:code('CD.SCHEDULE_TYPE.05')}"/>

<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/xcss/3rdparty/fullcalendar/fullcalendar.css" type="text/css"/>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/xcss/3rdparty/fullcalendar/fullcalendar.print.css" type="text/css" media='print'/>
<script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/3rdparty/fullcalendar/fullcalendar.min.js"></script>
<script type="text/javascript">
var scheduleColors = {
	"<c:out value="${CD_SCHEDULE_TYPE_01}"/>" : {
		"text" : "#ffffff",
		"bgcolor" : "#ff0000"
	},
	"<c:out value="${CD_SCHEDULE_TYPE_02}"/>" : {
		"text" : "#ffffff",
		"bgcolor" : "#ff5e00"
	},
	"<c:out value="${CD_SCHEDULE_TYPE_03}"/>" : {
		"text" : "#ffffff",
		"bgcolor" : "#ff007f"
	},
	"<c:out value="${CD_SCHEDULE_TYPE_04}"/>" : {
		"text" : "#ffffff",
		"bgcolor" : "#ffe400"
	},
	"<c:out value="${CD_SCHEDULE_TYPE_05}"/>" : {
		"text" : "#ffffff",
		"bgcolor" : "#abf200"
	}
};
</script>
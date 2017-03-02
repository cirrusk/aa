<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
<script src="/js/front.js"></script>
				<section id="articleSection" class="acItems">
				<c:forEach var="item" items="${courseList}" varStatus="status">
					<article class="item<c:if test="${item.finishflag eq 'Y'}"> selected</c:if>">
						<a href="#none" onClick="javascript:fnAccesViewClick('${item.courseid}');">
							<strong class="tit">${item.coursename}</strong>
							<span class="category">${item.coursename}</span>
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}" style="width: 100%; height: auto;" />
								<c:if test="${not empty item.playtime}"><span class="time">${item.playtime}</span></c:if>
							</span>
						</a>
						<div class="snsZone">
							<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
							<em id="likecntlab${item.courseid}">${item.likecnt}</em>
							<c:if test="${item.complianceflag ne 'Y'}">
							<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.savetype eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
							</c:if>
						</div>
						<div class="itemCont"> 
							<p>${item.coursecontent}</p>
							<p class="date">등록일 ${item.modifydate}<em>|</em>조회 ${item.viewcount}</p>
						</div>
					</article>
				</c:forEach>
				</section>
<script type="text/javascript">
	$(document).ready(function() {$(".img").find("img").load(function(){abnkorea_resize();}); });   // 이미지로드 완료시 호출.
</script>
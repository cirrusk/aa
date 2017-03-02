<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
<script src="/js/front.js"></script>
					<div id="articleSection" class="acItems">
						<c:forEach var="item" items="${courseList}" varStatus="status">
						<div class="item<c:if test="${item.savetype eq '1'}"> selected</c:if>">
							<a href="#none" class="acThumbImg" onClick="javascript:fnAccesViewClick('${item.courseid}');">
								<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}" />
								<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if><c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if><c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if><c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if><c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
								
								<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
								<c:set var="coursename" value="${item.realcoursename }" />
								<c:if test="${item.coursetype eq 'F'}">
									<c:set var="coursename" value="[${item.apname }] ${item.realcoursename }" />
								</c:if>
								<c:if test="${fn:length(coursename) > 33}">
									<c:set var="coursename" value="${fn:substring(coursename,0,31) }..." />
								</c:if>
								<span class="tit">${coursename}</span>
							</a>
							<div>
								<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D'}"><span class="menu">[${item.coursetypename}]</span> <span class="cate">${item.categoryname}</span></c:if>
								<c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D'}"><span class="menubox">${item.coursetypename}</span></c:if>
								
								<a href="#none" class="scLike <c:if test="${item.mylikecnt ne '0'}">on</c:if>" <c:if test="${not empty scrData.uid}">onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}','1');"</c:if>><span class="hide">좋아요</span><em id="likecntlab${item.courseid}">${item.likecnt}</em></a>
							</div>
						</div>
						</c:forEach>
					</div>
<script type="text/javascript">
	$(document).ready(function() {$(".img").find("img").load(function(){abnkorea_resize();}); });   // 이미지로드 완료시 호출.
</script>
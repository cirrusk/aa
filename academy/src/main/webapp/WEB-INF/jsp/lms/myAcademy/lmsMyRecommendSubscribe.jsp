<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
				<div id="result">${data.result}</div>
				<div id="categoryList_cnt"><c:if test="${categoryList eq null }">0</c:if><c:if test="${categoryList ne null }">${categoryList.size()}</c:if></div>
				<div id="searchtype5_cnt"><c:if test="${categoryDataList eq null }">0</c:if><c:if test="${categoryDataList ne null }">${categoryDataList.size()}</c:if></div>
				<div id="subscribeCate">
					<span class="hide">탭 메뉴</span>	
					<ul class="acContTab">
						<c:forEach var="item" items="${categoryList}" varStatus="status">
						<input type="hidden" id="mycategory_${item.categorytype}" name="mycategory" value="${item.categorytype}"/>
						<li id="myCategoryTab_${item.categorytype}" name="myCategoryTab" <c:if test="${data.categorytype eq item.categorytype }">class="on"</c:if>><a href="#none" onclick="javascript:fnSubscript('${item.categorytype}');">${item.categoryname}</a></li>
						</c:forEach>
					</ul>
				</div>
				<div id="acSlideView05">
					<c:forEach var="item" items="${categoryDataList}" varStatus="status">
						<div class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>">
							<a href="#none" class="acThumbImg" onClick="javascript:fnAccesViewClick('${item.courseid}');">
								<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
								<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
								<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
								<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
								<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
								<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
								<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
								<c:set var="coursename" value="${item.coursename }" />
								<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
								<span class="tit">${coursename}</span>
							</a>
							<div>
								<span class="<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D' }">menu</c:if><c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D' }">menubox</c:if>">[${item.coursetypename}]</span> <span class="cate">${item.categoryname}</span> 
								<a href="#none" class="scLike <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlabE${item.courseid}','');"><span class="hide">좋아요</span><em id="likecntlabE${item.courseid}">${item.likecnt}</em></a>
							</div>
						</div>
					</c:forEach>
					<c:if test="${categoryDataList eq null or categoryDataList.size() == 0 }">
						<div class="noItems">추천 콘텐츠가 없습니다.</div>
					</c:if>
				</div>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
				<div id="result">${result}</div>
				<div id="searchapseqArr">${searchapseqArr}</div>
				<div id="apList">
						<input type="checkbox" name="checkAll" id="checkAll"  onclick="allCheck(this)" value="Y"  <c:if test="${param.checkAll eq 'Y' or empty param.searchYn }">checked</c:if>/><label for="checkAll">전체</label>
					<c:forEach items="${apList }" var="data" varStatus="status">
						<input type="checkbox" name="searchapseq" id="check${status.count+1 }"  value="${data.apseq }"  onclick="searchGo();" /><label for="check${status.count+1 }">${data.apname }</label>
					</c:forEach>
				</div>
				<div id="courseList">
					<div class="monthlySchedule">
						<a href="#none" class="prev" onclick="changeMonth('prev');">이전달</a>
						<strong>${searchyear }년</strong><strong><fmt:formatNumber value="${searchmonth }" pattern="#"/>월</strong>
						<a href="#none" class="next" onclick="changeMonth('next');">다음달</a>
					</div>
					<table class="tblSchedule" >
						<caption>일정표</caption>
						<colgroup>
							<col width="70px" span="2" /><col width="auto" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">일</th><th scope="col">요일</th><th scope="col">교육명</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${monthList }" var="item2" varStatus="status">
							<tr class="<c:if test='${item2.nowthen ne "P" and (item2.weekname eq "토" or item2.weekname eq "일") }'> weekend</c:if><c:if test='${item2.nowthen eq "P" }'> lastday</c:if>">
								<td>${item2.num }</td>
								<td>${item2.weekname }</td>
								<td class="title">
									<c:forEach items="${courseList }" var="item" varStatus="status">
										<c:if test='${item.startdatestr eq item2.usedate }'>
											<c:if test='${item2.nowthen eq "P" }'>
												[${item.apname }] ${item.coursename } (${item.themename })<br>
											</c:if>
											<c:if test='${item2.nowthen eq "F" }'>
												<a href="#none" data-courseid="${item.courseid }" onclick="fnAccesViewClick('${item.courseid }', 'request');">[${item.apname }] ${item.coursename } (${item.themename })</a><br>
											</c:if>
										</c:if>
									</c:forEach>
								</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
					<p class="listWarning">※ 각 월별 해당 오프라인 교육일정 </p>
				</div>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
			<div id="toDayArea" class="acSubWrap">
				<c:forEach var="item" items="${courseList}" varStatus="status">
				<c:if test="${item.coursetype eq 'F'}">
				<dl class="eduSummary">
					<dt>
						<a href="#none" onclick="viewDetail('${item.coursetype }','${item.courseid }','${item.regularcourseid }')">
						<strong>
							[${item.apname}] ${item.coursename}
						</strong>
						<c:if test='${item.groupflag eq "Y" }'>
						<img src="/_ui/mobile/images/academy/amwaygo_flag_mob.png" alt="AmwayGo!" class="flag" />
						</c:if>
						<span class="btn">상세보기</span></a>
					</dt>
					<dd>
						<div><span class="tit">교육일</span>${item.startdatestr} ~ ${item.enddatestr2}</div>
						<div><span class="tit">교육종류</span>${item.coursetypename}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						<div>
							<span class="tit">좌석번호</span>
							<strong class="fcR"><c:if test='${not empty item.seatnumber }'>${item.seatnumber }</c:if><c:if test='${empty item.seatnumber }'>현장배정</c:if></strong>
						</div>
					</dd>
				</dl>
				</c:if>
				
				<c:if test="${item.coursetype eq 'L'}">
				<dl class="eduSummary">
					<dt>
						<a href="#none" onclick="viewDetail('${item.coursetype }','${item.courseid }','${item.regularcourseid }')">
						<strong>${item.liverealstr} ${item.coursename}</strong>
						<span class="category">${item.themename}</span>
						<c:if test='${item.groupflag eq "Y" }'> 
						<img src="/_ui/mobile/images/academy/amwaygo_flag_mob.png" alt="AmwayGo!" class="flag" />
						</c:if>
						<span class="btn">상세보기</span></a>
					</dt>
					<dd>
						<div><span class="tit">교육일</span>${item.startdatestr}</div>
						<div><span class="tit">교육종류</span>${item.coursetypename}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
					</dd>
				</dl>
				</c:if>
				
				<c:if test="${item.coursetype eq 'R'}">
				<dl class="eduSummary">
					<dt>
						<a href="#none" onclick="viewDetail('${item.coursetype }','${item.courseid }','${item.regularcourseid }')">
						<strong>${item.regularcoursename }</strong>
						<c:if test='${item.regulargroupflag eq "Y" }'> 
						<img src="/_ui/mobile/images/academy/amwaygo_flag_mob.png" alt="AmwayGo!" class="flag" />
						</c:if>
						<span class="btn">상세보기</span></a>
					</dt>
					<dd>
						<div><span class="tit">교육일</span>${item.coursestartdatestr} ~ ${item.courseenddatestr}</div>
						<div><span class="tit">교육종류</span>${item.coursetypename}</div>
						<div><span class="tit">나의현황</span>${item.regularstudystatusname}</div>
						
						<c:if test="${item.realcoursetype eq 'O' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">교육일</span>${item.startdatestr} ~ ${item.enddatestr}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						</c:if>

						<c:if test="${item.realcoursetype eq 'F' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">일시 및 <br/>장소</span>${item.startdatestr} ~ ${item.enddatestr2}<br/>${item.apname}(${item.roomname})</div>
						<div><span class="tit">좌석번호</span>
							<strong class="fcR"><c:if test='${not empty item.seatnumber }'>${item.seatnumber }</c:if><c:if test='${empty item.seatnumber }'>현장배정</c:if></strong>
						</div>
						</c:if>
						
						<c:if test="${item.realcoursetype eq 'L' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.liverealstr } ${item.coursename }</div>
						<div><span class="tit">교육일</span>${item.startdatestr}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						</c:if>
						
						<c:if test="${item.realcoursetype eq 'D' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">교육일</span>${item.startdatestr}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						</c:if>
						
						<c:if test="${item.realcoursetype eq 'T' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">시험일</span>${item.startdatestr} ~ ${item.enddatestr}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						</c:if>
						
						<c:if test="${item.realcoursetype eq 'V' }">
						<div class="eduSubItem">
							<span>[<c:if test="${item.unitmustflag eq 'Y'}">필수</c:if><c:if test="${item.unitmustflag ne 'Y'}">선택</c:if>]</span> ${item.stepseq}회차<em>|</em>${item.realcoursetypename }</div>
						<div><span class="tit">교육명</span>${item.coursename }</div>
						<div><span class="tit">설문일</span>${item.startdatestr} ~ ${item.enddatestr}</div>
						<div><span class="tit">나의현황</span>${item.studystatusname}</div>
						</c:if>
					</dd>
				</dl>
				</c:if>
				
				</c:forEach>
				
				<p class="listWarning">※  캘린더 보기에서는 완료 및 진행중인 교육만 확인 하실 수 있습니다.</p>
			</div>					

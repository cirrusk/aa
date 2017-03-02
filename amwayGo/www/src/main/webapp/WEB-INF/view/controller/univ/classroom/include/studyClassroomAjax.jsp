<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>		
<%-- 공통코드 --%>
<c:set var="CD_ATTEND_TYPE_001"          value="${aoffn:code('CD.ATTEND_TYPE.001')}"/>
<c:set var="CD_ATTEND_TYPE_002"          value="${aoffn:code('CD.ATTEND_TYPE.002')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_LECTURE" value="${aoffn:code('CD.COURSE_WEEK_TYPE.LECTURE')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>
	
<c:forEach var="row" items="${itemList}" varStatus="i"><!-- 주차 리스트 -->
<div class="online-lecture"><!--online-lecture-->	
	<dl class="lecture-style">
		<dt>
			<p class="week-num"><c:out value="${row.element.sortOrder}"/> <spring:message code="글:과정:주차"/></p>
			<div class="lecture-title al">
				<p class="lecture-name">
					<c:choose>
						<c:when test="${row.element.courseWeekTypeCd eq CD_COURSE_WEEK_TYPE_LECTURE}"><!-- 학습콘텐츠 -->
							<c:if test="${fn:length(row.itemResultList) eq 0}">
								<spring:message code="글:과정:준비중입니다"/>
							</c:if>
							<c:if test="${fn:length(row.itemResultList) ne 0}">
								<c:out value="${row.element.activeElementTitle}"/>
							</c:if>
						</c:when>
						<c:otherwise><!-- 학습콘텐츠가 아닌 경우 -->
							<c:if test="${empty row.element.activeElementTitle}">
								<spring:message code="글:과정:준비중입니다"/>
							</c:if>
							<c:if test="${not empty row.element.activeElementTitle}">
								<c:out value="${row.element.activeElementTitle}"/>
							</c:if>
						</c:otherwise>
					</c:choose>
				</p>
				<span>(<aof:date datetime="${row.element.startDtime}" pattern="yyyy.MM.dd"/>~<aof:date datetime="${row.element.endDtime}" pattern="yyyy.MM.dd"/>)</span>
			</div>
		</dt>
		<dd>
			<c:if test="${row.element.courseWeekTypeCd eq CD_COURSE_WEEK_TYPE_LECTURE}">
			<c:forEach var="rowSub" items="${row.itemResultList}" varStatus="j"><!-- 강 리스트 -->
				<ul <c:if test="${fn:length(row.itemResultList) eq j.count}">class="last"</c:if>>
					<li class="time-num"><span class="btnGray"><c:out value="${rowSub.item.sortOrder+1}"/><spring:message code="글:과정:교시"/></span></li>
					<li class="lecture-info">
							<p class="lecture-info-title"><c:out value="${rowSub.item.title}"/> </p>
							<p>
								<span><spring:message code="글:과정:학습횟수"/> <c:out value=" ${rowSub.learnerDatamodel.attempt}"/><spring:message code="글:과정:회"/></span>
								<span> 
									<spring:message code="글:과정:학습시간"/>
									<span>
									<c:choose>
										<c:when test="${0 < rowSub.learnerDatamodel.sessionTime}">
											<c:set var="hh" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime / (60 * 60 * 1000))}"/>
											<c:set var="mm" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime % (60 * 60 * 1000) / (60 * 1000))}"/>
											<c:set var="ss" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime % (60 * 1000) / 1000 )}"/>
											<c:choose>
												<c:when test="${0 == hh}"></c:when>
												<c:when test="${10 <= hh}">
													<c:out value="${hh}"/><spring:message code="글:시"/>
												</c:when>
												<c:otherwise>
													0<c:out value="${hh}"/><spring:message code="글:시"/>
												</c:otherwise>
											</c:choose>
											<c:choose>
												<c:when test="${10 <= mm}">
													<c:if test="${hh != 0}">
														<c:out value=" ${mm}"/><spring:message code="글:분"/>
													</c:if>
													<c:if test="${hh == 0}">
														<c:out value="${mm}"/><spring:message code="글:분"/>
													</c:if>
												</c:when>
												<c:otherwise>
													0<c:out value="${mm}"/><spring:message code="글:분"/>
												</c:otherwise>
											</c:choose>
											<c:choose>
												<c:when test="${10 <= ss}">
													<c:out value=" ${ss}"/><spring:message code="글:초"/>
												</c:when>
												<c:otherwise>
													0<c:out value="${ss}"/><spring:message code="글:초"/>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											00<spring:message code="글:분"/> 00<spring:message code="글:초"/>
										</c:otherwise>
									</c:choose>
								</span>
								<%-- <span> 기능 미개발로 잠시 주석
									<c:out value="${row.element.sortOrder}"/>-<c:out value="${rowSub.item.sortOrder+1}"/> 
									<spring:message code="글:과정:교시학습보조자료"/> 
									<a href="#"><aof:img src="icon/down_icon.gif" alt="글:과정:학습보조자료다운로드"/></a>
								</span> --%>
								
								<c:if test="${!empty rowSub.activeItem.attachList}">
									<span> 
										<c:forEach var="rowSub2" items="${rowSub.activeItem.attachList}" varStatus="i">
											<c:out value="${row.element.sortOrder}"/>-<c:out value="${rowSub.item.sortOrder+1} "/> 
											<spring:message code="글:과정:교시학습보조자료"/> 
											<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(rowSub2.attachSeq, pageContext.request)}"/>')"><aof:img src="icon/down_icon.gif" alt="글:과정:학습보조자료다운로드"/></a>
										</c:forEach>
									</span>
								</c:if>
							</p>
					</li>
					<li class="progress">
						<p><spring:message code="글:과정:진도율"/> <span <c:if test="${(rowSub.learnerDatamodel.progressMeasure * 100) == 100}">class="full"</c:if>> <aof:number value="${rowSub.learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>%</span></p>
						<p>
							<spring:message code="글:과정:출결"/> 
							<c:if test="${appToday > row.element.endDtime}"> 
								<c:choose>
									<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_001}">
										<aof:img src="icon/attend_icon.png" alt="글:과정:출석완료"/>
									</c:when>
									<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_002}">
										<aof:img src="icon/attend_not_icon.png" alt="글:과정:결석"/>
									</c:when>
									<c:otherwise>
										<aof:img src="icon/attend_late_icon.png" alt="글:과정:지각"/>
									</c:otherwise>
								</c:choose>
							</c:if>
							<c:if test="${appToday <= row.element.endDtime}">
								<c:choose>
									<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_001}">
										<aof:img src="icon/attend_icon.png" alt="글:과정:출석완료"/>
									</c:when>
									<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_002}">
										<span> [<spring:message code="글:과정:수강전"/>]</span>
									</c:when>
									<c:otherwise>
										<span> [<spring:message code="글:과정:수강중"/>]</span>
									</c:otherwise>
								</c:choose>
							</c:if>
						</p>
					</li>
					<li class="stydy">
						<c:if test="${appToday > row.element.startDtime}">
							<c:if test="${appToday <= row.element.endDtime}">
								<a href="javascript:void(0)" onclick="doLearning({
															'organizationSeq' : '<c:out value="${rowSub.item.organizationSeq}"/>',
															'itemSeq' : '<c:out value="${rowSub.item.itemSeq}"/>',
															'itemIdentifier' : '<c:out value="${rowSub.item.identifier}"/>',
															'height' : '<c:out value="${rowSub.organization.height}"/>',
															'width' : '<c:out value="${rowSub.organization.width}"/>',
															'completionStatus' : '<c:out value="${rowSub.learnerDatamodel.completionStatus}"/>',
															'courseId' : '<c:out value="${row.element.courseActiveSeq}"/>'
														});"><spring:message code="버튼:과정:학습하기"/></a>
							</c:if>
							<c:if test="${appToday > row.element.endDtime}">
								<a href="javascript:void(0)" onclick="doLearning({
															'organizationSeq' : '<c:out value="${rowSub.item.organizationSeq}"/>',
															'itemSeq' : '<c:out value="${rowSub.item.itemSeq}"/>',
															'itemIdentifier' : '<c:out value="${rowSub.item.identifier}"/>',
															'height' : '<c:out value="${rowSub.organization.height}"/>',
															'width' : '<c:out value="${rowSub.organization.width}"/>',
															'completionStatus' : '<c:out value="${rowSub.learnerDatamodel.completionStatus}"/>',
															'courseId' : 'resume'
														});"><spring:message code="버튼:과정:복습하기"/></a>
							</c:if>
						</c:if>
						<c:if test="${appToday <= row.element.startDtime}">
							<a href="javascript:void(0)" onclick="doNotStudyAlert()"><spring:message code="버튼:과정:학습하기"/></a>
						</c:if>
					</li>
				</ul>
			</c:forEach>
			</c:if>
		</dd>
	</dl>
</div>
</c:forEach>

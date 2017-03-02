<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

			<div id="info">
				<input type="hidden" id="uidList" value="${uidlist }"/> 
				<input type="hidden" id="stepcourseid"  name="stepcourseid" value="${param.stepcourseid }">
				<input type="hidden" id="uid"  name="uid" value="${info.uid }"/>
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="22%"  />
						<col width="28%" />
						<col width="22%" />
						<col width="28%" />
					</colgroup>
					<tr>
						<th>ABO번호</th>
						<td>${info.uid }</td>
						<th>이름</th>
						<td>${info.name }</td>
					</tr>
				</table>
			</div>
				
			<div id="surveyAnswer">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="15%" />
						<col width="45%"  />
						<col width="30%" />
						<col width="10%" />
					</colgroup>
					<tr>
						<th>NO</th>
						<th>질문</th>
						<th>답변</th>
						<th>척도점수</th>
					</tr>
					<c:forEach items="${responseList1 }" var="responseList1">
						<tr>
							<td>${responseList1.surveyseq }</td>
							<td>${responseList1.surveyname }</td>
							<c:if test="${responseList1.surveytype == 1}">
								<td>
									${responseList1.objectresponse } ) ${responseList1.samplename }
									<c:if test="${not empty responseList1.opinioncontent }">
										<br/>${responseList1.opinioncontent }
									</c:if>
								</td>
								<td>${responseList1.samplevalue }</td>
							</c:if>
							<c:if test="${responseList1.surveytype == 2}">
								<td colspan="2">
										<table id="tblSearch"  width="100%" border="0" cellspacing="0" cellpadding="0">
											<colgroup>
												<col width="76%" />
												<col width="24%" />
											</colgroup>
											<c:forEach items="${responseList2 }" var="responseList2">
													<c:if test="${responseList2.surveyseq eq responseList1.surveyseq }">
														<tr>
															<td>${responseList2.objectresponse} ) ${responseList2.samplename }</td>
															<td>${responseList2.samplevalue }</td>
														</tr>
													</c:if>
											</c:forEach>
										</table>
								</td>
							</c:if>
							<c:if test="${responseList1.surveytype == 3 or responseList1.surveytype ==4}">
								<td>
									${responseList1.subjectresponse }
								</td>
								<td> </td>
							</c:if>
						</tr>
					</c:forEach>
				</table>
			</div>
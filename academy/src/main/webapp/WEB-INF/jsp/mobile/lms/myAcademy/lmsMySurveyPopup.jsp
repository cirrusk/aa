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
				<div id="status">${data.surveystatus}</div>
				<div id="surveyLayerPopup" class="pbLayerContent">
					<dl class="surveyInfo">
						<dt>${data.surveyname}</dt>
						<dd>대상 : ${sessionName}</dd>
						<dd>기간 : ${data.startdate} ~ ${data.enddate}
					</dl>
					
					<input type="hidden" id="stepcourseid" name="stepcourseid" value="${param.stepcourseid}"/>
					<input type="hidden" id="courseid" name="courseid" value="${param.courseid}"/>
					<input type="hidden" id="stepseq" name="stepseq" value="${param.stepseq}"/>
					<input type="hidden" id="surveycount" name="surveycount" value="${data.surveycount}"/>
					<input type="hidden" id="submitflag" name="submitflag" value="${data.submitflag}"/>
					
					<c:forEach var="dataList" items="${dataList}" varStatus="idx">
					<input type="hidden" id="surveyseq_${dataList.surveyseq}" name="surveyseq" value="${dataList.surveyseq}"/>
					<input type="hidden" id="surveytype_${dataList.surveyseq}" name="surveytype" value="${dataList.surveytype}"/>
					<input type="hidden" id="samplecount_${dataList.surveyseq}" name="samplecount" value="${dataList.samplecount}"/>
					
					<dl class="surveyQuest" <c:if test="${data.submitflag eq 'Y' }">style="display:none"</c:if>>
						<c:if test="${dataList.surveytype eq '1'}">
						<dt>${dataList.surveyname}</dt>
						<dd>
							<div class="radioBoxWrap">	
								<input type="hidden" id="response_${dataList.surveyseq}" name="response" />
								<c:forEach var="sampleList" items="${dataList.sampleList}" varStatus="idx2">
								<span><input type="radio" id="sampleseq_${dataList.surveyseq}_${sampleList.sampleseq}" name="sampleseq_${dataList.surveyseq}" value="${sampleList.sampleseq}"/>
								<label for="sampleseq_${dataList.surveyseq}_${sampleList.sampleseq}">${sampleList.samplename}</label>
								<c:if test="${sampleList.directyn eq 'Y'}">
								&nbsp;<input type="text" id="opinioncontent_${dataList.surveyseq}_${sampleList.sampleseq}" name="opinioncontent_${dataList.surveyseq}" style="width:100px;" maxlength="50" />
								</c:if>
								<c:if test="${sampleList.directyn ne 'Y'}">
								&nbsp;<input type="hidden" id="opinioncontent_${dataList.surveyseq}_${sampleList.sampleseq}" name="opinioncontent_${dataList.surveyseq}" value="" />
								</c:if>
								</span>
								<input type="hidden" id="directyn_${dataList.surveyseq}_${sampleList.sampleseq}" name="directyn_${dataList.surveyseq}" value="${sampleList.directyn}"/>
								</c:forEach>
							</div>
						</dd>		
						</c:if>
							
						<c:if test="${dataList.surveytype eq '2'}">
						<dt>${dataList.surveyname}</dt>
						<dd>
							<div class="checkBoxWrap">
								<input type="hidden" id="response_${dataList.surveyseq}" name="response" />
								<c:forEach var="sampleList" items="${dataList.sampleList}" varStatus="idx2">
								<span><input type="checkbox" id="sampleseq_${dataList.surveyseq}_${sampleList.sampleseq}" name="sampleseq_${dataList.surveyseq}" value="${sampleList.sampleseq}"/>
								<label for="sampleseq_${dataList.surveyseq}_${sampleList.sampleseq}">${sampleList.samplename}</label>
								<c:if test="${sampleList.directyn eq 'Y'}">
								&nbsp;<input type="text" id="opinioncontent_${dataList.surveyseq}_${sampleList.sampleseq}" name="opinioncontent_${dataList.surveyseq}" style="width:100px;" maxlength="50" />
								</c:if>
								<c:if test="${sampleList.directyn ne 'Y'}">
								&nbsp;<input type="hidden" id="opinioncontent_${dataList.surveyseq}_${sampleList.sampleseq}" name="opinioncontent_${dataList.surveyseq}" value="" />
								</c:if>
								</span>
								<input type="hidden" id="directyn_${dataList.surveyseq}_${sampleList.sampleseq}" name="directyn_${dataList.surveyseq}" value="${sampleList.directyn}"/>
								</c:forEach>
							</div>
						</dd>		
						</c:if>
							
						<c:if test="${dataList.surveytype eq '3'}">
						<dt>${dataList.surveyname}</dt>
						<dd class="textInput">
							<input type="text" id="response_${dataList.surveyseq}" name="response" title="단답입력" maxlength="50" style="width:99%" />
						</dd>
						</c:if>
						
						<c:if test="${dataList.surveytype eq '4'}">
						<dt>${dataList.surveyname}</dt>
						<dd class="textInput">
							<textarea id="response_${dataList.surveyseq}" name="response" onkeyup="javascript:fnCheckLength('${dataList.surveyseq}',200);" onkeydown="javascript:fnCheckLength('${dataList.surveyseq}',200);" rows="7" cols="50" title="주관식 질문"></textarea>
							<p class="textR" id="responseCheck_${dataList.surveyseq}">0/200자</p>
						</dd>
						</c:if>
						
					</dl>
					</c:forEach>
					
					<div id="surveyButtonArea" class="btnWrap aNumb2" <c:if test="${data.submitflag eq 'Y'}">style="display:none"</c:if>>
						<span><a href="#none" id="submitButton" class="btnBasicGNL" onclick="javascript:fnSurveySubmit();">설문제출</a></span>
						<span><a href="#none" id="cancelButton" class="btnBasicGL" onclick="javascript:fnSurveyCancel();">취소</a></span>
					</div>
					
					<dl id="surveyCommitArea" <c:if test="${data.submitflag ne 'Y'}">style="display:none"</c:if>>
						<p class="mgtM"></p>
						<p style="text-align:center;"><strong>수고하셨습니다.</strong></p>
						<p class="mgtM"></p>
						<p style="text-align:center;">설문에 참여해 주셔서 감사합니다.</p>
						<div class="btnWrap mgtL">
							<a href="#none" class="btnBasicGNL" onclick="javascript:fnSurveyClose();">확인</a>
						</div>
					</dl>
				</div>
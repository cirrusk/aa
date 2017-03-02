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
				<div id="totalCount">${categoryDataList.size()}</div>
				<div id="categoryList">
					<c:forEach var="item" items="${categoryList}" varStatus="status">${item.categorytype},</c:forEach>
				</div>
				<div id="categoryMap" class="acSubWrap">
					<c:if test="${categoryDataList ne null and categoryDataList.size() > 0 }">
						<section id="articleSection_5" class="acItems">
							<c:forEach var="item" items="${categoryDataList}" varStatus="status">
							<article class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>">
								<a href="#none" onClick="javascript:fnAccesViewClick('${item.courseid}');">
									<c:set var="coursename" value="${item.coursename }" />
									<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
									<strong class="tit">${coursename}</strong>
									<span class="category"><span class="<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D' }">cate</c:if><c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D' }">catebox</c:if>">[${item.coursetypename}]</span> ${item.categoryname}</span>
									<span class="img">
										<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  style="width: 100%; height: auto;" />
										<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
										<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
										<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
										<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
										<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
										<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
									</span>
								</a>
								<div class="snsZone">
									<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlabF${item.courseid}','');"><span class="hide">좋아요</span></a>
									<em id="likecntlabF${item.courseid}">${item.likecnt}</em>
									<a href="#none" class="share" <c:if test="${item.coursetype eq 'O'}">style="display:none"</c:if> data-url="${data.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${data.httpDomain }/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
									<a href="#none" id="saveitemlabF${item.courseid}" class="save<c:if test="${item.depositcnt ne '0'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlabF${item.courseid}');"><span class="hide">보관함</span></a>
									<div class="detailSns">
										<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
										<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
										<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
										<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
										<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
									</div>
								</div>
							</article>
							</c:forEach>
						</section>
						<c:if test="${categoryDataList ne null and categoryDataList.size() eq 20}">
						<a href="#none" id="more20_5" class="listMore" onclick="javascript:fnMore20('5');"><span>20개 더보기</span></a>
						</c:if>
					</c:if>
					<c:if test="${categoryDataList.size() > 0  }">
						<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
					</c:if>
					<c:if test="${categoryDataList eq null or categoryDataList.size() == 0 }">
						<article class="item">
							<div class="nodata">
								<c:choose>
									<c:when test="${categoryList eq null or categoryList.size() == 0 }">
										<c:choose>
											<c:when test="${empty data.categorytype}">
												구독 카테고리가 없습니다.<br/><strong>카테고리 구독설정을 해주세요.</strong>
											</c:when>	
											<c:otherwise>
												추천 콘텐츠가 없습니다.
											</c:otherwise>
										</c:choose>	
									</c:when>	
									<c:otherwise>
										추천 콘텐츠가 없습니다.
									</c:otherwise>
								</c:choose>
							</div>
						</article>
						</div>
					</c:if>
				</div>
<script type="text/javascript">
	$(document).ready(function() {$(".img").find("img").load(function(){abnkorea_resize();}); });   // 이미지로드 완료시 호출.
</script>				
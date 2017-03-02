<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<script>
goSelectedCourse = function(applySeq) {
	forClassroom = null;
	forClassroom = $.action();
	forClassroom.config.formId = "commonClassroom";
	forClassroom.config.url    = "<c:url value="/usr/classroom/main.do"/>";
	
	var $form = jQuery("#" + forClassroom.config.formId);
	$form.find(":input[name='courseApplySeq']").val(applySeq);
	
	// 상세화면 실행
	forClassroom.run();
};
</script>

<form name="commonClassroom" id="commonClassroom" method="post" onsubmit="return false;">
	<input type="hidden" name="currentMenuId" value="<c:out value="${currentMenuId}"/>"/>
	<input type="hidden" name="courseApplySeq"/>
</form>	

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="currentMenuId" value="${param['currentMenuId']}" scope="request"/>
<c:choose>
<c:when test="${param['location'] eq 'main'}">
	<div id="underMenuInfo" style="display: none;"></div> 
    <div class="visualmenu">
        <ul>
            <li class="visualmenu-bg01">
                <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/mypage/course/apply/list.do"/>','001001001','','');" 
                   title="<spring:message code="메뉴:마이페이지"/>"><spring:message code="메뉴:마이페이지"/></a>
            </li>
            <li class="visualmenu-bg02">
                <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/univ/course/active/list.do"/>','002001','','');" 
                   title="<spring:message code="메뉴:개설과목"/>"><spring:message code="메뉴:개설과목"/></a>
            </li>
            <li class="visualmenu-bg03">
                <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/system/bbs/notice/list.do"/>','003001','','');" 
                   title="<spring:message code="메뉴:학습지원센터"/>"><spring:message code="메뉴:학습지원센터"/></a>
            </li>
            <li class="visualmenu-bg04">
                <a href="javascript:void(0)" onclick="alert('데모에서 지원하지 않는 메뉴입니다.');"
                   title="<spring:message code="메뉴:커뮤니티"/>"><spring:message code="메뉴:커뮤니티"/></a>
            </li>
            <li class="visualmenu-bg05">
                <a href="javascript:void(0)" onclick="alert('데모에서 지원하지 않는 메뉴입니다.');"
                   title="<spring:message code="메뉴:학사서비스"/>"><spring:message code="메뉴:학사서비스"/></a>
            </li>
        </ul>
    </div>
</c:when>
<c:when test="${param['location'] eq 'top'}">
    <ul id="gnb">
        <c:if test="${!empty ssMemberSeq}">
            <li class="first">
                <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/mypage/course/apply/list.do"/>','001001001','','');"
                   title="<spring:message code="메뉴:마이페이지"/>"><spring:message code="메뉴:마이페이지"/></a>
            </li>
        </c:if>
        <li>
            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/univ/course/active/list.do"/>','002001','','');"
               title="<spring:message code="메뉴:개설과목"/>"><spring:message code="메뉴:개설과목"/></a>
        </li>
        <li>
            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/system/bbs/notice/list.do"/>','003001','','');"
               title="<spring:message code="메뉴:학습지원센터"/>"><spring:message code="메뉴:학습지원센터"/></a>
        </li>
        <li>
            <a href="javascript:void(0)" onclick="alert('데모에서 지원하지 않는 메뉴입니다.');"
               title="<spring:message code="메뉴:커뮤니티"/>"><spring:message code="메뉴:커뮤니티"/></a>
        </li>
        <li>
            <a href="javascript:void(0)"  onclick="alert('데모에서 지원하지 않는 메뉴입니다.');"
               title="<spring:message code="메뉴:학사서비스"/>"><spring:message code="메뉴:학사서비스"/></a>
        </li>
    </ul>
</c:when>
<c:when test="${param['location'] eq 'left'}">
    <div class="lnb-area"><!--lnb-area-->
        <div class="user-area-wrap"><!--user-area-->
            <div class="user-area">
                <c:if test="${!empty ssMemberName}">
                    <h2><strong><spring:message code="글:로그인:X님안녕하세요" arguments="${ssMemberName}"/></strong></h2>
                    <dl>
                        <dt><spring:message code="필드:멤버:회원구분"/></dt>
                        <dd><strong><aof:code type="print" codeGroup="MEMBER_EMP_TYPE" selected="${ssMemberEmsTypeCd}" /></strong> (<aof:code type="print" codeGroup="STUDENT_STATUS" selected="${ssStudentStatusCd}" />)</dd>
                        <dt><spring:message code="필드:쪽지:새로운쪽지"/></dt>
                        <dd><a href="javascript:void(0)" onclick="FN.doGoMenu('/usr/memo/list.do','001004','','');"><strong><span id="unreadMessage">0</span></strong> <spring:message code="글:쪽지:통"/></a></dd>
                        <dt class="h"><spring:message code="필드:멤버:학년"/>/<spring:message code="필드:멤버:학기"/></dt>
                        <div id="underMenuInfo"></div>
<!--                         <dt>Server Time</dt> -->
                        <!-- <dd>2014/02/01 TUE 10:23:16</dd> -->
<%--                         <dd><aof:date datetime="${appToday}" pattern="yyyy/MM/dd HH:mm"/></dd> --%>
                    </dl>
                    <div class="btn"><a href="<c:url value="/security/logout"/>"><spring:message code="버튼:로그아웃"/></a></div>
                </c:if>
            </div>
        </div><!--//user-area-->
        
        <div class="lnb"><!--lnb-->
            <c:choose>
                <c:when test="${fn:startsWith(currentMenuId, '001') eq true}">
                    <h2 class="lnb-title"><spring:message code="메뉴:마이페이지"/></h2>
                    <ul>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '001001') eq true ? 'on' : ''}"/>">
                            <spring:message code="메뉴:마이페이지:학위과정"/>
                            <ul>
                                <li class="<c:out value="${fn:startsWith(currentMenuId, '001001001') eq true ? 'on' : ''}"/>">
                                    <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/mypage/course/apply/list.do"/>','001001001','','');"
                                       title=""><spring:message code="메뉴:마이페이지:학위과정:수강과목"/></a>
                                </li>
                                <li class="<c:out value="${fn:startsWith(currentMenuId, '001001002') eq true ? 'on' : ''}"/>">
                                    <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/mypage/course/apply/review/list.do"/>','001001002','','');"
                                       title=""><spring:message code="메뉴:마이페이지:학위과정:복습과목"/></a>
                                </li>
                            </ul>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '001002') eq true ? 'on' : ''}"/>">
                            <spring:message code="메뉴:마이페이지:비학위과정"/>
                            <ul>
                                <li class="<c:out value="${fn:startsWith(currentMenuId, '001002001') eq true ? 'on' : ''}"/>">
                                    <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/mypage/course/apply/non/list.do"/>','001002001','','');"
                                       title="<spring:message code="메뉴:마이페이지:비학위과정:수강과목"/>"><spring:message code="메뉴:마이페이지:비학위과정:수강과목"/></a>
                                </li>
                                <li class="<c:out value="${fn:startsWith(currentMenuId, '001002002') eq true ? 'on' : ''}"/>">
                                    <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/mypage/course/apply/non/review/list.do"/>','001002002','','');"
                                       title="<spring:message code="메뉴:마이페이지:비학위과정:복습과목"/>"><spring:message code="메뉴:마이페이지:비학위과정:복습과목"/></a>
                                </li>
                            </ul>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '001007') eq true ? 'on' : ''}"/>">
                            <spring:message code="메뉴:마이페이지:MOOC"/>
                            <ul>
                                <li class="<c:out value="${fn:startsWith(currentMenuId, '001007001') eq true ? 'on' : ''}"/>">
                                    <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/mypage/course/apply/mooc/list.do"/>','001007001','','');"
                                       title="<spring:message code="메뉴:마이페이지:MOOC:수강과목"/>"><spring:message code="메뉴:마이페이지:MOOC:수강과목"/></a>
                                </li>
                                <li class="<c:out value="${fn:startsWith(currentMenuId, '001007002') eq true ? 'on' : ''}"/>">
                                    <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/mypage/course/apply/mooc/review/list.do"/>','001007002','','');"
                                       title="<spring:message code="메뉴:마이페이지:MOOC:복습과목"/>"><spring:message code="메뉴:마이페이지:MOOC:복습과목"/></a>
                                </li>
                            </ul>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '001003') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/schedule.do"/>','001003','','');"
                               title="<spring:message code="메뉴:마이페이지:일정관리"/>"><spring:message code="메뉴:마이페이지:일정관리"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '001004') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/memo/list.do"/>','001004','','');"
                               title="<spring:message code="메뉴:마이페이지:쪽지함"/>"><spring:message code="메뉴:마이페이지:쪽지함"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '001005') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/memo/address/group/list.do"/>','001005','','');"
                               title="<spring:message code="메뉴:마이페이지:주소록"/>"><spring:message code="메뉴:마이페이지:주소록"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '001006') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)"
								onclick="FN.doGoMenu('<c:url value="/usr/member/edit.do"/>','001006','','');"
								title="<spring:message code="메뉴:마이페이지:개인정보조회"/>"><spring:message
										code="메뉴:마이페이지:개인정보조회" /></a>
							</li>
                    </ul>
                </c:when>
                <c:when test="${fn:startsWith(currentMenuId, '002') eq true}">
                    <h2 class="lnb-title"><spring:message code="메뉴:개설과목"/></h2>
                    <ul>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '002001') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/univ/course/active/list.do"/>','002001','','');"
                               title="<spring:message code="메뉴:개설과목:학위과정"/>"><spring:message code="메뉴:개설과목:학위과정"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '002002') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/univ/course/active/non/list.do"/>','002002','','');"
                               title="<spring:message code="메뉴:개설과목:비학위과정"/>"><spring:message code="메뉴:개설과목:비학위과정"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '002003') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/univ/course/active/mooc/list.do"/>','002003','','');"
                               title="<spring:message code="메뉴:개설과목:MOOC"/>"><spring:message code="메뉴:개설과목:MOOC"/></a>
                        </li>
                    </ul>
                </c:when>
                <c:when test="${fn:startsWith(currentMenuId, '003') eq true}">
                    <h2 class="lnb-title"><spring:message code="메뉴:학습지원센터"/></h2>
                    <ul>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '003001') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/system/bbs/notice/list.do"/>','003001','','');"
                               title="<spring:message code="메뉴:학습지원센터:공지사항"/>"><spring:message code="메뉴:학습지원센터:공지사항"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '003002') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/system/bbs/resource/list.do"/>','003002','','');"
                               title="<spring:message code="메뉴:학습지원센터:자료실"/>"><spring:message code="메뉴:학습지원센터:자료실"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '003003') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/system/bbs/faq/list.do"/>','003003','','');"
                               title="<spring:message code="메뉴:학습지원센터:FAQ"/>"><spring:message code="메뉴:학습지원센터:FAQ"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '003004') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/system/bbs/qna/list.do"/>','003004','','');"
                               title="<spring:message code="메뉴:학습지원센터:QNA"/>"><spring:message code="메뉴:학습지원센터:QNA"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '003005') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/system/bbs/free/list.do"/>','003005','','');"
                               title="<spring:message code="메뉴:학습지원센터:자유게시판"/>"><spring:message code="메뉴:학습지원센터:자유게시판"/></a>
                        </li>
                    </ul>
                </c:when>
                <c:when test="${fn:startsWith(currentMenuId, '005') eq true}">
                    <h2 class="lnb-title"><spring:message code="메뉴:학사서비스"/></h2>
                    <ul>
                    	<li class="<c:out value="${fn:startsWith(currentMenuId, '005001') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/school/frame/school.do?type=02"/>','005001','','');"
                               title="<spring:message code="메뉴:학사서비스:휴학신청"/>"><spring:message code="메뉴:학사서비스:휴학신청"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '005002') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/school/frame/school.do?type=01"/>','005002','','');"
                               title="<spring:message code="메뉴:학사서비스:수강신청"/>"><spring:message code="메뉴:학사서비스:수강신청"/></a>
                        </li>
                        <li class="<c:out value="${fn:startsWith(currentMenuId, '005003') eq true ? 'on' : ''}"/>">
                            <a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/usr/school/frame/school.do?type=03"/>','005003','','');"
                               title="<spring:message code="메뉴:학사서비스:복학신청"/>"><spring:message code="메뉴:학사서비스:복학신청"/></a>
                        </li>
                    </ul>
                </c:when>
            </c:choose>

        </div><!--//lnb-->
        
        <ul class="banner-menu"><!--banner-menu-->
            <li class="banner-menu01">
                변경된 출석점수 <br />
                <a href="javascript:void(0)" >산정방법안내</a>
            </li>
            <li class="banner-menu02">
                SCAU <br />
                <a href="javascript:void(0)">교수학습지원센터</a>
            </li>
            <li class="banner-menu03">
                강의노트구입하기 <br />
                <a href="javascript:void(0)">문의 : 02-558-5354</a>
            </li>
        </ul><!--//banner-menu-->
    </div>

</c:when>
</c:choose>
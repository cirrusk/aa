<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<html decorator="main">
<head>
<title></title>
<script type="text/javascript">
var forDetailBbs = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forDetailBbs = $.action();
	forDetailBbs.config.formId = "FormDetail";
	
};
/**
 * test
 */
 doDetailBbs = function(mapPKs) {
	UT.getById(forDetailBbs.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetailBbs.config.formId);
	if (mapPKs.bbsType == 'notice') {
		forDetailBbs.config.url    = "<c:out value="${appSystemDomain}"/><c:url value="/usr/system/bbs/notice/detail.do"/>";
	} else if (mapPKs.bbsType == 'faq') {
		forDetailBbs.config.url    = "<c:out value="${appSystemDomain}"/><c:url value="/usr/system/bbs/faq/detail.do"/>";
	} else if (mapPKs.bbsType == 'qna') {
		forDetailBbs.config.url    = "<c:out value="${appSystemDomain}"/><c:url value="/usr/system/bbs/qna/detail.do"/>";
	}
	
	
	forDetailBbs.run();
}; 
</script>
</head>

<body>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="bbsSeq" />
	<input type="hidden" name="currentMenuId"/>
</form>
    <div class="notice-area"><!--notice-area-->
        <div class="notice01 bbs"><!--notice01-->
            <h2>공지사항</h2>
            <ul>
                <c:forEach var="row" items="${noticeList.itemList}" varStatus="i">
                	<li>
                		<a href="#" onclick="doDetailBbs({bbsSeq : '<c:out value="${row.bbs.bbsSeq}"/>',currentMenuId : '003001',bbsType : 'notice'});"><c:out value="${row.bbs.bbsTitle}" /></a>
                	</li>
                </c:forEach>
            </ul>
            <div class="more"><a href="#" title="공지사항으로 이동" onclick="FN.doGoMenu('<c:url value="/usr/system/bbs/notice/list.do"/>','003001','','');">더보기</a></div>
        </div><!--//notice01-->

        <div class="notice02 bbs"><!--notice02-->
            <h2>FAQ</h2>
            <ul>
                <c:forEach var="row" items="${faqList.itemList}" varStatus="i">
                	<li>
                		<a href="#" onclick="doDetailBbs({bbsSeq : '<c:out value="${row.bbs.bbsSeq}"/>',currentMenuId : '003003',bbsType : 'faq'});"><c:out value="${row.bbs.bbsTitle}" /></a>
                	</li>
                </c:forEach>
            </ul>
            <div class="more"><a href="#" title="FAQ으로 이동" onclick="FN.doGoMenu('<c:url value="/usr/system/bbs/faq/list.do"/>','003003','','');">더보기</a></div>
        </div><!--//notice02-->
    
        <div class="notice03 bbs"><!--notice03-->
            <h2>Q&A</h2>
            <ul>
                <c:forEach var="row" items="${qnaList.itemList}" varStatus="i">
                	<li>
                		<a href="#" onclick="doDetailBbs({bbsSeq : '<c:out value="${row.bbs.bbsSeq}"/>',currentMenuId : '003004',bbsType : 'qna'});"><c:out value="${row.bbs.bbsTitle}" /></a>
                	</li>
                </c:forEach>
            </ul>
            <div class="more"><a href="#" title="QNA으로 이동" onclick="FN.doGoMenu('<c:url value="/usr/system/bbs/qna/list.do"/>','003004','','');">더보기</a></div>
        </div><!--notice03-->
    </div><!--notice-area-->
    
    <div class="content-bottom"><!--content-bottom-->
        <div class="memo"><!--memo-->
            <h3><span>간단메모</span> 꼭 저장버튼을 눌러주세요</h3>
            <ul>
                <li><a href="#"><aof:img src="main/memo_bt_01.gif" alt="저장" /></a></li>
                <li><a href="#"><aof:img src="main/memo_bt_02.gif" alt="취소" /></a></li>
            </ul>
            <div class="txt">
                <textarea title="간단메모 입력칸" rows="5" cols="30">간단한 메모를 입력해 주세요.</textarea>
            </div>
            <div class="date">마지막저장일자 <span>14-02-01 11:34</span></div>
        </div><!--//memo-->
        <!--banner-->
        <div class="banner"><a href="#" title="변경된 출석점수 산정방법 안내로 이동" onclick="alert('데모용 이미지 입니다.');"><aof:img src="main/ban_blue.gif" width="288" height="151" alt="변경된 출석점수 산정방법 안내" /></a></div>
        <!--//banner-->
        <ul class="iconmenu"><!--iconmenu-->
        <li class="iconmenu01"><a href="javascript:void(0);" title="수업주차시간표로 이동" onclick="alert('데모용 이미지 입니다.');">수업주차시간표</a></li>
        <li class="iconmenu02"><a href="javascript:void(0);" title="성적조회로 이동" onclick="alert('데모용 이미지 입니다.');">성적조회</a></li>
        <li class="iconmenu03"><a href="javascript:void(0);" title="필수프로그램으로 이동" onclick="alert('데모용 이미지 입니다.');">필수프로그램</a></li>
        <li class="iconmenu04"><a href="javascript:void(0);" title="개인정보관리로 이동" onclick="alert('데모용 이미지 입니다.');">개인정보관리로</a></li>
        </ul><!--//iconmenu-->
            
        <div class="time"><aof:date datetime="${appToday}" pattern="yyyy/MM/dd HH:mm"/></div>
            
    </div><!--//content-bottom-->
</body>
</html>
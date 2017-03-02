<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<!doctype html>
<!--[if IE 7]><html lang="ko" class="old ie7"><![endif]-->
<!--[if IE 8]><html lang="ko" class="old ie8"><![endif]-->
<!--[if IE 9]><html lang="ko" class="modern ie9"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="ko" class="modern">
<!--<![endif]--><head>
<meta charset="utf-8">
<title>수료증</title>
<script type="text/javascript">
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
};

/**
 * 출력
 */
doPrint = function() { 
	window.print();
};

/**
 * 닫기
 */
doClose = function() {
	$layer.dialog("close");
};
</script>
<!--[if lt IE 9]>
<script type="text/javascript" src="../../js/html5.js"></script>
<![endif]-->
<style type="text/css">
body{background-color:#fff; *word-break:keep-all; -ms-word-break:keep-all; word-break: keep-all;  /*단어별로 끊어줌.*/}
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,form,fieldset,p,button,input,img,a,strong{margin:0; padding:0}
img,fieldset,iframe{border:0 none;}
li{list-style:none;}
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td{	margin: 0;	outline: 0;	border: 0;	padding: 0;	font-size: 100%;	/*vertical-align: baseline;*/	background: transparent;}
table {width:100%; padding:0; border:0 none; border-collapse:collapse; table-layout:fixed; /*테이블수치고정*/}
table th, table td {margin:0; padding:0;  font-size:100%; color:#303030;}
img{vertical-align:middle;}

#document {min-width:800px;}
/* 프린트 안내문구 */
.print_del {clear:both; overflow:hidden; padding:10px;} 
.print_text{margin:15px 0 0 16px; font-size:14px; text-indent:-16px; } 
.print_text strong { color:#c3313c;}
.btnArea { overflow:hidden;}
.btnArea .btn_right { text-align:right;}
.btnArea .btn_right a {display:inline-block; padding:0px 10px; line-height:25px;text-decoration:none; color:#fff; font-size:12px;}
.btnArea .btn_right a:hover { text-decoration:underline;}
.btnArea .btn_right .btn01 { margin-right:5px; border:1px solid #333;  background:#666; }
.btnArea .btn_right .btn02 { border:1px solid #0d7f88; background:#44a4ac;}
/* 수료증, 수료증명서 */
.document_certificate .document_certificate_table {position:relative; background:url(http://web.4csoft.co.kr/common/images/admin/bg/logo_bg.png) no-repeat 50% 60%;  font-family:'궁서';}
.document_certificate .document_certificate_table p.number {position:absolute; top:40px; left:100px; font-size:14px; color:#303030;}
.document_certificate .document_certificate_table h1 { text-align:center; padding:140px 0 60px 0; font-size:45px; font-family:'궁서'; color:#303030;}
.document_certificate .document_certificate_table .top {width:100%; height:24px; background:url(http://web.4csoft.co.kr/common/images/admin/bg/top.gif) repeat-x 0 0;}
.document_certificate .document_certificate_table .bottom {width:100%; height:24px; background:url(http://web.4csoft.co.kr/common/images/admin/bg/bottom.gif) repeat-x 0 100%;}
.document_certificate .document_certificate_table .body_left{background:url(http://web.4csoft.co.kr/common/images/admin/bg/body_left.gif) repeat-y 0 0;}
.document_certificate .document_certificate_table .body_right {background:url(http://web.4csoft.co.kr/common/images/admin/bg/body_right.gif) repeat-y 100% 0;}
.document_certificate .document_certificate_table dl { overflow:hidden; width:600px; margin:60px 0 60px 160px;}
.document_certificate .document_certificate_table dl dt { float:left; width:180px; line-height:140%; font-weight:bold; margin-bottom:5px; font-size:24px; }
.document_certificate .document_certificate_table dl dd { float:left;width:350px; line-height:140%; margin-bottom:5px; text-indent:-12px;font-size:24px; }
.document_certificate .document_certificate_table p {padding:50px 0; text-align:center;  font-size:24px; line-height:140%; }
.document_certificate .document_certificate_table p.date {padding:40px 0 60px 0; text-align:center;}
 @media print{
	.print_del {display:none;}
  }
</style>
</head>

<body>

<div id="document"><!--전체영역-->
	<div class="print_del"> 	
		<p class="print_text"> 	
			<spring:message code="글:성적관리:인쇄안내" />	
		<div class="btnArea">
			<div class="btn_right">
				<a href="javascript:void(0);" onclick="doPrint();" class="btn01"><span><spring:message code="버튼:인쇄" /></span></a>
				<a href="javascript:void(0);" onclick="doClose();" class="btn02"><span><spring:message code="버튼:닫기" /></span></a>
			</div>
		</div> 
	</div> 
 <div class="document_certificate">
	<table class="document_certificate_table">
	 	<colgroup>
			<col style="width:52px;">
			<col style="auto">
			<col style="width:52px;">
		</colgroup>
		<tr>
			<td class="top_left"><aof:img src="bg/top_left.gif" alt="" /></td>
			<td class="top"></td>
			<td class="top_right"><aof:img src="bg/top_right.gif" alt="" /></td>
		</tr>
		<tr>
			<td class="body_left"></td>
			<td>
				<p class="number"><spring:message code="글:성적관리:제" /><span>1</span><spring:message code="글:성적관리:호" /></p>
				<h1><spring:message code="글:성적관리:수료증" /></h1>
				<dl>
					<dt><spring:message code="필드:성적관리:성명" /></dt>
					<dd>: <c:out value="${getDetailApply.member.memberName }" /></dd>
					<dt></dt>
					<dd></dd>
				</dl>
				<p>
					<spring:message code="글:성적관리:위사람은" /><c:out value="${getDetail.courseActive.courseActiveTitle }" /><spring:message code="글:성적관리:교육을" /><br/>
					(<aof:date datetime="${getDetail.courseActive.studyStartDate }" /> ~ <aof:date datetime="${getDetail.courseActive.studyStartDate }" />) 
					<spring:message code="글:성적관리:를이수하였으므로이에수료증을수여함" />
				</p>
				<c:set var="today"><aof:date datetime="${aoffn:today()}" pattern="yyyy년MM월dd일" /></c:set>			
				<p class="date"><span><c:out value="${today }" /></span></p>
				<p class="sign">포  씨  소  프  트 <aof:img src="bg/stemp.gif" alt="직인" /></p>
			</td>
			<td class="body_right"></td>
		</tr>
		
		<tr>
			<td class="bottom_left"><aof:img src="bg/bottom_left.gif" alt="" /></td>
			<td class="bottom"></td>
			<td class="bottom_right"><aof:img src="bg/bottom_right.gif" alt="" /></td>
		</tr>		
	</table>
	
</div><!--//전체영역-->
</body>
</html>

 
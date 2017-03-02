<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html decorator="learning">
<head>
<title></title>
<script type="text/javascript">
var SUB = {
		initPage : function() {
			// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
			SUB.doInitializeLocal();

		},
		/**
		 * 설정
		 */
		doInitializeLocal : function() {

		},
		/**
		 * 창 닫기
		 */
		doClose : function() {
			if ($layer != null) {
				$layer.dialog("close");
			}
		}
	};
</script>
</head>

<body>
	<div class="learning" style="height:400px;">
		<div class="pop-header">
			<h3><span class="pop-header-test"></span><c:out value="${detailCourseExamPaper.courseExamPaper.examPaperTitle}"/></h3>
			<a href="javascript:void(0)" onclick="SUB.doClose()" class="close"><aof:img src="common/pop_close.gif" alt="버튼:닫기" /></a>
		</div>
		
		<div class="section-contents">
			<div class="data scroller" style="width:725px; height:380px;">
				<table width="100%" class="tbl-detail" style="margin-bottom:10px;">
					<colgroup>
						<col style="width:80px" />
						<col style="width:auto" />
						<col style="width:80px" />
						<col style="width:auto" />
					</colgroup>
					<tbody>
						<tr>
							<th><spring:message code="필드:시험:시험제목" /></th>
							<td colspan="3"><c:out value="${detailCourseExamPaper.courseExamPaper.examPaperTitle}"/></td>
						</tr>
						<tr>
							<th><spring:message code="필드:시험:시험지설명" /></th>
							<td colspan="3"><c:out value="${detailCourseExamPaper.courseExamPaper.description}"/></td>
						</tr>
						<tr>
							<th><spring:message code="필드:시험:참조파일" /></th>
							<td colspan="3">
								<c:if test="${!empty detailCourseExamPaper.courseActiveExamPaperTarget.attachList}">
									<c:forEach var="rowSub" items="${detailCourseExamPaper.courseActiveExamPaperTarget.attachList}" varStatus="j">
										<div class="vspace"></div>
										<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(rowSub.attachSeq, pageContext.request)}"/>')"><c:out value="${rowSub.realName}"/>&nbsp;&nbsp;<aof:img src="icon/ico_file.gif"/></a>
									</c:forEach>
								</c:if>
							</td>
						</tr>
						<tr>
							<th><spring:message code="필드:시험:점수" /></th>
							<td>
								<aof:number value="${detailCourseExamPaper.courseActiveExamPaperTarget.takeScore}" pattern="##" />&nbsp;<spring:message code="글:시험:점"/>
							</td>
							<th><spring:message code="필드:시험:채점일" /></th>
							<td><aof:date datetime="${detailCourseExamPaper.courseApplyElement.scoreDtime}" /></td>
						</tr>
						<tr>
							<th><spring:message code="필드:시험:코멘트" /></th>
							<td colspan="3">
								<textarea name="comment" style="width: 600px;" readonly="readonly"><c:out value="${detailCourseExamPaper.courseActiveExamPaperTarget.comment}" /></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	
</body>
</html>
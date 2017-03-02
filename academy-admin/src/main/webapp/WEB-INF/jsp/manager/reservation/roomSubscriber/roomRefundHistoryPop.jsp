<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	

$(document).ready(function(){
	
});

</script>

<form id="baseClause" name="baseClause" method="POST">

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">환불 내역</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="15%" />
							<col width="40"  />
							<col width="10%" />
							<col width="40%" />
						</colgroup>
						<tr>
							<th>취소 구분</th>
							<td colspan="3">
								<c:out value="${roomRefundHistory.typename}"/>
							</td>
						</tr>
						
						<tr>
							<th>취소일시</th>
							<td colspan="3">
								<c:out value="${roomRefundHistory.canceldatetime}"/>
							</td>
						</tr>
						
						<tr>
							<th>환불방법</th>
							<td colspan="3">
								<c:out value="${roomRefundHistory.applytypevalue}%의 취소 수수료 제외후 환불"/>
							</td>
						</tr>
						
						
						<tr>
							<th>결제금액</th>
							<td colspan="3">
								<c:out value="${roomRefundHistory.paymentamount}"/>
							</td>
						</tr>
						
						
						<tr>
							<th>취소수수료</th>
							<td colspan="3">
								<c:out value="${roomRefundHistory.refundcharge}"/>
							</td>
						</tr>
						
						
						<tr>
							<th>환불금액</th>
							<td colspan="3">
								<c:out value="${roomRefundHistory.refundamount}"/>
							</td>
						</tr>
						
					
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>

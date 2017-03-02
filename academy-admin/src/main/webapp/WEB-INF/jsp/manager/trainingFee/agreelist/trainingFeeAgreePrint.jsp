<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">	

$(document).ready(function(){

});

function agreePrint(){
	Pwin = window.open("","","width=790,height=500,scrollbars=1");
//  	document.getElementById("etc").style.display = "none";
//  	document.getElementById("hidden").style.display = "none";
	wdata="<HTML>";
	wdata+="<link rel='stylesheet' type='text/css' href='/static/axisj/ui/arongi/AXLayout.css' />";
	wdata+="<link rel='stylesheet' type='text/css' href='/static/axisj/ui/arongi/AXFrameLayout.css' />";
	
	wdata="<head></head><body><div id='popwrap'>";
	wdata="<div class='title clear'>";
	wdata="<h2 class='fl'>${lyData.title }</h2></div>";
	wdata+=document.getElementById("printTxt").innerHTML;
	wdata+="</div></body></HTML>";
	
 	Pwin.document.open();
	Pwin.document.write(wdata);
 	Pwin.document.close();
	Pwin.window.print();
	Pwin.window.location.reload();
	
//  	document.getElementById("etc").style.display = "block";
//  	document.getElementById("hidden2").style.display = "block";
	
 	Pwin.close();
}
</script>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">${lyData.title }</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<div id="printTxt">
			<!-- Contents -->
			<div id="popcontainer">
				<div id="popcontent">
					<div class="tbl_write1" id="printpage">
						<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
							<colgroup>
								<col width="13%" />
								<col width="37%"  />
								<col width="13%" />
								<col width="37%"  />
							</colgroup>
							<tr>
								<th>회계연도</th>
								<td colspan="3"><span>${lyData.fiscalyear }년도</span>
									<input type="hidden" name="fiscalyear" value="${lyData.fiscalyear }" />
								</td>
							</tr>
							<c:forEach var="items" items="${agreeData}" varStatus="status">
								<c:if test="${status.index eq 0 }">
									<tr>
										<th>
											<c:if test="${lyData.agreetypecode eq '100' }">ABO 번호</c:if>
											<c:if test="${lyData.agreetypecode eq '200' }">ABO 번호<BR/>(피위임자)</c:if>
											<c:if test="${lyData.agreetypecode eq '300' }">ABO 번호</c:if>
										</th>
										<td><span>${items.abo_no }</span>
										</td>
										<th>
											ABO 이름
										</th>
										<td><span>${items.name }</span></td>
									</tr>
								</c:if>
								<c:if test="${lyData.agreetypecode eq '200' }">
									<tr>
										<th>ABO 번호<BR/>(위임자)</th>
										<td><span>${items.delegatorabo_no }</span></td>
										<th>ABO 이름<BR/>(위임자)</th>
										<td><span>${items.delegatoraboname }</span></td>
									</tr>
								</c:if>
								<c:if test="${lyData.agreetypecode eq '300' }">
									<c:if test="${status.index eq 0 }">
										<tr>
											<th>LOA</th>
											<td><span>${items.loanamekor }</span></td>
											<th>동의일시</th>
											<td><span>${items.agreedate }</span></td>
										</tr>
									</c:if>
								</c:if>
								
							</c:forEach>
						</table>
						<br/>
						<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
							<colgroup>
								<col width="13%" />
								<col width="*"  />
							</colgroup>
							<c:forEach var="items" items="${agreeData}" varStatus="status">
								<c:if test="${status.index eq 0 }">
									<tr>
										<th>약관제목</th>
										<td><span>${items.agreetitle }</span>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="height:300px;">${items.agreetxt }</td>
									</tr>
								</c:if>
							</c:forEach>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div id="popcontainer">
			<div id="popcontent">
				<div class="btnwrap clear">
					<a href="javascript:agreePrint();" class="btn_green">출력</a>
					<a href="javascript:;" class="btn_gray close-layer" >닫기</a>
				</div>
			</div>
		</div>
				
	</div>
	<!--// Edu Part Cd Info -->

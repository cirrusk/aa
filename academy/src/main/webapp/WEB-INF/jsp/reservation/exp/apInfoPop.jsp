<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("line", "\n"); %>
<script type="text/javascript">
</script>

<div class="pbLayerWrap" id="uiLayerPop_01" style="display: none; position: fixed; top: 50%; left: 50%; margin-top: 100px; margin-left: -300px;" tabindex="0">
	<div class="pbLayerHeader">
		<strong><img src="/_ui/desktop/images/content/poptxt_w010200050.gif" alt="AP안내"></strong>
	</div>
	<div class="pbLayerContent">
		<ul class="tabList uiApSelShow">
			<c:forEach var="item" items="${result.list}" varStatus="status">
				<li class="on"><a href="#uiAp${item.legacyCode}">${item.displayName}</a></li>
			</c:forEach>
		</ul>

		<c:forEach var="item" items="${result.list}" varStatus="status">
		
			<!-- 도로명 주소  formatting -->
			<c:set var="addressByStreet" value="${fn:replace(item.addressByStreet, line, '<br>')}"/>
			<c:set var="transAddressByStreet" value="${fn:split(addressByStreet, '<br>')}"/>
			
			<c:forEach var = "address" items="${transAddressByStreet}" varStatus="status">
				
				<c:if test="${status.count == 2}">
					<c:set var ="addressByStreet1" value="${address}"/>
				</c:if>
				<c:if test="${status.count == 3}">
					<c:set var ="addressByStreet2" value="${address}"/>
				</c:if>
				<c:if test="${status.count == 4}">
					<c:set var ="phone" value="${address}"/>
				</c:if>
			</c:forEach>
			<!-- 도로명 주소  formatting -->
		
			<!-- 지번 주소  formatting -->
			<c:set var="address" value="${fn:replace(item.address, line, '<br>')}"/>
			<c:set var="transAddress" value="${fn:split(address, '<br>')}"/>
			
			<c:forEach var = "address" items="${transAddress}" varStatus="status">
				
				<c:if test="${status.count == 2}">
					<c:set var ="address1" value="${address}"/>
				</c:if>
				<c:if test="${status.count == 3}">
					<c:set var ="address2" value="${address}"/>
				</c:if>
				
			</c:forEach>
			<!-- 지번 주소  formatting -->
		
		
			<div class="tabInfoWrap" id="uiApView${item.legacyCode}"  style="display: block;">
				<strong class="txtHead">암웨이 플라자  ${item.displayName}</strong>
				<div class="apPhoto">
					<c:if test="${item.storeGallery != '' && item.storeGallery ne null}">
						<div class="photoZ"><img src="${curerntHybrisLocation}${item.storeGallery}" alt="암웨이 플라자 ${item.displayName}"></div>
					</c:if>
					<c:if test="${item.storeGallery == '' || item.storeGallery eq null}">
						<div class="photoZ"><img src="/_ui/desktop/images/content/ap/img_ap_bsc.jpg" alt="암웨이 플라자 ${item.displayName}"></div>
					</c:if>
					<div class="addr">
						<strong class="title">주소</strong>
						<div class="addrDL">
							
							<p><img src="/_ui/desktop/images/content/ico_addrtype01.gif" alt="지번주소"> <span>${address1}${address1}</span></p>
							<p><img src="/_ui/desktop/images/content/ico_addrtype02.gif" alt="도로명주소"> <span>${addressByStreet1}${addressByStreet2}</span></p>
							
						</div>
						<strong class="title mgtM">전화번호 <span>:${phone} </span></strong>
					</div>
				</div>
				<strong class="title">영업시간</strong>
				<div class="scroll" tabindex="0">
<!-- 					20150709 : 암웨이 플라자 영업시간과 동일 소스 -->
						${item.businessHours}
<!-- 					//20150709 : 암웨이 플라자 영업시간과 동일 소스 -->
				</div>
			</div>
		</c:forEach>
	</div>
	<a href="#" class="btnPopClose" id="uiApSelClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="AP안내 상세보기 닫기"></a>
</div>
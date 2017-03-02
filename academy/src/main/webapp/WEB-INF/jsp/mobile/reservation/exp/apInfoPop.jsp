<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("line", "\n"); %>
<!-- <div class="pbLayerPopup fixedFullsize" id="uiLayerPop_apInfo"> -->
<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_apInfo" tabindex="0" style="display: block; top: 0px;">
	<div class="pbPopWrap">
		<div class="pbPopHeader">
			<h1>AP 안내</h1>
		</div>
		<div class="pbPopContent">
			<div class="hTitleBox">
				<!-- 20150604 : 암웨이플라자 순서 변경  -->
				<ul class="spTabList spApList">
					<c:forEach var="item" items="${result.list}" varStatus="status">
						<li><a href="#apCont${item.legacyCode}">${item.displayName}</a></li>
					</c:forEach>
				</ul>
				<!-- //20150604 : 암웨이플라자 순서 변경  -->
			</div>
			
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
			
				<div class="spTabCont spApCont" id="apCont${item.legacyCode}" style="display: block;">
					<h2>${item.displayName}</h2>
<!-- 					<h2>분당 ABC (암웨이 브랜드 체험센터)</h2> -->
					<div class="apPhoto">
						<c:if test="${item.storeGallery != '' && item.storeGallery ne null}">
							<div class="photoZ"><img src="${curerntHybrisLocation}${item.storeGallery}" alt="암웨이 플라자 ${item.displayName}"></div>
						</c:if>
						<c:if test="${item.storeGallery == '' || item.storeGallery eq null}">
							<div class="photoZ"><img src="/_ui/desktop/images/content/ap/img_ap_bsc.jpg" alt="암웨이 플라자 ${item.displayName}"></div>
						</c:if>
					</div>
					<ul class="spApAddress">
						<li class="addrWrap">
							<h3>주소</h3>
							<p class="addrP">
								<span><em>지번</em> <strong>${address1}${address1}</strong></span>
								<span><em>도로</em> <strong>${addressByStreet1}${addressByStreet2}</strong></span>
							</p>
						</li>
						<li><strong>전화 :</strong> ${phone} </li>
					</ul>
					<h3>영업시간</h3>
					<!-- 20150709 : 암웨이 플라자 영업시간과 동일 소스 -->
					<ul class="info">
						${item.businessHours}

					</ul>
					<!-- //20150709 : 암웨이 플라자 영업시간과 동일 소스 -->
				</div>
			</c:forEach>

	
			<div class="btnWrap aNumb1">
				<a href="#none" class="btnBasicGL" onclick="javascript:closeApInfo();">닫기</a>
			</div>
	
		</div>
		<!-- 20150417 : 순서변경 및 내용수정 -->
		<!-- pbPopContent -->
		<!-- App를 위한 버튼 Class --><a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
</div>
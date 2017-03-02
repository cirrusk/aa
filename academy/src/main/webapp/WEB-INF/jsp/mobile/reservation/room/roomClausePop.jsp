<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

				<div class="pbLayerHeader">
					<strong>약관 및 동의 전체보기</strong>
				</div>
				<div class="pbLayerContent">
				
					<div class="tabWrapLogical tNum2Line">
						<section class="on">
							<h2 class="tab01"><a href="#none">교육장(퀸룸)<br/> 규정 동의</a></h2>
							<div>
								<div class="borderbox">
									<div class="termsWrapper pdNone" tabindex="0">
										<c:out value="${clause01}" escapeXml="false" />
									</div>
								</div>
							</div>
						</section>
						<section class="">
							<h2 class="tab02"><a href="#none">교육장(퀸룸)<br/> 제품 교육 시 주의사항</a></h2>
							<div>
								<div class="borderbox">
									<c:out value="${clause02}" escapeXml="false" />
								</div>
								<p class="listDot mgtS fsS">한국암웨이 뉴트리라이트 제품은 의약품이 아닌 건강기능식품으로, 제품 판매 또는 권유시 세심한 주의가 요구됩니다.</p>
							</div>
						</section>
					</div>
					
					<div class="btnWrap aNumb1">
						<a href="#" class="btnBasicGL2" onclick="javascript:closePop2();">닫기</a>
					</div>
				</div>
				<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>


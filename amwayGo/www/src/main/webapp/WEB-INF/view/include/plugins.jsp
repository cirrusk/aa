<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<div class="installWrap">
	<div class="ocwBanner"><a href="javascript:void(0);" onclick="doOcw();"><aof:img src="common/ocw_banner.gif" alt="대학공개강의 OCW , Open Course Ware"  /></a></div>
	<div class="installArea">
		<dl>
			<dt><spring:message code="글:시스템:학습관련프로그램다운로드"/></dt>
	        <dd><spring:message code="글:시스템:최적의강의시청을위한학습프로그램을다운로드받으십시오"/></dd>
	        <dd><spring:message code="글:시스템:설치되지않은학습프로그램이있다면다운로드받아설치해주십시오"/></dd>
		</dl>
		<div class="instBox">
	        <div class="media">
	            <span><spring:message code="글:시스템:미디어플레이어"/></span>
	            <P id="wmpPluginNotfound" style="display: none"><a href="http://windows.microsoft.com/ko-KR/windows/download-windows-media-player" target="_blank"><aof:img src="btn/install.gif" alt="설치하기"  /></a></P>
	            <p id="wmpPluginAvailable" style="display: none"><aof:img src="btn/installed.gif" alt="설치완료"  /></p>
	        </div>
	        <div class="flash">
	            <span><spring:message code="글:시스템:플래시플레이어"/></span>
	            <P id="flashPluginNotfound" style="display: none"><a href="http://get.adobe.com/kr/flashplayer" target="_blank"><aof:img src="btn/install.gif" alt="설치하기"  /></a></P>
	            <p id="flashPluginAvailable" style="display: none"><aof:img src="btn/installed.gif" alt="설치완료"  /></p>
	        </div>
	    </div>
	</div>
</div>

<script type="text/javascript">
(function() {
	var flashInstalled = false;
	var wmpInstalled = false;
	// Shockwave Flash
	if (parseFloat(UT.installedFlashPlugin()) >= 9) {  // 버전 9 이상.
		jQuery("#flashPluginAvailable").show();
		jQuery("#flashPluginNotfound").hide();
		flashInstalled = true;
	} else {
		jQuery("#flashPluginAvailable").hide();
		jQuery("#flashPluginNotfound").show();
	}
	
	// Windows Media Player
	if (UT.installedMediaPlayerPlugin()) {
		jQuery("#wmpPluginAvailable").show();
		jQuery("#wmpPluginNotfound").hide();
		wmpInstalled = true;
	} else {
		jQuery("#wmpPluginAvailable").hide();
		jQuery("#wmpPluginNotfound").show();
	}
	<c:if test="${param['type'] eq 'installedHidden'}">
		if (flashInstalled == true && wmpInstalled) {
			jQuery(".section-guide").hide();
		}
	</c:if>
})();
</script>

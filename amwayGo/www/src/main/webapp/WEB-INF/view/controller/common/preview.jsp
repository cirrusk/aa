<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html>
<head>
<title></title>
<script type="text/javascript">

doSample = function(mapPKs) {
	var width = mapPKs["width"];
	var height = mapPKs["height"];
	if (width==0 || width == ""){
		width = 1060;
	}
	if (height==0 || height == ""){
		height = 768;
	}
	
	var forSample = null;
	forSample = $.action("popup");
	forSample.config.formId = "FormSample";
	forSample.config.url    = "<c:url value="/learning/simple/sample/popup.do"/>";
	forSample.config.winname = "Sample";
	forSample.config.options.title = "<spring:message code="글:과정:과정맛보기"/>";
	forSample.config.options.scrollbars = "no";
	
	forSample.config.options.width = width;
	forSample.config.options.height = parseInt(height)+47;
	UT.getById(forSample.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forSample.config.formId);
	if(forSample.config.popupWindow != null) { // 팝업윈도우가 이미 존재하면 닫고, 다시 띄운다.
		forSample.config.popupWindow.close();
		forSample.config.popupWindow = null;
		setTimeout("forSample.run()", 1000); // 윈도우가 close 되도록 1초만 쉬었다가
	} else {
		forSample.run();
	}
};

doSampleOther = function() {
	alert("준비중인 강좌입니다");
};
</script>
</head>

<body>

<form name="FormSample" id="FormSample" method="post" onsubmit="return false;">
	<input type="hidden" name="courseId">
</form>

<div id="wrap_pop" style="width:600px;">
	<!-- header -->
	<div id="header_pop">
		<div>
			<h1>과정맛보기</h1>
            <div class="close"><a href="#" onclick="doClose()"><aof:img src="btn/btn_pop_close.gif" alt="메뉴:팝업닫기" /></a></div>
		</div>
	</div>
	<!--// header -->
	<div id="content_pop">
		<!-- content -->
    	<!-- list -->
       	<table class="popBoard" summary="">
            <caption>제출자료 목록</caption>
            <colgroup>
            <col style="width:auto;" />
            <col style="width:35%;" />
            <col style="width:35%;" />
            </colgroup>
            <thead>
            <tr>
                <th scope="col">공통</th>
                <th scope="col">방송제작</th>
                <th scope="col">방송기술</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td> <a href="#" onclick="doSample({'courseId' : '5687',
						   'width'	  : '990',
						   'height'	  : '669'
					})"><span class="preview">공영 방송론</span></a></td>
              	<td><a href="#" onclick="doSample({'courseId' : '5586',
										   'width'	  : '800',
										   'height'	  : '600'
						})"><span class="preview">드라마 제작론</span></a></td>
                <td><a href="#" onclick="doSample({'courseId' : '5624',
										   'width'	  : '800',
										   'height'	  : '600'
						})"><span class="preview">방송영상기술의 이해</span></a></td>
            </tr>
            <tr>
                <td><a href="#" onclick="doSample({'courseId' : '5553',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">법규</span></a></td>
              	<td><a href="#" onclick="doSample({'courseId' : '5689',
										   'width'	  : '790',
										   'height'	  : '575'
						})"><span class="preview">다큐멘터리 제작론</span></a></td>
                <td><a  href="#" onclick="doSample({'courseId' : '5487',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">방송음향의 이해</span></a></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
              	<td><a href="#" onclick="doSample({'courseId' : '5600',
										   'width'	  : '806',
										   'height'	  : '680'
						})"><span class="preview">TV프로그램 이렇게 만든다</span></a></td>
                <td><a onclick="doSample({'courseId' : '5558',
										   'width'	  : '990',
										   'height'	  : '680'
						})" href="#"><span class="preview">디지털 워크플로우</span></a></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
              	<td><a onclick="doSampleOther()" href="#"><span class="preview">방송 보도론</span></a></td>
                <td><a  href="#" onclick="doSample({'courseId' : '5206',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">방송조명의 이해</span></a></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
              	<td><a onclick="doSampleOther()" href="#"><span class="preview">6mm카메라만 들면 나도 VJ</span></a></td>
                <td><a href="#" onclick="doSample({'courseId' : '5205',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">방송음향을 위한 악기론</span></a></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
              	<td><a href="#" onclick="doSample({'courseId' : '5557',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">탐사보도론</span></a></td>
                <td><a href="#" onclick="doSample({'courseId' : '5625',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">방송통신융합과 디지털방송</span></a></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
              	<td><a  href="#" onclick="doSample({'courseId' : '5743',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">FCP영상편집과정</span></a></td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
              	<td><a href="#" onclick="doSample({'courseId' : '5684',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">방송언어 교양인의 말하기</span></a></td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
              	<td><a href="#" onclick="doSample({'courseId' : '5549',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">스마트한 1인 미디어 제작</span></a></td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
              	<td><a href="#" onclick="doSample({'courseId' : '5623',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">왕초보씨 HD영상전문가되기</span></a></td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
              	<td><a href="#" onclick="doSample({'courseId' : '5620',
										   'width'	  : '990',
										   'height'	  : '680'
						})"><span class="preview">방송제작 가이드라인</span></a></td>
                <td>&nbsp;</td>
            </tr>
            </tbody>		
        </table>
        <!-- //list -->

		<!--// content -->
	</div>
</div>
</body>
</html>
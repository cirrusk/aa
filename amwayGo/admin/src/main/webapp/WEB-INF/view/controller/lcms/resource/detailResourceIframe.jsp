<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:if test="${!empty versionList}">
	<c:forEach var="row" items="${versionList}" varStatus="i">
		<c:if test="${i.first}">
			<c:set var="version" value="${row.itemResourceVersion.version}"/>
		</c:if>
	</c:forEach>
</c:if>
<c:if test="${empty versionList}">
	<c:set var="version" value="00000"/>
</c:if>

<html>
<head>
<title></title>
<script type="text/javascript">
var forInsert = null;
var forCreateFolder = null;
var forRevert = null;
var swfu = null;
var onlyFile = false;
var codeMirror = null;
<c:if test="${filetype eq 'dir'}">
onlyFile = true;
</c:if>
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// 코드 에디터
    if (UT.getById("filedata")) {
        codeMirror = UI.codeMirror("filedata");
    }
	
	if (onlyFile == true) {
		// uploader
		swfu = UI.uploader.create(function() {  // completeCallback
				parent.doRefresh();
			},
			[{
				elementId : "uploader",
				postParams : {
					dir : "<c:out value="${detail.hrefOriginal}"/>",	
					currentMenuId : "<c:out value="${aoffn:encrypt(appCurrentMenu.menu.menuId)}"/>"
				},
				options : {
					uploadUrl : "<c:url value="/lcms/resource/newfile.do"/>",
					fileTypes : "*.*",
					fileTypesDescription : "All File",
					fileSizeLimit : "100 MB",
					fileUploadLimit : 1, // default : 1, 0이면 제한없음.
					inputWidth : 300, // default : 300
					inputHeight : 20, // default : 20
					immediatelyUpload : false,
					successCallback : function(id, file) {}
				}
			}]
		);	
	} else {
		// uploader
		swfu = UI.uploader.create(function() {  // completeCallback
				forInsert.run("continue");
			},
			[{
				elementId : "uploader",
				postParams : {
					hrefOriginal : "<c:out value="${detail.hrefOriginal}"/>",	
					version : "<c:out value="${version}"/>",
					currentMenuId : "<c:out value="${aoffn:encrypt(appCurrentMenu.menu.menuId)}"/>"
				},
				options : {
					uploadUrl : "<c:url value="/lcms/resource/filesave.do"/>",
					fileTypes : "*.<c:out value="${extension}"/>",
					fileTypesDescription : "<c:out value="${extension}"/> File",
					fileSizeLimit : "100 MB",
					fileUploadLimit : 1, // default : 1, 0이면 제한없음.
					inputWidth : 190, // default : 300
					inputHeight : 20, // default : 20
					immediatelyUpload : false,
					successCallback : function(id, file) {}
				}
			}]
		);	
	}
	
	var $preview = jQuery("#previewImg");
	if ($preview.length > 0) {
		var $img = $preview.find("img");
		$img.attr("src", $img.attr("src") + "?seed=" + (new Date()).getTime());
		if ($preview.get(0).scrollWidth > 200) {
			$img.css("width", "100%");
			if ($preview.get(0).scrollHeight > 200) {
				$img.css({"width" : "", "height" : "100%"});
			}
		}
		jQuery("#blockImg").hide();
	}
	
	jQuery(".media").media({width : 200, height : 200, autoStart : false});
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forInsert = $.action("submit", {formId : "FormDetailResource"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/lcms/resource/insertversion.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = function() {
		var form = parent.document.getElementById("FormExtra");
		form.elements["encoding"][0].checked = true;
		parent.doRefresh();
	};
	forInsert.validator.set({
		title : "<spring:message code="필드:콘텐츠:변경내역"/>",
		name : "description",
		check : {
			maxlength : 1000
		}
	});
    <c:choose>
    <c:when test="${filetype eq 'text'}">
    forInsert.config.fn.before = function() {
        var $filedata = jQuery("#filedata");
        if ($filedata.length > 0 && codeMirror != null) {
            $filedata.val(codeMirror.getValue());
        }
        return true;
    };
    </c:when>
    <c:otherwise>
    forInsert.config.fn.before = doStartUpload;

    forInsert.validator.set(function() {
        if (UI.uploader.isAppendedFiles(swfu, "uploader") == false) {
            $.alert({
                message : "<spring:message code="글:콘텐츠:파일을선택하십시오"/>"
            });
            return false;
        } else {
            return true;
        }
    });
    </c:otherwise>
    </c:choose>
	
	forRevert = $.action("submit", {formId : "FormRevertResource"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forRevert.config.url             = "<c:url value="/lcms/resource/updaterevert.do"/>";
	forRevert.config.target          = "hiddenframe";
	forRevert.config.message.confirm = "<spring:message code="글:콘텐츠:복원하시겠습니까"/>"; 
	forRevert.config.message.success = "<spring:message code="글:콘텐츠:복원되었습니다"/>";
	forRevert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forRevert.config.fn.complete     = function() {
		parent.doRefresh();
	};

	forCreateFolder = $.action("submit", {formId : "FormCreateFolder"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forCreateFolder.config.url             = "<c:url value="/lcms/resource/newfolder.do"/>";
	forCreateFolder.config.target          = "hiddenframe";
	forCreateFolder.config.message.confirm = "<spring:message code="글:생성하시겠습니까"/>"; 
	forCreateFolder.config.message.success = "<spring:message code="글:생성되었습니다"/>";
	forCreateFolder.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forCreateFolder.config.fn.complete     = function() {
		parent.doRefresh();
	};
	forCreateFolder.validator.set({
		title : "<spring:message code="필드:콘텐츠:새폴더"/>",
		name : "folderName",
		data : ["!null", "alphabet", "!space"],
		check : {
			maxlength : 30
		}
	});

};
/**
 * 저장
 */
doInsert = function() { 
	forInsert.run();
};
/**
 * 저장
 */
doRevert = function(mapPKs) {
	// 등록화면 form을 reset한다.
	UT.getById(forRevert.config.formId).reset();
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forRevert.config.formId);
	// 등록화면 실행
	forRevert.run();
};
/**
 * 저장. 파일만 업로드
 */
doOnlyFile = function() {
	UI.uploader.runUpload(swfu, "uploader");
};
/**
 * 파일업로드 시작
 */
doStartUpload = function() {
	if (UI.uploader.isAppendedFiles(swfu, "uploader") == true) {
		UI.uploader.runUpload(swfu, "uploader");
		return false;
	} else {
		return true;
	}
};
/**
 * 폴더 생성
 */
doCreateFolder = function() {
	forCreateFolder.run();
};
</script>
<c:import url="/WEB-INF/view/include/codeMirror.jsp"/>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/mediaPlayer.jsp"/>
</head>

<body>

<c:choose>
	<c:when test="${filetype eq 'text'}">
		<form id="FormDetailResource" name="FormDetailResource" method="post" onsubmit="return false;">
			<input type="hidden" name="resourceSeq" value="<c:out value="${detail.resourceSeq}"/>"/>
			<input type="hidden" name="hrefOriginal" value="<c:out value="${detail.hrefOriginal}"/>"/>
			<input type="hidden" name="version" value="<c:out value="${version}"/>"/>
            <input type="hidden" name="aofNote" value="<c:out value="${aoffn:encryptSecure(ssMemberSeq, pageContext.request)}"/>"/>
            
			<table class="tbl-detail">
			<colgroup>
				<col style="width: auto" />
			</colgroup>
			<tbody>
			<tr>
				<th><spring:message code="필드:콘텐츠:파일경로" /> : <c:out value="${detail.hrefOriginal}"/></th>
			</tr>
			<tr>
				<td>
				    <textarea name="filedata" id="filedata"><c:out value="${filedata}"/></textarea>
					
					<div class="align-c" style="margin-top:8px;">
						<strong><spring:message code="필드:콘텐츠:변경내역" /></strong>
						<input type="text" name="description" style="width:72%"/>
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:if>
					</div>
				</td>
			</tr>
			</tbody>
			</table>
		</form>

	</c:when>	
	<c:when test="${filetype eq 'img'}">
		<table class="tbl-detail">
		<colgroup>
			<col style="width: 220px" />
			<col style="width: auto" />
		</colgroup>
		<tbody>
		<tr>
			<th colspan="2"><spring:message code="필드:콘텐츠:파일경로" /> : <c:out value="${detail.hrefOriginal}"/></th>
		</tr>
		<tr>
			<td style="position:relative">
				<div id="previewImg" style="width:200px;height:200px;overflow:auto;text-align:center;vertical-align:middle;line-height:195px;">
					<img src="<c:out value="${aoffn:config('upload.context.lcms')}"/>/<c:out value="${detail.hrefOriginal}"/>"/>
				</div>
				<div id="blockImg" style="width:100%;height:100%;position:absolute;left:0px;top:0px;z-index:100;background-color:white;"></div>
			</td>
			<td>
				<form id="FormDetailResource" name="FormDetailResource" method="post" onsubmit="return false;">
					<input type="hidden" name="resourceSeq" value="<c:out value="${detail.resourceSeq}"/>"/>
					<input type="hidden" name="hrefOriginal" value="<c:out value="${detail.hrefOriginal}"/>"/>
					<input type="hidden" name="version" value="<c:out value="${version}"/>"/>
					
					<div class="lybox-title">
						<h4 class="section-title"><spring:message code="필드:콘텐츠:새파일"/></h4>
					</div>
					<div style="margin-bottom:8px;"><div id="uploader" class="uploader"></div></div>

					<div class="lybox-title">
						<h4 class="section-title"><spring:message code="필드:콘텐츠:변경내역"/></h4>
					</div>
					<div><textarea name="description" style="width:250px;height:50px;"></textarea></div>
					
				</form>
			</td>
		</tr>
		</tbody>
		</table>
		
		<div class="lybox-btn">
			<div class="lybox-btn-r">
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
					<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
				</c:if>
			</div>
		</div>
		
	</c:when>
	<c:when test="${filetype eq 'dir'}">
		<table class="tbl-detail">
		<colgroup>
			<col style="width: auto" />
		</colgroup>
		<tbody>
		<tr>
			<th><spring:message code="필드:콘텐츠:파일경로" /> : <c:out value="${detail.hrefOriginal}"/></th>
		</tr>
		<tr>
			<td>
				<div class="lybox-title">
					<h4 class="section-title"><spring:message code="필드:콘텐츠:새파일"/></h4>
				</div>
				
				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<div id="uploader" class="uploader"></div>
					</div>
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doOnlyFile();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:if>
					</div>
				</div>
			</td>
		</tr>
		</tbody>
		</table>
		
		<form id="FormCreateFolder" name="FormCreateFolder" method="post" onsubmit="return false;">
		<input type="hidden" name="dir" value="<c:out value="${detail.hrefOriginal}"/>"/>
		<table class="tbl-detail mt10">
		<colgroup>
			<col style="width: auto" />
		</colgroup>
		<tbody>
		<tr>
			<td>
				<div class="lybox-title">
					<h4 class="section-title"><spring:message code="필드:콘텐츠:새폴더"/></h4>
				</div>
				
				
				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<input type="text" name="folderName" style="width:400px;">
					</div>
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doCreateFolder();" class="btn blue"><span class="mid"><spring:message code="버튼:생성"/></span></a>
						</c:if>
					</div>
				</div>
			</td>
		</tr>
		</tbody>
		</table>
		</form>
		
	</c:when>
	<c:when test="${filetype eq 'media'}">
		<table class="tbl-detail">
		<colgroup>
			<col style="width: 220px" />
			<col style="width: auto" />
		</colgroup>
		<tbody>
		<tr>
			<th colspan="2"><spring:message code="필드:콘텐츠:파일경로" /> : <c:out value="${detail.hrefOriginal}"/></th>
		</tr>
		<tr>
			<td>
				<div style="width:200px;height:200px; line-height:195px; overflow:auto; vertical-align:middle; text-align:center;">
					<a href="<c:out value="${aoffn:config('upload.context.lcms')}/${detail.hrefOriginal}"/>" class="media">object</a>
				</div>
			</td>
			<td>
				<form id="FormDetailResource" name="FormDetailResource" method="post" onsubmit="return false;">
					<input type="hidden" name="resourceSeq" value="<c:out value="${detail.resourceSeq}"/>"/>
					<input type="hidden" name="hrefOriginal" value="<c:out value="${detail.hrefOriginal}"/>"/>
					<input type="hidden" name="version" value="<c:out value="${version}"/>"/>
					
					<div class="lybox-title">
						<h4 class="section-title"><spring:message code="필드:콘텐츠:새파일"/></h4>
					</div>
					<div style="margin-bottom:8px;"><div id="uploader" class="uploader"></div></div>

					<div class="lybox-title">
						<h4 class="section-title"><spring:message code="필드:콘텐츠:변경내역"/></h4>
					</div>
					<div><textarea name="description" style="width:250px;height:50px;"></textarea></div>
				</form>
				
			</td>
		</tr>
		</tbody>
		</table>
		
		<div class="lybox-btn">
			<div class="lybox-btn-r">
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
					<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
				</c:if>
			</div>
		</div>
	</c:when>
	<c:otherwise>
		<table class="tbl-detail">
		<colgroup>
			<col style="width: 220px" />
			<col style="width: auto" />
		</colgroup>
		<tbody>
		<tr>
			<th colspan="2"><spring:message code="필드:콘텐츠:파일경로" /> : <c:out value="${detail.hrefOriginal}"/></th>
		</tr>
		<tr>
			<td>
				<div style="width:200px;height:200px; line-height:195px; overflow:auto; vertical-align:middle; text-align:center;">
					object
				</div>
			</td>
			<td>
				<form id="FormDetailResource" name="FormDetailResource" method="post" onsubmit="return false;">
					<input type="hidden" name="resourceSeq" value="<c:out value="${detail.resourceSeq}"/>"/>
					<input type="hidden" name="hrefOriginal" value="<c:out value="${detail.hrefOriginal}"/>"/>
					<input type="hidden" name="version" value="<c:out value="${version}"/>"/>
					
					<ul>
						<li class="section_title"><spring:message code="필드:콘텐츠:새파일" /></li>
						<li style="margin-bottom:8px;"><div id="uploader" class="uploader"></div></li>
						<li class="section_title"><spring:message code="필드:콘텐츠:변경내역" /></li>
						<li><textarea name="description" style="width:250px;height:50px;"></textarea></li>
					</ul>
				</form>
				
			</td>
		</tr>
		</tbody>
		</table>
		
		<div class="lybox-btn">
			<div class="lybox-btn-r">
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
					<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
				</c:if>
			</div>
		</div>
	</c:otherwise>
</c:choose>

<c:if test="${filetype ne 'dir'}">
	<form id="FormRevertResource" name="FormRevertResource" method="post" onsubmit="return false;">
	<input type="hidden" name="versionSeq"/>
	<input type="hidden" name="hrefOriginal"/>
	<input type="hidden" name="hrefBackup"/>
	</form>
	
	<table id="listTable" class="tbl-list mt10">
	<colgroup>
		<col style="width: 60px" />
		<col style="width: auto" />
		<col style="width: 60px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:콘텐츠:버전" /></th>
			<th><spring:message code="필드:콘텐츠:변경내역" /></th>
			<th></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${versionList}" varStatus="i">
		<tr>
			<td><c:out value="${row.itemResourceVersion.version}"/></td>
			<td class="align-l"><c:out value="${row.itemResourceVersion.description}"/></td>
			<td>
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and i.first}">
					<a href="#" 
						onclick="doRevert({versionSeq : '<c:out value="${row.itemResourceVersion.versionSeq}"/>'
						,hrefOriginal : '<c:out value="${row.itemResourceVersion.hrefOriginal}"/>'
						,hrefBackup : '<c:out value="${row.itemResourceVersion.hrefBackup}"/>'
					});" class="btn gray"><span class="small"><spring:message code="버튼:콘텐츠:복원"/></span></a>
				</c:if>
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty versionList}">
		<tr>
			<td colspan="3" align="center"><spring:message code="글:콘텐츠:변경내역이없습니다" /></td>
		</tr>
	</c:if>
	</tbody>
	</table>
</c:if>

</body>
</html>
<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var swfu = null;
var forUploadTemplateExcel = null;
var forDownloadExcel = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// uploader
    swfu = UI.uploader.create(function() {}, // completeCallback
        [{
            elementId : "uploader",
            postParams : {},
            options : {
                uploadUrl : "<c:url value="/attach/file/save.do"/>",
                fileTypes : "*.*",
                fileTypesDescription : "All Files",
                fileSizeLimit : "10 MB",
                fileUploadLimit : 1, // default : 1, 0이면 제한없음.
                inputWidth : 120,
                inputHeight : 20, // default : 20
                immediatelyUpload : true,
                successCallback : function(id, file) {
                	forUploadTemplateExcel.run();
                }
            }
        }]
    );
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forDownloadExcel = $.action("submit", {formId : "FormTemplateExcel"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forDownloadExcel.config.url             = "<c:url value="/univ/course/apply/template/excel.do"/>";
    
	forUploadTemplateExcel = $.action();
	forUploadTemplateExcel.config.formId = "FormInsert";
    forUploadTemplateExcel.config.url             = "<c:url value="/univ/course/apply/attach/excel/save.do"/>";
    forUploadTemplateExcel.config.target          = "hiddenframe";
    forUploadTemplateExcel.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUploadTemplateExcel.config.fn.before       = doSetUploadInfo;
    forUploadTemplateExcel.config.fn.complete     = function(result) {
    	result = result.replaceAll("&#034;", '"');
    	result = jQuery.parseJSON(result);
    	if(result.success > 0){
    		$.alert({
                message : "<spring:message code="글:저장되었습니다"/>",
                button1 : {
                    callback : function() {
                    	var par = $layer.dialog("option").parent;
                        if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
                            par["<c:out value="${param['callback']}"/>"].call(this);
                        }
                    	$layer.dialog("close");
                    }
                }
            });
    	} else if(result.success < 0) {
    		$.alert({message : "<spring:message code="글:엑셀:엑셀파일을확인하십시오"/>".format(
                    {"0" : result.error})
            });
    	} else {
    		$.alert({message : "<spring:message code="글:엑셀:건이등록되었습니다"/>".format({"0" : result.success})});
    	}
    }
};

/**
 * 파일정보 저장
 */
doSetUploadInfo = function() {
    if (swfu != null) {
        var form = UT.getById(forUploadTemplateExcel.config.formId);
        form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
    }
    return true;
};

/**
 * 엑셀다운로드
 */
doDownLoadExcel = function(){
	forDownloadExcel.run();
}
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>
    <form name="FormTemplateExcel" id="FormTemplateExcel" method="post" onsubmit="return false;">
	    <input type="hidden" name="courseActiveSeq"  value="<c:out value="${courseApply.courseActiveSeq}"/>" />
	</form>
	
   <form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"  value="<c:out value="${courseApply.courseActiveSeq}"/>" />
    <table class="tbl-detail">
    <colgroup>
        <col style="width: 120px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th><spring:message code="필드:게시판:첨부파일"/></th>
            <td>
                <input type="hidden" name="attachUploadInfo"/>
                <div id="uploader" class="uploader"></div>
                <span class="vbom">10 MB</span>
            </td>
        </tr>
    </tbody>
    </table>
    </form>

    <div class="lybox-btn-r">
        <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'E')}">
            <a href="javascript:void(0)" onclick="doDownLoadExcel()" class="btn blue">
                <span class="mid"><spring:message code="버튼:수강신청:탬플릿다운로드" /></span>
            </a>
        </c:if>
    </div>
	
</body>
</html>
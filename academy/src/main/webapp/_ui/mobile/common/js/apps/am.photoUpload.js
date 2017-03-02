$("document").ready(function(){
	var fileUploadSuccess = $(".fileUploadSuccessMessageBox");
	var fileUploadFail = $(".fileUploadFailMessageBox");
	var fileUploadSizeFail = $(".fileUploadSizeFailMessageBox");
	var fileEmpty = $(".fileEmptyMessageBox");
	
	if(fileUploadSuccess.length){
		alert($.getMsg($.msg.useAgreement.photoChangeSuccess));
		location.href = "/mypage/personalinfo/use-agreement?isFromMyPage=true";
	}else if(fileUploadSizeFail.length){
        alert($.getMsg($.msg.useAgreement.photoSize));
        $("#fileUploadInput").val('');
        $("#fileUploadInput").wrap('<form>').closest('form').get(0).reset();
        $("#fileUploadInput").unwrap();
	}else if(fileUploadFail.length){
		alert($.getMsg($.msg.useAgreement.photoChangeFail));
	}else if(fileEmpty.length){
		alert($.getMsg($.msg.useAgreement.photoEmpty));
	} 
})

$(document).on("click", "#closePopup", function(){
	var fileUploadSuccess = $(".fileUploadSuccessMessageBox");
	var fileUploadFail = $(".fileUploadFailMessageBox");
	var fileEmpty = $(".fileEmptyMessageBox");
	
	if(fileUploadSuccess.length || fileUploadFail.length || fileEmpty.length){
		history.go(-2);
	}else{
		history.back();		
	}	
	return false;
});

$(document).on("change","#fileUploadInput",function(e) {
    var chkExt = true; 

    var val = $(this).val();
    
    if(val == '') {
    	return false;
    }

    switch(val.substring(val.lastIndexOf('.') + 1).toLowerCase()){
        case 'gif': case 'jpg': case 'png': case 'jpeg': case 'bmp':            
            break;
        default:
	        $(this).val('');
	        $(this).wrap('<form>').closest('form').get(0).reset();
	        $(this).unwrap();
            
            alert($.getMsg($.msg.useAgreement.photoOnly));
            chkExt = false;
            break;
    }
    if(!chkExt) return chkExt;
	/*
    var tmppath;
	
	if($.browser.msie && Number($.browser.version) <= 9 ) {
		return true;
		//tmppath = $(this).val();
	} else {
		tmppath = URL.createObjectURL(e.target.files[0]);
	}
	
	if($(".photoImg img").length == 0) {
		$(".photoWrapL .photo .hide").remove();
		
		$("<span>", { class:"photoImg" }).appendTo(".photoWrapL .photo");
		$("<img>", { src:tmppath, 
					 css:{ "margin-left":"-53px" } }).appendTo(".photoWrapL .photo .photoImg");
	}
        
    $(".photoImg img").attr('src', tmppath);
    */
});

function fileSizeCheck(fileObject) { 
	var iSize = 0;
	
	if($.browser.msie) {

		if( Number($.browser.version) < 9 ) {
			return true;
		} else {
			/*var objFSO = new ActiveXObject("Scripting.FileSystemObject");
			var sPath = fileObject[0].value;
			var objFile = objFSO.getFile(sPath);
			var iSize = objFile.size;*/
			iSize = fileObject[0].size;
		}
		
		iSize = iSize/ 1024;
	} else {
		iSize = (fileObject[0].files[0].size / 1024);
	}
	
	iSize = (Math.round((iSize / 1024) * 100) / 100) // MB 계산
	console.log(iSize);
	if( iSize < 0.5 || iSize > 10 ) {
		return false;
	}
	
	return true;
}
	

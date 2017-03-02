var roopYn = "N";

function EthicsStart() {
	$("#ethicsForm #status").val("S");
	
	$.ajax({
        url: "/academy/ethics/training/ethicsStart",
        type: "POST",
        data: $("#ethicsForm").serialize(),
        datatype: "json"
    });
	
	set_page();
}

function EthicsEnd() {
    var rtn = true;
    
    $("#ethicsForm #status").val("E");

    $.ajax({
        url: "/academy/ethics/training/ethicsEnd",
        type: "POST",
        data: $("#ethicsForm").serialize(),
        datatype: "json",
        complete: function() {
			window.close();
			window.onunload = function(){
	    	  window.opener.location.reload();
	    	};
        }
    });

    if (rtn) {
        //정상처리
        roopYn = "Y";
    }
}

function complete_education() {
    if (roopYn == "N") {
        EthicsEnd()
    }
    location.href = "/academy/ethics/training";
}

function next_page(){

	if(progress[curPage-1] == 1){
		alert("학습완료 후(또는 동영상 시청 후) 다음으로 이동이 가능합니다.");
		controls_toggle();
		return;
	}

	if(navi_page.length == curPage){
		//complete_education();
		return;
	}
	curPage++;
	set_page();
}

function prev_page(){
	if(curPage == 1){
		alert("첫번째 페이지입니다.");
		return;
	}
	curPage--;
	set_page();
}

function controls_toggle(){
	var chk = $('#controls').css('display');
	if (chk == 'none'){
		$('#controls').attr('style','display:block;');
		$('#next_info').attr('style','display:none;');
	}else{
		$('#controls').attr('style','display:none;');
		if(progress[curPage-1] == 0 && navi_page.length != curPage){
			$('#next_info').attr('style','display:block;');
		}
	}
}

function ito(num){
	var result = "";
	if(num < 10){ result = "0"+num;}
	else{result = num;}
	return result;
}

function next_che(){
	progress[curPage-1] = 0;
	$('#controls').attr('style','display:block;');
}
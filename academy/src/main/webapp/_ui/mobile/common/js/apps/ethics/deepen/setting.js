/*페이지 레이아웃을 위한 셋팅 값

set_img_width : 이미지 원본 넓이
set_img_height : 이미지 원본 높이

set_video_width : 비디오 원본 넓이
set_video_height : 비디오 원본 높이

set_video_top_margin : 비디오 위치 지정 해당 레이어에서 떨어진  top 값
set_video_left_margin : 비디오 위치 지정 해당 레이어에서 떨어진  left 값

/*==========================================*/
var set_img_width = 1010;
var set_img_height = 650;
var set_video_width = 600;
var set_video_height = 400;
var set_video_top_margin = 86;
var set_video_left_margin = 97;
/*==========================================*/

var alert_chk = 0;
var rString = 'N'; // 나레이션 및 동영상 페이지 진도 제한 Y 일 경우 바로 넘길수 있음

var progress = new Array();
for (i=0; i<navi_page.length; i++){
	if(navi_page[i] == 'N' || rString == 'Y'){progress[i] = 0;}
	else{progress[i] = 1;}
}

function set_page(){
	var data = navi_page[curPage-1];
	var content = "";

	content += "<img id=\"image\" src=\"/_ui/mobile/images/content/ethics/deepen/images/"+ito(curPage)+".jpg\" width=\"100%\" onclick=\"javascript:controls_toggle();\"/>";
	if(data == "N"){ // 일반페이지
		content += "<audio id=\"audio1\">";
		content += "<source src=\""+navi_linkfile[curPage-1]+"\" type=\"audio/mpeg\">";
		content += "</audio>";
		if(navi_page.length == curPage){content += "<img id=\"completed_img\" src=\"/_ui/mobile/images/content/ethics/deepen/img/end.jpg\" onclick=\"javascript:complete_education();\"/>";}
		$("#page_wrap").children().remove();
		$("#page_wrap").append(content);
		var oAudio = document.getElementById('audio1');
		oAudio.play();
	}else if(data == "V"){ // 비디오 페이지
		content += "<video id=\"video1\" controls autoplay onended=\"javascript:next_che();\">";
		content += "<source src=\""+navi_linkfile[curPage-1]+"\" type=\"video/mp4\">";
		//content += "<source src=\"./video/ogv/"+ito(curPage)+".ogv\" type=\"video/ogg\">";
		content += "</video>";

		$("#a1").empty();
		$("#a1").append("<a href=\"" + navi_linkfile[curPage - 1] + "\" target=\"_blank\">링크</a>"); 
		
		$("#page_wrap").children().remove();
		$("#page_wrap").append(content);
	}else if (data == "A"){ // 오디오 페이지
		content += "<audio id=\"audio1\" onended=\"javascript:next_che();\">";
		content += "<source src=\""+navi_linkfile[curPage-1]+"\" type=\"audio/mpeg\">";
		content += "</audio>";
		$("#page_wrap").children().remove();
		$("#page_wrap").append(content);
		var oAudio = document.getElementById('audio1');
		oAudio.play();
	}

	$("#navi-text").children().remove();
	$("#navi-text").append("<span>" + curPage + " / " + navi_page.length + "</span>");
	$('#controls').attr('style','display:none;');

	if(navi_page[curPage-1] == 'N' && navi_page.length != curPage){
		$('#next_info').attr('style','display:block;');
	}else{
		$('#next_info').attr('style','display:none;');
	}

	if(curPage == navi_page.length){
		$('#navi-next').children().remove();
		//$('#navi-next').append("<img src=\"./img/icon_fw80.png\" height=\"80px\"/>");
		$('#navi-next').append("<span>&nbsp;</span>");
	}else{
		$('#navi-next').children().remove();
		$('#navi-next').append("<img src=\"/_ui/mobile/images/content/ethics/deepen/img/icon_fw80.png\" height=\"80px\"/>");
	}

	init();
}

function init(){
	if(window.orientation == 0 || window.orientation == 180) {
		if( alert_chk == 0 ){
			alert('본 학습은 기기의 가로모드에 최적화 되었습니다.');
			alert_chk = 1;
		}
	}
		var w = document.getElementById("image").offsetWidth;
		var h = document.getElementById("image").offsetHeight;

		var rw = w/set_img_width;
		var rh = h/set_img_height;

		var video_width = set_video_width * rw;
		var video_height = set_video_height * rh;
		var video_top = set_video_top_margin * rh;
		var video_left = set_video_left_margin * rw;

	if (data = navi_page[curPage-1] == "V"){
		

		$("#video1").css("width",video_width);
		$("#video1").css("height",video_height);
		$("#video1").css("top",video_top);
		$("#video1").css("left",video_left);

	}else if(data = navi_page[curPage-1] == "A"){
		
	}
	
	if(navi_page.length == curPage){
		$("#completed_img").css("width",600 * rw);
		$("#completed_img").css("height",400 * rh);
		$("#completed_img").css("top",125 * rh);
		$("#completed_img").css("left",205 * rw);
	}
}

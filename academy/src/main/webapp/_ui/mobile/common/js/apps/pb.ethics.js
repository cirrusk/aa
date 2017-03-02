// 윤리강령 필수교육 과정 페이지 show hide
$(document).on("click", "ul#ethicsTab a", function(){
	var parentId = $(this).parent().attr("id");
	var currId = $("ul#ethicsTab li.on").attr("id");
	
	$("#" + currId + " strong").replaceWith(function(){
		return $("<a href='#none'>").append($("#" + currId + " strong").contents());
	});
	
	$("#" + parentId + " a").replaceWith(function(){
		return $("<strong>").append($(this).contents());
	});
	
	$("ul#ethicsTab li").removeClass("on");
	$("#" + parentId).addClass("on");
	
	$("#ethicsFirst").hide();
	$("#ethicsSecond").hide();
	$("#ethicsThird").hide();
	$("#" + parentId.substr(0,parentId.length-3)).show();
	/*$("#" + currId.substr(currId.length-3,currId.length))*/
});

//go FAQ 클릭
$(document).on("click", "#goFAQ", function(){
	$("#ethicsFirst").hide();
	$("#ethicsSecond").hide();
	$("#ethicsThird").show();
	
	var currId = $("ul#ethicsTab li.on").attr("id");
	
	$("#" + currId + " strong").replaceWith(function(){
		return $("<a href='#none'>").append($("#" + currId + " strong").contents());
	});
	
	$("#ethicsThirdTab a").replaceWith(function(){
		return $("<strong>").append($(this).contents());
	});
	$("ul#ethicsTab li").removeClass("on");
	$("#ethicsThirdTab").addClass("on");
});

$("document").ready(function(){
	$("#ethicsFirst").hide();
	$("#ethicsSecond").hide();
	$("#ethicsThird").hide();
	
	var currId = $("ul#ethicsTab li.on").attr("id");
	$("#" + currId.substr(0,currId.length-3)).show();
});

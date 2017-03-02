// 다른 버전의 개인정보취급(처리)방침 조회
$(document).on("click", "ul.listSel", function(){
	var version = $("input:radio:checked").attr("id");
	var url = "/compliance/terms/infopolicy/" + version;
	$.get(url, function(data){
		$("#termsDetail").html(data);
		location.href = "#";
		return false;
	});
});
/*
// 비즈니스 메인에서만 사용
$(function(){
	bizChartSel();
});

*/

function bizChartSel(){
	var chartImg = $(".chartBg");
	var chartBox = $("#uiValue");
	var chartLeftImg = "/_ui/mobile/images/main/chart_bg_left.png";
	var chartRightImg = "/_ui/mobile/images/main/chart_value_right.png";
	var targetValue = $(".pieValue strong").text();
	var lastPer = targetValue *3.6;

	if (targetValue <= 50) {
		$(chartImg).attr("src",chartLeftImg);
	} else{
		$(chartImg).attr("src",chartRightImg);
	}
	$(chartBox).jangle({
		continuous: false,
		degrees: lastPer
	});
}

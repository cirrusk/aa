(function($) {
	$.rdSolution = {
			data : {
				  mrdPath : ""
				, mrdParam : ""
				, serverUrl : ""
				, xml : ""
			},
			rdopen : function()
		    {
		        if (navigator.appVersion.indexOf("MSIE 9") != -1 ||navigator.appVersion.indexOf("MSIE 8") != -1 || navigator.appVersion.indexOf("MSIE 7") != -1){
		        	$.rdSolution.pdfopen(); // IE 버전이 7,8,9 일때에는 PDF 요청 function
		        }else{
		        	$.rdSolution.html5open(); // 그 외 일 경우에는 HTML5 Viewer를 open하는 function
		        }
		    },
			html5open : function()
		    {
		        var div1 = document.getElementById("crownix-viewer"); //html5 viewer를 위한 영역을 가로,세로 100%씩 적용
		        div1.style.width='100%';

		        if(location.href.indexOf("/estimate-sheet/") != -1 || location.href.indexOf("/faxorder-sheet/") != -1){
		        	div1.style.height='94%'; // 견적서
		        }else{
		        	div1.style.height='100%';
		        }

		        var viewer = new m2soft.crownix.Viewer($.rdSolution.data.serverUrl, 'crownix-viewer'); //html5 viewer 객체 삽입
		        
		        m2soft.crownix.Layout.setTheme('blue'); // 테마는 파랑.
		        viewer.setRData($.rdSolution.data.xml);
		        viewer.openFile($.rdSolution.data.mrdPath, $.rdSolution.data.mrdParam); // html5 viewer 객체 보고서 오픈
		        viewer.hideToolbarItem (["xls","ppt","doc","hwp"]);

		        $("#btnPrint").show();
		        $("#btnOrder").show();
		    },
		    pdfopen : function()
		    {
		        var iframe1 = document.getElementById("pdfframe"); //PDF를 위한 영역을 가로,세로 100%씩 적용
		        iframe1.style.width='100%';
		        
		        if(location.href.indexOf("/estimate-sheet/") != -1){
		        	iframe1.style.height='94%'; // 견적서
		        }else{
		        	iframe1.style.height='100%';
		        }	        

		        var form = document.getElementById("form1");
		        form.opcode.value="500"; //500 고정
		        form.mrd_path.value=$.rdSolution.data.mrdPath;
		        form.mrd_data.value=$.rdSolution.data.xml;
		        form.mrd_param.value="/rpdfcodepage [utf-8]"

		        if($.rdSolution.data.mrdParam.length > 0) {
		        	form.mrd_param.value += " " + $.rdSolution.data.mrdParam;
		        }

		        form.export_type.value="pdf"; // 변환타입 pdf 고정
		        form.protocol.value="file"; // 프로토콜은 고정
		        form.submit(); // 요청을 주면 PDF가 리턴 됨.

		        $("#btnPrint").hide();
		        $("#btnOrder").show();
		    }			
	}

    // 견적서 주문하기
    $(document).off("click", "#btnOrder").on("click", "#btnOrder", function(e){
        if(confirm(opener.$.estimate.msg.orderConfirm)){
            opener.$.estimate.data.xml = $.rdSolution.data.xml;
            opener.$.estimate.order($(this).attr("data-code"));
            window.close();
        }
        return false;
    }); 

    // 견적서 인쇄
    $(document).off("click", "#btnPrint").on("click", "#btnPrint", function(e){
        $("#print_pdf").trigger("click");
        if(opener.$.estimate) {
            opener.$.estimate.list.setData($("#btnOrder").attr("data-code"), "print");	
        }
    });

})(jQuery);
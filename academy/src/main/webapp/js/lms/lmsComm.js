	// 상세보기전 접속 권한 체크 -  과정구분,교육시작 
	function fnAccesViewClick(courseidVal, callerMenu, searchVal) {
		//callerMenu :: main-메인페이지, eduResource-교육자료, request - 통합교육신청, -그외서브메뉴 

		var datatypeVal = "";
		if(callerMenu == "eduEduResource") {
			var arrSearch = searchVal.split('|');
			if(arrSearch.length > 1) {
				datatypeVal = arrSearch[1];
			}
		}

		var params = {courseid:courseidVal, datatype:datatypeVal};
		$.ajax({
			url : "/lms/authViewDataEvent.do",
			method : "POST",
			cache: false ,
			data : params,
			success : function(data, textStatus, jqXHR) {
				
				if(parseInt(data.sCode) > 0  && parseInt(data.sCode) < 10) {
					if( data.sCode == "1") {
						// 온라인강의 링크
						//var winobj = window.open(data.sLink2, 'onlineView','toolbar=0, menubar=no');
						var winobj = window.open(data.sLink+"?courseid="+data.sCourseid, '_blank','toolbar=0, menubar=no');
					} else if( data.sCode == "3") {
						// 교육자료 링크
						parent.location.href = data.sLink2;
					} else {
						// 상세보기 링크
						if(callerMenu == "request"){ // 정규,오프,라이브 목록인 경우
							goViewLink(data.sCode, data.sMsg, data.sCourseid, data.sLink);
						}else{
							parent.location.href = data.sLink2;
						}
					}
				} else if(parseInt(data.sCode) > 10  && parseInt(data.sCode) < 15) {
					//약관동의
					parent.location.href = data.sLink2;
				} else if(parseInt(data.sCode) > 15  && parseInt(data.sCode) < 20) {
					// 다른 링크
					goViewLink(data.sCode, data.sMsg, data.sCourseid, data.sLink);
				} else if(parseInt(data.sCode) > 20  && parseInt(data.sCode) < 40) {
					// 링크가 없다. 메세지처리
					alert(data.sMsg);
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
			
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}

	// 교육자료 상세보기전 접속 권한 체크 -  교육자료메뉴, 교육자료상세 에서만 사용한다
	function fnAccesEduView(courseidVal, searchVal) {
		
		var datatypeVal = "";
		var sortColumnVal = "";
		var searchTypeVal = "";
		var searchTxtVal = "";
		var currPageVal = "";
		var arrSearch = searchVal.split('|');
		if(arrSearch.length > 1) {
			datatypeVal = arrSearch[1];
			sortColumnVal = arrSearch[2];
			searchTypeVal = arrSearch[3];
			searchTxtVal = arrSearch[4];
			currPageVal = arrSearch[5];
		}

		var params = {courseid:courseidVal, datatype:datatypeVal, sortColumn:sortColumnVal, searchType:searchTypeVal, searchTxt:searchTxtVal, currPage:currPageVal};
		$.ajax({
			url : "/lms/authViewDataEvent.do",
			method : "POST",
			cache: false ,
			data : params,
			success : function(data, textStatus, jqXHR) {
				if(parseInt(data.sCode) > 0  && parseInt(data.sCode) < 10) {
					if( data.sCode == "3") {
						// 교육자료 링크
						//parent.location.href = data.sLink2;
						goViewLink(data.sCode, data.sMsg, data.sCourseid, data.sLink); 
					}
				} else if(parseInt(data.sCode) > 10  && parseInt(data.sCode) < 15) {
					//약관동의
					parent.location.href = data.sLink2;
				} else if(parseInt(data.sCode) > 15  && parseInt(data.sCode) < 20) {
					// 다른 링크
					goViewLink(data.sCode, data.sMsg, data.sCourseid, data.sLink);
				} else if(parseInt(data.sCode) > 20  && parseInt(data.sCode) < 40) {
					// 링크가 없다. 메세지처리
					alert(data.sMsg);
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
			
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}

	
	//좋아요 선택시 이벤트 단일.
	function likeitemClick(courseidVal, lablenm, levelVal) {
		var params = {courseid:courseidVal};
		
		$.ajax({
			url : "/lms/likecountEvent.do",
			method : "POST",
			cache: false ,
			data : params,
			success: function(data, textStatus, jqXHR) {
				if(data.sCode == "1") { 			// count
					if(lablenm!="") {
						$("#"+lablenm).html(data.cntMsg);
						//바로 위의 클래스 값을 변경할 것
						//$("#"+lablenm).prev().attr("class","like on");
						if( levelVal == "1" ) {
							$("#"+lablenm).parent().addClass(" on");
						} else {
							$("#"+lablenm).prev().addClass(" on");
						}
						
					}
					alert(data.sMsg);		//해당 자료를 추천하였습니다.
				} else if(data.sCode == "2") { // count되어있음
					alert(data.sMsg); 		//이미 추천하신 자료입니다.
				} else if(data.sCode == "3") {
					alert(data.sMsg); 		//Compliance 설정되어 추천 하실 수 없습니다.
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}

	//좋아요 선택시 이벤트 복수(ex,cntMsg:999+, cntFullMsg:12,345).
	function likeitemClickDual(courseidVal, lablenm, detaillab) {
		var params = {courseid:courseidVal};
		
		$.ajax({
			url : "/lms/likecountEvent.do",
			method : "POST",
			cache: false ,
			data : params,
			success: function(data, textStatus, jqXHR) {
				if(data.sCode == "1") { 			// count
					//var cnt = cellNumber(data.sMsg,"s");
					if(lablenm!="") { //간략
						$("#"+lablenm).html(data.cntMsg);
						$("#"+lablenm).parent().addClass(" on");
						//alert("id명:"+lablenm+" 값="+data.cntMsg);
					}
					if(detaillab!="") { //상세
						$("#"+detaillab).html(data.cntFullMsg);
						$("#"+detaillab).prev().addClass(" on");
					}
					alert(data.sMsg);		//해당 자료를 추천하였습니다.
				} else if(data.sCode == "2") { // count되어있음
					alert(data.sMsg); 		//이미 추천하신 자료입니다.
				} else if(data.sCode == "3") {
					alert(data.sMsg); 		//Compliance 설정되어 추천 하실 수 없습니다.
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}
	
	//자료실 선택시 이벤트 (목록)
	function depositClick(courseidVal, lablenm) {
		var params = {courseid:courseidVal};
		
		$.ajax({
			url : "/lms/depositEvent.do",
			method : "POST",
			cache: false ,
			data : params,
			success : function(data, textStatus, jqXHR) {
				if(data.sCode == "1") { 			
					if(lablenm!="") {
						$("#"+lablenm).addClass(" on");
					}
					alert(data.sMsg);		//해당 자료가 보관함에 추가되었습니다.
				} else if(data.sCode == "2") { 
					if(lablenm!="") {
						$("#"+lablenm).removeClass(" on");
					}
					alert(data.sMsg); 		//해당 자료가 보관함에서 삭제되었습니다
				} else if(data.sCode == "3") {
					alert(data.sMsg); 		//Compliance 설정되어 보관함에 추가 하실 수 없습니다.
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
			
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}

	//자료실 선택시 이벤트 (상세보기)
	function depositViewClick(courseidVal, lablenm) {
		var params = {courseid:courseidVal};
		
		$.ajax({
			url : "/lms/depositEvent.do",
			method : "POST",
			cache: false ,
			data : params,
			success : function(data, textStatus, jqXHR) {
				if(data.sCode == "1") { 		
					if(lablenm!="") {
						$("#"+lablenm).css("background-position","0 0");
					}
					alert(data.sMsg);		//해당 자료가 보관함에 추가되었습니다.
				} else if(data.sCode == "2") { 
					if(lablenm!="") {
						$("#"+lablenm).css("background-position","100% 0");
					}
					alert(data.sMsg); 		//해당 자료가 보관함에서 삭제되었습니다
				} else if(data.sCode == "3") {
					alert(data.sMsg); 		//Compliance 설정되어 보관함에 추가 하실 수 없습니다.
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
			
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}
	
	function fnSessionCall( popupVal ) {
		//세션 정보 끊김에 의한 특정 페이지 호출할 것
		if( popupVal == "Y" ) {
			opener.location.href = "/lms/common/session.do";
			top.close();
		}else{
			location.href = "/lms/common/session.do";
		}
		//하이브리스 특정 페이지 호출할 것
		
	}
	
	function dataMask(data,type) {	
		var regular = /[^0-9]/;
		var form = "";
		//이름일 경우 마스킹
		if(type == "name")
			{	
				var mask = "";
				for(var i=0;i<data.length - 2;i++)
					{
						mask += "*";
					}
				regular = /([가-힣])[가-힣]+([가-힣])/;
				form = "$1"+mask+"$2";
				data = data.replace(regular,form);
				return data;
			}
		//ABO번호일 경우 마스킹
		 else if(type == "uid")
			{
				regular = /([0-9]+)[0-9]{4}/;
				form = "$1****";
				data = data.replace(regular,form);
				return data;
			} 
	}
	
    //상단에 포커스 이동시키기
    var fnAnchor = function() {
    	$("#pbContent").attr("tabindex",-1).focus();
    }
    

	//회원등급 조회. 
	// 		- lablenm : 라벨id  		- rtnType : 'css' 스타일쉬트등록, 'alert' 안내창문구, 'rtnFn' 호출한곳의 함수호출(함수생성-빈 함수라도)
	function fnMemberGrade(lablenm, rtnType) {
		var params = { };
		
		$.ajax({
			url : "/lms/getItemMemberGrade.do",
			method : "POST",
			cache: false ,
			data : params,
			success: function(data, textStatus, jqXHR) {
				if(data.sCode == "1") { 			// 등급리턴
					if(rtnType == "css") {
						if(lablenm != "") { $("#"+lablenm).addClass(data.sMsg); }
					} else if(rtnType == "alert") {
						alert("회원등급 : "+data.sMsg);
					} else if(rtnType == "rtnFn") {
						fnRtnMemberGrade(data.sMsg);
					}
					
				} else if(data.sCode == "2") { // 등급이 없다
					if(rtnType == "alert") { alert("회원등급 : "+data.sMsg); }
					
				} else if(data.sCode == "0") { // 계정이 없다
					if(rtnType == "alert") { alert(data.sMsg); }
					
				}
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}

	
	function openAmwayGoInfo(){
		window.open("/lms/common/lmsAmwayGoInfo.do","amwaygoinfo","width=600, height=410, scrollbars=no, menubar=no, status=no");
	}

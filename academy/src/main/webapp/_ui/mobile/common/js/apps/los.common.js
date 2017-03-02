(function($) {; 
	$.losCommon ={
			data : {
				ALERT_MSG_AUTH_PT 	: "해당 서비스는 PT 이상 이용하실 수 있습니다."
			},
			callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data     : data,
					success: function (data){
						if( typeof successCallBack === 'function' ) { successCallBack(data); }
						return false;
					},
					error: function(xhr, st, err){
						xhr = null;
						// alert(err);
						if( typeof errorCallBack === 'function' ) { 
							errorCallBack(); 
						} else {
							alert($.msg.err.system);
						}
						return false;
					}
				});
			},
			getHeaderText : function(header){
				switch(header){
					case  "PV" :
						return "개인PV";
					case  "BV" :
						return "개인BV";
					case  "GROUP_PV" :
						return "그룹PV";
					case  "GROUP_BV" :
						return "그룹BV";
					case  "Q_LEG" :
						return "Q레그 수";
					case "PERSONAL_ORDER" :
						return "개인주문금액(수)";
					case "personalOrderAmt" :
						return "개인주문금액";
					case "personalOrderCount" :
						return "개인주문 수";
					case "PERSONAL_AMOUNT" :
						return "반품주문금액(수)";
					case "personalReturnAmt" :
						return "반품주문금액";
					case "personalReturnCount" :
						return "반품주문 수";
					case "ACHIEVE_RATE" :
						return "현재달성률";
					case "NEXT_ACHIEVE_RATE" :
						return "차기달성률";
					case  "GOAL_RATE" :
						return "목표달성률";
					case  "DISTRICT" :
						return "지역";
					case  "REGIST_DATE" :
						return "가입일";
					case  "REGIST_DATE_NEW" :
						return "가입일";
					case  "INTER_SPONSOR_YN" :
						return "국제후원자여부(대리후원)";
					case  "PIN" :
						return "현재 핀";
					case  "HIGHEST_PIN" :
						return "최고달성 핀";
					case  "sponsor" :
						return "후원자";
					case  "foreigner" :
						return "외국인 구분";
					case  "visaContry" :
						return "비자국가";
					case  "visaType" :
						return "비자타입";
					case  "expiredDate" :
						return "만료일";
					case  "businessDistrict" :
						return "지역";
					case  "renewal" :
						return "갱신여부";
					case  "renewalMethod" :
						return "갱신방법";
					case  "travelNo" :
						return "여행차수";
					case  "travelCurrentTP" :
						return "여행점수";
					case  "travelTargetTP" :
						return "목표여행 점수";
					case  "travelPercent" :
						return "여행점수 달성률";
					case  "RENEWAL_TYPE" :
						return "리뉴얼여부";
					default :
						return header;
				
				}
			},
			getUserGroupToNumber : function (userGroup){
				if(userGroup == null){
					return "0"
				}
				userGroup = userGroup.toLowerCase();
				if(userGroup.indexOf("member") > -1){
					return "0";
				}else if(userGroup.indexOf("silver") > -1){
					if(userGroup.indexOf("sponsor") > -1){
						return 2;
					}else{
						return 3;
					}
				}else if(userGroup.indexOf("platinum") > -1){
					if(userGroup.indexOf("founders") > -1){
						return 6;
					}else{
						return 4;
					}							
				}else if(userGroup.indexOf("ruby") > -1){
					return 5;
				}else if(userGroup.indexOf("sapphire") > -1){
					if(userGroup.indexOf("founders") > -1){
						return 8;
					} else {
						return 7;
					}
				} else if(userGroup.indexOf("emerald") > -1){
					if(userGroup.indexOf("founders") > -1){
						return 10;
					} else {
						return 9;
					}
				}else if(userGroup.indexOf("diamond") > -1){
					if(userGroup.indexOf("executive") > -1){
						if(userGroup.indexOf("founders") > -1){
							return 14;
						}else{
							return 13;
						}						
					}else if(userGroup.indexOf("double") > -1){
						if(userGroup.indexOf("founders") > -1){
							return 16;
						}else{
							return 15;
						}						
					}else if(userGroup.indexOf("triple") > -1){
						if(userGroup.indexOf("founders") > -1){
							return 18;
						}else{
							return 17;
						}						
					}else if(userGroup.indexOf("founders") > -1){
						return 12;
					}else{
						return 11;
					}
				}else if(userGroup.indexOf("crown") > -1){
					if(userGroup.indexOf("ambassador") > -1){
						if(userGroup.indexOf("founder") > -1){
							if(userGroup.indexOf("40") > -1){
								return 23;
							}else if(userGroup.indexOf("50") > -1){
								return 24;
							}else if(userGroup.indexOf("60") > -1){
								return 25;
							}else{
								return 22;
							}
						}else {
							return 21;
						}
						
					}else{
						if(userGroup.indexOf("founders") > -1){
							return 20;
						}else {
							return 19;
						}
					}	
				} else {
					return 1;
				}					
		      
			},
			setHeader : function (targetLosmap, isGrid, mapWidth, firstWidth ,headerList, headerListHidden){
				
				var headerString = "LOS";
				for(i=0 ; i<headerList.length;i++){
					headerString += "," + $.losCommon.getHeaderText(headerList[i]);
				}
				for(i=0 ; i<headerListHidden.length  ;i++){
					headerString += "," + headerListHidden[i];
				}
				
				var headerStyle = [];
				headerStyle.push("text-align:left;");
				for(i=0 ; i<headerList.length + headerListHidden.length ;i++){
					headerStyle.push("text-align:center;");
				}
				
				targetLosmap.setHeader(headerString,null,headerStyle);
				
				var initWidths = firstWidth;
				for(i=0 ; i<headerList.length + headerListHidden.length ;i++){
					initWidths += "," + "101";
				}
				targetLosmap.setInitWidths(initWidths);
				
			
				
				var align = "left";
				for(i=0 ; i<headerList.length + headerListHidden.length ;i++){
					if(headerList[i] == "travelCurrentTP" || headerList[i] == "travelTargetTP" ){
						align += "," + "right"
					}else{
						align += "," + "center"
					}
				}
				targetLosmap.setColAlign(align);
				
				if(isGrid){
					var types = "txt";
				}else{
					var types = "tree";
				}
				for(i=0 ; i<headerList.length + headerListHidden.length ;i++){
					types += "," + "txt"
				}
				targetLosmap.setColTypes(types);
				
				targetLosmap.setCustomSorting($.losCommon.sort_title_custom,0);
				for(i=0 ; i<headerList.length ;i++){
					if(headerList[i] == "sposor"){
						targetLosmap.setCustomSorting($.losCommon.sort_title_custom,i+1);
					}else if (headerList[i] == "REGIST_DATE"  || headerList[i] == "REGIST_DATE_NEW" || headerList[i] == "expiredDate"){
						targetLosmap.setCustomSorting($.losCommon.sort_date_custom,i+1);
					}else{
						targetLosmap.setCustomSorting($.losCommon.sort_custom,i+1);
					}
									
				}
				
				for(i=headerList.length+1; i <headerList.length + headerListHidden.length+1 ; i++){
					targetLosmap.setColumnHidden(i,true);
				}
			},
			isAbovePT : function (userGroup){
				if( $.losCommon.getUserGroupToNumber(userGroup)>= 4){
					return true;
				}else{
					return false;
				}
				
			},
			numberWithCommas : function (x) {
			    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			},
			sort_custom : function (a,b,order){
				
				var n;
				var m;
				if(a.indexOf(">") > -1){
					n = a.indexOf(">");
					a = a.substring(n+1);
				}
			    
				if(b.indexOf(">") > -1){
					m = b.indexOf(">");
					b = b.substring(m+1);	
				}	    
			    
				if(a.indexOf("(") > -1){
					 n = a.indexOf("(");
					 a = a.substring(0,n);
				}
			   
				if(b.indexOf("(") > -1){
					m = b.indexOf("(");
					b = b.substring(0,m);
				}		    
			    
			    a = a.replace(/\,/g, '');
			    b = b.replace(/\,/g, '');
			    
			    a = a.replace(/\%/g, '');
			    b = b.replace(/\%/g, '');
			    
			    a *= 1;
			    b *= 1;    
		    
			    if(order=="asc")
			        return a>b?1:-1;
			    else
			        return a<b?1:-1;		    
			 
			},
			
			sort_title_custom : function (a,b,order){
			    var n = a.indexOf(">");
			    var m = b.indexOf(">");
			    
			    a = a.substring(n);
			    b = b.substring(m);
			    
			    if(order=="asc")
			        return a>b?1:-1;
			    else
			        return a<b?1:-1;
			},
			sort_date_custom : function (a,b,order){
				a=a.split("-")
			    b=b.split("-")
			    
			     a[0] *=1;
				 a[1] *=1;
				 a[2] *=1;
				 b[0] *=1;
				 b[1] *=1;
				 b[2] *=1;
				 
				 if (a[0]==b[0]){
			        if (a[1]==b[1])
			            return (a[2]>b[2]?1:-1)*(order=="asc"?1:-1);
			        else
			            return (a[1]>b[1]?1:-1)*(order=="asc"?1:-1);
			    } else
			        return (a[0]>b[0]?1:-1)*(order=="asc"?1:-1);
			},
			
			sort_new_date_custom : function (a,b,order){
				 a=a.split("월");
				 a[1] = a[1].replace("일","");
				 
				 b=b.split("월");
				 b[1] = b[1].replace("일","");
				 
				 a[0] *=1;
				 a[1] *=1;
				 b[0] *=1;
				 b[1] *=1;
				 
				 if (a[0]==b[0])
				    return (a[1]>b[1]?1:-1)*(order=="asc"?1:-1);
				 else
				    return (a[0]>b[0]?1:-1)*(order=="asc"?1:-1);
			},
			
			getFormattedDate : function(date) {
		            return date.getFullYear()
		                + '-' + $.losCommon.pad( date.getMonth() + 1 )
		                + '-' + $.losCommon.pad( date.getDate() );		                
		    },
		    pad : function(number) {
	            var r = String(number);
	            if ( r.length === 1 ) {
	                r = '0' + r;
	            }
	            return r;
	        } 
	}
	
})(jQuery);	

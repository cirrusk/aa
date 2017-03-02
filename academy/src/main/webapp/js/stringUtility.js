var stringUtility = {
		
    /*
     * 해당 입력필드에 숫자만 기입 가능
     * onkeydown='return stringUtility.onlyNumber(event)'
     * */
	onlyNumber : function(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 9) 
			return;
		else
			return false;
	},
	
	/*
	 * 해당 입력필드에 한글 삭제
	 * onkeyup='stringUtility.removeChar(event)'
	 * */
	removeChar : function(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
	},
	
	/*
	 * 문자열 중 일부 문자 치환
	 */
	replaceAll : function(str, searchStr, replaceStr) {
		return str.split(searchStr).join(replaceStr);
	},
	
	/*
	 * trim - replace(/^\s+|\s+$/g, "") 
	 */
	trim : function(str, searchStr, replaceStr){
		return this.replaceAll(str, " ", "");
	}
}

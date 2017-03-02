/**
 * 회원가입 단계별 프로세스
 */

// 인증
var certify = function(){
	this.oCertify = null;
	this._status = 0; // 인증여부
	this.oElement = null; // 인증 체크 로직을 실행하는  element
	this.observerElements = new Array(); // 값으 변경될 경우 인증을 초기화 하는 element's
	this.fn_InitCertify = function(){}; // 인증값을 초기화할 경우
	this.fn_ObserverInit = function(){};
	this.fn_CheckCertify = function(){return true;}; // 인증 체크하는 로직
	this.fn_SuccessCertify = function(){this.setStatus(true);} // 인증 성공 시
	
	// 초기값을 구성한다.
	this.initialize.apply(this, arguments);
}

$.extend(certify.prototype, {
	initialize: function(data){
		if(data.oCertify){
			this.oCertify = data.oCertify;
		}
		
		if(data.initCertify){
			this.fn_InitCertify = data.initCertify;
		}
		
		if(data.observerInit){
			this.fn_ObserverInit = data.observerInit;
		}
		
		if(data.observer){
			var sub = this;
			for(var i=0; i < data.observer.length; i++){
				var element = data.observer[i];
				if(element.prop("tagName") == "INPUT"){
//					element.bind("keyup click", function(){
					element.bind("keyup", function(){
						sub.observerInit.call(sub);
					});
				}else if(element.prop("tagName") == "SELECT"){
					element.bind("change", function(){
						sub.observerInit.call(sub);
					});
				}else{
					element.bind("click", function(){
						sub.observerInit.call(sub);
					});					
				}
				
			}
		}
		
		if(data.checkCertify){
			this.fn_CheckCertify = data.checkCertify;
		}
		
		if(data.successCertify){
			this.fn_SuccessCertify = data.successCertify;
		}
		
		if(data.oElement){
			var sub = this;
			this.oElement = data.oElement;
			//console.log("this--", this.oElement);
			this.oElement.on("click", function(){
				sub.processCertify.call(sub, this);
			});
		}
		
		// 인증 초기화하는 로직이 있을 경우
		if(data.init){
			data.init.apply(this);
		}		
	},
	getCertifyElement : function(){
		return this.oCertify;
	},
	getStatus : function(){
		return this._status == 1 ? true : false;
	},
	setStatus : function(bStatus){
		this._status = bStatus ? 1 : 0;
	},
	applyInitCertify : function(){
		//console.log("----- InitCertify -----");
		this.setStatus(false);
		this.fn_InitCertify.call(this);
	},
	observerInit : function(){
		this.setStatus(false);
		this.fn_ObserverInit.call(this);
	},
	processCertify : function(element){
		//console.log("-- processCertify start--");
		if(this.fn_CheckCertify(element)){
			this.setStatus(true);
			this.fn_SuccessCertify(element);
			//console.log("-- Success process --");
		}
		//console.log("-- processCertify end--");
	}
});
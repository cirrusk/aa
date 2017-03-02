
//jQuery.noConflict();
(function($){
	$(function(){
		// More code using $ as alias to jQuery		
		
		//select
		/*
		if($('select').length){
			$('select').customSelect();
		}
		*/
		if($('select.round').length){
			$('select.round').customSelect();
		}
	});//ready
	
	// select : customSelect
	(function(a){a.fn.extend({customSelect:function(c){if(typeof document.body.style.maxHeight==="undefined"){return this}var e={customClass:"customSelect",mapClass:true,mapStyle:true},c=a.extend(e,c),d=c.customClass,f=function(h,k){var g=h.find(":selected"),j=k.children(":first"),i=g.html()||"&nbsp;";j.html(i);if(g.attr("disabled")){k.addClass(b("DisabledOption"))}else{k.removeClass(b("DisabledOption"))}setTimeout(function(){k.removeClass(b("Open"));a(document).off("mouseup."+b("Open"))},60)},b=function(g){return d+g};return this.each(function(){var g=a(this),i=a("<span />").addClass(b("Inner")),h=a("<span />");g.after(h.append(i));h.addClass(d);if(c.mapClass){h.addClass(g.attr("class"))}if(c.mapStyle){h.attr("style",g.attr("style"))}g.addClass("hasCustomSelect").on("update",function(){f(g,h);var k=parseInt(g.outerWidth(),10)-(parseInt(h.outerWidth(),10)-parseInt(h.width(),10));h.css({display:"inline-block"});var j=h.outerHeight();if(g.attr("disabled")){h.addClass(b("Disabled"))}else{h.removeClass(b("Disabled"))}i.css({width:k,display:"inline-block"});g.css({"-webkit-appearance":"menulist-button",width:h.outerWidth(),position:"absolute",opacity:0,height:j,fontSize:h.css("font-size")})}).on("change",function(){h.addClass(b("Changed"));f(g,h)}).on("keyup",function(j){if(!h.hasClass(b("Open"))){g.blur();g.focus()}else{if(j.which==13||j.which==27){f(g,h)}}}).on("mousedown",function(j){h.removeClass(b("Changed"))}).on("mouseup",function(j){if(!h.hasClass(b("Open"))){if(a("."+b("Open")).not(h).length>0&&typeof InstallTrigger!=="undefined"){g.focus()}else{h.addClass(b("Open"));j.stopPropagation();a(document).one("mouseup."+b("Open"),function(k){if(k.target!=g.get(0)&&a.inArray(k.target,g.find("*").get())<0){g.blur()}else{f(g,h)}})}}}).focus(function(){h.removeClass(b("Changed")).addClass(b("Focus"))}).blur(function(){h.removeClass(b("Focus")+" "+b("Open"))}).hover(function(){h.addClass(b("Hover"))},function(){h.removeClass(b("Hover"))}).trigger("update")})}})})(jQuery);

	/*
	 * jquery-filestyle
	 * http://dev.tudosobreweb.com.br/jquery-filestyle/
	 *
	 * Copyright (c) 2013 Markus Vinicius da Silva Lima
	 * Version 0.1.3
	 * Licensed under the MIT license.
	 */
	(function(c){var a=function(d,e){this.options=e;this.$elementjFilestyle=[];this.$element=c(d)};a.prototype={clear:function(){this.$element.val("");this.$elementjFilestyle.find(":text").val("")},destroy:function(){this.$element.removeAttr("style").removeData("jfilestyle").val("");this.$elementjFilestyle.remove()},icon:function(d){if(d===true){if(!this.options.icon){this.options.icon=true;this.$elementjFilestyle.find("label").prepend(this.htmlIcon())}}else{if(d===false){if(this.options.icon){this.options.icon=false;this.$elementjFilestyle.find("i").remove()}}else{return this.options.icon}}},input:function(d){if(d===true){if(!this.options.input){this.options.input=true;this.$elementjFilestyle.prepend(this.htmlInput());var e="",f=[];if(this.$element[0].files===undefined){f[0]={name:this.$element[0].value}}else{f=this.$element[0].files}for(var g=0;g<f.length;g++){e+=f[g].name.split("\\").pop()+", "}if(e!==""){this.$elementjFilestyle.find(":text").val(e.replace(/\, $/g,""))}}}else{if(d===false){if(this.options.input){this.options.input=false;this.$elementjFilestyle.find(":text").remove()}}else{return this.options.input}}},buttonText:function(d){if(d!==undefined){this.options.buttonText=d;this.$elementjFilestyle.find("label span").html(this.options.buttonText)}else{return this.options.buttonText}},iconName:function(d){if(d!==undefined){this.options.iconName=d;if(this.options.theme.search(/blue|green|red|orange|black/i)!==-1){this.$elementjFilestyle.find("label").find("i").attr({"class":"icon-white "+this.options.iconName})}else{this.$elementjFilestyle.find("label").find("i").attr({"class":this.options.iconName})}}else{return this.options.iconName}},size:function(d){if(d!==undefined){this.options.size=d;this.$elementjFilestyle.find(":text").css("width",this.options.size)}else{return this.options.size}},htmlIcon:function(){if(this.options.icon){var d="";if(this.options.theme.search(/blue|green|red|orange|black/i)!==-1){d=" icon-white "}return'<i class="'+d+this.options.iconName+'"></i> '}else{return""}},htmlInput:function(){if(this.options.input){return'<input type="text" style="width:'+this.options.size+'" disabled> '}else{return""}},constructor:function(){var f=this,d="",g=this.$element.attr("id"),e=[];if(g===""||!g){g="jfilestyle-"+c(".jquery-filestyle").length;this.$element.attr({id:g})}d=this.htmlInput()+'<label for="'+g+'">'+this.htmlIcon()+"<span>"+this.options.buttonText+"</span></label>";this.$elementjFilestyle=c('<div class="jquery-filestyle '+this.options.theme+'" style="display: inline;">'+d+"</div>");this.$element.css({position:"fixed",left:"-500px"}).after(this.$elementjFilestyle);this.$element.change(function(){var h="";if(this.files===undefined){e[0]={name:this.value}}else{e=this.files}for(var j=0;j<e.length;j++){h+=e[j].name.split("\\").pop()+", "}if(h!==""){f.$elementjFilestyle.find(":text").val(h.replace(/\, $/g,""))}});if(window.navigator.userAgent.search(/firefox/i)>-1){this.$elementjFilestyle.find("label").click(function(){f.$element.click();return false})}}};var b=c.fn.jfilestyle;c.fn.jfilestyle=function(e,d){var g="",f=this.each(function(){if(c(this).attr("type")==="file"){var i=c(this),j=i.data("jfilestyle"),h=c.extend({},c.fn.jfilestyle.defaults,e,typeof e==="object"&&e);if(!j){i.data("jfilestyle",(j=new a(this,h)));j.constructor()}if(typeof e==="string"){g=j[e](d)}}});if(typeof g!==undefined){return g}else{return f}};c.fn.jfilestyle.defaults={buttonText:"Choose file",input:true,icon:true,size:"200px",iconName:"icon-folder-open",theme:""};c.fn.jfilestyle.noConflict=function(){c.fn.jfilestyle=b;return this};c(".jfilestyle").each(function(){var e=c(this),d={buttonText:e.attr("data-buttonText"),input:e.attr("data-input")==="false"?false:true,icon:e.attr("data-icon")==="false"?false:true,size:e.attr("data-size"),iconName:e.attr("data-iconName"),theme:e.attr("data-theme")};e.jfilestyle(d)})})(window.jQuery);

})(jQuery);
// Other code using $ as an alias to the other library





	





NetFunnel.SkinUtil.add('order',{
	htmlStr:' \
		<div id="NetFunnel_Skin_Top" style="background-color:#ffffff;border:1px solid #9ab6c4;overflow:hidden;width:250px;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;" > \
		<div style="background-color:#ffffff;border:6px solid #eaeff3;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;"> \
			<div style="text-align:right;padding-top:5px;padding-right:5px;line-height:25px;"> \
			</div>\
			<div style="padding-top:5px;padding-left:5px;padding-right:5px"> \
				<div style="text-align:center;font-size:12pt;color:#001f6c;height:22px"><b><span style="color:#013dc1">접속대기 중</span>입니다.</b></div> \
				<div style="text-align:right;font-size:9pt;color:#4d4b4c;padding-top:4px;height:17px;"><b>예상시간 : <span id="NetFunnel_Loading_Popup_TimeLeft" class="%M분 %02S초^ ^false"></span></b></div> \
				<div style="padding-top:6px;padding-bottom:6px;vertical-align:center;width:228px" id="NetFunnel_Loading_Popup_Progressbar"></div> \
				<div style="background-color:#ededed;padding-bottom:8px;overflow:hidden;width:228px"> \
					<div style="padding-left:5px"> \
						<div style="text-align:center;font-size:8pt;color:#4d4b4c;padding:3px;padding-top:10px;padding-bottom:10px;height:10px">앞에 <b><span style="color:#2a509b"><span id="NetFunnel_Loading_Popup_Count" class="다수"></span></span></b> 명, 뒤에 <b><span style="color:#2a509b"><span id="NetFunnel_Loading_Popup_NextCnt" class="다수"></span></span></b> 명의 대기자가 있습니다.</div> \
						<div style="text-align:center;font-size:8pt;color:#4d4b4c;padding:3px;height:12px">현재 접속자가 많아 대기 중이며</div> \
						<div style="text-align:center;font-size:8pt;color:#4d4b4c;padding:3px;height:10px;">잠시만 기다리시면</div> \
						<div style="text-align:center;font-size:8pt;color:#4d4b4c;padding:3px;height:10px;">서비스로 자동 접속 됩니다.</div> \
						<div style="text-align:left;font-size:8pt;color:#ff0000;padding:3px;height:10px;"><b>기다리시는 동안 해당 제품이 조기 품절될 수 있습니다.</b></div> \
						<div style="text-align:center;font-size:9pt;color:#2a509b;padding-top:10px;"> \
							<b>[<span id="NetFunnel_Countdown_Stop" style="cursor:pointer">중지</span>]</b> \
						</div> \
					</div> \
				</div> \
			<div style="height:5px;"></div> \
		</div> \
	</div>'
},'mobile');

NetFunnel.skinOrder = '\
	<div id="NetFunnel_Skin_Top" style="background-color:#ffffff;border:1px solid #9ab6c4;width:458px;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;"> \
		<div style="background-color:#ffffff;border:6px solid #eaeff3;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;"> \
			<div style="text-align:right;padding-top:5px;padding-right:5px;line-height:25px;"> \
			<b><span id="NetFunnel_Loding_Popup_Debug_Alerts" style="text-align:left;color:#ff0000"></span></b> \
			<span style="text-align:right;"><a href="'+NetFunnel.gLogoURL+'" target="_blank" style="cursor:pointer;text-decoration:none;">';

if((NetFunnel.BrowserDetect.browser == "Explorer" && NetFunnel.BrowserDetect.version == "6" ) ||  NetFunnel.gLogoData == ""){
	NetFunnel.skinOrder += '<b style="font-size:12px;">'+NetFunnel.gLogoText+'</b></a>';
}else{
	NetFunnel.skinOrder += '<b style="font-size:12px;">'+NetFunnel.gLogoText+'</b><img style="height:16px;color:black;font-size:11px;" border=0 src="data:image/gif;base64,'+NetFunnel.gLogoData+'" ></a>';
}
NetFunnel.skinOrder +=	'</span></div> \
			<div style="padding-top:0px;padding-left:25px;padding-right:25px"> \
				<div style="text-align:left;font-size:12pt;color:#001f6c;height:22px"><b>서비스 <span style="color:#013dc1">접속대기 중</span>입니다.</b></div> \
				<div style="text-align:right;font-size:9pt;color:#4d4b4c;padding-top:4px;height:17px" ><b>예상대기시간 : <span id="NetFunnel_Loading_Popup_TimeLeft" class="%H시간 %M분 %02S초^ ^false"></span></b></div> \
				<div style="padding-top:6px;padding-bottom:6px;vertical-align:center;width:400px;height:20px" id="NetFunnel_Loading_Popup_Progressbar"></div> \
				<div style="background-color:#ededed;width:400px;padding-bottom:8px;overflow:hidden"> \
					<div style="padding-left:5px"> \
						<div style="text-align:left;font-size:8pt;color:#4d4b4c;padding:3px;padding-top:10px;height:10px">고객님 앞에 <b><span style="color:#2a509b"><span id="NetFunnel_Loading_Popup_Count" class="다수"></span></span></b> 명, 뒤에 <b><span style="color:#2a509b"><span id="NetFunnel_Loading_Popup_NextCnt" class="다수"></span></span></b> 명의 대기자가 있습니다.  </div> \
						<div style="text-align:left;font-size:8pt;color:#4d4b4c;padding:3px;height:10px">현재 접속 사용자가 많아 대기 중이며, 잠시만 기다리시면 </div> \
						<div style="text-align:left;font-size:8pt;color:#4d4b4c;padding:3px;height:10px;">서비스로 자동 접속 됩니다.</div> \
						<div style="text-align:left;font-size:8pt;color:#ff0000;padding:3px;height:10px;"><b>기다리시는 동안 해당 제품이 조기 품절될 수 있습니다.</b></div> \
						<div style="text-align:center;font-size:9pt;color:#2a509b;padding-top:10px;"> \
							<b>※ 재 접속하시면 대기시간이 더 길어집니다. <span id="NetFunnel_Countdown_Stop" style="cursor:pointer">[중지]</span> </b> \
						</div> \
					</div> \
				</div> \
				<div style="height:5px;"></div> \
			</div> \
		</div> \
	</div>';
NetFunnel.SkinUtil.add('order',{htmlStr:NetFunnel.skinOrder},'normal');

NetFunnel.SkinUtil.add('default',{
	htmlStr:' \
		<div id="NetFunnel_Skin_Top" style="background-color:#ffffff;border:1px solid #9ab6c4;overflow:hidden;width:250px;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;" > \
		<div style="background-color:#ffffff;border:6px solid #eaeff3;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;"> \
			<div style="text-align:right;padding-top:5px;padding-right:5px;line-height:25px;"> \
			</div>\
			<div style="padding-top:5px;padding-left:5px;padding-right:5px"> \
				<div style="text-align:center;font-size:12pt;color:#001f6c;height:22px"><b><span style="color:#013dc1">접속대기 중</span>입니다.</b></div> \
				<div style="text-align:right;font-size:9pt;color:#4d4b4c;padding-top:4px;height:17px;" ><b>예상시간 : <span id="NetFunnel_Loading_Popup_TimeLeft" class="%M분 %02S초^ ^false"></span></b></div> \
				<div style="padding-top:6px;padding-bottom:6px;vertical-align:center;width:228px" id="NetFunnel_Loading_Popup_Progressbar"></div> \
				<div style="background-color:#ededed;padding-bottom:8px;overflow:hidden;width:228px"> \
					<div style="padding-left:5px"> \
						<div style="text-align:center;font-size:8pt;color:#4d4b4c;padding:3px;padding-top:10px;padding-bottom:10px;height:10px">앞에 <b><span style="color:#2a509b"><span id="NetFunnel_Loading_Popup_Count" class="다수"></span></span></b> 명, 뒤에 <b><span style="color:#2a509b"><span id="NetFunnel_Loading_Popup_NextCnt" class="다수"></span></span></b> 명의 대기자가 있습니다.</div> \
						<div style="text-align:center;font-size:8pt;color:#4d4b4c;padding:3px;height:12px">현재 접속자가 많아 대기 중이며</div> \
						<div style="text-align:center;font-size:8pt;color:#4d4b4c;padding:3px;height:10px;">잠시만 기다리시면</div> \
						<div style="text-align:center;font-size:8pt;color:#4d4b4c;padding:3px;height:10px;">서비스로 자동 접속 됩니다.</div> \
						<div style="text-align:center;font-size:9pt;color:#2a509b;padding-top:10px;"> \
							<b>[<span id="NetFunnel_Countdown_Stop" style="cursor:pointer">중지</span>]</b> \
						</div> \
					</div> \
				</div> \
			<div style="height:5px;"></div> \
		</div> \
	</div>'
},'mobile');

NetFunnel.skinDefault = '\
	<div id="NetFunnel_Skin_Top" style="background-color:#ffffff;border:1px solid #9ab6c4;width:458px;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;"> \
		<div style="background-color:#ffffff;border:6px solid #eaeff3;-moz-border-radius: 5px; -webkit-border-radius: 5px; -khtml-border-radius: 5px; border-radius: 5px;"> \
			<div style="text-align:right;padding-top:5px;padding-right:5px;line-height:25px;"> \
			<b><span id="NetFunnel_Loding_Popup_Debug_Alerts" style="text-align:left;color:#ff0000"></span></b> \
			<span style="text-align:right;"><a href="'+NetFunnel.gLogoURL+'" target="_blank" style="cursor:pointer;text-decoration:none;">';

if((NetFunnel.BrowserDetect.browser == "Explorer" && NetFunnel.BrowserDetect.version == "6" ) ||  NetFunnel.gLogoData == ""){
	NetFunnel.skinDefault += '<b style="font-size:12px;">'+NetFunnel.gLogoText+'</b></a>';
}else{
	NetFunnel.skinDefault += '<b style="font-size:12px;">'+NetFunnel.gLogoText+'</b><img style="height:16px;color:black;font-size:11px;" border=0 src="data:image/gif;base64,'+NetFunnel.gLogoData+'" ></a>';
}
NetFunnel.skinDefault +=	'</span></div> \
			<div style="padding-top:0px;padding-left:25px;padding-right:25px"> \
				<div style="text-align:left;font-size:12pt;color:#001f6c;height:22px"><b>서비스 <span style="color:#013dc1">접속대기 중</span>입니다.</b></div> \
				<div style="text-align:right;font-size:9pt;color:#4d4b4c;padding-top:4px;height:17px" ><b>예상대기시간 : <span id="NetFunnel_Loading_Popup_TimeLeft" class="%H시간 %M분 %02S초^ ^false"></span></b></div> \
				<div style="padding-top:6px;padding-bottom:6px;vertical-align:center;width:400px;height:20px" id="NetFunnel_Loading_Popup_Progressbar"></div> \
				<div style="background-color:#ededed;width:400px;padding-bottom:8px;overflow:hidden"> \
					<div style="padding-left:5px"> \
						<div style="text-align:left;font-size:8pt;color:#4d4b4c;padding:3px;padding-top:10px;height:10px">고객님 앞에 <b><span style="color:#2a509b"><span id="NetFunnel_Loading_Popup_Count" class="다수"></span></span></b> 명, 뒤에 <b><span style="color:#2a509b"><span id="NetFunnel_Loading_Popup_NextCnt" class="다수"></span></span></b> 명의 대기자가 있습니다.  </div> \
						<div style="text-align:left;font-size:8pt;color:#4d4b4c;padding:3px;height:10px">현재 접속 사용자가 많아 대기 중이며, 잠시만 기다리시면 </div> \
						<div style="text-align:left;font-size:8pt;color:#4d4b4c;padding:3px;height:10px;">서비스로 자동 접속 됩니다.</div> \
						<div style="text-align:center;font-size:9pt;color:#2a509b;padding-top:10px;"> \
							<b>※ 재 접속하시면 대기시간이 더 길어집니다. <span id="NetFunnel_Countdown_Stop" style="cursor:pointer">[중지]</span> </b> \
						</div> \
					</div> \
				</div> \
				<div style="height:5px;"></div> \
			</div> \
		</div> \
	</div>';
NetFunnel.SkinUtil.add('default',{htmlStr:NetFunnel.skinDefault},'normal');

NetFunnel.SkinUtil.add('main',{
	htmlStr:' \
	<div style="color: rgb(102, 102, 102);display: block;font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 14px;letter-spacing: -0.7px;margin-bottom: 0px; margin-left: 0px;margin-right: 0px;margin-top: 0px;padding-bottom: 20px;padding-left: 10px;padding-right: 10px;padding-top: 20px;position: relative;">\
		<div style="background-clip: border-box;background-color: rgba(0, 0, 0, 0);background-image: url(/_ui/mobile/images/common/bg_popup.gif);background-origin: padding-box; background-repeat:no-repeat;background-position:left bottom;background-size: 100%;color: rgb(102, 102, 102);display: block;font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 14px;letter-spacing: -0.7px;margin:0; padding:0 25px 10px 0;">\
			<h1 style="color: rgb(51, 51, 51);display: block;font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 17px;font-weight: bold;letter-spacing: -0.7px;line-height: normal;margin:0;padding:0;">접속지연</h1>\
		</div>\
		<div style="color: rgb(102, 102, 102);display: block;font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 14px;letter-spacing: -0.7px;margin:0;padding-bottom: 0px;padding-left: 0px;padding-right: 0px;padding-top: 15px;">\
			<div style="background-clip: border-box;background-color: rgba(0, 0, 0, 0);background-image: url(/_ui/mobile/images/common/bg_commlogo2.jpg);background-position: center top; background-repeat:no-repeat;background-origin: padding-box;background-size: 300px 250px;color: rgb(102, 102, 102); display: block;font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 14px;letter-spacing: -0.7px;line-height: 18px;margin-bottom: 0px;margin-left: 10px; margin-right: 10px;margin-top: 0px;min-height: 300px;padding-bottom: 0px;padding-left: 0px;padding-right: 0px;padding-top: 280px;text-align: center;">\
				<div style="color: rgb(102, 102, 102);display: block;font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif; font-size: 14px;height: 227px;letter-spacing: -0.7px;line-height: 18px;padding:0;text-align: center;"><strong style="color: rgb(51, 51, 51);display: block; font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 20px;font-style: normal;font-weight: normal;letter-spacing: -0.7px;line-height: 24px;margin-bottom: 15px; text-align: center;">\
					접속지연<br>서비스 <em style="color: rgb(10, 112, 211);font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 20px;font-style: normal;font-weight: normal;letter-spacing: -0.7px;line-height: 24px; text-align: center;">접속 대기 중</em>입니다.</strong>\
					<div style="background-color: rgb(249, 249, 249); background-image: none; background-origin: padding-box;background-size: auto; color: rgb(102, 102, 102);display: block; font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 14px;height: 18px;letter-spacing: -0.7px;line-height: 18px;margin:20px 0 0 0;padding-bottom: 17px;padding-left: 15px;padding-right: 15px;padding-top: 20px;text-align: center;">예상 대기 시간 : <span id="NetFunnel_Loading_Popup_TimeLeft" class="%M분 %02S초^ ^false"></span></div>\
					<p style="color: rgb(102, 102, 102); display: block;font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 14px; letter-spacing: -0.7px;line-height: 2;margin:0;padding:0;text-align: center;">\
						고객님 앞에 <span id="NetFunnel_Loading_Popup_Count" class="다수" style="color: rgb(10, 112, 211); font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 14px;font-style: normal;font-weight: normal;letter-spacing: -0.7px;line-height: 28px;text-align: center;">명</span>, 뒤에 <em id="NetFunnel_Loading_Popup_NextCnt" class="다수" style="font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 14px;font-style: normal;font-weight: normal;letter-spacing: -0.7px;line-height: 28px; text-align: center;color: rgb(10, 112, 211);">1</em>명의 대기자가 있습니다.<br>\
						현재 접속 사용자가 많아 대기 중이며, 잠시만 기다리시면 서비스로 자동 접속 됩니다.<br>\
					</p>\
					<p style="color: rgb(136, 136, 136); display: block;font-family: \'Nanum Gothic\', 나눔고딕, \'Malgun Gothic\', 맑은고딕, Dotum, 돋움, Gulim, 굴림, \'Helvetica Neue\', Helvetica, Tahoma, Verdana, \'Trebuchet MS\', Arial, Apple-Gothic, sans-serif;font-size: 14px;letter-spacing: -0.7px; line-height: 18px;margin:0;padding:30px 0 0 0;text-align: center;">\
						※ 재 접속하시면 대기 시간이 더 길어집니다.[<span id="NetFunnel_Countdown_Stop" style="cursor:pointer">중지</span>]\
					</p>\
				</div>\
			</div>\
		</div>\
	</div>'
},'mobile');

NetFunnel.skinMain = '\
	<div id="layerMask" style="display: block;position:fixed; z-index:10000; top:0; right:0; bottom:0; left:0; background:#000; filter:alpha(opacity=30) !important; opacity:.3; -moz-opacity:0.3; -khtml-opacity: 0.3;"></div> \
	<div id="NetFunnel_Skin_Top" tabindex="0" style="left: 50%; top: 50%; margin-top: -278px; margin-left: -300px; display: block !important; position: fixed;overflow: hidden;width: 600px;background: #fff;z-index: 10001;"> \
		<div style="margin: 0px !important;text-align: left;"> \
			<div style="width: auto; height: auto;margin: 0 auto;"> \
				<div style="position: fixed;width: 960px;top: 50%;left: 50%;margin: -255px 0 0 -480px;background: #fff;"> \
					<div style="margin-left:850px;"><b><span id="NetFunnel_Loding_Popup_Debug_Alerts" style="text-align:left;color:#ff0000"></span></b></div> \
					<div style="padding: 40px 0px;text-align: center;font-size: 14px;"><strong style="line-height: 1.4; letter-spacing: -4px; font-size: 36px;">접속지연<br>서비스 \
						<span style="color: rgb(25, 98, 169);">\
							접속 대기 중</span> 입니다</strong>\
							<ul style="text-align: center; padding-right: 0px !important; padding-left: 0px !important; margin-bottom: 20px !important;margin: 28px 160px 0 160px; padding: 25px 0 22px 140px;border-top: 1px solid #e2e2e2;border-bottom: 1px solid #e2e2e2;background: #fafafa;list-style:none;"> \
								<li style="color: #444;font-size: 12px;">\
									<strong>예상 대기 시간 : <span id="NetFunnel_Loading_Popup_TimeLeft" class="%H시간 %M분 %02S초^ ^false"></span></strong>\
								</li>\
							</ul>\
							<p style="line-height: 2;margin:0;">						고객님 앞에 <strong><span id="NetFunnel_Loading_Popup_Count" class="다수"></span></strong>, 뒤에 <strong><span id="NetFunnel_Loading_Popup_NextCnt" class="다수"></span></strong>명의 대기자가 있습니다.<br>현재 접속 사용자가 많아 대기 중이며, 잠시만 기다리시면 서비스로 자동 접속 됩니다.<br/></p>\
							<p style="padding-top: 30px;margin:0;">※ 재 접속하시면 대기 시간이 더 길어집니다.<span id="NetFunnel_Countdown_Stop" style="cursor:pointer">[중지]</span></p>\
					</div>\
				</div>\
			</div>\
		</div>\
	</div>';
NetFunnel.SkinUtil.add('main',{htmlStr:NetFunnel.skinMain},'normal');
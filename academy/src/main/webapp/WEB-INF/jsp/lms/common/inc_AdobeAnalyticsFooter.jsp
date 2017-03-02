<script type="text/javascript">
//<![CDATA[
	//Adobe_Analytics
    var dataLayer = {};
	// site Info.
    dataLayer.site = {
        "isProduction":${analBox.isproduction},   // 개발 단계일 경우 false, 운영 단계일 경우 true,
        "type":"${analBox.type}",                 // AI desktop 용 화면은 “desktop”, AI mobile 용 화면은  “mobile”
        "country":"${analBox.country}",           // “kr" 입력
        "language":"${analBox.language}",         // “ko” 입력
        "currencyCode":"${analBox.currencycode}", // “krw” 입력
        "region":"${analBox.region}",             // “apac” 입력
        "subRegion":"${analBox.subregion}",       // “korea” 입력
        "subGroup":"${analBox.subgroup}",         // “korea” 입력
		"webProperty":"${analBox.webproperty}"    // 우선 “ecm” 을 입력. 추후에 AI용 webProperty 가 별도로 부여될 경우 업데이트 예정.
    };
    // cos Info.
    dataLayer.visitor = {
        "customerID":"${analBox.customerid}",     // 고객 ID, 즉, ABO인 경우 ABO 번호 입력. 멤버의 경우 멤버ID를 입력. 비 로그인 시에는 공백 삽입
        "imcID":"${analBox.imcid}",               // 국가코드 3자리 한국은 180 + 나머지 11자리는 ABO 번호를 입력 왼쪽 패딩값은 0임. ABO번호가 7480003인 경우 “18000007480003” 으로 입력하면 됨.멤버나 비 로그인 시에는 공백 삽입
        "pinNumber":"${analBox.pinnumber}",       //
    	"userProfile":"${analBox.userprofile}"	// abo/member 둘 중 하나로 입력하되, 비 로그인 상태는 공백으로 삽입
    };
    // conn page Info.
    dataLayer.page = {
		"section":"${analBox.section}",
		"category":"${analBox.category}",
		"subCategory":"${analBox.subcategory}",
		"detail":"${analBox.detail}"
	};
    
	if (typeof (_satellite) != "undefined") _satellite.pageBottom();
//]]>
</script>
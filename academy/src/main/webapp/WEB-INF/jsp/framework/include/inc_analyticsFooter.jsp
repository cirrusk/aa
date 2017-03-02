<script type="text/javascript">
    //<![CDATA[
    //Adobe_Analytics
//    if(typeof dataLayer == 'undefined') {
        var dataLayer = {};
//    }
    // site Info.
    dataLayer.site = {
        "isProduction":${analBox.isproduction},
        "type":"${analBox.type}",
        "country":"${analBox.country}",
        "language":"${analBox.language}",
        "currencyCode":"${analBox.currencycode}",
        "region":"${analBox.region}",
        "subRegion":"${analBox.subregion}",
        "subGroup":"${analBox.subgroup}",
        "webProperty":"${analBox.webproperty}"
    };
    // cos Info.
    dataLayer.visitor = {
        "customerID":"${analBox.customerid}",
        "imcID":"${analBox.imcid}",
        "pinNumber":"${analBox.pinnumber}",
        "userProfile":"${analBox.userprofile}"
    };
    // conn page Info.
    dataLayer.page = {
        "section":"${analBox.section}",
        "category":"${analBox.category}",
        "subCategory":"${analBox.subcategory}",
        "detail":"${analBox.detail}"
    };

    if (typeof (_satellite) != "undefined") _satellite.pageBottom();
    // if (typeof (_satellite) != "undefined") _satellite.track('academy');
    //]]>
</script>
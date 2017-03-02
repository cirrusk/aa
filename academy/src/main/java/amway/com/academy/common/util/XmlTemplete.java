package amway.com.academy.common.util;

/**
 * Created by KR620242 on 2016-09-10.
 */
public class XmlTemplete {

	
	/**
	 * 주문 체크 XML
	 * @return
	 */
    public static String xmlSource() {

        StringBuffer xmlBuffer = new StringBuffer();

        xmlBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xmlBuffer.append("<ApihubWsXml>");
        xmlBuffer.append("<header>");
        xmlBuffer.append("<dateAndTimeStamp>");
        xmlBuffer.append("<request>__request__</request>");		// 2016-08-09T12:32:22.857
        xmlBuffer.append("</dateAndTimeStamp>");
        xmlBuffer.append("</header>");
        xmlBuffer.append("<body>");
        xmlBuffer.append("<amwaySuperintendentOrderCreate>");
        xmlBuffer.append("<interfaceChannel>__interfaceChannel__</interfaceChannel>");	// WEB
        xmlBuffer.append("<checkMode>true</checkMode>");		// true:체크 ,false:주문
        xmlBuffer.append("<distNo>__distNo__</distNo>");		// 7480003
        xmlBuffer.append("<member>false</member>");
        xmlBuffer.append("<products>");
        xmlBuffer.append("<product>");
        xmlBuffer.append("<code>2904</code>");
        xmlBuffer.append("<quantity>__quantity__</quantity>");	// 1
        xmlBuffer.append("</product>");
        xmlBuffer.append("</products>");
        xmlBuffer.append("<apCode>__apCode__</apCode>");	// 03
        xmlBuffer.append("<etc><![CDATA[__etc__]]></etc>");	//
        xmlBuffer.append("</amwaySuperintendentOrderCreate>");
        xmlBuffer.append("</body>");
        xmlBuffer.append("</ApihubWsXml>");

        String xmlSource = xmlBuffer.toString();

        return xmlSource;
    }

    /**
     * 시설 주문 XML 전문
     * @return
     */
    public static String xmlOrderSource() {

        StringBuffer orderXmlBuffer = new StringBuffer();

        orderXmlBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        orderXmlBuffer.append("<ApihubWsXml>");
        orderXmlBuffer.append("<header>");
        orderXmlBuffer.append("<dateAndTimeStamp>");
        orderXmlBuffer.append("<request>__request__</request>");	//2016-08-09T12:32:22.857
        orderXmlBuffer.append("</dateAndTimeStamp>");
        orderXmlBuffer.append("</header>");
        orderXmlBuffer.append("<body>");
        orderXmlBuffer.append("<amwaySuperintendentOrderCreate>");
        orderXmlBuffer.append("<interfaceChannel>__interfaceChannel__</interfaceChannel>");	// WEB
        orderXmlBuffer.append("<checkMode>false</checkMode>");	// true:체크 ,false:주문
        orderXmlBuffer.append("<distNo>__distNo__</distNo>");	//7480003
        orderXmlBuffer.append("<trackingNumber>__trackingNumber__</trackingNumber>");
        orderXmlBuffer.append("<member>false</member>");
        orderXmlBuffer.append("<products>");
        orderXmlBuffer.append("<product>");
        orderXmlBuffer.append("<code>2904</code>");
        orderXmlBuffer.append("<quantity>__quantity__</quantity>");	// 1
        orderXmlBuffer.append("</product>");
        orderXmlBuffer.append("</products>");
        orderXmlBuffer.append("<apCode>__apCode__</apCode>");	// 03
        orderXmlBuffer.append("<etc>__etc__</etc>");	// 
        orderXmlBuffer.append("<payment>");
        orderXmlBuffer.append("<mode>007</mode>");
        orderXmlBuffer.append("<orderAmount>__orderAmount__</orderAmount>");	// 1100

        orderXmlBuffer.append("<easyPay>");
        orderXmlBuffer.append("<cardNumber>__cardNumber__</cardNumber>");		// 1111111111111111
        orderXmlBuffer.append("<cardEffectiveDate>__cardEffectiveDate__</cardEffectiveDate>");	// 1120
        orderXmlBuffer.append("<vpsInstallmentMonth>__vpsInstallmentMonth__</vpsInstallmentMonth>");	// 00
        orderXmlBuffer.append("<ispCard>__ispCard__</ispCard>");
        orderXmlBuffer.append("<mpiCard>false</mpiCard>");
        orderXmlBuffer.append("<bizNo>__bizNo__</bizNo>");
        orderXmlBuffer.append("<epTrCd>__epTrCd__</epTrCd>");
        orderXmlBuffer.append("<epTraceNo>__epTraceNo__</epTraceNo>");
        orderXmlBuffer.append("<epSessionkey>__epSessionKey__</epSessionkey>");
        orderXmlBuffer.append("<epEncryptData>__epEncryptData__</epEncryptData>");
        orderXmlBuffer.append("<epUserIp>__epUserIp__</epUserIp>");
        orderXmlBuffer.append("<epOrderNo>__epOrderNo__</epOrderNo>");
        orderXmlBuffer.append("<kknCode>__kknCode__</kknCode>");
        orderXmlBuffer.append("<url>__url__</url>");	// /framework/com/testOrderAPI.do
        orderXmlBuffer.append("</easyPay>");

        orderXmlBuffer.append("</payment>");
        orderXmlBuffer.append("<invoice>");
        orderXmlBuffer.append("<pricePrintStatus>false</pricePrintStatus>");
        orderXmlBuffer.append("<pvPrintStatus>false</pvPrintStatus>");
        orderXmlBuffer.append("<bvPrintStatus>false</bvPrintStatus>");
        orderXmlBuffer.append("</invoice>");
        orderXmlBuffer.append("</amwaySuperintendentOrderCreate>");
        orderXmlBuffer.append("</body>");
        orderXmlBuffer.append("</ApihubWsXml>");

        String xmlOrderSource = orderXmlBuffer.toString();

        return xmlOrderSource;
    }

    /**
     * 반품 : 주문 취소 XML 전문
     * @return
     */
    public static String xmlCancelSource() {

        StringBuffer cancelXmlBuffer = new StringBuffer();

        cancelXmlBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        cancelXmlBuffer.append("<ApihubWsXml>");
        cancelXmlBuffer.append("<header>");
	        cancelXmlBuffer.append("<dateAndTimeStamp>");
	        cancelXmlBuffer.append("<request>__request__</request>");			// 2016-08-09 T12:32:22.857
	        cancelXmlBuffer.append("</dateAndTimeStamp>");
        cancelXmlBuffer.append("</header>");
        cancelXmlBuffer.append("<body>");
	        cancelXmlBuffer.append("<amwaySuperintendentOrderCancel>");
	        cancelXmlBuffer.append("<interfaceChannel>__interfaceChannel__</interfaceChannel>");	// WEB
	        cancelXmlBuffer.append("<id>__id__</id>");							// 790429
	        cancelXmlBuffer.append("<imcNumber>__imcNumber__</imcNumber>");		// 7480003
	        cancelXmlBuffer.append("<courseFinishDate>__courseFinishDate__</courseFinishDate>");	// 2016-06-09
	        cancelXmlBuffer.append("<applicationDate>__applicationDate__</applicationDate>");		// 2016-07-10
	        cancelXmlBuffer.append("<vpsRef>__vpsRef__</vpsRef>");						// 773368
	        cancelXmlBuffer.append("<onlineStatus>__onlineStatus__</onlineStatus>");	// false
	        cancelXmlBuffer.append("<item> 271565K16</item>");							// 271565K16
	        cancelXmlBuffer.append("<itemQuantity>__itemQuantity__</itemQuantity>");	// 1
	        cancelXmlBuffer.append("</amwaySuperintendentOrderCancel>");
        cancelXmlBuffer.append("</body>");
        cancelXmlBuffer.append("</ApihubWsXml>");

        String xmlCancelSource = cancelXmlBuffer.toString();

        return xmlCancelSource;
    }

}

package amway.com.academy.common.util;

/**
 * Created by KR620242 on 2016-09-10.
 */
public class XmlSource {

    public static String xmlSource() {

        StringBuffer xmlBuffer = new StringBuffer();

        xmlBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xmlBuffer.append("<ApihubWsXml>");
        xmlBuffer.append("<header>");
        xmlBuffer.append("<dateAndTimeStamp>");
        xmlBuffer.append("<request>2016-08-09T12:32:22.857</request>");
        xmlBuffer.append("</dateAndTimeStamp>");
        xmlBuffer.append("</header>");
        xmlBuffer.append("<body>");
        xmlBuffer.append("<amwaySuperintendentOrderCreate>");
        xmlBuffer.append("<interfaceChannel>WEB</interfaceChannel>");
        xmlBuffer.append("<checkMode>true</checkMode>");
        xmlBuffer.append("<distNo>7480003</distNo>");
        xmlBuffer.append("<member>false</member>");
        xmlBuffer.append("<products>");
        xmlBuffer.append("<product>");
        xmlBuffer.append("<code>2904</code>");
        xmlBuffer.append("<quantity>1</quantity>");
        xmlBuffer.append("</product>");
        xmlBuffer.append("</products>");
        xmlBuffer.append("<apCode>03</apCode>");
        xmlBuffer.append("<etc>test</etc>");
        xmlBuffer.append("<result>");
        xmlBuffer.append("<reorder>yes</reorder>");
        xmlBuffer.append("</result>");
        xmlBuffer.append("</amwaySuperintendentOrderCreate>");
        xmlBuffer.append("</body>");
        xmlBuffer.append("</ApihubWsXml>");

        String xmlSource = xmlBuffer.toString();

        return xmlSource;
    }


    public static String xmlOrderSource() {

        StringBuffer orderXmlBuffer = new StringBuffer();

        orderXmlBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        orderXmlBuffer.append("<ApihubWsXml>");
        orderXmlBuffer.append("<header>");
        orderXmlBuffer.append("<dateAndTimeStamp>");
        orderXmlBuffer.append("<request>2016-08-09T12:32:22.857</request>");
        orderXmlBuffer.append("</dateAndTimeStamp>");
        orderXmlBuffer.append("</header>");
        orderXmlBuffer.append("<body>");
        orderXmlBuffer.append("<amwaySuperintendentOrderCreate>");
        orderXmlBuffer.append("<interfaceChannel>WEB</interfaceChannel>");
        orderXmlBuffer.append("<checkMode>false</checkMode>");
        orderXmlBuffer.append("<distNo>7480003</distNo>");
        orderXmlBuffer.append("<member>false</member>");
        orderXmlBuffer.append("<products>");
        orderXmlBuffer.append("<product>");
        orderXmlBuffer.append("<code>2904</code>");
        orderXmlBuffer.append("<quantity>1</quantity>");
        orderXmlBuffer.append("</product>");
        orderXmlBuffer.append("</products>");
        orderXmlBuffer.append("<apCode>03</apCode>");
        orderXmlBuffer.append("<etc>test</etc>");
        orderXmlBuffer.append("<payment>");
        orderXmlBuffer.append("<mode>007</mode>");
        orderXmlBuffer.append("<orderAmount>1100</orderAmount>");
        orderXmlBuffer.append("<easyPay>");
        orderXmlBuffer.append("<cardNumber>1111111111111111</cardNumber>");
        orderXmlBuffer.append("<cardEffectiveDate>1120</cardEffectiveDate>");
        orderXmlBuffer.append("<vpsInstallmentMonth>00</vpsInstallmentMonth>");
        orderXmlBuffer.append("<ispCard>false</ispCard>");
        orderXmlBuffer.append("<mpiCard>false</mpiCard>");
        orderXmlBuffer.append("<bizNo></bizNo>");
        orderXmlBuffer.append("<epTrCd></epTrCd>");
        orderXmlBuffer.append("<epTraceNo></epTraceNo>");
        orderXmlBuffer.append("<epSessionkey></epSessionkey>");
        orderXmlBuffer.append("<epEncryptData></epEncryptData>");
        orderXmlBuffer.append("<epUserIp></epUserIp>");
        orderXmlBuffer.append("<epOrderNo></epOrderNo>");
        orderXmlBuffer.append("<kknCode></kknCode>");
        orderXmlBuffer.append("<url>/framework/com/testOrderAPI.do</url>");
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

    public static String xmlCancelSource() {

        StringBuffer cancelXmlBuffer = new StringBuffer();

        cancelXmlBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        cancelXmlBuffer.append("<ApihubWsXml>");
        cancelXmlBuffer.append("<header>");
        cancelXmlBuffer.append("<dateAndTimeStamp>");
        cancelXmlBuffer.append("<request>2016-08-09 T12:32:22.857</request>");
        cancelXmlBuffer.append("</dateAndTimeStamp>");
        cancelXmlBuffer.append("</header>");
        cancelXmlBuffer.append("<body>");
        cancelXmlBuffer.append("<amwaySuperintendentOrderCancel>");
        cancelXmlBuffer.append("<interfaceChannel>WEB</interfaceChannel>");
        cancelXmlBuffer.append("<id>790429</id>");
        cancelXmlBuffer.append("<imcNumber>7480003</imcNumber>");
        cancelXmlBuffer.append("<courseFinishDate>2016-06-09</courseFinishDate>");
        cancelXmlBuffer.append("<applicationDate>2016-07-10</applicationDate>");
        cancelXmlBuffer.append("<vpsRef>773368</vpsRef>");
        cancelXmlBuffer.append("<onlineStatus>false</onlineStatus>");
        cancelXmlBuffer.append("<item>271565K16</item>");
        cancelXmlBuffer.append("<itemQuantity>1</itemQuantity>");
        cancelXmlBuffer.append("</amwaySuperintendentOrderCancel>");
        cancelXmlBuffer.append("</body>");
        cancelXmlBuffer.append("</ApihubWsXml>");

        String xmlCancelSource = cancelXmlBuffer.toString();

        return xmlCancelSource;
    }

}

package amway.com.academy.common.util;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Map;
import java.util.Properties;
	
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Created by KR620242 on 2016-09-05.
 */
public class UtilAPI {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(UtilAPI.class);
	
    //private static String daishinBaseUrl = "https://dev2.abnkorea.co.kr";
	
	/**
	 * 프로퍼티 정보 획득
	 * @param propString
	 * @return
	 */
	public static String getFrameworkProperties(String propString) {
		String returnValue = "";
		
		String resourceName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties props = new Properties();
		try( InputStream resourceStream = loader.getResourceAsStream(resourceName) ) {
			props.load(resourceStream);
			
			//api-url
			returnValue = props.getProperty(propString);
		} catch( IOException e) {
			LOGGER.error(e.getMessage(), e);
		}

		return returnValue;
	}
    
	/**
	 * <pre>
	 * API 호출 대상 서버 URL 정보
	 * framework.properties 프로퍼티내 설정된 값을 획득
	 * </pre>
	 * @return
	 */
    public static String getApiLocation() {
    	return getFrameworkProperties("api.server.location");
	}
    
    /**
     * <pre>
     * 현재 기동중인 서버의 location
     * ex: easy-pay 결제 모듈 호출시 요청서버의 정보를 보내서 처리 후 forwarding 될 페이지를 알려주도록한다. 
     * </pre>
     * @return
     */
    public static String getCurrentServerLocation(){
    	return getFrameworkProperties("current.server.location");
    }
    
    /**
     * <pre>
     * 하이브리스 도메인 경로
     * </pre>
     * @return
     */
    public static String getCurerntHybrisLocation(){
    	return getFrameworkProperties("Hybris.httpDomain");
    }
    
    
    private enum URL_TYPE {
        GET_TOKEN,
        GET_AWAYGO_LOGIN,
        GET_CARD_COMPANY,
        GET_AP_INFO,
        CHECK_AS400,
        GET_RECEIPTS_INFO,
        GET_INVOICE_INFO,
        ORDER_CREATE,
        CANCEL_ORDER
    }

    private static URL getUrl(URL_TYPE type, String param) throws Exception {
        URL url = null;
        
        String daishinBaseUrl = getApiLocation();
        
        switch (type) {
            case GET_TOKEN:
                url = new URL(daishinBaseUrl + "/rest/oauth/token" + param);
                break;

            case GET_AWAYGO_LOGIN:
                url = new URL(daishinBaseUrl + "/rest/customers/auth" + param);
                break;

            case GET_CARD_COMPANY:
                url = new URL(daishinBaseUrl + "/rest/store/creditCardCompany");
                break;

            case GET_AP_INFO:
                url = new URL(daishinBaseUrl + "/rest/store/pointOfServices");
                break;

            case CHECK_AS400:
                url = new URL(daishinBaseUrl + "/rest/store/maintenance/sm-as400");
                break;

            case GET_RECEIPTS_INFO:
                url = new URL(daishinBaseUrl + "/rest/orders/cardReceipts");
                break;

            case GET_INVOICE_INFO:
                url = new URL(daishinBaseUrl + "/rest/orders/invoiceCode");
                break;

            case ORDER_CREATE:
                url = new URL(daishinBaseUrl + "/rest/orders/amwaySuperintendent/create");
                break;

            case CANCEL_ORDER:
                url = new URL(daishinBaseUrl + "/rest/orders/amwaySuperintendent/cancel");
                break;

            default:
                break;
        }

        LOGGER.debug("api-server-location : {}", daishinBaseUrl );
        
        return url;
    }


    /**
     * token 정보
     * @return
     * @throws Exception
     */
    public static String token() throws Exception {
        String comp = "";

        String urlString = CommonAPI.getTokenObject(
                getUrl(URL_TYPE.GET_TOKEN, comp),
//				  2016-12-27 15:50 김경범차장님의 요청에 의해 수정하였습니다.
//                "client_id=t7OBlETHAD",
//                "client_secret=eab393de-5ce9-454a-a062-25f08671da54",
//                "grant_type=client_credentials"
        		"client_id=1ztr8zUTLBdlj2k",
        		"client_secret=8342251a-77d8-43bd-9145-d1fd997483c2",
        		"grant_type=client_credentials"
        );

        URL url = new URL(urlString);
        String returnValue = CommonAPI.connectionWebServiceToken(url);

        //읽어온 데이터 파싱하기
        Map<String,String> readMap = CommonAPI.getXmlRead(new ByteArrayInputStream(returnValue.getBytes()), "defaultOAuth2AccessToken");

        String token = "bearer "+readMap.get("value");

        return token;
    }

    /**
     * AmwayGO 회원인증
     * @param userId
     * @param userPass
     * @return
     * @throws Exception
     */
    public static Map checkUser(String userId, String userPass) throws Exception {
        String comp = "";
        String token = token();

        String ecmSalt = "hybris blue pepper can be used to prepare delicious noodle meals";
        String delimiter = "::";

        // hybris blue pepper can be used to prepare delicious noodle meals::05050101::7480003
        String plaintext = ecmSalt + delimiter + userPass + delimiter + userId;

        String enPass = CommonAPI.encodingSHA256(plaintext);
        //String enPass = "0d0b993f48e8cd8506221afb21268ac2b4b0f259d3444179f99a550d1fff720b";

        String urlString = CommonAPI.getObject(getUrl(URL_TYPE.GET_AWAYGO_LOGIN, comp),userId, enPass, "checkUser");
        LOGGER.debug(urlString);
        
        URL url = new URL(urlString);
        String userInfo = CommonAPI.conWebService(url, token, "GET");

        //읽어온 데이터 파싱하기
        Map<String,String> userInfoMap = CommonAPI.getXmlRead(new ByteArrayInputStream(userInfo.getBytes()), "Response");

        return userInfoMap;
    }

    /**
     * 카드 정보
     * @return
     * @throws Exception
     */
    public static Map creditCardCompany() throws Exception {
        String comp = "";
        String token = token();

        String urlString = CommonAPI.getObject(getUrl(URL_TYPE.GET_CARD_COMPANY, comp));

        URL url = new URL(urlString);
        String cardInfo = CommonAPI.conWebService(url, token, "GET");

        //읽어온 데이터 파싱하기
        Map<String, Object> cardMap = CommonAPI.getListXmlRead(new ByteArrayInputStream(cardInfo.getBytes()), "bankInfo");

        return cardMap;
    }

    /**
     * 카드 정보.
     * @param bankInfo
     * @return
     * @throws Exception
     */
    public static Map creditCardCompanyOne(String bankInfo) throws Exception {
        String comp = "";
        String token = token();

        String urlString = CommonAPI.getObject(getUrl(URL_TYPE.GET_CARD_COMPANY, comp), bankInfo, "", "one");

        URL url = new URL(urlString);
        String cardInfo = CommonAPI.conWebService(url, token, "GET");

        //읽어온 데이터 파싱하기
        Map<String, String> cardMap = CommonAPI.getXmlRead(new ByteArrayInputStream(cardInfo.getBytes()), "bankInfo");

        return cardMap;
    }

    /**
     * AP 정보
     * @return
     * @throws Exception
     */
    public static Map getApInfo() throws Exception {
        String comp = "";
        String token = token();
        String urlString = CommonAPI.getObject(getUrl(URL_TYPE.GET_AP_INFO, comp));

        URL url = new URL(urlString);
        String apInfo = CommonAPI.conWebService(url, token, "GET");

        if (null != apInfo && apInfo.length() >= 10){
//        	LOGGER.debug("apInfo : {} ...", apInfo.substring(0,10));
        	
        	LOGGER.debug("apInfo : {}", apInfo);
        }else if(null != apInfo && apInfo.length() < 10){
        	LOGGER.debug("apInfo : {}", apInfo);
        }
        
        //읽어온 데이터 파싱하기
        Map<String,Object> apInfoMap = CommonAPI.getListXmlRead(new ByteArrayInputStream(apInfo.getBytes()), "pointOfService");

        //LOGGER.debug((String)apInfoMap.get("list"));

        return apInfoMap;
    }

    /**
     * AS400 정보
     * @return
     * @throws Exception
     */
    public static Map getEcmsInfo() throws Exception {
        String comp = "";
        String token = token();
        String urlString = CommonAPI.getObject(getUrl(URL_TYPE.CHECK_AS400, comp));

        URL url = new URL(urlString);
        String ecmsInfo = CommonAPI.conWebService(url, token, "GET");

        //읽어온 데이터 파싱하기
        Map<String,String> ecmsInfoMap = CommonAPI.getXmlRead(new ByteArrayInputStream(ecmsInfo.getBytes()), "systemMaintenance");

        return ecmsInfoMap;
    }

    /**
     * 카드영수증 조회
     * @param invoiceCode
     * @return
     * @throws Exception
     */
    public static Map getReceipts(String invoiceCode) throws Exception {
        String comp = "";
        String token = token();

        String interfaceChannel = "WEB";
        String urlString = CommonAPI.getObject(getUrl(URL_TYPE.GET_RECEIPTS_INFO, comp),invoiceCode, interfaceChannel, "receipts");

        URL url = new URL(urlString);
        String receiptInfo = CommonAPI.conWebService(url, token, "POST").replaceAll("&", "&amp;");

        //읽어온 데이터 파싱하기
        Map<String,String> receiptInfoMap = CommonAPI.getXmlRead(new ByteArrayInputStream(receiptInfo.getBytes()), "cardReceipts");

        return receiptInfoMap;
    }

    /**
     * <pre>
     * 임시주문번호(VPS오더넘버) - 주문번호매핑
     * request : 주문일자 , 임시주문번호
     * </pre>
     * @param orderCreationTime
     * @param invoiceQueue
     * @return
     * @throws Exception
     */
    public static Map getInvoice(String orderCreationTime, String invoiceQueue) throws Exception {
        String comp = "";
        String token = token();

        String urlString = CommonAPI.getObject(getUrl(URL_TYPE.GET_INVOICE_INFO, comp),orderCreationTime, invoiceQueue, "receipts");

        URL url = new URL(urlString);
        String orderInfo = CommonAPI.conWebService(url, token, "POST").replaceAll("&", "&amp;");

        //읽어온 데이터 파싱하기
        Map<String,String> orderInfoMap = CommonAPI.getXmlRead(new ByteArrayInputStream(orderInfo.getBytes()), "invoiceCode");

        return orderInfoMap;
    }

    /**
     * 주문 조회. (가상 주문 번호 요청)
     * @param xmlSource
     * @return
     * @throws Exception
     */
    public static Map<String,String> checkOrder(String xmlSource) throws Exception {
        String comp = "";
        String token = token();

        String urlString = CommonAPI.getObject(getUrl(URL_TYPE.ORDER_CREATE, comp));

        LOGGER.debug(xmlSource);

        URL url = new URL(urlString);
        String receiptInfo = CommonAPI.conXmlWebService(url, token, xmlSource, "POST").replaceAll("&", "&amp;");

        LOGGER.debug(receiptInfo);
        //읽어온 데이터 파싱하기
        Map<String,String> receiptInfoMap = CommonAPI.getCheckXmlRead(new ByteArrayInputStream(receiptInfo.getBytes()), "check");

        LOGGER.debug(receiptInfoMap.toString());

        return receiptInfoMap;
    }

    /**
     * 주문 생성
     * @param xmlSource
     * @return
     * @throws Exception
     */
    public static Map orderCreate(String xmlSource) throws Exception {
        String comp = "";
        String token = token();

        String urlString = CommonAPI.getObject(getUrl(URL_TYPE.ORDER_CREATE, comp));

        LOGGER.debug(xmlSource);

        URL url = new URL(urlString);
        String receiptInfo = CommonAPI.conXmlWebService(url, token, xmlSource, "POST").replaceAll("&", "&amp;");

        LOGGER.debug(receiptInfo);
        //읽어온 데이터 파싱하기
        Map<String,String> receiptInfoMap = CommonAPI.getCheckXmlRead(new ByteArrayInputStream(receiptInfo.getBytes()), "order");

        LOGGER.debug(receiptInfoMap.toString());

        return receiptInfoMap;
    }

    /**
     * 주문 취소 (반품 = 환불)
     * @param xmlSource
     * @return
     * @throws Exception
     */
    public static Map<String,String> cancelOrder(String xmlSource) throws Exception {
        String comp = "";
        String token = token();

        String urlString = CommonAPI.getObject(getUrl(URL_TYPE.CANCEL_ORDER, comp));

        LOGGER.debug(xmlSource);

        URL url = new URL(urlString);
        String receiptInfo = CommonAPI.conXmlWebService(url, token, xmlSource, "POST").replaceAll("&", "&amp;");

        LOGGER.debug(receiptInfo);
        //읽어온 데이터 파싱하기
        Map<String,String> receiptInfoMap = CommonAPI.getCheckXmlRead(new ByteArrayInputStream(receiptInfo.getBytes()), "cancel");

        LOGGER.debug(receiptInfoMap.toString());

        return receiptInfoMap;
    }


}

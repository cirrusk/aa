package amway.com.academy.lms.common;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.TimeZone;
import java.nio.charset.StandardCharsets;
import java.net.URLEncoder;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import framework.com.cmm.lib.RequestBox;


@Repository("lmsUtil")
public class LmsUtil {
	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsUtil.class);


	/**
	 * 파일업로드
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> setFileMakeToList(MultipartHttpServletRequest request, String uploadFolder,  String childFolder) throws Exception{
		
		//folder mkdir
		File saveFolder = new File(uploadFolder+File.separator+childFolder);
		if(!saveFolder.exists() || saveFolder.isFile()){
			saveFolder.mkdirs();
		}
		
		//iterator
		Iterator<String> files = request.getFileNames();
		MultipartFile multipartFile;
		String filePath;
		List<Map<String, Object>> fileInfoList = new ArrayList<Map<String,Object>>();
		
		try{
			
			//while
			while(files.hasNext()){			
				
				//file생성
				String uuid = UUID.randomUUID().toString().replaceAll("-", "");
				multipartFile = request.getFile((String)files.next());
				String fieldName = multipartFile.getName();
				String extName = multipartFile.getOriginalFilename().substring(multipartFile.getOriginalFilename().lastIndexOf(".")+1 );
				String filename = uuid+"."+extName;
				filePath = uploadFolder+File.separator+childFolder+File.separator+filename;
				if( filename != null && !"".equals(multipartFile.getOriginalFilename()) ){
					multipartFile.transferTo(new File(filePath));

					//file정보 담기
					
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("fieldName", fieldName);
					map.put("FilePath", filePath);
					map.put("OriginalFilename", multipartFile.getOriginalFilename());
					map.put("extName", extName);
					map.put("FileSize", multipartFile.getSize());
					map.put("FileSavedName", filename);
					fileInfoList.add(map);
				}
			}
			
		}catch(IOException e){
			e.printStackTrace();
		}
		
		return fileInfoList;
		
	}
	
	/**
	 * LMS세션값을 설정하고 존재여부를 RequestBox에담는다.
	 * @param RequestBox
	 * @return RequestBox
	 * @throws 
	 */
	public RequestBox setLmsSessionBoolean(RequestBox requestBox) {
		/* TODO
		 * 세션체크 및 UID에 맞는 정보를 requestBox에 담는다.
		 * 세션값 유무를 리턴한다.
		 * 
		 * 		사용할멤버변수 예정. LMSCOURSECONDITION 테이블 컬럼.
		 * 				회원타입코드, 회원타입ABOVE, 
		 * 				핀레벨조건코드, 핀레벨UNDER, 핀레벨ABOVE, 
		 * 				보너스레벨조건코드, 보너스레벨UNDER, 보너스레벨ABOVE, 
		 * 				나이조건코드, 나이UNDER, 나이ABOVE, 
		 * 				LOA그룹, 다이아그룹, 비즈니스상태
		 */
		
		HttpSession session = requestBox.getHttpSession();
		if(session.getAttribute("lmsUid") != null && !"".equals(session.getAttribute("lmsUid"))) {

			requestBox.put(LmsCode.userSessionUid, session.getAttribute("lmsUid"));
			requestBox.put(LmsCode.userSessionName, session.getAttribute("name"));
			requestBox.put(LmsCode.userSessionAboTypeCode, session.getAttribute("abotypecode"));
			requestBox.put(LmsCode.userSessionAboTypeOrder, session.getAttribute("abotypeorder"));
			requestBox.put(LmsCode.userSessionPinCode, session.getAttribute("pincode"));
			requestBox.put(LmsCode.userSessionPinOrder, session.getAttribute("pinorder"));
			requestBox.put(LmsCode.userSessionBonusCode, session.getAttribute("bonuscode"));
			requestBox.put(LmsCode.userSessionBonusOrder, session.getAttribute("bonusorder"));
			requestBox.put(LmsCode.userSessionAgeOrder, session.getAttribute("ageorder"));
			requestBox.put(LmsCode.userSessionLoaCode, session.getAttribute("loacode"));
			requestBox.put(LmsCode.userSessionDiaCode, session.getAttribute("diacode"));
			requestBox.put(LmsCode.userSessionCreationtime, session.getAttribute("creationtime"));

			requestBox.put(LmsCode.userSessionCustomerCode, session.getAttribute("customercode"));
			requestBox.put(LmsCode.userSessionConsecutiveCode, session.getAttribute("consecutivecode"));
			requestBox.put(LmsCode.userSessionBusinessStatusCode1, session.getAttribute("businessstatuscode1"));
			requestBox.put(LmsCode.userSessionBusinessStatusCode2, session.getAttribute("businessstatuscode2"));
			requestBox.put(LmsCode.userSessionBusinessStatusCode3, session.getAttribute("businessstatuscode3"));
			requestBox.put(LmsCode.userSessionBusinessStatusCode4, session.getAttribute("businessstatuscode4"));

			requestBox.put("MemberYn", "Y");
		} else {
			requestBox.put(LmsCode.userSessionUid, "");
			requestBox.put(LmsCode.userSessionName, "");
			requestBox.put(LmsCode.userSessionAboTypeCode, "");
			requestBox.put(LmsCode.userSessionAboTypeOrder, "1");
			requestBox.put(LmsCode.userSessionPinCode, "");
			requestBox.put(LmsCode.userSessionPinOrder, "0");
			requestBox.put(LmsCode.userSessionBonusCode, "");
			requestBox.put(LmsCode.userSessionBonusOrder, "0");
			requestBox.put(LmsCode.userSessionAgeOrder, "999");
			requestBox.put(LmsCode.userSessionLoaCode, "");
			requestBox.put(LmsCode.userSessionDiaCode, "");
			requestBox.put(LmsCode.userSessionCreationtime, "");

			requestBox.put(LmsCode.userSessionCustomerCode, "");
			requestBox.put(LmsCode.userSessionConsecutiveCode, "");
			requestBox.put(LmsCode.userSessionBusinessStatusCode1, "");
			requestBox.put(LmsCode.userSessionBusinessStatusCode2, "");
			requestBox.put(LmsCode.userSessionBusinessStatusCode3, "");
			requestBox.put(LmsCode.userSessionBusinessStatusCode4, "");
			
			requestBox.put("MemberYn", "N");
		}
		return requestBox;
	}
	
	
	public String getHtmlBr(String strTxt){
		strTxt = getHtmlStrCnvrBr(strTxt);
		return strTxt;
	}
	
	/**
	 * html의 특수문자를 표현하기 위해
	 *
	 * @param srcString
	 * @return String
	 * @exception Exception
	 * @see
	 */
	public static String getHtmlStrCnvr(String srcString) {

		String tmpString = srcString;

		tmpString = tmpString.replaceAll("&lt;", "<");
		tmpString = tmpString.replaceAll("&gt;", ">");
		tmpString = tmpString.replaceAll("&amp;", "&");
		tmpString = tmpString.replaceAll("&nbsp;", " ");
		tmpString = tmpString.replaceAll("&apos;", "\'");
		tmpString = tmpString.replaceAll("&quot;", "\"");
		tmpString = tmpString.replaceAll("\n", "<br />"); //li 태그 없애고 <br>처리하기로 통화함 1206일 10시 17분경 전화 통화 후 처리

		return tmpString;

	}
	
	/**
	 * html의 특수문자를 표현하기 위해
	 *
	 * @param srcString
	 * @return String
	 * @exception Exception
	 * @see
	 */
	public static String getHtmlStrCnvrBr(String srcString) {

		String tmpString = srcString;

		tmpString = tmpString.replaceAll("&lt;", "<");
		tmpString = tmpString.replaceAll("&gt;", ">");
		tmpString = tmpString.replaceAll("&amp;", "&");
		tmpString = tmpString.replaceAll("&nbsp;", " ");
		tmpString = tmpString.replaceAll("&apos;", "\'");
		tmpString = tmpString.replaceAll("&quot;", "\"");
		tmpString = tmpString.replaceAll("\n", "<br />");

		return tmpString;

	}
	
	/**
	 * html의 특수문자를 표현하기 위해
	 *
	 * @param srcString
	 * @return String
	 * @exception Exception
	 * @see
	 */
	public String getDomain(HttpServletRequest request) {
		String scheme = request.getScheme();
		String serverName = request.getServerName();
		int serverPort = request.getServerPort();
		String domain = "";
		domain = scheme+"://"+serverName;
		String localhostStr = "localhost";
		if(localhostStr.equals(serverName) && serverPort != 80){
			domain = scheme+"://"+serverName + ":" + serverPort;
		}
		return domain;
	}
	

	/**
	 * 접속서버에 대한 Link를 반환 한다.
	 *
	 * @param String, HttpServletRequest
	 * @return String
	 * @see 
	 * 			middleLink : 도메인다음의 호출 Link ==>  "/lms/main"
	 * 			paramGet  : get으로 넘기는 파라메타  ==> "?day=20160923&time=1130&..."
	 * 			mobileLink : 모바일접속유무 모바일접속시 ==> "mobile" 
	 * 			connHttp   : Link주소 http OR https 구분 ==> "https"
	 */
	public String getUrlFullLink(String middleLink, String paramGet, String mobileLink, String connHttp, HttpServletRequest request) {
		
		//StringBuffer sbDomain = new StringBuffer();
		StringBuffer sbLink = new StringBuffer();
		String sDo = "";
		String firstLink = "";
		
		String sHybrisDomain = LmsCode.getHybrisHttpDomain(); 	//프러퍼티에 있는 값을 가져온다.
		if("mobile".equals(mobileLink)) {
			firstLink = "/mobile"; 	//모바일 접속시 로컬서버 셋팅
		}

		String requestUrl = request.getRequestURL().toString();  
		int serverPort = request.getServerPort();
		
		if(connHttp.equals("https") && sHybrisDomain.indexOf("http://") >= 0 ) {
			//sHybrisDomain = "https://" + sHybrisDomain.substring( 7 );
			sbLink.append("https://").append(sHybrisDomain.substring( 7 ));
		} else if( requestUrl.indexOf("localhost") >= 0 ) {
			//sHybrisDomain = "http://localhost:" + serverPort + firstLink;
			sbLink.append("http://localhost:").append(serverPort).append(firstLink);
		
			if(middleLink.length() > 0) {
				sDo = ".do"; 
			}
		} else {
			sbLink.append(sHybrisDomain);
		}
		
		//String sLink = sHybrisDomain + middleLink + sDo + paramGet;
		sbLink.append(middleLink).append(sDo).append(paramGet);
		
		return sbLink.toString();
	}
	
	
	
	
	
	/**
	 * 암호화 설정
	 * @param srcString
	 * @return String
	 * @exception Exception
	 * @see
	 */
	public String getEncryptStr(String strVal) {
		String rtnEncode = ""; 
		
		final String TRANSFORMATION = "AES/CBC/PKCS5Padding"; 	// 알고리즘/모드/패딩방식
        final String ALGORITHM = "AES"; 	// 암호화 알고리즘
        final String DIGEST = "MD5"; 			// MD5 해싱을 통해 암호화를 위한 16바이트 key, iv 생성 
        final String KEY = "123"; 					// KEY 초기 값 
        final String IV = "456"; 					// IV 초기 값
        
        try {
			final Cipher cipher = Cipher.getInstance(TRANSFORMATION);										// 알고리즘/모드/패딩방식 설정 -> AES/CBC/PKCS7Padding
			final MessageDigest md = MessageDigest.getInstance(DIGEST); 									// KEY와 IV를 MD5 해싱
			final SecretKey key = new SecretKeySpec(md.digest(KEY.getBytes("UTF8")), ALGORITHM); 	// AES 암호화를 위한 key 생성
			final IvParameterSpec ivParamSpec = new IvParameterSpec(md.digest(IV.getBytes("UTF8"))); 	// 암호화를 위한 iv(initial vector) 생성
			
			cipher.init(Cipher.ENCRYPT_MODE, key, ivParamSpec); 
			
			byte[] utf8Value = strVal.getBytes("UTF8"); 		// Get a UTF-8 byte array from a unicode string.
			byte[] arrCipherData = cipher.doFinal(utf8Value); 						// AES 암호화 실행
			rtnEncode = new String(Base64.encodeBase64(arrCipherData)); 	// 암호화된 데이터를 문자열로 변환

        }catch(InvalidKeyException e){
			e.printStackTrace();
        	rtnEncode = "";
        }catch(IllegalBlockSizeException e){
			e.printStackTrace();
        	rtnEncode = "";
        }catch(InvalidAlgorithmParameterException e){
			e.printStackTrace();
        	rtnEncode = "";
		}catch(UnsupportedEncodingException e){
			e.printStackTrace();
        	rtnEncode = "";
        }catch(NoSuchPaddingException e){
			e.printStackTrace();
        	rtnEncode = "";
        }catch(BadPaddingException e){
			e.printStackTrace();
        	rtnEncode = "";
        }catch(NoSuchAlgorithmException e){
			e.printStackTrace();
        	rtnEncode = "";
        }
        
		return rtnEncode;
	}
	
	/**
	 * 복호화 설정
	 * @param srcString
	 * @return String
	 * @exception Exception
	 * @see
	 */
	public String getDecryptStr(String strVal) throws Exception {
		String rtnDecode = "";
		
		final String TRANSFORMATION = "AES/CBC/PKCS5Padding"; 	// 알고리즘/모드/패딩방식
        final String ALGORITHM = "AES"; 		// 복호화 알고리즘
        final String DIGEST = "MD5"; 				// MD5 해싱을 통해 복호화를 위한 16바이트 key, iv 생성 
        final String KEY = "123"; 						// KEY 초기 값 
        final String IV = "456"; 						// IV 초기 값
        
        try  {
        	final Cipher cipher = Cipher.getInstance(TRANSFORMATION);										// 복호화 알고리즘/모드/패딩방식 설정 -> AES/CBC/PKCS7Padding
            final MessageDigest md = MessageDigest.getInstance(DIGEST); 									// KEY와 IV를 MD5 해싱
            final SecretKey key = new SecretKeySpec(md.digest(KEY.getBytes("UTF8")), ALGORITHM); 	// AES 복호화를 위한 key 생성
            final IvParameterSpec ivParamSpec = new IvParameterSpec(md.digest(IV.getBytes("UTF8"))); 	// 복호화를 위한 iv(initial vector) 생성

            cipher.init(Cipher.DECRYPT_MODE, key, ivParamSpec); 		// 복호화 모드로 객체 초기화
            
            byte[] encryptedValue = Base64.decodeBase64(strVal); 		// Base64 디코딩, 아스키 텍스트 -> 바이트 스트림
            byte[] decryptedValue = cipher.doFinal(encryptedValue); 	// AES 복호화 실행 문자열로 변환
            
            rtnDecode = new String(decryptedValue, "UTF8");

        }catch(IOException e){
			e.printStackTrace();
        	rtnDecode = "";
        }
		
		return rtnDecode;
	}
	
	/**
	 * glms 호출 link 
	 * @param strVal
	 * @return
	 * @throws Exception
	 */
	public String getGlmsStr(String distNo, String activityId) throws Exception {
		String redirectURL = "";
		
		final String md5Key = "AG6wTKVcLxCqcK7";  //prod
		//final String md5Key = "LMSQA1";				//qa
		final String DIGEST = "MD5";
		
		try
        {
			final MessageDigest digest = MessageDigest.getInstance(DIGEST);
			
			final int distNoLength = 12;
	        StringBuffer authUserBuffer = new StringBuffer("18"); // Country Code
	        for (int i = 0; i < distNoLength - distNo.length(); i++)
	        {
	        	authUserBuffer = authUserBuffer.append("0");
	        }
	        authUserBuffer = authUserBuffer.append(distNo);
	        String authUser = URLEncoder.encode(authUserBuffer.toString(), "UTF-8"); // URL 인코딩
			
	        LOGGER.debug("authUser : " + authUser);
	        
	        /* get UTC time value */
	        final DateFormat formatter = new SimpleDateFormat("yyyy:MM:dd:HH:mm:ss");
	        formatter.setTimeZone(TimeZone.getTimeZone("UTC"));
	        final Calendar date = Calendar.getInstance();
	        final String currentTime = formatter.format(date.getTime());
	        LOGGER.debug("currentTime : " + currentTime);
	        
	        final String timeStamp = URLEncoder.encode(currentTime, "UTF-8");
	        LOGGER.debug("timeStamp : " + timeStamp);
	
	        /* make authToken */
	        final String encodingStr = authUser + currentTime + md5Key;
	        final byte asciiEncodingBytes[] = encodingStr.getBytes(StandardCharsets.US_ASCII); // 아스키 인코딩
	        final byte hashValueBytes[] = digest.digest(asciiEncodingBytes); // MD5 해싱
	        final String hexStr = byteArrayToHex(hashValueBytes); // Hex 변환
	        
	        //String authToken = Utilities.escapeHTML(hexStr); // HTML 인코딩
	        String authToken = StringEscapeUtils.escapeHtml(hexStr); //소스를 대체해 봄
	        authToken = URLEncoder.encode(authToken, "UTF-8"); // URL 인코딩
	        LOGGER.debug("authToken : " + authToken);
	        
	        /* set returnUrl */
            String returnUrl = "";
            //String returnServerName = isProduction ? "https://www.amwayuniversity.com" : "https://learning-asiapacific.qa.intranet.local";
            //final String returnServerName = "https://learning-asiapacific.qa.intranet.local";
            final String returnServerName = "https://www.amwayuniversity.com";

            if (activityId == null)
            {
                returnUrl = "/Courses/app/management/LMS_ActDetails.aspx";
            }
            else if ("main".equals(activityId))
            {
                returnUrl = "/LandingPage/";
            }
            else
            {
                returnUrl = "/Courses/app/management/LMS_ActDetails.aspx?UserMode=0&ActivityId=" + activityId;
            	//returnUrl = "/Courses/app/management/LMS_ActDetails.aspx?UserMode=0&ActivityId=17217";
            	
            }
            returnUrl = URLEncoder.encode(returnServerName + returnUrl, "UTF-8"); // URL 인코딩
            //returnUrl = URLEncoder.encode(returnUrl, "UTF-8"); // URL 인코딩

            /* alticorReturnUrl */
            final String alticorReturnUrl = URLEncoder.encode("www.abnkorea.co.kr", "UTF-8"); // URL 인코딩

            /* postBackUrl */
            //String postBackUrl = returnServerName + "/Courses/app/SYS_Login.aspx";
            final String postBackUrl = returnServerName + "/LandingPage";

            /* redirectURL */
            redirectURL = postBackUrl + "?RtUserID=" + authUser + "&time_stamp=" + timeStamp + "&auth_token=" + authToken + "&RU=" + returnUrl + "&alticorRU=" + alticorReturnUrl;
            //redirectURL = postBackUrl + "/?RtUserID=" + authUser + "&time_stamp=" + timeStamp + "&auth_token=" + authToken + "&RU=" + returnUrl;

        } catch (final UnsupportedEncodingException e) {
        	LOGGER.error(e.getMessage());
            return null;
        }
		
		return redirectURL;
	}

    public static String byteArrayToHex(final byte[] ba)
    {
        if (ba == null || ba.length == 0)
        {
            return null;
        }
        final StringBuffer sb = new StringBuffer(ba.length * 2);
        String hexNumber;
        for (int i = 0; i < ba.length; i++)
        {
            hexNumber = "0" + Integer.toHexString(0xff & ba[i]);
            sb.append(hexNumber.substring(hexNumber.length() - 2));
        }
        return sb.toString();
    }

	/**
	 * Adobe Analytics 데이터생성.
	 * @param RequestBox
	 * @return Map
	 * @throws 
	 */
	public Map<String, Object> setLmsAdobeAnalytics( HttpServletRequest request, RequestBox requestBox, String sConn) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		// 변수설정
		if(sConn == null ) {
			sConn = "mobile";
		} else if("".equals(sConn)) {
			sConn = "mobile";
		} else if("PC".equals(sConn)) {
			sConn = "desktop";
		} else {
			sConn = "mobile";
		}
		
		String customerID = requestBox.get(LmsCode.userSessionUid);
		String sPinCode = requestBox.get(LmsCode.userSessionPinCode);
		String requestUrl = request.getRequestURL().toString();  // WAS서버 URL
        String pinNumber = ":kr";
        String userProfile = "";
        String sProduction = "true";
        String sUrlAccess = "OPER";	// 접속서버URL 위치 - OPER:운영, DEV:개발
        
		if( requestUrl.indexOf("localhost") >= 0) {
			sProduction = "false";
			sUrlAccess = "DEV";
		} else if ( requestUrl.indexOf("dev2.abnkorea.co") >= 0) {
			sProduction = "false";
			sUrlAccess = "DEV";
		} else if ( requestUrl.indexOf("qa2.abnkorea.co") >= 0) {
			sProduction = "false";
			sUrlAccess = "DEV";
		} else if ( requestUrl.indexOf("aq.abnkorea.co") >= 0) {
			sProduction = "false";
			sUrlAccess = "DEV";
		}
		
		/* imcID 생성 -> Country Code + IBO Number */
        /* 7480003 -> 18000007480003 */
		final int distNoLength = 11;
        StringBuffer imcID = new StringBuffer();
        
        if(customerID == null || customerID.equals("")) {
        	customerID = " ";
        	imcID.append(" ");
        	pinNumber = " ";
        	userProfile = " ";
        } else {
        	imcID.append("180"); // Country Code
        	
	        for (int i = 0; i < distNoLength - customerID.length(); i++) {
	        	imcID.append("0");
	        }
	        imcID.append(customerID);
	        
	        if(!sPinCode.equals(""))  {
	        	pinNumber = sPinCode + ":kr";
	        }
	        
	        if("M".equals(requestBox.get(LmsCode.userSessionAboTypeCode)) ) {
	        	userProfile = "member"; //member
	        } else {
	        	userProfile = "abo";
	        }
        }
        
        rtnMap.put("isProduction", 	sProduction);  // 운영:true, 개발: false
		rtnMap.put("connType", 		sConn);
		rtnMap.put("country", 			"kr");
		rtnMap.put("language", 		"ko");
		rtnMap.put("currencyCode", "krw");
		rtnMap.put("region", 			"apac");
		rtnMap.put("subRegion", 	"korea");
		rtnMap.put("subGroup", 		"korea");
		rtnMap.put("webProperty", 	"ecm");
		
		rtnMap.put("customerID", 	customerID);
		rtnMap.put("imcID", 			imcID.toString());
		rtnMap.put("pinNumber", 	pinNumber);
		rtnMap.put("userProfile", 	userProfile);
		
		rtnMap.put("section", 		"Academy");
		rtnMap.put("category", 	requestBox.get("adobeCategory"));
		rtnMap.put("subCategory", requestBox.get("adobeSubCategory"));
		rtnMap.put("detail", 		requestBox.get("adobeDetail"));
		rtnMap.put("urlAccess", 	sUrlAccess);
		
		return rtnMap;
	}
	
	public String getAmwayGoGooglePlay() {
		String returnValue = "";
		
		String resourceName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties props = new Properties();
		try( InputStream resourceStream = loader.getResourceAsStream(resourceName) ) {
			props.load(resourceStream);
			//삼성 하이브리스 체크 url
			returnValue = props.getProperty("market.amwaygo.googleplay");
		} catch( IOException e) {
			e.printStackTrace();
		}

		return returnValue;
	}
	
	public String getAmwayGoAppStore() {
		String returnValue = "";
		
		String resourceName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties props = new Properties();
		try( InputStream resourceStream = loader.getResourceAsStream(resourceName) ) {
			props.load(resourceStream);
			//삼성 하이브리스 체크 url
			returnValue = props.getProperty("market.amwaygo.appstore");
		} catch( IOException e) {
			e.printStackTrace();
		}

		return returnValue;
	}
	
	public Map<String, Object> getAmwayGoLink() {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		String resourceName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties props = new Properties();
		try( InputStream resourceStream = loader.getResourceAsStream(resourceName) ) {
			props.load(resourceStream);
			returnMap.put("googleplay", props.getProperty("market.amwaygo.googleplay"));
			returnMap.put("appstore", props.getProperty("market.amwaygo.appstore"));
		} catch( IOException e) {
			e.printStackTrace();
		}
		return returnMap;
	}
	
}

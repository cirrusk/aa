package amway.com.academy.common.util;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.IOException;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import java.net.URL;

public class CheckSSO {

	private static final Logger LOGGER = LoggerFactory.getLogger(CheckSSO.class);

	public static String ssoCheck(HttpServletRequest request, String urlString) {

		String distNo = "";

		try {
			String ssoToken = "";

LOGGER.debug("urlString="+urlString);

	        Cookie[] cookies = request.getCookies();

	        if(null != cookies) {
				/* 유효한 연결이면 requestMap 객체 생성 */
	            for(Cookie cookie : cookies){
	                String cookieName = cookie.getName();
	                String cookieValue = cookie.getValue();

LOGGER.debug("cookieName = " + cookieName);
	                if("i_mar".equals(cookieName)){
	                    ssoToken = cookieValue;
	                    break;
	                }
	            }
	        }

LOGGER.debug("ssoToken="+ssoToken);
			if(!ssoToken.equals("")) {
				URL url = new URL(urlString);
				CommonAPI.getCommHTTPS("SSL");
				HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection();
				urlConnection.setDoOutput(true);
				urlConnection.setRequestMethod("GET");
				urlConnection.setRequestProperty("ssoToken", ssoToken);

				urlConnection.getHeaderFields();

				int responsCode = urlConnection.getResponseCode();
LOGGER.debug("responsCode=" + responsCode);

				int success = 202;
				int fail = 401;

				// 성공 202 / 실패 401
				if (responsCode == fail) {
					distNo = "ERROR";
				} else if (responsCode == success) {
					String deDistNo = urlConnection.getHeaderField("dist_no");
					// 복호화
					byte[] byteDistNo = Base64.decodeBase64(deDistNo);
					distNo = new String(byteDistNo);
LOGGER.debug("dist_no=" + distNo);
				}
				urlConnection.disconnect();
			}
		} catch ( IOException e) {
LOGGER.debug("Exception error");
			distNo = "ERROR";
			e.printStackTrace();
		}

        return distNo;
    }

}

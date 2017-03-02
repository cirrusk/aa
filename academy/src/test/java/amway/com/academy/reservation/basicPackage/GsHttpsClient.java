package amway.com.academy.reservation.basicPackage;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.cert.X509Certificate;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.springframework.web.servlet.ModelAndView;

/**
 * <pre>
 * </pre>
 * Program Name  : GsHttpsClient.java
 * Author : KR620207
 * Creation Date : 2016. 9. 1.
 */
public class GsHttpsClient extends GlmsAPI{

//	public static void main(String[] args) {
	
	public void test(String urlStr) {
		//String urlStr = "https://www.google.com";
		
		StringBuffer sb = new StringBuffer();

		try {
			TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
				public java.security.cert.X509Certificate[] getAcceptedIssuers() {
					return null;
				}

				public void checkClientTrusted(X509Certificate[] certs,
						String authType) {
				}

				public void checkServerTrusted(X509Certificate[] certs,
						String authType) {
				}
			} };

			SSLContext sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new java.security.SecureRandom());
			HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

			//URL url = new URL(urlStr);
			//HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			String token = token();
			System.out.println("token :" + token);
			
			// certification
			HttpsURLConnection conn = (HttpsURLConnection) new URL(urlStr).openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Accept", "application/xml");
	        conn.setRequestProperty("Authorization", token);
	        conn.setRequestProperty("ssoToken", token);
			
			conn.setHostnameVerifier(new CustomizedHostNameVerifier());

			InputStreamReader in = new InputStreamReader((InputStream) conn.getContent());
			BufferedReader br = new BufferedReader(in);

			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line).append("\n");
			}

			System.out.println(sb.toString());
			br.close();
			in.close();
			conn.disconnect();

		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
    
}


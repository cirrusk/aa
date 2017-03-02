package amway.com.academy.reservation.basicPackage;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.*;

import java.security.cert.X509Certificate;

import javax.net.ssl.SSLSocketFactory;

import org.apache.http.conn.ssl.NoopHostnameVerifier;
import org.apache.http.conn.ssl.TrustStrategy;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.junit.Test;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;


/**
 * <pre>
 * </pre>
 * Program Name  : ReservationCommonApiServiceTest.java
 * Author : KR620207
 * Creation Date : 2016. 8. 12.
 */
public class ReservationCommonApiServiceTest {

	@Test
	public void authentication() throws Exception {
		
		/* 인증 */
		String authUrl = "https://dev2.abnkorea.co.kr/rest/oauth/token?client_id=t7OBlETHAD&client_secret=eab393de-5ce9-454a-a062-25f08671da54&grant_type=client_credentials";

	
		//RestTemplate restTemplate = new RestTemplate();
		
		CloseableHttpClient httpClient = 
			      HttpClients.custom()
			                 .setSSLHostnameVerifier(new NoopHostnameVerifier())
			                 .build();
		
		HttpComponentsClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory();
		requestFactory.setHttpClient(httpClient);
		    
		try{
			ResponseEntity<String> response = new RestTemplate(requestFactory).exchange(authUrl, HttpMethod.GET, null, String.class);
			System.out.println("authResult : " + response.toString());
			
			assertThat(response.getStatusCode().value(), equalTo(200));
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
	@Test
	public void creditCardCompany() throws Exception {
		new GlmsAPI().creditCardCompany();
	}
	
	@Test
	public void connectToHttpsUrl() throws Exception {
		try{
			
			GsHttpsClient hc = new GsHttpsClient();
			hc.test("https://qa2.abnkorea.co.kr/rest/store/creditCardCompany");
			//hc.test("https://www.google.com");
			
		}catch (Exception e){
			System.out.println(e);
		}
	}
	
	@Test
	public void creditCardCompanyList() throws Exception {
		
		
		
		
		/* 개발 */
		String domain = "http://dev2.abnkorea.co.kr";
		
		/* QA */
		//String domain = "http://dev2.abnkorea.co.kr";
		
		String url = "/rest/store/creditCardCompany"; 
		
		RestTemplate restTemplate = new RestTemplate();
		
		String result = restTemplate.getForObject( domain + url, String.class);
		System.out.println("result : " + result);
		
		assertTrue(true);
	}

}

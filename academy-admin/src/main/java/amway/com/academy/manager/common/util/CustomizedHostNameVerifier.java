package amway.com.academy.manager.common.util;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;

/**
 * <pre>
 * </pre>
 * Program Name  : CustomizedHostNameVerifier.java
 * Author : KR620207
 * Creation Date : 2016. 9. 2.
 */
public class CustomizedHostNameVerifier implements HostnameVerifier {

	/* (non-Javadoc)
	 * @see javax.net.ssl.HostnameVerifier#verify(java.lang.String, javax.net.ssl.SSLSession)
	 */
	@Override
	public boolean verify(String arg0, SSLSession arg1) {
		// TODO Auto-generated method stub
		//return false;
		return true;
	}

}

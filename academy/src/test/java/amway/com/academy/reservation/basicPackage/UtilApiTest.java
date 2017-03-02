package amway.com.academy.reservation.basicPackage;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import amway.com.academy.common.util.UtilAPI;

/**
 * <pre>
 * </pre>
 * Program Name  : UtilApiTest.java
 * Author : KR620207
 * Creation Date : 2016. 9. 6.
 */
public class UtilApiTest {

	@Test
	public void creditCardCompany() throws Exception {
		new UtilAPI().creditCardCompany();
		
		assertTrue(true);
	}
}

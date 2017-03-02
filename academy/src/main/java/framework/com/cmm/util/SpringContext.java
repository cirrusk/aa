package framework.com.cmm.util;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class SpringContext implements ApplicationContextAware {

	private static ApplicationContext ctx = null;
	
	@Override
	public void setApplicationContext(ApplicationContext ctx) throws BeansException {
		SpringContext.ctx = ctx;
	}
	
	public static Object getBean(String beanName) {
		return ctx.getBean(beanName);
	}
}
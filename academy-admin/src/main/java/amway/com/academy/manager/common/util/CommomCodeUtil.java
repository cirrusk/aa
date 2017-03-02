package amway.com.academy.manager.common.util;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import amway.com.academy.manager.common.commoncode.service.ManageCodeService;

@Component
public class CommomCodeUtil  {

	@Autowired
	private ManageCodeService manageCodeService;
	
	public List<Map<String, String>> codeListCommonTag(String majorCd, String except) {
		
		Map<String, String> cMap = new HashMap<String, String>();
		cMap.put("majorCd", majorCd); // 유형 : 연구형, 학습형
		cMap.put("except", except);

		List<Map<String, String>> list = manageCodeService.getCodeList(cMap);

		return list;
	}
	
	
	public boolean getSchedulerUseYn() {
		Boolean bool = false;
		
		String resourceName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties props = new Properties();
		try( InputStream resourceStream = loader.getResourceAsStream(resourceName) ) {
			props.load(resourceStream);
			//삼성 하이브리스 체크 url
			if("Y".equals(props.getProperty("scheduler.useYn")) ){
				bool = true;
			}
		} catch( IOException e) {

		}
		return bool;
	}
	
}
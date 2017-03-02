package amway.com.academy.common.util;

import framework.com.cmm.lib.RequestBox;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

import java.util.Map;

/**
 * Created by KR620242 on 2016-09-06.
 */
@Controller
@RequestMapping("/framework/com")
public class TestAPIController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(TestAPIController.class);

    @RequestMapping(value = "/testAPI.do")
    public ModelAndView testAPI(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox)throws Exception{
        // 카드 혜택 전체
        // Map testAPI = UtilAPI.creditCardCompany("all","");
        // 카드 혜택 단일 카드
        // Map testAPI = UtilAPI.creditCardCompanyOne("4");
        // AP 정보 리스트
        // Map testAPI = UtilAPI.getApInfo();
        // as400 점검시간 체크
        // Map testAPI = UtilAPI.getEcmsInfo();
        // 영수증
        // Map testAPI = UtilAPI.getReceipts("130304099");
        // 임시주문번호로 주문번호 받아 오기
        // Map testAPI = UtilAPI.getInvoice("20160916","130304099");
        // 회원 여부 확인
    	//Map testAPI = UtilAPI.checkUser("7480003","05050101");
        // 토근 가져오기
        String testAPI = UtilAPI.token();

        LOGGER.debug("testAPI"+testAPI);
        mav.addObject("result", testAPI);

        return mav;
    }

    @RequestMapping(value = "/testCheckAPI.do")
    public ModelAndView testCheckAPI(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox)throws Exception{

        // 주문 체크 (주문생성 전에 선행)
        String xmlSource = XmlSource.xmlSource();
        Map testAPI = UtilAPI.checkOrder(xmlSource);

        LOGGER.debug("testAPI"+testAPI);

        mav.addObject("result", testAPI);

        return mav;
    }

    @RequestMapping(value = "/testOrderAPI.do")
    public ModelAndView testOrderAPI(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox)throws Exception{

        // 주문생성
        String xmlOrderSource = XmlSource.xmlOrderSource();
        Map testOrderAPI = UtilAPI.orderCreate(xmlOrderSource);

        LOGGER.debug("testOrderAPI"+testOrderAPI);

        mav.addObject("result", testOrderAPI);

        return mav;
    }


    @RequestMapping(value = "/testCancelAPI.do")
    public ModelAndView testCancelAPI(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox)throws Exception{

        // 취소 신청
        String xmlCancelSource = XmlSource.xmlCancelSource();
        Map testCancelAPI = UtilAPI.cancelOrder(xmlCancelSource);

        LOGGER.debug("testCancelAPI"+testCancelAPI);

        mav.addObject("result", testCancelAPI);

        return mav;
    }


    @RequestMapping(value = "/testBase64.do")
    public ModelAndView testBase64(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox)throws Exception{

        // 취소 신청
        String enDistNo = "NzQ4MDAwMw==";

        byte[] byteDistNo = Base64.decodeBase64(enDistNo);

        String distNo = new String(byteDistNo);

        LOGGER.debug("distNo"+distNo);

        mav.addObject("byteDistNo", byteDistNo);
        mav.addObject("dist_no", distNo);

        return mav;
    }


}

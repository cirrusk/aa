package amway.com.academy.manager.common.menuApi.web;

import amway.com.academy.manager.common.menuApi.service.MenuApiService;
import amway.com.academy.manager.common.util.PropertiesReader;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;
import org.apache.ibatis.transaction.TransactionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by KR620242 on 2016-10-18.
 */
@Controller
@RequestMapping("/manager/common/menuApi")
public class MenuApiController {
    /** log */
    @SuppressWarnings("unused")
    private static final Logger LOGGER = LoggerFactory.getLogger(MenuApiController.class);

    @Autowired
    MenuApiService menuApiService;

    @RequestMapping(value = "/navigationApi.do")
    public ModelAndView testAPI(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox)throws Exception {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        PropertiesReader ppt = new PropertiesReader();

        int result = 0;

        try {
            result = menuApiService.navigationInsert(requestBox);

            resultMap.put("errCode", result);
            resultMap.put("errMsg", "");
        } catch (TransactionException e) {
            e.printStackTrace();
            String msg = ppt.getProperties("errors.system");
            resultMap.put("errMsg", msg);
        }

        rtnMap.put("result", resultMap);
        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT", rtnMap);
        return mav;
    }
}

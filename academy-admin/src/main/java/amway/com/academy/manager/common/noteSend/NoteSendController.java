package amway.com.academy.manager.common.noteSend;

import javax.servlet.http.HttpServletRequest;

import amway.com.academy.manager.common.noteSend.service.NoteSendService;
import amway.com.academy.manager.common.noteSet.service.NoteSetService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import framework.com.cmm.lib.RequestBox;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/manager/common/noteSend")
public class NoteSendController {
    /** log */
    @SuppressWarnings("unused")
    private static final Logger LOGGER = LoggerFactory.getLogger(NoteSendController.class);

    @Autowired
    NoteSendService noteSendService;

    /**
     *  발신이력 리스트
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/noteSendList.do")
    public ModelAndView noteSendList(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        return mav;
    }

    /**
     *  발신이력 리스트(AJAX)
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/noteSendListAjax.do")
    public ModelAndView noteSendListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        //페이징
        PageVO pageVO = new PageVO(requestBox);
        pageVO.setTotalCount(noteSendService.noteSendListCount(requestBox));

        requestBox.putAll(pageVO.toMapData());
        PagingUtil.defaultParmSetting(requestBox);

        //리스트
        rtnMap.putAll(pageVO.toMapData());
        rtnMap.put("dataList",noteSendService.noteSendList(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT",  rtnMap);
        return mav;
    }
}
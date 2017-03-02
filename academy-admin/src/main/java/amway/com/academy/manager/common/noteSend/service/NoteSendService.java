package amway.com.academy.manager.common.noteSend.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

public interface NoteSendService {

    /**
     * 발신이력 리스트 카운트
     * @param requestBox
     * @return
     * @throws Exception
     */
    public int noteSendListCount(RequestBox requestBox) throws Exception;

    /**
     * 발신이력 리스트
     * @param requestBox
     * @return
     * @throws Exception
     */
    public List<DataBox> noteSendList(RequestBox requestBox) throws Exception;

}

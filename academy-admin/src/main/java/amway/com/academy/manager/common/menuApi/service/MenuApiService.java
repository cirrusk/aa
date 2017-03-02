package amway.com.academy.manager.common.menuApi.service;

import framework.com.cmm.lib.RequestBox;

/**
 * Created by KR620242 on 2016-10-18.
 */
public interface MenuApiService {
    /**
     * 코드관리 등록
     * @param requestBox
     * @throws Exception
     */
    public int navigationInsert(RequestBox requestBox) throws Exception;
}

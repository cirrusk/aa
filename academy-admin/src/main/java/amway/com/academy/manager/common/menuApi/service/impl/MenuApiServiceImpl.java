package amway.com.academy.manager.common.menuApi.service.impl;

import amway.com.academy.manager.common.menuApi.service.MenuApiService;
import amway.com.academy.manager.common.util.NavigationAPI;
import framework.com.cmm.lib.RequestBox;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Created by KR620242 on 2016-10-18.
 */
@Service
public class MenuApiServiceImpl implements MenuApiService {

    @Autowired
    private MenuApiMapper menuApiMapper;

    // list insert
    @Override
    public int navigationInsert(RequestBox requestBox) throws Exception{
        int result = 0;

        List<Map<String, Object>> testAPI = NavigationAPI.navigation();

        for( int i=0; i<testAPI.size(); i++ ) {
            Map<String,Object> retMap = testAPI.get(i);
            result = menuApiMapper.navigationInsert(retMap);
        }

        return result;
    }
}

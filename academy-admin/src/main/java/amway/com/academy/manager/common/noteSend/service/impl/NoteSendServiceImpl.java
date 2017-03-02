package amway.com.academy.manager.common.noteSend.service.impl;

import amway.com.academy.manager.common.noteSend.service.NoteSendService;
import amway.com.academy.manager.common.noteSet.service.NoteSetService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NoteSendServiceImpl implements NoteSendService {

    @Autowired
    private NoteSendMapper noteSendMapper;

    //list count
    @Override
    public int noteSendListCount(RequestBox requestBox) throws Exception {
        return noteSendMapper.noteSendListCount(requestBox);
    }

    //list
    @Override
    public List<DataBox> noteSendList(RequestBox requestBox) throws Exception {
        return noteSendMapper.noteSendList(requestBox);
    }
}
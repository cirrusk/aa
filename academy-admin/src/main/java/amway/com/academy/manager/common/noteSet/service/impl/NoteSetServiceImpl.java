package amway.com.academy.manager.common.noteSet.service.impl;

import amway.com.academy.manager.common.noteSet.service.NoteSetService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NoteSetServiceImpl implements NoteSetService {
	
	@Autowired
	private NoteSetMapper noteSetMapper;

	//count
	@Override
	public int noteSetListCount(RequestBox requestBox) throws Exception {
		return (int) noteSetMapper.noteSetListCount(requestBox);
	}

	//list
	@Override
	public List<DataBox> noteSetList(RequestBox requestBox) throws Exception {
		return noteSetMapper.noteSetList(requestBox);
	}

	// list popup
	@Override
	public DataBox noteSetPop(RequestBox requestBox) throws Exception {
		return noteSetMapper.noteSetPop(requestBox);
	}

	// list insert
	@Override
	public int noteSetInsert(RequestBox requestBox) throws Exception{
		int result = 0;
		result = noteSetMapper.noteSetInsert(requestBox);
		return result;
	}

	// list update
	@Override
	public int noteSetUpdate(RequestBox requestBox) throws  Exception{
		return noteSetMapper.noteSetUpdate(requestBox);
	}

	// list delete
	@Override
	public void noteSetDelete(RequestBox requestBox) throws Exception{
		noteSetMapper.noteSetDelete(requestBox);
	}

}
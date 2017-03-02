package amway.com.academy.manager.common.targetUpload.service.impl;

import amway.com.academy.manager.common.targetUpload.service.TargetUploadService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TargetUploadServiceImpl implements TargetUploadService {
	
	@Autowired
	private TargetUploadMapper targetUploadMapper;

	@Autowired
	private ExcelMapper dao;

	//Count
	@Override
	public int targetUploadListCount(RequestBox requestBox) throws Exception {
		return (int)targetUploadMapper.targetUploadListCount(requestBox);
	}

	//List
	@Override
	public List<DataBox> targetUploadList(RequestBox requestBox) throws Exception {
		return targetUploadMapper.targetUploadList(requestBox);
	}

	//detail pop data
	@Override
	public DataBox targetUploadDetailPop(RequestBox requestBox) throws Exception {
		return targetUploadMapper.targetUploadDetailPop(requestBox);
	}

	//detail pop
	@Override
	public List<DataBox> targetUploadListCntPop(RequestBox requestBox) throws Exception {
		return targetUploadMapper.targetUploadListCntPop(requestBox);
	}

	//detail pop count
	@Override
	public int targetUploadListCntPopCount(RequestBox requestBox) throws Exception {
		return (int)targetUploadMapper.targetUploadListCntPopCount(requestBox);
	}

	//insert
	@Override
	public int targeterUploadInsert(RequestBox requestBox) throws Exception{
		targetUploadMapper.targeterUploadInsert(requestBox);
		int upSeq = requestBox.getInt("groupseq");

		return upSeq;
	}

	//insert excelupload
	@Override
	public int insertExcelData(Map<String, Object> params) throws Exception {
		int result = 0;
		result = targetUploadMapper.insertExcelData(params);
		return  result;
	}

	//delete
	@Override
	public int targetUploadDelete(RequestBox requestBox) throws Exception{
		return targetUploadMapper.targetUploadDelete(requestBox);
	}

	@Override
	public int targetUploadDetailDelete(RequestBox requestBox) throws Exception{
		return targetUploadMapper.targetUploadDetailDelete(requestBox);
	}

	//delete
	@Override
	public int targetUploadDelseq(RequestBox requestBox) throws Exception {
		return targetUploadMapper.targetUploadDelseq(requestBox);
	}

	//vaild
	@Override
	public String[][] validExcel(String[][] importData, RequestBox requestBox) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String[] strData = {};
		int result = 0;

		for(int i=0;i<importData.length;i++){
			strData = importData[i];

			if("target".equals("target")){
				paramMap.put("aboname", strData[0]);
				paramMap.put("abono", strData[1]);

				result = dao.selectValidAgree(paramMap);
				int reNum = 1;

				if(result==reNum){
					continue;
				}else{
					importData[0][0] = "-1";
					importData[0][1] = "존재 하지 않는 ABO번호가 있습니다.";
					break;
				}

			}
		}

		return importData;
	}

}
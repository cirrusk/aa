package framework.com.cmm.common.vo;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import egovframework.rte.fdl.property.EgovPropertyService;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.SpringContext;
import framework.com.cmm.util.StringUtil;

public class PageVO implements Serializable {
	private static final long serialVersionUID = -5483184827782226548L;
	
    @Autowired
    protected EgovPropertyService propertiesService;

	/** 페이지 넘버 */ 
    private int page = 1;
    
    /** 레코드 번호 */ 
    private int rowPerPage = 1;
    
    /** 전체_건수 */ 
    private int totalCount = 0;
    
    /** 현재페이지 */
	private int pageIndex = 1;

	/** 페이지갯수 */
	private int pageUnit = 10;

	/** 페이지사이즈 */
	private int pageSize = 10;

	/** firstIndex */
	private int firstIndex = 1;

	/** lastIndex */
	private int lastIndex = 1;

	/** recordCountPerPage */
	private int recordCountPerPage = 10;
	
    public EgovPropertyService getPropertiesService() {
		return propertiesService;
	}

	public void setPropertiesService(EgovPropertyService propertiesService) {
		this.propertiesService = propertiesService;
	}

	public int getPageIndex() {
		return pageIndex;
	}

	public void setPageIndex(int pageIndex) {
		this.pageIndex = pageIndex;
	}

	public int getPageUnit() {
		return pageUnit;
	}

	public void setPageUnit(int pageUnit) {
		this.pageUnit = pageUnit;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getFirstIndex() {
		return firstIndex;
	}

	public void setFirstIndex(int firstIndex) {
		this.firstIndex = firstIndex;
	}

	public int getLastIndex() {
		return lastIndex;
	}

	public void setLastIndex(int lastIndex) {
		this.lastIndex = lastIndex;
	}

	public int getRecordCountPerPage() {
		return recordCountPerPage;
	}

	public void setRecordCountPerPage(int recordCountPerPage) {
		this.recordCountPerPage = recordCountPerPage;
	}

	private String pageSortColumn = null;
    
    private String pageSortOrder = null;

    public PageVO() {
    	// Do Nothing
	}
	
    public PageVO(RequestBox requestBox) {
		// Page & RowNum
		if(requestBox.containsKey("sortIndex")) {
			this.setPage(requestBox.getInt("page"));
			this.setRowPerPage(requestBox.getInt("rowPerPage"));
		}
		
		// Sort Order
		if (requestBox.containsKey("sortIndex")) {
			// 1. Generate Sort Column
			EgovPropertyService propertyService = (EgovPropertyService) SpringContext.getBean("propertiesService");
			
			Integer sortIndex = requestBox.getInt("sortIndex");
			String sortColKey = requestBox.getString("sortColKey");
			
			String[] sortColumns = propertyService.getString(sortColKey).split("\\|");
			
			this.setPageSortColumn(sortColumns[sortIndex]);
			
			// 2. Generate Sort Order
			String sortOrder = requestBox.getString("sortOrder");
			
			if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
				this.setPageSortOrder(sortOrder.toUpperCase());
			} else {
				this.setPageSortOrder("DESC");
			}
		}
    }

	public int getPage() {
		if(this.page > getTotalCount()) {
            return getTotalCount();
        }
	        
		return page;
	}
	
	public void setPage(int page) {
		if(page < 1) {
            this.page = 1;
        } else {
            this.page = page;
        }
	}
	
    public void setPage(String page) {
    	if("".equals(StringUtil.nvl(page, ""))) {
            this.page = 1;
        }
        
        try {
            this.page = Integer.parseInt(page);
        } catch(NumberFormatException nfe) {
        	throw new IllegalArgumentException(nfe);
        }
    }
    
    public void setPage(Object page) {
        setPage(String.valueOf(page));
    }

	public int getRowPerPage() {
		return rowPerPage < 1 ? 10 : rowPerPage;
	}

	public void setRowPerPage(int rowPerPage) {
		this.rowPerPage = rowPerPage;
	}
	
    public void setRowPerPage(String rowPerPage) {
    	if("".equals(StringUtil.nvl(rowPerPage, ""))) {
            this.rowPerPage = 1;
        }
        
        try {
            this.rowPerPage = Integer.parseInt(rowPerPage);
        } catch(NumberFormatException nfe) {
        	throw new IllegalArgumentException(nfe);
        }
    }
    
    public void setRowPerPage(Object page) {
    	setRowPerPage(String.valueOf(page));
    }

	public int getTotalCount() {
		return totalCount;
	}
	
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public void setTotalCount(String totalCount) {
    	if("".equals(StringUtil.nvl(totalCount, ""))) {
            this.totalCount = 0;
        }
        
        try {
            this.totalCount = Integer.parseInt(totalCount);
        } catch(NumberFormatException nfe) {
        	throw new IllegalArgumentException(nfe);
        }
    }
	
	public String getPageSortColumn() {
		return pageSortColumn;
	}
	
	public void setPageSortColumn(String pageSortColumn) {
		this.pageSortColumn = pageSortColumn;
	}

	public String getPageSortOrder() {
		return pageSortOrder;
	}
	
	public void setPageSortOrder(String pageSortOrder) {
		this.pageSortOrder = pageSortOrder;
	}
    
    public int getTotalPages() {
    	int iTotalPage = 1;
    	
        if(getTotalCount() < 1) {
        	iTotalPage = 1;
        }
        
		if(getTotalCount() < 1) {
			iTotalPage = 1;
		} else if(getTotalCount() >= 1) {
			iTotalPage =  getTotalCount() / getRowPerPage();
			if( (getTotalCount() % getRowPerPage()) > 0 ) iTotalPage++; //나머지가 있다면 1증가 
		}
		
        return iTotalPage;
    }
    
    public Map<String, Object> toMapData() {
    	Map<String, Object> map = new HashMap<String, Object>();

    	// 1. Basic Paging Key
    	map.put("page", getPage());
    	map.put("rowPerPage", getRowPerPage());
    	map.put("totalPage", getTotalPages());
    	map.put("totalCount", getTotalCount());
    	map.put("firstIndex", ((getPage() - 1) * getRowPerPage()) + 1 );
        
    	// 2. Order Paging Key
    	if (pageSortColumn != null && pageSortOrder != null) {
    		map.put("sortColumn", pageSortColumn);
    		map.put("sortOrder", pageSortOrder);
    	}
    	
    	return map;
    }
}
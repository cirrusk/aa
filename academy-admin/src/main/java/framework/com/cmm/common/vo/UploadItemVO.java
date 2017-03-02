package framework.com.cmm.common.vo;

import java.util.List;

import org.codehaus.jackson.annotate.JsonIgnore;
import org.springframework.web.multipart.MultipartFile;

public class UploadItemVO {
	
	private static final long serialVersionUID = -1111109141399889059L;
	
	private long maxLength; // max bytes 
	private boolean checkedImage;
	private int width;
	private int height;
	private String targetExts; // jpg,png,gif
	private int rdSeq;
	private String name;
	
	/**
	 * TMP/RANDOM_SEQ
	 */
	public int getRdSeq() {
		return rdSeq;
	}

	public void setRdSeq(int rdSeq) {
		this.rdSeq = rdSeq;
	}

	@JsonIgnore
	private List<MultipartFile> fileData;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		//System.out.println("====================>" + name);
		this.name = name;
	}
	
	@JsonIgnore
	public List<MultipartFile> getFileData() {
		return fileData;
	}

	public void setMaxLength(long maxLength) {
		this.maxLength = maxLength;
	}

	public void setCheckedImage(boolean checkedImage) {
		this.checkedImage = checkedImage;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	public void setHeight(int height) {
		this.height = height;
	}

	public void setFileData(List<MultipartFile> fileData) {
		this.fileData = fileData;
	}

	public void setTargetExts(String targetExts) {
		this.targetExts = targetExts;
	}

	@JsonIgnore
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	@JsonIgnore
	public long getMaxLength() {
		return maxLength;
	}
	
	@JsonIgnore
	public boolean isCheckedImage() {
		return checkedImage;
	}
	
	@JsonIgnore
	public int getWidth() {
		return width;
	}
	
	@JsonIgnore
	public int getHeight() {
		return height;
	}

	@JsonIgnore
	public String getTargetExts() {
		return targetExts;
	}

}

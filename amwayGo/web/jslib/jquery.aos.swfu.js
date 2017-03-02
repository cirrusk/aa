/**
 * jquery.aos.swfu.js
 * author : jkk5246@gmail.com
 * version : 3.0.0
 * created : 2013.05.08
 */
var _fileinfo_ = {
	version : "3.2.1"
};
var SWFU = {
	create : function(options) {
		var publics = {
			uploader : {},
			completeCallback : typeof options === "object" && typeof options.completeCallback === "function" ? options.completeCallback : null,
			progressCallback : typeof options === "object" &&  typeof options.progressCallback === "function" ? options.progressCallback : null,
			fileLimitType : typeof options === "object" &&  typeof options.fileLimitType === "string" ? options.fileLimitType : null, // 어떤 경우에도 선택불가능한 파일 확장자들, 세미콜론 구분자 사용  
			create : function(elementId, options) {
				var _super = this;
				var fn = {
					/**
					 * The swfUploadLoaded event is fired by flashReady. (uploader로드가 되면 발생하는 이벤트) 
					 * It is settable. 
					 * swfUploadLoaded is called to let you know that it is safe to call SWFUpload methods.
					 */
					uploadLoaded : function() {
						// alert("swfUploadLoaded");
						var stats = this.getStats();
						if (typeof this.settings.custom_settings.previousUploaded === "number") {
							stats.successful_uploads = this.settings.custom_settings.previousUploaded;
							this.setStats(stats);
						}
					},
					/**
					 * fileDialogStart is fired after selectFile for selectFiles is called. (파일선택 다이얼로그가 오픈될 때 발생하는 이벤트)
					 * This event is fired immediately before the File Selection Dialog window is displayed. 
					 * However, the event may not execute until after the Dialog window is closed.
					 */
					fileDialogStart : function() {
						//alert("fileDialogStart");
						if (this.settings.file_upload_limit == 1) { // 파일 한개만 업로드 가능한 경우에는 기존 데이타를 취소한다.
							this.cancelUpload(null, false);
							if (this.settings.custom_settings.immediatelyUpload === true) { // 즉시 업로드인 경우, 이미 업로드가 된 것도 취소 해야한다.
								var stats = this.getStats();
								stats.successful_uploads = 0;
								this.setStats(stats);
								this["uploadedData"] = {};
							}
							if (typeof this.settings.custom_settings.canceled === "function") {
								this.settings.custom_settings.canceled.call(this, {id : this.settings.button_placeholder_id});
							}
						}
					},
					/**
					 * The fileQueued event is fired for each file that is queued after the File Selection Dialog window is closed.
					 * (파일선택 후 파일 선택 다이얼로그가 닫히면서 발생하는 이벤트)
					 */
					fileQueued : function(file) {
						//alert("fileQueued");
						var valid = true;
						if (typeof _super.fileLimitType === "string") {
							var types = _super.fileLimitType.split(";");
							for (var index in types) {
								if ("." + types[index].trim().toLowerCase() == file.type.toLowerCase()) {
									this.cancelUpload(file.id, false);
									alert(UT.formatString(SWFU.message.QUEUE_INVALID_FILETYPE, {name : file.name}));
									valid = false;
									break;
								}
							}
						}
						if (typeof this.settings.custom_settings.selected === "function" && valid == true) {
							this.settings.custom_settings.selected.call(this, {
								"id" : this.settings.button_placeholder_id, 
								"deleteIconUrl" : this.settings.custom_settings.deleteIconUrl
							}, valid == true ? file : null);
						}
					},
					/**
					 * The fileQueueError event is fired for each file that was not queued after the File Selection Dialog window is closed. 
					 * A file may not be queued for several reasons such as, the file exceeds the file size, the file is empty or a file or queue limit has been exceeded.
					 * The reason for the queue error is specified by the error code parameter. 
					 * The error code corresponds to a SWFUpload.QUEUE_ERROR constant.
					 */
					fileQueueError : function(file, errorCode, message) {
						switch (errorCode) {
						case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT :
							alert(UT.formatString(SWFU.message.QUEUE_EXCEEDS_SIZE_LIMIT, {
								name : file.name, 
								size : UT.getFilesize(file.size), 
								limit : this.settings.file_size_limit 
							}));
							break;
						case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE :
							alert(UT.formatString(SWFU.message.QUEUE_ZERO_BYTE_FILE, {name : file.name}));
							break;
						case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE :
							alert(UT.formatString(SWFU.message.QUEUE_INVALID_FILETYPE, {name : file.name}));
							break;
						case SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED :
							alert(UT.formatString(SWFU.message.QUEUE_LIMIT_EXCEEDED, {
								limit : this.settings.file_queue_limit
							}));
							break;
						default:
							alert(UT.formatString(SWFU.message.ETC, {name : file.name}));
							break;
						}
					},
					/**
					 * The fileDialogComplete event fires after the File Selection Dialog window has been closed and all the selected files have been processed. 
					 * The 'number of files queued' argument indicates the number of files that were queued from the dialog selection (as opposed to the number of files in the queue).
					 * If you want file uploading to begin automatically this is a good place to call 'this.startUpload()'
					 * 파일선택 다이얼로그가 닫힐 때 발생하는 이벤트, fileQueue 이벤트 후에 발생.
					 */
					fileDialogComplete : function(numFilesSelected, numFilesQueued, totalNumFilesQueued) {
						//alert("fileDialogComplete\n" + "numFilesSelected:" + numFilesSelected + "\nnumFilesQueued:" + numFilesQueued + "\ntotalNumFilesQueued:" + totalNumFilesQueued);
						if (this.settings.custom_settings.immediatelyUpload === true && numFilesQueued > 0) { // 즉시업로드이고, 파일이 선택되었을 때 업로드를 실시한다.
							this.startUpload();
						}
					},
					/**
					 * uploadStart is called immediately before the file is uploaded. 
					 * This event provides an opportunity to perform any last minute validation, add post params or do any other work before the file is uploaded.
					 * The upload can be cancelled by returning 'false' from uploadStart. 
					 * If you return 'true' or do not return any value then the upload proceeds. 
					 * Returning 'false' will cause an uploadError event to fired.
					 */
					uploadStart : function(file) {
						//alert("uploadStart");
						if (typeof _super.progressCallback === "function") {
							_super.progressCallback.call(this, "open", {name : file.name, progress : 0});
						}
					},
					/**
					 * The uploadProgress event is fired periodically by the Flash Control. 
					 * This event is useful for providing UI updates on the page.
					 * Note: The Linux Flash Player fires a single uploadProgress event after the entire file has been uploaded. 
					 *       This is a bug in the Linux Flash Player that we cannot work around.
					 */
					uploadProgress : function(file, bytesLoaded, bytesTotal) {
						//alert("uploadProgress");
						var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
						if (typeof _super.progressCallback === "function") {
							_super.progressCallback.call(this, "progress", {name : file.name, progress : percent});
						}
					},
					/**
					 * The uploadError event is fired any time an upload is interrupted or does not complete successfully. 
					 * The error code parameter indicates the type of error that occurred. 
					 * The error code parameter specifies a constant in SWFUpload.UPLOAD_ERROR.
					 * Stopping, Cancelling or returning 'false' from uploadStart will cause uploadError to fire. 
					 * Upload error will not fire for files that are cancelled but still waiting in the queue.
					 * •HTTP_ERROR            - The file upload was attempted but the server did not return a 200 status code.
					 * •MISSING_UPLOAD_URL    - The upload_url setting was not set.
					 * •IO_ERROR              - Some kind of error occurred while reading or transmitting the file. This most commonly occurs when the server unexpectedly terminates the connection.
					 * •SECURITY_ERROR        - The upload violates a security restriction. This error is rare.
					 * •UPLOAD_LIMIT_EXCEEDED - The user has attempted to upload more files than is allowed by the file_upload_limit setting.
					 * •UPLOAD_FAILED         - The attempt to initiate the upload caused an error. This error is rare.
					 * •SPECIFIED_FILE_ID_NOT_FOUND - A file ID was passed to startUpload but that file ID could not be found.
					 * •FILE_VALIDATION_FAILED - False was returned from the uploadStart event
					 * •FILE_CANCELLED        - cancelUpload was called
					 * •UPLOAD_STOPPED        - stopUpload was called.
					 * 업로드 실패시 발생하는 이벤트
					 */
					uploadError : function(file, errorCode, message) {
						switch (errorCode) {
						case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
							alert(SWFU.message.UPLOAD_HTTP_ERROR);
							break;
						case SWFUpload.UPLOAD_ERROR.MISSING_UPLOAD_URL:
							alert(SWFU.message.UPLOAD_MISSING_UPLOAD_URL);
							break;
						case SWFUpload.UPLOAD_ERROR.IO_ERROR:
							alert(SWFU.message.UPLOAD_IO_ERROR);
							break;
						case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
							alert(SWFU.message.UPLOAD_SECURITY_ERROR);
							break;
						case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
							alert(UT.formatString(SWFU.message.UPLOAD_LIMIT_EXCEEDED, {limit : this.settings.file_upload_limit}));
							break;
						case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
							alert(SWFU.message.UPLOAD_FAILED);
							break;
						case SWFUpload.UPLOAD_ERROR.SPECIFIED_FILE_ID_NOT_FOUND:
							alert(UT.formatString(SWFU.message.UPLOAD_SPECIFIED_FILE_ID_NOT_FOUND, {name : file.name}));
							break;
						case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
							alert(UT.formatString(SWFU.message.UPLOAD_FILE_VALIDATION_FAILED, {name : file.name}));
							break;
						case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
							break;
						case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
							break;
						default:
							alert(UT.formatString(SWFU.message.ETC, {name : file.name}));
							break;
						}
					},
					/**
					 * uploadSuccess is fired when the entire upload has been transmitted and the server returns a HTTP 200 status code. 
					 * Any data outputted by the server is available in the server data parameter.
					 * Due to some bugs in the Flash Player the server response may not be acknowledged and no uploadSuccess event is fired by Flash. 
					 * In this case the assume_success_timeout setting is checked to see if enough time has passed to fire uploadSuccess anyway. 
					 * In this case the received response parameter will be false. 
					 * The http_success setting allows uploadSuccess to be fired for HTTP status codes other than 200. 
					 * In this case no server data is available from the Flash Player. 
					 * At this point the upload is not yet complete. Another upload cannot be started from uploadSuccess.
					 * 업로드가 성공하면 발생하는 이벤트
					 */
					uploadSuccess : function(file, serverData, receivedResponse) {
						// alert("uploadSuccess");
						// file Object
						// id : string,			    // SWFUpload file id, used for starting or cancelling and upload
						// index : number,			// The index of this file for use in getFile(i)
						// name : string,			// The file name. The path is not included.
						// size : number,			// The file size in bytes
						// type : string,			// The file type as reported by the client operating system
						// creationdate : Date,		// The date the file was created
						// modificationdate : Date,	// The date the file was last modified
						// filestatus : number,		// The file's current status. Use SWFUpload.FILE_STATUS to interpret the value.
						
						file["serverData"] = jQuery.parseJSON(serverData);
						this["uploadedData"][file.id] = file; 
						if (typeof this.settings.custom_settings.uploaded === "function") {
							this.settings.custom_settings.uploaded.call(this, {
								id : this.settings.button_placeholder_id,
								successCallback : this.settings.custom_settings.successCallback
							}, file);
						}
					},
					/**
					 * uploadComplete is always fired at the end of an upload cycle (after uploadError or uploadSuccess). 
					 * At this point the upload is complete and another upload can be started.
					 * If you want the next upload to start automatically this is a good place to call this.uploadStart(). 
					 * Use caution when calling uploadStart inside the uploadComplete event if you also have code that cancels all the uploads in a queue.
					 * 업로드가 성공/실패에 관계없이 끝나면 발생하는 이벤트
					 */
					uploadComplete : function(file) {
						// alert("uploadComplete" + file.filestatus);
						switch(file.filestatus) {
							case SWFUpload.FILE_STATUS.QUEUED: 
								break;
							case SWFUpload.FILE_STATUS.IN_PROGRESS: 
								break;
							case SWFUpload.FILE_STATUS.ERROR: 
								break;
							case SWFUpload.FILE_STATUS.COMPLETE: 
								_super.runUpload();
								break;
							case SWFUpload.FILE_STATUS.CANCELLED: 
								break;
						}
					}
				}
				var settings = {
					flash_url              : "/common/flash/swfupload.swf",          
					flash9_url             : "/common/flash/swfupload_fp9.swf",
					upload_url             : "/attach/file/save.do",    // 업로드를 수행할 URL
					file_post_name         : "FileData",                // 업로드를 수행할 때 선택한 파일을 POST 파라미터에 넣어서 보내는 이름
					post_params            : {},                        // 추가적으로 POST 파라미터에 전해질 내용들
					file_types             : "*.*",                     // 선택 가능한 파일 확장자들
					file_types_description : "All Files",               // 파일 타입에 대한 설명
					file_size_limit        : "100 MB",                  // 업로드할 파일 하나의 최대 크기
					file_upload_limit      : 0,  // 업로드 가능한 최대 파일의 수. 0은 무한대
					file_queue_limit       : 1,  // 큐에 들어갈 수 있는 최대 파일의 수. 0은 무한대
					custom_settings        : {
						successCallback    : null,       // 개별 업로드 완료시 호출 되는 함수 (데이타 전달)
						uploaded          : null,       // 개별 업로드 완료시 호출 되는 함수
						selected           : null,       // 파일선택시 호출 되는 함수
						canceled           : null,       // 개별 업로드 취소시 호출 되는 함수
						immediatelyUpload  : false,      // 파일 선택 후 즉시 업로드
						deleteIconUrl      : ""          // 삭제아이콘
					},
					
					button_placeholder_id    : elementId,
					button_placeholder       : null,
					button_image_url         : "",
					button_width             : 65,
					button_height            : 22,
					button_text              : "", // <span class='uploadButtonText'>File Browse</span>
					button_text_style        : ".uploadButtonText { color:#000000;}",
					button_text_left_padding : 3,
					button_text_top_padding  : 2,
					button_disabled          : false,
					button_cursor            : SWFUpload.CURSOR.HAND,
					button_window_mode       : SWFUpload.WINDOW_MODE.TRANSPARENT,
					
					swfupload_loaded_handler     : fn.uploadLoaded,
					file_dialog_start_handler    : fn.fileDialogStart,
					file_queued_handler          : fn.fileQueued,
					file_queue_error_handler     : fn.fileQueueError,
					file_dialog_complete_handler : fn.fileDialogComplete,
					upload_start_handler         : fn.uploadStart,
					upload_progress_handler      : fn.uploadProgress,
					upload_error_handler         : fn.uploadError,
					upload_success_handler       : fn.uploadSuccess,
					upload_complete_handler      : fn.uploadComplete

					// 기타
					// http_success           : [201, 202],
					// assume_success_timeout : 0,
					// use_query_string       : false,
					// requeue_on_error       : false,
					// prevent_swf_caching    : false,
					// preserve_relative_urls : false,
				};
				options = jQuery.extend(true, settings, options);
				options.button_action = SWFUpload.BUTTON_ACTION.SELECT_FILE;
				options.file_queue_limit = options.file_upload_limit;
				if (options.file_upload_limit > 1 || options.file_upload_limit == 0) {
					options.button_action = SWFUpload.BUTTON_ACTION.SELECT_FILES;
				}
				_super.uploader[elementId] = new SWFUpload(options);
				_super.uploader[elementId]["uploadedData"] = {};
				
			},
			runUpload : function(id) {
				if (typeof id === "string") {
					var uploader = this.uploader[id];
					if (typeof uploader === "object" && typeof uploader.getStats() !== "undefined" && uploader.getStats().files_queued > 0) {
						uploader.startUpload();
						return;
					}
				} else {
					for(var id in this.uploader) {
						var uploader = this.uploader[id];
						if (typeof uploader.getStats() !== "undefined" && uploader.getStats().files_queued > 0) {
							uploader.startUpload();
							return;
						}
					}
				}
				if (typeof this.progressCallback === "function") {
					this.progressCallback.call(this, "close");
				}
				if (typeof this.completeCallback === "function") {
					this.completeCallback.call(this);
				}
			},
			cancelUpload : function(id, fileId) {
				var uploader = this.uploader[id];
				if (typeof uploader === "object") {
					if (typeof fileId === "string") {
						uploader.cancelUpload(fileId, false);
						if (typeof fileId === "string" && typeof uploader["uploadedData"] === "object" && typeof uploader["uploadedData"][fileId] === "object") {
							delete uploader["uploadedData"][fileId];
						}
					}
					var stats = uploader.getStats();
					stats.successful_uploads--;
					if (stats.successful_uploads < 0) {
						stats.successful_uploads = 0;
					}
					uploader.setStats(stats); 
				}
			},
			stopUpload : function() {
				for(var id in this.uploader) {
					var uploader = this.uploader[id];
					uploader.stopUpload();
				}
				if (typeof this.progressCallback === "function") {
					this.progressCallback.call(this, "close");
				}
			},
			isAppendedFiles : function(id) {
				var uploader = this.uploader[id];
				if (typeof uploader === "object" && typeof uploader.getStats() !== "undefined") {
					return uploader.getStats().files_queued > 0 ? true : false;
				} else {
					return false;
				}
			},
			getUploadedData : function(id) {
				var uploader = this.uploader[id];
				if (typeof uploader === "object" && typeof uploader["uploadedData"] === "object") {
					var data = [];
					for (var fileId in uploader["uploadedData"]) {
						data.push(uploader["uploadedData"][fileId].serverData)
					}
					return data;
				} else {
					return [];
				}
			},
			removeUpload : function(id) {
				var uploader = this.uploader[id];
				if (typeof uploader === "object") {
					delete uploader;
				}
			},
			setPostParams : function(id, addParams, removeParamNames) {
				var uploader = this.uploader[id];
				if (typeof uploader === "object") {
					if (typeof addParams === "object") {
						for (var p in addParams) {
							uploader.addPostParam(p, addParams[p]);
						}
					}					
					if (typeof removeParamNames === "object") {
						for (var i in removeParamNames) {
							uploader.removePostParam(removeParamNames[i]);
						}
					}
				}
			}
		};
		return publics;
	},
	message : {
		QUEUE_EXCEEDS_SIZE_LIMIT : I18N["Aos:Swfu:QueueExceedsSizeLimit"], // 파일 제한 용량({limit})을 초과하였습니다
		QUEUE_ZERO_BYTE_FILE : I18N["Aos:Swfu:QueueZeroByteFile"], // 파일이 비어있습니다
		QUEUE_INVALID_FILETYPE : I18N["Aos:Swfu:QueueInvalidFiletype"], // 파일 형식이 유효하지 않습니다
		QUEUE_LIMIT_EXCEEDED : I18N["Aos:Swfu:QueueLimitExceeded"], // 업로드 개수({limit})를 초과하였습니다
		UPLOAD_HTTP_ERROR : I18N["Aos:Swfu:UploadHttpError"], // http 에러가 발생하였습니다
		UPLOAD_MISSING_UPLOAD_URL : I18N["Aos:Swfu:UploadMissingUploadUrl"], // 업로드 url이 정확하지 않습니다
		UPLOAD_IO_ERROR : I18N["Aos:Swfu:UploadIoError"], // io 에러가 발생하였습니다
		UPLOAD_SECURITY_ERROR : I18N["Aos:Swfu:UploadSecurityError"], // 보안 에러가 발생하였습니다
		UPLOAD_LIMIT_EXCEEDED : I18N["Aos:Swfu:UploadLimitExceeded"], // 업로드 개수({limit})를 초과하였습니다
		UPLOAD_FAILED : I18N["Aos:Swfu:UploadFailed"], // 업로드 에러가 발생하였습니다
		UPLOAD_SPECIFIED_FILE_ID_NOT_FOUND : I18N["Aos:Swfu:UploadSpecifiedFileIdNotFound"], // 파일 id를 찾을수가 없습니다
		UPLOAD_FILE_VALIDATION_FAILED : I18N["Aos:Swfu:UploadFileValidationFailed"], // 파일 유효성 에러가 발생하였습니다
		ETC : I18N["Aos:Swfu:Etc"] // 알수없는 에러가 발생하였습니다
	}
};

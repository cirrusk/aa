/**
 * author : jkk5246@gmail.com
 * created : 2014.07.18
 */
var _fileinfo_ = {
	version : "3.2.0"
};

var I18N = {
	"Aos:Dialog:Confirm:Title" : "Confirm",
	"Aos:Dialog:Confirm:Button:Ok" : "Ok",
	"Aos:Dialog:Confirm:Button:Cancel" : "Cancel",
	"Aos:Dialog:Alert:Title" : "Alert",
	"Aos:Dialog:Alert:Button:Ok" : "Ok",
	"Aos:Dialog:Info:Title" : "Information",
	"Aos:Dialog:Progress:Button:Cancel" : "Cancel",
	
	"Aos:Validator:Eq" : "{_title_}, {_verb_} equals to {_value_}",
	"Aos:Validator:Le" : "{_title_}, {_verb_} a value less than or equals to {_value_}",
	"Aos:Validator:Ge" : "{_title_}, {_verb_} a value greater than or equals to {_value_}",
	"Aos:Validator:Lt" : "{_title_}, {_verb_} a value less than {_value_}",
	"Aos:Validator:Gt" : "{_title_}, {_verb_} a value greater than {_value_}",
	"Aos:Validator:Maxlength" : "{_title_}, {_verb_} the maximum length of {_value_} or less characters",
	"Aos:Validator:Minlength" : "{_title_}, {_verb_} the minimum length of {_value_} or more characters",
	"Aos:Validator:Fixlength" : "{_title_}, {_verb_} the length of {_value_} characters",
	"Aos:Validator:Maxbyte" : "{_title_}, {_verb_} up to less than {_value_} bytes",
	"Aos:Validator:Minbyte" : "{_title_}, {_verb_} above at least {_value_} bytes",
	"Aos:Validator:!Space" : "{_title_} does not allow whitespace",
	"Aos:Validator:!Null" : "Please {_verb_} {_title_}",
	"Aos:Validator:!Tag" : "{_title_} does not allow tag",
	"Aos:Validator:!Chars" : "{_title_}, {_value_} charaters are not allowed",
	"Aos:Validator:Ssn" : "{_title_} is not a correct format",
	"Aos:Validator:Frn" : "{_title_} is not a correct format",
	"Aos:Validator:Email" : "{_title_} is not a correct format",
	"Aos:Validator:Url" : "{_title_} is not a correct format",
	"Aos:Validator:Ip" : "{_title_} is not a correct format",
	"Aos:Validator:Date" : "{_title_} is not a correct format[{_value_}]",
	"Aos:Validator:Regex" : "{_title_} is not a correct format",
	"Aos:Validator:!Regex" : "{_title_} is not a correct format",
	"Aos:Validator:Alphabet" : "{_title_} is not a correct format",
	"Aos:Validator:Hangul" : "{_title_} is not a correct format",
	"Aos:Validator:Number" : "{_title_} is not a correct format",
	"Aos:Validator:Signnumber" : "{_title_} is not a correct format",
	"Aos:Validator:Hypennumber" : "{_title_} is not a correct format",
	"Aos:Validator:Commanumber" : "{_title_} is not a correct format",
	"Aos:Validator:Decimalnumber" : "{_title_} is not a correct format",
	"Aos:Validator:Select" : "Select",
	"Aos:Validator:Enter" : "Enter",
	
	"Aos:Player:NotSupportMediaType" : "Can not support the media type",
	"Aos:Player:ToGoPreviousStudy" : "Do you want to go the previous study position?",
	
	"Aos:Swfu:QueueExceedsSizeLimit" : "File size limit({limit}) has been exceeded\n({name}-{size})",
	"Aos:Swfu:QueueZeroByteFile" : "File is empty\n({name})",
	"Aos:Swfu:QueueInvalidFiletype" : "The file format is not valid\n({name})",
	"Aos:Swfu:QueueLimitExceeded" : "Upload count ({limit}) has been exceeded",
	"Aos:Swfu:UploadHttpError" : "HTTP error occurred",
	"Aos:Swfu:UploadMissingUploadUrl" : "Upload url is not correct",
	"Aos:Swfu:UploadIoError" : "IO error occurred",
	"Aos:Swfu:UploadSecurityError" : "Security error occurred",
	"Aos:Swfu:UploadLimitExceeded" : "Upload count ({limit}) has been exceeded",
	"Aos:Swfu:UploadFailed" : "Upload error occurred",
	"Aos:Swfu:UploadSpecifiedFileIdNotFound" : "File ID is not found\n({name})",
	"Aos:Swfu:UploadFileValidationFailed" : "An error has occurred in file validation\n({name})",
	"Aos:Swfu:Etc" : "Unknown error occurred\n({name})",
	
	"Aos:Ui:Datepicker:ClearText" : "Clear",
	"Aos:Ui:Datepicker:CloseText" : "Close",
	"Aos:Ui:Datepicker:ButtonText" : "Calendar",
	"Aos:Ui:Datepicker:CurrentText" : "Today",
	"Aos:Ui:Datepicker:DayNamesMin:Sun" : "Su",
	"Aos:Ui:Datepicker:DayNamesMin:Mon" : "Mo",
	"Aos:Ui:Datepicker:DayNamesMin:Tue" : "Tu",
	"Aos:Ui:Datepicker:DayNamesMin:Wen" : "We",
	"Aos:Ui:Datepicker:DayNamesMin:Thu" : "Th",
	"Aos:Ui:Datepicker:DayNamesMin:Fri" : "Fr",
	"Aos:Ui:Datepicker:DayNamesMin:SAT" : "Sa",
	"Aos:Ui:Datepicker:MonthNamesShort:Jan" : "Jan",
	"Aos:Ui:Datepicker:MonthNamesShort:Fab" : "Fab",
	"Aos:Ui:Datepicker:MonthNamesShort:Mar" : "Mar",
	"Aos:Ui:Datepicker:MonthNamesShort:Apr" : "Apr",
	"Aos:Ui:Datepicker:MonthNamesShort:May" : "May",
	"Aos:Ui:Datepicker:MonthNamesShort:Jun" : "Jun",
	"Aos:Ui:Datepicker:MonthNamesShort:Jul" : "Jul",
	"Aos:Ui:Datepicker:MonthNamesShort:Aug" : "Aug",
	"Aos:Ui:Datepicker:MonthNamesShort:Sep" : "Sep",
	"Aos:Ui:Datepicker:MonthNamesShort:Oct" : "Oct",
	"Aos:Ui:Datepicker:MonthNamesShort:Nov" : "Nov",
	"Aos:Ui:Datepicker:MonthNamesShort:Dec" : "Dec",
	
	"Aos:Ui:Calendar:DayNamesShort:Sun" : "Sun",
	"Aos:Ui:Calendar:DayNamesShort:Mon" : "Mon",
	"Aos:Ui:Calendar:DayNamesShort:Tue" : "Tue",
	"Aos:Ui:Calendar:DayNamesShort:Wen" : "Wen",
	"Aos:Ui:Calendar:DayNamesShort:Thu" : "Thu",
	"Aos:Ui:Calendar:DayNamesShort:Fri" : "Fri",
	"Aos:Ui:Calendar:DayNamesShort:SAT" : "SAT",
	"Aos:Ui:Calendar:DayNames:Sun" : "Sunday",
	"Aos:Ui:Calendar:DayNames:Mon" : "Monday",
	"Aos:Ui:Calendar:DayNames:Tue" : "Tuesday",
	"Aos:Ui:Calendar:DayNames:Wen" : "Wednesday",
	"Aos:Ui:Calendar:DayNames:Thu" : "Thursday",
	"Aos:Ui:Calendar:DayNames:Fri" : "Friday",
	"Aos:Ui:Calendar:DayNames:SAT" : "Saturday",
	"Aos:Ui:Calendar:MonthNames:Jan" : "January",
	"Aos:Ui:Calendar:MonthNames:Fab" : "February",
	"Aos:Ui:Calendar:MonthNames:Mar" : "March",
	"Aos:Ui:Calendar:MonthNames:Apr" : "April",
	"Aos:Ui:Calendar:MonthNames:May" : "May",
	"Aos:Ui:Calendar:MonthNames:Jun" : "June",
	"Aos:Ui:Calendar:MonthNames:Jul" : "July",
	"Aos:Ui:Calendar:MonthNames:Aug" : "August",
	"Aos:Ui:Calendar:MonthNames:Sep" : "September",
	"Aos:Ui:Calendar:MonthNames:Oct" : "October",
	"Aos:Ui:Calendar:MonthNames:Nov" : "November",
	"Aos:Ui:Calendar:MonthNames:Dec" : "December",
	"Aos:Ui:Calendar:buttonText:Month" : "Month",
	"Aos:Ui:Calendar:buttonText:Week" : "Week",
	"Aos:Ui:Calendar:buttonText:Day" : "Day",
	"Aos:Ui:Calendar:buttonText:Today" : "Today",
	"Aos:Ui:Calendar:Text:Day" : "Day",
	"Aos:Ui:Calendar:Text:Year" : "Year",
	"Aos:Ui:Calendar:Text:AllDay" : "All Day",

	"Aos:Learing:NoError" : "Success",
	"Aos:Learing:InitializeFailure" : "Failed to initialize",
	"Aos:Learing:InitializeAfterInitialize" : "Already been initialized",
	"Aos:Learing:InitializeAfterTerminate" : "Already been terminated",
	"Aos:Learing:InitializeArgument" : "Argument is not correct",
	"Aos:Learing:TerminateFailure" : "Has not been terminated",
	"Aos:Learing:TerminateBeforeInitialize" : "Before initializing state",
	"Aos:Learing:TerminateAfterTerminate" : "Already been terminated",
	"Aos:Learing:TerminateArgument" : "Argument is not correct",
	"Aos:Learing:CommitFailure" : "The server or the network is unstable.<br>Close, and then try again",
	"Aos:Learing:CommitBeforeInitialize" : "Before initializing state",
	"Aos:Learing:CommitAfterTerminate" : "Already been terminated",
	"Aos:Learing:CommitArgument" : "Argument is not correct",
	"Aos:Learing:GetvalueFailure" : "There was an error getting the study data",
	"Aos:Learing:GetvalueBeforeInitialize" : "Before initializing state",
	"Aos:Learing:GetvalueAfterTerminate" : "Already been terminated",
	"Aos:Learing:GetvalueArgument" : "Argument is not correct",
	"Aos:Learing:SetvalueFailure" : "There was an error setting the study data",
	"Aos:Learing:SetvalueBeforeInitialize" : "Before initializing state",
	"Aos:Learing:SetvalueAfterTerminate" : "Already been terminated",
	"Aos:Learing:SetvalueArgument" : "Argument is not correct",
	"Aos:Learing:RestoreLearningData" : "Unsaved study data been restored"
	
};

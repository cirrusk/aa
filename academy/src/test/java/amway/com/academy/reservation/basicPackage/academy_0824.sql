/****** Object:  Database [academy_dev]    Script Date: 2016-08-24 오후 2:04:46 ******/
-- ALTER DATABASE [academy_dev] SET COMPATIBILITY_LEVEL = 110
-- GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [academy_dev].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [academy_dev] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [academy_dev] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [academy_dev] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [academy_dev] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [academy_dev] SET ARITHABORT OFF 
GO
ALTER DATABASE [academy_dev] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [academy_dev] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [academy_dev] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [academy_dev] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [academy_dev] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [academy_dev] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [academy_dev] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [academy_dev] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [academy_dev] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [academy_dev] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [academy_dev] SET  DISABLE_BROKER 
GO
ALTER DATABASE [academy_dev] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [academy_dev] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [academy_dev] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [academy_dev] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [academy_dev] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [academy_dev] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [academy_dev] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [academy_dev] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [academy_dev] SET  MULTI_USER 
GO
ALTER DATABASE [academy_dev] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [academy_dev] SET DB_CHAINING OFF 
GO
ALTER DATABASE [academy_dev] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [academy_dev] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
/****** Object:  Sequence [dbo].[filekeysequence]    Script Date: 2016-08-24 오후 2:04:46 ******/
CREATE SEQUENCE [dbo].[filekeysequence] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
/****** Object:  StoredProcedure [dbo].[SP_LMS_ONLINEBATCH_STAMPONLINE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LMS_ONLINEBATCH_STAMPONLINE] 
@STAMPID VARCHAR(5),
@RETURN VARCHAR(2)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CURRENTPFYEAR VARCHAR(4)
	DECLARE @UID VARCHAR(11)

	--' 온라인 GLMS 연동정보 읽어오기

	--' 온라인 정보 FETCH 돌면서 수료정보 업데이트 및 스탬프 부여 확인하기



	--' 온라인강의 수료 횟수 확인하여 회기연도에 1번만 스탬프 부여함
	INSERT INTO LMSSTAMPOBTAIN (
		UID
		, STAMPID
		, OBTAINSEQ
		, OBTAINDATE
		, COURSEID
	)
	SELECT 
		@UID
		, @STAMPID
		, (SELECT ISNULL(MAX(OBTAINSEQ),0) +1 FROM LMSSTAMPOBTAIN WHERE UID = @UID AND STAMPID = @STAMPID)
		, GETDATE()
		, 0
	WHERE DBO.F_LMS_DFYEAR(GETDATE()) <> DBO.F_LMS_DFYEAR(ISNULL(
		(SELECT MAX(OBTAINDATE)
			FROM LMSSTAMPOBTAIN
			WHERE UID = @UID
			AND STAMPID = @STAMPID
		),DATEADD(YEAR, -1, GETDATE()))
	)
	AND 100 = (
		SELECT COUNT(*)
		FROM LMSSTUDENT A INNER JOIN LMSCOURSE B
		ON A.COURSEID = B.COURSEID
		WHERE A.UID = @UID
		AND A.FINISHFLAG = 'Y'
		AND B.COURSETYPE = 'O'
		AND B.OPENFLAG = 'Y'
		AND B.USEFLAG = 'Y'
		AND DBO.F_LMS_DFYEAR(A.FINISHDATE) = DBO.F_LMS_DFYEAR(GETDATE())
	)
	
	IF @@ERROR <> 0
		SET @RETURN = 'ER'
	ELSE 
		SET @RETURN = 'OK'

	SELECT @RETURN;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_LMS_STAMPCONNECT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LMS_STAMPCONNECT] 
@UID VARCHAR(11),
@STAMPID4 VARCHAR(5),
@STAMPID12 VARCHAR(5),
@STAMPID24 VARCHAR(5),
@STAMPID48 VARCHAR(5),
@RETURN VARCHAR(2) OUT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @REGULARWEEKCOUNT INT
	DECLARE @WEEKCOUNT INT
	DECLARE @REGULARPFYEAR VARCHAR(4)
	DECLARE @CURRENTPFYEAR VARCHAR(4)
	DECLARE @REGULARDATE DATETIME

	SET @WEEKCOUNT = 0

	--' TRANSACTION 시작
	BEGIN TRAN

	--'1 최초 접속일자,개근 주, 최종 접속일의 PF 연도, 현재의 PF연도 확인
	SELECT TOP 1 
		@REGULARDATE = ISNULL(REGULARDATE,GETDATE())
		, @REGULARWEEKCOUNT = ISNULL(REGULARWEEKCOUNT,0)
		, @WEEKCOUNT = DATEDIFF(WEEK, ISNULL(REGULARDATE,GETDATE()), GETDATE())
		, @REGULARPFYEAR = DBO.F_LMS_DFYEAR(ISNULL(CONNECTDATE,GETDATE()))
		, @CURRENTPFYEAR = DBO.F_LMS_DFYEAR(GETDATE())
	FROM LMSCONNECTLOG
	WHERE UID = @UID
	ORDER BY CONNECTDATE DESC

	--' 접속주가 0인 경우는 접속정보 입력 후 END
	IF @REGULARWEEKCOUNT = 0
		BEGIN
			INSERT INTO LMSCONNECTLOG ( UID, CONNECTDATE, REGULARDATE, REGULARWEEKCOUNT ) VALUES( @UID, GETDATE(), GETDATE(), 1)
		END
	
	--' 개근여부 확인
	--' 접속일시 - 최초접속일의 차이 주 > 개근주(개근실패)
	ELSE
		BEGIN
			--' 최종 접속일의 PF YEAR와 현재의 PF YEAR가 틀리면 초기화 함
			IF @REGULARPFYEAR <> @CURRENTPFYEAR
				BEGIN
					SET @RETURN = '11'
					INSERT INTO LMSCONNECTLOG ( UID, CONNECTDATE, REGULARDATE, REGULARWEEKCOUNT ) VALUES( @UID, GETDATE(), GETDATE(), 1)
				END
			ELSE
				BEGIN
					--' 개근 달성 : 개근주 증가
					IF @WEEKCOUNT = @REGULARWEEKCOUNT
						BEGIN
							SET @RETURN = '22'
							INSERT INTO LMSCONNECTLOG ( UID, CONNECTDATE, REGULARDATE, REGULARWEEKCOUNT ) VALUES( @UID, GETDATE(), GETDATE(), @REGULARWEEKCOUNT + 1)

							--' 개근 스탬프 조건 확인하여 스탬프 해당 주면 스탬프 부여하기
							--' 스탬프는 회계연도에 1번만 부여됨
							IF @REGULARWEEKCOUNT + 1 = 4
								BEGIN
									SET @RETURN = '22-1'
									INSERT INTO LMSSTAMPOBTAIN (
										UID
										, STAMPID
										, OBTAINSEQ
										, OBTAINDATE
										, COURSEID
									)
									SELECT 
										@UID
										, @STAMPID4
										, (SELECT ISNULL(MAX(OBTAINSEQ),0) +1 FROM LMSSTAMPOBTAIN WHERE UID = @UID AND STAMPID = @STAMPID4)
										, GETDATE()
										, 0
									WHERE DBO.F_LMS_DFYEAR(GETDATE()) <> DBO.F_LMS_DFYEAR(ISNULL(
										(SELECT MAX(OBTAINDATE)
											FROM LMSSTAMPOBTAIN
											WHERE UID = @UID
											AND STAMPID = @STAMPID4
										),DATEADD(YEAR, -1, GETDATE()))
									)
								END
							ELSE IF @REGULARWEEKCOUNT + 1 = 12
								BEGIN
									SET @RETURN = '22-2'
									INSERT INTO LMSSTAMPOBTAIN (
										UID
										, STAMPID
										, OBTAINSEQ
										, OBTAINDATE
										, COURSEID
									)
									SELECT 
										@UID
										, @STAMPID12
										, (SELECT ISNULL(MAX(OBTAINSEQ),0) +1 FROM LMSSTAMPOBTAIN WHERE UID = @UID AND STAMPID = @STAMPID12)
										, GETDATE()
										, 0
									WHERE DBO.F_LMS_DFYEAR(GETDATE()) <> DBO.F_LMS_DFYEAR(ISNULL(
										(SELECT MAX(OBTAINDATE)
											FROM LMSSTAMPOBTAIN
											WHERE UID = @UID
											AND STAMPID = @STAMPID12
										),DATEADD(YEAR, -1, GETDATE()))
									)
								END
							ELSE IF @REGULARWEEKCOUNT + 1 = 24
								BEGIN
									SET @RETURN = '22-3'
									INSERT INTO LMSSTAMPOBTAIN (
										UID
										, STAMPID
										, OBTAINSEQ
										, OBTAINDATE
										, COURSEID
									)
									SELECT 
										@UID
										, @STAMPID24
										, (SELECT ISNULL(MAX(OBTAINSEQ),0) +1 FROM LMSSTAMPOBTAIN WHERE UID = @UID AND STAMPID = @STAMPID24)
										, GETDATE()
										, 0
									WHERE DBO.F_LMS_DFYEAR(GETDATE()) <> DBO.F_LMS_DFYEAR(ISNULL(
										(SELECT MAX(OBTAINDATE)
											FROM LMSSTAMPOBTAIN
											WHERE UID = @UID
											AND STAMPID = @STAMPID24
										),DATEADD(YEAR, -1, GETDATE()))
									)
								END
							ELSE IF @REGULARWEEKCOUNT + 1 = 48
								BEGIN
									SET @RETURN = '22-4'
									INSERT INTO LMSSTAMPOBTAIN (
										UID
										, STAMPID
										, OBTAINSEQ
										, OBTAINDATE
										, COURSEID
									)
									SELECT 
										@UID
										, @STAMPID48
										, (SELECT ISNULL(MAX(OBTAINSEQ),0) +1 FROM LMSSTAMPOBTAIN WHERE UID = @UID AND STAMPID = @STAMPID48)
										, GETDATE()
										, 0
									WHERE DBO.F_LMS_DFYEAR(GETDATE()) <> DBO.F_LMS_DFYEAR(ISNULL(
										(SELECT MAX(OBTAINDATE)
											FROM LMSSTAMPOBTAIN
											WHERE UID = @UID
											AND STAMPID = @STAMPID48
										),DATEADD(YEAR, -1, GETDATE()))
									)
								END
						END
					--' 개근 실패 : 개근 주 초기화
					ELSE IF @WEEKCOUNT > @REGULARWEEKCOUNT
						BEGIN
							SET @RETURN = '33'
							INSERT INTO LMSCONNECTLOG ( UID, CONNECTDATE, REGULARDATE, REGULARWEEKCOUNT ) VALUES( @UID, GETDATE(), GETDATE(), 1)
						END
					--' 개근 확인 : 개근한 주에 다시 접속
					ELSE IF @WEEKCOUNT < @REGULARWEEKCOUNT
						BEGIN
							SET @RETURN = '44'
							INSERT INTO LMSCONNECTLOG ( UID, CONNECTDATE, REGULARDATE, REGULARWEEKCOUNT ) VALUES( @UID, GETDATE(), @REGULARDATE, @REGULARWEEKCOUNT)
						END
				END
		END
	
	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			SET @RETURN = 'ER'
		END
	ELSE 
		BEGIN
			COMMIT TRAN
			SET @RETURN = 'OK'
		END

	--'SELECT @RETURN;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_LMS_STAMPDATA]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,교육자료 스탬프,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LMS_STAMPDATA] 
@UID VARCHAR(11),
@STAMPID VARCHAR(5),
@RETURN VARCHAR(2) OUT
AS
BEGIN
	SET NOCOUNT ON;
	
	--' 교육자료 수료여부 확인하여 회기연도에 200개 이상 수료하면 스탬프 부여함
	INSERT INTO LMSSTAMPOBTAIN (
		UID
		, STAMPID
		, OBTAINSEQ
		, OBTAINDATE
		, COURSEID
	)
	SELECT 
		@UID
		, @STAMPID
		, (SELECT ISNULL(MAX(OBTAINSEQ),0) +1 FROM LMSSTAMPOBTAIN WHERE UID = @UID AND STAMPID = @STAMPID)
		, GETDATE()
		, 0
	WHERE DBO.F_LMS_DFYEAR(GETDATE()) <> DBO.F_LMS_DFYEAR(ISNULL(
		(SELECT MAX(OBTAINDATE)
			FROM LMSSTAMPOBTAIN
			WHERE UID = @UID
			AND STAMPID = @STAMPID
		),DATEADD(YEAR, -1, GETDATE()))
	)
	AND 200 = (
		SELECT COUNT(*)
		FROM LMSSTUDENT A INNER JOIN LMSCOURSE B
		ON A.COURSEID = B.COURSEID
		WHERE A.UID = @UID
		AND A.FINISHFLAG = 'Y'
		AND B.COURSETYPE = 'D'
		AND B.OPENFLAG = 'Y'
		AND B.USEFLAG = 'Y'
		AND DBO.F_LMS_DFYEAR(A.FINISHDATE) = DBO.F_LMS_DFYEAR(GETDATE())
	)
	
	IF @@ERROR <> 0
		SET @RETURN = 'ER'
	ELSE 
		SET @RETURN = 'OK'

	SELECT @RETURN;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_LMS_STAMPOFFLINE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,오프라인강의스탬프,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LMS_STAMPOFFLINE] 
@UID VARCHAR(11),
@STAMPID VARCHAR(5),
@RETURN VARCHAR(2) OUT
AS
BEGIN
	SET NOCOUNT ON;
	
	--' 오프라인강의 수료여부 확인하여 회기연도에 30개 이상 수료하면 스탬프 부여함
	INSERT INTO LMSSTAMPOBTAIN (
		UID
		, STAMPID
		, OBTAINSEQ
		, OBTAINDATE
		, COURSEID
	)
	SELECT 
		@UID
		, @STAMPID
		, (SELECT ISNULL(MAX(OBTAINSEQ),0) +1 FROM LMSSTAMPOBTAIN WHERE UID = @UID AND STAMPID = @STAMPID)
		, GETDATE()
		, 0
	WHERE DBO.F_LMS_DFYEAR(GETDATE()) <> DBO.F_LMS_DFYEAR(ISNULL(
		(SELECT MAX(OBTAINDATE)
			FROM LMSSTAMPOBTAIN
			WHERE UID = @UID
			AND STAMPID = @STAMPID
		),DATEADD(YEAR, -1, GETDATE()))
	)
	AND 30 = (
		SELECT COUNT(*)
		FROM LMSSTUDENT A INNER JOIN LMSCOURSE B
		ON A.COURSEID = B.COURSEID
		WHERE A.UID = @UID
		AND A.FINISHFLAG = 'Y'
		AND B.COURSETYPE = 'F'
		AND B.OPENFLAG = 'Y'
		AND B.USEFLAG = 'Y'
		AND DBO.F_LMS_DFYEAR(A.FINISHDATE) = DBO.F_LMS_DFYEAR(GETDATE())
	)
	
	IF @@ERROR <> 0
		SET @RETURN = 'ER'
	ELSE 
		SET @RETURN = 'OK'

	SELECT @RETURN;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_LMS_STAMPREGULAR]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,정규과정스탬프,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LMS_STAMPREGULAR] 
@UID VARCHAR(11),
@COURSEID VARCHAR(10),
@RETURN VARCHAR(2) OUT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @STAMPFLAG VARCHAR(1)
	DECLARE @STAMPID INT

	--'정규과정을 읽어서 스탬프 발행여부 확인하여 스탬프 발행 없으면 종료함
	SELECT 
		@STAMPFLAG = STAMPFLAG
		, @STAMPID = STAMPID
	FROM LMSREGULAR
	WHERE COURSEID = @COURSEID
	
	IF @STAMPFLAG = 'Y'
		BEGIN
			--' 정규과정 스탬프 있는지 확인하여 없으면 스탬프 발행함
			INSERT INTO LMSSTAMPOBTAIN (
				UID
				, STAMPID
				, OBTAINSEQ
				, OBTAINDATE
				, COURSEID
			)
			SELECT 
				@UID
				, @STAMPID
				, (SELECT ISNULL(MAX(OBTAINSEQ),0) +1 FROM LMSSTAMPOBTAIN WHERE UID = @UID AND STAMPID = @STAMPID)
				, GETDATE()
				, @COURSEID
			WHERE 0 = (
				SELECT COUNT(*)
				FROM LMSSTAMPOBTAIN
				WHERE UID = @UID
				AND STAMPID = @STAMPID
				AND COURSEID = @COURSEID
			)
		END

	IF @@ERROR <> 0
		SET @RETURN = 'ER'
	ELSE 
		SET @RETURN = 'OK'

	SELECT @RETURN;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_LMS_STAMPVIEWLOG]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,SNS공유 스탬프,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LMS_STAMPVIEWLOG] 
@UID VARCHAR(11),
@STAMPID VARCHAR(5),
@RETURN VARCHAR(2) OUT
AS
BEGIN
	SET NOCOUNT ON;
	
	--' SNS공유여부 확인하여 회기연도에 100개 이상 수료하면 스탬프 부여함
	INSERT INTO LMSSTAMPOBTAIN (
		UID
		, STAMPID
		, OBTAINSEQ
		, OBTAINDATE
		, COURSEID
	)
	SELECT 
		@UID
		, @STAMPID
		, (SELECT ISNULL(MAX(OBTAINSEQ),0) +1 FROM LMSSTAMPOBTAIN WHERE UID = @UID AND STAMPID = @STAMPID)
		, GETDATE()
		, 0
	WHERE DBO.F_LMS_DFYEAR(GETDATE()) <> DBO.F_LMS_DFYEAR(ISNULL(
		(SELECT MAX(OBTAINDATE)
			FROM LMSSTAMPOBTAIN
			WHERE UID = @UID
			AND STAMPID = @STAMPID
		),DATEADD(YEAR, -1, GETDATE()))
	)
	AND 100 = ISNULL((
		SELECT SUM(ISNULL(VIEWCOUNT,0))
		FROM LMSVIEWLOG
		WHERE UID = @UID
		AND VIEWTYPE = '1'
		AND DBO.F_LMS_DFYEAR(CONVERT(DATETIME, SUBSTRING(VIEWMONTH,1,4) + '-' + SUBSTRING(VIEWMONTH,5,2) + '-01 00:00')) = DBO.F_LMS_DFYEAR(GETDATE())
	),0)
	
	IF @@ERROR <> 0
		SET @RETURN = 'ER'
	ELSE 
		SET @RETURN = 'OK'

	SELECT @RETURN;
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_CMM_CODENAME]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,홍석조>
-- Create date: <Create Date, 2016.08.01 ,>
-- Description:	<Description, 코드 이름을 리턴 한다. ,>
-- =============================================
CREATE FUNCTION [dbo].[F_CMM_CODENAME]
(@CODEMASTERSEQ varchar(20), @COMMONCODESEQ varchar(20))
RETURNS varchar(50)
WITH EXEC AS CALLER
AS
BEGIN
-- Declare the return variable here
	DECLARE @CODENAME VARCHAR(50)

	-- Add the T-SQL statements to compute the return value here
	SELECT @CODENAME = CODENAME
	  FROM dbo.COMMONCODE
	 WHERE CODEMASTERSEQ = @CODEMASTERSEQ
     AND COMMONCODESEQ = @COMMONCODESEQ;

	-- Return the result of the function
	RETURN @CODENAME;
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_GETABONAME]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,홍석조>
-- Create date: <Create Date, 2016.08.01 ,>
-- Description:	<Description, ABO 이름을 리턴 한다. ,>
-- =============================================
CREATE FUNCTION [dbo].[F_GETABONAME]
(@ABO_NO VARCHAR(12))
RETURNS VARCHAR(50)
WITH EXEC AS CALLER
AS
BEGIN
-- Declare the return variable here
	DECLARE @NAME VARCHAR(50)

	-- Add the T-SQL statements to compute the return value here
	SELECT @NAME = [NAME]
    FROM [dbo].[MEMBER]
   WHERE UID = @ABO_NO;

	-- Return the result of the function
	RETURN @NAME;
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_GETMONEYKOR]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[F_GETMONEYKOR](@arg_amt varchar(15)) 
RETURNS VARCHAR(100)
AS

BEGIN

 DECLARE @N_NUM_LEN  int
 DECLARE @N_NUM_IDX  int
 DECLARE @count      int
 DECLARE @V_NUM_CHAR VARCHAR(20)
 DECLARE @V_LENGTH   VARCHAR(1)
 DECLARE @V_EXIST    VARCHAR(1)
 DECLARE @V_HAN_AMT  VARCHAR(100)
     
 SET @V_HAN_AMT = '';
 IF @ARG_AMT = '' RETURN '';
 IF @ARG_AMT = '0'    RETURN '영';
 IF @ARG_AMT < '0'    SET @V_HAN_AMT = '-';


 SET @V_NUM_CHAR = @ARG_AMT;
 SET @N_NUM_LEN  = LEN(@V_NUM_CHAR);
 SET @count = 1 ;
  
 WHILE (@count <= @N_NUM_LEN) 
 BEGIN 
  SET @V_LENGTH = SUBSTRING(@V_NUM_CHAR, @count, 1);
  
   BEGIN
    IF @V_LENGTH = '0'   SET @V_HAN_AMT = @V_HAN_AMT + '';
    IF @V_LENGTH = '1'   SET @V_HAN_AMT = @V_HAN_AMT + '일';
    IF @V_LENGTH = '2'   SET @V_HAN_AMT = @V_HAN_AMT + '이';
    IF @V_LENGTH = '3'   SET @V_HAN_AMT = @V_HAN_AMT + '삼';
    IF @V_LENGTH = '4'   SET @V_HAN_AMT = @V_HAN_AMT + '사';
    IF @V_LENGTH = '5'   SET @V_HAN_AMT = @V_HAN_AMT + '오';
    IF @V_LENGTH = '6'   SET @V_HAN_AMT = @V_HAN_AMT + '육';
    IF @V_LENGTH = '7'   SET @V_HAN_AMT = @V_HAN_AMT + '칠';
    IF @V_LENGTH = '8'   SET @V_HAN_AMT = @V_HAN_AMT + '팔';
    IF @V_LENGTH = '9'   SET @V_HAN_AMT = @V_HAN_AMT + '구';

    SET @V_EXIST = '1';
   END
        
         
  SET @N_NUM_IDX = @N_NUM_LEN + 1 - @count;
  
  IF      @N_NUM_IDX = 1  SET @V_HAN_AMT = @V_HAN_AMT + '';
  ELSE IF @N_NUM_IDX = 5   
    BEGIN
     IF @V_EXIST = '1'   SET @V_HAN_AMT = @V_HAN_AMT + '만';
    END    
  ELSE IF @N_NUM_IDX = 9  
    BEGIN
     IF @V_EXIST = '1'   SET @V_HAN_AMT = @V_HAN_AMT + '억';
    END
  ELSE IF @N_NUM_IDX = 13  
   BEGIN 
    IF @V_EXIST = '1'   SET @V_HAN_AMT = @V_HAN_AMT + '조';
   END
  ELSE IF @N_NUM_IDX = 17  
   BEGIN
    IF @V_EXIST = '1'   SET @V_HAN_AMT = @V_HAN_AMT + '경';
   END
  ELSE 
   IF @V_LENGTH <> 0  
    BEGIN
     IF  (@N_NUM_IDX % 4) = 0    SET @V_HAN_AMT = @V_HAN_AMT + '천';
     IF  (@N_NUM_IDX % 4) = 1    SET @V_HAN_AMT = @V_HAN_AMT + '';
     IF  (@N_NUM_IDX % 4) = 2    SET @V_HAN_AMT = @V_HAN_AMT + '십';
     IF  (@N_NUM_IDX % 4) = 3    SET @V_HAN_AMT = @V_HAN_AMT + '백';
    END
         
         -- 일경조억만 이라는 금액이 찍히지 않도록...
  IF @N_NUM_IDX in (1, 5, 9, 13, 17)      SET @V_EXIST = '';
              
  SET @count = @count + 1 ;

 END 

 RETURN @V_HAN_AMT+'원';

END

GO
/****** Object:  UserDefinedFunction [dbo].[F_LMS_AGE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =======================================================
함수명 : F_LMS_AGE
생년월일로 나이 가져오기(주민번호?)
========================================================== */
CREATE FUNCTION [dbo].[F_LMS_AGE] (
              @ssn1     VARCHAR(15) ,
			  @ssn2		VARCHAR(15)
              )
RETURNS INT
AS  
BEGIN 
	DECLARE @return INT;
	DECLARE @year1 INT;
	DECLARE @year2 INT;
	DECLARE @gubun INT;
	DECLARE @nowyear INT;
		
	SET @year1 = 999;
	SET @year2 = 999;

	SET @gubun = SUBSTRING(@ssn1, 7, 1) % 2; 
	SET @nowyear = YEAR(GETDATE());
	
	IF (LEN(@ssn1) >= 7)
		BEGIN
			SET @year1 = LEFT(@ssn1, 2);
			SET @gubun = SUBSTRING(@ssn1, 7, 1); 
			IF (@gubun IN (1, 2, 5, 6))
				BEGIN
					SET @year1 = @nowyear - (1900 + @year1) - 1;
				END
			ELSE
				BEGIN
					SET @year1 = @nowyear - (2000 + @year1) - 1;
				END
		END

	IF (LEN(@ssn2) >= 7)
		BEGIN
			SET @year2 = LEFT(@ssn2, 2);
			SET @gubun = SUBSTRING(@ssn2, 7, 1); 
			IF (@gubun IN (1, 2, 5, 6))
				BEGIN
					SET @year2 = @nowyear - (1900 + @year2) - 1;
				END
			ELSE
				BEGIN
					SET @year2 = @nowyear - (2000 + @year2) - 1;
				END
		END

	IF (@year1 <= @year2)
		BEGIN
			SET @return = @year1;
		END
	ELSE
		BEGIN
			SET @return = @year2;
		END

	RETURN @return

END
;

GO
/****** Object:  UserDefinedFunction [dbo].[F_LMS_CATEGORY_TREENAME]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =======================================================
함수명 : F_LMS_CATEGORY_TREENAME
작성자 : 이정종
작성일 : 2016/07/15

교육분류명을 계층으로 가져온다.
========================================================== */

CREATE FUNCTION [dbo].[F_LMS_CATEGORY_TREENAME] (
              @categoryid   integer
              )
RETURNS varchar(100)  
AS  
BEGIN 
	DECLARE @categoryname varchar(100)
	;
	WITH TREE_QUERY  AS (
	  SELECT  
		   CATEGORYID, CATEGORYNAME, CATEGORYUPID
		   , CONVERT(VARCHAR(255), CATEGORYORDER) SORT  
  		   , CONVERT(VARCHAR(255), CATEGORYNAME) FULLNAME
	  FROM LMSCATEGORY
	  WHERE CATEGORYLEVEL = 1
	  UNION ALL 
	  SELECT
			B.CATEGORYID, B.CATEGORYNAME, B.CATEGORYUPID
		   , CONVERT(VARCHAR(255), CONVERT(NVARCHAR,C.SORT) + ' > ' +  CONVERT(VARCHAR(255), B.CATEGORYORDER)) SORT
		   , CONVERT(VARCHAR(255), CONVERT(NVARCHAR,C.FULLNAME) + ' > ' +  CONVERT(VARCHAR(255), B.CATEGORYNAME)) FULLNAME
	  FROM  LMSCATEGORY B, TREE_QUERY C
	  WHERE B.CATEGORYUPID = C.CATEGORYID
	) 
	SELECT @categoryname = FULLNAME
	FROM TREE_QUERY
	WHERE CATEGORYID = @categoryid
	ORDER BY SORT
	;
	return @categoryname

END
;

GO
/****** Object:  UserDefinedFunction [dbo].[F_LMS_COURSETYPENAME]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =======================================================
함수명 : F_LMS_COURSETYPENAME
과정구분명을 리턴한다.
========================================================== */
CREATE FUNCTION [dbo].[F_LMS_COURSETYPENAME] (
			  @type		VARCHAR(1)
              )
RETURNS VARCHAR(100)  
AS  
BEGIN 
	DECLARE @return VARCHAR(100)
	;
	IF (@type = 'O')
		BEGIN
			SET @return = '온라인강의'
		END
	ELSE IF (@type = 'F')
		BEGIN
			SET @return = '오프라인강의'
		END
	ELSE IF (@type = 'L')
		BEGIN
			SET @return = '라이브교육'
		END
	ELSE IF (@type = 'R')
		BEGIN
			SET @return = '정규과정'
		END
	ELSE IF (@type = 'D')
		BEGIN
			SET @return = '교육자료'
		END
	ELSE IF (@type = 'T')
		BEGIN
			SET @return = '시험'
		END
	ELSE IF (@type = 'V')
		BEGIN
			SET @return = '설문'
		END
	ELSE
		BEGIN
			SET @return = '교육자료'
		END
	RETURN @return
END
;
GO
/****** Object:  UserDefinedFunction [dbo].[F_LMS_DATETYPE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =======================================================
함수명 : F_LMS_DATETYPE
날짜를 여러가지 형태로 가져온다.
========================================================== */
CREATE FUNCTION [dbo].[F_LMS_DATETYPE] (
              @idate    datetime ,
			  @type		VARCHAR(1)
              )
RETURNS VARCHAR(100)  
AS  
BEGIN 
	DECLARE @returndate VARCHAR(100)
	;
	IF (@type = '1')
		BEGIN
			SET @returndate = FORMAT(@idate, 'yyyy년 M월 d일')
		END
	ELSE IF (@type = '2')
		BEGIN
			SET @returndate = FORMAT(@idate, 'yyyy년 M월 d일') + '(' + LEFT(DATENAME(DW, @idate), 1) + ')'
		END
	ELSE IF (@type = '3')
		BEGIN
			SET @returndate = FORMAT(@idate, 'yyyy년 M월 d일') + '(' + LEFT(DATENAME(DW, @idate), 1) + ') ' + FORMAT(@idate, 'HH:mm')
		END
	ELSE IF (@type = '4')
		BEGIN
			SET @returndate = FORMAT(@idate, 'yyyy-MM-dd') + '(' + LEFT(DATENAME(DW, @idate), 1) + ')'
		END
	ELSE IF (@type = '5')
		BEGIN
			SET @returndate = FORMAT(@idate, 'yyyy-MM-dd') + '(' + LEFT(DATENAME(DW, @idate), 1) + ') ' + FORMAT(@idate, 'HH:mm')
		END
	ELSE
		BEGIN
			SET @returndate = FORMAT(@idate, 'yyyy-MM-dd');
		END
	RETURN @returndate
END
;
GO
/****** Object:  UserDefinedFunction [dbo].[F_LMS_DFYEAR]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =======================================================
함수명 : F_LMS_DFYEAR
입력일의 회기연도를 리턴한다.
========================================================== */
CREATE FUNCTION [dbo].[F_LMS_DFYEAR] (
	@idate    datetime 
)
RETURNS CHAR(4)  
AS  
BEGIN 
	DECLARE @PFYEAR CHAR(4)
	
	SELECT
		@PFYEAR = CASE WHEN DATEPART(MONTH,@idate) >= 9 THEN DATEPART(YEAR,@idate) + 1 
		ELSE DATEPART(YEAR,@idate) END

	RETURN @PFYEAR
END
;
GO
/****** Object:  UserDefinedFunction [dbo].[F_LMS_LIKECNT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =======================================================
함수명 : F_LMS_LIKECNT
숫자를 여러가지 형태로 가져온다
========================================================== */
CREATE FUNCTION [dbo].[F_LMS_LIKECNT] (
              @likecnt      INT ,
			  @type		VARCHAR(1)
              )
RETURNS VARCHAR(10)  
AS  
BEGIN 
	DECLARE @return VARCHAR(10)
	;
	IF (@type = '1')
		BEGIN
			SET @return = CASE WHEN @likecnt > 999 THEN CAST('999+' AS VARCHAR) ELSE CAST(@likecnt AS VARCHAR)  END
		END
	ELSE IF (@type = '2')
		BEGIN
			SET @return = REPLACE(CONVERT(VARCHAR,CONVERT(MONEY, @likecnt),1),'.00','') 
		END
	ELSE
		BEGIN
			SET @return = CONVERT(VARCHAR, @likecnt);
		END
	RETURN @return

END
;
GO
/****** Object:  UserDefinedFunction [dbo].[F_LMS_STUDY_STATUS]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =======================================================
함수명 : F_LMS_STUDY_STATUS
수강상태를 리턴한다.
교육대기 : A
진행중 : S
취소 : C
완료 : Y
미완료 : N
========================================================== */
CREATE FUNCTION [dbo].[F_LMS_STUDY_STATUS] (
			  @startdate		DATETIME,
			  @enddate		DATETIME,
			  @requestflag		VARCHAR(1),
			  @finishflag		VARCHAR(1),
			  @type		VARCHAR(1)
              )
RETURNS VARCHAR(10)  
AS  
BEGIN 
	DECLARE @return VARCHAR(10);
	DECLARE @returnCode VARCHAR(1);
	DECLARE @returnStr VARCHAR(10);


	IF (@requestflag = 'N') 
		BEGIN
			SET @returnCode = 'C'; -- 취소
			SET @returnStr = '취소'; -- 취소
		END
	ELSE IF (GETDATE() < @startdate)
		BEGIN
			SET @returnCode = 'A' -- 교육대기
			SET @returnStr = '교육대기'; -- 교육대기
		END
	ELSE IF (GETDATE() BETWEEN @startdate AND @enddate)
		BEGIN
			SET @returnCode = 'S' -- 진행중
			SET @returnStr = '진행중'; -- 진행중
		END
	ELSE IF (GETDATE() > @enddate)
		BEGIN
			IF (@finishflag = 'N')
				BEGIN
					SET @returnCode = 'N' -- 미완료
					SET @returnStr = '미완료'; -- 미완료
				END
			ELSE
				BEGIN
					SET @returnCode = 'Y' -- 완료
					SET @returnStr = '완료'; -- 완료
				END
		END

	IF (@type = 'T')
		BEGIN
			SET @return = @returnStr;
		END
	ELSE
		BEGIN
			SET @return = @returnCode;
		END

	RETURN @return;
END
;
GO
/****** Object:  UserDefinedFunction [dbo].[F_LMS_TIME_FORMAT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =======================================================
함수명 : F_LMS_TIME_FORMAT
11:20:04 을  11시 20분 4초 , 11h 20m 3s 형식으로 변환한다. 
========================================================== */
CREATE FUNCTION [dbo].[F_LMS_TIME_FORMAT] (
              @strtime      VARCHAR(10) ,
			        @type		VARCHAR(2)
              )
RETURNS VARCHAR(20)  
AS  
BEGIN 
	DECLARE @return VARCHAR(20)
	;
	IF (@type = 'kr')
		BEGIN
			SET @return = CASE WHEN CONVERT(INT,SUBSTRING(@strtime,1,2)) = 0 THEN '' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,1,2))) + '시 ' END 
                  + CASE WHEN CONVERT(INT,SUBSTRING(@strtime,4,2)) = 0 THEN '0' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,4,2))) END + '분 ' 
                  + CASE WHEN CONVERT(INT,SUBSTRING(@strtime,7,2)) = 0 THEN '0' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,7,2))) END + '초'
		END
	ELSE IF (@type = 'en')
		BEGIN
			SET @return = CASE WHEN CONVERT(INT,SUBSTRING(@strtime,1,2)) = 0 THEN '' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,1,2))) + 'h ' END 
                  + CASE WHEN CONVERT(INT,SUBSTRING(@strtime,4,2)) = 0 THEN '0' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,4,2))) END + 'm ' 
                  + CASE WHEN CONVERT(INT,SUBSTRING(@strtime,7,2)) = 0 THEN '0' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,7,2))) END + 's'
		END
	ELSE IF (@type = 'he')
		BEGIN
			SET @return = CASE WHEN CONVERT(INT,SUBSTRING(@strtime,1,2)) = 0 THEN '' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,1,2))) + 'H ' END 
                  + CASE WHEN CONVERT(INT,SUBSTRING(@strtime,4,2)) = 0 THEN '0' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,4,2))) END + 'M ' 
                  + CASE WHEN CONVERT(INT,SUBSTRING(@strtime,7,2)) = 0 THEN '0' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,7,2))) END + 'S'
		END
	ELSE
		BEGIN
			SET @return = CASE WHEN CONVERT(INT,SUBSTRING(@strtime,1,2)) = 0 THEN '' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,1,2))) + 'h ' END 
                  + CASE WHEN CONVERT(INT,SUBSTRING(@strtime,4,2)) = 0 THEN '0' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,4,2))) END + 'm ' 
                  + CASE WHEN CONVERT(INT,SUBSTRING(@strtime,7,2)) = 0 THEN '0' ELSE CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(@strtime,7,2))) END + 's'
		END
	RETURN @return

END
;
GO
/****** Object:  UserDefinedFunction [dbo].[F_SETTRFEEABONAME]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,홍석조>
-- Create date: <Create Date, 2016.08.01 ,>
-- Description:	<Description, ABO 이름을 홍*동 리턴 한다. ,>
-- =============================================
CREATE FUNCTION [dbo].[F_SETTRFEEABONAME]
(@ABO_NAME VARCHAR(12), @AGREEYN VARCHAR(1))
RETURNS VARCHAR(50)
WITH EXEC AS CALLER
AS
BEGIN
-- Declare the return variable here
	DECLARE @NAME VARCHAR(50)
  DECLARE @NUM  INT
  DECLARE @LNO  INT
  SET @NUM = 1
  SET @NAME = ''
  
  IF @AGREEYN = 'Y'
  BEGIN
    SET @NAME = @ABO_NAME
  END
  
  IF @AGREEYN = 'N'
  BEGIN
    WHILE @NUM <= LEN(@ABO_NAME)
    BEGIN
      IF @NUM%2 = 1 SET @NAME = @NAME + SUBSTRING(@ABO_NAME, @NUM, 1)
      IF @NUM%2 = 0 SET @NAME = @NAME + '*'

      SET @NUM = @NUM+1
    END
  END
  
	-- Return the result of the function
	RETURN @NAME;
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_TARGET_CODENAME]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,홍석조>
-- Create date: <Create Date, 2016.08.01 ,>
-- Description:	<Description, 코드 이름을 리턴 한다. ,>
-- =============================================
CREATE FUNCTION [dbo].[F_TARGET_CODENAME]
(@TARGETMASTERSEQ varchar(20), @TARGETCODESEQ varchar(20))
RETURNS varchar(50)
WITH EXEC AS CALLER
AS
BEGIN
-- Declare the return variable here
	DECLARE @CODENAME VARCHAR(50)

	-- Add the T-SQL statements to compute the return value here
	SELECT @CODENAME = TARGETCODENAME
	  FROM dbo.TARGETCODE
	 WHERE TARGETMASTERSEQ = @TARGETMASTERSEQ
     AND TARGETCODESEQ = @TARGETCODESEQ;

	-- Return the result of the function
	RETURN @CODENAME;
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_TARGET_ORDER]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,서길종>
-- Create date: <Create Date, 2016.08.11 ,>
-- Description:	<Description, 대상자코드 순서를 리턴 한다. ,>
-- =============================================
CREATE FUNCTION [dbo].[F_TARGET_ORDER]
(@TARGETRULESEQ int, @RULESTART varchar(50))
RETURNS int
WITH EXEC AS CALLER
AS
BEGIN
-- Declare the return variable here
	DECLARE @ORDER INT

	-- Add the T-SQL statements to compute the return value here
	 SELECT @ORDER = AI.TARGETCODEORDER
	   FROM TARGETCODE AI
		    INNER JOIN TARGETRULE BI
	        ON AI.TARGETMASTERSEQ = BI.TARGETCODEGUBUN
	  WHERE BI.TARGETRULESEQ = @TARGETRULESEQ
	    AND AI.TARGETCODESEQ = @RULESTART;

	-- Return the result of the function
	RETURN @ORDER;
END


GO
/****** Object:  UserDefinedFunction [dbo].[F_USEADMINNAME]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,홍석조>
-- Create date: <Create Date, 2016.08.01 ,>
-- Description:	<Description, ADMIN 사용자 이름을 리턴 한다. ,>
-- =============================================
CREATE FUNCTION [dbo].[F_USEADMINNAME]
(@NO VARCHAR(12))
RETURNS VARCHAR(50)
WITH EXEC AS CALLER
AS
BEGIN
-- Declare the return variable here
	DECLARE @NAME VARCHAR(50)

	-- Add the T-SQL statements to compute the return value here
	SELECT @NAME = '관리자 이름'

	-- Return the result of the function
	RETURN @NAME;
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_CMM_MENUCODE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/* =======================================================
함수명 : F_CMM_MENUCODE
작성자 : 서길종
작성일 : 2016/07/15

생성될 메뉴 코드를 가져온다.
========================================================== */

CREATE FUNCTION [dbo].[FN_CMM_MENUCODE] (@upCode AS varchar(200),@menuLv AS integer)
RETURNS varchar(200)  
AS  
BEGIN 
	DECLARE @newMenuCd	varchar(200);
	DECLARE @menuCnt	integer;
	DECLARE @menuCd		varchar(200);
	DECLARE @tempCd		varchar(200);

	SELECT @menuCnt = COUNT(MENUCODE)
		 , @menuCd = MAX(MENUCODE)
	FROM MENUCODE
	WHERE UPPERGROUP = @upCode;
	
	IF @menuCnt = 0 
		BEGIN
			SELECT @tempCd = CAST(CASE WHEN @menuLv = '2' THEN max(CAST(SUBSTRING(@upCode,2,4) AS integer))+1
								  WHEN @menuLv = '3' THEN max(CAST(SUBSTRING(@upCode,2,7) AS integer))+1
								  WHEN @menuLv = '4' THEN max(CAST(SUBSTRING(@upCode,2,9) AS integer))+1
							 END AS VARCHAR(200));
		END;
	ELSE
		BEGIN
			SELECT @tempCd = CAST(CASE WHEN MENULEVEL = '2' THEN max(CAST(SUBSTRING(menucode,2,4) AS integer))+1
								  WHEN MENULEVEL = '3' THEN max(CAST(SUBSTRING(menucode,2,7) AS integer))+1
								  WHEN MENULEVEL = '4' THEN max(CAST(SUBSTRING(menucode,2,9) AS integer))+1
							 END AS VARCHAR(200))
			FROM MENUCODE
			WHERE UPPERGROUP = @upCode
			AND	  MENULEVEL = @menuLv
			GROUP BY MENULEVEL;
		END
	;

	SELECT @newMenuCd = CASE WHEN @menuLv ='2' THEN 'W'+@tempCd+'00000'
	                         WHEN @menuLv ='3' THEN 'W'+@tempCd+'00'
							 WHEN @menuLv ='4' THEN 'W'+@tempCd+''
						END;
							
	return @newMenuCd

END
;





GO
/****** Object:  Table [dbo].[CODEMASTER]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CODEMASTER](
	[CODEMASTERSEQ] [varchar](20) NOT NULL,
	[WORKSCOPE] [varchar](20) NULL,
	[CODEMASTERNAME] [varchar](50) NULL,
	[CODEMASTERACCOUNT] [varchar](2000) NULL,
	[USEYN] [char](1) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL,
 CONSTRAINT [PK_CODEMASTER] PRIMARY KEY NONCLUSTERED 
(
	[CODEMASTERSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[COMMONCODE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[COMMONCODE](
	[CODEMASTERSEQ] [varchar](20) NOT NULL,
	[COMMONCODESEQ] [varchar](20) NOT NULL,
	[CODENAME] [varchar](50) NULL,
	[CODEACCOUNT] [varchar](2000) NULL,
	[CODEORDER] [int] NULL,
	[USEYN] [char](1) NULL,
	[CASEONE] [varchar](50) NULL,
	[CASETWO] [varchar](50) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CODEMASTERSEQ] ASC,
	[COMMONCODESEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FILEMANAGEMENT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FILEMANAGEMENT](
	[WORK] [varchar](50) NOT NULL,
	[FILEKEY] [numeric](12, 0) NOT NULL,
	[UPLOADSEQ] [numeric](6, 0) NOT NULL,
	[REALFILENAME] [varchar](300) NOT NULL,
	[STOREFILENAME] [varchar](300) NOT NULL,
	[FILEFULLURL] [varchar](4000) NOT NULL,
	[FILEEXT] [varchar](100) NOT NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[WORK] ASC,
	[FILEKEY] ASC,
	[UPLOADSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[K_LEVEL]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[K_LEVEL](
	[GRP_CD] [varchar](10) NOT NULL,
	[LEVEL_CD] [varchar](20) NOT NULL,
	[LEVEL_NM] [varchar](200) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFY_DT] [datetime] NULL,
	[USE_YN] [varchar](1) NULL,
	[DESCRIPTION] [varchar](4000) NULL,
 CONSTRAINT [PK_K_LEVEL] PRIMARY KEY CLUSTERED 
(
	[GRP_CD] ASC,
	[LEVEL_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[K_MENUBYLEVEL]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[K_MENUBYLEVEL](
	[GRP_CD] [varchar](10) NOT NULL,
	[LEVEL_CD] [varchar](20) NOT NULL,
	[MENU_CD] [varchar](100) NOT NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFY_DT] [datetime] NULL,
 CONSTRAINT [PK_K_MENUBYLEVEL] PRIMARY KEY CLUSTERED 
(
	[GRP_CD] ASC,
	[LEVEL_CD] ASC,
	[MENU_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[K_USERLEVEL]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[K_USERLEVEL](
	[GRP_CD] [varchar](10) NOT NULL,
	[USER_ID] [varchar](50) NOT NULL,
	[LEVEL_CD] [varchar](20) NOT NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFY_DT] [datetime] NULL,
	[USE_YN] [varchar](1) NULL,
 CONSTRAINT [PK_K_USERLEVEL] PRIMARY KEY CLUSTERED 
(
	[GRP_CD] ASC,
	[USER_ID] ASC,
	[LEVEL_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LEVEL]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LEVEL](
	[SYSTEMCODE] [varchar](10) NOT NULL,
	[LEVELCODE] [varchar](20) NOT NULL,
	[LEVELNAME] [varchar](200) NULL,
	[USEYN] [varchar](1) NULL,
	[DESCRIPTION] [varchar](4000) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL,
 CONSTRAINT [PK_LEVEL] PRIMARY KEY CLUSTERED 
(
	[SYSTEMCODE] ASC,
	[LEVELCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSAGREE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSAGREE](
	[UID] [varchar](11) NOT NULL,
	[CATEGORYID] [numeric](5, 0) NOT NULL,
	[AGREEDATE] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UID] ASC,
	[CATEGORYID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSCATEGORY]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSCATEGORY](
	[CATEGORYID] [numeric](5, 0) NOT NULL,
	[CATEGORYTYPE] [char](1) NOT NULL,
	[CATEGORYNAME] [varchar](100) NOT NULL,
	[CATEGORYCODE] [varchar](5) NOT NULL,
	[CATEGORYUPID] [numeric](5, 0) NULL,
	[CATEGORYLEVEL] [int] NOT NULL,
	[OPENFLAG] [char](1) NOT NULL,
	[COMPLIANCEFLAG] [char](1) NOT NULL,
	[COPYRIGHTFLAG] [char](1) NOT NULL,
	[REGISTRANTDATE] [datetime] NOT NULL,
	[MODIFYDATE] [datetime] NOT NULL,
	[HYBRISMENU] [varchar](100) NULL,
	[REGISTRANT] [varchar](50) NOT NULL,
	[MODIFIER] [varchar](50) NOT NULL,
	[CATEGORYORDER] [varchar](5) NOT NULL,
	[USEFLAG] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CATEGORYID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSCONNECTLOG]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSCONNECTLOG](
	[UID] [varchar](11) NOT NULL,
	[CONNECTDATE] [datetime] NOT NULL,
	[REGULARDATE] [datetime] NOT NULL,
	[REGULARWEEKCOUNT] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UID] ASC,
	[CONNECTDATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSCOURSE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSCOURSE](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[CATEGORYID] [numeric](5, 0) NOT NULL,
	[COURSETYPE] [varchar](5) NOT NULL,
	[COURSENAME] [varchar](100) NOT NULL,
	[THEMENAME] [varchar](100) NULL,
	[THEMESEQ] [numeric](10, 0) NULL,
	[OPENFLAG] [char](1) NOT NULL,
	[REQUESTSTARTDATE] [datetime] NULL,
	[REQUESTENDDATE] [datetime] NULL,
	[STARTDATE] [datetime] NOT NULL,
	[ENDDATE] [datetime] NOT NULL,
	[REGISTRANTDATE] [datetime] NOT NULL,
	[MODIFYDATE] [datetime] NOT NULL,
	[COURSECONTENT] [varchar](1000) NULL,
	[DATATYPE] [char](1) NULL,
	[PLAYTIME] [varchar](8) NULL,
	[COURSEIMAGE] [varchar](50) NULL,
	[COURSEIMAGENOTE] [varchar](100) NULL,
	[SNSFLAG] [char](1) NULL,
	[GROUPFLAG] [char](1) NULL,
	[USEFLAG] [char](1) NOT NULL,
	[REGISTRANT] [varchar](50) NOT NULL,
	[MODIFIER] [varchar](50) NOT NULL,
	[TARGET] [varchar](100) NULL,
	[SEARCHWORD] [varchar](1000) NULL,
	[CANCELTERM] [int] NULL,
	[LIKECOUNT] [int] NULL,
	[VIEWCOUNT] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSCOURSECONDITION]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSCOURSECONDITION](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[CONDITIONTYPE] [char](1) NOT NULL,
	[CONDITIONSEQ] [int] NOT NULL,
	[ABOTYPECODE] [varchar](20) NULL,
	[ABOTYPEABOVE] [varchar](5) NULL,
	[PINCODE] [varchar](20) NULL,
	[PINUNDER] [varchar](5) NULL,
	[PINABOVE] [varchar](5) NULL,
	[BONUSCODE] [varchar](20) NULL,
	[BONUSUNDER] [varchar](5) NULL,
	[BONUSABOVE] [varchar](5) NULL,
	[AGECODE] [varchar](20) NULL,
	[AGEUNDER] [varchar](5) NULL,
	[AGEABOVE] [varchar](5) NULL,
	[LOACODE] [varchar](200) NULL,
	[DIACODE] [varchar](8000) NULL,
	[CUSTOMERCODE] [varchar](20) NULL,
	[CONSECUTIVECODE] [varchar](20) NULL,
	[BUSINESSSTATUSCODE] [varchar](50) NULL,
	[TARGETCODE] [varchar](20) NULL,
	[TARGETMEMBER] [text] NULL,
	[STARTDATE] [datetime] NOT NULL,
	[ENDDATE] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[CONDITIONTYPE] ASC,
	[CONDITIONSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSDATA]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSDATA](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[PCLINK] [varchar](1000) NULL,
	[MOBILELINK] [varchar](1000) NULL,
	[FILELINK] [varchar](1000) NULL,
	[FILEDOWN] [varchar](1000) NULL,
 CONSTRAINT [PK__LMSDATA__CC214B4F3ACBBBC8] PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSLIVE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSLIVE](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[LIVELINK] [varchar](1000) NOT NULL,
	[LIVEREPLAYLINK] [varchar](1000) NULL,
	[REPLAYSTART] [datetime] NULL,
	[REPLAYEND] [datetime] NULL,
	[TARGETDETAIL] [text] NULL,
	[NOTE] [text] NULL,
	[LINKTITLE] [varchar](100) NULL,
	[LINKURL] [varchar](200) NULL,
	[PENALTYNOTE] [text] NULL,
	[LIMITCOUNT] [int] NULL,
	[CANCELTERM] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSLOG]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSLOG](
	[LOGID] [numeric](10, 0) NOT NULL,
	[LOGTYPE] [char](1) NOT NULL,
	[WORKTYPE] [char](1) NOT NULL,
	[REGISRANTDATE] [datetime] NOT NULL,
	[REGISTRANT] [varchar](50) NOT NULL,
	[SUCCESSCOUNT] [int] NOT NULL,
	[FAILCOUNT] [int] NOT NULL,
	[COURSEID] [varchar](10) NULL,
	[LOGCONTENT] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[LOGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSOFFLINE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSOFFLINE](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[PLACEFLAG] [char](1) NOT NULL,
	[TOGETHERFLAG] [char](1) NOT NULL,
	[PENALTYFLAG] [char](1) NULL,
	[PENALTYTERM] [int] NULL,
	[APSEQ] [varchar](5) NOT NULL,
	[APNAME] [varchar](50) NOT NULL,
	[ROOMSEQ] [varchar](5) NOT NULL,
	[ROOMNAME] [varchar](50) NOT NULL,
	[LIMITCOUNT] [int] NOT NULL,
	[DETAILCONTENT] [text] NULL,
	[TARGETDETAIL] [text] NULL,
	[NOTE] [text] NULL,
	[LINKTITLE] [varchar](100) NULL,
	[LINKURL] [varchar](200) NULL,
	[PENALTYNOTE] [text] NULL,
	[CANCELTERM] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSONLINE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSONLINE](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[ACTIVITYID] [varchar](50) NOT NULL,
	[ACTIVITYCODE] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSPENALTY]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSPENALTY](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[UID] [varchar](11) NOT NULL,
	[REGISTRANTDATE] [datetime] NOT NULL,
	[CLEARDATE] [datetime] NULL,
	[CLEARNOTE] [varchar](200) NULL,
	[PENALTYFLAG] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSREGULAR]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSREGULAR](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[STEPCOUNT] [int] NOT NULL,
	[TOGETHERFLAG] [char](1) NULL,
	[STAMPFLAG] [char](1) NULL,
	[STAMPID] [numeric](5, 0) NULL,
	[LIMITCOUNT] [int] NULL,
	[TARGETDETAIL] [text] NULL,
	[NOTE] [text] NULL,
	[PASSNOTE] [text] NULL,
	[LINKTITLE] [varchar](100) NULL,
	[LINKURL] [varchar](200) NULL,
	[PENALTYNOTE] [text] NULL,
	[CANCELTERM] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSAVELOG]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSAVELOG](
	[UID] [varchar](11) NOT NULL,
	[COURSEID] [numeric](10, 0) NOT NULL,
	[SAVETYPE] [char](1) NOT NULL,
	[SAVEDATE] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UID] ASC,
	[COURSEID] ASC,
	[SAVETYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSEAT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSEAT](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[SEATSEQ] [int] NOT NULL,
	[SEATTYPE] [char](1) NOT NULL,
	[SEATNUMBER] [varchar](20) NOT NULL,
	[SEATUSEFLAG] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[SEATSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSEATSTUDENT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSEATSTUDENT](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[UID] [varchar](11) NOT NULL,
	[SEATSEQ] [int] NOT NULL,
	[REGISTRANTDATE] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[UID] ASC,
	[SEATSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSTAMP]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSTAMP](
	[STAMPID] [numeric](5, 0) NOT NULL,
	[STAMPTYPE] [char](1) NOT NULL,
	[STAMPNAME] [varchar](100) NOT NULL,
	[STAMPCONDITION] [varchar](100) NULL,
	[STAMPCONTENT] [varchar](200) NULL,
	[REGISTRANTDATE] [datetime] NOT NULL,
	[MODIFYDATE] [datetime] NOT NULL,
	[REGISTRANT] [varchar](50) NOT NULL,
	[MODIFIER] [varchar](50) NOT NULL,
	[USEFLAG] [char](1) NOT NULL,
	[OFFIMAGE] [varchar](50) NOT NULL,
	[ONIMAGE] [varchar](50) NOT NULL,
	[OFFIMAGENOTE] [varchar](50) NULL,
	[ONIMAGENOTE] [varchar](50) NULL,
	[PINCODE] [varchar](5) NULL,
	[BONUSCODE] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[STAMPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSTAMPGOAL]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSTAMPGOAL](
	[UID] [varchar](11) NOT NULL,
	[GOALSEQ] [int] NOT NULL,
	[PINCODE] [varchar](5) NULL,
	[BONUSCODE] [varchar](5) NULL,
	[GOALTERM] [int] NULL,
	[REGISTRANTDATE] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UID] ASC,
	[GOALSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSTAMPOBTAIN]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSTAMPOBTAIN](
	[UID] [varchar](11) NOT NULL,
	[STAMPID] [numeric](5, 0) NOT NULL,
	[OBTAINSEQ] [int] NOT NULL,
	[OBTAINDATE] [datetime] NOT NULL,
	[COURSEID] [numeric](10, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[UID] ASC,
	[STAMPID] ASC,
	[OBTAINSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSTEP]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSTEP](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[STEPSEQ] [int] NOT NULL,
	[STEPNAME] [varchar](100) NOT NULL,
	[STEPORDER] [int] NOT NULL,
	[STEPCOUNT] [int] NULL,
	[MUSTFLAG] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[STEPSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSTEPFINISH]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSTEPFINISH](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[STEPSEQ] [int] NOT NULL,
	[UID] [varchar](11) NOT NULL,
	[FINISHFLAG] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[STEPSEQ] ASC,
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSTEPUNIT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSTEPUNIT](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[STEPSEQ] [int] NOT NULL,
	[STEPCOURSEID] [numeric](10, 0) NOT NULL,
	[MUSTFLAG] [char](1) NOT NULL,
	[UNITORDER] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[STEPSEQ] ASC,
	[STEPCOURSEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSTUDENT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSTUDENT](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[UID] [varchar](11) NOT NULL,
	[REQUESTFLAG] [char](1) NULL,
	[REQUESTDATE] [datetime] NULL,
	[CANCELDATE] [datetime] NULL,
	[CANCELNOTE] [varchar](100) NULL,
	[TOGETHERREQUESTFLAG] [char](1) NULL,
	[PINCODE] [varchar](5) NULL,
	[REQUESTCHANNEL] [char](1) NULL,
	[STUDYFLAG] [char](1) NULL,
	[STUDYDATE] [datetime] NULL,
	[ATTENDFLAG] [char](1) NULL,
	[FINISHFLAG] [char](1) NULL,
	[FINISHDATE] [datetime] NULL,
	[SUBJECTPOINT] [int] NULL,
	[OBJECTPOINT] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSUBSCRIBE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSUBSCRIBE](
	[UID] [varchar](11) NOT NULL,
	[CATEGORYID] [numeric](5, 0) NOT NULL,
	[SUBSCRIBEDATE] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UID] ASC,
	[CATEGORYID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSURVEY]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSURVEY](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[SURVEYSEQ] [numeric](5, 0) NOT NULL,
	[SURVEYNAME] [text] NOT NULL,
	[SURVEYTYPE] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[SURVEYSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSURVEYOPINION]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSURVEYOPINION](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[SURVEYSEQ] [numeric](5, 0) NOT NULL,
	[UID] [varchar](11) NOT NULL,
	[OPINIONSEQ] [int] NOT NULL,
	[OPINIONCONTENT] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[SURVEYSEQ] ASC,
	[UID] ASC,
	[OPINIONSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSURVEYRESPONSE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSURVEYRESPONSE](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[SURVEYSEQ] [numeric](5, 0) NOT NULL,
	[UID] [varchar](11) NOT NULL,
	[SUBJECTRESPONSE] [text] NULL,
	[OBJECTRESPONSE] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[SURVEYSEQ] ASC,
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSSURVEYSAMPLE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSSURVEYSAMPLE](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[SURVEYSEQ] [numeric](5, 0) NOT NULL,
	[SAMPLESEQ] [int] NOT NULL,
	[SAMPLENAME] [varchar](100) NULL,
	[SAMPLEVALUE] [int] NULL,
	[DIRECTYN] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[SURVEYSEQ] ASC,
	[SAMPLESEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSTEST]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSTEST](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[LIMITTIME] [int] NOT NULL,
	[PASSPOINT] [int] NOT NULL,
	[TESTTYPE] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSTESTANSWER]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSTESTANSWER](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[UID] [varchar](11) NOT NULL,
	[ANSWERSEQ] [int] NOT NULL,
	[TESTPOOLID] [numeric](10, 0) NOT NULL,
	[TESTPOOLPOINT] [int] NULL,
	[SUBJECTANSWER] [text] NULL,
	[OBJECTANSWER] [varchar](20) NULL,
	[POINT] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[UID] ASC,
	[ANSWERSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSTESTPOOL]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSTESTPOOL](
	[TESTPOOLID] [numeric](10, 0) NOT NULL,
	[CATEGORYID] [numeric](5, 0) NOT NULL,
	[TESTPOOLNAME] [varchar](100) NOT NULL,
	[TESTPOOLNOTE] [text] NULL,
	[ANSWERTYPE] [char](1) NOT NULL,
	[OBJECTANSWER] [varchar](20) NULL,
	[SUBJECTANSWER] [text] NULL,
	[USEFLAG] [char](1) NULL,
	[TESTPOOLIMAGE] [varchar](100) NULL,
	[TESTPOOLIMAGENOTE] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TESTPOOLID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSTESTPOOLANSWER]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSTESTPOOLANSWER](
	[TESTPOOLID] [numeric](10, 0) NOT NULL,
	[TESTPOOLANSWERSEQ] [int] NOT NULL,
	[TESTPOOLANSWERNAME] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TESTPOOLID] ASC,
	[TESTPOOLANSWERSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSTESTSUBMIT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSTESTSUBMIT](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[SUBMITSEQ] [int] NOT NULL,
	[TESTCOUNT] [int] NOT NULL,
	[TESTPOINT] [int] NOT NULL,
	[ANSWERTYPE] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[SUBMITSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LMSVIEWLOG]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LMSVIEWLOG](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[VIEWTYPE] [char](1) NOT NULL,
	[VIEWMONTH] [char](6) NOT NULL,
	[UID] [varchar](11) NOT NULL,
	[VIEWCOUNT] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[COURSEID] ASC,
	[VIEWTYPE] ASC,
	[VIEWMONTH] ASC,
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MANAGER]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MANAGER](
	[ADNO] [varchar](11) NOT NULL,
	[MANAGENAME] [varchar](40) NULL,
	[MANAGEDEPART] [varchar](50) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL,
 CONSTRAINT [PK_MANAGER] PRIMARY KEY NONCLUSTERED 
(
	[ADNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MEMBER]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MEMBER](
	[UID] [varchar](11) NOT NULL,
	[GROUPS] [varchar](1) NULL,
	[HIGHESTACHIEVE] [varchar](1) NULL,
	[CUSTOMERGUBUN] [varchar](1) NULL,
	[NAME] [varchar](40) NULL,
	[MEMBERID] [varchar](10) NULL,
	[CREATIONTIME] [varchar](8) NULL,
	[SSN] [varchar](13) NULL,
	[PARTNERINFOSSN] [varchar](13) NULL,
	[PARTNERINFONAME] [varchar](10) NULL,
	[BUSINESSDISTRICT] [varchar](20) NULL,
	[QUALIFYDIA] [varchar](11) NULL,
	[QUALIFYPT] [varchar](11) NULL,
	[LOAGROUP] [varchar](2) NULL,
	[LOANAMEKOR] [varchar](20) NULL,
	[LOANAMEENG] [varchar](20) NULL,
	[DIAGROUP] [varchar](20) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL,
 CONSTRAINT [PK_MEMBER] PRIMARY KEY NONCLUSTERED 
(
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MENUCODE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MENUCODE](
	[SYSTEMCODE] [varchar](10) NOT NULL,
	[MENUCODE] [varchar](100) NOT NULL,
	[MENUTYPE] [varchar](10) NOT NULL,
	[MENUNAME] [varchar](100) NULL,
	[LINKURL] [varchar](300) NULL,
	[UPPERGROUP] [varchar](200) NULL,
	[MENUSEQ] [numeric](5, 0) NULL,
	[MENULEVEL] [numeric](5, 0) NULL,
	[USEYN] [char](1) NULL,
	[VISIBLEYN] [char](1) NULL,
	[MENUYN] [char](1) NULL,
	[SORTNUM] [numeric](5, 0) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL,
 CONSTRAINT [PK_MENUCODE] PRIMARY KEY CLUSTERED 
(
	[SYSTEMCODE] ASC,
	[MENUCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NOTESET]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NOTESET](
	[NOTESETSEQ] [int] NOT NULL,
	[NOTESERVICE] [varchar](20) NULL,
	[NOTEITEM] [varchar](20) NULL,
	[SENDTIME] [varchar](1000) NULL,
	[NOTECONTENT] [varchar](2000) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL,
 CONSTRAINT [PK_NOTESET] PRIMARY KEY NONCLUSTERED 
(
	[NOTESETSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVCITYGROUPMAP]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVCITYGROUPMAP](
	[MAPPINGSEQ] [int] IDENTITY(1,1) NOT NULL,
	[CITYGROUPCODE] [varchar](3) NOT NULL,
	[REGIONCODE] [varchar](10) NULL,
	[CITYCODE] [varchar](10) NULL,
 CONSTRAINT [XPK지역군_맵핑] PRIMARY KEY CLUSTERED 
(
	[MAPPINGSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVCITYGROUPMASTER]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVCITYGROUPMASTER](
	[CITYGROUPCODE] [int] IDENTITY(1,1) NOT NULL,
	[CITYGROUPNAME] [varchar](20) NULL,
	[MODIFYDATETIME] [datetime] NULL,
	[MODIFIER] [varchar](100) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK지역군_마스터] PRIMARY KEY CLUSTERED 
(
	[CITYGROUPCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVCITYINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVCITYINFO](
	[REGIONCODE] [varchar](10) NOT NULL,
	[CITYCODE] [varchar](10) NOT NULL,
	[CITYNAME] [varchar](100) NULL,
	[SHORTNAME] [varchar](100) NULL,
 CONSTRAINT [XPK시군구_지역_정보] PRIMARY KEY CLUSTERED 
(
	[CITYCODE] ASC,
	[REGIONCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVCLAUSEHISTORY]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVCLAUSEHISTORY](
	[CLAUSESEQ] [int] NOT NULL,
	[AGREEDATETIME] [datetime] NULL,
	[STATUSCODE] [varchar](3) NULL,
	[MEMBERNO] [int] NOT NULL,
 CONSTRAINT [XPK약관_동의_이력_정보] PRIMARY KEY CLUSTERED 
(
	[CLAUSESEQ] ASC,
	[MEMBERNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVCLAUSEINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVCLAUSEINFO](
	[CLAUSESEQ] [int] IDENTITY(1,1) NOT NULL,
	[CONTENT] [varchar](2000) NULL,
	[TITLE] [varchar](300) NULL,
	[TYPECODE] [varchar](3) NULL,
	[MANDATORYCODE] [varchar](3) NULL,
	[VERSION] [varchar](20) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK약관_정보] PRIMARY KEY CLUSTERED 
(
	[CLAUSESEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVCONSTRAINT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVCONSTRAINT](
	[SETTINGSEQ] [int] IDENTITY(1,1) NOT NULL,
	[CONSTRAINTTYPE] [varchar](3) NULL,
	[PINTREATRANGE] [varchar](20) NULL,
	[CITYTREATCODE] [varchar](3) NULL,
	[AGETREATCODE] [varchar](10) NULL,
	[GROUPSEQ] [int] NULL,
	[PPSEQ] [int] NULL,
	[GLOBALDAILYCOUNT] [numeric](2, 0) NULL,
	[GLOBALWEEKLYCOUNT] [numeric](2, 0) NULL,
	[GLOBALMONTHLYCOUNT] [numeric](2, 0) NULL,
	[PPDAILYCOUNT] [numeric](2, 0) NULL,
	[PPWEEKLYCOUNT] [numeric](2, 0) NULL,
	[PPMONTHLYCOUNT] [numeric](2, 0) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK누적_예약_횟수_제한_설정] PRIMARY KEY CLUSTERED 
(
	[SETTINGSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVDETAILCODE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVDETAILCODE](
	[MASTERCODE] [varchar](3) NOT NULL,
	[DETAILCODE] [varchar](3) NOT NULL,
	[DETAILNAME] [varchar](100) NULL,
	[ORDERNUMBER] [numeric](2, 0) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[CASE1] [varchar](5) NULL,
	[CASE2] [varchar](5) NULL,
	[ETCNOTE] [varchar](2000) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK공통코드_상세분류] PRIMARY KEY CLUSTERED 
(
	[MASTERCODE] ASC,
	[DETAILCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVEXPINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVEXPINFO](
	[EXPSEQ] [int] IDENTITY(1,1) NOT NULL,
	[PPSEQ] [int] NOT NULL,
	[CATEGORYTYPE1] [varchar](3) NULL,
	[CATEGORYTYPE2] [varchar](5) NULL,
	[CATEGORYTYPE3] [varchar](7) NULL,
	[THEMENAME] [varchar](50) NULL,
	[PRODUCTNAME] [varchar](100) NULL,
	[STARTDATE] [varchar](8) NULL,
	[ENDDATE] [varchar](8) NULL,
	[TIME1] [varchar](100) NULL,
	[NOTE1] [varchar](2000) NULL,
	[TIME2] [varchar](100) NULL,
	[NOTE2] [varchar](2000) NULL,
	[TIME3] [varchar](100) NULL,
	[NOTE3] [varchar](2000) NULL,
	[INTRO] [varchar](2000) NULL,
	[CONTENT] [varchar](2000) NULL,
	[SEATCOUNT1] [numeric](3, 0) NULL,
	[SEATCOUNT2] [numeric](3, 0) NULL,
	[USETIME] [varchar](100) NULL,
	[USETIMENOTE] [varchar](2000) NULL,
	[ROLE] [varchar](20) NULL,
	[ROLENOTE] [varchar](2000) NULL,
	[PREPARATION] [varchar](100) NULL,
	[KEYWORD] [varchar](100) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK체험_정보_마스터] PRIMARY KEY CLUSTERED 
(
	[EXPSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVEXPPENALTYMAP]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RSVEXPPENALTYMAP](
	[PENALTYSEQ] [int] NOT NULL,
	[EXPSESSIONSEQ] [int] NOT NULL,
 CONSTRAINT [XPK체험_패널티_맵핑] PRIMARY KEY CLUSTERED 
(
	[PENALTYSEQ] ASC,
	[EXPSESSIONSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RSVEXPPENALTYSETTING]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVEXPPENALTYSETTING](
	[PENALTYSEQ] [int] NOT NULL,
	[EXPSESSIONSEQ] [int] NOT NULL,
	[TYPECODE] [varchar](3) NULL,
	[TYPEDETAILCODE] [varchar](3) NULL,
	[TYPEVALUE] [varchar](50) NULL,
	[PERIODCODE] [varchar](3) NULL,
	[PERIODVALUE] [numeric](2, 0) NULL,
	[APPLYTYPECODE] [varchar](3) NULL,
	[APPLYTYPEVALUE] [varchar](100) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK체험_패널티_설정_정보] PRIMARY KEY CLUSTERED 
(
	[PENALTYSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVEXPROLE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVEXPROLE](
	[EXPROLESEQ] [int] IDENTITY(1,1) NOT NULL,
	[EXPSESSIONSEQ] [int] NULL,
	[TARGETTYPECODE] [varchar](3) NULL,
	[GROUPSEQ] [int] NULL,
	[PINTREATRANGE] [varchar](20) NULL,
	[CITYTREATCODE] [varchar](3) NULL,
	[AGETREATCODE] [varchar](20) NULL,
	[PERIODTYPECODE] [varchar](3) NULL,
	[STARTMONTH] [varchar](6) NULL,
	[ENDMONTH] [varchar](6) NULL,
	[STARTDAY] [varchar](2) NULL,
	[ENDDAY] [varchar](2) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK체험_세션별_예약_자격_설정_정보] PRIMARY KEY CLUSTERED 
(
	[EXPROLESEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVEXPSESSIONINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVEXPSESSIONINFO](
	[EXPSESSIONSEQ] [int] IDENTITY(1,1) NOT NULL,
	[EXPSEQ] [int] NOT NULL,
	[SETTYPECODE] [varchar](3) NULL,
	[SETWEEK] [varchar](3) NULL,
	[SETDATE] [varchar](8) NULL,
	[SESSIONNAME] [varchar](6) NULL,
	[STARTDATETIME] [varchar](4) NULL,
	[ENDDATETIME] [varchar](4) NULL,
	[ORDERNUMBER] [numeric](2, 0) NULL,
	[WORKTYPECODE] [varchar](3) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
	[STATUSCODE] [varchar](3) NULL,
 CONSTRAINT [XPK체험_세션_정보] PRIMARY KEY CLUSTERED 
(
	[EXPSESSIONSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVEXPTYPEMAP]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RSVEXPTYPEMAP](
	[TYPESEQ] [int] NOT NULL,
	[EXPSEQ] [int] NOT NULL,
	[SETTINGSEQ] [int] NOT NULL,
 CONSTRAINT [XPK체험타입_맵핑] PRIMARY KEY CLUSTERED 
(
	[TYPESEQ] ASC,
	[EXPSEQ] ASC,
	[SETTINGSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RSVMASTERCODE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVMASTERCODE](
	[MASTERCODE] [varchar](3) NOT NULL,
	[MASTERNAME] [varchar](100) NULL,
	[ORDERNUMBER] [numeric](2, 0) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[ETCNOTE] [varchar](2000) NULL,
	[CATEGORY] [varchar](3) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK공통코드_대분류] PRIMARY KEY CLUSTERED 
(
	[MASTERCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVPAYMENTSTATUS]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVPAYMENTSTATUS](
	[RSVSEQ] [int] NOT NULL,
	[PAYMENTCODE] [varchar](3) NULL,
	[PAYMENTSEQ] [int] IDENTITY(1,1) NOT NULL,
	[PROCESSDATE] [datetime] NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
	[ACCOUNT] [varchar](20) NULL,
 CONSTRAINT [XPK결제_진행_이력_정보] PRIMARY KEY CLUSTERED 
(
	[PAYMENTSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVPENALTYHISTORY]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVPENALTYHISTORY](
	[HISTORYSEQ] [int] NOT NULL,
	[ACCOUNT] [varchar](20) NULL,
	[RSVSEQ] [int] NULL,
	[PENALTYSEQ] [int] NOT NULL,
	[APPLYTYPECODE] [varchar](3) NULL,
	[APPLYTYPEVALUE] [varchar](100) NULL,
	[REASON] [varchar](50) NULL,
	[GRANTDATE] [varchar](8) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK패널티_이력_정보] PRIMARY KEY CLUSTERED 
(
	[HISTORYSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVPENALTYSETTING]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVPENALTYSETTING](
	[PENALTYSEQ] [int] NOT NULL,
	[TYPECODE] [varchar](3) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[TYPEDETAILCODE] [varchar](3) NULL,
	[TYPEVALUE] [varchar](5) NULL,
	[PERIODCODE] [varchar](3) NULL,
	[PERIODVALUE] [numeric](2, 0) NULL,
	[APPLYTYPECODE] [varchar](3) NULL,
	[APPLYTYPEVALUE] [varchar](100) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK시설_패널티_설정_정보] PRIMARY KEY CLUSTERED 
(
	[PENALTYSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVPPHISTORY]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVPPHISTORY](
	[HISTORYSEQ] [int] NOT NULL,
	[STATUSCODE] [varchar](3) NULL,
	[PPSEQ] [int] NOT NULL,
	[PPNAME] [varchar](50) NULL,
	[WAREHOUSECODE] [varchar](3) NULL,
	[MODIFYDATETIME] [datetime] NULL,
	[MODIFIER] [varchar](100) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK교육장_변경_이력] PRIMARY KEY CLUSTERED 
(
	[HISTORYSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVPPINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVPPINFO](
	[PPSEQ] [int] NOT NULL,
	[PPNAME] [varchar](50) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[WAREHOUSECODE] [varchar](3) NULL,
	[ORDERNUMBER] [numeric](2, 0) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK교육장_PP__정보] PRIMARY KEY CLUSTERED 
(
	[PPSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVPURCHASEINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVPURCHASEINFO](
	[PURCHASEDATE] [varchar](8) NULL,
	[CARDTRACENUMBER] [varchar](10) NULL,
	[SKU] [varchar](50) NULL,
	[PRICE] [numeric](10, 0) NULL,
	[REQUESTDATETIME] [datetime] NULL,
	[VIRTUALDATETIME] [datetime] NULL,
	[REGULARDATETIME] [datetime] NULL,
	[VIRTUALPURCHASNUMBER] [varchar](10) NULL,
	[REGULARPURCHASENUMBER] [varchar](10) NULL,
	[RSVSEQ] [int] NOT NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
	[SKU_OLD] [varchar](50) NULL,
	[ACCOUNT] [varchar](20) NULL,
 CONSTRAINT [XPK주문정보관리] PRIMARY KEY CLUSTERED 
(
	[RSVSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVREGIONINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVREGIONINFO](
	[REGIONCODE] [varchar](10) NOT NULL,
	[REGIONNAME] [varchar](100) NULL,
	[SHORTNAME] [varchar](100) NULL,
 CONSTRAINT [XPK행정구역_정보] PRIMARY KEY CLUSTERED 
(
	[REGIONCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVRESERVATIONINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVRESERVATIONINFO](
	[RSVSEQ] [int] IDENTITY(1,1) NOT NULL,
	[RSVTYPECODE] [varchar](3) NULL,
	[TYPESEQ] [int] NULL,
	[PPSEQ] [int] NULL,
	[ROOMSEQ] [int] NULL,
	[EXPSEQ] [int] NULL,
	[RESERVATIONDATE] [varchar](8) NULL,
	[RSVSESSIONSEQ] [int] NULL,
	[EXPSESSIONSEQ] [int] NULL,
	[ACCOUNT] [varchar](20) NULL,
	[ACCOUNTTYPE] [varchar](3) NULL,
	[AMOUNT] [varchar](10) NULL,
	[STARTDATETIME] [varchar](4) NULL,
	[ENDDATETIME] [varchar](4) NULL,
	[ADMINFIRSTCODE] [varchar](3) NULL,
	[ADMINFIRSTREASON] [varchar](100) NULL,
	[ADMINFIRSTREASONCODE] [varchar](3) NULL,
	[COOKMASTERCODE] [varchar](3) NULL,
	[NOSHOWCODE] [varchar](3) NULL,
	[PARTNERTYPECODE] [varchar](3) NULL,
	[PARTNERID] [varchar](11) NULL,
	[STANDBYNUMBER] [numeric](2, 0) NULL,
	[PURCHASEDATE] [datetime] NULL,
	[PAYMENTSTATUSCODE] [varchar](3) NULL,
	[PAYMENTAMOUNT] [numeric](10, 0) NULL,
	[PAYMENTDATE] [datetime] NULL,
	[PAYMENTOPTIONCODE] [varchar](3) NULL,
	[PAYMENTINTERNALCODE] [varchar](3) NULL,
	[CANCELCODE] [varchar](3) NULL,
	[CANCELDATETIME] [datetime] NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK사용자_예약_정보] PRIMARY KEY CLUSTERED 
(
	[RSVSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVROLEGROUP]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVROLEGROUP](
	[GROUPSEQ] [int] NOT NULL,
	[TARGETGROUPNAME] [varchar](100) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
	[STATUSCODE] [varchar](3) NULL,
	[TARGETUSE] [varchar](200) NULL,
 CONSTRAINT [XPK예약_자격_대상자_그룹] PRIMARY KEY CLUSTERED 
(
	[GROUPSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVROLETARGET]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVROLETARGET](
	[TARGETSEQ] [int] NOT NULL,
	[ABONO] [varchar](20) NULL,
	[ABONAME] [varchar](100) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[GROUPSEQ] [int] NOT NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK예약_자격_대상자_정보] PRIMARY KEY CLUSTERED 
(
	[TARGETSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVROOMINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVROOMINFO](
	[ROOMSEQ] [int] IDENTITY(1,1) NOT NULL,
	[INTRO] [varchar](2000) NULL,
	[FACILITYSTATUSCODE] [varchar](3) NULL,
	[ROOMNAME] [varchar](100) NULL,
	[SEATCOUNT] [numeric](3, 0) NULL,
	[FACILITY] [varchar](2000) NULL,
	[USETIME] [varchar](100) NULL,
	[ROLE] [varchar](20) NULL,
	[ROLENOTE] [varchar](2000) NULL,
	[KEYWORD] [varchar](100) NULL,
	[PPSEQ] [int] NOT NULL,
	[STATUSCODE] [varchar](3) NULL,
	[ENDDATE] [varchar](8) NULL,
	[STARTDATE] [varchar](8) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK시설_정보_마스터] PRIMARY KEY CLUSTERED 
(
	[ROOMSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVROOMPENALTYMAP]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RSVROOMPENALTYMAP](
	[PENALTYSEQ] [int] NOT NULL,
	[RSVSESSIONSEQ] [int] NOT NULL,
 CONSTRAINT [XPK시설_패널티_맵핑] PRIMARY KEY CLUSTERED 
(
	[PENALTYSEQ] ASC,
	[RSVSESSIONSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RSVROOMROLE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVROOMROLE](
	[RSVROLESEQ] [int] NOT NULL,
	[RSVSESSIONSEQ] [int] NULL,
	[TARGETTYPECODE] [varchar](3) NULL,
	[GROUPSEQ] [int] NULL,
	[PINTREATRANGE] [varchar](20) NULL,
	[CITYTREATCODE] [varchar](3) NULL,
	[AGETREATCODE] [varchar](3) NULL,
	[PERIODTYPECODE] [varchar](3) NULL,
	[STARTMONTH] [varchar](6) NULL,
	[STARTDAY] [varchar](2) NULL,
	[ENDMONTH] [varchar](6) NULL,
	[ENDDAY] [varchar](2) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK시설_세션별_예약_자격_설정_정보] PRIMARY KEY CLUSTERED 
(
	[RSVROLESEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVROOMSESSIONINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVROOMSESSIONINFO](
	[ORDERNUMBER] [numeric](2, 0) NULL,
	[STARTDATETIME] [varchar](4) NULL,
	[ENDDATETIME] [varchar](4) NULL,
	[SESSIONNAME] [varchar](6) NULL,
	[PRICE] [numeric](10, 0) NULL,
	[DISCOUNTPRICE] [numeric](10, 0) NULL,
	[ROOMSEQ] [int] NOT NULL,
	[RSVSESSIONSEQ] [int] IDENTITY(1,1) NOT NULL,
	[SETTYPECODE] [varchar](3) NULL,
	[SETWEEK] [varchar](3) NULL,
	[SETDATE] [varchar](8) NULL,
	[WORKTYPECODE] [varchar](3) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
	[STATUSCODE] [varchar](3) NULL,
 CONSTRAINT [XPK시설_세션_정보] PRIMARY KEY CLUSTERED 
(
	[RSVSESSIONSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVROOMTYPEMAP]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RSVROOMTYPEMAP](
	[TYPESEQ] [int] NULL,
	[ROOMSEQ] [int] NULL,
	[SETTINGSEQ] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RSVSAMEROOMINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVSAMEROOMINFO](
	[SAMEROOMSEQ] [int] IDENTITY(1,1) NOT NULL,
	[IDENTIFY] [varchar](14) NOT NULL,
	[ROOMSEQ] [int] NOT NULL,
	[PARENTROOMSEQ] [int] NOT NULL,
 CONSTRAINT [PK__RSVSAMER__432EFBEA5399BF5A] PRIMARY KEY CLUSTERED 
(
	[SAMEROOMSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RSVSPECIALPPMAP]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RSVSPECIALPPMAP](
	[SPECIALPPSEQ] [int] IDENTITY(1,1) NOT NULL,
	[SETTINGSEQ] [int] NULL,
	[TYPESEQ] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SPECIALPPSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RSVTYPEINFO]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RSVTYPEINFO](
	[RSVTYPECODE] [varchar](3) NULL,
	[TYPESEQ] [int] IDENTITY(1,1) NOT NULL,
	[TYPENAME] [varchar](50) NULL,
	[STATUSCODE] [varchar](3) NULL,
	[RESERVATIONINFO] [varchar](2000) NULL,
	[INSERTUSER] [varchar](100) NULL,
	[INSERTDATE] [datetime] NULL,
	[UPDATEUSER] [varchar](100) NULL,
	[UPDATEDATE] [datetime] NULL,
 CONSTRAINT [XPK예약_형태_정보] PRIMARY KEY CLUSTERED 
(
	[TYPESEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SEARCHLMS]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SEARCHLMS](
	[COURSEID] [numeric](10, 0) NOT NULL,
	[GUBUN] [varchar](10) NOT NULL,
	[CATEGORYNAME] [varchar](100) NULL,
	[COURSENAME] [varchar](100) NULL,
	[COURSECONTENT] [varchar](1000) NULL,
	[DATETYPE] [varchar](20) NULL,
	[CREATEDATE] [datetime] NULL,
	[MODIFYDATE] [datetime] NULL,
	[ACADEMYURL] [varchar](1000) NULL,
	[HYBRISURL] [varchar](1000) NULL,
	[KEYWORD] [text] NULL,
	[STAMPNAME] [varchar](100) NULL,
	[STAMPCONDITION] [varchar](100) NULL,
	[HTMLTITLE] [text] NULL,
	[SUBTITLE] [text] NULL,
	[BODY] [text] NULL,
	[DELETEYN] [varchar](1) NULL,
 CONSTRAINT [PK_SEARCHLMS] PRIMARY KEY NONCLUSTERED 
(
	[COURSEID] ASC,
	[GUBUN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SEARCHRSV]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SEARCHRSV](
	[RSVSEQ] [int] NOT NULL,
	[GUBUN] [varchar](10) NOT NULL,
	[PPNAME] [varchar](100) NULL,
	[NAME] [varchar](100) NULL,
	[TYPE] [varchar](100) NULL,
	[CONTENT] [varchar](2000) NULL,
	[INTRO] [varchar](2000) NULL,
	[INFO] [varchar](2000) NULL,
	[CREATEDATE] [datetime] NULL,
	[MODIFYDATE] [datetime] NULL,
	[ACADEMYURL] [varchar](1000) NULL,
	[HYBRISURL] [varchar](1000) NULL,
	[KEYWORD] [text] NULL,
	[DELETEYN] [varchar](1) NULL,
 CONSTRAINT [PK_SEARCHRSV] PRIMARY KEY NONCLUSTERED 
(
	[RSVSEQ] ASC,
	[GUBUN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TARGETCODE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TARGETCODE](
	[TARGETSEQ] [int] NOT NULL,
	[TARGETMASTERSEQ] [varchar](20) NOT NULL,
	[TARGETCODESEQ] [varchar](20) NOT NULL,
	[TARGETCODENAME] [varchar](50) NULL,
	[TARGETCODEACCOUNT] [varchar](2000) NULL,
	[TARGETCODEORDER] [int] NULL,
	[USEYN] [char](1) NULL,
	[CASEONE] [varchar](50) NULL,
	[CASETWO] [varchar](50) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL,
 CONSTRAINT [PK_TARGETCODE] PRIMARY KEY NONCLUSTERED 
(
	[TARGETSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TARGETCODE_BACK]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TARGETCODE_BACK](
	[TARGETMASTERSEQ] [varchar](20) NOT NULL,
	[TARGETCODESEQ] [varchar](20) NOT NULL,
	[TARGETCODENAME] [varchar](50) NULL,
	[TARGETCODEACCOUNT] [varchar](2000) NULL,
	[TARGETCODEORDER] [int] NULL,
	[USEYN] [char](1) NULL,
	[CASEONE] [varchar](50) NULL,
	[CASETWO] [varchar](50) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TARGETMASTER]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TARGETMASTER](
	[TARGETMASTERSEQ] [varchar](20) NOT NULL,
	[TARGETMASTERNAME] [varchar](50) NULL,
	[TARGETMASTERACCOUNT] [varchar](2000) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL,
 CONSTRAINT [PK_TARGETMASTER] PRIMARY KEY NONCLUSTERED 
(
	[TARGETMASTERSEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TARGETRULE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TARGETRULE](
	[TARGETRULESEQ] [int] NOT NULL,
	[TARGETCODEGUBUN] [varchar](20) NULL,
	[TARGETRULENAME] [varchar](100) NULL,
	[RULEGUBUN] [varchar](20) NULL,
	[RULESCOPE] [varchar](20) NULL,
	[RULESTART] [varchar](50) NULL,
	[RULEEND] [varchar](50) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [datetime] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [datetime] NULL,
 CONSTRAINT [PK_TARGETRULE] PRIMARY KEY NONCLUSTERED 
(
	[TARGETRULESEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEEAGREEDELEG]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEEAGREEDELEG](
	[FISCALYEAR] [varchar](4) NOT NULL,
	[DELEGTYPECODE] [varchar](10) NOT NULL,
	[DELEGABO_NO] [varchar](12) NOT NULL,
	[DELEGATORABO_NO] [varchar](12) NOT NULL,
	[AGREEID] [numeric](5, 2) NULL,
	[AGREEFLAG] [varchar](1) NULL,
	[AGREEDATE] [date] NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[FISCALYEAR] ASC,
	[DELEGTYPECODE] ASC,
	[DELEGABO_NO] ASC,
	[DELEGATORABO_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEEAGREEMANAGE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEEAGREEMANAGE](
	[FISCALYEAR] [varchar](4) NOT NULL,
	[AGREEID] [numeric](5, 2) NOT NULL,
	[AGREETYPECODE] [varchar](10) NOT NULL,
	[DELEGTYPECODE] [varchar](10) NULL,
	[AGREETITLE] [varchar](300) NOT NULL,
	[AGREETEXT] [ntext] NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[FISCALYEAR] ASC,
	[AGREEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEEAGREEPLEDGE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEEAGREEPLEDGE](
	[FISCALYEAR] [varchar](4) NOT NULL,
	[AGREEID] [numeric](5, 2) NOT NULL,
	[DEPABO_NO] [varchar](12) NOT NULL,
	[AGREEFLAG] [varchar](1) NULL,
	[AGREEDATE] [date] NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[FISCALYEAR] ASC,
	[AGREEID] ASC,
	[DEPABO_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEEAGREESPECIAL]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEEAGREESPECIAL](
	[FISCALYEAR] [varchar](4) NOT NULL,
	[SPECIALID] [numeric](5, 2) NOT NULL,
	[ATTACHFILE] [varchar](12) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[FISCALYEAR] ASC,
	[SPECIALID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEEAGREETHIRDPERSON]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEEAGREETHIRDPERSON](
	[FISCALYEAR] [varchar](4) NOT NULL,
	[AGREEID] [numeric](5, 2) NOT NULL,
	[THIRDPERSON] [varchar](12) NOT NULL,
	[DEPABO_NO] [varchar](12) NOT NULL,
	[AGREEFLAG] [varchar](1) NULL,
	[AGREEDATE] [date] NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[FISCALYEAR] ASC,
	[AGREEID] ASC,
	[THIRDPERSON] ASC,
	[DEPABO_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEEGROUPCODE]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEEGROUPCODE](
	[GROUPCODE] [varchar](10) NOT NULL,
	[GROUPNAME] [varchar](300) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[GROUPCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEEPLAN]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEEPLAN](
	[GIVEYEAR] [varchar](4) NOT NULL,
	[GIVEMONTH] [varchar](2) NOT NULL,
	[PLANID] [numeric](2, 0) NOT NULL,
	[DEPABO_NO] [varchar](12) NOT NULL,
	[PLANTYPE] [varchar](10) NULL,
	[EDUTITLE] [varchar](300) NULL,
	[EDUKIND] [varchar](10) NULL,
	[PLACE] [varchar](300) NULL,
	[SPENDDT] [varchar](8) NULL,
	[LECTURENAME] [varchar](300) NULL,
	[PERSONCOUNT] [numeric](3, 0) NULL,
	[PLANCOUNT] [numeric](3, 0) NULL,
	[EDUDESC] [varchar](300) NULL,
	[PLANSTATUS] [varchar](2) NULL,
	[SPENDID] [numeric](2, 0) NULL,
	[GROUPCODE] [varchar](10) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[GIVEYEAR] ASC,
	[GIVEMONTH] ASC,
	[PLANID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEEPLANITEM]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEEPLANITEM](
	[GIVEYEAR] [varchar](4) NOT NULL,
	[GIVEMONTH] [varchar](2) NOT NULL,
	[PLANID] [numeric](2, 0) NOT NULL,
	[PLANITEMID] [numeric](2, 0) NOT NULL,
	[SPENDITEM] [varchar](10) NULL,
	[SPENDAMOUNT] [numeric](12, 0) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[GIVEYEAR] ASC,
	[GIVEMONTH] ASC,
	[PLANID] ASC,
	[PLANITEMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEEPLANITEMGROUP]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEEPLANITEMGROUP](
	[GIVEYEAR] [varchar](4) NOT NULL,
	[GIVEMONTH] [varchar](2) NOT NULL,
	[PLANID] [numeric](2, 0) NOT NULL,
	[PLANITEMID] [numeric](2, 0) NOT NULL,
	[DEPABO_NO] [varchar](12) NOT NULL,
	[SPENDITEM] [varchar](10) NULL,
	[SPENDAMOUNT] [numeric](12, 0) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[GIVEYEAR] ASC,
	[GIVEMONTH] ASC,
	[PLANID] ASC,
	[PLANITEMID] ASC,
	[DEPABO_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEERENT]    Script Date: 2016-08-24 오후 2:04:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEERENT](
	[FISCALYEAR] [varchar](4) NOT NULL,
	[DEPABO_NO] [varchar](12) NOT NULL,
	[RENTID] [numeric](3, 0) NOT NULL,
	[RENTTYPE] [varchar](10) NOT NULL,
	[RENTAMOUNT] [numeric](12, 0) NULL,
	[RENTDEPOSIT] [numeric](12, 0) NULL,
	[RENTTITLE] [varchar](2000) NULL,
	[RENTFROMMONTH] [varchar](6) NULL,
	[RENTTOMONTH] [varchar](6) NULL,
	[RENTSTATUS] [varchar](2) NULL,
	[ATTACHFILE] [varchar](10) NULL,
	[RENTREJECTTEXT] [varchar](2000) NULL,
	[RENTSMSTEXT] [varchar](2000) NULL,
	[GROUPCODE] [varchar](10) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
	[GIVEYEAR] [nvarchar](4) NULL,
	[GIVEMONTH] [varchar](2) NULL,
PRIMARY KEY CLUSTERED 
(
	[FISCALYEAR] ASC,
	[DEPABO_NO] ASC,
	[RENTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEERENTGROUP]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEERENTGROUP](
	[FISCALYEAR] [varchar](4) NOT NULL,
	[DEPABO_NO] [varchar](12) NOT NULL,
	[RENTID] [numeric](3, 0) NOT NULL,
	[RENTAMOUNT] [numeric](12, 0) NULL,
	[RENTDEPOSIT] [numeric](12, 0) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[FISCALYEAR] ASC,
	[DEPABO_NO] ASC,
	[RENTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEERENTPERSON]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEERENTPERSON](
	[FISCALYEAR] [varchar](4) NOT NULL,
	[DEPABO_NO] [varchar](12) NOT NULL,
	[RENTID] [numeric](3, 0) NOT NULL,
	[GIVEYEARMONTH] [varchar](6) NOT NULL,
	[RENTAMOUNT] [numeric](12, 0) NULL,
	[RENTDEPOSIT] [numeric](12, 0) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[FISCALYEAR] ASC,
	[DEPABO_NO] ASC,
	[RENTID] ASC,
	[GIVEYEARMONTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEESCHEDULE]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEESCHEDULE](
	[GIVEYEAR] [varchar](4) NOT NULL,
	[GIVEMONTH] [varchar](2) NOT NULL,
	[STARTDT] [varchar](8) NULL,
	[STARTTIME] [varchar](4) NULL,
	[ENDDT] [varchar](8) NULL,
	[ENDTIME] [varchar](4) NULL,
	[SMSSENDFLAG] [varchar](1) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[GIVEYEAR] ASC,
	[GIVEMONTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEESPEND]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEESPEND](
	[GIVEYEAR] [varchar](4) NOT NULL,
	[GIVEMONTH] [varchar](2) NOT NULL,
	[SPENDID] [numeric](4, 0) NOT NULL,
	[DEPABO_NO] [varchar](12) NOT NULL,
	[SPENDTYPE] [varchar](10) NOT NULL,
	[EDUTITLE] [varchar](300) NULL,
	[EDUKIND] [varchar](10) NULL,
	[PLACE] [varchar](300) NULL,
	[SPENDDT] [varchar](8) NULL,
	[LECTURENAME] [varchar](300) NULL,
	[PERSONCOUNT] [numeric](3, 0) NULL,
	[PLANCOUNT] [numeric](3, 0) NULL,
	[EDUDESC] [varchar](300) NULL,
	[SPENDSTATUS] [varchar](1) NULL,
	[SPENDCONFIRMFLAG] [varchar](1) NULL,
	[GROUPCODE] [varchar](10) NULL,
	[PLANID] [numeric](4, 0) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
	[SPENDCONFIRMDT] [varchar](8) NULL,
	[AS400UPLOADFALG] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[GIVEYEAR] ASC,
	[GIVEMONTH] ASC,
	[SPENDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEESPENDITEM]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEESPENDITEM](
	[GIVEYEAR] [varchar](4) NOT NULL,
	[GIVEMONTH] [varchar](2) NOT NULL,
	[SPENDID] [numeric](12, 0) NOT NULL,
	[SPENDITEMID] [numeric](12, 0) NOT NULL,
	[SPENDITEM] [varchar](10) NULL,
	[SPENDAMOUNT] [numeric](12, 0) NULL,
	[ATTACHFILE] [varchar](10) NULL,
	[CHECKFLAG] [varchar](1) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[GIVEYEAR] ASC,
	[GIVEMONTH] ASC,
	[SPENDID] ASC,
	[SPENDITEMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEESPENDITEMGROUP]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEESPENDITEMGROUP](
	[GIVEYEAR] [varchar](4) NOT NULL,
	[GIVEMONTH] [varchar](2) NOT NULL,
	[SPENDID] [numeric](12, 0) NOT NULL,
	[SPENDITEMID] [numeric](12, 0) NOT NULL,
	[DEPABO_NO] [varchar](12) NOT NULL,
	[SPENDITEM] [varchar](10) NULL,
	[SPENDAMOUNT] [numeric](12, 0) NULL,
	[SPENDCONFIRMFLAG] [varchar](1) NULL,
	[CHECKFLAG] [varchar](1) NULL,
	[ATTACHFILE] [varchar](10) NULL,
	[SPENDCONFIRMDT] [varchar](8) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[GIVEYEAR] ASC,
	[GIVEMONTH] ASC,
	[SPENDID] ASC,
	[SPENDITEMID] ASC,
	[DEPABO_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEESYSTEMLOG]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEESYSTEMLOG](
	[ABO_NO] [varchar](12) NOT NULL,
	[SYSTEMID] [numeric](12, 0) NOT NULL,
	[SYSTEMTYPE] [varchar](12) NULL,
	[EVENTID] [varchar](1) NULL,
	[SYSTEMTEXT] [varchar](2000) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[ABO_NO] ASC,
	[SYSTEMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEETARGETFULL]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEETARGETFULL](
	[ABO_NO] [varchar](12) NOT NULL,
	[CODE] [varchar](10) NULL,
	[BR] [varchar](10) NULL,
	[DEPARTMENT] [varchar](10) NULL,
	[REFERENCE] [varchar](2000) NULL,
	[GROUPCODE] [varchar](10) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
	[AUTHGROUP] [varchar](1) NULL,
	[AUTHPERSON] [varchar](1) NULL,
	[AUTHMANAGEFLAG] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[ABO_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TRFEETARGETMONTH]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TRFEETARGETMONTH](
	[GIVEYEAR] [varchar](4) NOT NULL,
	[GIVEMONTH] [varchar](2) NOT NULL,
	[ABO_NO] [varchar](12) NOT NULL,
	[CODE] [varchar](10) NULL,
	[BR] [varchar](10) NULL,
	[DEPARTMENT] [varchar](10) NULL,
	[SALES] [numeric](12, 0) NULL,
	[TRFEE] [numeric](12, 0) NULL,
	[GROUPCODE] [varchar](10) NULL,
	[AUTHGROUP] [varchar](1) NULL,
	[AUTHPERSON] [varchar](1) NULL,
	[AUTHMANAGEFLAG] [varchar](1) NULL,
	[DELEGTYPECODE] [varchar](10) NULL,
	[DEPABO_NO] [varchar](12) NULL,
	[DEPCODE] [varchar](10) NULL,
	[REJECTTEXT] [varchar](2000) NULL,
	[SMSTEXT] [varchar](2000) NULL,
	[PROCESSSTATUS] [varchar](2) NULL,
	[AS400UPLOADFALG] [varchar](1) NULL,
	[NOTE] [varchar](2000) NULL,
	[MODIFIER] [varchar](50) NULL,
	[MODIFYDATE] [date] NULL,
	[REGISTRANT] [varchar](50) NULL,
	[REGISTRANTDATE] [date] NULL,
	[PROCESSSTATUSDT] [varchar](8) NULL,
PRIMARY KEY CLUSTERED 
(
	[GIVEYEAR] ASC,
	[GIVEMONTH] ASC,
	[ABO_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[fn_aboinformation]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fn_aboinformation]
(
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT   ABO_NO
         , '홍길동' AS ABO_NAME
         , '' AS HPIN
         , '' AS HPINNAME
				 , '' AS CPIN
         , '' AS CPINNAME
         , '' AS LOA
				 , '' AS LOAKOR
				 , '' AS LOAENG
				 , '' AS CUPDIA
				 , '' AS CUPDIANAME
    FROM   DBO.TRFEETARGETFULL
)

GO
/****** Object:  UserDefinedFunction [dbo].[fn_aboinformation2]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fn_aboinformation2]
(
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT   ABO_NO
         , '홍길동' AS ABO_NAME
		 , '홍길동' AS ABO_NAME1
         , '' AS HPIN
         , '' AS HPINNAME
				 , '' AS CPIN
         , '' AS CPINNAME
         , '' AS LOA
				 , '' AS LOAKOR
				 , '' AS LOAENG
				 , '' AS CUPDIA
				 , '' AS CUPDIANAME
    FROM   DBO.TRFEETARGETFULL
)

GO
/****** Object:  View [dbo].[V_TRFEETARGET]    Script Date: 2016-08-24 오후 2:04:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_TRFEETARGET]
AS
SELECT   A.GIVEYEAR
       , A.GIVEMONTH
       , A.DEPABO_NO
       , C.NAME AS DEPABONAME
       , A.DEPCODE
       , A.CODE
       , A.BR
       , A.DEPARTMENT
       , A.GROUPCODE
       , C.GROUPS
       , C.HIGHESTACHIEVE
       , C.LOANAMEKOR
       , C.LOANAMEENG
       , C.QUALIFYDIA
       , A.AUTHGROUP
       , A.AUTHPERSON
       , A.AUTHMANAGEFLAG
       , A.DELEGTYPECODE
       , SUM(A.TRFEE) AS TRFEE
       , A.NOTE
       , A.PROCESSSTATUS
       , A.PROCESSSTATUSDT
       , A.REJECTTEXT
 FROM   DBO.TRFEETARGETMONTH A
 JOIN   DBO.TRFEETARGETMONTH B on A.GIVEYEAR = B.GIVEYEAR
                               and A.GIVEMONTH = B.GIVEMONTH
                               and A.ABO_NO = B.DEPABO_NO
 JOIN   DBO.MEMBER C ON C.UID = A.DEPABO_NO
GROUP BY A.GIVEYEAR
       , A.GIVEMONTH
       , A.DEPABO_NO
       , C.NAME
       , A.DEPCODE
       , A.CODE
       , A.BR
       , A.DEPARTMENT
       , A.GROUPCODE
       , C.GROUPS
       , C.HIGHESTACHIEVE
       , C.LOANAMEKOR
       , C.LOANAMEENG
       , C.QUALIFYDIA
       , A.AUTHGROUP
       , A.AUTHPERSON
       , A.AUTHMANAGEFLAG
       , A.DELEGTYPECODE
       , A.NOTE
       , A.PROCESSSTATUS
       , A.PROCESSSTATUSDT
       , A.REJECTTEXT
GO
ALTER TABLE [dbo].[COMMONCODE] ADD  DEFAULT (NULL) FOR [CODENAME]
GO
ALTER TABLE [dbo].[COMMONCODE] ADD  DEFAULT (NULL) FOR [CODEACCOUNT]
GO
ALTER TABLE [dbo].[COMMONCODE] ADD  DEFAULT (NULL) FOR [CODEORDER]
GO
ALTER TABLE [dbo].[COMMONCODE] ADD  DEFAULT (NULL) FOR [USEYN]
GO
ALTER TABLE [dbo].[COMMONCODE] ADD  DEFAULT (NULL) FOR [CASEONE]
GO
ALTER TABLE [dbo].[COMMONCODE] ADD  DEFAULT (NULL) FOR [CASETWO]
GO
ALTER TABLE [dbo].[COMMONCODE] ADD  DEFAULT (NULL) FOR [MODIFIER]
GO
ALTER TABLE [dbo].[COMMONCODE] ADD  DEFAULT (NULL) FOR [MODIFYDATE]
GO
ALTER TABLE [dbo].[COMMONCODE] ADD  DEFAULT (NULL) FOR [REGISTRANT]
GO
ALTER TABLE [dbo].[COMMONCODE] ADD  DEFAULT (NULL) FOR [REGISTRANTDATE]
GO
ALTER TABLE [dbo].[SEARCHLMS] ADD  DEFAULT (NULL) FOR [DELETEYN]
GO
ALTER TABLE [dbo].[TRFEEAGREEMANAGE] ADD  DEFAULT ('0') FOR [DELEGTYPECODE]
GO
ALTER TABLE [dbo].[LMSAGREE]  WITH CHECK ADD FOREIGN KEY([CATEGORYID])
REFERENCES [dbo].[LMSCATEGORY] ([CATEGORYID])
GO
ALTER TABLE [dbo].[LMSAGREE]  WITH CHECK ADD FOREIGN KEY([UID])
REFERENCES [dbo].[MEMBER] ([UID])
GO
ALTER TABLE [dbo].[LMSCONNECTLOG]  WITH CHECK ADD FOREIGN KEY([UID])
REFERENCES [dbo].[MEMBER] ([UID])
GO
ALTER TABLE [dbo].[LMSCOURSE]  WITH CHECK ADD FOREIGN KEY([CATEGORYID])
REFERENCES [dbo].[LMSCATEGORY] ([CATEGORYID])
GO
ALTER TABLE [dbo].[LMSCOURSECONDITION]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSDATA]  WITH CHECK ADD  CONSTRAINT [FK__LMSDATA__COURSEI__16EE5E27] FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSDATA] CHECK CONSTRAINT [FK__LMSDATA__COURSEI__16EE5E27]
GO
ALTER TABLE [dbo].[LMSLIVE]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSOFFLINE]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSONLINE]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSPENALTY]  WITH CHECK ADD FOREIGN KEY([COURSEID], [UID])
REFERENCES [dbo].[LMSSTUDENT] ([COURSEID], [UID])
GO
ALTER TABLE [dbo].[LMSPENALTY]  WITH CHECK ADD FOREIGN KEY([UID])
REFERENCES [dbo].[MEMBER] ([UID])
GO
ALTER TABLE [dbo].[LMSREGULAR]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSSAVELOG]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSSAVELOG]  WITH CHECK ADD FOREIGN KEY([UID])
REFERENCES [dbo].[MEMBER] ([UID])
GO
ALTER TABLE [dbo].[LMSSEAT]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSSEATSTUDENT]  WITH CHECK ADD FOREIGN KEY([COURSEID], [UID])
REFERENCES [dbo].[LMSSTUDENT] ([COURSEID], [UID])
GO
ALTER TABLE [dbo].[LMSSEATSTUDENT]  WITH CHECK ADD FOREIGN KEY([COURSEID], [SEATSEQ])
REFERENCES [dbo].[LMSSEAT] ([COURSEID], [SEATSEQ])
GO
ALTER TABLE [dbo].[LMSSTAMPGOAL]  WITH CHECK ADD FOREIGN KEY([UID])
REFERENCES [dbo].[MEMBER] ([UID])
GO
ALTER TABLE [dbo].[LMSSTAMPOBTAIN]  WITH CHECK ADD FOREIGN KEY([STAMPID])
REFERENCES [dbo].[LMSSTAMP] ([STAMPID])
GO
ALTER TABLE [dbo].[LMSSTAMPOBTAIN]  WITH CHECK ADD FOREIGN KEY([UID])
REFERENCES [dbo].[MEMBER] ([UID])
GO
ALTER TABLE [dbo].[LMSSTEP]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSSTEPFINISH]  WITH CHECK ADD FOREIGN KEY([COURSEID], [STEPSEQ])
REFERENCES [dbo].[LMSSTEP] ([COURSEID], [STEPSEQ])
GO
ALTER TABLE [dbo].[LMSSTEPFINISH]  WITH CHECK ADD FOREIGN KEY([COURSEID], [UID])
REFERENCES [dbo].[LMSSTUDENT] ([COURSEID], [UID])
GO
ALTER TABLE [dbo].[LMSSTEPUNIT]  WITH CHECK ADD FOREIGN KEY([COURSEID], [STEPSEQ])
REFERENCES [dbo].[LMSSTEP] ([COURSEID], [STEPSEQ])
GO
ALTER TABLE [dbo].[LMSSTUDENT]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSSTUDENT]  WITH CHECK ADD FOREIGN KEY([UID])
REFERENCES [dbo].[MEMBER] ([UID])
GO
ALTER TABLE [dbo].[LMSSUBSCRIBE]  WITH CHECK ADD FOREIGN KEY([CATEGORYID])
REFERENCES [dbo].[LMSCATEGORY] ([CATEGORYID])
GO
ALTER TABLE [dbo].[LMSSUBSCRIBE]  WITH CHECK ADD FOREIGN KEY([UID])
REFERENCES [dbo].[MEMBER] ([UID])
GO
ALTER TABLE [dbo].[LMSSURVEY]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSSURVEYOPINION]  WITH CHECK ADD FOREIGN KEY([COURSEID], [SURVEYSEQ], [UID])
REFERENCES [dbo].[LMSSURVEYRESPONSE] ([COURSEID], [SURVEYSEQ], [UID])
GO
ALTER TABLE [dbo].[LMSSURVEYRESPONSE]  WITH CHECK ADD FOREIGN KEY([COURSEID], [SURVEYSEQ])
REFERENCES [dbo].[LMSSURVEY] ([COURSEID], [SURVEYSEQ])
GO
ALTER TABLE [dbo].[LMSSURVEYRESPONSE]  WITH CHECK ADD FOREIGN KEY([COURSEID], [UID])
REFERENCES [dbo].[LMSSTUDENT] ([COURSEID], [UID])
GO
ALTER TABLE [dbo].[LMSSURVEYSAMPLE]  WITH CHECK ADD FOREIGN KEY([COURSEID], [SURVEYSEQ])
REFERENCES [dbo].[LMSSURVEY] ([COURSEID], [SURVEYSEQ])
GO
ALTER TABLE [dbo].[LMSTEST]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSTESTANSWER]  WITH CHECK ADD FOREIGN KEY([TESTPOOLID])
REFERENCES [dbo].[LMSTESTPOOL] ([TESTPOOLID])
GO
ALTER TABLE [dbo].[LMSTESTANSWER]  WITH CHECK ADD FOREIGN KEY([COURSEID], [UID])
REFERENCES [dbo].[LMSSTUDENT] ([COURSEID], [UID])
GO
ALTER TABLE [dbo].[LMSTESTPOOL]  WITH CHECK ADD FOREIGN KEY([CATEGORYID])
REFERENCES [dbo].[LMSCATEGORY] ([CATEGORYID])
GO
ALTER TABLE [dbo].[LMSTESTPOOLANSWER]  WITH CHECK ADD FOREIGN KEY([TESTPOOLID])
REFERENCES [dbo].[LMSTESTPOOL] ([TESTPOOLID])
GO
ALTER TABLE [dbo].[LMSTESTSUBMIT]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSTEST] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSVIEWLOG]  WITH CHECK ADD FOREIGN KEY([COURSEID])
REFERENCES [dbo].[LMSCOURSE] ([COURSEID])
GO
ALTER TABLE [dbo].[LMSVIEWLOG]  WITH CHECK ADD FOREIGN KEY([UID])
REFERENCES [dbo].[MEMBER] ([UID])
GO
ALTER TABLE [dbo].[RSVDETAILCODE]  WITH CHECK ADD  CONSTRAINT [R_142] FOREIGN KEY([MASTERCODE])
REFERENCES [dbo].[RSVMASTERCODE] ([MASTERCODE])
GO
ALTER TABLE [dbo].[RSVDETAILCODE] CHECK CONSTRAINT [R_142]
GO
ALTER TABLE [dbo].[RSVEXPINFO]  WITH CHECK ADD  CONSTRAINT [R_119] FOREIGN KEY([PPSEQ])
REFERENCES [dbo].[RSVPPINFO] ([PPSEQ])
GO
ALTER TABLE [dbo].[RSVEXPINFO] CHECK CONSTRAINT [R_119]
GO
ALTER TABLE [dbo].[RSVEXPPENALTYMAP]  WITH CHECK ADD  CONSTRAINT [R_145] FOREIGN KEY([PENALTYSEQ])
REFERENCES [dbo].[RSVPENALTYSETTING] ([PENALTYSEQ])
GO
ALTER TABLE [dbo].[RSVEXPPENALTYMAP] CHECK CONSTRAINT [R_145]
GO
ALTER TABLE [dbo].[RSVPENALTYHISTORY]  WITH CHECK ADD  CONSTRAINT [R_148] FOREIGN KEY([PENALTYSEQ])
REFERENCES [dbo].[RSVPENALTYSETTING] ([PENALTYSEQ])
GO
ALTER TABLE [dbo].[RSVPENALTYHISTORY] CHECK CONSTRAINT [R_148]
GO
ALTER TABLE [dbo].[RSVPPHISTORY]  WITH CHECK ADD  CONSTRAINT [R_105] FOREIGN KEY([PPSEQ])
REFERENCES [dbo].[RSVPPINFO] ([PPSEQ])
GO
ALTER TABLE [dbo].[RSVPPHISTORY] CHECK CONSTRAINT [R_105]
GO
ALTER TABLE [dbo].[RSVROLETARGET]  WITH CHECK ADD  CONSTRAINT [R_117] FOREIGN KEY([GROUPSEQ])
REFERENCES [dbo].[RSVROLEGROUP] ([GROUPSEQ])
GO
ALTER TABLE [dbo].[RSVROLETARGET] CHECK CONSTRAINT [R_117]
GO
ALTER TABLE [dbo].[RSVROOMINFO]  WITH CHECK ADD  CONSTRAINT [R_95] FOREIGN KEY([PPSEQ])
REFERENCES [dbo].[RSVPPINFO] ([PPSEQ])
GO
ALTER TABLE [dbo].[RSVROOMINFO] CHECK CONSTRAINT [R_95]
GO
ALTER TABLE [dbo].[RSVROOMPENALTYMAP]  WITH CHECK ADD  CONSTRAINT [R_143] FOREIGN KEY([PENALTYSEQ])
REFERENCES [dbo].[RSVPENALTYSETTING] ([PENALTYSEQ])
GO
ALTER TABLE [dbo].[RSVROOMPENALTYMAP] CHECK CONSTRAINT [R_143]
GO
ALTER TABLE [dbo].[RSVSPECIALPPMAP]  WITH CHECK ADD  CONSTRAINT [FK_SPECIALPPMAP_TO_TYPESEQ] FOREIGN KEY([TYPESEQ])
REFERENCES [dbo].[RSVTYPEINFO] ([TYPESEQ])
GO
ALTER TABLE [dbo].[RSVSPECIALPPMAP] CHECK CONSTRAINT [FK_SPECIALPPMAP_TO_TYPESEQ]
GO
ALTER TABLE [dbo].[TARGETCODE]  WITH CHECK ADD  CONSTRAINT [FK_TARGETMASTER_TO_TARGETCODE] FOREIGN KEY([TARGETMASTERSEQ])
REFERENCES [dbo].[TARGETMASTER] ([TARGETMASTERSEQ])
GO
ALTER TABLE [dbo].[TARGETCODE] CHECK CONSTRAINT [FK_TARGETMASTER_TO_TARGETCODE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업무구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'WORK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'통합파일키' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'FILEKEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'통합파일업로드아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'UPLOADSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실제파일명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'REALFILENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'저장파일명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'STOREFILENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일풀URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'FILEFULLURL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일확장자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'FILEEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업로드파일관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILEMANAGEMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSAGREE', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'분류번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSAGREE', @level2type=N'COLUMN',@level2name=N'CATEGORYID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'저작권동의일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSAGREE', @level2type=N'COLUMN',@level2name=N'AGREEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'저작권동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSAGREE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'분류번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'CATEGORYID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정구분코드 O온라인과정 F오프라인과정 D교육자료 L라이브과정 R정규과정 V설문 T시험' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'CATEGORYTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'분류명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'CATEGORYNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'분류코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'CATEGORYCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'상위분류번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'CATEGORYUPID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'분류레벨(1~5)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'CATEGORYLEVEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'공개여부 Y.공개 N.비공개' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'OPENFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'규정준수(COMPLIANCE)여부 Y적용, N비적용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'COMPLIANCEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'저작권동의여부 Y적용, N비적용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'COPYRIGHTFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'등록일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'하이브리스메뉴' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'HYBRISMENU'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'분류순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'CATEGORYORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'사용상태 Y사용 N삭제' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY', @level2type=N'COLUMN',@level2name=N'USEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육분류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCATEGORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCONNECTLOG', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'접속일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCONNECTLOG', @level2type=N'COLUMN',@level2name=N'CONNECTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'최초접속일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCONNECTLOG', @level2type=N'COLUMN',@level2name=N'REGULARDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'개근주(1주부터 쌓임)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCONNECTLOG', @level2type=N'COLUMN',@level2name=N'REGULARWEEKCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'접속로그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCONNECTLOG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'분류번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'CATEGORYID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정구분코드 O온라인과정 F오프라인과정 D교육자료 L라이브과정 R정규과정 V설문 T시험' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'COURSETYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'COURSENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정테마명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'THEMENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정테마번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'THEMESEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'공개여부 Y.공개 N.비공개 C:정규과정 공개' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'OPENFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육신청시작일시 YYYY.MM.DD HH24:MI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'REQUESTSTARTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육신청종료일시 YYYY.MM.DD HH24:MI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'REQUESTENDDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육시작일시 YYYY.MM.DD HH24:MI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'STARTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육종료일시 YYYY.MM.DD HH24:MI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'ENDDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'등록일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'COURSECONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'자료유형 M동영상 S오디어 F문서 L링크 I이미지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'DATATYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'시청시간(시:분:초)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'PLAYTIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'대표이미지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'COURSEIMAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'대표이미지설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'COURSEIMAGENOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'SNS공유설정 Y공유 N비공유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'SNSFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'그룹방적용여부 Y적용 N비적용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'GROUPFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'사용상태 Y사용 N삭제' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'USEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'신청대상' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'TARGET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'검색어' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'SEARCHWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육신청취소일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'CANCELTERM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'좋아요횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'LIKECOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'조회수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE', @level2type=N'COLUMN',@level2name=N'VIEWCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육과정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'조회구분 1노출 2신청 3추천' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'CONDITIONTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'CONDITIONSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원타입코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'ABOTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원타입ABOVE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'ABOTYPEABOVE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'핀레벨조건코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'PINCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'핀레벨UNDER' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'PINUNDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'핀레벨ABOVE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'PINABOVE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'보너스레벨조건코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'BONUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'보너스레벨UNDER' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'BONUSUNDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'보너스레벨ABOVE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'BONUSABOVE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'나이조건코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'AGECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'나이UNDER' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'AGEUNDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'나이ABOVE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'AGEABOVE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'LOA그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'LOACODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'다이아그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'DIACODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'다운라인구매여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'CUSTOMERCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'6개월주문횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'CONSECUTIVECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'비즈니스상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'BUSINESSSTATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'대상자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'TARGETCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'대상자직접입력' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'TARGETMEMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'조회시작일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'STARTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'조회종료일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION', @level2type=N'COLUMN',@level2name=N'ENDDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정조회조건' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSCOURSECONDITION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSDATA', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'PC링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSDATA', @level2type=N'COLUMN',@level2name=N'PCLINK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'모바일링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSDATA', @level2type=N'COLUMN',@level2name=N'MOBILELINK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'파일링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSDATA', @level2type=N'COLUMN',@level2name=N'FILELINK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'파일다운로드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSDATA', @level2type=N'COLUMN',@level2name=N'FILEDOWN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육자료상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSDATA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'라이브링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'LIVELINK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'재방송링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'LIVEREPLAYLINK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'재방송시작일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'REPLAYSTART'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'재방송종료일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'REPLAYEND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'TARGETDETAIL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'TARGETDETAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'NOTE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'NOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'링크제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'LINKTITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'링크주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'LINKURL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'페널티설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'PENALTYNOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'정원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'LIMITCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'취소허용기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE', @level2type=N'COLUMN',@level2name=N'CANCELTERM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'라이브상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLIVE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'로그번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLOG', @level2type=N'COLUMN',@level2name=N'LOGID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'로그구분 E엑셀로그 S메시지로그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLOG', @level2type=N'COLUMN',@level2name=N'LOGTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'작업구분 1.이용권한 2.수강생 3.좌석등록 4.주관식점수 5.문제은행 7.VIP좌석 8. 일반좌석 8.교육안내' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLOG', @level2type=N'COLUMN',@level2name=N'WORKTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'등록일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLOG', @level2type=N'COLUMN',@level2name=N'REGISRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLOG', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'성공갯수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLOG', @level2type=N'COLUMN',@level2name=N'SUCCESSCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'실패갯수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLOG', @level2type=N'COLUMN',@level2name=N'FAILCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLOG', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'로그내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLOG', @level2type=N'COLUMN',@level2name=N'LOGCONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육로그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSLOG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'현장접수여부 Y허용 N불허' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'PLACEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'동반자허용여부  Y허용 N불허' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'TOGETHERFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'페널티적용여부 Y적용 N비적용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'PENALTYFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'페널티기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'PENALTYTERM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육장번호 0 직접입력' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'APSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육장명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'APNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'강의실번호 0 직접입력' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'ROOMSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'강의실명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'ROOMNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'정원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'LIMITCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'상세정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'DETAILCONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'신청대상상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'TARGETDETAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'유의사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'NOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'링크제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'LINKTITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'링크주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'LINKURL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'취소허용기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE', @level2type=N'COLUMN',@level2name=N'CANCELTERM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'오프라인상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSOFFLINE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSONLINE', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'액티비티ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSONLINE', @level2type=N'COLUMN',@level2name=N'ACTIVITYID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'코스코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSONLINE', @level2type=N'COLUMN',@level2name=N'ACTIVITYCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'온라인상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSONLINE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSPENALTY', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSPENALTY', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'페널티등록일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSPENALTY', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'페널티해제일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSPENALTY', @level2type=N'COLUMN',@level2name=N'CLEARDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'페널티해제사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSPENALTY', @level2type=N'COLUMN',@level2name=N'CLEARNOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'페널티상태 Y적용 N해제' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSPENALTY', @level2type=N'COLUMN',@level2name=N'PENALTYFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'페널티' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSPENALTY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수료단계수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'STEPCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'동반자허용여부  Y허용 N불허' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'TOGETHERFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'스탬프적용여부 Y적용 N비적용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'STAMPFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'스탬프번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'STAMPID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'정원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'LIMITCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'신청대상상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'TARGETDETAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'유의사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'NOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수료기준' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'PASSNOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'링크제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'LINKTITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'링크주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'LINKURL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'취소허용기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR', @level2type=N'COLUMN',@level2name=N'CANCELTERM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'정규상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSREGULAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSAVELOG', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSAVELOG', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'저장구분 1최근본콘텐츠 2보관함 3GLMS동의' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSAVELOG', @level2type=N'COLUMN',@level2name=N'SAVETYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'저장일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSAVELOG', @level2type=N'COLUMN',@level2name=N'SAVEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'저장로그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSAVELOG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEAT', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'좌석일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEAT', @level2type=N'COLUMN',@level2name=N'SEATSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'좌석등급 V. VIP N.일반' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEAT', @level2type=N'COLUMN',@level2name=N'SEATTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'좌석번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEAT', @level2type=N'COLUMN',@level2name=N'SEATNUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'좌석사용여부 Y사용 N비사용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEAT', @level2type=N'COLUMN',@level2name=N'SEATUSEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'좌석' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEAT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEATSTUDENT', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEATSTUDENT', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'좌석일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEATSTUDENT', @level2type=N'COLUMN',@level2name=N'SEATSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'등록일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEATSTUDENT', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육수강생좌석' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSEATSTUDENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스탬프번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'STAMPID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스탬프구분 N일반 C정규과정 U개인목표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'STAMPTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스탬프명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'STAMPNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스탬프조건' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'STAMPCONDITION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스탬프내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'STAMPCONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용상태 Y사용 N삭제' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'USEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기본이미지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'OFFIMAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'달성이미지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'ONIMAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기본이미지설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'OFFIMAGENOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'달성이미지설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'ONIMAGENOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핀레벨코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'PINCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보너스레벨코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP', @level2type=N'COLUMN',@level2name=N'BONUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스탬프' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPGOAL', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'목표번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPGOAL', @level2type=N'COLUMN',@level2name=N'GOALSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'목표핀레벨코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPGOAL', @level2type=N'COLUMN',@level2name=N'PINCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'목표보너스레벨코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPGOAL', @level2type=N'COLUMN',@level2name=N'BONUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'목표기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPGOAL', @level2type=N'COLUMN',@level2name=N'GOALTERM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'목표등록일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPGOAL', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'스탬프목표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPGOAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPOBTAIN', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'스탬프번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPOBTAIN', @level2type=N'COLUMN',@level2name=N'STAMPID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPOBTAIN', @level2type=N'COLUMN',@level2name=N'OBTAINSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'스탬프취득일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPOBTAIN', @level2type=N'COLUMN',@level2name=N'OBTAINDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호(정규과정)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPOBTAIN', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'스탬프획득' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTAMPOBTAIN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEP', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'단계번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEP', @level2type=N'COLUMN',@level2name=N'STEPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'단계명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEP', @level2type=N'COLUMN',@level2name=N'STEPNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEP', @level2type=N'COLUMN',@level2name=N'STEPORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수료과정수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEP', @level2type=N'COLUMN',@level2name=N'STEPCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'필수여부 Y필수 N선택' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEP', @level2type=N'COLUMN',@level2name=N'MUSTFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정단계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPFINISH', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'단계번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPFINISH', @level2type=N'COLUMN',@level2name=N'STEPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPFINISH', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수료여부 Y수료 N미수료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPFINISH', @level2type=N'COLUMN',@level2name=N'FINISHFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정단계수료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPFINISH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPUNIT', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'단계번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPUNIT', @level2type=N'COLUMN',@level2name=N'STEPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'구성과정번호 (과정번호)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPUNIT', @level2type=N'COLUMN',@level2name=N'STEPCOURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'필수여부 Y필수 N선' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPUNIT', @level2type=N'COLUMN',@level2name=N'MUSTFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPUNIT', @level2type=N'COLUMN',@level2name=N'UNITORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정구성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTEPUNIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수강신청여부 Y신청 N미신청' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'REQUESTFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수강신청일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'REQUESTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수강취소일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'CANCELDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수강취소사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'CANCELNOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'동반신청여부 Y신청 N미신청' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'TOGETHERREQUESTFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'핀레벨(코드이용)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'PINCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수강신청채널 O온라인 M매뉴얼 D현장등록' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'REQUESTCHANNEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'학습(시험)시작여부 Y시작 N미시작' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'STUDYFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'학습(시험)시작일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'STUDYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'출석구분 C바코드 M매뉴얼' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'ATTENDFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수료여부 Y수료 N미수료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'FINISHFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수료일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'FINISHDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'주관식점수(숫자없으면 입력한것 아님)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'SUBJECTPOINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'객관식점수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT', @level2type=N'COLUMN',@level2name=N'OBJECTPOINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육수강생' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSTUDENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSUBSCRIBE', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'분류번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSUBSCRIBE', @level2type=N'COLUMN',@level2name=N'CATEGORYID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'구독신청일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSUBSCRIBE', @level2type=N'COLUMN',@level2name=N'SUBSCRIBEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'구독신청' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSUBSCRIBE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEY', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문항번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEY', @level2type=N'COLUMN',@level2name=N'SURVEYSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'질문' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEY', @level2type=N'COLUMN',@level2name=N'SURVEYNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'답변유형 1선일형 2선다형 3단답형 4서술형' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEY', @level2type=N'COLUMN',@level2name=N'SURVEYTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'설문상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYOPINION', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문항번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYOPINION', @level2type=N'COLUMN',@level2name=N'SURVEYSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYOPINION', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'입력번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYOPINION', @level2type=N'COLUMN',@level2name=N'OPINIONSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'입력의견' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYOPINION', @level2type=N'COLUMN',@level2name=N'OPINIONCONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'설문응답의견' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYOPINION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYRESPONSE', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문항번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYRESPONSE', @level2type=N'COLUMN',@level2name=N'SURVEYSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYRESPONSE', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'답변내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYRESPONSE', @level2type=N'COLUMN',@level2name=N'SUBJECTRESPONSE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'설문응답' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYRESPONSE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYSAMPLE', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문항번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYSAMPLE', @level2type=N'COLUMN',@level2name=N'SURVEYSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'답변번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYSAMPLE', @level2type=N'COLUMN',@level2name=N'SAMPLESEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'답변' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYSAMPLE', @level2type=N'COLUMN',@level2name=N'SAMPLENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'척도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYSAMPLE', @level2type=N'COLUMN',@level2name=N'SAMPLEVALUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'직접입력여부 Y예 N아니오' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYSAMPLE', @level2type=N'COLUMN',@level2name=N'DIRECTYN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'설문답변' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSSURVEYSAMPLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTEST', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제한시간(분)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTEST', @level2type=N'COLUMN',@level2name=N'LIMITTIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'합격점수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTEST', @level2type=N'COLUMN',@level2name=N'PASSPOINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시험구분 O온라인시험 F오프라인시험' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTEST', @level2type=N'COLUMN',@level2name=N'TESTTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTANSWER', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTANSWER', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'응시번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTANSWER', @level2type=N'COLUMN',@level2name=N'ANSWERSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문제번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTANSWER', @level2type=N'COLUMN',@level2name=N'TESTPOOLID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'배점' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTANSWER', @level2type=N'COLUMN',@level2name=N'TESTPOOLPOINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'답변' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTANSWER', @level2type=N'COLUMN',@level2name=N'SUBJECTANSWER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'점수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTANSWER', @level2type=N'COLUMN',@level2name=N'POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'시험응시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTANSWER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문제번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOL', @level2type=N'COLUMN',@level2name=N'TESTPOOLID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'분류번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOL', @level2type=N'COLUMN',@level2name=N'CATEGORYID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'질문' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOL', @level2type=N'COLUMN',@level2name=N'TESTPOOLNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'지문' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOL', @level2type=N'COLUMN',@level2name=N'TESTPOOLNOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'답변유형 1선일형 2선다형 3.주관식' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOL', @level2type=N'COLUMN',@level2name=N'ANSWERTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'정답' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOL', @level2type=N'COLUMN',@level2name=N'OBJECTANSWER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'사용상태 Y사용 N삭제 S중지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOL', @level2type=N'COLUMN',@level2name=N'USEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'참고이미지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOL', @level2type=N'COLUMN',@level2name=N'TESTPOOLIMAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문제이미지설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOL', @level2type=N'COLUMN',@level2name=N'TESTPOOLIMAGENOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문제' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문제번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOLANSWER', @level2type=N'COLUMN',@level2name=N'TESTPOOLID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'답변번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOLANSWER', @level2type=N'COLUMN',@level2name=N'TESTPOOLANSWERSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'답변' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOLANSWER', @level2type=N'COLUMN',@level2name=N'TESTPOOLANSWERNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문제답변' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTPOOLANSWER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTSUBMIT', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'출제번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTSUBMIT', @level2type=N'COLUMN',@level2name=N'SUBMITSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문제수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTSUBMIT', @level2type=N'COLUMN',@level2name=N'TESTCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'문제별점수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTSUBMIT', @level2type=N'COLUMN',@level2name=N'TESTPOINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'답변유형 1선일형 2선다형 3주관식' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTSUBMIT', @level2type=N'COLUMN',@level2name=N'ANSWERTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'시험문제출제' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSTESTSUBMIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'과정번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSVIEWLOG', @level2type=N'COLUMN',@level2name=N'COURSEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'조회구분 1 SNS공유, 2좋아요, 3조회' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSVIEWLOG', @level2type=N'COLUMN',@level2name=N'VIEWTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'조회월  YYYY-MM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSVIEWLOG', @level2type=N'COLUMN',@level2name=N'VIEWMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSVIEWLOG', @level2type=N'COLUMN',@level2name=N'UID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'조회수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSVIEWLOG', @level2type=N'COLUMN',@level2name=N'VIEWCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'조회로그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LMSVIEWLOG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'맵핑 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMAP', @level2type=N'COLUMN',@level2name=N'MAPPINGSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역군 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMAP', @level2type=N'COLUMN',@level2name=N'CITYGROUPCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행정구역 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMAP', @level2type=N'COLUMN',@level2name=N'REGIONCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시군구 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMAP', @level2type=N'COLUMN',@level2name=N'CITYCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역군 맵핑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMAP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역군 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMASTER', @level2type=N'COLUMN',@level2name=N'CITYGROUPCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역군명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMASTER', @level2type=N'COLUMN',@level2name=N'CITYGROUPNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최종수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMASTER', @level2type=N'COLUMN',@level2name=N'MODIFYDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최종수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMASTER', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMASTER', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMASTER', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMASTER', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMASTER', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역군 마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYGROUPMASTER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행정구역 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYINFO', @level2type=N'COLUMN',@level2name=N'REGIONCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시군구 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYINFO', @level2type=N'COLUMN',@level2name=N'CITYCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시군구 지역 이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYINFO', @level2type=N'COLUMN',@level2name=N'CITYNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시군구 지역 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCITYINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEHISTORY', @level2type=N'COLUMN',@level2name=N'CLAUSESEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관 동의 일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEHISTORY', @level2type=N'COLUMN',@level2name=N'AGREEDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관 동의 여부 코드[YN9]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEHISTORY', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회원일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEHISTORY', @level2type=N'COLUMN',@level2name=N'MEMBERNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관 동의 이력 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEHISTORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO', @level2type=N'COLUMN',@level2name=N'CLAUSESEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관 내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO', @level2type=N'COLUMN',@level2name=N'CONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관 제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관 타입 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO', @level2type=N'COLUMN',@level2name=N'TYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'필수 여부 코드[CL1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO', @level2type=N'COLUMN',@level2name=N'MANDATORYCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관 버전' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO', @level2type=N'COLUMN',@level2name=N'VERSION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCLAUSEINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'누적 예약 설정 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'SETTINGSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제한 기준 타입 코' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'CONSTRAINTTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자격 PIN 구간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'PINTREATRANGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역 우대 여부 [YN9]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'CITYTREATCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'나이 우대 여부 [YN9]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'AGETREATCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전국일별가능횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'GLOBALDAILYCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전국주별가능횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'GLOBALWEEKLYCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전국월별가능횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'GLOBALMONTHLYCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PP의 일별 가능횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'PPDAILYCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PP의 주별 가능횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'PPWEEKLYCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PP의 월별 가능횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'PPMONTHLYCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'누적 예약 횟수 제한 설정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVCONSTRAINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 정보 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'EXPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육장 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'PPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'분류 타입1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'CATEGORYTYPE1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'분류 타입2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'CATEGORYTYPE2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'분류 타입3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'CATEGORYTYPE3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'테마 이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'THEMENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로그램 이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'PRODUCTNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영 시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'STARTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영 종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'ENDDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로그램1시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'TIME1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로그램1내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'NOTE1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로그램2시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'TIME2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로그램2내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'NOTE2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로그램3시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'TIME3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로그램3내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'NOTE3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로그램 개요' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'INTRO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로그램 소개' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'CONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'개인 수용 인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'SEATCOUNT1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'단체 수용 인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'SEATCOUNT2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'USETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 시간 부가설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'USETIMENOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 자격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'ROLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 자격 부가설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'ROLENOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'준비물' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'PREPARATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'검색용 키워드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'KEYWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 정보 마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 설정 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPPENALTYMAP', @level2type=N'COLUMN',@level2name=N'PENALTYSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 세션 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPPENALTYMAP', @level2type=N'COLUMN',@level2name=N'EXPSESSIONSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 패널티 맵핑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPPENALTYMAP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 설정 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'EXPROLESEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 세션 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'EXPSESSIONSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'특정 대상자 우대 여부 [YN5]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'TARGETTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대상자 그룹 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'GROUPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자격 PIN 구간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'PINTREATRANGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역 우대 여부 [YN5]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'CITYTREATCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제한 나이 우대 타입 [RU1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'AGETREATCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 가능 기간 유형 코드 [PD1-TYPE2]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'PERIODTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 시작월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'STARTMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 종료월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'ENDMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'STARTDAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'ENDDAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 세션별 예약 자격 설정 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPROLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 세션 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'EXPSESSIONSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 정보 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'EXPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설정 단위 코드 [SS1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'SETTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설정 요일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'SETWEEK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설정 일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'SETDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세션 명칭' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'SESSIONNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세션 시작시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'STARTDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세션 종료시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'ENDDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세션 순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'ORDERNUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영 형태 코드 [SS2]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'WORKTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 세션 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPSESSIONINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약형태 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPTYPEMAP', @level2type=N'COLUMN',@level2name=N'TYPESEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 정보 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPTYPEMAP', @level2type=N'COLUMN',@level2name=N'EXPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'누적 예약 설정 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPTYPEMAP', @level2type=N'COLUMN',@level2name=N'SETTINGSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험타입 맵핑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVEXPTYPEMAP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPAYMENTSTATUS', @level2type=N'COLUMN',@level2name=N'RSVSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제 진행상태 코드 [PM1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPAYMENTSTATUS', @level2type=N'COLUMN',@level2name=N'PAYMENTCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제진행 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPAYMENTSTATUS', @level2type=N'COLUMN',@level2name=N'PAYMENTSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'진행 상태 변경일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPAYMENTSTATUS', @level2type=N'COLUMN',@level2name=N'PROCESSDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPAYMENTSTATUS', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPAYMENTSTATUS', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPAYMENTSTATUS', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPAYMENTSTATUS', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자 계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPAYMENTSTATUS', @level2type=N'COLUMN',@level2name=N'ACCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제 진행 이력 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPAYMENTSTATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이력 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'HISTORYSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자 계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'ACCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약일련번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'RSVSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 설정 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'PENALTYSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 적용 형태 코드 [PN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'APPLYTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 적용값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'APPLYTYPEVALUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'REASON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 부여일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'GRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유효코드[YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 이력 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYHISTORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 설정 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'PENALTYSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 유형코드 [PN1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'TYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 상세유형코드 [PN2]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'TYPEDETAILCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 유형값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'TYPEVALUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 적용 기간 코드 [PD1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'PERIODCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 적용 기간값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'PERIODVALUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 적용 형태 코드 [PN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'APPLYTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 적용값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'APPLYTYPEVALUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 패널티 설정 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPENALTYSETTING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이력 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY', @level2type=N'COLUMN',@level2name=N'HISTORYSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육장 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY', @level2type=N'COLUMN',@level2name=N'PPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육장 이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY', @level2type=N'COLUMN',@level2name=N'PPNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'웨어하우스 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY', @level2type=N'COLUMN',@level2name=N'WAREHOUSECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY', @level2type=N'COLUMN',@level2name=N'MODIFYDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육장 변경 이력' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPHISTORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육장 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPINFO', @level2type=N'COLUMN',@level2name=N'PPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육장 이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPINFO', @level2type=N'COLUMN',@level2name=N'PPNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPINFO', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'웨어하우스 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPINFO', @level2type=N'COLUMN',@level2name=N'WAREHOUSECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노출 정렬 순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPINFO', @level2type=N'COLUMN',@level2name=N'ORDERNUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPINFO', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPINFO', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPINFO', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPINFO', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육장[PP] 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPPINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주문발생일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'PURCHASEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드추적번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'CARDTRACENUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'SKU'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주문요청일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'REQUESTDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가상주문번호응답일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'VIRTUALDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정규주문번호응답일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'REGULARDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가상주문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'VIRTUALPURCHASNUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정규주문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'REGULARPURCHASENUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'RSVSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품명[OLD]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'SKU_OLD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약장 계정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO', @level2type=N'COLUMN',@level2name=N'ACCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주문정보관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVPURCHASEINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행정구역 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVREGIONINFO', @level2type=N'COLUMN',@level2name=N'REGIONCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행정구역 이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVREGIONINFO', @level2type=N'COLUMN',@level2name=N'REGIONNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행정구역 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVREGIONINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'RSVSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 형태 분류 코드 [RT1:시설/체험]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'RSVTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약형태 일련번호 - 시설타' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'TYPESEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육장 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'PPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 정보 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'ROOMSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 정보 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'EXPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'RESERVATIONDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 세션 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'RSVSESSIONSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체험 세션 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'EXPSESSIONSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자 계정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'ACCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'AMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세션 시작 시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'STARTDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세션 종료 시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'ENDDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리자 우선 예약 여부 [RV1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'ADMINFIRSTCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리자 우선 예약 사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'ADMINFIRSTREASON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리자 우선 예약 사유 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'ADMINFIRSTREASONCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요리 명장 여부 [RV2]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'COOKMASTERCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'불참 여부 [RV3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'NOSHOWCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동반자 구분 코드 [RV4]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'PARTNERTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동반자 식별 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'PARTNERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 대기 순서 [default_0]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'STANDBYNUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'신청일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'PURCHASEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제 유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'PAYMENTSTATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제 금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'PAYMENTAMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'PAYMENTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제 방법 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'PAYMENTOPTIONCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제 관리 코드[interface]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'PAYMENTINTERNALCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소유무[YN6]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'CANCELCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'CANCELDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용자 예약 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVRESERVATIONINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대상자 그룹 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLEGROUP', @level2type=N'COLUMN',@level2name=N'GROUPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대상자 그룹 이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLEGROUP', @level2type=N'COLUMN',@level2name=N'TARGETGROUPNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLEGROUP', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLEGROUP', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLEGROUP', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLEGROUP', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLEGROUP', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 자격 대상자 그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLEGROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대상자 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLETARGET', @level2type=N'COLUMN',@level2name=N'TARGETSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대상자 식별 번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLETARGET', @level2type=N'COLUMN',@level2name=N'ABONO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대상자 이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLETARGET', @level2type=N'COLUMN',@level2name=N'ABONAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용 여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLETARGET', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대상자 그룹 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLETARGET', @level2type=N'COLUMN',@level2name=N'GROUPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLETARGET', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLETARGET', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLETARGET', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLETARGET', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 자격 대상자 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROLETARGET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 정보 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'ROOMSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 소개' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'INTRO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부대시설 사용 여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'FACILITYSTATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'ROOMNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수용 인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'SEATCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부대시설' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'FACILITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이용 시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'USETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 자격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'ROLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 자격 추가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'ROLENOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'검색용 키워드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'KEYWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육장 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'PPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영 종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'ENDDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영 시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'STARTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 정보 마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패널티 설정 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMPENALTYMAP', @level2type=N'COLUMN',@level2name=N'PENALTYSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 세션 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMPENALTYMAP', @level2type=N'COLUMN',@level2name=N'RSVSESSIONSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 패널티 맵핑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMPENALTYMAP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 설정 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'RSVROLESEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 세션 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'RSVSESSIONSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'특정 대상자 우대 여부 [YN5]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'TARGETTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대상자 그룹 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'GROUPSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자격 PIN 구간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'PINTREATRANGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역 우대 여부 [YN5]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'CITYTREATCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제한 나이 우대 타입 [RU1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'AGETREATCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 가능 기간 유형 코드 [PD1-TYPE2]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'PERIODTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 시작월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'STARTMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'STARTDAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 종료월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'ENDMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'ENDDAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 세션별 예약 자격 설정 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMROLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세션 순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'ORDERNUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세션 시작 시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'STARTDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세션 종료 시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'ENDDATETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세션 명칭' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'SESSIONNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정상가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'DISCOUNTPRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 정보 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'ROOMSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 세션 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'RSVSESSIONSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설정 단위 코드 [SS1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'SETTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설정 요일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'SETWEEK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설정 일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'SETDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영 형태 코드 [SS2]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'WORKTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 세션 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMSESSIONINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약형태 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMTYPEMAP', @level2type=N'COLUMN',@level2name=N'TYPESEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 정보 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMTYPEMAP', @level2type=N'COLUMN',@level2name=N'ROOMSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'누적 예약 설정 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMTYPEMAP', @level2type=N'COLUMN',@level2name=N'SETTINGSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설타입 맵핑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVROOMTYPEMAP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시설 정보 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVSAMEROOMINFO', @level2type=N'COLUMN',@level2name=N'ROOMSEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동일장소 식별정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVSAMEROOMINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 형태 분류 코드 [RT1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVTYPEINFO', @level2type=N'COLUMN',@level2name=N'RSVTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약형태 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVTYPEINFO', @level2type=N'COLUMN',@level2name=N'TYPESEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'타입 이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVTYPEINFO', @level2type=N'COLUMN',@level2name=N'TYPENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부 [YN3]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVTYPEINFO', @level2type=N'COLUMN',@level2name=N'STATUSCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 필수 안내' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVTYPEINFO', @level2type=N'COLUMN',@level2name=N'RESERVATIONINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVTYPEINFO', @level2type=N'COLUMN',@level2name=N'INSERTUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVTYPEINFO', @level2type=N'COLUMN',@level2name=N'INSERTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVTYPEINFO', @level2type=N'COLUMN',@level2name=N'UPDATEUSER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVTYPEINFO', @level2type=N'COLUMN',@level2name=N'UPDATEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 형태 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSVTYPEINFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회계연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'FISCALYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위임구분(1:Emeald 위임, 2:Diamond 위임)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'DELEGTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'피위임자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'DELEGABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위임자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'DELEGATORABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관아이디(자동체번)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'AGREEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'AGREEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관동의일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'AGREEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비 위임 동의' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEDELEG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회계연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE', @level2type=N'COLUMN',@level2name=N'FISCALYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE', @level2type=N'COLUMN',@level2name=N'AGREEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관구분(서약서, 위임동의, 제3자동의)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE', @level2type=N'COLUMN',@level2name=N'AGREETYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위임구분(위임동의사용)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE', @level2type=N'COLUMN',@level2name=N'DELEGTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE', @level2type=N'COLUMN',@level2name=N'AGREETITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE', @level2type=N'COLUMN',@level2name=N'AGREETEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비약관관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEMANAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회계연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEPLEDGE', @level2type=N'COLUMN',@level2name=N'FISCALYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관아이디(자동체번)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEPLEDGE', @level2type=N'COLUMN',@level2name=N'AGREEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEPLEDGE', @level2type=N'COLUMN',@level2name=N'DEPABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEPLEDGE', @level2type=N'COLUMN',@level2name=N'AGREEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관동의일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEPLEDGE', @level2type=N'COLUMN',@level2name=N'AGREEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEPLEDGE', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEPLEDGE', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEPLEDGE', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEPLEDGE', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비 서약서 동의' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREEPLEDGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회계연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREESPECIAL', @level2type=N'COLUMN',@level2name=N'FISCALYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관아이디(자동체번)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREESPECIAL', @level2type=N'COLUMN',@level2name=N'SPECIALID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'첨부파일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREESPECIAL', @level2type=N'COLUMN',@level2name=N'ATTACHFILE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREESPECIAL', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREESPECIAL', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREESPECIAL', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREESPECIAL', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비 Special' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREESPECIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회계연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON', @level2type=N'COLUMN',@level2name=N'FISCALYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관아이디(자동체번)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON', @level2type=N'COLUMN',@level2name=N'AGREEID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제3자 동의 ABO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON', @level2type=N'COLUMN',@level2name=N'THIRDPERSON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deposit ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON', @level2type=N'COLUMN',@level2name=N'DEPABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON', @level2type=N'COLUMN',@level2name=N'AGREEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관동의일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON', @level2type=N'COLUMN',@level2name=N'AGREEDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비 제3자 동의' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEAGREETHIRDPERSON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEGROUPCODE', @level2type=N'COLUMN',@level2name=N'GROUPCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영그룹명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEGROUPCODE', @level2type=N'COLUMN',@level2name=N'GROUPNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEGROUPCODE', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEGROUPCODE', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEGROUPCODE', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEGROUPCODE', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비운영그룹관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEGROUPCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'GIVEYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'GIVEMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계획아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'PLANID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deposit ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'DEPABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계획형태(1:그룹,2:개인)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'PLANTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'강의제목(교육명)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'EDUTITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'EDUKIND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'장소(교육장소)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'PLACE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용일자(교육일자)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'SPENDDT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'강사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'LECTURENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예상인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'PERSONCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'횟수(회)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'PLANCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'EDUDESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계획상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'PLANSTATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'SPENDID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'GROUPCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비계획서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLAN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM', @level2type=N'COLUMN',@level2name=N'GIVEYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM', @level2type=N'COLUMN',@level2name=N'GIVEMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계획아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM', @level2type=N'COLUMN',@level2name=N'PLANID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계획항목아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM', @level2type=N'COLUMN',@level2name=N'PLANITEMID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출항목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM', @level2type=N'COLUMN',@level2name=N'SPENDITEM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출금액(예상금액)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM', @level2type=N'COLUMN',@level2name=N'SPENDAMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비계획서항목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'GIVEYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'GIVEMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계획아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'PLANID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계획항목아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'PLANITEMID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deposit ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'DEPABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출항목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'SPENDITEM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출금액(예상금액)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'SPENDAMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비계획서그룹항목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEEPLANITEMGROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회계연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'FISCALYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deposit ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'DEPABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료신청아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'RENTID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료형태(1:그룹,2:개인)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'RENTTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'RENTAMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료보증금' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'RENTDEPOSIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료제목(계약명)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'RENTTITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임대료시작월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'RENTFROMMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임대료종료월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'RENTTOMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'RENTSTATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'첨부파일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'ATTACHFILE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reject 사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'RENTREJECTTEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'RENTSMSTEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'GROUPCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'GIVEYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT', @level2type=N'COLUMN',@level2name=N'GIVEMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비임대차신청' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회계연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTGROUP', @level2type=N'COLUMN',@level2name=N'FISCALYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deposit ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTGROUP', @level2type=N'COLUMN',@level2name=N'DEPABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료신청아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTGROUP', @level2type=N'COLUMN',@level2name=N'RENTID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTGROUP', @level2type=N'COLUMN',@level2name=N'RENTAMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료보증금' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTGROUP', @level2type=N'COLUMN',@level2name=N'RENTDEPOSIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTGROUP', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTGROUP', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTGROUP', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTGROUP', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비임대차그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTGROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회계연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON', @level2type=N'COLUMN',@level2name=N'FISCALYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deposit ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON', @level2type=N'COLUMN',@level2name=N'DEPABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료신청아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON', @level2type=N'COLUMN',@level2name=N'RENTID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급년월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON', @level2type=N'COLUMN',@level2name=N'GIVEYEARMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON', @level2type=N'COLUMN',@level2name=N'RENTAMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'임차료보증금' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON', @level2type=N'COLUMN',@level2name=N'RENTDEPOSIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비임대차개인' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEERENTPERSON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'GIVEYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'GIVEMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시작일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'STARTDT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시작시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'STARTTIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종료일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'ENDDT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종료시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'ENDTIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS발송신청여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'SMSSENDFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비일정관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESCHEDULE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급년도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'GIVEYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'GIVEMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'SPENDID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deposit ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'DEPABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출형태(1:그룹,2:순번)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'SPENDTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'강의제목(교육명)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'EDUTITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'EDUKIND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'장소(교육장소)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'PLACE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용일자(교육일자)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'SPENDDT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'강사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'LECTURENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예상인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'PERSONCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'횟수(회)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'PLANCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육설명기타' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'EDUDESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출증빙상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'SPENDSTATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출확정여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'SPENDCONFIRMFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'GROUPCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계획서아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'PLANID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출확정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'SPENDCONFIRMDT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'AS400업로드여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND', @level2type=N'COLUMN',@level2name=N'AS400UPLOADFALG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비지출' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPEND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급년도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'GIVEYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'GIVEMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'SPENDID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출항목아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'SPENDITEMID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출항목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'SPENDITEM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'SPENDAMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'첨부파일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'ATTACHFILE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'CHECKFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비지출항목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급년도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'GIVEYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'GIVEMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'SPENDID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출항목아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'SPENDITEMID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deposit ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'DEPABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출항목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'SPENDITEM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'SPENDAMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출확정여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'SPENDCONFIRMFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'CHECKFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'첨부파일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'ATTACHFILE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지출확정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'SPENDCONFIRMDT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비지출항목그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESPENDITEMGROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESYSTEMLOG', @level2type=N'COLUMN',@level2name=N'ABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시스템아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESYSTEMLOG', @level2type=N'COLUMN',@level2name=N'SYSTEMID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시스템타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESYSTEMLOG', @level2type=N'COLUMN',@level2name=N'SYSTEMTYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESYSTEMLOG', @level2type=N'COLUMN',@level2name=N'EVENTID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESYSTEMLOG', @level2type=N'COLUMN',@level2name=N'SYSTEMTEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESYSTEMLOG', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESYSTEMLOG', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESYSTEMLOG', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESYSTEMLOG', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교육비 시스템 로그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEESYSTEMLOG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'ABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION CODE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION BR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'BR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION DEPT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'DEPARTMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'참고사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'REFERENCE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'운영그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'GROUPCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DEPOSIT 권한(그룹)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'AUTHGROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DEPOSIT 권한(개인)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'AUTHPERSON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DEPOSIT 총무유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL', @level2type=N'COLUMN',@level2name=N'AUTHMANAGEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육비누적대상자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETFULL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'지급연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'GIVEYEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'지급월' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'GIVEMONTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION ABO번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'ABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION CODE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION BR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'BR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION DEPT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'DEPARTMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION 매출액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'SALES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION 교육비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'TRFEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'CALCULATION 운영그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'GROUPCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'DEPOSIT 권한(그룹)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'AUTHGROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'DEPOSIT 권한(개인)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'AUTHPERSON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'DEPOSIT 총무유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'AUTHMANAGEFLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'Deposit 위임구분(에메랄드위임, 다이아위임, Special 위임)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'DELEGTYPECODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'DEPOSIT ABO_NO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'DEPABO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'DEPOSIT CODE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'DEPCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'REJECT 사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'REJECTTEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'SMS 내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'SMSTEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'처리상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'PROCESSSTATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'AS400업로드유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'AS400UPLOADFALG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'메모(월단위)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'NOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'MODIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'MODIFYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'입력자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'REGISTRANT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'입력일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'REGISTRANTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH', @level2type=N'COLUMN',@level2name=N'PROCESSSTATUSDT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'교육비월별대상자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRFEETARGETMONTH'
GO
ALTER DATABASE [academy_dev] SET  READ_WRITE 
GO

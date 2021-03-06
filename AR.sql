USE [master]
GO
/****** Object:  Database [AR]    Script Date: 10-02-2020 16:04:41 ******/
CREATE DATABASE [AR]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LMGEDI', FILENAME = N'E:\SQL_Database\LMGEDI.mdf' , SIZE = 140288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'LMGEDI_log', FILENAME = N'E:\SQL_Database\LMGEDI_log.ldf' , SIZE = 2160960KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [AR] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AR].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AR] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AR] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AR] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AR] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AR] SET ARITHABORT OFF 
GO
ALTER DATABASE [AR] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AR] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AR] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AR] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AR] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AR] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AR] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AR] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AR] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AR] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AR] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AR] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AR] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AR] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AR] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AR] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AR] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AR] SET RECOVERY FULL 
GO
ALTER DATABASE [AR] SET  MULTI_USER 
GO
ALTER DATABASE [AR] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AR] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AR] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AR] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [AR] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'AR', N'ON'
GO
USE [AR]
GO
/****** Object:  User [VSAINDIA\dheerajs]    Script Date: 10-02-2020 16:04:41 ******/
CREATE USER [VSAINDIA\dheerajs] FOR LOGIN [VSAINDIA\dheerajs] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [VSAINDIA\Developers_JAL]    Script Date: 10-02-2020 16:04:41 ******/
CREATE USER [VSAINDIA\Developers_JAL] FOR LOGIN [VSAINDIA\Developers_JAL]
GO
/****** Object:  User [uttam]    Script Date: 10-02-2020 16:04:41 ******/
CREATE USER [uttam] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [VSAINDIA\dheerajs]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [VSAINDIA\dheerajs]
GO
ALTER ROLE [db_owner] ADD MEMBER [VSAINDIA\Developers_JAL]
GO
ALTER ROLE [db_owner] ADD MEMBER [uttam]
GO
/****** Object:  Schema [global]    Script Date: 10-02-2020 16:04:41 ******/
CREATE SCHEMA [global]
GO
/****** Object:  Schema [Job]    Script Date: 10-02-2020 16:04:41 ******/
CREATE SCHEMA [Job]
GO
/****** Object:  Schema [lookup]    Script Date: 10-02-2020 16:04:41 ******/
CREATE SCHEMA [lookup]
GO
/****** Object:  UserDefinedFunction [global].[Get_AddWorkDays]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [global].[Get_AddWorkDays] --Mahinder Singh/12 JAN 2016
(    
    @WorkingDays As Int, 
    @StartDate AS DateTime 
) 
RETURNS DateTime 
AS
BEGIN
    DECLARE @Count AS Int
    DECLARE @i As Int
    DECLARE @NewDate As DateTime 
    SET @Count = 0 
    SET @i = 0 
 
    WHILE (@i < @WorkingDays) --runs through the number of days to add 
    BEGIN
-- increments the count variable 
        SELECT @Count = @Count + 1 
-- increments the i variable 
        SELECT @i = @i + 1 
-- adds the count on to the StartDate and checks if this new date is a Saturday or Sunday 
-- if it is a Saturday or Sunday it enters the nested while loop and increments the count variable 
           WHILE DATEPART(weekday,DATEADD(d, @Count, @StartDate)) IN (1,7) 
            BEGIN
                SELECT @Count = @Count + 1 
            END
    END
 
-- adds the eventual count on to the Start Date and returns the new date 
    SELECT @NewDate = DATEADD(d,@Count,@StartDate) 
    RETURN @NewDate 
END


 
GO
/****** Object:  UserDefinedFunction [global].[Get_DateInUSFormat]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [global].[Get_DateInUSFormat]--Mahinder Singh/12 JUN 2015
(
	@DATE VARCHAR(12)
)
RETURNS VARCHAR(10)
AS
BEGIN	
	
    DECLARE @FIRST VARCHAR(2)
    DECLARE @SECOND VARCHAR(2)
    DECLARE @THIRD VARCHAR(4)
    DECLARE @SLASH VARCHAR(1)
    DECLARE @FINAL VARCHAR(10)
    DECLARE @EXPRESSION VARCHAR(1) 
    DECLARE @COUNTINDEX INT  
    DECLARE @COUNT INT  
	
   SET @COUNTINDEX = (SELECT CHARINDEX('-',@DATE) AS T)
 
   IF(@COUNTINDEX >0)	
   BEGIN
        SET @EXPRESSION = '-'
   END
   ELSE
   BEGIN
        SET @EXPRESSION = '/'
   END
	
   SET @COUNT =(SELECT (LEFT(@DATE, charindex(@EXPRESSION,@DATE) - 1)))
	
	
   IF(@COUNT >12)
   BEGIN	
		   SELECT @FIRST = (LEFT(@DATE, charindex(@EXPRESSION, @DATE) - 1)),
		          @SECOND =(SUBSTRING(@DATE, charindex(@EXPRESSION, @DATE)+1, len(@DATE) - CHARINDEX(@EXPRESSION, reverse(@DATE)) - charindex(@EXPRESSION, @DATE))),
			      @THIRD =(REVERSE(LEFT(reverse(@DATE), charindex(@EXPRESSION, reverse(@DATE)) - 1)))
			   
			   
		   SET  @FINAL = (@SECOND+@EXPRESSION+@FIRST+@EXPRESSION+@THIRD)
   END
   ELSE           
   BEGIN
             SELECT @FIRST = (LEFT(@DATE, charindex(@EXPRESSION, @DATE) - 1)),
		            @SECOND =(SUBSTRING(@DATE, charindex(@EXPRESSION, @DATE)+1, len(@DATE) - CHARINDEX(@EXPRESSION, reverse(@DATE)) - charindex(@EXPRESSION, @DATE))),
			        @THIRD =(REVERSE(LEFT(reverse(@DATE), charindex(@EXPRESSION, reverse(@DATE)) - 1)))
			   
			   
		   SET  @FINAL = (@FIRST+@EXPRESSION+@SECOND+@EXPRESSION+@THIRD)
   END 
	
	


	RETURN @FINAL
END

GO
/****** Object:  UserDefinedFunction [global].[Get_SplitStringFormat]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE FUNCTION [global].[Get_SplitStringFormat] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(Id int IDENTITY(1,1) NOT NULL,splitdata NVARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END


 
GO
/****** Object:  UserDefinedFunction [global].[Split]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [global].[Split](@String VARCHAR(8000), @Delimiter CHAR(1))       
RETURNS @table TABLE (items VARCHAR(8000))       
AS       
BEGIN       
    DECLARE @idx INT       
    DECLARE @slice VARCHAR(8000)       

    SELECT @idx = 1       
        IF LEN(@String)<1 OR @String IS NULL  RETURN       

    WHILE @idx!= 0       
    BEGIN       
        SET @idx = CHARINDEX(@Delimiter,@String)       
        IF @idx!=0       
            SET @slice = LEFT(@String,@idx - 1)       
        ELSE       
            SET @slice = @String       

        IF(LEN(@slice)>0)  
            INSERT INTO @table(Items) VALUES(@slice)       

        SET @String = right(@String,LEN(@String) - @idx)       
        IF LEN(@String) = 0 BREAK       
    END   
RETURN       
END

GO
/****** Object:  Table [global].[tblAdjusters]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblAdjusters](
	[AdjusterId] [int] IDENTITY(1,1) NOT NULL,
	[AdjusterFirstName] [varchar](50) NULL,
	[AdjusterLastName] [varchar](50) NULL,
	[AdjusterPhone] [varchar](12) NULL,
	[AdjusterFax] [varchar](12) NULL,
	[AdjusterEmail] [varchar](50) NULL,
 CONSTRAINT [PK_Adjuster] PRIMARY KEY CLUSTERED 
(
	[AdjusterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblCommissionPayments]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblCommissionPayments](
	[CommissionPaymentID] [int] IDENTITY(1,1) NOT NULL,
	[CommissionID] [int] NULL,
	[CPPaymentPaidAmount] [money] NULL,
	[CPCheckNumber] [varchar](10) NULL,
	[CPCheckSentOn] [datetime] NULL,
	[InvoiceDateQuarter] [int] NULL,
	[IsPaymentRecevied] [bit] NULL,
 CONSTRAINT [PK_tblCommissionPayments] PRIMARY KEY CLUSTERED 
(
	[CommissionPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblCommissions]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblCommissions](
	[CommissionID] [int] IDENTITY(1,1) NOT NULL,
	[LienCommissionID] [int] NULL,
	[LienCName] [varchar](50) NULL,
	[LienCClientID] [int] NULL,
	[LienCStartDate] [datetime] NULL,
	[LienCEndDate] [datetime] NULL,
	[LienCPrecentage] [decimal](18, 2) NULL,
	[LienClientName] [varchar](500) NULL,
 CONSTRAINT [PK_tblCommissions] PRIMARY KEY CLUSTERED 
(
	[CommissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblDepartments]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblDepartments](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [char](10) NULL,
	[DepartmentNameDesc] [varchar](50) NULL,
 CONSTRAINT [PK_tblDepartments] PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblEmployers]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblEmployers](
	[EmployerId] [int] IDENTITY(1,1) NOT NULL,
	[EmployerName] [varchar](50) NULL,
	[EmployerAddress] [varchar](50) NULL,
	[EmployerCity] [varchar](50) NULL,
	[EmployerStateID] [int] NULL,
	[EmployerZip] [varchar](10) NULL,
	[EmployerPhone] [varchar](14) NULL,
 CONSTRAINT [PK_tblEmployer] PRIMARY KEY CLUSTERED 
(
	[EmployerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblFiles]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblFiles](
	[FileID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[ClaimNumber] [varchar](100) NULL,
	[InsurerId] [int] NULL,
	[InsurerBranchId] [int] NULL,
	[EmployerId] [int] NULL,
	[AdjusterId] [int] NULL,
	[IsLienClaimNumber] [bit] NULL,
	[IsLienInsurerID] [bit] NULL,
	[IsLienInsurerBranchID] [bit] NULL,
	[IsLienEmployerID] [bit] NULL,
	[IsLienAdjusterID] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedBy] [int] NULL,
	[DeletedOn] [datetime] NULL,
	[Notes] [varchar](max) NULL,
	[DepartmentID] [int] NULL,
 CONSTRAINT [PK_tblFiles] PRIMARY KEY CLUSTERED 
(
	[FileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [global].[tblICRecordDetails]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblICRecordDetails](
	[ICRecordDetailID] [int] IDENTITY(1,1) NOT NULL,
	[FileID] [int] NULL,
	[ICRecordDetailAddress] [varchar](80) NULL,
	[ICRecordDetailCity] [varchar](25) NULL,
	[StateID] [int] NULL,
	[ICRecordDetailZip] [varchar](5) NULL,
	[ICRecordDetailTaxID] [varchar](10) NULL,
 CONSTRAINT [PK_tblICRecordDetails] PRIMARY KEY CLUSTERED 
(
	[ICRecordDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblIndependentContractorDepartment]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblIndependentContractorDepartment](
	[IndepContractorDeptID] [int] IDENTITY(1,1) NOT NULL,
	[IndepContractorDeptFirstName] [varchar](50) NULL,
	[IndepContractorDeptLastName] [varchar](50) NULL,
	[IndepContractorDeptInvoiceNumber] [varchar](255) NULL,
	[IndepContractorDeptInvoiceDate] [date] NULL,
	[IndepContractorDeptInvoiceAmt] [money] NULL,
	[IndepContractorDeptARInvoiceNumber] [varchar](255) NULL,
	[IndepContractorDeptPaymentAmt] [money] NULL,
	[IndepContractorDeptPaymentSent] [date] NULL,
	[IndepContractorDeptCheckNumber] [varchar](50) NULL,
 CONSTRAINT [PK_tblIndependentContractorDepartment] PRIMARY KEY CLUSTERED 
(
	[IndepContractorDeptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblInsurerBranches]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblInsurerBranches](
	[InsurerBranchId] [int] IDENTITY(1,1) NOT NULL,
	[InsurerId] [int] NULL,
	[InsurerBranchName] [varchar](50) NULL,
	[InsurerBranchAddress] [varchar](50) NULL,
	[InsurerBranchCity] [varchar](50) NULL,
	[InsurerBranchStateID] [int] NULL,
	[InsurerBranchZip] [varchar](10) NULL,
	[InsurerBranchPhone] [varchar](50) NULL,
 CONSTRAINT [PK_tblInsurerBranch] PRIMARY KEY CLUSTERED 
(
	[InsurerBranchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblInsurers]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblInsurers](
	[InsurerId] [int] IDENTITY(1,1) NOT NULL,
	[InsurerName] [varchar](50) NOT NULL,
	[InsurerAddress] [varchar](50) NULL,
	[InsurerCity] [varchar](50) NULL,
	[InsurerStateID] [int] NULL,
	[InsurerZip] [varchar](10) NULL,
	[InsurerPhone] [varchar](14) NULL,
 CONSTRAINT [PK_Insurer] PRIMARY KEY CLUSTERED 
(
	[InsurerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblInvoiceAdjustments]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblInvoiceAdjustments](
	[AdjustmentID] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceID] [int] NULL,
	[AdjustmentAmt] [money] NULL,
	[AdjustmentNotes] [varchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_tblInvoiceAdjustments_1] PRIMARY KEY CLUSTERED 
(
	[AdjustmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [global].[tblInvoiceNotes]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblInvoiceNotes](
	[InvoiceNotesID] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceID] [int] NULL,
	[InvoiceNotes] [varchar](max) NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_tblInvoiceNotes] PRIMARY KEY CLUSTERED 
(
	[InvoiceNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [global].[tblInvoices]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblInvoices](
	[InvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[FileId] [int] NULL,
	[InvoiceNumber] [varchar](255) NULL,
	[InvoiceAmt] [money] NULL,
	[InvoiceICAmt] [money] NULL,
	[InvoiceDate] [date] NULL,
	[InvoiceDueDate] [date] NULL,
	[InvoiceSent] [date] NULL,
	[BillingWeek] [date] NULL,
	[DepartmentId] [int] NULL,
	[InvoiceBalanceAmt] [money] NULL,
	[InvoiceFileName] [varchar](max) NULL,
	[UserCredibility] [int] NULL,
	[AssignedToInvoiceID] [int] NULL,
	[LienClientID] [int] NULL,
 CONSTRAINT [PK_tblInvoice] PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [global].[tblLienTempTables]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblLienTempTables](
	[UploadId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Claim] [varchar](100) NULL,
	[Insurer] [varchar](50) NULL,
	[InsurerBranch] [varchar](50) NULL,
	[Employer] [varchar](50) NULL,
	[Adjuster] [varchar](50) NULL,
	[InvoiceNumber] [varchar](50) NULL,
	[InvoiceAmount] [varchar](50) NULL,
	[InvoiceDate] [varchar](50) NULL,
	[InvoiceSent] [varchar](50) NULL,
	[BillingWeek] [varchar](50) NULL,
	[InvoiceDept] [varchar](50) NULL,
	[PaymentAmount] [varchar](50) NULL,
	[PaymentReceived] [varchar](50) NULL,
	[CheckNumber] [varchar](50) NULL,
	[LienDataValidate] [bit] NULL,
	[Reason] [varchar](max) NULL,
	[PendingUploadId] [int] NULL,
 CONSTRAINT [PK_tblLienTempTable] PRIMARY KEY CLUSTERED 
(
	[UploadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [global].[tblOCRPayments]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblOCRPayments](
	[OCRPaymentId] [int] IDENTITY(1,1) NOT NULL,
	[OCRId] [int] NOT NULL,
	[PaymentId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_tblOCRPayments] PRIMARY KEY CLUSTERED 
(
	[OCRPaymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblOCRs]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblOCRs](
	[OcrId] [int] IDENTITY(1,1) NOT NULL,
	[OcrFileName] [varchar](100) NULL,
	[IsOCRPaymentRecevied] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedBy] [int] NULL,
	[DeletedOn] [datetime] NULL,
 CONSTRAINT [PK_tblOCRs] PRIMARY KEY CLUSTERED 
(
	[OcrId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblPaymentRefunds]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblPaymentRefunds](
	[PaymentRefundID] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceId] [int] NULL,
	[RefundAmount] [money] NULL,
	[RefundReceived] [datetime] NULL,
	[CheckNumber] [varchar](50) NULL,
	[CheckUploadName] [varchar](100) NULL,
 CONSTRAINT [PK_tblPaymentRefunds] PRIMARY KEY CLUSTERED 
(
	[PaymentRefundID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblPayments]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblPayments](
	[PaymentId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceId] [int] NULL,
	[PaymentAmount] [money] NULL,
	[PaymentReceived] [datetime] NULL,
	[CheckNumber] [varchar](50) NULL,
	[CheckUploadName] [varchar](100) NULL,
	[PendingUploadId] [int] NULL,
	[CheckDate] [datetime] NULL,
 CONSTRAINT [PK_tblPayments] PRIMARY KEY CLUSTERED 
(
	[PaymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblPendingUploads]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblPendingUploads](
	[PendingUploadId] [int] IDENTITY(1,1) NOT NULL,
	[PendingUploadName] [varchar](512) NULL,
	[PendingUploadDate] [datetime] NULL,
	[UserId] [int] NULL,
	[DepartmentId] [int] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedBy] [int] NULL,
	[DeletedOn] [datetime] NULL,
	[IsProcessed] [bit] NULL,
	[ProcessedBy] [int] NULL,
	[ProcessedOn] [datetime] NULL,
 CONSTRAINT [PK_tblPendingUploads] PRIMARY KEY CLUSTERED 
(
	[PendingUploadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblUploadTemps]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblUploadTemps](
	[UploadId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[Claim] [varchar](100) NULL,
	[Insurer] [varchar](50) NULL,
	[InsurerBranch] [varchar](50) NULL,
	[Employer] [varchar](50) NULL,
	[Adjuster] [varchar](50) NULL,
	[InvoiceNumber] [varchar](50) NULL,
	[InvoiceAmount] [varchar](50) NULL,
	[InvoiceDate] [varchar](50) NULL,
	[InvoiceSent] [varchar](50) NULL,
	[BillingWeek] [varchar](50) NULL,
	[PaymentAmount] [varchar](50) NULL,
	[PaymentReceived] [varchar](50) NULL,
	[CheckNumber] [varchar](50) NULL,
	[InvoiceDept] [varchar](50) NULL,
	[PendingUploadId] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblUploadTempsContractor]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblUploadTempsContractor](
	[UploadId] [int] IDENTITY(1,1) NOT NULL,
	[ICFirstName] [varchar](100) NULL,
	[ICLastName] [varchar](100) NULL,
	[ICInvoiceNumber] [varchar](50) NULL,
	[ICInvoiceAmount] [varchar](50) NULL,
	[ICInvoiceDate] [varchar](50) NULL,
	[ARInvoiceNumber] [varchar](50) NULL,
	[ICPayment] [varchar](50) NULL,
	[ICPaySent] [varchar](50) NULL,
	[ICCheckNumber] [varchar](50) NULL,
	[InvoiceDept] [varchar](50) NULL,
	[PendingUploadId] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [global].[tblUsers]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [global].[tblUsers](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NULL,
	[Password] [varchar](70) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Email] [varchar](255) NULL,
	[Telephone] [varchar](10) NULL,
	[LastLoginDate] [datetime] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Job].[tblTrackingLienInvoice]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Job].[tblTrackingLienInvoice](
	[JobDate] [datetime] NULL,
	[Status] [varchar](max) NULL,
	[Invoice] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [lookup].[States]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[States](
	[StateID] [int] IDENTITY(1,1) NOT NULL,
	[StateName] [char](2) NOT NULL,
 CONSTRAINT [PK_States] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [global].[tblCommissionPayments] ADD  CONSTRAINT [DF_tblCommissionPayments_IsPaymentRecevied]  DEFAULT ((0)) FOR [IsPaymentRecevied]
GO
ALTER TABLE [global].[tblFiles] ADD  CONSTRAINT [DF_tblFiles_IsLienClaimNumber]  DEFAULT ((0)) FOR [IsLienClaimNumber]
GO
ALTER TABLE [global].[tblFiles] ADD  CONSTRAINT [DF_tblFiles_IsLienInsurerID]  DEFAULT ((0)) FOR [IsLienInsurerID]
GO
ALTER TABLE [global].[tblFiles] ADD  CONSTRAINT [DF_tblFiles_IsLienInsurerBranchID]  DEFAULT ((0)) FOR [IsLienInsurerBranchID]
GO
ALTER TABLE [global].[tblFiles] ADD  CONSTRAINT [DF_tblFiles_IsLienEmployerID]  DEFAULT ((0)) FOR [IsLienEmployerID]
GO
ALTER TABLE [global].[tblFiles] ADD  CONSTRAINT [DF_tblFiles_IsLienAdjusterID]  DEFAULT ((0)) FOR [IsLienAdjusterID]
GO
ALTER TABLE [global].[tblFiles] ADD  CONSTRAINT [DF_tblFiles_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [global].[tblInvoiceAdjustments] ADD  CONSTRAINT [DF_tblInvoiceAdjustments_AdjustmentAmt]  DEFAULT ((0)) FOR [AdjustmentAmt]
GO
ALTER TABLE [global].[tblInvoiceAdjustments] ADD  CONSTRAINT [DF_tblInvoiceAdjustments_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [global].[tblInvoices] ADD  CONSTRAINT [DF_tblInvoices_InvoiceBalanceAmt]  DEFAULT ((0)) FOR [InvoiceBalanceAmt]
GO
ALTER TABLE [global].[tblOCRPayments] ADD  CONSTRAINT [DF_tblOCRPayments_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [global].[tblOCRs] ADD  CONSTRAINT [DF_tblOCRs_IsOCRPaymentRecevied]  DEFAULT ((0)) FOR [IsOCRPaymentRecevied]
GO
ALTER TABLE [global].[tblOCRs] ADD  CONSTRAINT [DF_tblOCRs_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [global].[tblOCRs] ADD  CONSTRAINT [DF_tblOCRs_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [global].[tblPayments] ADD  CONSTRAINT [DF_tblPayments_PendingUploadId]  DEFAULT ((0)) FOR [PendingUploadId]
GO
ALTER TABLE [global].[tblPendingUploads] ADD  CONSTRAINT [DF_tblPendingUploads_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [global].[tblPendingUploads] ADD  CONSTRAINT [DF_tblPendingUploads_IsDeleted1]  DEFAULT ((0)) FOR [IsProcessed]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_FirstName]  DEFAULT ('Update') FOR [FirstName]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_LastName]  DEFAULT ('Update') FOR [LastName]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_Claim]  DEFAULT ('Update') FOR [Claim]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_Insurer]  DEFAULT ('Update') FOR [Insurer]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_InsurerBranch]  DEFAULT ('Update') FOR [InsurerBranch]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_Employer]  DEFAULT ('Update') FOR [Employer]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_Adjuster]  DEFAULT ('Update') FOR [Adjuster]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_InvoiceNumber]  DEFAULT ('Update') FOR [InvoiceNumber]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_InvoiceAmount]  DEFAULT ('Update') FOR [InvoiceAmount]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_InvoiceDate]  DEFAULT ('Update') FOR [InvoiceDate]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_InvoiceSent]  DEFAULT ('Update') FOR [InvoiceSent]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_BillingWeek]  DEFAULT ('Update') FOR [BillingWeek]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_PaymentAmount]  DEFAULT ('Update') FOR [PaymentAmount]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_PaymentReceived]  DEFAULT ('Update') FOR [PaymentReceived]
GO
ALTER TABLE [global].[tblUploadTemps] ADD  CONSTRAINT [DF_tblUploadTemps_CheckNumber]  DEFAULT ('Update') FOR [CheckNumber]
GO
ALTER TABLE [global].[tblUploadTempsContractor] ADD  CONSTRAINT [DF_tblUploadTempsContractor_ICFirstName]  DEFAULT ('Update') FOR [ICFirstName]
GO
ALTER TABLE [global].[tblUploadTempsContractor] ADD  CONSTRAINT [DF_tblUploadTempsContractor_ICLastName]  DEFAULT ('Update') FOR [ICLastName]
GO
ALTER TABLE [global].[tblUploadTempsContractor] ADD  CONSTRAINT [DF_tblUploadTempsContractor_ICInvoiceNumber]  DEFAULT ('Update') FOR [ICInvoiceNumber]
GO
ALTER TABLE [global].[tblUploadTempsContractor] ADD  CONSTRAINT [DF_tblUploadTempsContractor_ICInvoiceAmount]  DEFAULT ('Update') FOR [ICInvoiceAmount]
GO
ALTER TABLE [global].[tblUploadTempsContractor] ADD  CONSTRAINT [DF_tblUploadTempsContractor_ICInvoiceDate]  DEFAULT ('Update') FOR [ICInvoiceDate]
GO
ALTER TABLE [global].[tblUploadTempsContractor] ADD  CONSTRAINT [DF_tblUploadTempsContractor_ARInvoiceNumber]  DEFAULT ('Update') FOR [ARInvoiceNumber]
GO
ALTER TABLE [global].[tblUploadTempsContractor] ADD  CONSTRAINT [DF_tblUploadTempsContractor_ICPayment]  DEFAULT ('Update') FOR [ICPayment]
GO
ALTER TABLE [global].[tblUploadTempsContractor] ADD  CONSTRAINT [DF_tblUploadTempsContractor_ICPaySent]  DEFAULT ('Update') FOR [ICPaySent]
GO
ALTER TABLE [global].[tblUploadTempsContractor] ADD  CONSTRAINT [DF_tblUploadTempsContractor_ICCheckNumber]  DEFAULT ('Update') FOR [ICCheckNumber]
GO
ALTER TABLE [global].[tblUsers] ADD  CONSTRAINT [DF_User_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [global].[tblICRecordDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblICRecordDetails_States] FOREIGN KEY([StateID])
REFERENCES [lookup].[States] ([StateID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [global].[tblICRecordDetails] CHECK CONSTRAINT [FK_tblICRecordDetails_States]
GO
ALTER TABLE [global].[tblICRecordDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblICRecordDetails_tblFiles] FOREIGN KEY([FileID])
REFERENCES [global].[tblFiles] ([FileID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [global].[tblICRecordDetails] CHECK CONSTRAINT [FK_tblICRecordDetails_tblFiles]
GO
ALTER TABLE [global].[tblInvoiceAdjustments]  WITH CHECK ADD  CONSTRAINT [FK_tblInvoiceAdjustments_tblInvoices] FOREIGN KEY([InvoiceID])
REFERENCES [global].[tblInvoices] ([InvoiceID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [global].[tblInvoiceAdjustments] CHECK CONSTRAINT [FK_tblInvoiceAdjustments_tblInvoices]
GO
ALTER TABLE [global].[tblInvoiceNotes]  WITH CHECK ADD  CONSTRAINT [FK_tblInvoiceNotes_tblUsers] FOREIGN KEY([InvoiceID])
REFERENCES [global].[tblInvoices] ([InvoiceID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [global].[tblInvoiceNotes] CHECK CONSTRAINT [FK_tblInvoiceNotes_tblUsers]
GO
ALTER TABLE [global].[tblOCRPayments]  WITH CHECK ADD  CONSTRAINT [FK_tblOCRPayments_tblOCRs] FOREIGN KEY([OCRId])
REFERENCES [global].[tblOCRs] ([OcrId])
GO
ALTER TABLE [global].[tblOCRPayments] CHECK CONSTRAINT [FK_tblOCRPayments_tblOCRs]
GO
ALTER TABLE [global].[tblOCRPayments]  WITH CHECK ADD  CONSTRAINT [FK_tblOCRPayments_tblPayments] FOREIGN KEY([PaymentId])
REFERENCES [global].[tblPayments] ([PaymentId])
GO
ALTER TABLE [global].[tblOCRPayments] CHECK CONSTRAINT [FK_tblOCRPayments_tblPayments]
GO
ALTER TABLE [global].[tblPendingUploads]  WITH CHECK ADD  CONSTRAINT [FK_tblPendingUploads_tblDepartments] FOREIGN KEY([DepartmentId])
REFERENCES [global].[tblDepartments] ([DepartmentId])
GO
ALTER TABLE [global].[tblPendingUploads] CHECK CONSTRAINT [FK_tblPendingUploads_tblDepartments]
GO
/****** Object:  StoredProcedure [global].[Add_OCRPaymentRecords]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Rohit Kumar
-- Create date: 07/27/2015
-- Description:	ADD OCR PAYMENTS RECORDS
-- =========================================================================================
-- [global].[Add_OCRPaymentRecords] 1 ,2,1,1,'07-08-2015 16:51:53','1R2O3H4I5T','01-08-2015','CHECK132.pdf'
CREATE PROCEDURE [global].[Add_OCRPaymentRecords] 
(
	@OCRId int,
	@CreatedBy int,
	@InvoiceId int,
	@PaymentAmount money,
	@PaymentReceived datetime,
	@CheckNumber varchar(50),
	@CheckDate datetime,
	@CheckUploadName varchar(100)
)
AS
BEGIN

	BEGIN TRANSACTION Tran1
		BEGIN TRY
			DECLARE @PaymentId AS INT = 0
			
			INSERT	INTO global.tblPayments
					(InvoiceId, PaymentAmount, PaymentReceived, CheckNumber, CheckUploadName,PendingUploadId,CheckDate)
			VALUES  (@InvoiceId, @PaymentAmount, @PaymentReceived, @CheckNumber, @CheckUploadName,0,@CheckDate)

			SET @PaymentId = SCOPE_IDENTITY() 

			if(@PaymentId>0)
				BEGIN
					DECLARE @OCRPaymentId AS INT = 0
					INSERT INTO global.tblOCRPayments
							  (OCRId, PaymentId, CreatedBy, CreatedOn)
					VALUES    (@OCRId, @PaymentId, @CreatedBy,getdate())
					
					--declare @InvoiceAmount as money = 0 
					--declare @PaymentSumAmount as money = 0
					
					--Set @InvoiceAmount = (SELECT isnull(InvoiceAmt,0) FROM global.tblInvoices where InvoiceID= @InvoiceId)
					--Set @PaymentSumAmount = (SELECT isnull(Sum(isnull(PaymentAmount,0)),0) FROM global.tblPayments where InvoiceId= @InvoiceId)
					
					--if(@InvoiceAmount = @PaymentSumAmount)
					--	begin
					--		UPDATE    global.tblOCRs SET              IsOCRPaymentRecevied = 1 where OCRId = @OCRId
					--	end
					--ELSE
					--	begin
					--		UPDATE    global.tblOCRs SET              IsOCRPaymentRecevied = 0 where OCRId = @OCRId
					--	end		
					
					UPDATE    global.tblInvoices SET              InvoiceBalanceAmt = (InvoiceBalanceAmt - @PaymentAmount) where  InvoiceId = @InvoiceId
								
				END 
			SELECT  CAST(SCOPE_IDENTITY() AS INT) as OCRPaymentId , @PaymentId as PaymentId
			
		COMMIT TRANSACTION Tran1
	END TRY 
	BEGIN CATCH
		ROLLBACK TRANSACTION Tran1
END CATCH

END

GO
/****** Object:  StoredProcedure [global].[Check_AdjusterExist]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Genius Jain
-- Create date: 07/21/2015
-- Description:	Check  Adjuster from Liens.dbo.Adjuster and AR.dbo.Adjuster exist
-- =========================================================================================
CREATE PROCEDURE [global].[Check_AdjusterExist] 
(
	@AdjusterFirstName VARCHAR(50),
	@AdjusterLastName  VARCHAR(50)
)
AS
BEGIN
Select COUNT(*)		 from (
  
				SELECT     adjusterId, adjusterFirstName, adjusterLastName, adjusterPhone, adjusterFax, adjusterEmail
FROM         Liens.dbo.adjuster WITH (READPAST, ROWLOCK)
WHERE     (adjusterFirstName =  RTRIM(LTRIM(@AdjusterFirstName))) AND (adjusterLastName = RTRIM(LTRIM(@AdjusterLastName)))
			
			UNION ALL
		
			SELECT     AdjusterId, AdjusterFirstName, AdjusterLastName, AdjusterPhone, AdjusterFax, AdjusterEmail
                     
FROM         global.tblAdjusters WITH (READPAST, ROWLOCK)
WHERE     (AdjusterFirstName =  RTRIM(LTRIM(@AdjusterFirstName))) AND (AdjusterLastName =  RTRIM(LTRIM(@AdjusterLastName)))
			   ) as Adj
	
     
END

GO
/****** Object:  StoredProcedure [global].[Check_ClaimNumberExist]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Genius Jain
-- Create date: 07/21/2015
-- Description:	Check  ClaimNumber from Liens.dbo.lienFile and AR.dbo.tblFiles exist
-- =========================================================================================
-- [global].[Check_ClaimNumberExist] 'a'
CREATE PROCEDURE [global].[Check_ClaimNumberExist] 
(
	@ClaimNumber VARCHAR(50)
)
AS
BEGIN
select COUNT(*) from 
(
	SELECT lienFile.lienFileClaimNumber as ClaimNumber,lienFile.lienFileId as FileID FROM Liens.dbo.lienFile WITH(READPAST,ROWLOCK) 
			where lienFile.lienFileClaimNumber= RTRIM(LTRIM(@ClaimNumber))
			UNION ALL
	SELECT      ClaimNumber,FileID
	FROM         global.tblFiles WITH(READPAST,ROWLOCK) where tblFiles.ClaimNumber= RTRIM(LTRIM(@ClaimNumber)) and tblFiles.IsDeleted=0
			--	SELECT tblFiles.ClaimNumber  FROM AR.global.tblFiles WITH(READPAST,ROWLOCK)
		) as tbl	
			  
END

GO
/****** Object:  StoredProcedure [global].[Check_EmployerExist]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Genius Jain
-- Create date: 07/21/2015
-- Description:	Check  Employer from Liens.dbo.Employer and AR.dbo.Employer exist
-- =========================================================================================
-- [global].[Check_EmployerExist]  'Mast Ji'
CREATE PROCEDURE [global].[Check_EmployerExist]  
(
	@EmployerName VARCHAR(50)

)
AS
BEGIN
    Select COUNT(*) from (
		  
				SELECT     employerId as EmployerId, employerName as EmployerName
FROM         Liens.dbo.employer WITH (READPAST, ROWLOCK)
WHERE     (employerName =  RTRIM(LTRIM(@EmployerName))) 
			
		UNION ALL
		
				SELECT     EmployerId, EmployerName
FROM         global.tblEmployers WITH (READPAST, ROWLOCK)
WHERE     (EmployerName =  RTRIM(LTRIM(@EmployerName)))
) as emp
			   
	
     
END

GO
/****** Object:  StoredProcedure [global].[Check_InsurerBranchExist]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Genius Jain
-- Create date: 07/21/2015
-- Description:	Check  InsurerBranch from Liens.dbo.InsurerBranch and AR.dbo.InsurerBranch exist
-- =========================================================================================
CREATE PROCEDURE [global].[Check_InsurerBranchExist] 
(
	@InsurerBranchName VARCHAR(50)

)
AS
BEGIN
      Select COUNT(*)		 from (
		  
				SELECT     insurerBranchId, insurerId, insurerBranchName
FROM         Liens.dbo.insuranceBranch WITH (READPAST, ROWLOCK)
WHERE     (insurerBranchName =  RTRIM(LTRIM(@InsurerBranchName)))
			
			UNION ALL
		
			SELECT     InsurerBranchId, InsurerId, InsurerBranchName
FROM         global.tblInsurerBranches WITH (READPAST, ROWLOCK)
WHERE     (InsurerBranchName =  RTRIM(LTRIM(@InsurerBranchName)))
			   
			 ) as InsBrch
	
     
END

GO
/****** Object:  StoredProcedure [global].[Check_InsurerExist]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Genius Jain
-- Create date: 07/21/2015
-- Description:	Check  Insurer from Liens.dbo.InsuranceBilling and AR.dbo.Insurer exist
-- =========================================================================================
CREATE PROCEDURE [global].[Check_InsurerExist] 
(
	@InsurerName VARCHAR(50)
)
AS
BEGIN
       Select COUNT(*)		 from (
		   
				SELECT  insuranceBilling.InsurerID AS InsurerRowID,insuranceBilling.InsurerID,  insuranceBilling.insurerName as InsurerName  FROM Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) 
			where insuranceBilling.insurerName= RTRIM(LTRIM(@InsurerName))
			UNION ALL
		
				SELECT tblInsurers.InsurerID AS InsurerRowID,tblInsurers.InsurerID, tblInsurers.InsurerName FROM AR.global.tblInsurers WITH(READPAST,ROWLOCK)
			   where tblInsurers.InsurerName= RTRIM(LTRIM(@InsurerName))) as ins
			
		   
		
		
     
END

GO
/****** Object:  StoredProcedure [global].[Delete_FileAccToFielID]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 15 JULY 2015
-- Description : Delete from global.tblFiles
-- ===================================================================================
CREATE PROCEDURE [global].[Delete_FileAccToFielID]
	@FileID INT,
	@DeletedBy INT
AS
BEGIN
	UPDATE [global].[tblFiles] WITH(READPAST,ROWLOCK) SET [IsDeleted] = 1,[DeletedBy] = @DeletedBy,DeletedOn = GETDATE() WHERE [FileID]=@FileID
END

GO
/****** Object:  StoredProcedure [global].[Get_AdjusterByAdjusterID]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		TGosain
-- Create date: 11-25-2015
-- Description:	get adjuster detail from AR adjuster table
-- =============================================
create PROCEDURE [global].[Get_AdjusterByAdjusterID](@AdjusterId int)
AS
BEGIN	
	SET NOCOUNT ON;
		Select AdjusterId, AdjusterFirstName, AdjusterLastName, AdjusterPhone, AdjusterEmail 
		from [AR].[global].[tblAdjusters] WITH(READPAST,ROWLOCK) 
		where [AR].[global].[tblAdjusters].AdjusterId = @AdjusterId	
END

GO
/****** Object:  StoredProcedure [global].[Get_AllAdjuster]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Mahinder Singh
-- Create date: 07/03/2015
-- Description:	Get all Adjuster from Liens.dbo.Adjuster and AR.dbo.Adjuster
-- =========================================================================================
CREATE PROCEDURE [global].[Get_AllAdjuster]
(
	@AdjusterName VARCHAR(50),
	@Skip INT,        
	@Take INT
)
AS
BEGIN

          WITH AllAdjuster  AS
         (
            SELECT ROW_NUMBER() OVER(ORDER BY AdjusterRowID DESC)AS ROW,AdjusterId, AdjusterName, AdjusterFirstName, AdjusterLastName, AdjusterPhone,AdjusterFax,AdjusterEmail,DBNameAdjuster
            FROM
		    (       
				 SELECT adjuster.AdjusterId AS AdjusterRowID,adjuster.AdjusterId, adjuster.AdjusterFirstName, adjuster.AdjusterLastName, ( adjuster.AdjusterFirstName + ' '+ adjuster.AdjusterLastName )  AS AdjusterName,adjuster.AdjusterPhone,adjuster.AdjusterFax,adjuster.AdjusterEmail,'Lien' as DBNameAdjuster FROM Liens.dbo.adjuster WITH(READPAST,ROWLOCK) 
				
			UNION ALL

				 SELECT tblAdjusters.AdjusterId AS AdjusterRowID,tblAdjusters.AdjusterId, tblAdjusters.AdjusterFirstName, tblAdjusters.AdjusterLastName,(tblAdjusters.AdjusterFirstName +' ' + tblAdjusters.AdjusterLastName ) AS AdjusterName,tblAdjusters.AdjusterPhone,tblAdjusters.AdjusterFax,tblAdjusters.AdjusterEmail,'AR' as DBNameAdjuster FROM AR.global.tblAdjusters WITH(READPAST,ROWLOCK)
					   
					   
	         ) TBL 
	         WHERE (TBL.AdjusterName LIKE '%' + LTRIM(RTRIM(@AdjusterName))+ '%')
	      )
	      SELECT * FROM AllAdjuster AAD
	      WHERE AAD.ROW BETWEEN @Skip + 1 AND @Skip + @Take	 
END

GO
/****** Object:  StoredProcedure [global].[Get_AllAdjusterCount]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Mahinder Singh
-- Create date: 07/03/2015
-- Description:	Get all Adjuster from Liens.dbo.Adjuster and AR.dbo.Adjuster
-- =========================================================================================
CREATE PROCEDURE [global].[Get_AllAdjusterCount] 
(
	@AdjusterName VARCHAR(50)
)
AS
BEGIN

          
        SELECT COUNT(ROW) as TotalCount
        FROM
	    (       
			  SELECT ROW_NUMBER() OVER(ORDER BY AdjusterRowID DESC)AS ROW,AdjusterId, AdjusterName,AdjusterPhone,AdjusterFax,AdjusterEmail
              FROM
		      (       
					 SELECT adjuster.AdjusterId AS AdjusterRowID,adjuster.AdjusterId,  adjuster.AdjusterFirstName + ' '+ adjuster.AdjusterLastName  AS AdjusterName,adjuster.AdjusterPhone,adjuster.AdjusterFax,adjuster.AdjusterEmail FROM Liens.dbo.adjuster WITH(READPAST,ROWLOCK) 
					
				UNION ALL

					 SELECT tblAdjusters.AdjusterId AS AdjusterRowID,tblAdjusters.AdjusterId,tblAdjusters.AdjusterFirstName +' ' + tblAdjusters.AdjusterLastName AS AdjusterName,tblAdjusters.AdjusterPhone,tblAdjusters.AdjusterFax,tblAdjusters.AdjusterEmail FROM AR.global.tblAdjusters WITH(READPAST,ROWLOCK)
						   
					   
	         ) TBL 
	         WHERE (TBL.AdjusterName LIKE '%' + LTRIM(RTRIM(@AdjusterName))+ '%')
				   
         )AS Td
	       
END

GO
/****** Object:  StoredProcedure [global].[Get_AllColumnNameFromTblUploadTemps]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author      : Mahinder Singh
-- Create date : 15 MAY 2015
-- Description : Get All COLUMNNAME tblTempPatientBilling
-- ==============================================================================
CREATE PROCEDURE [global].[Get_AllColumnNameFromTblUploadTemps] 
	
AS
BEGIN
	SELECT COLUMN_NAME AS ColumnName , DATA_TYPE AS DataType
			FROM AR.INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = N'tblUploadTemps' AND COLUMN_NAME<>'UploadId' AND DATA_TYPE<>'bit'
END
GO
/****** Object:  StoredProcedure [global].[Get_AllColumnNameFromTblUploadTempsContractor]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author      : Mahinder Singh
-- Create date : 06 APRIL 2015
-- Description : Get All COLUMNNAME tblTempPatientBilling
-- ==============================================================================
CREATE PROCEDURE [global].[Get_AllColumnNameFromTblUploadTempsContractor] 
	
AS
BEGIN
	SELECT COLUMN_NAME AS ColumnName , DATA_TYPE AS DataType
			FROM AR.INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = N'tblUploadTempsContractor' AND COLUMN_NAME<>'UploadId' 
END
GO
/****** Object:  StoredProcedure [global].[Get_AllColumnNameFromTempPatient]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author      : Mahinder Singh
-- Create date : 06 APRIL 2015
-- Description : Get All COLUMNNAME tblTempPatientBilling
-- ==============================================================================
Create PROCEDURE [global].[Get_AllColumnNameFromTempPatient] 
	
AS
BEGIN
	SELECT COLUMN_NAME AS ColumnName , DATA_TYPE AS DataType
			FROM AR.INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = N'tblUploadTemps' AND DATA_TYPE<>'int' AND DATA_TYPE<>'bit'
END
GO
/****** Object:  StoredProcedure [global].[Get_AllEmployer]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Version : 1.1
-- Author     :	Mahinder Singh
-- Create date: 07/03/2015
-- Description:	Get all Employer from Liens.dbo.Employer and AR.dbo.tblEmployer

-- Revision History:
-- 1.1 -	17-11-2015 TGosain
--			User Story #2595: Add View Function
-- =========================================================================================
CREATE PROCEDURE [global].[Get_AllEmployer] 
(
	@EmployerName VARCHAR(50),
	@Skip INT,        
	@Take INT
)
AS
BEGIN
        WITH  AllEmployer AS
        (          
           SELECT ROW_NUMBER() Over(Order by EmployerRowID desc)as ROW,EmployerId,EmployerName, EmployerAddress, EmployerCity, EmployerStateName, EmployerZip, EmployerPhone, DBNameEmployer
           FROM
           (SELECT employer.EmployerId AS EmployerRowID, employer.EmployerId, employer.EmployerName, employerAddress1 as EmployerAddress, employerCity as EmployerCity
				 ,employerState as EmployerStateName, employerZip as EmployerZip, employerTelephone as EmployerPhone, 'Lien' as DBNameEmployer FROM  Liens.dbo.employer WITH(READPAST,ROWLOCK)
				 
			UNION ALL			
			
			SELECT tblEmployers.EmployerId AS EmployerRowID, tblEmployers.EmployerId, tblEmployers.EmployerName, EmployerAddress, EmployerCity, (select StateName from AR.lookup.States where AR.lookup.States.StateID = EmployerStateID) as EmployerStateName
			, EmployerZip, EmployerPhone, 'AR' as DBNameEmployer FROM AR.global.tblEmployers WITH(READPAST,ROWLOCK)				   
		    )AS TBL
		    WHERE (TBL.EmployerName LIKE '%' + LTRIM(RTRIM(@EmployerName))+ '%')
		  )
		  SELECT * FROM AllEmployer AE
		  WHERE AE.ROW BETWEEN @Skip + 1 AND @Skip + @Take 
END

GO
/****** Object:  StoredProcedure [global].[Get_AllEmployerCount]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Mahinder Singh
-- Create date: 07/03/2015
-- Description:	Get all Employer from Liens.dbo.Employer and AR.dbo.tblEmployer
-- =========================================================================================
CREATE PROCEDURE [global].[Get_AllEmployerCount] 
(
	@EmployerName VARCHAR(50)
)
AS
BEGIN
           
           SELECT COUNT(ROW) AS TotalCount
           FROM
           (
				   SELECT ROW_NUMBER() Over(Order by EmployerRowID desc)as ROW,EmployerId,EmployerName
				   FROM
				   (
					SELECT employer.EmployerId AS EmployerRowID,employer.EmployerId,employer.EmployerName  FROM  Liens.dbo.employer WITH(READPAST,ROWLOCK)
						  
					UNION ALL
					
					SELECT tblEmployers.EmployerId AS EmployerRowID,tblEmployers.EmployerId, tblEmployers.EmployerName  FROM AR.global.tblEmployers WITH(READPAST,ROWLOCK)
						   
					)AS TBL
					WHERE (TBL.EmployerName LIKE '%' + LTRIM(RTRIM(@EmployerName))+ '%')
		    )AS Ts
		  
END

GO
/****** Object:  StoredProcedure [global].[Get_AllFiles]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,10-07-2015>
-- Description:	<Description,,get all Files content >
-- =============================================
-- Author:		<Author,,Mahinder Singh>
-- Create date: <Create Date,,15 june 2017>
-- Description:	User Story #3087: AR Search Bar Update
-- =============================================
--[global].[Get_AllFiles]'gurleen',0,100 
CREATE PROCEDURE [global].[Get_AllFiles]
	(
	@SearchText varchar(100) = '%',
	@Skip int=null, 
	@Take int=null
	)
AS
BEGIN
 WITH AllFiles AS
  ( 
         select * , Row_number()over(order by (select 1)) RowNum  from(
                SELECT DISTINCT DBConnetion,FileID,FullName, FirstName , LastName , ClaimNumber, InsurerId, InsurerName, InsurerBranchId, insurerBranchName, EmployerId, EmployerName  
                FROM (
				select distinct DBConnetion,FileID, (FirstName + ' ' + LastName) AS FullName, FirstName , LastName , ClaimNumber, InsurerId, InsurerName, InsurerBranchId, insurerBranchName, EmployerId, EmployerName ,InvoiceNumber
						from (
							SELECT     'A' AS DBConnetion, global.tblFiles.FileID, ISNULL(global.tblFiles.FirstName,
                          (SELECT     lienFileClaimantFirstName
                            FROM          Liens.dbo.lienFile WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) AS FirstName, ISNULL(global.tblFiles.LastName,
                          (SELECT     lienFileClaimantLastName
                            FROM          Liens.dbo.lienFile AS lienFile_1 WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) AS LastName, global.tblFiles.ClaimNumber, global.tblFiles.InsurerId,  
                      global.tblFiles.IsLienClaimNumber, ISNULL
                          ((SELECT     InsurerName
                              FROM         global.tblInsurers WITH (READPAST, ROWLOCK)
                              WHERE     (InsurerId = global.tblFiles.InsurerId)),
                          (SELECT     insurerName
                            FROM          Liens.dbo.insuranceBilling WITH (READPAST, ROWLOCK)
                            WHERE      (insurerId = global.tblFiles.InsurerId))) AS InsurerName, global.tblFiles.InsurerBranchId, ISNULL
                          ((SELECT     InsurerBranchName
                              FROM         global.tblInsurerBranches WITH (READPAST, ROWLOCK)
                              WHERE     (InsurerBranchId = global.tblFiles.InsurerBranchId)),
                          (SELECT     insurerBranchName
                            FROM          Liens.dbo.insuranceBranch WITH (READPAST, ROWLOCK)
                            WHERE      (insurerBranchId = global.tblFiles.InsurerBranchId))) AS InsurerBranchName, global.tblFiles.EmployerId, ISNULL
                          ((SELECT     EmployerName
                              FROM         global.tblEmployers WITH (READPAST, ROWLOCK)
                              WHERE     (EmployerId = global.tblFiles.EmployerId)),
                          (SELECT     employerName
                            FROM          Liens.dbo.employer WITH (READPAST, ROWLOCK)
                            WHERE      (employerId = global.tblFiles.EmployerId))) AS EmployerName,
                      global.tblInvoices.InvoiceNumber 
					FROM         global.tblFiles WITH (READPAST, ROWLOCK) left JOIN
										  global.tblInvoices WITH(READPAST, ROWLOCK) ON global.tblFiles.FileID = global.tblInvoices.FileId
					WHERE     (ISNULL(global.tblFiles.IsDeleted, 0) = 0)
							) as t
						) AS m
			where (FullName like '%'+ RTRIM(LTRIM(@SearchText))+ '%' or  ClaimNumber like '%'+RTRIM(LTRIM(@SearchText))+'%' or InvoiceNumber like '%'+RTRIM(LTRIM(@SearchText))+'%')
			 )as tt
		)
                           
   
   SELECT * FROM AllFiles FLS
   WHERE FLS.RowNum BETWEEN @Skip + 1 AND @Skip + @Take
   
END

GO
/****** Object:  StoredProcedure [global].[Get_AllInsurer]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Version : 1.1
-- Author     :	Mahinder Singh
-- Create date: 07/03/2015
-- Description:	Get all Insurer from Liens.dbo.InsuranceBilling and AR.dbo.Insurer

-- Revision History:
-- 1.1 -	17-11-2015 TGosain
--			User Story #2595: Add View Function

-- =========================================================================================
--  [global].[Get_AllInsurer] '%', 1, 10
CREATE PROCEDURE [global].[Get_AllInsurer] 
(
	@InsurerName VARCHAR(50),
	@Skip INT,        
	@Take INT
)
AS
BEGIN
    WITH AllInsurer AS
    (
		SELECT   ROW_NUMBER() Over(Order by InsurerRowID desc)as Row,InsurerID, InsurerName, InsurerAddress, InsurerCity, InsurerStateName, InsurerZip, insurerPhone, DBNameInsurer
		FROM 
		(  
		SELECT  insuranceBilling.InsurerID AS InsurerRowID,insuranceBilling.InsurerID,  insuranceBilling.insurerName  as InsurerName, insurerAddress1 as InsurerAddress, insurerCity, insurerState as InsurerStateName
		, insurerZip, insurerPhone, 'Lien' as DBNameInsurer FROM Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) 
			
		UNION ALL
		
		SELECT tblInsurers.InsurerID AS InsurerRowID,tblInsurers.InsurerID, tblInsurers.InsurerName as InsurerName, InsurerAddress, insurerCity, (select StateName from AR.lookup.States where AR.lookup.States.StateID = InsurerStateID) as InsurerStateName
		, insurerZip, insurerPhone ,'AR' as DBNameInsurer	FROM AR.global.tblInsurers WITH(READPAST,ROWLOCK)
			   
		 )AS TBL
		 WHERE (TBL.InsurerName LIKE '%' + LTRIM(RTRIM(@InsurerName))+ '%')
     )
     SELECT * FROM AllInsurer AllIns
     WHERE AllIns.ROW BETWEEN @Skip + 1 AND @Skip + @Take
END

GO
/****** Object:  StoredProcedure [global].[Get_AllInsurerBranch]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================================================================
-- Version : 1.1
-- Author     :	Genius Jain
-- Create date: 07/10/2015
-- Description:	Get all InsurerBranch from Liens.dbo.InsuranceBranch and AR.dbo.tblInsurerBranches According to InsurerID
-- [global].[Get_AllInsurerBranch] '%',0,10

-- Revision History:
-- 1.1 -	17-11-2015 TGosain
--			User Story #2595: Add View Function
-- =======================================================================================================================
CREATE PROCEDURE [global].[Get_AllInsurerBranch] 
(
	@InsurerBranchName varchar(50),
	@Skip INT,        
	@Take INT
)
AS
BEGIN       
		
			BEGIN
			with AllInsurerBranch1 as(
			SELECT ROW_NUMBER() Over(Order by InsurerBranchRowID DESC)AS ROW,InsurerBranchId,InsurerId,InsurerBranchName, InsurerBranchAddress,  insurerBranchCity, insurerBranchStateName, insurerBranchZip, InsurerBranchPhone,DBNameInsurerBranch
			from
			(
				 
				SELECT insuranceBranch.InsurerBranchId AS InsurerBranchRowID,insuranceBranch.InsurerBranchId,insuranceBranch.InsurerId, insuranceBranch.InsurerBranchName   as InsurerBranchName 
				, insurerBranchAddress1 as InsurerBranchAddress, insurerBranchCity, insurerBranchState as InsurerBranchStateName, insurerBranchZip, insurerBranchTelephone as InsurerBranchPhone,'Lien' as DBNameInsurerBranch FROM  Liens.dbo.insuranceBranch WITH(READPAST,ROWLOCK)
				WHERE insuranceBranch.InsurerBranchName like '%' + @InsurerBranchName + '%'
				
				union all
				SELECT tblInsurerBranches.InsurerBranchId AS InsurerBranchRowID,tblInsurerBranches.InsurerBranchId,tblInsurerBranches.InsurerId, tblInsurerBranches.InsurerBranchName  as InsurerBranchName 
				, insurerBranchAddress , insurerBranchCity, (select StateName from AR.lookup.States where AR.lookup.States.StateID = InsurerBranchStateID) as insurerBranchStateName, insurerBranchZip, InsurerBranchPhone,'AR' as DBNameInsurerBranch FROM AR.global.tblInsurerBranches WITH(READPAST,ROWLOCK)				
					WHERE tblInsurerBranches.InsurerBranchName like '%' + @InsurerBranchName + '%' 			
			
			) as tbl1	
			)					
			SELECT * FROM  AllInsurerBranch1 AIB
			WHERE AIB.ROW BETWEEN @Skip + 1 AND @Skip + @Take
			END
		
END

GO
/****** Object:  StoredProcedure [global].[Get_AllInsurerBranchCount]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================================================================
-- Author     :	Genius jain
-- Create date: 07/20/2015
-- Description:	Get all InsurerBranch from Liens.dbo.InsuranceBranch and AR.dbo.tblInsurerBranches
-- =======================================================================================================================
CREATE PROCEDURE [global].[Get_AllInsurerBranchCount] 
(
	@InsurerBranchName varchar(50)
)
AS
BEGIN      
 select COUNT(*) from 
 (
			SELECT insuranceBranch.InsurerBranchId AS InsurerBranchRowID,insuranceBranch.InsurerBranchId,insuranceBranch.InsurerId, insuranceBranch.InsurerBranchName   as InsurerBranchName ,'Lien' as DBNameInsurerBranch FROM  Liens.dbo.insuranceBranch WITH(READPAST,ROWLOCK)
				WHERE insuranceBranch.InsurerBranchName like '%' + @InsurerBranchName + '%'
				--insuranceBranch.InsurerId = @InsurerId and 
				union all
				SELECT tblInsurerBranches.InsurerBranchId AS InsurerBranchRowID,tblInsurerBranches.InsurerBranchId,tblInsurerBranches.InsurerId, tblInsurerBranches.InsurerBranchName  as InsurerBranchName ,'AR' as DBNameInsurerBranch FROM AR.global.tblInsurerBranches WITH(READPAST,ROWLOCK)
					WHERE tblInsurerBranches.InsurerBranchName like '%' + @InsurerBranchName + '%' 
					) as GJ
				
				
END

GO
/****** Object:  StoredProcedure [global].[Get_AllInsurerCount]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Mahinder Singh
-- Create date: 07/03/2015
-- Description:	Get all Insurer from Liens.dbo.InsuranceBilling and AR.dbo.Insurer
-- =========================================================================================
CREATE PROCEDURE [global].[Get_AllInsurerCount] 
(
	@InsurerName VARCHAR(50)
)
AS
BEGIN
        SELECT COUNT(ROW) AS TotalCount
        FROM 
		(  
		    SELECT   ROW_NUMBER() Over(Order by InsurerRowID desc)as Row,InsurerID, InsurerName
			FROM 
			(  
				SELECT  insuranceBilling.InsurerID AS InsurerRowID,insuranceBilling.InsurerID,  insuranceBilling.insurerName as InsurerName  FROM Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) 
			
			UNION ALL
		
				SELECT tblInsurers.InsurerID AS InsurerRowID,tblInsurers.InsurerID, tblInsurers.InsurerName FROM AR.global.tblInsurers WITH(READPAST,ROWLOCK)
			   
			 )AS TBL
		     WHERE (TBL.InsurerName LIKE '%' + LTRIM(RTRIM(@InsurerName))+ '%')
		
		)AS TD
     
END

GO
/****** Object:  StoredProcedure [global].[Get_AllInvoice]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Rohit Kumar
-- Create date: 07/03/2015
-- Description:	Get all Invocie from Liens.dbo.InsuranceBilling and AR.dbo.Insurer
-- =========================================================================================
--  [global].[Get_AllInvoice] 1, 0, 10
CREATE PROCEDURE [global].[Get_AllInvoice] 
(
	@FileId int,	
	@Skip INT,        
	@Take INT
)
AS
BEGIN

			SELECT * from (SELECT  ROW_NUMBER() Over(Order by InvoiceID desc) as Row, InvoiceID as InvoiceRowID,   InvoiceID, FileID, InvoiceNumber, isnull(InvoiceAmt,0) as InvoiceAmt,isnull(InvoiceICAmt,0) as InvoiceICAmt, isnull( InvoiceBalanceAmt,0) as InvoiceBalanceAmt,  InvoiceDate,InvoiceDueDate, InvoiceSent, BillingWeek, DepartmentId,
			ISNULL(InvoiceBalanceAmt,0.00) as InvoiceBalance,
			isnull((SELECT      top 1 (AdjustmentAmt) FROM         global.tblInvoiceAdjustments  where InvoiceID = global.tblInvoices.InvoiceID order by AdjustmentId desc),0.00) as AdjustmentAmt,
			isnull((SELECT      top 1 (AdjustmentNotes) FROM         global.tblInvoiceAdjustments  where InvoiceID = global.tblInvoices.InvoiceID order by AdjustmentId desc),'') as AdjustmentNotes
			FROM         global.tblInvoices WITH(READPAST,ROWLOCK)where  FileId = @FileId ) tbl where   Row BETWEEN @Skip + 1 AND @Skip + @Take  
		
END

GO
/****** Object:  StoredProcedure [global].[Get_AllInvoiceIC]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Mahinder Singh
-- Create date: 02/23/2017
-- Description:	Get all Invocie from Liens.dbo.InsuranceBilling and AR.dbo.Insurer
-- =========================================================================================
--  [global].[Get_AllInvoiceIC]  39
CREATE PROCEDURE [global].[Get_AllInvoiceIC] 
(
 @FileId INT
)
AS
BEGIN
      SELECT ROW_NUMBER() Over(Order by fi.FileID  desc) as Row,fi.FileID,Inv.InvoiceID, (CASE WHEN fi.FirstName IS NULL THEN fi.FirstName 
			WHEN fi.LastName IS NULL THEN fi.LastName 
			ELSE (fi.FirstName + ' ' + fi.LastName) END) AS FileFullName,fi.ClaimNumber,Inv.InvoiceNumber,Inv.InvoiceAmt,Inv.InvoiceICAmt,fi.DepartmentID FROM AR.global.tblInvoices Inv WITH(READPAST,ROWLOCK)
			INNER JOIN AR.global.tblFiles  fi WITH(READPAST,ROWLOCK) ON Inv.FileId = fi.FileID 
			WHERE  Inv.InvoiceID in (SELECT InvoiceID FROM global.tblInvoices Invoic WHERE Invoic.UserCredibility = @FileId)
				and inv.AssignedToInvoiceID is null
		
END

GO
/****** Object:  StoredProcedure [global].[Get_AllLienClientBilling]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RKumar
-- Create date: 04-25-2017
-- Description:	get Client Billing details
-- =============================================
--[global].[Get_AllLienClientBilling]
CREATE PROCEDURE [global].[Get_AllLienClientBilling]
AS
 
BEGIN

SELECT   * FROM            (

SELECT     insuranceBranch.insurerBranchId as ID, insuranceBranch.insurerBranchName as LienClientName, ClientBilling.clientBillingID as LienClientID, 'INSURANCEBRANCH' as Tablename
FROM         Liens.dbo.insuranceBranch INNER JOIN
                      Liens.dbo.ClientBilling ON insuranceBranch.insurerBranchId = ClientBilling.insuranceBranchID
WHERE     (insuranceBranch.IsClient = 1)
--ORDER BY insuranceBranch.insurerBranchName
 union
SELECT     employer.employerId as ID, employer.employerName as LienClientName, ClientBilling.clientBillingID as LienClientID , 'EMPLOYER' as Tablename
FROM         Liens.dbo.employer INNER JOIN
                      Liens.dbo.ClientBilling ON employer.employerId = ClientBilling.employerID
WHERE     (employer.IsClient = 1)
--ORDER BY employer.employerName
union 
SELECT     defenseAttorney.defenseAttorneyId as ID, 
                      defenseAttorney.defenseAttorneyFirstName + ' ' + defenseAttorney.defenseAttorneyLastName as LienClientName, 
                      ClientBilling.clientBillingID as LienClientID , 'DEFENSEATTORNEY' as Tablename
FROM         Liens.dbo.defenseAttorney INNER JOIN
                      Liens.dbo.ClientBilling ON defenseAttorney.defenseAttorneyId = ClientBilling.defenseAttorneyid
WHERE     (defenseAttorney.IsClient = 1)
--ORDER BY defenseAttorneyName
) tbl
--ORDER BY insuranceBilling.insurerName

ORDER BY LienClientName

 end



GO
/****** Object:  StoredProcedure [global].[Get_AllLienTempRecords]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Rohit Kumar
-- Create date: 08/12/2015
-- Description:	Get all the Lien temp table data 
-- =========================================================================================
-- [global].[Get_AllLienTempRecords] 0,10
CREATE PROCEDURE [global].[Get_AllLienTempRecords] 
(
	@Skip INT,        
	@Take INT
)
AS
BEGIN
       WITH  AllLienTemp AS
        (          
			SELECT     Claim, FirstName, LastName, Insurer, InsurerBranch, Employer, Adjuster, InvoiceNumber, InvoiceAmount, InvoiceDate, InvoiceSent, BillingWeek, 
                      InvoiceDept, PaymentAmount, PaymentReceived, CheckNumber, LienDataValidate, Reason, PendingUploadId, 
                      
                      (case when lower(FirstName)= 'update' then  cast(1 as bit) else cast(0 as bit) end)  as IsFirstNameUpdate,
                      (case when lower(LastName)= 'update' then cast(1 as bit) else cast(0 as bit) end)  as IsLastNameUpdate,
                      (case when lower(Insurer)= 'update' then cast(1 as bit) else cast(0 as bit) end)  as IsInsurerUpdate,
					(case when lower(InsurerBranch)= 'update' then cast(1 as bit) else cast(0 as bit) end)  asIsInsurerBranchUpdate,
                      (case when lower(Employer)= 'update' then cast(1 as bit) else cast(0 as bit) end)  as IsEmployerUpdate,
                      (case when lower(Adjuster)= 'update' then cast(1 as bit) else cast(0 as bit) end)  as IsAdjusterUpdate ,
                      ROW_NUMBER() OVER(ORDER BY ltrim(rtrim(claim)) )AS ROW,  UploadId 
                      
			FROM      global.tblLienTempTables with(READPAST,ROWLOCK)   
		)
		SELECT * FROM AllLienTemp AL
		WHERE AL.ROW BETWEEN @Skip + 1 AND @Skip + @Take
		
		--ORDER BY REVERSE(SUBSTRING(REVERSE(Claim),1+CHARINDEX('-',REVERSE(Claim)),LEN(Claim))) 
  --  -- AffixAsInt
  --  ,CAST(
  --      SUBSTRING(Claim,2+LEN(SUBSTRING(REVERSE(Claim),1+CHARINDEX('-',REVERSE(Claim)),LEN(Claim))),LEN(Claim))
  --      AS int)
END

GO
/****** Object:  StoredProcedure [global].[Get_AssignedInvoicedByInvoiceID]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	TGosain
-- Create date: 04/21/2017
-- Description:	To get invoice records which are assigned to given InvoiceID
-- Used In :- 
--		FileController/UpdateAssignedToInvoiceID  - (When opening the popup to view invoice detail on file Index page)

-- =========================================================================================
--  [global].[Update_AssignedToInvoiceIDByInvoiceID] 31,2
Create PROCEDURE [global].[Get_AssignedInvoicedByInvoiceID] 
(
 @InvoiceID INT
)
AS
BEGIN
       SELECT ROW_NUMBER() Over(Order by fi.FileID  desc) as Row,fi.FileID,Inv.InvoiceID, (CASE WHEN fi.FirstName IS NULL THEN fi.FirstName 
			WHEN fi.LastName IS NULL THEN fi.LastName 
			ELSE (fi.FirstName + ' ' + fi.LastName) END) AS FileFullName,fi.ClaimNumber,Inv.InvoiceNumber,Inv.InvoiceAmt,Inv.InvoiceICAmt,fi.DepartmentID FROM AR.global.tblInvoices Inv WITH(READPAST,ROWLOCK)
			INNER JOIN AR.global.tblFiles  fi WITH(READPAST,ROWLOCK) ON Inv.FileId = fi.FileID 
			WHERE  inv.AssignedToInvoiceID  = @InvoiceID
END

GO
/****** Object:  StoredProcedure [global].[Get_CommissionDashboardRecord]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Rohit Kumar
-- Create date: 05/02/2017
-- Description:	Get Upcoming Commissions Dashboard
-- =========================================================================================
-- [global].[Get_CommissionDashboardRecord] 0,100

CREATE PROCEDURE [global].[Get_CommissionDashboardRecord]
(
	@Skip INT,        
	@Take INT
)
AS
BEGIN
			Select * from(
    Select ROW_NUMBER() OVER(	   order by CDueDate, LienClientName )AS ROWNUMBER, * from (

			SELECT distinct global.tblCommissions.LienCStartDate, global.tblCommissions.LienCEndDate, DATEPART(QUARTER,InvoiceDate) as InvoiceDateQuater,
			global.tblCommissions.LienCName, ltrim(rtrim(global.tblCommissions.LienClientName)) as LienClientName, global.tblCommissions.LienCPrecentage,
			dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) )) AS 'CDueDate',
			year(dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) ))) AS 'CDueYear',
            sum(global.tblInvoices.InvoiceAmt) as CTotalInvoicedAmount , sum( global.tblInvoices.InvoiceBalanceAmt) as CInvoiceBalanceAmt, 
			isnull((((sum( global.tblInvoices.InvoiceAmt) - sum( global.tblInvoices.InvoiceBalanceAmt)))
			 * (global.tblCommissions.LienCPrecentage / 100)),0) as CAmountDue, 
			 (sum( global.tblInvoices.InvoiceAmt) - sum( global.tblInvoices.InvoiceBalanceAmt) ) as  PaymentAmount,
			 isnull(global.tblCommissionPayments.IsPaymentRecevied,0) as IsPaymentRecevied ,global.tblCommissions.LienCClientID, global.tblCommissions.CommissionID 
			 -- selct
			FROM         global.tblCommissions INNER JOIN
                         global.tblInvoices ON global.tblCommissions.LienCClientID = global.tblInvoices.LienClientID left JOIN
                         global.tblCommissionPayments ON global.tblCommissions.CommissionID = global.tblCommissionPayments.CommissionID AND 
                         global.tblCommissionPayments.InvoiceDateQuarter = DATEPART(QUARTER, global.tblInvoices.InvoiceDate)
			WHERE    isnull(IsPaymentRecevied,0) = 0  AND 
			(global.tblInvoices.InvoiceDate BETWEEN global.tblCommissions.LienCStartDate AND 
			global.tblCommissions.LienCEndDate)
			group by   LienCName, LienClientName, LienCPrecentage,LienCClientID,global.tblCommissions.CommissionID ,IsPaymentRecevied ,LienCStartDate, LienCEndDate, DATEPART(QUARTER,InvoiceDate)
			)tbl 
			where CAmountDue > 0 
			  ) tbl2

			where  
                    ROWNUMBER BETWEEN @Skip + 1 AND @Skip + @Take	
				

END





-- 			select * from(
--Select ROW_NUMBER() OVER(	   order by CDueDate, LienClientName )AS ROWNUMBER, * from (

--			SELECT global.tblCommissions.LienCStartDate, global.tblCommissions.LienCEndDate, DATEPART(QUARTER,InvoiceDate) as InvoiceDateQuater,
--			global.tblCommissions.LienCName, ltrim(rtrim(global.tblCommissions.LienClientName)) as LienClientName, global.tblCommissions.LienCPrecentage,
--			dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) )) AS 'CDueDate',
--			year(dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) ))) AS 'CDueYear',
--            global.tblCommissions.LienCClientID, global.tblCommissions.CommissionID   , sum( global.tblInvoices.InvoiceAmt) as CTotalInvoicedAmount,
--			(sum( global.tblInvoices.InvoiceAmt) * ( global.tblCommissions.LienCPrecentage / 100)) as CAmountDue, isnull(global.tblCommissionPayments.IsPaymentRecevied,0) as IsPaymentRecevied
--			FROM            global.tblCommissions INNER JOIN
--                         global.tblInvoices ON global.tblCommissions.LienCClientID = global.tblInvoices.LienClientID left JOIN
--                         global.tblCommissionPayments ON global.tblCommissions.CommissionID = global.tblCommissionPayments.CommissionID
--						 and global.tblCommissionPayments.InvoiceDateQuarter = DATEPART(QUARTER,InvoiceDate)
--			WHERE  isnull(IsPaymentRecevied,0) = 0  AND 
--			(global.tblInvoices.InvoiceDate BETWEEN global.tblCommissions.LienCStartDate AND 
--			global.tblCommissions.LienCEndDate)
--			group by	LienCStartDate, LienCEndDate, DATEPART(QUARTER,InvoiceDate), LienCName, LienClientName, LienCPrecentage,LienCClientID,  global.tblCommissions.CommissionID ,IsPaymentRecevied


--)tbl ) tbl2








 
 
GO
/****** Object:  StoredProcedure [global].[Get_CommissionDashboardRecordCount]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Rohit Kumar
-- Create date: 05/02/2017
-- Description:	Get Upcoming Commissions Dashboard
-- =========================================================================================
-- [global].[Get_CommissionDashboardRecordCount]

CREATE PROCEDURE [global].[Get_CommissionDashboardRecordCount]
AS
BEGIN 
 
 
			Select count(*) from(
				Select ROW_NUMBER() OVER(	   order by CDueDate, LienClientName )AS ROWNUMBER, * from (

			SELECT distinct global.tblCommissions.LienCStartDate, global.tblCommissions.LienCEndDate, DATEPART(QUARTER,InvoiceDate) as InvoiceDateQuater,
			global.tblCommissions.LienCName, ltrim(rtrim(global.tblCommissions.LienClientName)) as LienClientName, global.tblCommissions.LienCPrecentage,
			dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) )) AS 'CDueDate',
			year(dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) ))) AS 'CDueYear',
            sum(global.tblInvoices.InvoiceAmt) as CTotalInvoicedAmount , sum( global.tblInvoices.InvoiceBalanceAmt) as CInvoiceBalanceAmt, 
			isnull((((sum( global.tblInvoices.InvoiceAmt) - sum( global.tblInvoices.InvoiceBalanceAmt)))
			 * (global.tblCommissions.LienCPrecentage / 100)),0) as CAmountDue, 
			 (sum( global.tblInvoices.InvoiceAmt) - sum( global.tblInvoices.InvoiceBalanceAmt) ) as  PaymentAmount,
			 isnull(global.tblCommissionPayments.IsPaymentRecevied,0) as IsPaymentRecevied ,global.tblCommissions.LienCClientID, global.tblCommissions.CommissionID 
			 -- selct
			FROM         global.tblCommissions INNER JOIN
                         global.tblInvoices ON global.tblCommissions.LienCClientID = global.tblInvoices.LienClientID left JOIN
                         global.tblCommissionPayments ON global.tblCommissions.CommissionID = global.tblCommissionPayments.CommissionID AND 
                         global.tblCommissionPayments.InvoiceDateQuarter = DATEPART(QUARTER, global.tblInvoices.InvoiceDate)
			WHERE    isnull(IsPaymentRecevied,0) = 0  AND 
			(global.tblInvoices.InvoiceDate BETWEEN global.tblCommissions.LienCStartDate AND 
			global.tblCommissions.LienCEndDate)
			group by   LienCName, LienClientName, LienCPrecentage,IsPaymentRecevied ,LienCClientID,global.tblCommissions.CommissionID ,LienCStartDate, LienCEndDate, DATEPART(QUARTER,InvoiceDate)
			)tbl 
			where CAmountDue > 0 
			  ) tbl2

END

GO
/****** Object:  StoredProcedure [global].[Get_CommissionRecordByLienClientID]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RKumar
-- Create date: 04-25-2017
-- Description:	Get All Commission By LienClientID
-- =============================================

-- [global].[Get_CommissionRecordByLienClientID] 95,0,100
CREATE PROCEDURE [global].[Get_CommissionRecordByLienClientID](@LienClientID int, @Skip int, @Take int )
AS
BEGIN	
	SET NOCOUNT ON;

			Select * from(
			Select ROW_NUMBER() OVER(	   order by CDueDate, LienClientName )AS ROWNUMBER, * from (
			SELECT distinct global.tblCommissions.LienCStartDate, global.tblCommissions.LienCEndDate, DATEPART(QUARTER,InvoiceDate) as InvoiceDateQuater,
			global.tblCommissions.LienCName, ltrim(rtrim(global.tblCommissions.LienClientName)) as LienClientName, global.tblCommissions.LienCPrecentage,
			dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) )) AS 'CDueDate',
			year(dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) ))) AS 'CDueYear',
            sum(global.tblInvoices.InvoiceAmt) as CTotalInvoicedAmount , sum( global.tblInvoices.InvoiceBalanceAmt) as CInvoiceBalanceAmt, 
			isnull((((sum( global.tblInvoices.InvoiceAmt) - sum( global.tblInvoices.InvoiceBalanceAmt)))
			 * (global.tblCommissions.LienCPrecentage / 100)),0) as CAmountDue, 
			 (sum( global.tblInvoices.InvoiceAmt) - sum( global.tblInvoices.InvoiceBalanceAmt) ) as  PaymentAmount,
			 isnull(global.tblCommissionPayments.IsPaymentRecevied,0) as IsPaymentRecevied ,global.tblCommissions.LienCClientID , global.tblCommissions.CommissionID
			 -- selct
			FROM         global.tblCommissions INNER JOIN
                         global.tblInvoices ON global.tblCommissions.LienCClientID = global.tblInvoices.LienClientID left JOIN
                         global.tblCommissionPayments ON global.tblCommissions.CommissionID = global.tblCommissionPayments.CommissionID AND 
                         global.tblCommissionPayments.InvoiceDateQuarter = DATEPART(QUARTER, global.tblInvoices.InvoiceDate)
			WHERE   (global.tblInvoices.LienClientID = @LienClientID)   AND 
			(global.tblInvoices.InvoiceDate BETWEEN global.tblCommissions.LienCStartDate AND 
			global.tblCommissions.LienCEndDate)
			group by   LienCName, LienClientName, LienCPrecentage,LienCClientID,  global.tblCommissions.CommissionID,IsPaymentRecevied ,LienCStartDate, LienCEndDate, DATEPART(QUARTER,InvoiceDate)
			)tbl 
			where CAmountDue > 0 
			  ) tbl2



			where  
                       ROWNUMBER BETWEEN @Skip + 1 AND @Skip + @Take	
                 
END

 

-- select * from(
--			Select ROW_NUMBER() OVER(	     order by CDueDate, LienClientName )AS ROWNUMBER, * from (

--			SELECT global.tblCommissions.LienCStartDate, global.tblCommissions.LienCEndDate, DATEPART(QUARTER,InvoiceDate) as InvoiceDateQuater,
--			global.tblCommissions.LienCName, ltrim(rtrim(global.tblCommissions.LienClientName)) as LienClientName, global.tblCommissions.LienCPrecentage,
--			dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) )) AS 'CDueDate',
--			year(dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) ))) AS 'CDueYear',
--            global.tblCommissions.LienCClientID, global.tblCommissions.CommissionID   , sum( global.tblInvoices.InvoiceAmt) as CTotalInvoicedAmount,
--			(sum( global.tblInvoices.InvoiceAmt) * ( global.tblCommissions.LienCPrecentage / 100)) as CAmountDue, isnull(global.tblCommissionPayments.IsPaymentRecevied,0) as IsPaymentRecevied
--			FROM            global.tblCommissions INNER JOIN
--                         global.tblInvoices ON global.tblCommissions.LienCClientID = global.tblInvoices.LienClientID left JOIN
--                         global.tblCommissionPayments ON global.tblCommissions.CommissionID = global.tblCommissionPayments.CommissionID
--						 and global.tblCommissionPayments.InvoiceDateQuarter = DATEPART(QUARTER,InvoiceDate)
--			WHERE       (global.tblInvoices.LienClientID = @LienClientID) AND 
--			(global.tblInvoices.InvoiceDate BETWEEN global.tblCommissions.LienCStartDate AND 
--			global.tblCommissions.LienCEndDate) --and isnull(IsPaymentRecevied,0) = 0
--			group by	LienCStartDate, LienCEndDate, DATEPART(QUARTER,InvoiceDate), LienCName, LienClientName, LienCPrecentage,LienCClientID,  global.tblCommissions.CommissionID ,IsPaymentRecevied
			 

--)tbl ) tbl2
GO
/****** Object:  StoredProcedure [global].[Get_CommissionRecordByLienClientIDCount]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RKumar
-- Create date: 04-25-2017
-- Description:	Get All Commission By LienClientID count
-- =============================================
--[global].[Get_CommissionRecordByLienClientIDCount] 95
CREATE PROCEDURE [global].[Get_CommissionRecordByLienClientIDCount](@LienClientID int)
AS
BEGIN	
	SET NOCOUNT ON;

	 	
			Select count(*) from(
			Select ROW_NUMBER() OVER(	   order by CDueDate, LienClientName )AS ROWNUMBER, * from (
			SELECT distinct global.tblCommissions.LienCStartDate, global.tblCommissions.LienCEndDate, DATEPART(QUARTER,InvoiceDate) as InvoiceDateQuater,
			global.tblCommissions.LienCName, ltrim(rtrim(global.tblCommissions.LienClientName)) as LienClientName, global.tblCommissions.LienCPrecentage,
			dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) )) AS 'CDueDate',
			year(dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) ))) AS 'CDueYear',
            sum(global.tblInvoices.InvoiceAmt) as CTotalInvoicedAmount , sum( global.tblInvoices.InvoiceBalanceAmt) as CInvoiceBalanceAmt, 
			isnull((((sum( global.tblInvoices.InvoiceAmt) - sum( global.tblInvoices.InvoiceBalanceAmt)))
			 * (global.tblCommissions.LienCPrecentage / 100)),0) as CAmountDue, 
			 (sum( global.tblInvoices.InvoiceAmt) - sum( global.tblInvoices.InvoiceBalanceAmt) ) as  PaymentAmount,
			 isnull(global.tblCommissionPayments.IsPaymentRecevied,0) as IsPaymentRecevied 
			 -- selct
			FROM         global.tblCommissions INNER JOIN
                         global.tblInvoices ON global.tblCommissions.LienCClientID = global.tblInvoices.LienClientID left JOIN
                         global.tblCommissionPayments ON global.tblCommissions.CommissionID = global.tblCommissionPayments.CommissionID AND 
                         global.tblCommissionPayments.InvoiceDateQuarter = DATEPART(QUARTER, global.tblInvoices.InvoiceDate)
			WHERE   (global.tblInvoices.LienClientID = @LienClientID)   AND 
			(global.tblInvoices.InvoiceDate BETWEEN global.tblCommissions.LienCStartDate AND 
			global.tblCommissions.LienCEndDate)
			group by   LienCName, LienClientName, LienCPrecentage,IsPaymentRecevied ,LienCStartDate, LienCEndDate, DATEPART(QUARTER,InvoiceDate)
			)tbl 
			where CAmountDue > 0 
			  ) tbl2
			 
END


--select count(*) from (
--			 Select ROW_NUMBER() OVER(	  order by CDueYear,InvoiceDateQuater , ltrim(rtrim(LienClientName)) )AS ROWNUMBER, * from (

--			SELECT global.tblCommissions.LienCStartDate, global.tblCommissions.LienCEndDate, DATEPART(QUARTER,InvoiceDate) as InvoiceDateQuater,
--			global.tblCommissions.LienCName, ltrim(rtrim(global.tblCommissions.LienClientName)) as LienClientName, global.tblCommissions.LienCPrecentage,
--			dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) )) AS 'CDueDate',
--			year(dateadd(day,29,(select dateadd(M, 3*number, CONVERT(date, CONVERT(varchar(5),year(LienCEndDate))+'-1-1')) from master..spt_values where type='p' and number  = DATEPART(QUARTER,InvoiceDate) ))) AS 'CDueYear',
--            global.tblCommissions.LienCClientID, global.tblCommissions.CommissionID   , sum( global.tblInvoices.InvoiceAmt) as CTotalInvoicedAmount,
--			(sum( global.tblInvoices.InvoiceAmt) * ( global.tblCommissions.LienCPrecentage / 100)) as CAmountDue, isnull(global.tblCommissionPayments.IsPaymentRecevied,0) as IsPaymentRecevied
--			FROM            global.tblCommissions INNER JOIN
--                         global.tblInvoices ON global.tblCommissions.LienCClientID = global.tblInvoices.LienClientID left JOIN
--                         global.tblCommissionPayments ON global.tblCommissions.CommissionID = global.tblCommissionPayments.CommissionID
--						 and global.tblCommissionPayments.InvoiceDateQuarter = DATEPART(QUARTER,InvoiceDate)
--			WHERE       (global.tblInvoices.LienClientID = @LienClientID) AND 
--			(global.tblInvoices.InvoiceDate BETWEEN global.tblCommissions.LienCStartDate AND 
--			global.tblCommissions.LienCEndDate)
--			group by	LienCStartDate, LienCEndDate, DATEPART(QUARTER,InvoiceDate), LienCName, LienClientName, LienCPrecentage,LienCClientID,  global.tblCommissions.CommissionID ,IsPaymentRecevied
--			)tbl)tbl2
--	       --where  isnull(IsPaymentRecevied,0) = 0
GO
/****** Object:  StoredProcedure [global].[Get_FileDetailByFileId]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rohit Kumar
-- Create date: 08-18-2015
-- Description:	Get File Detail By FileId
-- =============================================
-- [global].[Get_FileDetailByFileId] 17
CREATE PROCEDURE [global].[Get_FileDetailByFileId]
	(
	@FileId int
	
	)
AS
BEGIN

		SELECT --'A' as DbName,
		[AR].[global].[tblFiles].FileID,
		isnull([FirstName],(SELECT lienFileClaimantFirstName FROM  Liens.dbo.lienFile WITH(READPAST,ROWLOCK) where  Liens.dbo.lienFile.lienFileClaimNumber = [AR].[global].[tblFiles].ClaimNumber)) as FirstName,
		isnull([LastName],(SELECT lienFileClaimantLastName FROM  Liens.dbo.lienFile WITH(READPAST,ROWLOCK) where  Liens.dbo.lienFile.lienFileClaimNumber = [AR].[global].[tblFiles].ClaimNumber)) as LastName,
		[AR].[global].[tblFiles].ClaimNumber, 
		[AR].[global].[tblFiles].InsurerID,
		[AR].[global].[tblFiles].DepartmentID,
		[AR].[global].[tblFiles].Notes,
		
		(CASE 
		when [AR].[global].[tblFiles].IsLienInsurerID  = 1 then
		(SELECT  insurerName FROM Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) where Liens.dbo.insuranceBilling.insurerId = [AR].[global].[tblFiles].InsurerID) 
		else
		(SELECT  [InsurerName]FROM [AR].[global].[tblInsurers] WITH(READPAST,ROWLOCK) where [AR].[global].[tblInsurers].InsurerId = [AR].[global].[tblFiles].InsurerID)  
		end ) InsurerName,

		[AR].[global].[tblFiles].InsurerBranchID, 

		(CASE 
		when [AR].[global].[tblFiles].IsLienInsurerBranchID  = 1 then
		(select insurerBranchName from Liens.dbo.insuranceBranch WITH(READPAST,ROWLOCK) where Liens.dbo.insuranceBranch.insurerBranchId = [AR].[global].[tblFiles].InsurerBranchID)
		else
		(SELECT InsurerBranchName FROM [AR].[global].[tblInsurerBranches] WITH(READPAST,ROWLOCK) where [AR].[global].[tblInsurerBranches].InsurerBranchId = [AR].[global].[tblFiles].InsurerBranchID) 
		end ) InsurerBranchName,
		[AR].[global].[tblFiles].EmployerID, 

		(CASE 
		when [AR].[global].[tblFiles].IsLienEmployerID  = 1 then
		(select employerName from Liens.dbo.employer WITH(READPAST,ROWLOCK) where Liens.dbo.employer.employerId = [AR].[global].[tblFiles].EmployerID)
		else
		(SELECT EmployerName FROM [AR].[global].[tblEmployers] WITH(READPAST,ROWLOCK) where [AR].[global].[tblEmployers].EmployerId = [AR].[global].[tblFiles].EmployerID)  
		end ) EmployerName,
		 AdjusterId,
		(CASE 
		when [AR].[global].[tblFiles].IsLienAdjusterID  = 1 then
		(select (case when isnull(adjusterLastName,'0')!='0' then (adjusterFirstName +' '+adjusterLastName ) else adjusterFirstName end ) from Liens.dbo.adjuster WITH(READPAST,ROWLOCK) where Liens.dbo.adjuster.adjusterId = [AR].[global].[tblFiles].AdjusterId)
		else
		(Select (case when isnull(adjusterLastName,'0')!='0' then (adjusterFirstName +' '+adjusterLastName ) else adjusterFirstName end ) from [AR].[global].[tblAdjusters] WITH(READPAST,ROWLOCK) where [AR].[global].[tblAdjusters].AdjusterId = [AR].[global].[tblFiles].AdjusterId) 
		end ) AdjusterName,
		[AR].[global].[tblFiles].IsLienInsurerID, 
		[AR].[global].[tblFiles].IsLienInsurerBranchID, 
		[AR].[global].[tblFiles].IsLienEmployerID, 
		[AR].[global].[tblFiles].IsLienAdjusterID,
		[AR].[global].[tblFiles].IsLienClaimNumber,
		ISNULL(tblICRD.ICRecordDetailID,0) AS ICRecordDetailID,
		tblICRD.ICRecordDetailAddress,
		tblICRD.ICRecordDetailCity,
		ISNULL(tblICRD.StateID,0) AS StateID,
		tblICRD.ICRecordDetailZip,
		tblICRD.ICRecordDetailTaxID
		FROM [AR].[global].[tblFiles] WITH(READPAST,ROWLOCK) LEFT JOIN
		[AR].[global].[tblICRecordDetails]  tblICRD ON [global].[tblFiles].FileID=tblICRD.FileID
		where  [global].[tblFiles].FileID = @FileId  and [IsDeleted]=0 
		end
		 
GO
/****** Object:  StoredProcedure [global].[Get_FilesCount]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,07-10-2015>
-- Description:	<Description,,get Files Count >
-- =============================================
-- [global].[Get_FilesCount]'%' 
CREATE PROCEDURE [global].[Get_FilesCount]--'%' 
	(@SearchText varchar(20)='%')
AS
BEGIN select count(*)  from(

		      select * , Row_number()over(order by (select 1)) RowNum  from(
				 SELECT DISTINCT DBConnetion,FileID,FullName, FirstName , LastName , ClaimNumber, InsurerId, InsurerName, InsurerBranchId, insurerBranchName, EmployerId, EmployerName  
                FROM (
				select distinct DBConnetion,FileID, (FirstName + ' ' + LastName) AS FullName, FirstName , LastName , ClaimNumber, InsurerId, InsurerName, InsurerBranchId, insurerBranchName, EmployerId, EmployerName ,InvoiceNumber
						from (
							SELECT     'A' AS DBConnetion, global.tblFiles.FileID, ISNULL(global.tblFiles.FirstName,
                          (SELECT     lienFileClaimantFirstName
                            FROM          Liens.dbo.lienFile WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) AS FirstName, ISNULL(global.tblFiles.LastName,
                          (SELECT     lienFileClaimantLastName
                            FROM          Liens.dbo.lienFile AS lienFile_1 WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) AS LastName, global.tblFiles.ClaimNumber, global.tblFiles.InsurerId,  
                      global.tblFiles.IsLienClaimNumber, ISNULL
                          ((SELECT     InsurerName
                              FROM         global.tblInsurers WITH (READPAST, ROWLOCK)
                              WHERE     (InsurerId = global.tblFiles.InsurerId)),
                          (SELECT     insurerName
                            FROM          Liens.dbo.insuranceBilling WITH (READPAST, ROWLOCK)
                            WHERE      (insurerId = global.tblFiles.InsurerId))) AS InsurerName, global.tblFiles.InsurerBranchId, ISNULL
                          ((SELECT     InsurerBranchName
                              FROM         global.tblInsurerBranches WITH (READPAST, ROWLOCK)
                              WHERE     (InsurerBranchId = global.tblFiles.InsurerBranchId)),
                          (SELECT     insurerBranchName
                            FROM          Liens.dbo.insuranceBranch WITH (READPAST, ROWLOCK)
                            WHERE      (insurerBranchId = global.tblFiles.InsurerBranchId))) AS InsurerBranchName, global.tblFiles.EmployerId, ISNULL
                          ((SELECT     EmployerName
                              FROM         global.tblEmployers WITH (READPAST, ROWLOCK)
                              WHERE     (EmployerId = global.tblFiles.EmployerId)),
                          (SELECT     employerName
                            FROM          Liens.dbo.employer WITH (READPAST, ROWLOCK)
                            WHERE      (employerId = global.tblFiles.EmployerId))) AS EmployerName,
                      global.tblInvoices.InvoiceNumber 
					FROM         global.tblFiles WITH (READPAST, ROWLOCK) left JOIN
										  global.tblInvoices ON global.tblFiles.FileID = global.tblInvoices.FileId
					WHERE     (ISNULL(global.tblFiles.IsDeleted, 0) = 0)
							) as t
						) AS m
			where (FullName like '%'+ RTRIM(LTRIM(@SearchText))+ '%' or  ClaimNumber like '%'+RTRIM(LTRIM(@SearchText))+'%' or InvoiceNumber like '%'+RTRIM(LTRIM(@SearchText))+'%')
			 )as tt
	 

) tbll
END

GO
/****** Object:  StoredProcedure [global].[Get_InvoiceDetailByInvoiceID]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Rohit Kumar
-- Create date: 11/16/2015
-- Description:	Get Invoice Detail By InvoiceID
-- =========================================================================================
-- [global].[Get_InvoiceDetailByInvoiceID] 19,0,10
CREATE PROCEDURE [global].[Get_InvoiceDetailByInvoiceID]
(
	@InvoiceID int,
	@Skip INT,        
	@Take INT
)
AS
BEGIN

		   select * from (
			SELECT   ROW_NUMBER() OVER(ORDER BY InvoiceNotesID DESC)AS ROWNUMBER, global.tblInvoiceNotes.InvoiceID, global.tblUsers.Username, global.tblInvoiceNotes.InvoiceNotes, global.tblInvoiceNotes.InvoiceNotesID, global.tblUsers.UserID
			FROM         global.tblInvoiceNotes INNER JOIN
                      global.tblUsers ON global.tblInvoiceNotes.UserID = global.tblUsers.UserID
                      where global.tblInvoiceNotes.InvoiceID = @InvoiceID ) tbl where
                      ROWNUMBER BETWEEN @Skip + 1 AND @Skip + @Take	
	      
	      
END

GO
/****** Object:  StoredProcedure [global].[Get_LienAdjusterByAdjusterID]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		TGosain
-- Create date: 11-25-2015
-- Description:	get adjuster detail from lien adjuster table
-- =============================================
create PROCEDURE [global].[Get_LienAdjusterByAdjusterID](@AdjusterId int)
AS
BEGIN
	SET NOCOUNT ON;
		select adjusterId,adjusterFirstName,adjusterLastName, adjusterPhone, adjusterEmail from Liens.dbo.adjuster WITH(READPAST,ROWLOCK) 
		where Liens.dbo.adjuster.adjusterId = @AdjusterId
END

GO
/****** Object:  StoredProcedure [global].[Get_NetworkingDays]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 14 JAN 2015
-- Description : Calculating 30 Networking days
-- ===================================================================================
CREATE PROCEDURE [global].[Get_NetworkingDays] --[global].[Get_NetworkingDays]'2015-11-28',5
@InvoiceDate DATE,
@DepartmentId INT
AS
BEGIN
   
         
         DECLARE @_InvoiceDueDate DATE
        
		 IF(@DepartmentId =5)	
		 BEGIN	
		      SET @_InvoiceDueDate = (SELECT DATEADD(dd,30,@InvoiceDate) [InvoiceDueDate])					  
              
         END
         ELSE
         BEGIN
              SET @_InvoiceDueDate =  (SELECT  Convert(date,[global].[Get_AddWorkDays](30,@InvoiceDate)) as InvoiceDueDate)
         END
									  	  
									
         SELECT   CONVERT(VARCHAR(10),@_InvoiceDueDate,110)  AS InvoiceDueDate
END
GO
/****** Object:  StoredProcedure [global].[Get_OCRFilesInvoiceRecords]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Rohit Kumar
-- Create date: 07/27/2015
-- Description:	Get OCR , Files and Invoice Records from lien and AR database

-- Revision History: -

-- 1.1 	12-20-2016: TGosain
--		User Story #2969: Check Assignment - .pdf Viewer and Assignment Pop Up
-- =========================================================================================
-- [global].[Get_OCRFilesInvoiceRecords] 'gu',0,100

CREATE PROCEDURE [global].[Get_OCRFilesInvoiceRecords] 
(
	@SearchText varchar(50),
	@Skip INT,        
	@Take INT
)
AS
BEGIN
SELECT * FROM (
SELECT ROW_NUMBER() Over(Order by InvoiceID DESC)AS RowNumber ,FileID	,FilesName	,ClaimNumber	,InsurerBranchName	,InvoiceNumber,InvoiceDate,InvoiceID	,EmployerName	,InsurerName
, InvoiceBalance as OutstandingBalance FROM (		 
		 
SELECT      
							global.tblFiles.FileID ,
							ISNULL(global.tblFiles.FirstName,
                          (SELECT     lienFileClaimantFirstName
                            FROM          Liens.dbo.lienFile WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) as FirstName                            
                            , ISNULL(global.tblFiles.LastName,
                          (SELECT     lienFileClaimantLastName
                            FROM          Liens.dbo.lienFile AS lienFile_1 WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) as LastName,   
						(ISNULL(global.tblFiles.FirstName,
                          (SELECT     lienFileClaimantFirstName
                            FROM          Liens.dbo.lienFile WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) + ' ' + ISNULL(global.tblFiles.LastName,
                          (SELECT     lienFileClaimantLastName
                            FROM          Liens.dbo.lienFile AS lienFile_1 WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber)))) AS FilesName, global.tblFiles.ClaimNumber, global.tblInvoices.InvoiceNumber ,global.tblInvoices.InvoiceDate, global.tblInvoices.InvoiceID,
                        ISNULL
                          ((SELECT     InsurerName
                              FROM         global.tblInsurers WITH (READPAST, ROWLOCK)
                              WHERE     (InsurerId = global.tblFiles.InsurerId)),
                          (SELECT     insurerName
                            FROM          Liens.dbo.insuranceBilling WITH (READPAST, ROWLOCK)
                            WHERE      (insurerId = global.tblFiles.InsurerId))) AS InsurerName,  ISNULL
                          ((SELECT     InsurerBranchName
                              FROM         global.tblInsurerBranches WITH (READPAST, ROWLOCK)
                              WHERE     (InsurerBranchId = global.tblFiles.InsurerBranchId)),
                          (SELECT     insurerBranchName
                            FROM          Liens.dbo.insuranceBranch WITH (READPAST, ROWLOCK)
                            WHERE      (insurerBranchId = global.tblFiles.InsurerBranchId))) AS InsurerBranchName,  ISNULL
                          ((SELECT     EmployerName
                              FROM         global.tblEmployers WITH (READPAST, ROWLOCK)
                              WHERE     (EmployerId = global.tblFiles.EmployerId)),
                          (SELECT     employerName
                            FROM          Liens.dbo.employer WITH (READPAST, ROWLOCK)
                            WHERE      (employerId = global.tblFiles.EmployerId))) AS EmployerName
							, ISNULL(tblInvoices.InvoiceBalanceAmt,0.00) as InvoiceBalance
		FROM			global.tblFiles  WITH (READPAST, ROWLOCK) INNER JOIN
                      global.tblInvoices  WITH (READPAST, ROWLOCK) ON global.tblFiles.FileID = global.tblInvoices.FileId 
		) tbls1	      
		WHERE 
	      ( FirstName like '%' + @SearchText + '%'   or
	      LastName like '%' + @SearchText + '%'  or
	      ClaimNumber like '%' + @SearchText + '%'   or
	      InvoiceNumber like '%' + @SearchText + '%' )	      
	      ) tbls2	       	      
	      where RowNumber BETWEEN @Skip + 1 AND @Skip + @Take	
	      order by FilesName  
END




GO
/****** Object:  StoredProcedure [global].[Get_OCRFilesInvoiceRecordsCount]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Rohit Kumar
-- Create date: 07/27/2015
-- Description:	Get OCR , Files and Invoice Records from lien and AR database

-- Revision History: -

-- 1.1 	12-20-2016: TGosain
--		User Story #2969: Check Assignment - .pdf Viewer and Assignment Pop Up
-- =========================================================================================

-- [global].[Get_OCRFilesInvoiceRecordsCount] 'r'
CREATE PROCEDURE [global].[Get_OCRFilesInvoiceRecordsCount] 
(
	@SearchText varchar(50)
)
AS
BEGIN

		SELECT count(*) as Totalcount FROM (
				 
		SELECT     global.tblFiles.FileID  ,   
		 
		 ISNULL(global.tblFiles.FirstName,
                          (SELECT     lienFileClaimantFirstName
                            FROM          Liens.dbo.lienFile WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) as FirstName
                            
                            , ISNULL(global.tblFiles.LastName,
                          (SELECT     lienFileClaimantLastName
                            FROM          Liens.dbo.lienFile AS lienFile_1 WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) as LastName
		  ,
		 
		 (ISNULL(global.tblFiles.FirstName,
                          (SELECT     lienFileClaimantFirstName
                            FROM          Liens.dbo.lienFile WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) + ' ' + ISNULL(global.tblFiles.LastName,
                          (SELECT     lienFileClaimantLastName
                            FROM          Liens.dbo.lienFile AS lienFile_1 WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber)))) AS FilesName, global.tblFiles.ClaimNumber, global.tblInvoices.InvoiceNumber, global.tblInvoices.InvoiceID,
                        ISNULL
                          ((SELECT     InsurerName
                              FROM         global.tblInsurers WITH (READPAST, ROWLOCK)
                              WHERE     (InsurerId = global.tblFiles.InsurerId)),
                          (SELECT     insurerName
                            FROM          Liens.dbo.insuranceBilling WITH (READPAST, ROWLOCK)
                            WHERE      (insurerId = global.tblFiles.InsurerId))) AS InsurerName,  ISNULL
                          ((SELECT     InsurerBranchName
                              FROM         global.tblInsurerBranches WITH (READPAST, ROWLOCK)
                              WHERE     (InsurerBranchId = global.tblFiles.InsurerBranchId)),
                          (SELECT     insurerBranchName
                            FROM          Liens.dbo.insuranceBranch WITH (READPAST, ROWLOCK)
                            WHERE      (insurerBranchId = global.tblFiles.InsurerBranchId))) AS InsurerBranchName,  ISNULL
                          ((SELECT     EmployerName
                              FROM         global.tblEmployers WITH (READPAST, ROWLOCK)
                              WHERE     (EmployerId = global.tblFiles.EmployerId)),
                          (SELECT     employerName
                            FROM          Liens.dbo.employer WITH (READPAST, ROWLOCK)
                            WHERE      (employerId = global.tblFiles.EmployerId))) AS EmployerName
							, ISNULL(tblInvoices.InvoiceBalanceAmt,0.00) as InvoiceBalance
			FROM			global.tblFiles  WITH (READPAST, ROWLOCK) INNER JOIN
                      global.tblInvoices  WITH (READPAST, ROWLOCK) ON global.tblFiles.FileID = global.tblInvoices.FileId 
				          
                       
                      
	      ) tbls
	      WHERE (
	      (FirstName like '%' + @SearchText + '%'   or
	      LastName like '%' + @SearchText + '%' )  or
	      ClaimNumber like '%' + @SearchText + '%'   or
	      InvoiceNumber like '%' + @SearchText + '%' )
 
	      
	       
END

GO
/****** Object:  StoredProcedure [global].[Get_OCRPaymentFilesRecords]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Rohit Kumar
-- Create date: 07/27/2015
-- Description:	Get OCR payments , Files and Invoice Records from lien and AR database
-- =========================================================================================
-- [global].[Get_OCRPaymentFilesRecords] %,0,10
CREATE PROCEDURE [global].[Get_OCRPaymentFilesRecords] 
(
	@SearchText varchar(50),
	@Skip INT,        
	@Take INT
)
AS
BEGIN

		SELECT FileID	,FilesName	,ClaimNumber	 ,InvoiceNumber	,InvoiceID	 ,PaymentId,PaymentAmount, PaymentReceived, CheckNumber, OCRPaymentId FROM (
		SELECT   ROW_NUMBER() Over(Order by global.tblInvoices.InvoiceID DESC)AS RowNumber  ,global.tblFiles.FileID, ISNULL(global.tblFiles.FirstName,
                          (SELECT     lienFileClaimantFirstName
                            FROM          Liens.dbo.lienFile WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) + ' ' + ISNULL(global.tblFiles.LastName,
                          (SELECT     lienFileClaimantLastName
                            FROM          Liens.dbo.lienFile AS lienFile_1 WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) AS FilesName, global.tblFiles.ClaimNumber, global.tblInvoices.InvoiceID, 
                      global.tblInvoices.InvoiceNumber, global.tblPayments.PaymentId,  isnull(global.tblPayments.PaymentAmount,0)  as PaymentAmount, global.tblPayments.PaymentReceived, 
                      global.tblPayments.CheckNumber, global.tblOCRPayments.OCRPaymentId
		FROM			global.tblFiles WITH (READPAST, ROWLOCK) INNER JOIN
						global.tblInvoices WITH (READPAST, ROWLOCK) ON global.tblFiles.FileID = global.tblInvoices.FileId INNER JOIN
                      global.tblPayments WITH (READPAST, ROWLOCK) ON global.tblInvoices.InvoiceID = global.tblPayments.InvoiceId INNER JOIN
                      global.tblOCRPayments WITH (READPAST, ROWLOCK) ON global.tblPayments.PaymentId = global.tblOCRPayments.PaymentId
	      ) tbls
	      WHERE /*( FilesName like '%' + @SearchText + '%'   or
	      ClaimNumber like '%' + @SearchText + '%'   or
	      InvoiceNumber like '%' + @SearchText + '%' )
	      
	      and */
	      RowNumber BETWEEN @Skip + 1 AND @Skip + @Take	 
	      order by FilesName 
END

GO
/****** Object:  StoredProcedure [global].[Get_OCRPaymentFilesRecordsCount]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	Rohit Kumar
-- Create date: 07/27/2015
-- Description:	Get OCR payments , Files and Invoice Records from lien and AR database
-- =========================================================================================
--[global].[Get_OCRPaymentFilesRecordsCount] CHECK132
CREATE PROCEDURE [global].[Get_OCRPaymentFilesRecordsCount] 
(
	@SearchText varchar(50)
)
AS
BEGIN

		SELECT count(*) as Totalcount FROM (
		SELECT   ROW_NUMBER() Over(Order by global.tblInvoices.InvoiceID DESC)AS RowNumber  ,global.tblFiles.FileID, ISNULL(global.tblFiles.FirstName,
                          (SELECT     lienFileClaimantFirstName
                            FROM          Liens.dbo.lienFile WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) + ' ' + ISNULL(global.tblFiles.LastName,
                          (SELECT     lienFileClaimantLastName
                            FROM          Liens.dbo.lienFile AS lienFile_1 WITH (READPAST, ROWLOCK)
                            WHERE      (lienFileClaimNumber = global.tblFiles.ClaimNumber))) AS FilesName, global.tblFiles.ClaimNumber, global.tblInvoices.InvoiceID, 
                      global.tblInvoices.InvoiceNumber, global.tblPayments.PaymentId, isnull(global.tblPayments.PaymentAmount,0) as PaymentAmount, global.tblPayments.PaymentReceived, 
                      global.tblPayments.CheckNumber, global.tblOCRPayments.OCRPaymentId
		FROM			global.tblFiles WITH (READPAST, ROWLOCK) INNER JOIN
						global.tblInvoices WITH (READPAST, ROWLOCK) ON global.tblFiles.FileID = global.tblInvoices.FileId INNER JOIN
                      global.tblPayments WITH (READPAST, ROWLOCK) ON global.tblInvoices.InvoiceID = global.tblPayments.InvoiceId INNER JOIN
                      global.tblOCRPayments WITH (READPAST, ROWLOCK) ON global.tblPayments.PaymentId = global.tblOCRPayments.PaymentId
	      ) tbls
	      WHERE ( FilesName like '%' + @SearchText + '%'   or
	      ClaimNumber like '%' + @SearchText + '%'   or
	      InvoiceNumber like '%' + @SearchText + '%' )
END

GO
/****** Object:  StoredProcedure [global].[Get_PastDueInvoices]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 28 JAN 2017
-- Description : THIS SP IS USED FOR GET DATA FROM  PAST DUE INVOICES
--               User Story #2999: SSRS Report - Past Due Invoices
-- ===================================================================================
CREATE PROCEDURE [global].[Get_PastDueInvoices]  
(@departmentID varchar(max))

AS	
BEGIN

	SELECT (CASE WHEN fi.DepartmentID = 1 THEN 'LR' 
				WHEN fi.DepartmentID = 2  THEN  'UR'
				WHEN fi.DepartmentID = 3  THEN  'BR' 
				WHEN fi.DepartmentID = 4  THEN  'CM' ELSE 'IC' END) AS DepartmentName,
				Inv.InvoiceDate as DateSent,Inv.BillingWeek,Inv.InvoiceNumber,(fi.FirstName + ' ' + fi.LastName) as IW,fi.ClaimNumber,
				(CASE WHEN fi.IsLienInsurerID = 0 
			          	THEN (SELECT InsurerName FROM global.tblInsurers  WHERE InsurerId = fi.InsurerId)
				          ELSE (SELECT insurerName AS InsurerName FROM Liens.dbo.insuranceBilling WHERE insurerId = fi.InsurerId) END ) AS Company,				
			    (CASE WHEN fi.IsLienEmployerID = 0 
				        THEN (SELECT EmployerName  from global.tblEmployers WHERE EmployerId = fi.EmployerId)
			              ELSE (SELECT employerName AS EmployerName  FROM Liens.dbo.employer WHERE employerId = fi.EmployerId) END) AS Employer,
				(CASE WHEN IsLienInsurerBranchID = 0
				        THEN (SELECT InsurerBranchName FROM global.tblInsurerBranches WHERE InsurerBranchId = fi.InsurerBranchId)
				          ELSE (SELECT insurerBranchName AS InsurerBranchName FROM Liens.dbo.insuranceBranch WHERE insurerBranchId = fi.InsurerBranchId) END) AS InsuranceBranch,
				(CASE WHEN fi.IsLienAdjusterID = 0
				        THEN (SELECT (CASE WHEN AdjusterFirstName IS NULL THEN AdjusterLastName 
                                    WHEN AdjusterLastName IS NULL THEN AdjusterFirstName 
                          ELSE (AdjusterFirstName + ' ' + AdjusterLastName) END)  FROM global.tblAdjusters WHERE AdjusterId = fi.AdjusterId)
				                           ELSE (SELECT (adjusterFirstName + ' ' + adjusterLastName) AS AdjusterName   FROM Liens.dbo.adjuster WHERE adjusterId = fi.AdjusterId) END) AS Adjuster,
				Inv.InvoiceAmt,Inv.InvoiceBalanceAmt AS Balance,Inv.InvoiceDueDate,DATEDIFF(day,Inv.InvoiceDate,(SELECT CAST(GETDATE() AS DATE))) AS DaysOpen 
	FROM global.tblFiles fi
				INNER JOIN global.tblInvoices Inv ON fi.FileID = Inv.FileId
	WHERE fi.DepartmentID IN (SELECT * FROM global.Split(@departmentID, ',')) 


END

GO
/****** Object:  StoredProcedure [global].[Get_RpForICPayments]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 04 JAN 2016
-- Description : THIS SP IS FETCH DATA FROM FILE TABLE AND INVOICE TABLE For IC Payments
-- ===================================================================================
CREATE PROCEDURE [global].[Get_RpForICPayments]
	
AS
BEGIN
	
	SELECT		(global.tblFiles.FirstName +' '+ global.tblFiles.LastName) as [FileName],global.tblInvoices.InvoiceNumber, 
				 global.tblInvoices.InvoiceDate,global.tblInvoices.InvoiceAmt,global.tblInvoices.InvoiceDueDate
	FROM         AR.global.tblFiles WITH(READPAST,ROWLOCK)INNER JOIN
				 AR.global.tblInvoices WITH(READPAST,ROWLOCK) ON global.tblInvoices.FileId = global.tblFiles.FileId 
	WHERE        global.tblFiles.DepartmentID = 5
END

GO
/****** Object:  StoredProcedure [global].[Move_FrLienToAR]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 20 NOV 2015
-- Description : THIS SP IS USED FOR PULL DATA FROM  LIEN AND INSERT INTO AR DATABASE
--               User Story #2594: Lien Invoicing Integration
-- Revision History: 

-- 1.0 - 09/28/2016 : MMSINGH
--		User Story #3052: Pull Feature Update
-- ===================================================================================
CREATE PROCEDURE [global].[Move_FrLienToAR] 
@Department INT,
@UserID INT,
@Invoicedt DATETIME,
@ForJob BIT = 0
AS
BEGIN
   
   BEGIN TRANSACTION [Trans1]  
   BEGIN TRY
         
         DECLARE @PendingUploadId INT
         DECLARE @InsurerId INT
         DECLARE @AdjusterId INT
         DECLARE @EmployerId INT
         DECLARE @InsurerBranchId INT
         DECLARE @IsLienInsurerID INT
         DECLARE @IsLienInsurerBranchID INT
         DECLARE @IsLienEmployerID INT
         DECLARE @IsLienAdjusterID INT
         DECLARE @AdjusterCount INT
         DECLARE @AdjusterCountIn INT
         DECLARE @UploadId INT
         DECLARE @FullName VARCHAR(50)
         DECLARE @FirstName VARCHAR(50)
         DECLARE @LastName VARCHAR(50)
         DECLARE @Claim VARCHAR(100)
         DECLARE @Insurer VARCHAR(50)
         DECLARE @InsurerBranch VARCHAR(50)
         DECLARE @Employer VARCHAR(50)
         DECLARE @Adjuster VARCHAR(50)
         DECLARE @InvoiceNumber VARCHAR(50)
         DECLARE @InvoiceAmount VARCHAR(255)
         DECLARE @InvoiceDate VARCHAR(50)
         DECLARE @InvoiceSent VARCHAR(50)
         DECLARE @BillingWeek VARCHAR(50)
         DECLARE @InvoiceDept VARCHAR(50)
         DECLARE @PaymentAmount VARCHAR(50)
         DECLARE @PaymentReceived VARCHAR(50)
         DECLARE @InvoiceBalanceAmount MONEY
         DECLARE @_InvoiceAmount MONEY
         DECLARE @_InvoiceBalanceAmount MONEY
         DECLARE @_PaymentAmount MONEY
         DECLARE @_TotalInvoiceBalanceAmount MONEY
         DECLARE @_DbInvoiceBalanceAmount MONEY
         DECLARE @CheckNumber VARCHAR(50)
         DECLARE @FILEID INT
         DECLARE @INVOICEID INT
         DECLARE @AlreadyExistInvoice INT
         DECLARE @MyLoop1 INT
         DECLARE @InvoiceNum VARCHAR(255)
         DECLARE @ERRORLOOP INT    
         DECLARE @_InvoiceDueDate DATE   
         DECLARE @_InvoiceAmtPaid MONEY
         DECLARE @ICEXISTS INT         
         DECLARE @FILE_IC_ID INT
         DECLARE @FullNameIC VARCHAR(50)
         DECLARE @FirstNameIC VARCHAR(50)
         DECLARE @LastNameIC VARCHAR(50)
         DECLARE @DepartmentIC INT
        -----------------------------------------------         
         DECLARE @LienCommissionID INT
         DECLARE @LienCName VARCHAR(100)
         DECLARE @LienCClientID INT
         DECLARE @LienCStartDate DATETIME
         DECLARE @LienCEndDate DATETIME
         DECLARE @LienCPrecentage MONEY
         DECLARE @LienClientName VARCHAR(150)
         DECLARE @LienFilesTables TABLE(LienCommissionID INT,LienCName VARCHAR(100),LienCClientID INT,LienCStartDate DATETIME,LienCEndDate DATETIME,LienCPrecentage MONEY,LienClientName VARCHAR(100))
         DECLARE @LienClientOnlyTables TABLE(LienCClientID INT)
        
           
           
           	---------tblCommissions-------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------							
							
			 INSERT @LienFilesTables(LienCommissionID,LienCName,LienCClientID,LienCStartDate,LienCEndDate,LienCPrecentage,LienClientName)
             SELECT  COMMI.CommissionID,COMMI.CName,COMMI.CClientID,COMMI.CStartDate,COMMI.CEndDate,COMMI.CPrecentage 
			,(SELECT TOP 1 (CASE WHEN LienFileClient = 'Employer' THEN (SELECT employerName FROM [Liens].[dbo].[employer] WHERE employerId = lienEmployerId)
			WHEN LienFileClient = 'Insurer' THEN (SELECT insurerBranchName FROM [Liens].[dbo].[insuranceBranch] WHERE insurerBranchId = lienInsurerBranchId) ELSE 
			(SELECT (defenseAttorneyFirstName +' '+ defenseAttorneyLastName) AS DefenceAttorneyName  FROM [Liens].[dbo].[defenseAttorney] 
			WHERE defenseAttorneyId = lienFileDefenseAttorneyId)END)AS ClientName
			FROM [Liens].[dbo].[invoice]  INV WITH(READPAST,ROWLOCK)
												INNER JOIN  [Liens].[dbo].[lienfile] LFILE  WITH(READPAST,ROWLOCK)ON INV.LienFileID = LFILE.lienFileId 
												INNER JOIN 	[Liens].[dbo].[ClientBilling] CBILL WITH(READPAST,ROWLOCK) ON 
												(CASE WHEN LFILE.LienFileClient = 'Employer' 
												THEN LFILE.lienEmployerId 
												WHEN LFILE.LienFileClient = 'Insurer' 
												THEN LFILE.lienInsurerBranchId 
												WHEN LFILE.LienFileClient = 'Defense Attorney'
												THEN LFILE.lienFileDefenseAttorneyId END) 
												= (CASE WHEN LFILE.LienFileClient = 'Employer' THEN CBILL.employerID
												   WHEN LFILE.LienFileClient = 'Insurer' THEN CBILL.insuranceBranchID WHEN LFILE.LienFileClient
												= 'Defense Attorney' THEN CBILL.defenseAttorneyid END)WHERE  CBILL.clientBillingID = COMMI.CClientID) AS ClientName
			 FROM [Liens].[dbo].[tblCommissions] COMMI WITH(READPAST,ROWLOCK) WHERE CClientID IN ( 
			SELECT CBILL.clientBillingID FROM [Liens].[dbo].[invoice]  INV WITH(READPAST,ROWLOCK)
			INNER JOIN  [Liens].[dbo].[lienfile] LFILE  WITH(READPAST,ROWLOCK)ON INV.LienFileID = LFILE.lienFileId 
			INNER JOIN 	[Liens].[dbo].[ClientBilling] CBILL WITH(READPAST,ROWLOCK) ON 
			(CASE WHEN LienFileClient = 'Employer' 
			THEN LFILE.lienEmployerId 
			WHEN LienFileClient = 'Insurer' 
			THEN LFILE.lienInsurerBranchId 
			WHEN LienFileClient = 'Defense Attorney'
			THEN LFILE.lienFileDefenseAttorneyId END) 
			= (CASE WHEN LienFileClient = 'Employer' THEN CBILL.employerID
			   WHEN LienFileClient = 'Insurer' THEN CBILL.insuranceBranchID WHEN LienFileClient
			= 'Defense Attorney' THEN CBILL.defenseAttorneyid END) LEFT OUTER JOIN
				[Liens].[dbo].[tblAdditionalPriceStructure] ADDPRICE  WITH(READPAST,ROWLOCK) ON ADDPRICE.Clientid = CBILL.clientBillingID 
			) AND COMMI.CommissionID NOT IN (SELECT arCommission.LienCommissionID 
			FROM [AR].[global].[tblCommissions] arCommission WITH(READPAST,ROWLOCK))
			
			
			
			
			IF EXISTS(SELECT LienCClientID FROM @LienFilesTables)
		    BEGIN
					INSERT INTO [AR].[global].[tblCommissions](LienCommissionID,LienCName,LienCClientID,LienCStartDate,LienCEndDate,LienCPrecentage,LienClientName)
					SELECT LienCommissionID,LienCName,LienCClientID,LienCStartDate,LienCEndDate,LienCPrecentage,LienClientName FROM @LienFilesTables 
					WHERE LienCommissionID NOT IN (SELECT LienCommissionID FROM [AR].[global].[tblCommissions])
				 
		    END	
        
        
        
           INSERT INTO [AR].[global].[tblPendingUploads]([PendingUploadName] ,[PendingUploadDate],[UserId] ,[DepartmentId] )
                                                          VALUES('LR_TO_AR',getdate(),@UserID,@Department)
           SET 	@PendingUploadId = (SELECT SCOPE_IDENTITY())
           
           SET  @InvoiceNum = (SELECT MAX(InvoiceNumber)AS InvoiceNumber FROM global.tblInvoices)
           
           IF(@InvoiceNum IS NULL)
           BEGIN                  
				   INSERT INTO [AR].[global].[tblUploadTemps]
							   ([FirstName],[LastName],[Claim],[Insurer],[InsurerBranch],[Employer],[Adjuster],[InvoiceNumber],[InvoiceAmount],[InvoiceDate]
							   ,[InvoiceSent],[BillingWeek] ,[PaymentAmount],[PaymentReceived] ,[CheckNumber],[InvoiceDept],[PendingUploadId])        
				   SELECT    	Liens.dbo.invoice.lienFileClaimantName,NULL,Liens.dbo.invoice.lienFileClaimNumber,Liens.dbo.lienFile.lienInsurerId as InsurerId,
					  			Liens.dbo.lienFile.lienInsurerBranchId AS InsuranceBranchID,Liens.dbo.invoice.EmployerID, Liens.dbo.invoice.AdjusterID,Liens.dbo.invoice.InvoiceNumber,
					  			Liens.dbo.invoice.BilledAmount AS InvoiceAmount, Liens.dbo.invoice.InvoiceDate, Liens.dbo.invoice.InvoiceDate as InvoiceSent,
					  			DATEADD(dd, -(DATEPART(dw, Liens.dbo.invoice.InvoiceDate)-6), Liens.dbo.invoice.InvoiceDate) [BillingWeek],Liens.dbo.invoice.BilledAmount AS PaymentAmount,
					  			NULL as PaymentReceived,NULL as CheckNumber,@Department as InvoiceDept,@PendingUploadId as PendingUploadId		  
				   FROM       	Liens.dbo.invoice WITH (READPAST,ROWLOCK) INNER JOIN
				                Liens.dbo.lienFile WITH (READPAST,ROWLOCK) on Liens.dbo.lienFile.lienFileId = Liens.dbo.invoice.LienFileID 
                   WHERE        Liens.dbo.invoice.InvoiceDate >= @Invoicedt AND Liens.dbo.invoice.InvoiceNumber NOT IN (SELECT  InvoiceNumber FROM global.tblInvoices)
				   
		   END
		   ELSE
		   BEGIN 
		           INSERT INTO [AR].[global].[tblUploadTemps]
							   ([FirstName],[LastName],[Claim],[Insurer],[InsurerBranch],[Employer],[Adjuster],[InvoiceNumber],[InvoiceAmount],[InvoiceDate]
							   ,[InvoiceSent],[BillingWeek] ,[PaymentAmount],[PaymentReceived] ,[CheckNumber],[InvoiceDept],[PendingUploadId])        
				   SELECT    	Liens.dbo.invoice.lienFileClaimantName,NULL,Liens.dbo.invoice.lienFileClaimNumber,Liens.dbo.lienFile.lienInsurerId as InsurerId,
					  			Liens.dbo.lienFile.lienInsurerBranchId AS InsuranceBranchID,Liens.dbo.invoice.EmployerID, Liens.dbo.invoice.AdjusterID,Liens.dbo.invoice.InvoiceNumber,
					  			Liens.dbo.invoice.BilledAmount AS InvoiceAmount, Liens.dbo.invoice.InvoiceDate, Liens.dbo.invoice.InvoiceDate as InvoiceSent,
					  			DATEADD(dd, -(DATEPART(dw, Liens.dbo.invoice.InvoiceDate)-6), Liens.dbo.invoice.InvoiceDate) [BillingWeek],Liens.dbo.invoice.BilledAmount AS PaymentAmount,
					  			NULL  as PaymentReceived,NULL as CheckNumber,@Department as InvoiceDept,@PendingUploadId as PendingUploadId		  
				   FROM       	Liens.dbo.invoice WITH (READPAST,ROWLOCK) INNER JOIN
				                Liens.dbo.lienFile WITH (READPAST,ROWLOCK) on Liens.dbo.lienFile.lienFileId = Liens.dbo.invoice.LienFileID 
				   WHERE        Liens.dbo.invoice.InvoiceDate >= @Invoicedt AND Liens.dbo.invoice.InvoiceNumber NOT IN (SELECT  InvoiceNumber FROM global.tblInvoices)
		   END
                      	
            
            SET @MyLoop1 = (SELECT    COUNT(global.tblUploadTemps.UploadId) AS TotalCount FROM global.tblUploadTemps  WITH(READPAST,ROWLOCK) 
                            WHERE  PendingUploadId = @PendingUploadId)
				    
					WHILE (@MyLoop1 > 0)
					BEGIN
					        
							  SELECT  TOP 1   @UploadId = UploadId,@FullName = FirstName, @Claim=Claim,@InsurerId = Insurer,
							            @InsurerBranchId=InsurerBranch, @EmployerId = Employer, @AdjusterId=Adjuster, 
										@InvoiceNumber = InvoiceNumber,@InvoiceDate =InvoiceDate ,
										@InvoiceSent = InvoiceSent , @BillingWeek= BillingWeek,
										@InvoiceDept = InvoiceDept, @PaymentAmount = PaymentAmount,
										@CheckNumber = CheckNumber  FROM global.tblUploadTemps  WITH(READPAST,ROWLOCK)  
										WHERE  PendingUploadId = @PendingUploadId
							 	                  
		                    
		                    
		                      SET @ERRORLOOP = @UploadId
							 
							  SET @PaymentReceived = (SELECT  DateCheckReceived FROM Liens.dbo.InvoicePaid WITH (READPAST,ROWLOCK) WHERE InvoiceNumber = @InvoiceNumber)
							
							  SET @ICEXISTS  = (SELECT COUNT(*) AS CNT FROM Liens.dbo.Users WITH (READPAST,ROWLOCK)
							                     WHERE userId IN (SELECT UserCredibility FROM Liens.dbo.invoice WITH (READPAST,ROWLOCK) WHERE InvoiceNumber = @InvoiceNumber) and IC = 1 )
							  
							  IF(@ICEXISTS = 0)
							  BEGIN
									 SET @InvoiceDept = 1
									 SET @Department = 1
									 SET @FILE_IC_ID = 0
							  END
							  ELSE
							  BEGIN
							         SET @InvoiceDept = 1
									 SET @Department = 1
									 SET @DepartmentIC = 5
									 SET @FullNameIC = (SELECT (userFirstName + ' ' + userLastName) AS userFullName  FROM Liens.dbo.Users WITH (READPAST,ROWLOCK)
							                     WHERE userId IN (SELECT UserCredibility FROM Liens.dbo.invoice WITH (READPAST,ROWLOCK) WHERE InvoiceNumber = @InvoiceNumber) and IC = 1 )
							                     
							          SET @FirstNameIC =  (SELECT SUBSTRING(@FullNameIC, 1, NULLIF(CHARINDEX(' ', @FullNameIC) - 1, -1)) AS [FirstName])
									  SET @LastNameIC  =  (SELECT SUBSTRING(@FullNameIC, CHARINDEX(' ', @FullNameIC) + 1, LEN(@FullNameIC)) AS [LastName])         
							  END
							
							  SET @FirstName = (SELECT SUBSTRING(@FullName, 1, NULLIF(CHARINDEX(' ', @FullName) - 1, -1)) AS FirstName)
							 
  		 
							  IF(@FirstName IS NULL)
							  BEGIN
									
									  SET @FirstName =   (SELECT SUBSTRING(@FullName, CHARINDEX(' ', @FullName) + 1, LEN(@FullName))  AS [FirstName])
									  SET @LastName  =  NULL
							  END
							  ELSE
							  BEGIN
									
									  SET @FirstName =  (SELECT SUBSTRING(@FullName, 1, NULLIF(CHARINDEX(' ', @FullName) - 1, -1)) AS [FirstName])
									  SET @LastName  =  (SELECT SUBSTRING(@FullName, CHARINDEX(' ', @FullName) + 1, LEN(@FullName)) AS [LastName])
									 
							  END
							   
							   
							  
							  ---tblFiles----------------------
							  IF EXISTS(SELECT * FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE ClaimNumber = @Claim  AND IsDeleted = 0)
							  BEGIN
									  SET 	@FILEID = (SELECT FileID FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE ClaimNumber = @Claim AND IsDeleted = 0)
									  
									  
									  IF(@DepartmentIC = 5) ------FOR IC DEPARTMENT---------------------------
									  BEGIN
										       IF EXISTS(SELECT * FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE FirstName = @FirstNameIC AND LastName = @LastNameIC AND IsDeleted = 0)
							                   BEGIN
									                   SET 	@FILE_IC_ID = (SELECT FileID FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE FirstName = @FirstNameIC AND LastName = @LastNameIC AND IsDeleted = 0)
											   END
											   ELSE
											   BEGIN
														   INSERT INTO global.tblFiles (FirstName,LastName,ClaimNumber,InsurerId,InsurerBranchId,EmployerId,AdjusterId,
																						IsLienClaimNumber,IsLienInsurerID,IsLienInsurerBranchID,IsLienEmployerID,IsLienAdjusterID,DepartmentID) 
																				VALUES(@FirstNameIC,@LastNameIC,NULL,0,0,0,0,
																						0,0,0,0,0,@DepartmentIC)
																		
														   SET 	@FILE_IC_ID = 	(SELECT SCOPE_IDENTITY())
														   
														   INSERT INTO global.tblICRecordDetails(FileID,ICRecordDetailAddress,ICRecordDetailCity,StateID,ICRecordDetailZip,ICRecordDetailTaxID)
																			VALUES(@FILE_IC_ID,NULL,NULL,NULL,NULL,NULL)
											   END
											    
											   
									  END
																		  
									  
							  END
							  ELSE
							  BEGIN
							  
							          IF(@DepartmentIC = 5) ------FOR IC DEPARTMENT---------------------------
									  BEGIN
										       IF EXISTS(SELECT * FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE FirstName = @FirstNameIC AND LastName = @LastNameIC AND IsDeleted = 0)
							                   BEGIN
									                   SET 	@FILE_IC_ID = (SELECT FileID FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE FirstName = @FirstNameIC AND LastName = @LastNameIC AND IsDeleted = 0)
											   END
											   ELSE
											   BEGIN
														   INSERT INTO global.tblFiles (FirstName,LastName,ClaimNumber,InsurerId,InsurerBranchId,EmployerId,AdjusterId,
																						IsLienClaimNumber,IsLienInsurerID,IsLienInsurerBranchID,IsLienEmployerID,IsLienAdjusterID,DepartmentID) 
																				VALUES(@FirstNameIC,@LastNameIC,NULL,0,0,0,0,
																						0,0,0,0,0,@DepartmentIC)
																		
														   SET 	@FILE_IC_ID = 	(SELECT SCOPE_IDENTITY())
														   
														   INSERT INTO global.tblICRecordDetails(FileID,ICRecordDetailAddress,ICRecordDetailCity,StateID,ICRecordDetailZip,ICRecordDetailTaxID)
																			VALUES(@FILE_IC_ID,NULL,NULL,NULL,NULL,NULL)
											    END
									  END
							  
							          INSERT INTO global.tblFiles (FirstName,LastName,ClaimNumber,InsurerId,InsurerBranchId,EmployerId,AdjusterId,
														IsLienClaimNumber,IsLienInsurerID,IsLienInsurerBranchID,IsLienEmployerID,IsLienAdjusterID,DepartmentID) 
												VALUES(@FirstName,@LastName,@Claim,@InsurerId,@InsurerBranchId,@EmployerId,@AdjusterId,
														1,1,1,1,1,@Department)
										
					        	      SET 	@FILEID = 	(SELECT SCOPE_IDENTITY())
							  
									  		
							  END	            
							--------------------------------------------------           
													
													
											
											
													            
							 -----tblInvoices-------
								
		                         
							  SET @AlreadyExistInvoice = (SELECT  Count(tblFiles.FileID) as TotalCount FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																   global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
		                     
							  IF (@AlreadyExistInvoice > 0)
							  BEGIN
									 SET @INVOICEID = (SELECT  tblInvoices.InvoiceID FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																   global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
														   
														   
									SET @_DbInvoiceBalanceAmount = (SELECT  tblInvoices.InvoiceBalanceAmt FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																             global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														                     WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
			                          
			                       
			                        IF EXISTS(SELECT * FROM Liens.dbo.InvoicePaid WHERE InvoicePaid.InvoiceNumber = @InvoiceNumber)   
			                        BEGIN
			                              IF NOT EXISTS(SELECT * FROM global.tblPayments WITH(READPAST,ROWLOCK) WHERE InvoiceId = @INVOICEID)
						                  BEGIN
												  SET @_InvoiceAmtPaid = (SELECT CheckAmount FROM Liens.dbo.InvoicePaid WHERE InvoicePaid.InvoiceNumber = @InvoiceNumber)
					                              
												  SET @_TotalInvoiceBalanceAmount = @_DbInvoiceBalanceAmount - @_InvoiceAmtPaid
												  
												  UPDATE global.tblInvoices SET InvoiceBalanceAmt = @_TotalInvoiceBalanceAmount 
												  WHERE InvoiceID = @INVOICEID AND FileId = @FILEID
										  END
			                        END
			                        			                          
							  END
							  ELSE
							  BEGIN		
							  		
							  		SET @InvoiceAmount = (SELECT Sum(BilledAmount) as InvoiceAmount from Liens.dbo.invoice where InvoiceNumber = @InvoiceNumber)
							  		
							        IF EXISTS(SELECT * FROM Liens.dbo.InvoicePaid WHERE InvoicePaid.InvoiceNumber = @InvoiceNumber)   
			                        BEGIN
			                              SET @_InvoiceAmtPaid = (SELECT CheckAmount FROM Liens.dbo.InvoicePaid WHERE InvoicePaid.InvoiceNumber = @InvoiceNumber)
			                              
			                              SET @_InvoiceAmount = @InvoiceAmount
										  SET @_TotalInvoiceBalanceAmount = @_InvoiceAmtPaid - @_InvoiceAmount
			                        END
			                        ELSE
			                        BEGIN
			                              SET @_TotalInvoiceBalanceAmount = @InvoiceAmount	
			                        END 
			                         
								    
								    
							        SET @_InvoiceDueDate =  (SELECT  Convert(date,[global].[Get_AddWorkDays](30,@InvoiceDate)) as InvoiceDueDate)--Calculating 30 Networking days
							          
							        IF(@FILE_IC_ID = 0)  ----fOR USER CREDIBILITY
							        BEGIN
											INSERT INTO global.tblInvoices (FileId,InvoiceNumber,InvoiceAmt,InvoiceDate,InvoiceDueDate,InvoiceSent,BillingWeek,DepartmentId,InvoiceBalanceAmt,UserCredibility)
																	   VALUES(@FILEID,@InvoiceNumber,@InvoiceAmount,@InvoiceDate,@_InvoiceDueDate,@InvoiceSent,@BillingWeek,@InvoiceDept,@_TotalInvoiceBalanceAmount,NULL)
						                                               
											SET 	@INVOICEID = (SELECT SCOPE_IDENTITY())	
								    END
								    ELSE
								    BEGIN
								            INSERT INTO global.tblInvoices (FileId,InvoiceNumber,InvoiceAmt,InvoiceDate,InvoiceDueDate,InvoiceSent,BillingWeek,DepartmentId,InvoiceBalanceAmt,UserCredibility)
															   VALUES(@FILEID,@InvoiceNumber,@InvoiceAmount,@InvoiceDate,@_InvoiceDueDate,@InvoiceSent,@BillingWeek,@InvoiceDept,@_TotalInvoiceBalanceAmount,@FILE_IC_ID)
				                                               
								            SET @INVOICEID = (SELECT SCOPE_IDENTITY())	
								    END
								    
								  
								  
							  END
			                
			                     
							 -----tblPayments--------------------------------
							 -------------------------------------------------
							 IF(@INVOICEID <> 0 AND @PaymentAmount IS NOT NULL)
							 BEGIN	
						         IF EXISTS(SELECT * FROM Liens.dbo.InvoicePaid WITH(READPAST,ROWLOCK) WHERE InvoiceNumber = @InvoiceNumber)
						         BEGIN
						                 IF NOT EXISTS(SELECT * FROM global.tblPayments WITH(READPAST,ROWLOCK) WHERE InvoiceId = @INVOICEID)
						                 BEGIN
												INSERT INTO global.tblPayments (InvoiceId,PaymentAmount,PaymentReceived,CheckNumber,PendingUploadId)
																VALUES (@INVOICEID, @_InvoiceAmtPaid,@PaymentReceived ,@CheckNumber ,@PendingUploadId)	
										 END
								 END			            
							 END	 
							 
							 	
							 	
							--------------tblCommissions by InvoiceNumber-------------------------------------
							----------------------------------------------------------------------------------	
           
							INSERT @LienClientOnlyTables(LienCClientID)
						    SELECT  COMMI.CClientID							
							FROM [Liens].[dbo].[tblCommissions] COMMI WITH(READPAST,ROWLOCK) WHERE CClientID IN ( 
							SELECT CBILL.clientBillingID FROM [Liens].[dbo].[invoice]  INV WITH(READPAST,ROWLOCK)
							INNER JOIN  [Liens].[dbo].[lienfile] LFILE  WITH(READPAST,ROWLOCK)ON INV.LienFileID = LFILE.lienFileId 
							INNER JOIN 	[Liens].[dbo].[ClientBilling] CBILL WITH(READPAST,ROWLOCK) ON 
							(CASE WHEN LienFileClient = 'Employer' 
							THEN LFILE.lienEmployerId 
							WHEN LienFileClient = 'Insurer' 
							THEN LFILE.lienInsurerBranchId 
							WHEN LienFileClient = 'Defense Attorney'
							THEN LFILE.lienFileDefenseAttorneyId END) 
							= (CASE WHEN LienFileClient = 'Employer' THEN CBILL.employerID
							   WHEN LienFileClient = 'Insurer' THEN CBILL.insuranceBranchID WHEN LienFileClient
							= 'Defense Attorney' THEN CBILL.defenseAttorneyid END) LEFT OUTER JOIN
								[Liens].[dbo].[tblAdditionalPriceStructure] ADDPRICE  WITH(READPAST,ROWLOCK) ON ADDPRICE.Clientid = CBILL.clientBillingID 
							WHERE InvoiceNumber = @InvoiceNumber) 
						    
						    
						    -------------------UPDATE tblInvoices-------------------
						    IF EXISTS(SELECT LienCClientID FROM @LienClientOnlyTables)
						    BEGIN
						            UPDATE  global.tblInvoices SET LienClientID = (SELECT Top 1 LienCClientID FROM @LienClientOnlyTables) WHERE InvoiceNumber = @InvoiceNumber
						    END
						    
						     -------DELETE FROM DYNAMIC TABLE---------------------
						    DELETE FROM @LienClientOnlyTables
								 
							 ---------DELETE THE PROCESSED ENTRY---------------
							 DELETE FROM global.tblUploadTemps   WITH(READPAST,ROWLOCK)
									   WHERE  global.tblUploadTemps.UploadId =@UploadId AND global.tblUploadTemps.PendingUploadId = @PendingUploadId
									          AND global.tblUploadTemps.InvoiceDept = @Department
									          
							SET @MyLoop1 = @MyLoop1 -1
					
					END	
					
					
					
					
				    
				    
				    	 	
		       
		    UPDATE global.tblPendingUploads WITH(READPAST,ROWLOCK) SET IsProcessed = 1,ProcessedBy = @UserID,ProcessedOn = getdate() where PendingUploadId = @PendingUploadId
            
	   SELECT  NULL AS ErrorNumberLoop,NULL AS ErrorNumber,NULL AS ErrorSeverity,NULL AS ErrorState,NULL AS ErrorLine,'NULL' AS ErrorProcedure,'NULL' AS ErrorMessage
	   IF @ForJob = 1
	   BEGIN
		INSERT INTO Job.tblTrackingLienInvoice (JobDate,  Status, Invoice) VALUES (getdate(),'Successfully',CONVERT(date, getdate()))
	   END	
	   
	
	COMMIT TRANSACTION	[Trans1]
	
    END TRY
	BEGIN CATCH	   
	    ROLLBACK TRANSACTION [Trans1]
		DECLARE @tmp Table(ErrorNumberLoop INT,ErrorNumber INT,ErrorSeverity INT,ErrorState INT,ErrorLine INT,ErrorProcedure VARCHAR(100),ErrorMessage VARCHAR(MAX))
		INSERT INTO  @tmp
 			 SELECT @ERRORLOOP AS ErrorNumberLoop,
			 ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_LINE () AS ErrorLine
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_MESSAGE() AS ErrorMessage;	
			 
			 
		IF (@ForJob =1)
		BEGIN
			INSERT INTO Job.tblTrackingLienInvoice (JobDate,  Status, Invoice) VALUES (getdate(),
			(select ('ErrorNumber : '+ErrorNumber +', ErrorSeverity: '+ErrorSeverity +', ErrorState: '+ErrorState +', ErrorLine: '+ErrorLine +', ErrorProcedure: '+ErrorProcedure +', ErrorMessage: '+ErrorMessage ) as Mrg from @tmp)		
			,CONVERT(date, getdate()))
		END
		
			SELECT * FROM @tmp
		
	
	END CATCH	

END

GO
/****** Object:  StoredProcedure [global].[Move_TempUploadDataDepAR]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 10 AUG 2015
-- Description : THIS SP IS USED FOR MOVE DATA IN  UR,BR,CM DEPARTMENT
--               INSERTING FROM EXCEL UPLOAD TEMP TABLE / SPRINT 2/ [US#2446]
-- ===================================================================================
CREATE PROCEDURE [global].[Move_TempUploadDataDepAR] 
@Department INT,
@PendingUploadId INT,
@UserID INT	
AS
BEGIN
   --set transaction isolation level repeatable read;
   BEGIN TRANSACTION [Trans1]  
   BEGIN TRY
   
         DECLARE @InsurerId INT
         DECLARE @AdjusterId INT
         DECLARE @EmployerId INT
         DECLARE @InsurerBranchId INT
         DECLARE @IsLienInsurerID INT
         DECLARE @IsLienInsurerBranchID INT
         DECLARE @IsLienEmployerID INT
         DECLARE @IsLienAdjusterID INT
         DECLARE @AdjusterCount INT
         DECLARE @AdjusterCountIn INT
         DECLARE @UploadId INT
         DECLARE @FirstName VARCHAR(50)
         DECLARE @LastName VARCHAR(50)
         DECLARE @Claim VARCHAR(100)
         DECLARE @Insurer VARCHAR(50)
         DECLARE @InsurerBranch VARCHAR(50)
         DECLARE @Employer VARCHAR(50)
         DECLARE @Adjuster VARCHAR(50)
         DECLARE @InvoiceNumber VARCHAR(255)
         DECLARE @InvoiceAmount VARCHAR(50)
         DECLARE @InvoiceDate VARCHAR(50)
         DECLARE @InvoiceSent VARCHAR(50)
         DECLARE @BillingWeek VARCHAR(50)
         DECLARE @InvoiceDept VARCHAR(50)
         DECLARE @PaymentAmount VARCHAR(50)
         DECLARE @PaymentReceived VARCHAR(50)
         DECLARE @CheckNumber VARCHAR(50)
         DECLARE @FILEID INT
         DECLARE @INVOICEID INT
         DECLARE @_InvoiceDate DATE
         DECLARE @_InvoiceDueDate DATE
         DECLARE @_InvoiceSent DATE
         DECLARE @_BillingWeek DATE
         DECLARE @_PaymentReceived DATE
         DECLARE @InvoiceBalanceAmount MONEY
         DECLARE @_InvoiceAmount MONEY
         DECLARE @_InvoiceBalanceAmount MONEY
         DECLARE @_PaymentAmount MONEY
         DECLARE @_TotalInvoiceBalanceAmount MONEY
         DECLARE @_DbInvoiceBalanceAmount MONEY
         DECLARE @AlreadyExistInvoice INT         
         DECLARE @MyLoop2 INT
         DECLARE @MyLoop3 INT
         DECLARE @ERRORLOOP INT
         
 
		       --- i Claim = AR.FileClaim
		       --- 1.	If Match, then assign Invoice and Payment Columns to matching FileID
		       
		       DELETE FROM AR.global.tblUploadTemps WHERE (FirstName = 'Update')  
													 AND (LastName = 'Update') AND (Claim = 'Update') AND (Insurer = 'Update')
													 AND (InsurerBranch = 'Update') AND (Employer = 'Update') AND (Adjuster = 'Update')
													 AND (InvoiceNumber = 'Update') AND (InvoiceAmount = 'Update') AND (InvoiceDate = 'Update')
													 AND (InvoiceSent = 'Update') AND (BillingWeek = 'Update') AND (PaymentAmount = 'Update')
													 AND (PaymentReceived = 'Update') AND (CheckNumber = 'Update') 
		       
		       DECLARE @Update varchar(10) = 'Update'
			    
				SET @MyLoop2 = (SELECT  COUNT(tblUploadTemps.UploadId) AS Total 
								FROM    global.tblUploadTemps WITH(READPAST,ROWLOCK)  INNER JOIN
										global.tblFiles WITH(READPAST, ROWLOCK) ON global.tblFiles.ClaimNumber = global.tblUploadTemps.Claim
								WHERE   global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.Claim <> @Update)
				SET @ERRORLOOP =0
				WHILE (@MyLoop2 >0)
				BEGIN
					
					
					  SELECT TOP 1  @UploadId = tblUploadTemps.UploadId,@FirstName= tblUploadTemps.FirstName,@LastName = tblUploadTemps.LastName,@Claim = tblUploadTemps.Claim,@Insurer = tblUploadTemps.Insurer,@InsurerBranch = tblUploadTemps.InsurerBranch,
									@Employer = tblUploadTemps.Employer,@Adjuster = tblUploadTemps.Adjuster,@InvoiceNumber = tblUploadTemps.InvoiceNumber,@InvoiceAmount = tblUploadTemps.InvoiceAmount,@InvoiceDate = tblUploadTemps.InvoiceDate,
									@InvoiceSent = tblUploadTemps.InvoiceSent,@BillingWeek = tblUploadTemps.BillingWeek,@InvoiceDept = tblUploadTemps.InvoiceDept,@PaymentAmount = tblUploadTemps.PaymentAmount,@PaymentReceived = tblUploadTemps.PaymentReceived,
									@CheckNumber = tblUploadTemps.CheckNumber 
					  FROM          global.tblUploadTemps WITH(READPAST,ROWLOCK)  INNER JOIN
									global.tblFiles WITH(READPAST, ROWLOCK) ON global.tblFiles.ClaimNumber = global.tblUploadTemps.Claim
									WHERE  global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.Claim <> @Update
					
					     SET @ERRORLOOP = @UploadId
						 ---tblFiles----------
						  IF EXISTS(SELECT * FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE ClaimNumber = @Claim AND IsDeleted = 0)
						  BEGIN
								  SET 	@FILEID = (SELECT FileID FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE ClaimNumber = @Claim AND IsDeleted = 0)
						  END
											            
						 -----tblInvoices-------
						 IF(@InvoiceNumber <> @Update AND @InvoiceAmount <> @Update AND @InvoiceDate <> @Update AND @InvoiceSent <> @Update AND @BillingWeek <> @Update)
						 BEGIN	
							     SET @_InvoiceDate =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@InvoiceDate)) as InvoiceDate)
							     SET @_InvoiceSent =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@InvoiceSent)) as InvoiceSent)
							     SET @_BillingWeek =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@BillingWeek)) as BillingWeek)
								
						 END
	                         
							IF(@Department=1)
							BEGIN
							SET @InvoiceDept = 1
							END
							ELSE IF(@Department=2)
							BEGIN
							   SET @InvoiceDept = 2
							END
							ELSE IF(@Department=3)
							BEGIN
							   SET @InvoiceDept = 3
							END
							ELSE IF(@Department=4)
							BEGIN
							   SET @InvoiceDept = 4
							END	
	                     
						  SET @AlreadyExistInvoice = (SELECT  Count(tblFiles.FileID) as TotalCount FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																   global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
		                     
						  IF (@AlreadyExistInvoice > 0)
						  BEGIN
								  SET 	@INVOICEID = (SELECT  tblInvoices.InvoiceID FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
															   global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
													   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
													   
						          
						          SET @_DbInvoiceBalanceAmount = (SELECT  tblInvoices.InvoiceBalanceAmt FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																             global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														                     WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
			                          
			                              
	                              IF(@PaymentAmount <> @Update)
								  BEGIN											  
										  SET @_PaymentAmount = @PaymentAmount
										  SET @_TotalInvoiceBalanceAmount = @_DbInvoiceBalanceAmount - @_PaymentAmount
										  
										  UPDATE global.tblInvoices SET InvoiceBalanceAmt = @_TotalInvoiceBalanceAmount 
										  WHERE InvoiceID = @INVOICEID AND FileId = @FILEID
								  END
						  END
						  ELSE
						  BEGIN
						  
						       IF(@InvoiceNumber <> @Update AND @InvoiceAmount <> @Update AND @InvoiceDate <> @Update AND @InvoiceSent <> @Update AND @BillingWeek <> @Update)
						       BEGIN
						                  IF(@PaymentAmount <> @Update)
										  BEGIN
												  SET @_InvoiceAmount = @InvoiceAmount
												  SET @_PaymentAmount = @PaymentAmount
												  SET @InvoiceBalanceAmount = @_InvoiceAmount - @_PaymentAmount
										  END
										  ELSE
										  BEGIN 
												  SET @InvoiceBalanceAmount = @InvoiceAmount 
										  END
										  
										  SET @_InvoiceDueDate =  (SELECT  Convert(date,[global].[Get_AddWorkDays](30,@_InvoiceDate)) as InvoiceDueDate)--Calculating 30 Networking days
										
									  INSERT INTO global.tblInvoices (FileId,InvoiceNumber,InvoiceAmt,InvoiceDate,InvoiceDueDate,InvoiceSent,BillingWeek,DepartmentId,InvoiceBalanceAmt)
															   VALUES(@FILEID,@InvoiceNumber,@InvoiceAmount,@_InvoiceDate,@_InvoiceDueDate,@_InvoiceSent,@_BillingWeek,@InvoiceDept,@InvoiceBalanceAmount)
				                                               
									  SET 	@INVOICEID = (SELECT SCOPE_IDENTITY())	
							   END
							   ELSE
							   BEGIN
									  SET 	@INVOICEID = 0
							   END 
						  END
	                     
	                     
	                     
	                     
	                     
						     -----tblPayments--------------------------------
							 -------------------------------------------------
							 IF(@INVOICEID <> 0 AND @PaymentAmount <> @Update)
						     BEGIN	
						         IF(@PaymentReceived <> @Update)
						         BEGIN				         
		                               SET @_PaymentReceived =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@PaymentReceived)) as PaymentReceived)
		                         END
								 INSERT INTO global.tblPayments (InvoiceId,PaymentAmount,PaymentReceived,CheckNumber,PendingUploadId)
														VALUES (@INVOICEID, (CASE WHEN @PaymentAmount=@Update THEN 0 ELSE Convert(money,@PaymentAmount) END),
														(CASE WHEN @PaymentReceived=@Update THEN NULL ELSE @_PaymentReceived END),(CASE WHEN @CheckNumber=@Update THEN NULL ELSE @CheckNumber END),@PendingUploadId)				            
			                 END	 			            
		                  									           
						  ---------DELTE THE PROCESSED ENTRY---------------
							 DELETE FROM global.tblUploadTemps WITH(READPAST,ROWLOCK)
							 WHERE       global.tblUploadTemps.UploadId =@UploadId
					        
					        					       
							SET @MyLoop2 = @MyLoop2 - 1
							
				
				END
				
            
            
            
                   
						
                          
            --- 2.	If no match, then create new record in AR.File and assign Invoice and Payment Columns to new FileID    
                
				SET @MyLoop3 = (SELECT  COUNT(UploadId)   FROM    global.tblUploadTemps WITH(READPAST,ROWLOCK)
						   WHERE  PendingUploadId = @PendingUploadId)
	            
	            
				WHILE (@MyLoop3 > 0)
				BEGIN
				   
						  SELECT Top 1 @UploadId = UploadId,@FirstName = FirstName,
						          @LastName = LastName,
						          @Claim =  Claim,
						          @Insurer =  Insurer,
						          @InsurerBranch = InsurerBranch,
						          @Employer =  Employer,
								  @Adjuster =  Adjuster,
								  @InvoiceNumber = InvoiceNumber,@InvoiceAmount = InvoiceAmount,@InvoiceDate = InvoiceDate, @InvoiceSent = InvoiceSent,@BillingWeek = BillingWeek,
								  @InvoiceDept = InvoiceDept,@PaymentAmount = PaymentAmount,@PaymentReceived = PaymentReceived,@CheckNumber = CheckNumber 
						  FROM    global.tblUploadTemps WITH(READPAST,ROWLOCK)
						  WHERE   PendingUploadId = @PendingUploadId
	                    
	                      SET @ERRORLOOP = @UploadId
	                    
						------------INSURER------------
						  IF EXISTS (SELECT  insuranceBilling.InsurerID FROM Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) 
									 WHERE insuranceBilling.insurerName=@Insurer)
						  BEGIN
								   SET @InsurerId = (SELECT TOP 1 insuranceBilling.InsurerID FROM Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) 
										WHERE insuranceBilling.insurerName = @Insurer)
								   SET @IsLienInsurerID = 1
						  END 
						  ELSE
						  BEGIN
						  
									IF EXISTS(SELECT * FROM global.tblInsurers WITH(READPAST,ROWLOCK) WHERE InsurerName= @Insurer)
									BEGIN
											SET @InsurerId = (SELECT InsurerId FROM global.tblInsurers WITH(READPAST,ROWLOCK) WHERE InsurerName= @Insurer)
											SET @IsLienInsurerID = 0
									END
									ELSE
									BEGIN
											INSERT INTO global.tblInsurers(InsurerName)Values(@Insurer)
											SET @InsurerId = (SELECT SCOPE_IDENTITY())
											SET @IsLienInsurerID = 0
									END
						  END  
						  ---------------------------------
						  
						  -------INSURER BRANCH-------------
						  IF EXISTS (SELECT insuranceBranch.InsurerBranchId  FROM  Liens.dbo.insuranceBranch WITH(READPAST,ROWLOCK)
									 WHERE (insuranceBranch.InsurerBranchName = @InsurerBranch And insuranceBranch.insurerId = @InsurerId))
						  BEGIN
									SET @InsurerBranchId = (SELECT TOP 1 insuranceBranch.InsurerBranchId  FROM  Liens.dbo.insuranceBranch WITH(READPAST,ROWLOCK)
										 WHERE (insuranceBranch.InsurerBranchName = @InsurerBranch And insuranceBranch.insurerId = @InsurerId))
					                
									SET @IsLienInsurerBranchID  = 1
				                
						  END
						  ELSE
						  BEGIN
									IF EXISTS(SELECT * FROM global.tblInsurerBranches WITH(READPAST,ROWLOCK) WHERE InsurerId = @InsurerId AND InsurerBranchName= @InsurerBranch)
									BEGIN
											SET @InsurerBranchId = (SELECT InsurerBranchId FROM global.tblInsurerBranches WITH(READPAST,ROWLOCK) WHERE InsurerId = @InsurerId AND InsurerBranchName= @InsurerBranch)					                
											SET @IsLienInsurerBranchID = 0
									END
									ELSE
									BEGIN
											INSERT INTO global.tblInsurerBranches(InsurerId,InsurerBranchName)VALUES(@InsurerId,@InsurerBranch)
											SET @InsurerBranchId = (SELECT SCOPE_IDENTITY())
							                
											SET @IsLienInsurerBranchID = 0
									END
						  END
						  ---------------------------------
						  
						   ----ADJUSTER----
							  
							  declare @AdjusterFName as varchar(50)=null
							  declare @AdjusterLName as varchar(50)=null
							  if ( (Select COUNT(*) from  [global].[Get_SplitStringFormat](@Adjuster,'')) > 1)
								begin
									Set @AdjusterFName =  (Select top 1 splitdata from  [global].[Get_SplitStringFormat](@Adjuster,''))  	
									Set @AdjusterLName =  (Select top 1 splitdata from  [global].[Get_SplitStringFormat](@Adjuster,'') order by id desc  )
									
									SET @AdjusterCount = (SELECT count(adjuster.AdjusterId) as totalCOunt  FROM Liens.dbo.adjuster WITH(READPAST,ROWLOCK)
															WHERE adjuster.AdjusterFirstName = @AdjusterFName and adjuster.AdjusterLastName = @AdjusterLName)
									
								 end
							  else
								begin
									Set @AdjusterFName =  (Select top 1 splitdata from  [global].[Get_SplitStringFormat](@Adjuster,'')) 	
									set @AdjusterLName = null
									SET @AdjusterCount = (SELECT count(adjuster.AdjusterId) as totalCOunt  FROM Liens.dbo.adjuster WITH(READPAST,ROWLOCK)
													WHERE adjuster.AdjusterFirstName = @AdjusterFName)
									
								end	  
							                   
							  IF(@AdjusterCount >0)                 
							  BEGIN 
										if ( isnull(@AdjusterLName,'0') = '0')
										begin
										
										 SET @AdjusterId = (SELECT TOP 1 adjuster.AdjusterId  FROM Liens.dbo.adjuster WITH(READPAST,ROWLOCK)
															 WHERE adjuster.AdjusterFirstName = @AdjusterFName)
								            
										 SET @IsLienAdjusterID = 1   
										end
										else
											begin
												SET @AdjusterId = (SELECT TOP 1 adjuster.AdjusterId  FROM Liens.dbo.adjuster WITH(READPAST,ROWLOCK)
															 	WHERE adjuster.AdjusterFirstName = @AdjusterFName and adjuster.AdjusterLastName = @AdjusterLName)
								            
												SET @IsLienAdjusterID = 1   
											end
							           
							          
							  END
							  ELSE
							  BEGIN		
										 if ( isnull(@AdjusterLName,'0') = '0')
											begin
													SET @AdjusterCountIn = (SELECT count(AdjusterId) as totalCOunt  FROM global.tblAdjusters WITH(READPAST,ROWLOCK)
																  WHERE AdjusterFirstName = @AdjusterFName)		
											END
										ELSE 
											BEGIN
													SET @AdjusterCountIn = (SELECT count(AdjusterId) as totalCOunt  FROM global.tblAdjusters WITH(READPAST,ROWLOCK)
																  WHERE AdjusterFirstName = @AdjusterFName and AdjusterLastName = @AdjusterLName)
											END
											
										 IF(@AdjusterCountIn >0)
										 BEGIN
											if ( isnull(@AdjusterLName,'0') = '0')
												BEGIN
													 SET @AdjusterId = (SELECT AdjusterId  FROM global.tblAdjusters WITH(READPAST,ROWLOCK)
																		WHERE AdjusterFirstName = @AdjusterFName) 
																		
													 SET @IsLienAdjusterID = 0
												 END
											ELSE 
												BEGIN
													SET @AdjusterId = (SELECT AdjusterId  FROM global.tblAdjusters WITH(READPAST,ROWLOCK)
																		WHERE AdjusterFirstName = @AdjusterFName and AdjusterLastName = @AdjusterLName) 
																		
													 SET @IsLienAdjusterID = 0
												END
										 END
										 ELSE
										 BEGIN			         
												 INSERT INTO global.tblAdjusters(AdjusterFirstName,AdjusterLastName,AdjusterPhone)					         
												 SELECT  @AdjusterFName, @AdjusterLName,null
										         
												 SET @AdjusterId = (SELECT SCOPE_IDENTITY())
												 SET @IsLienAdjusterID = 0 
										 END
							         
							  END
							  --------------------------------
						  
						  ----EMPLOYER------------------------------------------------------------------
						  IF EXISTS(SELECT employer.EmployerId  FROM  Liens.dbo.employer WITH(READPAST,ROWLOCK)
									WHERE (employer.EmployerName = @Employer))
						  BEGIN
									 SET @EmployerId =  (SELECT TOP 1 employer.EmployerId  FROM  Liens.dbo.employer WITH(READPAST,ROWLOCK)
										 WHERE (employer.EmployerName = @Employer))
							             
									 SET @IsLienEmployerID = 1
						  END
						  ELSE
						  BEGIN
									  IF EXISTS(SELECT * FROM global.tblEmployers WITH(READPAST,ROWLOCK) WHERE EmployerName =@Employer)
									  BEGIN
											  
											  SET @EmployerId = (SELECT EmployerId FROM global.tblEmployers WITH(READPAST,ROWLOCK) WHERE EmployerName =@Employer)
									          
											  SET @IsLienEmployerID = 0
									  END
									  ELSE
									  BEGIN
											 INSERT INTO global.tblEmployers(EmployerName)Values(@Employer)
											 SET @EmployerId = (SELECT SCOPE_IDENTITY())
									          
											 SET @IsLienEmployerID = 0
									  END
						  END
						  
						  
						  --------------------------------------------------------------------------------------
						   
						  
						   ---tblFiles----------------------
						  IF EXISTS(SELECT * FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE ClaimNumber = (CASE WHEN @Claim = @Update THEN '' ELSE @Claim END) AND IsDeleted = 0)
						  BEGIN
								  SET 	@FILEID = (SELECT FileID FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE ClaimNumber = @Claim AND IsDeleted = 0)
						  END
						  ELSE
						  BEGIN
						         				  
								  INSERT INTO global.tblFiles (FirstName,LastName,ClaimNumber,InsurerId,InsurerBranchId,EmployerId,AdjusterId,
																IsLienClaimNumber,IsLienInsurerID,IsLienInsurerBranchID,IsLienEmployerID,IsLienAdjusterID,DepartmentID) 
														VALUES(@FirstName,@LastName,@Claim,@InsurerId,@InsurerBranchId,@EmployerId,@AdjusterId,
																0,@IsLienInsurerID,@IsLienInsurerBranchID,@IsLienEmployerID,@IsLienAdjusterID,@Department)
												
								  SET 	@FILEID = 	(SELECT SCOPE_IDENTITY())
								 		
						  END	            
						--------------------------------------------------
											
									
									
											            
						 -----tblInvoices-------
						    
						    IF(@InvoiceNumber <> @Update AND @InvoiceAmount <> @Update AND @InvoiceDate <> @Update AND @InvoiceSent <> @Update AND @BillingWeek <> @Update)
						    BEGIN
						    
								 SET @_InvoiceDate =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@InvoiceDate)) as InvoiceDate)
								 SET @_InvoiceSent =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@InvoiceSent)) as InvoiceSent)
								 SET @_BillingWeek =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@BillingWeek)) as BillingWeek)
								
								
	                        END
	                        
	                        
	                        
							IF(@Department=1)
							BEGIN
							SET @InvoiceDept = 1
							END
							ELSE IF(@Department=2)
							BEGIN
							   SET @InvoiceDept = 2
							END
							ELSE IF(@Department=3)
							BEGIN
							   SET @InvoiceDept = 3
							END
							ELSE IF(@Department=4)
							BEGIN
							   SET @InvoiceDept = 4
							END	
	                     
						  SET @AlreadyExistInvoice = (SELECT  Count(tblFiles.FileID) as TotalCount FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																   global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
		                     
						  IF (@AlreadyExistInvoice > 0)
						  BEGIN
								  SET 	@INVOICEID = (SELECT  tblInvoices.InvoiceID FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
															   global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
													   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
													   
													   
								  SET @_DbInvoiceBalanceAmount = (SELECT  tblInvoices.InvoiceBalanceAmt FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																             global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														                     WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
			                          
			                              
	                              IF(@PaymentAmount <> @Update)
								  BEGIN											  
										  SET @_PaymentAmount = @PaymentAmount
										  SET @_TotalInvoiceBalanceAmount = @_DbInvoiceBalanceAmount - @_PaymentAmount
										  
										  UPDATE global.tblInvoices SET InvoiceBalanceAmt = @_TotalInvoiceBalanceAmount 
										  WHERE InvoiceID = @INVOICEID AND FileId = @FILEID
								  END
						  END
						  ELSE
						  BEGIN
						  
						          IF(@InvoiceNumber <> @Update AND @InvoiceAmount <> @Update AND @InvoiceDate <> @Update AND @InvoiceSent <> @Update AND @BillingWeek <> @Update)
						          BEGIN
						                  IF(@PaymentAmount <> @Update)
										  BEGIN
												  SET @_InvoiceAmount = @InvoiceAmount
												  SET @_PaymentAmount = @PaymentAmount
												  SET @InvoiceBalanceAmount = @_InvoiceAmount - @_PaymentAmount
										  END
										  ELSE
										  BEGIN 
												  SET @InvoiceBalanceAmount = @InvoiceAmount 
										  END
										  
										  SET @_InvoiceDueDate =  (SELECT  Convert(date,[global].[Get_AddWorkDays](30,@_InvoiceDate)) as InvoiceDueDate) --Calculating 30 Networking days

										  
										  INSERT INTO global.tblInvoices (FileId,InvoiceNumber,InvoiceAmt,InvoiceDate,InvoiceDueDate,InvoiceSent,BillingWeek,DepartmentId,InvoiceBalanceAmt)
																   VALUES(@FILEID,@InvoiceNumber,@InvoiceAmount,@_InvoiceDate,@_InvoiceDueDate,@_InvoiceSent,@_BillingWeek,@InvoiceDept,@InvoiceBalanceAmount)
					                                               
										  SET 	@INVOICEID = (SELECT SCOPE_IDENTITY())	
								  END
								  ELSE
								  BEGIN 
								          SET 	@INVOICEID = 0
								  END 
						  END
	                     
	                     
	                     
	                     
	                     
						    -----tblPayments--------------------------------
							 -------------------------------------------------
							 IF(@INVOICEID <> 0 AND @PaymentAmount <> @Update)
						     BEGIN	
						         IF(@PaymentReceived <> @Update)
						         BEGIN				         
		                               SET @_PaymentReceived =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@PaymentReceived)) as PaymentReceived)
		                         END
								 INSERT INTO global.tblPayments (InvoiceId,PaymentAmount,PaymentReceived,CheckNumber,PendingUploadId)
														VALUES (@INVOICEID, (CASE WHEN @PaymentAmount=@Update THEN 0 ELSE Convert(money,@PaymentAmount) END),
														(CASE WHEN @PaymentReceived=@Update THEN NULL ELSE @_PaymentReceived END),(CASE WHEN @CheckNumber=@Update THEN NULL ELSE @CheckNumber END),@PendingUploadId)				            
			                 END	 			            
		                  									           
						  ---------DELTE THE PROCESSED ENTRY---------------
							 DELETE FROM global.tblUploadTemps   WITH(READPAST,ROWLOCK)
									   WHERE  global.tblUploadTemps.UploadId =@UploadId
					   
					     
						  SET @MyLoop3 = @MyLoop3 - 1
	                      
				
				END
				 	           
 
		   
		    UPDATE global.tblPendingUploads WITH(READPAST,ROWLOCK) SET IsProcessed = 1,ProcessedBy = @UserID,ProcessedOn = getdate() where PendingUploadId = @PendingUploadId
           
         SELECT  NULL AS ErrorNumberLoop,NULL AS ErrorNumber,NULL AS ErrorSeverity,NULL AS ErrorState,NULL AS ErrorLine,'NULL' AS ErrorProcedure,'NULL' AS ErrorMessage
		 
	COMMIT TRANSACTION	[Trans1]			
    END TRY
	BEGIN CATCH	
	     SELECT @ERRORLOOP AS ErrorNumberLoop,
			 ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_LINE () AS ErrorLine
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_MESSAGE() AS ErrorMessage;
		ROLLBACK TRANSACTION [Tran1]
		
	END CATCH	
	
	    
END
GO
/****** Object:  StoredProcedure [global].[Move_TempUploadDataDepContractor]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 07 DEC 2015
-- Description : THIS SP IS USED FOR MOVE DATA IN  CONTRACTOR DEPARTMENT
--               INSERTING FROM EXCEL UPLOAD TEMP TABLE / SPRINT 4/ [User Story #2613] 
-- ===================================================================================
CREATE PROCEDURE [global].[Move_TempUploadDataDepContractor] 
@Department INT,
@PendingUploadId INT,
@UserID INT	
AS
BEGIN
   
   BEGIN TRANSACTION [Trans1]  
   BEGIN TRY
   
       
         DECLARE @UploadId INT
         DECLARE @FirstName VARCHAR(50)
         DECLARE @LastName VARCHAR(50)
         DECLARE @InvoiceNumber VARCHAR(50)
         DECLARE @InvoiceAmount VARCHAR(255)
         DECLARE @InvoiceBalanceAmount MONEY
         DECLARE @_InvoiceAmount MONEY
         DECLARE @_InvoiceBalanceAmount MONEY
         DECLARE @_PaymentAmount MONEY
         DECLARE @_TotalInvoiceBalanceAmount MONEY
         DECLARE @_DbInvoiceBalanceAmount MONEY
         DECLARE @InvoiceDate VARCHAR(50)
         DECLARE @InvoiceSent VARCHAR(50)
         DECLARE @ARInvoiceNumber VARCHAR(50)
         DECLARE @BillingWeek VARCHAR(50)
         DECLARE @InvoiceDept VARCHAR(50)
         DECLARE @PaymentAmount VARCHAR(50)
         DECLARE @PaymentReceived VARCHAR(50)
         DECLARE @PaymentSent VARCHAR(50)
         DECLARE @CheckNumber VARCHAR(50)
         DECLARE @FILEID INT
         DECLARE @INVOICEID INT
         DECLARE @_InvoiceDate DATE
         DECLARE @_PaymentSent DATE
         DECLARE @InvoiceDueDate DATE
         DECLARE @AlreadyExistInvoice INT
         DECLARE @MyLoop1 INT
         DECLARE @AlreadyExistFile INT
         DECLARE @ERRORLOOP INT
         
         DECLARE @Update varchar(10) = 'Update'
         
 		
		 
					DELETE FROM AR.global.tblUploadTempsContractor WHERE (ICFirstName = 'Update')  
      													   AND (ICLastName = 'Update') AND (ICInvoiceNumber = 'Update') AND (ICInvoiceAmount = 'Update') 
      													   AND (ICInvoiceDate = 'Update') AND (ARInvoiceNumber = 'Update')
      													   AND (ICPayment = 'Update')AND (ICPaySent = 'Update') AND (ICCheckNumber = 'Update') 
					
					
					
				
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					
					SET @MyLoop1 = (SELECT    COUNT(global.tblUploadTempsContractor.UploadId) AS TotalCount FROM global.tblUploadTempsContractor  WITH(READPAST,ROWLOCK) 
                                    WHERE  PendingUploadId = @PendingUploadId)
				    
					WHILE (@MyLoop1 > 0)
					BEGIN
					    
							 SELECT  TOP 1   @UploadId = UploadId,@FirstName = ICFirstName , @LastName = ICLastName,  
										@InvoiceNumber = ICInvoiceNumber, @InvoiceAmount = ICInvoiceAmount,@ARInvoiceNumber = ARInvoiceNumber, @InvoiceDate = ICInvoiceDate ,
										@InvoiceDept = InvoiceDept, @PaymentAmount = ICPayment, @PaymentSent = ICPaySent, 
										@CheckNumber = ICCheckNumber  FROM global.tblUploadTempsContractor  WITH(READPAST,ROWLOCK)  
										WHERE  PendingUploadId = @PendingUploadId
		                    
		                    
		                     SET @ERRORLOOP = @UploadId
							 
							   
							  
							  ---tblFiles----------------------
							  
							  SET @AlreadyExistFile  = (SELECT  Count(tblFiles.FileID) as TotalCount FROM global.tblFiles WITH(READPAST,ROWLOCK) 
															   WHERE  tblFiles.DepartmentID = 5 AND tblFiles.FirstName = @FirstName 
															           AND tblFiles.LastName = @LastName AND tblFiles.IsDeleted = 0)
															   
							  
							  IF (@AlreadyExistFile > 0)
							  BEGIN
									  SET 	@FILEID = (SELECT  tblFiles.FileID FROM global.tblFiles WITH(READPAST,ROWLOCK)
															   WHERE  tblFiles.DepartmentID = 5 AND tblFiles.FirstName = @FirstName 
															   AND tblFiles.LastName = @LastName AND tblFiles.IsDeleted = 0)
							  END
							  ELSE
							  BEGIN
							  
									  INSERT INTO global.tblFiles (FirstName,LastName,ClaimNumber,InsurerId,InsurerBranchId,EmployerId,AdjusterId,
																	IsLienClaimNumber,IsLienInsurerID,IsLienInsurerBranchID,IsLienEmployerID,IsLienAdjusterID,DepartmentID) 
															VALUES(@FirstName,@LastName,NULL,0,0,0,0,
																	0,0,0,0,0,@Department)
															
									  SET 	@FILEID = 	(SELECT SCOPE_IDENTITY())
					                 
							         	
							  END	            
							--------------------------------------------------           
												
												
										
										
												            
							 -----tblInvoices-------
							 IF(@InvoiceNumber <> @Update AND @InvoiceAmount <> @Update AND @InvoiceDate <> @Update)
						     BEGIN								
								 SET @_InvoiceDate =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@InvoiceDate)) as InvoiceDate)
							 END
		                         
								IF(@Department=5)
								BEGIN
								SET @InvoiceDept = 5
								END
		                         
							  SET @AlreadyExistInvoice = (SELECT  Count(tblFiles.FileID) as TotalCount FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																   global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber and tblFiles.DepartmentID = 5)
		                     
							  IF (@AlreadyExistInvoice > 0)
							  BEGIN
									  SET 	@INVOICEID = (SELECT  tblInvoices.InvoiceID FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																   global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber and tblFiles.DepartmentID = 5)
														   
							          SET @_DbInvoiceBalanceAmount = (SELECT  tblInvoices.InvoiceBalanceAmt FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																             global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														                     WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber and tblFiles.DepartmentID = 5)
			                          
			                              
		                              IF(@PaymentAmount <> @Update)
									  BEGIN											  
											  SET @_PaymentAmount = @PaymentAmount
											  SET @_TotalInvoiceBalanceAmount = @_DbInvoiceBalanceAmount - @_PaymentAmount
											  
											  UPDATE global.tblInvoices SET InvoiceBalanceAmt = @_TotalInvoiceBalanceAmount 
											  WHERE InvoiceID = @INVOICEID AND FileId = @FILEID
									  END
									  
														                     
			                          
							  END
							  ELSE
							  BEGIN
							       
							       
							       IF(@InvoiceNumber <> @Update AND @InvoiceAmount <> @Update AND @InvoiceDate <> @Update)
						           BEGIN
						                  SET @InvoiceDueDate = (SELECT DATEADD(dd,30,@_InvoiceDate) [InvoiceDueDate])						                  
						                 
						                  
										  IF(@PaymentAmount <> @Update)
										  BEGIN
												  SET @_InvoiceAmount = @InvoiceAmount
												  SET @_PaymentAmount = @PaymentAmount
												  SET @InvoiceBalanceAmount = @_InvoiceAmount - @_PaymentAmount
										  END
										  ELSE
										  BEGIN 
												  SET @InvoiceBalanceAmount = @InvoiceAmount 
										  END
						              
						              
									  INSERT INTO global.tblInvoices (FileId,InvoiceNumber,InvoiceAmt,InvoiceDate,InvoiceDueDate,InvoiceSent,BillingWeek,DepartmentId,InvoiceBalanceAmt)
															   VALUES(@FILEID,@InvoiceNumber,@InvoiceAmount,@_InvoiceDate,@InvoiceDueDate,@_InvoiceDate,NULL,@InvoiceDept,@InvoiceBalanceAmount)
				                                               
									  SET 	@INVOICEID = (SELECT SCOPE_IDENTITY())	
									  
								   END
								   ELSE
								   BEGIN
								      SET 	@INVOICEID = 0
								   
								   END
							  END
		                     
		                     
		                     
		                     
		                     
							 -----tblPayments--------------------------------
							 -------------------------------------------------
							 IF(@INVOICEID <> 0 AND @PaymentAmount <> @Update)
						     BEGIN	
						        
								 INSERT INTO global.tblPayments (InvoiceId,PaymentAmount,PaymentReceived,CheckNumber,PendingUploadId)
														VALUES (@INVOICEID, (CASE WHEN @PaymentAmount=@Update THEN 0 ELSE Convert(money,@PaymentAmount) END),
														NULL,(CASE WHEN @CheckNumber=@Update THEN NULL ELSE @CheckNumber END),@PendingUploadId)				            
			                 END	
			                 
			                 -----tblIndependentContractorDepartment--------------------
			                 -------------------------------------------------
			                  IF(@PaymentSent <> @Update)
						      BEGIN
						            SET @_PaymentSent =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@PaymentSent)) as PaymentSent)
						      END
			                            INSERT INTO global.tblIndependentContractorDepartment(IndepContractorDeptFirstName,IndepContractorDeptLastName,IndepContractorDeptInvoiceNumber,IndepContractorDeptInvoiceDate,
			                                                                       IndepContractorDeptInvoiceAmt,IndepContractorDeptARInvoiceNumber,IndepContractorDeptPaymentAmt,IndepContractorDeptPaymentSent,
			                                                                       IndepContractorDeptCheckNumber)
			                             VALUES(@FirstName,@LastName,@InvoiceNumber,(CASE WHEN @InvoiceDate=@Update THEN NULL ELSE @_InvoiceDate END) ,(CASE WHEN @InvoiceAmount=@Update THEN 0 ELSE Convert(money,@InvoiceAmount) END),
			                             @ARInvoiceNumber,(CASE WHEN @PaymentAmount=@Update THEN 0 ELSE Convert(money,@PaymentAmount) END),(CASE WHEN @PaymentSent=@Update THEN NULL ELSE @_PaymentSent END),@CheckNumber)
			              
			                 
			                 
			                 
			                 
			                 
			                  						           
							  ---------DELETE THE PROCESSED ENTRY---------------
								 DELETE FROM global.tblUploadTempsContractor WITH(READPAST,ROWLOCK)
								 WHERE       global.tblUploadTempsContractor.UploadId =@UploadId AND global.tblUploadTempsContractor.PendingUploadId = @PendingUploadId
								 
								 
								 
								SET @MyLoop1 = @MyLoop1 -1
						 
		            
					
					END				 	
					 	
			 		 	
									
									
				 DELETE FROM global.tblUploadTempsContractor	WITH(READPAST,ROWLOCK)
				 WHERE       global.tblUploadTempsContractor.PendingUploadId = @PendingUploadId 
		            
 
				   
		    UPDATE global.tblPendingUploads WITH(READPAST,ROWLOCK) SET IsProcessed = 1,ProcessedBy = @UserID,ProcessedOn = getdate() where PendingUploadId = @PendingUploadId
            
		    SELECT  NULL AS ErrorNumberLoop,NULL AS ErrorNumber,NULL AS ErrorSeverity,NULL AS ErrorState,NULL AS ErrorLine,'NULL' AS ErrorProcedure,'NULL' AS ErrorMessage
	COMMIT TRANSACTION	[Trans1]			
    END TRY
	BEGIN CATCH	    
	 	 SELECT @ERRORLOOP AS ErrorNumberLoop,
         ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_LINE () AS ErrorLine
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_MESSAGE() AS ErrorMessage;	
         ROLLBACK TRANSACTION [Tran1]
		
	END CATCH	

END

GO
/****** Object:  StoredProcedure [global].[Move_TempUploadDataDepLien]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 13 JULY 2015
-- Description : THIS SP IS USED FOR MOVE DATA IN  LIEN DEPARTMENT
--               INSERTING FROM EXCEL UPLOAD TEMP TABLE / SPRINT 2/ [US#2446]
-- Version     : 1.0
-- ===================================================================================
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 28 JAN 2016
-- Description : Remove FirstName and LastName Validation               
--  Version    : 1.1
-- ===================================================================================

CREATE PROCEDURE [global].[Move_TempUploadDataDepLien] 
@Department INT,
@PendingUploadId INT,
@UserID INT	
AS
BEGIN
   
   BEGIN TRANSACTION [Trans1]  
   BEGIN TRY
   
         DECLARE @InsurerId INT
         DECLARE @AdjusterId INT
         DECLARE @EmployerId INT
         DECLARE @InsurerBranchId INT
         DECLARE @IsLienInsurerID INT
         DECLARE @IsLienInsurerBranchID INT
         DECLARE @IsLienEmployerID INT
         DECLARE @IsLienAdjusterID INT
         DECLARE @AdjusterCount INT
         DECLARE @AdjusterCountIn INT
         DECLARE @UploadId INT
         DECLARE @FirstName VARCHAR(50)
         DECLARE @LastName VARCHAR(50)
         DECLARE @Claim VARCHAR(100)
         DECLARE @Insurer VARCHAR(50)
         DECLARE @InsurerBranch VARCHAR(50)
         DECLARE @Employer VARCHAR(50)
         DECLARE @Adjuster VARCHAR(50)
         DECLARE @InvoiceNumber VARCHAR(50)
         DECLARE @InvoiceAmount VARCHAR(255)
         DECLARE @InvoiceDate VARCHAR(50)
         DECLARE @InvoiceSent VARCHAR(50)
         DECLARE @BillingWeek VARCHAR(50)
         DECLARE @InvoiceDept VARCHAR(50)
         DECLARE @PaymentAmount VARCHAR(50)
         DECLARE @PaymentReceived VARCHAR(50)
         DECLARE @CheckNumber VARCHAR(50)
         DECLARE @FILEID INT
         DECLARE @INVOICEID INT
         DECLARE @_InvoiceDate DATE
         DECLARE @_InvoiceDueDate DATE
         DECLARE @_InvoiceSent DATE
         DECLARE @_BillingWeek DATE
         DECLARE @_PaymentReceived DATE
         DECLARE @InvoiceBalanceAmount MONEY
         DECLARE @_InvoiceAmount MONEY
         DECLARE @_InvoiceBalanceAmount MONEY
         DECLARE @_PaymentAmount MONEY
         DECLARE @_TotalInvoiceBalanceAmount MONEY
         DECLARE @_DbInvoiceBalanceAmount MONEY
         DECLARE @AlreadyExistInvoice INT
         DECLARE @MyLoop1 INT
         DECLARE @MyLoop2 INT
         DECLARE @MyLoop3 INT
         DECLARE @MyLoopCheck1 INT
         DECLARE @MyLoopCheck2 INT
         DECLARE @MyClaimNumber VARCHAR(100)
         DECLARE @CHECKINSERT INT
         DECLARE @ERRORLOOP INT
         DECLARE @LienClaimNumber VARCHAR(100)
         
         DECLARE @Update varchar(10) = 'Update'
         
 		
		    ---    a.	If Dept Dropdown = “Lien”, Check Liens.dbo.LienFile for 
			  ---	      i.	PatientClaim = LienFileClaimNumber
			         --      1.	If match, then we can pull Patient Data form Liens DB
					 	--			a.	There is no need to store FirstName and LastName since it already exists in Liens.dbo.LienFile			 
					
					------------Check data in temp table having claim blank should update if found more than one record go to tblLienTempTable------------
					--------------------------------------------------------------------------------------------------------------------------------------
					DELETE FROM AR.global.tblUploadTemps WHERE (FirstName = 'Update')  
      													   AND (LastName = 'Update') AND (Claim = 'Update') AND (Insurer = 'Update')
      													   AND (InsurerBranch = 'Update') AND (Employer = 'Update') AND (Adjuster = 'Update')
      													   AND (InvoiceNumber = 'Update') AND (InvoiceAmount = 'Update') AND (InvoiceDate = 'Update')
      													   AND (InvoiceSent = 'Update') AND (BillingWeek = 'Update') AND (PaymentAmount = 'Update')
      													   AND (PaymentReceived = 'Update') AND (CheckNumber = 'Update') 
					
					
					
					--SET @MyLoop1 = (SELECT   COUNT(global.tblUploadTemps.UploadId) AS TotalCount FROM global.tblUploadTemps WITH(READPAST,ROWLOCK)
				 --                   WHERE      global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.InvoiceDept = 1 AND  
				 --                   global.tblUploadTemps.Claim = @Update AND global.tblUploadTemps.FirstName<> @Update AND global.tblUploadTemps.LastName <> @Update AND global.tblUploadTemps.Insurer <> @Update)
				 --   SET @ERRORLOOP = 0
				 --   WHILE (@MyLoop1 > 0)
				 --   BEGIN
				          
				 --         SELECT  TOP 1 @UploadId = global.tblUploadTemps.UploadId,@FirstName = global.tblUploadTemps.FirstName , @LastName =global.tblUploadTemps.LastName , @Claim=global.tblUploadTemps.Claim, 
					--					@Insurer = global.tblUploadTemps.Insurer, @InsurerBranch=global.tblUploadTemps.InsurerBranch, @Employer = global.tblUploadTemps.Employer, @Adjuster=global.tblUploadTemps.Adjuster, 
					--					@InvoiceNumber = global.tblUploadTemps.InvoiceNumber, @InvoiceAmount = global.tblUploadTemps.InvoiceAmount, @InvoiceDate =global.tblUploadTemps.InvoiceDate ,
					--					@InvoiceSent = global.tblUploadTemps.InvoiceSent , @BillingWeek= global.tblUploadTemps.BillingWeek,
					--					@InvoiceDept = global.tblUploadTemps.InvoiceDept, @PaymentAmount = global.tblUploadTemps.PaymentAmount, @PaymentReceived = global.tblUploadTemps.PaymentReceived, 
					--					@CheckNumber = global.tblUploadTemps.CheckNumber  FROM global.tblUploadTemps  WITH(READPAST,ROWLOCK) 
				 --         WHERE         global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.InvoiceDept = 1 AND  global.tblUploadTemps.Claim = @Update	
				 --                       AND global.tblUploadTemps.FirstName<> @Update AND global.tblUploadTemps.LastName <> @Update AND global.tblUploadTemps.Insurer <> @Update
					  
				 --         SET @ERRORLOOP = @UploadId
				 --         SET @MyLoopCheck1 =(SELECT count(*) FROM Liens.dbo.LienFile WITH(READPAST,ROWLOCK) INNER JOIN
					--						 Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) ON Liens.dbo.insuranceBilling.InsurerID = Liens.dbo.LienFile.lienInsurerId
					--						 WHERE  Liens.dbo.LienFile.lienFileClaimantFirstName = @FirstName AND Liens.dbo.LienFile.lienFileClaimantLastName = @LastName AND Liens.dbo.insuranceBilling.InsurerName = @Insurer)
											 
											 
					--      IF(@MyLoopCheck1 =1)
					--      BEGIN
					      
					--           SET @MyClaimNumber =(SELECT lienFileClaimNumber FROM Liens.dbo.LienFile WITH(READPAST,ROWLOCK)INNER JOIN
					--						        Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) ON Liens.dbo.insuranceBilling.InsurerID = Liens.dbo.LienFile.lienInsurerId
					--						        WHERE  Liens.dbo.LienFile.lienFileClaimantFirstName = @FirstName AND Liens.dbo.LienFile.lienFileClaimantLastName = @LastName AND Liens.dbo.insuranceBilling.InsurerName = @Insurer)
											 
											 
					--           UPDATE  global.tblUploadTemps WITH(READPAST,ROWLOCK) SET Claim = @MyClaimNumber 
					--                   WHERE UploadId = @UploadId
					--      END
					--      ELSE					           
					--      BEGIN
					--             INSERT INTO global.tblLienTempTables(FirstName,LastName,Claim,Insurer,InsurerBranch,Employer,Adjuster,InvoiceNumber,InvoiceAmount,InvoiceDate,
					--								InvoiceSent,BillingWeek,InvoiceDept,PaymentAmount,PaymentReceived,CheckNumber,LienDataValidate,Reason,PendingUploadId)
					--								VALUES(@FirstName,@LastName,@Claim,@Insurer,@InsurerBranch,@Employer,@Adjuster,@InvoiceNumber,@InvoiceAmount,@InvoiceDate,
					--								@InvoiceSent,@BillingWeek,@InvoiceDept,@PaymentAmount,@PaymentReceived,@CheckNumber,0 ,'Claim Number Duplicate',@PendingUploadId)
													
					--      END
				          
				 --         DELETE FROM global.tblUploadTemps WITH(READPAST,ROWLOCK)
				 --                WHERE     global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.UploadId =@UploadId 
				 --                          AND global.tblUploadTemps.InvoiceDept = 1 AND  global.tblUploadTemps.Claim = @Update
				          
				 --         SET @MyLoop1 = @MyLoop1 -1
				          
				          
				    
				 --   END
					
					-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			    	-----------------Check data in temp table having claim NON LR should CHECK firstname,LastName,Insurer update if found more than one record go to tblLienTempTable------------
					-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						
					SET @MyLoop2 = (SELECT    COUNT(global.tblUploadTemps.UploadId) AS TotalCount FROM global.tblUploadTemps  WITH(READPAST,ROWLOCK) 
									WHERE     global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.InvoiceDept = 1 AND global.tblUploadTemps.Claim <> @Update
									          AND global.tblUploadTemps.FirstName<> @Update AND global.tblUploadTemps.LastName <> @Update AND global.tblUploadTemps.Insurer <> @Update
										      AND  global.tblUploadTemps.Claim NOT IN (SELECT  lienFileClaimNumber FROM    Liens.dbo.LienFile WITH(READPAST,ROWLOCK) 
					                          INNER JOIN global.tblUploadTemps  WITH(READPAST,ROWLOCK) ON Liens.dbo.lienFile.lienFileClaimNumber = global.tblUploadTemps.Claim
																WHERE global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.Claim <> @Update))
				    
				    WHILE (@MyLoop2 > 0)
				    BEGIN
				          
				          SELECT  TOP 1 @UploadId = global.tblUploadTemps.UploadId,@FirstName = global.tblUploadTemps.FirstName , @LastName =global.tblUploadTemps.LastName , @Claim=global.tblUploadTemps.Claim, 
										@Insurer = global.tblUploadTemps.Insurer, @InsurerBranch=global.tblUploadTemps.InsurerBranch, @Employer = global.tblUploadTemps.Employer, @Adjuster=global.tblUploadTemps.Adjuster, 
										@InvoiceNumber = global.tblUploadTemps.InvoiceNumber, @InvoiceAmount = global.tblUploadTemps.InvoiceAmount, @InvoiceDate =global.tblUploadTemps.InvoiceDate ,
										@InvoiceSent = global.tblUploadTemps.InvoiceSent , @BillingWeek= global.tblUploadTemps.BillingWeek,
										@InvoiceDept = global.tblUploadTemps.InvoiceDept, @PaymentAmount = global.tblUploadTemps.PaymentAmount, @PaymentReceived = global.tblUploadTemps.PaymentReceived, 
										@CheckNumber = global.tblUploadTemps.CheckNumber  FROM global.tblUploadTemps  WITH(READPAST,ROWLOCK) 
				          WHERE         global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.InvoiceDept = 1 AND global.tblUploadTemps.Claim <> @Update 
				                        AND global.tblUploadTemps.FirstName<> @Update AND global.tblUploadTemps.LastName <> @Update AND global.tblUploadTemps.Insurer <> @Update
				                        AND  global.tblUploadTemps.Claim NOT IN (SELECT  lienFileClaimNumber FROM    Liens.dbo.LienFile WITH(READPAST,ROWLOCK) 
					                        INNER JOIN global.tblUploadTemps  WITH(READPAST,ROWLOCK) ON Liens.dbo.lienFile.lienFileClaimNumber = global.tblUploadTemps.Claim
																WHERE global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.Claim <> @Update)
					  
				          SET @ERRORLOOP = @UploadId
				          SET @CHECKINSERT = 0
				          SET @MyLoopCheck2 =(SELECT count(*) FROM Liens.dbo.LienFile WITH(READPAST,ROWLOCK) INNER JOIN
											 Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) ON Liens.dbo.insuranceBilling.InsurerID = Liens.dbo.LienFile.lienInsurerId
											 WHERE  Liens.dbo.LienFile.lienFileClaimantFirstName = @FirstName AND Liens.dbo.LienFile.lienFileClaimantLastName = @LastName AND Liens.dbo.insuranceBilling.InsurerName = @Insurer)
											 
									 
					      IF(@MyLoopCheck2 = 1)
					      BEGIN
					      
					           SET @MyClaimNumber =(SELECT lienFileClaimNumber FROM Liens.dbo.LienFile WITH(READPAST,ROWLOCK) INNER JOIN
											        Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) ON Liens.dbo.insuranceBilling.InsurerID = Liens.dbo.LienFile.lienInsurerId
											        WHERE  Liens.dbo.LienFile.lienFileClaimantFirstName = @FirstName AND Liens.dbo.LienFile.lienFileClaimantLastName = @LastName AND Liens.dbo.insuranceBilling.InsurerName = @Insurer)
											 
											 
					           UPDATE  global.tblUploadTemps WITH(READPAST,ROWLOCK) SET Claim = @MyClaimNumber 
					                   WHERE UploadId = @UploadId
					      END
					      ELSE					           
					      BEGIN
					            INSERT INTO global.tblLienTempTables(FirstName,LastName,Claim,Insurer,InsurerBranch,Employer,Adjuster,InvoiceNumber,InvoiceAmount,InvoiceDate,
													InvoiceSent,BillingWeek,InvoiceDept,PaymentAmount,PaymentReceived,CheckNumber,LienDataValidate,Reason,PendingUploadId)
													VALUES(@FirstName,@LastName,@Claim,@Insurer,@InsurerBranch,@Employer,@Adjuster,@InvoiceNumber,@InvoiceAmount,@InvoiceDate,
													@InvoiceSent,@BillingWeek,@InvoiceDept,@PaymentAmount,@PaymentReceived,@CheckNumber,0 ,'Claim Number Duplicate',@PendingUploadId)
							    SET @CHECKINSERT =	(SELECT SCOPE_IDENTITY())	
					      END
				          
				          IF(@CHECKINSERT > 0)
				          BEGIN
								  DELETE FROM global.tblUploadTemps WITH(READPAST,ROWLOCK)
										 WHERE     global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.UploadId =@UploadId 
												   AND global.tblUploadTemps.InvoiceDept = 1 
				          END
				          
				          SET @MyLoop2 = @MyLoop2 -1
				          
				          
				    
				    END
					
					---------------------------------------------------------------------------------------------------------------------------------------------
					
					
					
					SET @MyLoop3 = (SELECT  COUNT(lienFileClaimNumber) AS TotalCount 
					                FROM    Liens.dbo.LienFile WITH(READPAST,ROWLOCK) 
					                        INNER JOIN global.tblUploadTemps  WITH(READPAST,ROWLOCK) ON Liens.dbo.lienFile.lienFileClaimNumber = global.tblUploadTemps.Claim
																WHERE global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.Claim <> @Update)
				    
					WHILE (@MyLoop3 > 0)
					BEGIN
					    
					        SET @LienClaimNumber = (SELECT Top 1 lienFileClaimNumber FROM    Liens.dbo.LienFile WITH(READPAST,ROWLOCK) 
					                                           INNER JOIN global.tblUploadTemps  WITH(READPAST,ROWLOCK) ON Liens.dbo.lienFile.lienFileClaimNumber = global.tblUploadTemps.Claim
																WHERE global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.Claim <> @Update)
					    
					    
					    
							 SELECT  TOP 1   @UploadId = global.tblUploadTemps.UploadId,@FirstName = Liens.dbo.LienFile.lienFileClaimantFirstName , @LastName =Liens.dbo.LienFile.lienFileClaimantLastName , @Claim=Liens.dbo.LienFile.lienFileClaimNumber, 
										@InsurerId = Liens.dbo.LienFile.lienInsurerId, @InsurerBranchId=Liens.dbo.LienFile.lienInsurerBranchId, @EmployerId = Liens.dbo.LienFile.lienEmployerId, @AdjusterId=Liens.dbo.LienFile.lienAdjusterId, 
										@InvoiceNumber = global.tblUploadTemps.InvoiceNumber, @InvoiceAmount = global.tblUploadTemps.InvoiceAmount, @InvoiceDate =global.tblUploadTemps.InvoiceDate ,
										@InvoiceSent = global.tblUploadTemps.InvoiceSent , @BillingWeek= global.tblUploadTemps.BillingWeek,
										@InvoiceDept = global.tblUploadTemps.InvoiceDept, @PaymentAmount = global.tblUploadTemps.PaymentAmount, @PaymentReceived = global.tblUploadTemps.PaymentReceived, 
										@CheckNumber = global.tblUploadTemps.CheckNumber  FROM global.tblUploadTemps  WITH(READPAST,ROWLOCK)  INNER JOIN
										Liens.dbo.LienFile WITH(READPAST,ROWLOCK) ON Liens.dbo.LienFile.lienFileClaimNumber = global.tblUploadTemps.Claim 
							 WHERE      global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.Claim = @LienClaimNumber
										   	                  
		                    
		                    
		                     SET @ERRORLOOP = @UploadId
							 
							   
							  
						  ---tblFiles----------------------
						  IF EXISTS(SELECT * FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE ClaimNumber = LTRIM(RTRIM(@Claim)) AND IsDeleted = 0)
						  BEGIN
								  SET 	@FILEID = (SELECT FileID FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE ClaimNumber = LTRIM(RTRIM(@Claim)) AND IsDeleted = 0)
						  END
						  ELSE
						  BEGIN
						          IF(@Claim = @Update)
						          BEGIN
						               
						                 IF EXISTS(SELECT * FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE FirstName =LTRIM(RTRIM(@FirstName)) AND LastName =LTRIM(RTRIM(@LastName)) AND InsurerId=LTRIM(RTRIM(@InsurerId)) AND IsDeleted = 0)
						                 BEGIN
						                        SET 	@FILEID = (SELECT FileID FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE FirstName =@FirstName AND LastName =@LastName AND InsurerId=@InsurerId AND IsDeleted = 0)
						                 END
						                 ELSE
						                 BEGIN
												  INSERT INTO global.tblFiles (FirstName,LastName,ClaimNumber,InsurerId,InsurerBranchId,EmployerId,AdjusterId,
																				IsLienClaimNumber,IsLienInsurerID,IsLienInsurerBranchID,IsLienEmployerID,IsLienAdjusterID,DepartmentID) 
																		VALUES(@FirstName,@LastName,@Claim,@InsurerId,@InsurerBranchId,@EmployerId,@AdjusterId,
																				1,1,1,1,1,@Department)
																
												  SET 	@FILEID = 	(SELECT SCOPE_IDENTITY())
						                 END
						          END
						          ELSE
						          BEGIN						  
										  INSERT INTO global.tblFiles (FirstName,LastName,ClaimNumber,InsurerId,InsurerBranchId,EmployerId,AdjusterId,
																		IsLienClaimNumber,IsLienInsurerID,IsLienInsurerBranchID,IsLienEmployerID,IsLienAdjusterID,DepartmentID) 
																VALUES(@FirstName,@LastName,@Claim,@InsurerId,@InsurerBranchId,@EmployerId,@AdjusterId,
																		1,1,1,1,1,@Department)
														
										  SET 	@FILEID = 	(SELECT SCOPE_IDENTITY())
								  END		
						  END	            
						--------------------------------------------------           
												
												
										
										
												            
							 -----tblInvoices-------
							 IF(@InvoiceNumber <> @Update AND @InvoiceAmount <> @Update AND @InvoiceDate <> @Update AND @InvoiceSent <> @Update AND @BillingWeek <> @Update)
						     BEGIN								
								 SET @_InvoiceDate =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@InvoiceDate)) as InvoiceDate)
							     SET @_InvoiceSent =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@InvoiceSent)) as InvoiceSent)
							     SET @_BillingWeek =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@BillingWeek)) as BillingWeek)
							 END
		                         
								IF(@Department=1)
								BEGIN
								SET @InvoiceDept = 1
								END
								ELSE IF(@Department=2)
								BEGIN
								   SET @InvoiceDept = 2
								END
								ELSE IF(@Department=3)
								BEGIN
								   SET @InvoiceDept = 3
								END
								ELSE IF(@Department=4)
								BEGIN
								   SET @InvoiceDept = 4
								END	
		                         
							  SET @AlreadyExistInvoice = (SELECT  Count(tblFiles.FileID) as TotalCount FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																   global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
		                     
							  IF (@AlreadyExistInvoice > 0)
							  BEGIN
									  SET 	@INVOICEID = (SELECT  tblInvoices.InvoiceID FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																   global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
														   
						              SET @_DbInvoiceBalanceAmount = (SELECT  tblInvoices.InvoiceBalanceAmt FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																             global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														                     WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
			                          
			                              
									  IF(@PaymentAmount <> @Update)
									  BEGIN											  
											  SET @_PaymentAmount = @PaymentAmount
											  SET @_TotalInvoiceBalanceAmount = @_DbInvoiceBalanceAmount - @_PaymentAmount
											  
											  UPDATE global.tblInvoices SET InvoiceBalanceAmt = @_TotalInvoiceBalanceAmount 
											  WHERE InvoiceID = @INVOICEID AND FileId = @FILEID
									  END
							  END
							  ELSE
							  BEGIN
							       
							       IF(@InvoiceNumber <> @Update AND @InvoiceAmount <> @Update AND @InvoiceDate <> @Update AND @InvoiceSent <> @Update AND @BillingWeek <> @Update)
						           BEGIN
						                  IF(@PaymentAmount <> @Update)
										  BEGIN
												  SET @_InvoiceAmount = @InvoiceAmount
												  SET @_PaymentAmount = @PaymentAmount
												  SET @InvoiceBalanceAmount = @_InvoiceAmount - @_PaymentAmount
										  END
										  ELSE
										  BEGIN 
												  SET @InvoiceBalanceAmount = @InvoiceAmount 
										  END
										  
										  SET @_InvoiceDueDate =  (SELECT  Convert(date,[global].[Get_AddWorkDays](30,@_InvoiceDate)) as InvoiceDueDate)--Calculating 30 Networking days
										  
									  INSERT INTO global.tblInvoices (FileId,InvoiceNumber,InvoiceAmt,InvoiceDate,InvoiceDueDate,InvoiceSent,BillingWeek,DepartmentId,InvoiceBalanceAmt)
															   VALUES(@FILEID,@InvoiceNumber,@InvoiceAmount,@_InvoiceDate,@_InvoiceDueDate,@_InvoiceSent,@_BillingWeek,@InvoiceDept,@InvoiceBalanceAmount)
				                                               
									  SET 	@INVOICEID = (SELECT SCOPE_IDENTITY())	
								   END
								   ELSE
								   BEGIN
								      SET 	@INVOICEID = 0
								   
								   END
							  END
		                     
		                     
		                     
		                     
		                     
							 -----tblPayments--------------------------------
							 -------------------------------------------------
							 IF(@INVOICEID <> 0 AND @PaymentAmount <> @Update)
						     BEGIN	
						         IF(@PaymentReceived <> @Update)
						         BEGIN				         
		                               SET @_PaymentReceived =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@PaymentReceived)) as PaymentReceived)
		                         END
								 INSERT INTO global.tblPayments (InvoiceId,PaymentAmount,PaymentReceived,CheckNumber,PendingUploadId)
														VALUES (@INVOICEID, (CASE WHEN @PaymentAmount=@Update THEN 0 ELSE Convert(money,@PaymentAmount) END),
														(CASE WHEN @PaymentReceived=@Update THEN NULL ELSE @_PaymentReceived END),(CASE WHEN @CheckNumber=@Update THEN NULL ELSE @CheckNumber END),@PendingUploadId)				            
			                 END	 						           
							  ---------DELTE THE PROCESSED ENTRY---------------
								 DELETE FROM global.tblUploadTemps WITH(READPAST,ROWLOCK)
								 WHERE       global.tblUploadTemps.UploadId =@UploadId
								 
								SET @FirstName = ''  SET @LastName = ''  SET @Claim = ''  SET @InsurerId = 0 SET @InsurerBranchId = 0 SET @EmployerId = 0 SET @AdjusterId = 0
								 
								SET @MyLoop3 = @MyLoop3 -1
						 
		            
					
					END				 	
					 	
			 		 	
				   -----------------------------------------------------------------------------------------------------------------------
					 	
					 
				
					
					
					
					 	
                ----------Check data in temp table having  blank should be go to tblLienTempTable--------------------------
					----------------------------------------------------------------------------------------------------------- 	
					 	
					 INSERT INTO global.tblLienTempTables(FirstName,LastName,Claim,Insurer,InsurerBranch,Employer,Adjuster,InvoiceNumber,InvoiceAmount,InvoiceDate,
													InvoiceSent,BillingWeek,InvoiceDept,PaymentAmount,PaymentReceived,CheckNumber,LienDataValidate,Reason,PendingUploadId)		      
                     SELECT     global.tblUploadTemps.FirstName,global.tblUploadTemps.LastName,global.tblUploadTemps.Claim, 
                                global.tblUploadTemps.Insurer,global.tblUploadTemps.InsurerBranch,global.tblUploadTemps.Employer,global.tblUploadTemps.Adjuster, 
                                global.tblUploadTemps.InvoiceNumber, global.tblUploadTemps.InvoiceAmount,global.tblUploadTemps.InvoiceDate,
                                global.tblUploadTemps.InvoiceSent ,  global.tblUploadTemps.BillingWeek ,
                                global.tblUploadTemps.InvoiceDept, global.tblUploadTemps.PaymentAmount, global.tblUploadTemps.PaymentReceived, 
                                global.tblUploadTemps.CheckNumber,0 AS LienDataValidate,'Claim Number not matched' as Reason,@PendingUploadId as PendingUploadID
                                FROM global.tblUploadTemps WITH(READPAST,ROWLOCK)
				     WHERE      global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.InvoiceDept = 1 AND  (global.tblUploadTemps.FirstName = @Update
				                OR   global.tblUploadTemps.LastName = @Update OR global.tblUploadTemps.Insurer = @Update)	
					 	
					
					 	
				     DELETE FROM global.tblUploadTemps	WITH(READPAST,ROWLOCK)
				     WHERE      global.tblUploadTemps.PendingUploadId = @PendingUploadId AND global.tblUploadTemps.InvoiceDept = 1 AND  (global.tblUploadTemps.FirstName = @Update
				                OR   global.tblUploadTemps.LastName = @Update OR global.tblUploadTemps.Insurer = @Update) 	
					 	
					 	
					----------------------------------------------------------------------------------------------------------------- 	
					
					       
		 
		 
		 
	             --  2.	If no match, then hold parse data in temp db that will display for user to update Claim Number to match LienFileClaimNumber.     
		 
		 
		 
		                     
                INSERT INTO global.tblLienTempTables(FirstName,LastName,Claim,Insurer,InsurerBranch,Employer,Adjuster,InvoiceNumber,InvoiceAmount,InvoiceDate,
													InvoiceSent,BillingWeek,InvoiceDept,PaymentAmount,PaymentReceived,CheckNumber,LienDataValidate,Reason,PendingUploadId)		      
                SELECT     global.tblUploadTemps.FirstName , global.tblUploadTemps.LastName , global.tblUploadTemps.Claim, 
                           global.tblUploadTemps.Insurer, global.tblUploadTemps.InsurerBranch, global.tblUploadTemps.Employer, global.tblUploadTemps.Adjuster, 
                           global.tblUploadTemps.InvoiceNumber, global.tblUploadTemps.InvoiceAmount,global.tblUploadTemps.InvoiceDate,
                           global.tblUploadTemps.InvoiceSent,  global.tblUploadTemps.BillingWeek,
                           global.tblUploadTemps.InvoiceDept, global.tblUploadTemps.PaymentAmount, global.tblUploadTemps.PaymentReceived, 
                           global.tblUploadTemps.CheckNumber,0 AS LienDataValidate,'Claim Number not matched' as Reason,@PendingUploadId as PendingUploadID 
                           FROM global.tblUploadTemps WITH(READPAST,ROWLOCK)
				WHERE      global.tblUploadTemps.PendingUploadId = @PendingUploadId 
								
									
				 DELETE FROM global.tblUploadTemps	WITH(READPAST,ROWLOCK)
				 WHERE       global.tblUploadTemps.PendingUploadId = @PendingUploadId 
		            
 
				   
		    UPDATE global.tblPendingUploads WITH(READPAST,ROWLOCK) SET IsProcessed = 1,ProcessedBy = @UserID,ProcessedOn = getdate() where PendingUploadId = @PendingUploadId
            
		    SELECT  NULL AS ErrorNumberLoop,NULL AS ErrorNumber,NULL AS ErrorSeverity,NULL AS ErrorState,NULL AS ErrorLine,'NULL' AS ErrorProcedure,'NULL' AS ErrorMessage
	COMMIT TRANSACTION	[Trans1]			
    END TRY
	BEGIN CATCH	    
	 	 SELECT @ERRORLOOP AS ErrorNumberLoop,
         ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_LINE () AS ErrorLine
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_MESSAGE() AS ErrorMessage;	
         ROLLBACK TRANSACTION [Tran1]
		
	END CATCH	

END

GO
/****** Object:  StoredProcedure [global].[Processed_LienTempTable]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 22 JULY 2015
-- Description : THIS SP IS USED FOR Processed data after updating the claim number
--               then again go for Lien Processed
--  Version    : 1.0
-- ===================================================================================
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 28 JAN 2016
-- Description : Remove FirstName and LastName Validation               
--  Version    : 1.1
-- ===================================================================================
CREATE PROCEDURE [global].[Processed_LienTempTable] 

AS
BEGIN
   
   BEGIN TRANSACTION [Trans1]  
   BEGIN TRY
   
         DECLARE @InsurerId INT
         DECLARE @AdjusterId INT
         DECLARE @EmployerId INT
         DECLARE @InsurerBranchId INT
         DECLARE @IsLienInsurerID INT
         DECLARE @IsLienInsurerBranchID INT
         DECLARE @IsLienEmployerID INT
         DECLARE @IsLienAdjusterID INT
         DECLARE @AdjusterCount INT
         DECLARE @AdjusterCountIn INT
         DECLARE @UploadId INT
         DECLARE @FirstName VARCHAR(50)
         DECLARE @LastName VARCHAR(50)
         DECLARE @Claim VARCHAR(100)
         DECLARE @Insurer VARCHAR(50)
         DECLARE @InsurerBranch VARCHAR(50)
         DECLARE @Employer VARCHAR(50)
         DECLARE @Adjuster VARCHAR(50)
         DECLARE @InvoiceNumber VARCHAR(255)
         DECLARE @InvoiceAmount VARCHAR(50)
         DECLARE @InvoiceDate VARCHAR(50)
         DECLARE @InvoiceSent VARCHAR(50)
         DECLARE @BillingWeek VARCHAR(50)
         DECLARE @InvoiceDept VARCHAR(50)
         DECLARE @PaymentAmount VARCHAR(50)
         DECLARE @PaymentReceived VARCHAR(50)
         DECLARE @CheckNumber VARCHAR(50)
         DECLARE @PendingUploadId INT
         DECLARE @FILEID INT
         DECLARE @INVOICEID INT
         DECLARE @_InvoiceDate DATE
         DECLARE @_InvoiceDueDate DATE
         DECLARE @_InvoiceSent DATE
         DECLARE @_BillingWeek DATE
         DECLARE @_PaymentReceived DATE
         DECLARE @InvoiceBalanceAmount MONEY
         DECLARE @_InvoiceAmount MONEY
         DECLARE @_InvoiceBalanceAmount MONEY
         DECLARE @_PaymentAmount MONEY
         DECLARE @_TotalInvoiceBalanceAmount MONEY
         DECLARE @_DbInvoiceBalanceAmount MONEY
         DECLARE @AlreadyExistInvoice INT
         DECLARE @STATUSCURSOR  INT
         DECLARE @MyLoop1 INT 
         DECLARE @MyLoop2 INT 
         DECLARE @MyLoopCheck1 INT
         DECLARE @MyClaimNumber VARCHAR(100)
         DECLARE @CHECKINSERT INT
         DECLARE @ERRORLOOP INT
         DECLARE @LienClaimNumber VARCHAR(100)
         
         
         DECLARE @Update varchar(10) = 'Update'
		    ---    a.	If Dept Dropdown = “Lien”, Check Liens.dbo.LienFile for 
			  ---	      i.	PatientClaim = LienFileClaimNumber
			         --      1.	If match, then we can pull Patient Data form Liens DB
					 	--			a.	There is no need to store FirstName and LastName since it already exists in Liens.dbo.LienFile
           
                	------------Check data in temp table having claim NON LR should CHECK firstname,LastName,Insurer update if found more than one record go to tblLienTempTable------------
					--------------------------------------------------------------------------------------------------------------------------------------
					
					--SET @MyLoop1 = (SELECT    COUNT(global.tblLienTempTables.UploadId) AS TotalCount FROM global.tblLienTempTables  WITH(READPAST,ROWLOCK) 
					--			    WHERE  global.tblLienTempTables.InvoiceDept = 1 AND global.tblLienTempTables.FirstName <> @Update
				 --                   AND   global.tblLienTempTables.LastName <> @Update AND global.tblLienTempTables.Insurer <> @Update)
				 --   SET @ERRORLOOP = 0
				 --   WHILE (@MyLoop1 > 0)
				 --   BEGIN
				          
				 --         SELECT  TOP 1 @UploadId = global.tblLienTempTables.UploadId,@FirstName = global.tblLienTempTables.FirstName , @LastName =global.tblLienTempTables.LastName , @Claim=global.tblLienTempTables.Claim, 
					--					@Insurer = global.tblLienTempTables.Insurer, @InsurerBranch=global.tblLienTempTables.InsurerBranch, @Employer = global.tblLienTempTables.Employer, @Adjuster=global.tblLienTempTables.Adjuster, 
					--					@InvoiceNumber = global.tblLienTempTables.InvoiceNumber, @InvoiceAmount = global.tblLienTempTables.InvoiceAmount, @InvoiceDate =global.tblLienTempTables.InvoiceDate ,
					--					@InvoiceSent = global.tblLienTempTables.InvoiceSent , @BillingWeek= global.tblLienTempTables.BillingWeek,
					--					@InvoiceDept = global.tblLienTempTables.InvoiceDept, @PaymentAmount = global.tblLienTempTables.PaymentAmount, @PaymentReceived = global.tblLienTempTables.PaymentReceived, 
					--					@CheckNumber = global.tblLienTempTables.CheckNumber  FROM global.tblLienTempTables  WITH(READPAST,ROWLOCK) 
				 --         WHERE         global.tblLienTempTables.InvoiceDept = 1 	AND global.tblLienTempTables.FirstName <> @Update
				 --                       AND   global.tblLienTempTables.LastName <> @Update AND global.tblLienTempTables.Insurer <> @Update AND LienDataValidate = 0
					  
					     
					--      SET @ERRORLOOP = @UploadId
				 --         SET @CHECKINSERT = 0
				 --         SET @MyLoopCheck1 =(SELECT count(*) FROM Liens.dbo.LienFile WITH(READPAST,ROWLOCK) INNER JOIN
					--						 Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) ON Liens.dbo.insuranceBilling.InsurerID = Liens.dbo.LienFile.lienInsurerId
					--						 WHERE  Liens.dbo.LienFile.lienFileClaimantFirstName = @FirstName AND Liens.dbo.LienFile.lienFileClaimantLastName = @LastName AND Liens.dbo.insuranceBilling.InsurerName = @Insurer)
											 
									 
					--      IF(@MyLoopCheck1 = 1)
					--      BEGIN
					      
					--           SET @MyClaimNumber =(SELECT lienFileClaimNumber FROM Liens.dbo.LienFile WITH(READPAST,ROWLOCK) INNER JOIN
					--						        Liens.dbo.insuranceBilling WITH(READPAST,ROWLOCK) ON Liens.dbo.insuranceBilling.InsurerID = Liens.dbo.LienFile.lienInsurerId
					--						        WHERE  Liens.dbo.LienFile.lienFileClaimantFirstName = @FirstName AND Liens.dbo.LienFile.lienFileClaimantLastName = @LastName AND Liens.dbo.insuranceBilling.InsurerName = @Insurer)
											 
											 
					--           UPDATE  global.tblLienTempTables WITH(READPAST,ROWLOCK) SET LienDataValidate = 1,Claim = @MyClaimNumber 
					--                   WHERE UploadId = @UploadId
					--      END
					--      ELSE
					--      BEGIN
					--            UPDATE  global.tblLienTempTables WITH(READPAST,ROWLOCK) SET LienDataValidate = 1  WHERE UploadId = @UploadId
					--      END
					     
				          
				 --         SET @MyLoop1 = @MyLoop1 -1
				          
				          
				    
				 --   END
					
				---------------------------------------------------------------------------------------------------------------------------------------------
                
                
                
                
                SET @STATUSCURSOR = 0
			    SET @MyLoop2 = (SELECT     COUNT(*) AS TotalCount 
								FROM         Liens.dbo.lienFile WITH (READPAST, ROWLOCK) INNER JOIN
								global.tblLienTempTables WITH(READPAST,ROWLOCK) ON Liens.dbo.lienFile.lienFileClaimNumber = global.tblLienTempTables.Claim
								WHERE      Claim <> @Update)
					WHILE (@MyLoop2 > 0)
					BEGIN				
					
					         SET @LienClaimNumber = (SELECT  TOP 1 lienFileClaimNumber FROM Liens.dbo.LienFile WITH(READPAST,ROWLOCK) 
                                                             WHERE  lienFileClaimNumber IN (SELECT    Claim FROM  global.tblLienTempTables  WITH(READPAST,ROWLOCK) 
																						    WHERE      Claim <> @Update ))
					         	      
							
		                     SELECT  TOP 1   @UploadId = global.tblLienTempTables.UploadId,@FirstName = Liens.dbo.LienFile.lienFileClaimantFirstName , @LastName =Liens.dbo.LienFile.lienFileClaimantLastName , @Claim=Liens.dbo.LienFile.lienFileClaimNumber, 
										@InsurerId = Liens.dbo.LienFile.lienInsurerId, @InsurerBranchId=Liens.dbo.LienFile.lienInsurerBranchId, @EmployerId = Liens.dbo.LienFile.lienEmployerId, @AdjusterId=Liens.dbo.LienFile.lienAdjusterId, 
										@InvoiceNumber = global.tblLienTempTables.InvoiceNumber, @InvoiceAmount = global.tblLienTempTables.InvoiceAmount, @InvoiceDate =global.tblLienTempTables.InvoiceDate ,
										@InvoiceSent = global.tblLienTempTables.InvoiceSent , @BillingWeek= global.tblLienTempTables.BillingWeek,
										@InvoiceDept = global.tblLienTempTables.InvoiceDept, @PaymentAmount = global.tblLienTempTables.PaymentAmount, @PaymentReceived = global.tblLienTempTables.PaymentReceived, 
										@CheckNumber = global.tblLienTempTables.CheckNumber,@PendingUploadId = global.tblLienTempTables.PendingUploadId FROM global.tblLienTempTables  WITH(READPAST,ROWLOCK)  INNER JOIN
										Liens.dbo.LienFile WITH(READPAST,ROWLOCK) ON Liens.dbo.LienFile.lienFileClaimNumber = global.tblLienTempTables.Claim 
							 WHERE      global.tblLienTempTables.InvoiceDept = 1 AND global.tblLienTempTables.LienDataValidate = 0 AND global.tblLienTempTables.Claim = @LienClaimNumber
		                    
		                    
		                    
		                     SET @ERRORLOOP = @UploadId
							
							   
							  
						  ---tblFiles----------------------
						  IF EXISTS(SELECT * FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE ClaimNumber = (CASE WHEN @Claim = @Update THEN '' ELSE @Claim END) AND IsDeleted = 0)
						  BEGIN
								  SET 	@FILEID = (SELECT FileID FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE ClaimNumber = @Claim AND IsDeleted = 0)
						  END
						  ELSE
						  BEGIN
						          IF(@Claim = @Update)
						          BEGIN
						               
						                 IF EXISTS(SELECT * FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE FirstName =@FirstName AND LastName =@LastName AND InsurerId=@InsurerId AND IsDeleted = 0)
						                 BEGIN
						                        SET 	@FILEID = (SELECT FileID FROM global.tblFiles WITH(READPAST,ROWLOCK) WHERE FirstName =@FirstName AND LastName =@LastName AND InsurerId=@InsurerId AND IsDeleted = 0)
						                 END
						                 ELSE
						                 BEGIN
												  INSERT INTO global.tblFiles (FirstName,LastName,ClaimNumber,InsurerId,InsurerBranchId,EmployerId,AdjusterId,
																				IsLienClaimNumber,IsLienInsurerID,IsLienInsurerBranchID,IsLienEmployerID,IsLienAdjusterID,DepartmentID) 
																		VALUES(@FirstName,@LastName,@Claim,@InsurerId,@InsurerBranchId,@EmployerId,@AdjusterId,
																				1,1,1,1,1,1)
																
												  SET 	@FILEID = 	(SELECT SCOPE_IDENTITY())
						                 END
						          END
						          ELSE
						          BEGIN						  
										  INSERT INTO global.tblFiles (FirstName,LastName,ClaimNumber,InsurerId,InsurerBranchId,EmployerId,AdjusterId,
																		IsLienClaimNumber,IsLienInsurerID,IsLienInsurerBranchID,IsLienEmployerID,IsLienAdjusterID,DepartmentID) 
																VALUES(@FirstName,@LastName,@Claim,@InsurerId,@InsurerBranchId,@EmployerId,@AdjusterId,
																		1,1,1,1,1,1)
														
										  SET 	@FILEID = 	(SELECT SCOPE_IDENTITY())
								  END		
						  END	            
						--------------------------------------------------           
												
												
										
										
												            
							 -----tblInvoices-------
							  IF(@InvoiceNumber <> @Update AND @InvoiceAmount <> @Update AND @InvoiceDate <> @Update AND @InvoiceSent <> @Update AND @BillingWeek <> @Update)
						      BEGIN
							     	SET @_InvoiceDate =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@InvoiceDate)) as InvoiceDate)
							        SET @_InvoiceSent =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@InvoiceSent)) as InvoiceSent)
							        SET @_BillingWeek =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@BillingWeek)) as BillingWeek)
							  END
		                         
							
		                         
							  SET @AlreadyExistInvoice = (SELECT  Count(tblFiles.FileID) as TotalCount FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																   global.tblFiles ON tblFiles.FileID = tblInvoices.FileId
														   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
		                     
							  IF (@AlreadyExistInvoice > 0)
							  BEGIN
									  SET 	@INVOICEID = (SELECT  tblInvoices.InvoiceID FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																   global.tblFiles ON tblFiles.FileID = tblInvoices.FileId
														   WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
														   
														   
									  SET @_DbInvoiceBalanceAmount = (SELECT  tblInvoices.InvoiceBalanceAmt FROM global.tblInvoices WITH(READPAST,ROWLOCK) INNER JOIN
																             global.tblFiles WITH(READPAST,ROWLOCK) ON tblFiles.FileID = tblInvoices.FileId
														                     WHERE   tblInvoices.InvoiceNumber = @InvoiceNumber And tblFiles.ClaimNumber = @Claim)
			                          
			                              
									  IF(@PaymentAmount <> @Update)
									  BEGIN											  
											  SET @_PaymentAmount = @PaymentAmount
											  SET @_TotalInvoiceBalanceAmount = @_DbInvoiceBalanceAmount - @_PaymentAmount
											  
											  UPDATE global.tblInvoices SET InvoiceBalanceAmt = @_TotalInvoiceBalanceAmount 
											  WHERE InvoiceID = @INVOICEID AND FileId = @FILEID
									  END
							  END
							  ELSE
							  BEGIN
							       IF(@InvoiceNumber <> @Update AND @InvoiceAmount <> @Update AND @InvoiceDate <> @Update AND @InvoiceSent <> @Update AND @BillingWeek <> @Update)
						           BEGIN
						                  IF(@PaymentAmount <> @Update)
										  BEGIN
												  SET @_InvoiceAmount = @InvoiceAmount
												  SET @_PaymentAmount = @PaymentAmount
												  SET @InvoiceBalanceAmount = @_InvoiceAmount - @_PaymentAmount
										  END
										  ELSE
										  BEGIN 
												  SET @InvoiceBalanceAmount = @InvoiceAmount 
										  END
										  
										  
									  SET @_InvoiceDueDate =  (SELECT  Convert(date,[global].[Get_AddWorkDays](30,@_InvoiceDate)) as InvoiceDueDate)--Calculating 30 Networking days
									  	  
									  INSERT INTO global.tblInvoices (FileId,InvoiceNumber,InvoiceAmt,InvoiceDate,InvoiceDueDate,InvoiceSent,BillingWeek,DepartmentId,InvoiceBalanceAmt)
															   VALUES(@FILEID,@InvoiceNumber,@InvoiceAmount,@_InvoiceDate,@_InvoiceDueDate,@_InvoiceSent,@_BillingWeek,@InvoiceDept,@InvoiceBalanceAmount)
				                                               
									  SET 	@INVOICEID = (SELECT SCOPE_IDENTITY())	
								   END
								   ELSE
								   BEGIN
								      SET 	@INVOICEID = 0
								   END
							  END
		                     
		                     
		                     
		                     
		                     
							 -----tblPayments--------------------------------
							 -------------------------------------------------
							 IF(@INVOICEID <> 0 AND @PaymentAmount <> @Update)
						     BEGIN	
						         IF(@PaymentReceived <> @Update)
						         BEGIN				         
		                               SET @_PaymentReceived =  (SELECT  Convert(date,[global].[Get_DateInUSFormat](@PaymentReceived)) as PaymentReceived)
		                         END
								 INSERT INTO global.tblPayments (InvoiceId,PaymentAmount,PaymentReceived,CheckNumber,PendingUploadId)
														VALUES (@INVOICEID, (CASE WHEN @PaymentAmount=@Update THEN 0 ELSE Convert(money,@PaymentAmount) END),
														(CASE WHEN @PaymentReceived=@Update THEN NULL ELSE @_PaymentReceived END),(CASE WHEN @CheckNumber=@Update THEN NULL ELSE @CheckNumber END),@PendingUploadId)				            
			                 END	                      			            
			                  									           
							  ---------DELTE THE PROCESSED ENTRY---------------
								 DELETE FROM global.tblLienTempTables  WITH(READPAST,ROWLOCK)
								 WHERE       UploadId =@UploadId
								 
								 
								 SET @FirstName = ''  SET @LastName = ''  SET @Claim = ''  SET @InsurerId = 0 SET @InsurerBranchId = 0 SET @EmployerId = 0 SET @AdjusterId = 0 
								SET @MyLoop2 = @MyLoop2 -1
						        SET @STATUSCURSOR = 1
		            
					
					END 	  
		          
		            IF EXISTS(SELECT * FROM global.tblLienTempTables WITH(READPAST,ROWLOCK))
		            BEGIN
		                 UPDATE  global.tblLienTempTables WITH(READPAST,ROWLOCK) SET LienDataValidate = 0 WHERE PendingUploadId =@PendingUploadId
		            END
		 
		 
		     IF(@STATUSCURSOR = 1 )
		     BEGIN
		          SELECT  NULL AS ErrorNumberLoop,NULL AS ErrorNumber,NULL AS ErrorSeverity,NULL AS ErrorState,NULL AS ErrorLine,'NULL' AS ErrorProcedure,'NULL' AS ErrorMessage	
		     END
		     ELSE
		     BEGIN
		          SELECT  0 AS ErrorNumberLoop,NULL AS ErrorNumber,NULL AS ErrorSeverity,NULL AS ErrorState,NULL AS ErrorLine,'NULL' AS ErrorProcedure,'NULL' AS ErrorMessage	
		     END
		    
		    
	COMMIT TRANSACTION	[Trans1]			
    END TRY
	BEGIN CATCH
	    SELECT @ERRORLOOP AS ErrorNumberLoop,
         ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_LINE () AS ErrorLine
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_MESSAGE() AS ErrorMessage;
		ROLLBACK TRANSACTION [Tran1]
	END CATCH	

END
GO
/****** Object:  StoredProcedure [global].[Update_AssignedToInvoiceIDByInvoiceID]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================
-- Author     :	TGosain
-- Create date: 04/21/2017
-- Description:	Assign Root InvoiceID to SubInvoices in IC Case
-- Used In :- 
--		FileController/UpdateAssignedToInvoiceID  - (When adding new Invoice in IC case)

-- =========================================================================================
--  [global].[UpdateInvoiceForAssignedToInvoiceID] 
CREATE PROCEDURE [global].[Update_AssignedToInvoiceIDByInvoiceID] 
(
 @InvoiceID INT, @SubInvoiceID INT
)
AS
BEGIN
      update global.tblInvoices set AssignedToInvoiceID = @InvoiceId where InvoiceID = @SubInvoiceID
END

GO
/****** Object:  StoredProcedure [global].[Update_File]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author      : Genius Jain
-- Create date : 7 July 2015
-- Description : Update File  by FileID
-- ==============================================================================
CREATE PROCEDURE [global].[Update_File]
  @FileID int,
  @FirstName varchar(50),
  @LastName varchar(50),
  @ClaimNumber varchar(50),
  @InsurerId  int,
  @InsurerBranchId int,
  @AdjusterId  int,
  @EmployerId int,
	@IsLienClaimNumber bit,
	@IsLienInsurerID  bit,
	@IsLienInsurerBranchID bit,
	@IsLienEmployerID  bit,
	@IsLienAdjusterID  bit,
--	@IsDeleted bit,
	@DeletedBy int,
	@DeletedOn datetime,
	@Notes varchar(max) 
	
 
AS
BEGIN

   BEGIN TRANSACTION [Trans1]  
   BEGIN TRY

	 declare @claimCount int,
		     @Return varchar(15),
			 @UpdatedFileID int,
			 @InvoiceCount int

					select @claimCount= COUNT(*) from 
					(
						SELECT     lienFileClaimNumber AS ClaimNumber, lienFileId AS FileID
						FROM         Liens.dbo.lienFile WITH (READPAST, ROWLOCK)
						WHERE     (lienFileClaimNumber = RTRIM(LTRIM(@ClaimNumber)))
									UNION ALL
						SELECT     ClaimNumber, FileID
								FROM         global.tblFiles WITH(READPAST,ROWLOCK)
								WHERE     (ClaimNumber = RTRIM(LTRIM(@ClaimNumber))) AND (IsDeleted = 0) and FileID !=@FileID
					) as tbl
					
				
					if(@claimCount=0 and @IsLienClaimNumber=0)---- AR case new Claim Does not exist In lien And AR does not Exist,Update Same File with new Claimno
						begin
							UPDATE    global.tblFiles WITH(READPAST,ROWLOCK)
							SET              FirstName = @FirstName, LastName = @LastName, ClaimNumber = @ClaimNumber, InsurerId = @InsurerId, InsurerBranchId = @InsurerBranchId, 
												  EmployerId = @EmployerId, AdjusterId = @AdjusterId, IsLienInsurerID = @IsLienInsurerID, IsLienInsurerBranchID = @IsLienInsurerBranchID, 
												  IsLienAdjusterID = @IsLienAdjusterID, IsLienEmployerID = @IsLienEmployerID, Notes = @Notes
							WHERE     (FileID = @FileID)
							set @Return=@FileID
						end
					else if((SELECT      count(*) FROM         global.tblFiles  WITH(READPAST,ROWLOCK)  where tblFiles.ClaimNumber= RTRIM(LTRIM(@ClaimNumber))AND (IsDeleted = 0)and FileID !=@FileID)>0 and @IsLienClaimNumber=0)---- AR case new Claim  exist in AR ,Update This  File to ISDeleted True and Shift Invoices to New ClaimNo
						begin
								SELECT    @UpdatedFileID=  FileID  FROM         global.tblFiles   WITH(READPAST,ROWLOCK) where tblFiles.ClaimNumber= RTRIM(LTRIM(@ClaimNumber)) and tblFiles.IsDeleted=0--FILe of New Clain 
						
								select @InvoiceCount =COUNT(*) from global.tblInvoices WITH(READPAST,ROWLOCK) where FileId=@UpdatedFileID and InvoiceNumber in (select tblInvoices.InvoiceNumber from global.tblInvoices WITH(READPAST,ROWLOCK) where FileId=@FileID)
										if(@InvoiceCount=0)-- Does not have Same InvoiceNUmber
										begin
												
												UPDATE    global.tblFiles WITH(READPAST,ROWLOCK)
														SET              IsDeleted =1, DeletedBy =@DeletedBy, DeletedOn =@DeletedOn where FileID=@FileID
														
													UPDATE    global.tblFiles WITH(READPAST,ROWLOCK)
													SET     ClaimNumber =@ClaimNumber where FileID=@UpdatedFileID and tblFiles.IsDeleted=0
															UPDATE    global.tblInvoices WITH(READPAST,ROWLOCK)
													SET              FileId =@UpdatedFileID where FileId=@FileID
													
									    set @Return=@UpdatedFileID
										end
										else -- Have Same Invoice Number Dont allow any updation till user fix this
										Begin
												set @Return=0 
										End
										
						end
						else if((SELECT COUNT(*) FROM Liens.dbo.lienFile WITH(READPAST,ROWLOCK) where lienFile.lienFileClaimNumber= RTRIM(LTRIM(@ClaimNumber)))>0 and @IsLienClaimNumber=0)---- AR case new Claim  exist in lien ,Update This  File to IsliencLaim True and FN and LN to NULL
						begin
							UPDATE    global.tblFiles WITH(READPAST,ROWLOCK)
									SET   FirstName=null,LastName=null,  ClaimNumber =@ClaimNumber, InsurerId =@InsurerId,
									 InsurerBranchId =@InsurerBranchId, EmployerId =@EmployerId, AdjusterId =@AdjusterId,IsLienClaimNumber = 1,
									 IsLienInsurerID =@IsLienInsurerID,IsLienInsurerBranchID =@IsLienInsurerBranchID, IsLienAdjusterID =@IsLienAdjusterID, IsLienEmployerID =@IsLienEmployerID, Notes = @Notes where FileID=@FileID
						 set @Return=@FileID
										
						end	
					else if(@IsLienClaimNumber=1 and @claimCount=0)-- lien Case New Claim Does not exist in lien and AR Just Update with new Claim No and update IsLienClaimNumber to false
						begin
									UPDATE    global.tblFiles WITH(READPAST,ROWLOCK)
									SET      FirstName = @FirstName, LastName = @LastName,   ClaimNumber = @ClaimNumber, InsurerId = @InsurerId, InsurerBranchId = @InsurerBranchId, 
														  EmployerId = @EmployerId, AdjusterId = @AdjusterId, IsLienClaimNumber = 0, IsLienInsurerID = @IsLienInsurerID, IsLienInsurerBranchID = @IsLienInsurerBranchID, 
														  IsLienAdjusterID = @IsLienAdjusterID, IsLienEmployerID = @IsLienEmployerID, Notes = @Notes
									WHERE     (FileID = @FileID)
									 set @Return=@FileID
					
						end
					else if(@IsLienClaimNumber=1 and @claimCount>0)-- lien Case New Claim Exist
						begin
					
								if((SELECT      count(*) FROM         global.tblFiles  WITH(READPAST,ROWLOCK)  where tblFiles.ClaimNumber= RTRIM(LTRIM(@ClaimNumber))AND (IsDeleted = 0)and FileID !=@FileID)>0)--  new Claim  exist in AR ,Update This  File to ISDeleted True and Shift Invoices to New ClaimNo
							begin
								
									SELECT    @UpdatedFileID=  FileID  FROM         global.tblFiles  WITH(READPAST,ROWLOCK)  where tblFiles.ClaimNumber= RTRIM(LTRIM(@ClaimNumber)) and tblFiles.IsDeleted=0
						
										select @InvoiceCount =COUNT(*) from global.tblInvoices WITH(READPAST,ROWLOCK) where FileId=@UpdatedFileID and InvoiceNumber in (select tblInvoices.InvoiceNumber from global.tblInvoices WITH(READPAST,ROWLOCK)  where FileId=@FileID)
												if(@InvoiceCount=0)-- Does not have Same InvoiceNUmber
													begin
						
														UPDATE    global.tblFiles WITH(READPAST,ROWLOCK)
																SET              IsDeleted =1, DeletedBy =@DeletedBy, DeletedOn =@DeletedOn where FileID=@FileID
																
															UPDATE    global.tblFiles WITH(READPAST,ROWLOCK)
															SET     ClaimNumber =@ClaimNumber where FileID=@UpdatedFileID and tblFiles.IsDeleted=0
															UPDATE    global.tblInvoices WITH(READPAST,ROWLOCK)
															SET              FileId =@UpdatedFileID where FileId=@FileID
												  set @Return=@UpdatedFileID
						
													end
												else
													Begin
													set @Return=0 
												End
							
							end
							else if((SELECT COUNT(*) FROM Liens.dbo.lienFile WITH(READPAST,ROWLOCK) where lienFile.lienFileClaimNumber= RTRIM(LTRIM(@ClaimNumber)))>0)
							begin
									UPDATE    global.tblFiles WITH(READPAST,ROWLOCK)
									SET      ClaimNumber =@ClaimNumber, InsurerId =@InsurerId,
									 InsurerBranchId =@InsurerBranchId, EmployerId =@EmployerId, AdjusterId =@AdjusterId,
									 IsLienInsurerID =@IsLienInsurerID,IsLienInsurerBranchID =@IsLienInsurerBranchID, IsLienAdjusterID =@IsLienAdjusterID, IsLienEmployerID =@IsLienEmployerID, Notes = @Notes where FileID=@FileID
						  set @Return=@FileID
							end			
						end
						
						
						Select @Return
			COMMIT TRANSACTION	[Trans1]			
    END TRY
	BEGIN CATCH
	 		
		ROLLBACK TRANSACTION [Tran1]
	END CATCH	
					
END

GO
/****** Object:  StoredProcedure [global].[Update_ICAmtAccFileIdInvID]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================
-- Author:		MAHINDER SINGH
-- Create date: 25-02-2017
-- Description:	Update Invoice IC Amt where fileID and InvoiceID.
-- ================================================================
CREATE PROCEDURE [global].[Update_ICAmtAccFileIdInvID]
	@FileId INT,
	@InvoiceID INT,
	@InvoiceICAmt MONEY
AS
BEGIN	
	SET NOCOUNT ON;
    BEGIN TRANSACTION [Trans1]
    BEGIN TRY
		UPDATE AR.global.tblInvoices WITH(READPAST,ROWLOCK) SET InvoiceICAmt = @InvoiceICAmt  WHERE FileId = @FileId AND InvoiceID = @InvoiceID
		COMMIT TRANSACTION	[Trans1]
	END TRY
	BEGIN CATCH	 		
		ROLLBACK TRANSACTION [Tran1]
	END CATCH	
END

GO
/****** Object:  StoredProcedure [global].[Update_ICFile]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tarun Gosain
-- Create date: 12-08-2015
-- Description:	Update IC department file.
-- =============================================
CREATE PROCEDURE [global].[Update_ICFile]
	@FileID int,
	@FirstName varchar(50),
	@LastName varchar(50)
AS
BEGIN	
	SET NOCOUNT ON;
    BEGIN TRANSACTION [Trans1]
    BEGIN TRY
		Update ar.global.tblFiles with(readpast,rowlock) 
		Set tblfiles.FirstName = @FirstName, tblfiles.LastName = @LastName 
		where FileID = @FileID
		COMMIT TRANSACTION	[Trans1]
	END TRY
	BEGIN CATCH	 		
		ROLLBACK TRANSACTION [Tran1]
	END CATCH	
END

GO
/****** Object:  StoredProcedure [global].[Update_InvoiceAdjustmentByInvoiceID]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [global].[Update_InvoiceAdjustmentByInvoiceID] 224,'sss',1,251
CREATE PROCEDURE [global].[Update_InvoiceAdjustmentByInvoiceID] 
(
	@InvoiceID int,
	@AdjustmentNotes varchar(Max),
	@CreatedBy int,
	@AdjustmentAmt money
)
AS
BEGIN
declare @AdjustmentAmount as money = 0.0
declare @InvoiceBalAmt as money = 0.0
declare @InvBalance as int = 0
declare @TotalInvoiceAmt as int =0

set @AdjustmentAmount = isnull((SELECT   top 1 (isnull(AdjustmentAmt,0))
						  FROM         global.tblInvoiceAdjustments where InvoiceID = @InvoiceID order by 1 desc),0)
						  
set @InvBalance= (SELECT ISNULL((SELECT SUM([tblPayments].PaymentAmount)FROM [AR].[global].[tblPayments] WITH(READPAST,ROWLOCK) where tblPayments.InvoiceId=tblInvoices.InvoiceID),0.00) as InvoiceBalance
				FROM         global.tblInvoices where InvoiceID=@InvoiceID)
				
set @InvoiceBalAmt = (SELECT InvoiceBalanceAmt
				FROM         global.tblInvoices where InvoiceID=@InvoiceID)
set @TotalInvoiceAmt = (SELECT InvoiceAmt
				FROM         global.tblInvoices where InvoiceID=@InvoiceID)

--select @AdjustmentAmount as AdjustmentAmount ,@InvBalance as InvBalance
if(@AdjustmentAmount = 0)
begin
--select 1
	insert into global.tblInvoiceAdjustments(AdjustmentAmt,AdjustmentNotes,CreatedBy,CreatedOn,InvoiceID) values(@AdjustmentAmt,@AdjustmentNotes,@CreatedBy,GETDATE(),@InvoiceID)
	UPDATE    global.tblInvoices
					SET           InvoiceBalanceAmt = InvoiceAmt  - (@AdjustmentAmt + @InvBalance)
					where InvoiceID = @InvoiceID
	return 1
end

if(@AdjustmentAmt < @AdjustmentAmount)
	begin
--	select 2
	insert into global.tblInvoiceAdjustments(AdjustmentAmt,AdjustmentNotes,CreatedBy,CreatedOn,InvoiceID) values(@AdjustmentAmt,@AdjustmentNotes,@CreatedBy,GETDATE(),@InvoiceID)
	UPDATE    global.tblInvoices
					SET           InvoiceBalanceAmt = InvoiceAmt  - (@AdjustmentAmt + @InvBalance)
					where InvoiceID = @InvoiceID
	return 1
	end
else
	begin
--	select 3
		
						
			--select @AdjustmentAmt
			if(@AdjustmentAmt <= (@InvoiceBalAmt + @AdjustmentAmount))
			begin
			--	select 4
			insert into global.tblInvoiceAdjustments(AdjustmentAmt,AdjustmentNotes,CreatedBy,CreatedOn,InvoiceID) values(@AdjustmentAmt,@AdjustmentNotes,@CreatedBy,GETDATE(),@InvoiceID)
					UPDATE    global.tblInvoices
					SET           InvoiceBalanceAmt = InvoiceAmt - (@AdjustmentAmt + @InvBalance)
					where InvoiceID = @InvoiceID
					
					return 1 
			end
			else
			Begin
				return 0 
			End
	     
	end        
END

GO
/****** Object:  StoredProcedure [global].[Update_LienTempClaimNumberByUploadID]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author      : Mahinder Singh
-- Create date : 22 July 2015
-- Description : Update LienTemp Table ClaimNumber by UploadID
-- ==============================================================================
CREATE PROCEDURE [global].[Update_LienTempClaimNumberByUploadID]
 @Claim VARCHAR(100),
 @UploadId INT,
 @FirstName VARCHAR(50), 
 @LastName VARCHAR(50), 
 @Adjuster VARCHAR(50),
 @Insurer VARCHAR(50),
 @InsurerBranch VARCHAR(50),
 @Employer VARCHAR(50)
 
AS
BEGIN
	 BEGIN TRANSACTION [Trans1]  
	 BEGIN TRY
   
   
		UPDATE    global.tblLienTempTables WITH(READPAST,ROWLOCK)
		SET              Claim = @Claim,Reason = 'Claim Number Updated', FirstName = @FirstName, LastName = @LastName, Insurer = @Insurer, 
							  InsurerBranch = @InsurerBranch, Employer = @Employer, Adjuster = @Adjuster
		WHERE     (UploadId = @UploadId)
		
    SELECT 1
	COMMIT TRANSACTION	[Trans1]			
    END TRY
	BEGIN CATCH
	 		
		ROLLBACK TRANSACTION [Tran1]
	END CATCH			
   
         
END

GO
/****** Object:  StoredProcedure [Job].[Move_LineInvoiceInAR]    Script Date: 10-02-2020 16:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dsharma
-- Create date: 02-03-2016
-- Description:	Fetch Invoice from the Lien Database and insert into the AR with the help of Agent Job
-- =============================================
CREATE PROCEDURE [Job].[Move_LineInvoiceInAR]
AS
BEGIN	

 DECLARE @LastInvoiceDate date 
 set @LastInvoiceDate = (SELECT Max(Invoice) FROM Job.tblTrackingLienInvoice where Status='Successfully')
 if ( @LastInvoiceDate is NULL) begin  set @LastInvoiceDate = (DATEADD(day,-1,GETDATE()))  END

--SELECT JobDate, JobTime, Status, Invoice FROM Job.tblTrackingLienInvoice
  
 exec [global].[Move_FrLienToAR] 1,2,@LastInvoiceDate,1
		--@Department 1 --Lien Only
		--@UserID INT --Job User
		--@Invoicedt DATETIME --pull start from Invoice Date
		--@ForJob bit -- 1 call from Job SP and 0 call from Project SP

END

GO
USE [master]
GO
ALTER DATABASE [AR] SET  READ_WRITE 
GO

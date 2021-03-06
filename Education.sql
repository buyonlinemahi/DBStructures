USE [master]
GO
/****** Object:  Database [HCRGUniversity]    Script Date: 10-02-2020 16:03:17 ******/
CREATE DATABASE [HCRGUniversity]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HCRGUniversity', FILENAME = N'E:\SQL_Database\HCRGUniversity.mdf' , SIZE = 28672KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'HCRGUniversity_log', FILENAME = N'E:\SQL_Database\HCRGUniversity_log.ldf' , SIZE = 92864KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [HCRGUniversity] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HCRGUniversity].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HCRGUniversity] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HCRGUniversity] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HCRGUniversity] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HCRGUniversity] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HCRGUniversity] SET ARITHABORT OFF 
GO
ALTER DATABASE [HCRGUniversity] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HCRGUniversity] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HCRGUniversity] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HCRGUniversity] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HCRGUniversity] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HCRGUniversity] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HCRGUniversity] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HCRGUniversity] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HCRGUniversity] SET RECURSIVE_TRIGGERS ON 
GO
ALTER DATABASE [HCRGUniversity] SET  DISABLE_BROKER 
GO
ALTER DATABASE [HCRGUniversity] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HCRGUniversity] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HCRGUniversity] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HCRGUniversity] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HCRGUniversity] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HCRGUniversity] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HCRGUniversity] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HCRGUniversity] SET RECOVERY FULL 
GO
ALTER DATABASE [HCRGUniversity] SET  MULTI_USER 
GO
ALTER DATABASE [HCRGUniversity] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HCRGUniversity] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HCRGUniversity] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HCRGUniversity] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [HCRGUniversity] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'HCRGUniversity', N'ON'
GO
USE [HCRGUniversity]
GO
/****** Object:  User [VSAINDIA\Developers_JAL]    Script Date: 10-02-2020 16:03:17 ******/
CREATE USER [VSAINDIA\Developers_JAL] FOR LOGIN [VSAINDIA\Developers_JAL]
GO
ALTER ROLE [db_owner] ADD MEMBER [VSAINDIA\Developers_JAL]
GO
/****** Object:  Schema [link]    Script Date: 10-02-2020 16:03:17 ******/
CREATE SCHEMA [link]
GO
/****** Object:  Schema [lookup]    Script Date: 10-02-2020 16:03:17 ******/
CREATE SCHEMA [lookup]
GO
/****** Object:  Table [dbo].[AboutUs]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AboutUs](
	[AboutUsID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](max) NOT NULL,
 CONSTRAINT [PK_AboutUs] PRIMARY KEY CLUSTERED 
(
	[AboutUsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Accreditations]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accreditations](
	[AccreditationID] [int] IDENTITY(1,1) NOT NULL,
	[AccreditationContent] [varchar](max) NULL,
 CONSTRAINT [PK_Accreditations] PRIMARY KEY CLUSTERED 
(
	[AccreditationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Accreditors]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accreditors](
	[AccreditorID] [int] IDENTITY(1,1) NOT NULL,
	[AccreditorName] [varchar](25) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Accreditors] PRIMARY KEY CLUSTERED 
(
	[AccreditorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BillingAddresses]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillingAddresses](
	[BillingAddressID] [int] IDENTITY(1,1) NOT NULL,
	[BAUserID] [int] NOT NULL,
	[BAFirstName] [varchar](30) NULL,
	[BALastName] [varchar](30) NULL,
	[BAAddress] [varchar](100) NULL,
	[BAAddress2] [varchar](100) NULL,
	[BACity] [varchar](50) NULL,
	[BAStateID] [int] NOT NULL,
	[BAPostalCode] [varchar](50) NULL,
	[BAPhone] [varchar](50) NULL,
 CONSTRAINT [PK_tblBillingAddresses] PRIMARY KEY CLUSTERED 
(
	[BillingAddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CarouselSetUps]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarouselSetUps](
	[CarouselID] [int] IDENTITY(1,1) NOT NULL,
	[CarouselTitle] [varchar](50) NULL,
	[CarouselDescription] [varchar](200) NULL,
	[CarouselBgColor] [varchar](20) NULL,
	[NewsID] [int] NULL,
 CONSTRAINT [PK_CarouselSetUp] PRIMARY KEY CLUSTERED 
(
	[CarouselID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Certifications]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Certifications](
	[CertificationID] [int] IDENTITY(1,1) NOT NULL,
	[CertificationContent] [varchar](max) NULL,
 CONSTRAINT [PK_Certifications] PRIMARY KEY CLUSTERED 
(
	[CertificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CertificationTitleOptions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CertificationTitleOptions](
	[CertificationTitleOptionID] [int] IDENTITY(1,1) NOT NULL,
	[CertificationTitle] [varchar](100) NULL,
	[CertificationContent] [varchar](max) NULL,
	[EducationId] [int] NULL,
 CONSTRAINT [PK_CertificationTitleOptions] PRIMARY KEY CLUSTERED 
(
	[CertificationTitleOptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Colleges]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Colleges](
	[CollegeID] [int] IDENTITY(1,1) NOT NULL,
	[CollegeName] [varchar](200) NOT NULL,
	[Abbreviation] [varchar](50) NULL,
	[StartNumber] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Colleges] PRIMARY KEY CLUSTERED 
(
	[CollegeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeliveryTerms]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryTerms](
	[DeliveryTermID] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryTermContents] [varchar](max) NULL,
 CONSTRAINT [PK_DeliveryTerms] PRIMARY KEY CLUSTERED 
(
	[DeliveryTermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DiscountCoupons]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiscountCoupons](
	[CouponID] [int] IDENTITY(1,1) NOT NULL,
	[CouponCode] [varchar](20) NOT NULL,
	[CouponType] [varchar](20) NOT NULL,
	[CouponEducationID] [int] NOT NULL,
	[CouponProduactID] [int] NOT NULL,
	[CouponDiscount] [decimal](18, 2) NOT NULL,
	[CouponExpiryDate] [datetime] NOT NULL,
	[CouponIssueDate] [datetime] NOT NULL,
	[CoupanValid] [bit] NOT NULL,
 CONSTRAINT [PK_DiscountCoupons] PRIMARY KEY CLUSTERED 
(
	[CouponID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EducationCredentials]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationCredentials](
	[CredentialID] [int] IDENTITY(1,1) NOT NULL,
	[CredentialUnit] [decimal](18, 1) NULL,
	[CredentialProgram] [varchar](25) NOT NULL,
	[AccreditorID] [int] NOT NULL,
	[CertificateMessage] [varchar](500) NOT NULL,
	[EducationID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CredentialType] [varchar](5) NULL,
 CONSTRAINT [PK_CourseCredentials] PRIMARY KEY CLUSTERED 
(
	[CredentialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EducationDetailPages]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationDetailPages](
	[EPageID] [int] IDENTITY(1,1) NOT NULL,
	[EducationID] [int] NULL,
	[PContent] [varchar](max) NULL,
	[PDate] [datetime] NULL,
 CONSTRAINT [PK_EducationDetailPage] PRIMARY KEY CLUSTERED 
(
	[EPageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EducationFormats]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationFormats](
	[EducationFormatID] [int] IDENTITY(1,1) NOT NULL,
	[EducationFormatType] [varchar](100) NOT NULL,
	[EducationPriority] [int] NOT NULL,
 CONSTRAINT [PK_EducationFormats] PRIMARY KEY CLUSTERED 
(
	[EducationFormatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EducationModuleFiles]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationModuleFiles](
	[EducationModuleFileID] [int] IDENTITY(1,1) NOT NULL,
	[EducationModuleID] [int] NOT NULL,
	[ModuleFile] [varchar](max) NULL,
	[FileTypeID] [int] NOT NULL,
	[DocumentName] [varchar](150) NULL,
	[DocumentUploadedDate] [date] NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_ModuleFiles] PRIMARY KEY CLUSTERED 
(
	[EducationModuleFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EducationModules]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationModules](
	[EducationModuleID] [int] IDENTITY(1,1) NOT NULL,
	[EducationID] [int] NOT NULL,
	[EducationModuleName] [varchar](200) NOT NULL,
	[EducationModuleDescription] [varchar](max) NULL,
	[EducationModuleTime] [varchar](50) NULL,
	[EducationModuleDate] [datetime] NOT NULL,
	[EducationModulePosition] [int] NOT NULL,
 CONSTRAINT [PK_Modules] PRIMARY KEY CLUSTERED 
(
	[EducationModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Educations]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Educations](
	[EducationID] [int] IDENTITY(1,1) NOT NULL,
	[CourseName] [varchar](250) NOT NULL,
	[CourseCode] [varchar](100) NULL,
	[CourseDescription] [varchar](max) NOT NULL,
	[CourseTime] [varchar](10) NOT NULL,
	[CourseCredential] [bit] NOT NULL,
	[CourseUploadDate] [date] NULL,
	[CoursePrice] [money] NULL,
	[IsActive] [bit] NOT NULL,
	[CourseFile] [varchar](250) NULL,
	[CourseStartDate] [date] NULL,
	[CourseEndDate] [date] NULL,
	[CoursePresenterName] [varchar](100) NULL,
	[CourseLocation] [varchar](25) NULL,
	[CourseStartTime] [varchar](10) NULL,
	[CourseEndTime] [varchar](10) NULL,
	[CourseDate] [datetime] NULL,
	[CourseAllotedTime] [int] NULL,
	[CouseAllotedDaysMonth] [varchar](10) NULL,
	[ReadyToDisplay] [bit] NULL,
	[AllowRevisit] [bit] NULL,
	[IsPublished] [bit] NULL,
	[IsTimerRequired] [bit] NULL,
	[IsProgramRequired] [bit] NULL,
	[StateID] [int] NULL,
	[IsCoursePreview] [bit] NULL,
 CONSTRAINT [PK_Educations] PRIMARY KEY CLUSTERED 
(
	[EducationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EducationShoppings]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationShoppings](
	[EducationShoppingID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[EducationID] [int] NOT NULL,
	[EducationTypeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[CoupanID] [int] NULL,
	[Grandtotal] [money] NOT NULL,
	[OrderID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[ShippingPaymentID] [int] NULL,
	[UserAllAccessPassID] [int] NULL,
	[TaxPercentage] [decimal](18, 2) NULL,
 CONSTRAINT [PK_tblEducationShoppings] PRIMARY KEY CLUSTERED 
(
	[EducationShoppingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EducationShoppingTemps]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationShoppingTemps](
	[EducationShoppingTempID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[EducationID] [int] NOT NULL,
	[EducationTypeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[CoupanID] [int] NULL,
	[Amount] [money] NOT NULL,
	[Date] [datetime] NOT NULL,
	[CredentialID] [int] NULL,
	[ShippingPaymentID] [int] NULL,
	[UserAllAccessPassID] [int] NULL,
	[ProcessedDate] [datetime] NULL,
	[TaxPercentage] [decimal](18, 2) NULL,
 CONSTRAINT [PK_tblEducationShoppingTemps] PRIMARY KEY CLUSTERED 
(
	[EducationShoppingTempID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EducationTypes]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationTypes](
	[EducationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[EducationType] [varchar](20) NOT NULL,
 CONSTRAINT [PK_EducationTypes] PRIMARY KEY CLUSTERED 
(
	[EducationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EnterprisePackageRegisters]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnterprisePackageRegisters](
	[EPRID] [int] IDENTITY(1,1) NOT NULL,
	[EPRName] [varchar](50) NULL,
	[EPRPhone] [varchar](50) NULL,
	[EPREmail] [varchar](50) NULL,
	[EPRCompany] [varchar](50) NULL,
	[EPRCreatedDate] [date] NULL,
 CONSTRAINT [PK_UserEnterprisePackageRegisters] PRIMARY KEY CLUSTERED 
(
	[EPRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Enterprises]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enterprises](
	[EnterpriseID] [int] IDENTITY(1,1) NOT NULL,
	[EnterpriseClientName] [varchar](50) NULL,
	[EnterpriseAddress] [varchar](50) NULL,
	[EnterpriseCity] [varchar](50) NULL,
	[EnterpriseStateID] [int] NULL,
	[EnterpriseZip] [varchar](10) NULL,
	[EnterprisePhone] [varchar](14) NULL,
	[EnterpriseEmail] [varchar](50) NULL,
	[EnterpriseCourseStartPrice] [money] NULL,
	[EnterpriseCourseEndPrice] [money] NULL,
	[EnterpriseProgram] [bit] NULL,
	[EnterpriseEndDate] [datetime] NULL,
	[EnterpriseNumberUser] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_Enterprises] PRIMARY KEY CLUSTERED 
(
	[EnterpriseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EvaluationAnswers]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EvaluationAnswers](
	[EvaluationAnswerID] [int] IDENTITY(1,1) NOT NULL,
	[EvaluationAns] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EvaluationAnswers] PRIMARY KEY CLUSTERED 
(
	[EvaluationAnswerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EvaluationPredefinedQuestions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EvaluationPredefinedQuestions](
	[EvalPredefinedQuestionID] [int] IDENTITY(1,1) NOT NULL,
	[EvalPredefinedQuestions] [varchar](max) NULL,
 CONSTRAINT [PK_EvaluationPredefinedQuestions] PRIMARY KEY CLUSTERED 
(
	[EvalPredefinedQuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EvaluationQuestionResults]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EvaluationQuestionResults](
	[EvaluationQuestionResultID] [int] IDENTITY(1,1) NOT NULL,
	[EvaluationQuestionID] [int] NOT NULL,
	[EvaluationAnswerID] [int] NOT NULL,
	[EvaluationResultID] [int] NOT NULL,
 CONSTRAINT [PK_EvaluationQuestionResults] PRIMARY KEY CLUSTERED 
(
	[EvaluationQuestionResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EvaluationQuestions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EvaluationQuestions](
	[EvaluationQuestionID] [int] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [int] NOT NULL,
	[EvaluationQues] [varchar](1024) NOT NULL,
	[IsStatus] [bit] NOT NULL,
 CONSTRAINT [PK_EvaluationQuestions] PRIMARY KEY CLUSTERED 
(
	[EvaluationQuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EvaluationResults]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EvaluationResults](
	[EvaluationResultID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[IsPass] [bit] NOT NULL,
	[MEID] [int] NULL,
	[EvaluationID] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Suggestions] [varchar](max) NULL,
 CONSTRAINT [PK_EvaluationResults] PRIMARY KEY CLUSTERED 
(
	[EvaluationResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Evaluations]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Evaluations](
	[EvaluationID] [int] IDENTITY(1,1) NOT NULL,
	[EvaluationName] [varchar](500) NOT NULL,
	[EvaluationStatus] [bit] NOT NULL,
 CONSTRAINT [PK_Evaluations] PRIMARY KEY CLUSTERED 
(
	[EvaluationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Events]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Events](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[EventName] [varchar](50) NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[EventDescription] [varchar](350) NOT NULL,
	[NewsID] [int] NULL,
	[EducationID] [int] NULL,
 CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExamQuestionResults]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamQuestionResults](
	[ExamQuestionResultID] [int] IDENTITY(1,1) NOT NULL,
	[ExamQuestionID] [int] NOT NULL,
	[ExamAnswer] [char](1) NULL,
	[ExamResultID] [int] NOT NULL,
	[ExamAnswerTrueFalse] [bit] NULL,
 CONSTRAINT [PK_ExamQuestionResults] PRIMARY KEY CLUSTERED 
(
	[ExamQuestionResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExamQuestions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamQuestions](
	[ExamQuestionID] [int] IDENTITY(1,1) NOT NULL,
	[ExamID] [int] NOT NULL,
	[ExamQues] [varchar](1024) NOT NULL,
	[ExamOptionA] [varchar](250) NULL,
	[ExamOptionB] [varchar](250) NULL,
	[ExamOptionC] [varchar](250) NULL,
	[ExamOptionD] [varchar](250) NULL,
	[ExamAnswer] [char](1) NULL,
	[ExamAnswerType] [varchar](20) NULL,
	[ExamAnswerTrueFalse] [bit] NULL,
 CONSTRAINT [PK_ExamQuestions] PRIMARY KEY CLUSTERED 
(
	[ExamQuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExamResults]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamResults](
	[ExamResultID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[IsPass] [bit] NOT NULL,
	[MEID] [int] NULL,
	[ExamID] [int] NULL,
 CONSTRAINT [PK_ExamResults] PRIMARY KEY CLUSTERED 
(
	[ExamResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Exams]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exams](
	[ExamID] [int] IDENTITY(1,1) NOT NULL,
	[ExamName] [varchar](500) NOT NULL,
	[ExamStatus] [bit] NOT NULL,
 CONSTRAINT [PK_Exams] PRIMARY KEY CLUSTERED 
(
	[ExamID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Faculties]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faculties](
	[FacultyID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](20) NOT NULL,
	[LastName] [varchar](20) NOT NULL,
	[Email] [varchar](25) NOT NULL,
	[Company] [varchar](50) NOT NULL,
	[Phone] [varchar](10) NULL,
	[ProfessionalTitle] [varchar](50) NOT NULL,
	[AddressStreet] [varchar](50) NOT NULL,
	[AddressFloor] [varchar](50) NULL,
	[City] [varchar](50) NOT NULL,
	[State] [char](2) NOT NULL,
	[Zip] [varchar](5) NOT NULL,
	[AreaOfExpertise] [varchar](max) NULL,
	[Topics] [varchar](max) NULL,
	[Resume] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Faculties] PRIMARY KEY CLUSTERED 
(
	[FacultyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FAQCategories]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAQCategories](
	[FAQCatID] [int] IDENTITY(1,1) NOT NULL,
	[FAQCategoryTitle] [varchar](250) NULL,
 CONSTRAINT [PK_FAQCategory] PRIMARY KEY CLUSTERED 
(
	[FAQCatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FAQs]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAQs](
	[FAQID] [int] IDENTITY(1,1) NOT NULL,
	[FAQCatID] [int] NOT NULL,
	[FAQues] [varchar](500) NULL,
	[FAQAns] [varchar](max) NULL,
 CONSTRAINT [PK_FAQs] PRIMARY KEY CLUSTERED 
(
	[FAQID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FileTypes]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileTypes](
	[FileTypeID] [int] IDENTITY(1,1) NOT NULL,
	[FileTypeName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_FileTypes] PRIMARY KEY CLUSTERED 
(
	[FileTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HomeContents]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HomeContents](
	[HomeContentID] [int] IDENTITY(1,1) NOT NULL,
	[HomePageContent] [varchar](max) NULL,
 CONSTRAINT [PK_HomeContents] PRIMARY KEY CLUSTERED 
(
	[HomeContentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IndustryResearches]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndustryResearches](
	[IndustryResearchID] [int] IDENTITY(1,1) NOT NULL,
	[IndustryResearchContent] [varchar](max) NOT NULL,
 CONSTRAINT [PK_IndustryResearches] PRIMARY KEY CLUSTERED 
(
	[IndustryResearchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LogSessions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogSessions](
	[LogSessionID] [int] IDENTITY(1,1) NOT NULL,
	[SessionId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[PageUrl] [nvarchar](50) NOT NULL,
	[Browser] [nvarchar](50) NOT NULL,
	[MEID] [int] NOT NULL,
	[LogCreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_LogSessions] PRIMARY KEY CLUSTERED 
(
	[LogSessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MyEducationModules]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MyEducationModules](
	[MEMID] [int] IDENTITY(1,1) NOT NULL,
	[EducationModuleID] [int] NOT NULL,
	[MEID] [int] NOT NULL,
	[Completed] [bit] NULL,
	[CompletedDate] [datetime] NULL,
	[TimeLeft] [varchar](50) NULL,
 CONSTRAINT [PK_MyEducationModules] PRIMARY KEY CLUSTERED 
(
	[MEMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MyEducations]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MyEducations](
	[MEID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[EducationID] [int] NOT NULL,
	[EducationTypeID] [int] NOT NULL,
	[Completed] [bit] NULL,
	[CompletedDate] [datetime] NULL,
	[Expired] [bit] NULL,
	[PurchaseDate] [date] NULL,
	[IsPassed] [bit] NULL,
	[CredentialID] [int] NULL,
	[CertificatePrinted] [bit] NULL,
	[CertificateURL] [varchar](50) NULL,
 CONSTRAINT [PK_MyEducations] PRIMARY KEY CLUSTERED 
(
	[MEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[News]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[NewsID] [int] IDENTITY(1,1) NOT NULL,
	[NewsSectionID] [int] NOT NULL,
	[NewsTitle] [varchar](200) NOT NULL,
	[NewsDescription] [varchar](max) NOT NULL,
	[NewsEditorPick] [bit] NOT NULL,
	[NewsDate] [datetime] NOT NULL,
	[NewsType] [varchar](20) NOT NULL,
	[NewsAuthor] [varchar](50) NOT NULL,
 CONSTRAINT [PK_News] PRIMARY KEY CLUSTERED 
(
	[NewsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NewsLetters]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsLetters](
	[NewsLetterID] [int] IDENTITY(1,1) NOT NULL,
	[NewsLetterContent] [varchar](max) NULL,
 CONSTRAINT [PK_NewsLetters] PRIMARY KEY CLUSTERED 
(
	[NewsLetterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NewsPhotos]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsPhotos](
	[NewsPhotoID] [int] IDENTITY(1,1) NOT NULL,
	[NewsID] [int] NOT NULL,
	[NewsPhotos] [varchar](200) NOT NULL,
 CONSTRAINT [PK_NewsPhotos] PRIMARY KEY CLUSTERED 
(
	[NewsPhotoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NewsSections]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsSections](
	[NewsSectionID] [int] IDENTITY(1,1) NOT NULL,
	[NewsSectionTitle] [varchar](500) NOT NULL,
	[NewsSectionType] [varchar](10) NOT NULL,
 CONSTRAINT [PK_NewsSections] PRIMARY KEY CLUSTERED 
(
	[NewsSectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NewsVideos]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsVideos](
	[NewsVideoID] [int] IDENTITY(1,1) NOT NULL,
	[NewsID] [int] NOT NULL,
	[NewsVideos] [varchar](200) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Orders]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderNumber] [varchar](50) NOT NULL,
	[UserID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
 CONSTRAINT [PK_tblOrders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PreTestQuestionResults]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreTestQuestionResults](
	[PreTestQuestionResultID] [int] IDENTITY(1,1) NOT NULL,
	[PreTestQuestionID] [int] NOT NULL,
	[PreTestAnswer] [char](1) NULL,
	[PreTestResultID] [int] NOT NULL,
	[PreTestAnswerTrueFalse] [bit] NULL,
 CONSTRAINT [PK_PreTestQuestionResults] PRIMARY KEY CLUSTERED 
(
	[PreTestQuestionResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PreTestQuestions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreTestQuestions](
	[PreTestQuestionID] [int] IDENTITY(1,1) NOT NULL,
	[PreTestID] [int] NOT NULL,
	[PreTestQues] [varchar](1024) NOT NULL,
	[PreTestOptionA] [varchar](250) NULL,
	[PreTestOptionB] [varchar](250) NULL,
	[PreTestOptionC] [varchar](250) NULL,
	[PreTestOptionD] [varchar](250) NULL,
	[PreTestAnswer] [char](1) NULL,
	[PreTestAnswerType] [varchar](20) NULL,
	[PreTestAnswerTrueFalse] [bit] NULL,
 CONSTRAINT [PK_PreTestQuestions] PRIMARY KEY CLUSTERED 
(
	[PreTestQuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PreTestResults]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreTestResults](
	[PreTestResultID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[IsPass] [bit] NOT NULL,
	[MEID] [int] NULL,
	[PreTestID] [int] NULL,
 CONSTRAINT [PK_PreTestResults] PRIMARY KEY CLUSTERED 
(
	[PreTestResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PreTests]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreTests](
	[PreTestID] [int] IDENTITY(1,1) NOT NULL,
	[PreTestName] [varchar](500) NOT NULL,
	[PreTestStatus] [bit] NOT NULL,
 CONSTRAINT [PK_PreTests] PRIMARY KEY CLUSTERED 
(
	[PreTestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PrivacyPolicies]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrivacyPolicies](
	[PrivacyPolicyID] [int] IDENTITY(1,1) NOT NULL,
	[PrivacyPolicyContent] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Policies] PRIMARY KEY CLUSTERED 
(
	[PrivacyPolicyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductQuantities]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductQuantities](
	[ProductQuantityID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[ProdQuantity] [int] NULL,
	[ProdQuantityDate] [datetime] NULL,
	[UserID] [int] NULL,
	[Mode] [varchar](50) NULL,
 CONSTRAINT [PK_ProductQuantities] PRIMARY KEY CLUSTERED 
(
	[ProductQuantityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Products]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](50) NOT NULL,
	[ProductDesc] [varchar](max) NOT NULL,
	[ProductPrice] [money] NOT NULL,
	[ProductImage] [varchar](50) NULL,
	[ProductFile] [varchar](50) NULL,
	[ProductType] [varchar](20) NULL,
	[ProductTotalQuantity] [int] NULL,
	[ProductCurrentBalance] [int] NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductShippingDetails]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductShippingDetails](
	[ProductShippingDetailID] [int] IDENTITY(1,1) NOT NULL,
	[ProductShippedOn] [datetime] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ShippingPaymentID] [int] NULL,
 CONSTRAINT [PK_ProductShippingDetails] PRIMARY KEY CLUSTERED 
(
	[ProductShippingDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductShoppings]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductShoppings](
	[ProductShoppingID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[CoupanID] [int] NULL,
	[Grandtotal] [money] NOT NULL,
	[OrderID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[ShippingPaymentID] [int] NULL,
	[TaxPercentage] [decimal](18, 2) NULL,
 CONSTRAINT [PK_ProductShoppings] PRIMARY KEY CLUSTERED 
(
	[ProductShoppingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductShoppingTemps]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductShoppingTemps](
	[ProductShoppingTempID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[CoupanID] [int] NULL,
	[Amount] [money] NOT NULL,
	[Date] [datetime] NOT NULL,
	[ShippingPaymentID] [int] NULL,
	[IsProcessed] [bit] NULL,
	[ProcessedDate] [datetime] NULL,
	[TaxPercentage] [decimal](18, 2) NULL,
 CONSTRAINT [PK_ProductShoppingTemps] PRIMARY KEY CLUSTERED 
(
	[ProductShoppingTempID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Professions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Professions](
	[ProfessionID] [int] IDENTITY(1,1) NOT NULL,
	[ProfessionTitle] [varchar](512) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Professions] PRIMARY KEY CLUSTERED 
(
	[ProfessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Resources]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Resources](
	[ResourceID] [int] IDENTITY(1,1) NOT NULL,
	[ResourceTitle] [varchar](200) NULL,
 CONSTRAINT [PK_Resourses] PRIMARY KEY CLUSTERED 
(
	[ResourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ReturnPolicys]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReturnPolicys](
	[ReturnPolicyID] [int] IDENTITY(1,1) NOT NULL,
	[ReturnPolicyContent] [varchar](max) NULL,
 CONSTRAINT [PK_ReturnPolicys] PRIMARY KEY CLUSTERED 
(
	[ReturnPolicyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShippingAddresses]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingAddresses](
	[ShippingAddressID] [int] IDENTITY(1,1) NOT NULL,
	[SAUserID] [int] NOT NULL,
	[SAFirstName] [varchar](30) NULL,
	[SALastName] [varchar](30) NULL,
	[SAAddress] [varchar](100) NULL,
	[SAAddress2] [varchar](100) NULL,
	[SACity] [varchar](50) NULL,
	[SAStateID] [int] NOT NULL,
	[SAPostalCode] [varchar](50) NULL,
	[SAPhone] [varchar](50) NULL,
	[SABillingAddressSame] [bit] NULL,
 CONSTRAINT [PK_tblShippingAddresses] PRIMARY KEY CLUSTERED 
(
	[ShippingAddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShippingMethods]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingMethods](
	[ShippingMethodID] [int] IDENTITY(1,1) NOT NULL,
	[ShippingMethodName] [varchar](50) NULL,
	[ShippingMethodAmount] [money] NULL,
 CONSTRAINT [PK_ShippingMethods] PRIMARY KEY CLUSTERED 
(
	[ShippingMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShippingPayments]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingPayments](
	[ShippingPaymentID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[BillingAddressID] [int] NULL,
	[ShippingAddressID] [int] NULL,
	[ShippingMethodID] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[IsPaymentRecevied] [bit] NULL,
	[TransactionNumber] [varchar](100) NULL,
	[TransactionDatetime] [datetime] NULL,
 CONSTRAINT [PK_ShippingPayments] PRIMARY KEY CLUSTERED 
(
	[ShippingPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SuggestCourses]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SuggestCourses](
	[SuggestCourseID] [int] IDENTITY(1,1) NOT NULL,
	[SCMyOccupation] [varchar](50) NULL,
	[SCStateID] [int] NULL,
	[SCName] [varchar](50) NULL,
	[SCPhone] [varchar](50) NULL,
	[SCEmail] [varchar](50) NULL,
	[SCPossibleTitle] [varchar](100) NULL,
	[SCBriefAgendaOutline] [varchar](max) NULL,
	[SCAudience] [varchar](100) NULL,
	[SCSingleDaySeminarCourse] [bit] NULL,
	[SCOndemandLiveWebinarCourse] [bit] NULL,
	[SCInterestedInstructor] [bit] NULL,
	[SCCreatedDate] [date] NULL,
 CONSTRAINT [PK_SuggestCourses] PRIMARY KEY CLUSTERED 
(
	[SuggestCourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TermsConditions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TermsConditions](
	[TermsConditionID] [int] IDENTITY(1,1) NOT NULL,
	[TermsConditionContent] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Privacies] PRIMARY KEY CLUSTERED 
(
	[TermsConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TrainingAndSeminars]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingAndSeminars](
	[TrainingAndSeminarID] [int] IDENTITY(1,1) NOT NULL,
	[TrainingAndSeminarDesc] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserAllAccessPasses]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAllAccessPasses](
	[UserAllAccessPassID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[AAPCouponID] [int] NULL,
	[IsAllAccessPricingAmountRecevied] [bit] NULL,
	[AllAccessStartDate] [datetime] NULL,
	[AllAccessEndDate] [datetime] NULL,
	[ShippingPaymentID] [int] NULL,
	[UserSubscriptionID] [int] NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_UserAllAcessPasses] PRIMARY KEY CLUSTERED 
(
	[UserAllAccessPassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserCardDetails]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserCardDetails](
	[UserCardDetailID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[UserCardName] [varchar](100) NULL,
	[UserCardNumber] [char](16) NULL,
	[UserCardExpiry] [char](5) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[DeletedBy] [datetime] NULL,
	[DeletedOn] [int] NULL,
 CONSTRAINT [PK_UserCardDetails] PRIMARY KEY CLUSTERED 
(
	[UserCardDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserResetPasswords]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserResetPasswords](
	[UTempPwdID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[TempPwd] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UserResetPasswords] PRIMARY KEY CLUSTERED 
(
	[UTempPwdID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Password] [varchar](1000) NOT NULL,
	[EmailID] [varchar](100) NOT NULL,
	[Company] [varchar](100) NULL,
	[Phone] [varchar](20) NULL,
	[ProfessionalTitle] [varchar](100) NULL,
	[IsActive] [bit] NOT NULL,
	[IsLocked] [bit] NOT NULL,
	[FailedAttemptCount] [int] NOT NULL,
	[LastLoginDate] [date] NULL,
	[Role] [varchar](10) NULL,
	[IsAllAccessPricing] [bit] NULL,
	[UserAllAccessPassID] [int] NULL,
	[IsManagement] [bit] NULL,
	[IsCoursePreview] [bit] NULL,
	[IsVerified] [bit] NULL,
	[VerifiedOn] [datetime] NULL,
	[IsCleared] [bit] NULL,
	[ClearedOn] [datetime] NULL,
	[ClearedBy] [int] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_EmailID_Users] UNIQUE NONCLUSTERED 
(
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserSubscriptions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSubscriptions](
	[UserSubscriptionID] [int] IDENTITY(1,1) NOT NULL,
	[IndividualAccessPricing] [money] NULL,
	[IndividualAccessPricingStart] [money] NULL,
	[IndividualAccessPricingEnd] [money] NULL,
	[IndividualAccessTermsOfService] [varchar](max) NULL,
	[AllAccessPassPricing] [money] NULL,
	[AllAccessParametersCoursePriceStart] [money] NULL,
	[AllAccessParametersCoursePriceEnd] [money] NULL,
	[AllAccessIncludeProgram] [bit] NULL,
	[AllAccessTermsOfService] [varchar](max) NULL,
	[EnterprisePricing] [money] NULL,
	[EnterpriseTermsOfService] [varchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_Subscription] PRIMARY KEY CLUSTERED 
(
	[UserSubscriptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [link].[CollegeEducations]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[CollegeEducations](
	[CollegeCourseID] [int] IDENTITY(1,1) NOT NULL,
	[EducationID] [int] NOT NULL,
	[CollegeID] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_CollegeEducations] PRIMARY KEY CLUSTERED 
(
	[CollegeCourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [link].[EducationEvaluations]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[EducationEvaluations](
	[CourseEvaluationID] [int] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [int] NOT NULL,
	[EducationID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_EducationEvaluations] PRIMARY KEY CLUSTERED 
(
	[CourseEvaluationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [link].[EducationExamQuestions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[EducationExamQuestions](
	[CourseExamID] [int] IDENTITY(1,1) NOT NULL,
	[ExamID] [int] NOT NULL,
	[EducationID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_EducationExamQuestions] PRIMARY KEY CLUSTERED 
(
	[CourseExamID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [link].[EducationFormatAvailables]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[EducationFormatAvailables](
	[EducationAvailableID] [int] IDENTITY(1,1) NOT NULL,
	[EducationID] [int] NOT NULL,
	[EducationFormatID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_EducationFormatAvailables] PRIMARY KEY CLUSTERED 
(
	[EducationAvailableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [link].[EducationPreTestQuestions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[EducationPreTestQuestions](
	[CoursePreTestID] [int] IDENTITY(1,1) NOT NULL,
	[PreTestID] [int] NOT NULL,
	[EducationID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_EducationPreTestQuestions] PRIMARY KEY CLUSTERED 
(
	[CoursePreTestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [link].[EducationProfessions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[EducationProfessions](
	[EducationProfessionID] [int] IDENTITY(1,1) NOT NULL,
	[EducationID] [int] NOT NULL,
	[ProfessionID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_EducationProfession] PRIMARY KEY CLUSTERED 
(
	[EducationProfessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [link].[EducationTypesAvailables]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[EducationTypesAvailables](
	[EducationTypeAID] [int] IDENTITY(1,1) NOT NULL,
	[EducationID] [int] NOT NULL,
	[EducationTypeID] [int] NOT NULL,
	[Price] [money] NOT NULL,
 CONSTRAINT [PK_EducationTypes] PRIMARY KEY CLUSTERED 
(
	[EducationTypeAID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[States]    Script Date: 10-02-2020 16:03:17 ******/
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
ALTER TABLE [dbo].[Accreditors] ADD  CONSTRAINT [DF_Accreditors_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Colleges] ADD  CONSTRAINT [DF_Colleges_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[EducationCredentials] ADD  CONSTRAINT [DF_EducationCredentials_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Educations] ADD  CONSTRAINT [DF_Educations_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Educations] ADD  CONSTRAINT [DF_Educations_ReadyToDisplay]  DEFAULT ((0)) FOR [ReadyToDisplay]
GO
ALTER TABLE [dbo].[EnterprisePackageRegisters] ADD  CONSTRAINT [DF_EnterprisePackageRegisters_EPRCreatedDate]  DEFAULT (getdate()) FOR [EPRCreatedDate]
GO
ALTER TABLE [dbo].[EvaluationQuestions] ADD  CONSTRAINT [DF_EvaluationQuestions_IsStatus]  DEFAULT ((1)) FOR [IsStatus]
GO
ALTER TABLE [dbo].[ExamResults] ADD  CONSTRAINT [DF_ExamResults_IsPass]  DEFAULT ((0)) FOR [IsPass]
GO
ALTER TABLE [dbo].[Faculties] ADD  CONSTRAINT [DF_Faculties_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[LogSessions] ADD  CONSTRAINT [DF_LogSessions_LogCreatedDate]  DEFAULT (getdate()) FOR [LogCreatedDate]
GO
ALTER TABLE [dbo].[MyEducationModules] ADD  CONSTRAINT [DF_MyEducationModules_Completed]  DEFAULT ((0)) FOR [Completed]
GO
ALTER TABLE [dbo].[PreTestResults] ADD  CONSTRAINT [DF_PreTestResults_IsPass]  DEFAULT ((0)) FOR [IsPass]
GO
ALTER TABLE [dbo].[Professions] ADD  CONSTRAINT [DF_Professions_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SuggestCourses] ADD  CONSTRAINT [DF_SuggestCourses_SCSingleDaySeminarCourse]  DEFAULT ((0)) FOR [SCSingleDaySeminarCourse]
GO
ALTER TABLE [dbo].[SuggestCourses] ADD  CONSTRAINT [DF_SuggestCourses_SCOndemandLiveWebinarCourse]  DEFAULT ((0)) FOR [SCOndemandLiveWebinarCourse]
GO
ALTER TABLE [dbo].[SuggestCourses] ADD  CONSTRAINT [DF_SuggestCourses_SCInterestedInstructor]  DEFAULT ((0)) FOR [SCInterestedInstructor]
GO
ALTER TABLE [dbo].[SuggestCourses] ADD  CONSTRAINT [DF_SuggestCourses_SCCreatedDate]  DEFAULT (getdate()) FOR [SCCreatedDate]
GO
ALTER TABLE [dbo].[UserAllAccessPasses] ADD  CONSTRAINT [DF_UserAllAccessPasses_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [link].[CollegeEducations] ADD  CONSTRAINT [DF_CollegeEducations_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [link].[EducationEvaluations] ADD  CONSTRAINT [DF_EducationEvaluations_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [link].[EducationExamQuestions] ADD  CONSTRAINT [DF_EducationExamQuestions_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [link].[EducationFormatAvailables] ADD  CONSTRAINT [DF_EducationFormatAvailables_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [link].[EducationPreTestQuestions] ADD  CONSTRAINT [DF_EducationPreTestQuestions_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [link].[EducationProfessions] ADD  CONSTRAINT [DF_EducationProfessions_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[BillingAddresses]  WITH CHECK ADD  CONSTRAINT [FK_BillingAddresses_States] FOREIGN KEY([BAStateID])
REFERENCES [lookup].[States] ([StateID])
GO
ALTER TABLE [dbo].[BillingAddresses] CHECK CONSTRAINT [FK_BillingAddresses_States]
GO
ALTER TABLE [dbo].[BillingAddresses]  WITH CHECK ADD  CONSTRAINT [FK_tblBillingAddresses_Users] FOREIGN KEY([BAUserID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[BillingAddresses] CHECK CONSTRAINT [FK_tblBillingAddresses_Users]
GO
ALTER TABLE [dbo].[CarouselSetUps]  WITH CHECK ADD  CONSTRAINT [FK_CarouselSetUp_News] FOREIGN KEY([NewsID])
REFERENCES [dbo].[News] ([NewsID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CarouselSetUps] CHECK CONSTRAINT [FK_CarouselSetUp_News]
GO
ALTER TABLE [dbo].[CertificationTitleOptions]  WITH CHECK ADD  CONSTRAINT [FK_CertificationTitleOptions_Educations] FOREIGN KEY([EducationId])
REFERENCES [dbo].[Educations] ([EducationID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CertificationTitleOptions] CHECK CONSTRAINT [FK_CertificationTitleOptions_Educations]
GO
ALTER TABLE [dbo].[EducationDetailPages]  WITH CHECK ADD  CONSTRAINT [FK_EducationDetailPage_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
GO
ALTER TABLE [dbo].[EducationDetailPages] CHECK CONSTRAINT [FK_EducationDetailPage_Educations]
GO
ALTER TABLE [dbo].[EducationModuleFiles]  WITH CHECK ADD  CONSTRAINT [FK_EducationModuleFiles_EducationModules] FOREIGN KEY([EducationModuleID])
REFERENCES [dbo].[EducationModules] ([EducationModuleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EducationModuleFiles] CHECK CONSTRAINT [FK_EducationModuleFiles_EducationModules]
GO
ALTER TABLE [dbo].[EducationModuleFiles]  WITH CHECK ADD  CONSTRAINT [FK_EducationModuleFiles_FileTypes] FOREIGN KEY([FileTypeID])
REFERENCES [dbo].[FileTypes] ([FileTypeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EducationModuleFiles] CHECK CONSTRAINT [FK_EducationModuleFiles_FileTypes]
GO
ALTER TABLE [dbo].[EducationModules]  WITH CHECK ADD  CONSTRAINT [FK_Modules_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EducationModules] CHECK CONSTRAINT [FK_Modules_Educations]
GO
ALTER TABLE [dbo].[Educations]  WITH CHECK ADD  CONSTRAINT [FK_Educations_States] FOREIGN KEY([StateID])
REFERENCES [lookup].[States] ([StateID])
GO
ALTER TABLE [dbo].[Educations] CHECK CONSTRAINT [FK_Educations_States]
GO
ALTER TABLE [dbo].[EducationShoppings]  WITH CHECK ADD  CONSTRAINT [FK_EducationShoppings_DiscountCoupons] FOREIGN KEY([CoupanID])
REFERENCES [dbo].[DiscountCoupons] ([CouponID])
GO
ALTER TABLE [dbo].[EducationShoppings] CHECK CONSTRAINT [FK_EducationShoppings_DiscountCoupons]
GO
ALTER TABLE [dbo].[EducationShoppings]  WITH CHECK ADD  CONSTRAINT [FK_EducationShoppings_EducationTypes] FOREIGN KEY([EducationTypeID])
REFERENCES [dbo].[EducationTypes] ([EducationTypeID])
GO
ALTER TABLE [dbo].[EducationShoppings] CHECK CONSTRAINT [FK_EducationShoppings_EducationTypes]
GO
ALTER TABLE [dbo].[EducationShoppings]  WITH CHECK ADD  CONSTRAINT [FK_tblEducationShoppings_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
GO
ALTER TABLE [dbo].[EducationShoppings] CHECK CONSTRAINT [FK_tblEducationShoppings_Educations]
GO
ALTER TABLE [dbo].[EducationShoppings]  WITH CHECK ADD  CONSTRAINT [FK_tblEducationShoppings_tblOrders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[EducationShoppings] CHECK CONSTRAINT [FK_tblEducationShoppings_tblOrders]
GO
ALTER TABLE [dbo].[EducationShoppings]  WITH CHECK ADD  CONSTRAINT [FK_tblEducationShoppings_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[EducationShoppings] CHECK CONSTRAINT [FK_tblEducationShoppings_Users]
GO
ALTER TABLE [dbo].[EducationShoppingTemps]  WITH CHECK ADD  CONSTRAINT [FK_EducationShoppingTemps_DiscountCoupons] FOREIGN KEY([CoupanID])
REFERENCES [dbo].[DiscountCoupons] ([CouponID])
GO
ALTER TABLE [dbo].[EducationShoppingTemps] CHECK CONSTRAINT [FK_EducationShoppingTemps_DiscountCoupons]
GO
ALTER TABLE [dbo].[EducationShoppingTemps]  WITH CHECK ADD  CONSTRAINT [FK_EducationShoppingTemps_EducationCredentials] FOREIGN KEY([CredentialID])
REFERENCES [dbo].[EducationCredentials] ([CredentialID])
GO
ALTER TABLE [dbo].[EducationShoppingTemps] CHECK CONSTRAINT [FK_EducationShoppingTemps_EducationCredentials]
GO
ALTER TABLE [dbo].[EducationShoppingTemps]  WITH CHECK ADD  CONSTRAINT [FK_EducationShoppingTemps_EducationTypes] FOREIGN KEY([EducationTypeID])
REFERENCES [dbo].[EducationTypes] ([EducationTypeID])
GO
ALTER TABLE [dbo].[EducationShoppingTemps] CHECK CONSTRAINT [FK_EducationShoppingTemps_EducationTypes]
GO
ALTER TABLE [dbo].[EducationShoppingTemps]  WITH CHECK ADD  CONSTRAINT [FK_tblEducationShoppingTemps_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
GO
ALTER TABLE [dbo].[EducationShoppingTemps] CHECK CONSTRAINT [FK_tblEducationShoppingTemps_Educations]
GO
ALTER TABLE [dbo].[EducationShoppingTemps]  WITH CHECK ADD  CONSTRAINT [FK_tblEducationShoppingTemps_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[EducationShoppingTemps] CHECK CONSTRAINT [FK_tblEducationShoppingTemps_Users]
GO
ALTER TABLE [dbo].[Enterprises]  WITH CHECK ADD  CONSTRAINT [FK_Enterprises_States] FOREIGN KEY([EnterpriseStateID])
REFERENCES [lookup].[States] ([StateID])
GO
ALTER TABLE [dbo].[Enterprises] CHECK CONSTRAINT [FK_Enterprises_States]
GO
ALTER TABLE [dbo].[Enterprises]  WITH CHECK ADD  CONSTRAINT [FK_Enterprises_Users] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[Enterprises] CHECK CONSTRAINT [FK_Enterprises_Users]
GO
ALTER TABLE [dbo].[EvaluationQuestionResults]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationQuestionResults_EvaluationAnswers] FOREIGN KEY([EvaluationAnswerID])
REFERENCES [dbo].[EvaluationAnswers] ([EvaluationAnswerID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EvaluationQuestionResults] CHECK CONSTRAINT [FK_EvaluationQuestionResults_EvaluationAnswers]
GO
ALTER TABLE [dbo].[EvaluationQuestionResults]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationQuestionResults_EvaluationQuestions] FOREIGN KEY([EvaluationQuestionID])
REFERENCES [dbo].[EvaluationQuestions] ([EvaluationQuestionID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EvaluationQuestionResults] CHECK CONSTRAINT [FK_EvaluationQuestionResults_EvaluationQuestions]
GO
ALTER TABLE [dbo].[EvaluationQuestionResults]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationQuestionResults_EvaluationResults] FOREIGN KEY([EvaluationResultID])
REFERENCES [dbo].[EvaluationResults] ([EvaluationResultID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EvaluationQuestionResults] CHECK CONSTRAINT [FK_EvaluationQuestionResults_EvaluationResults]
GO
ALTER TABLE [dbo].[EvaluationQuestions]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationQuestions_Evaluations] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[Evaluations] ([EvaluationID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EvaluationQuestions] CHECK CONSTRAINT [FK_EvaluationQuestions_Evaluations]
GO
ALTER TABLE [dbo].[EvaluationResults]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationResults_EducationEvaluations] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[Evaluations] ([EvaluationID])
GO
ALTER TABLE [dbo].[EvaluationResults] CHECK CONSTRAINT [FK_EvaluationResults_EducationEvaluations]
GO
ALTER TABLE [dbo].[EvaluationResults]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationResults_MyEducations] FOREIGN KEY([MEID])
REFERENCES [dbo].[MyEducations] ([MEID])
GO
ALTER TABLE [dbo].[EvaluationResults] CHECK CONSTRAINT [FK_EvaluationResults_MyEducations]
GO
ALTER TABLE [dbo].[EvaluationResults]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationResults_Users] FOREIGN KEY([UID])
REFERENCES [dbo].[Users] ([UID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EvaluationResults] CHECK CONSTRAINT [FK_EvaluationResults_Users]
GO
ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK_Events_Educations]
GO
ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_News] FOREIGN KEY([NewsID])
REFERENCES [dbo].[News] ([NewsID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK_Events_News]
GO
ALTER TABLE [dbo].[ExamQuestionResults]  WITH CHECK ADD  CONSTRAINT [FK_ExamQuestionResults_ExamQuestions] FOREIGN KEY([ExamQuestionID])
REFERENCES [dbo].[ExamQuestions] ([ExamQuestionID])
GO
ALTER TABLE [dbo].[ExamQuestionResults] CHECK CONSTRAINT [FK_ExamQuestionResults_ExamQuestions]
GO
ALTER TABLE [dbo].[ExamQuestionResults]  WITH CHECK ADD  CONSTRAINT [FK_ExamQuestionResults_ExamResults] FOREIGN KEY([ExamResultID])
REFERENCES [dbo].[ExamResults] ([ExamResultID])
GO
ALTER TABLE [dbo].[ExamQuestionResults] CHECK CONSTRAINT [FK_ExamQuestionResults_ExamResults]
GO
ALTER TABLE [dbo].[ExamQuestions]  WITH CHECK ADD  CONSTRAINT [FK_ExamQuestions_Exams] FOREIGN KEY([ExamID])
REFERENCES [dbo].[Exams] ([ExamID])
GO
ALTER TABLE [dbo].[ExamQuestions] CHECK CONSTRAINT [FK_ExamQuestions_Exams]
GO
ALTER TABLE [dbo].[ExamResults]  WITH CHECK ADD  CONSTRAINT [FK_ExamResults_EducationExamQuestions] FOREIGN KEY([ExamID])
REFERENCES [dbo].[Exams] ([ExamID])
GO
ALTER TABLE [dbo].[ExamResults] CHECK CONSTRAINT [FK_ExamResults_EducationExamQuestions]
GO
ALTER TABLE [dbo].[ExamResults]  WITH CHECK ADD  CONSTRAINT [FK_ExamResults_MyEducations] FOREIGN KEY([MEID])
REFERENCES [dbo].[MyEducations] ([MEID])
GO
ALTER TABLE [dbo].[ExamResults] CHECK CONSTRAINT [FK_ExamResults_MyEducations]
GO
ALTER TABLE [dbo].[ExamResults]  WITH CHECK ADD  CONSTRAINT [FK_ExamResults_Users] FOREIGN KEY([UID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[ExamResults] CHECK CONSTRAINT [FK_ExamResults_Users]
GO
ALTER TABLE [dbo].[FAQs]  WITH CHECK ADD  CONSTRAINT [FK_FAQs_FAQCategory] FOREIGN KEY([FAQCatID])
REFERENCES [dbo].[FAQCategories] ([FAQCatID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FAQs] CHECK CONSTRAINT [FK_FAQs_FAQCategory]
GO
ALTER TABLE [dbo].[MyEducations]  WITH CHECK ADD  CONSTRAINT [FK_MyEducations_EducationCredentials] FOREIGN KEY([CredentialID])
REFERENCES [dbo].[EducationCredentials] ([CredentialID])
GO
ALTER TABLE [dbo].[MyEducations] CHECK CONSTRAINT [FK_MyEducations_EducationCredentials]
GO
ALTER TABLE [dbo].[MyEducations]  WITH CHECK ADD  CONSTRAINT [FK_MyEducations_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
GO
ALTER TABLE [dbo].[MyEducations] CHECK CONSTRAINT [FK_MyEducations_Educations]
GO
ALTER TABLE [dbo].[MyEducations]  WITH CHECK ADD  CONSTRAINT [FK_MyEducations_EducationTypes] FOREIGN KEY([EducationTypeID])
REFERENCES [dbo].[EducationTypes] ([EducationTypeID])
GO
ALTER TABLE [dbo].[MyEducations] CHECK CONSTRAINT [FK_MyEducations_EducationTypes]
GO
ALTER TABLE [dbo].[MyEducations]  WITH CHECK ADD  CONSTRAINT [FK_MyEducations_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[MyEducations] CHECK CONSTRAINT [FK_MyEducations_Users]
GO
ALTER TABLE [dbo].[News]  WITH NOCHECK ADD  CONSTRAINT [FK_News_NewsSections] FOREIGN KEY([NewsSectionID])
REFERENCES [dbo].[NewsSections] ([NewsSectionID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[News] CHECK CONSTRAINT [FK_News_NewsSections]
GO
ALTER TABLE [dbo].[NewsPhotos]  WITH CHECK ADD  CONSTRAINT [FK_NewsPhotos_News] FOREIGN KEY([NewsID])
REFERENCES [dbo].[News] ([NewsID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NewsPhotos] CHECK CONSTRAINT [FK_NewsPhotos_News]
GO
ALTER TABLE [dbo].[NewsVideos]  WITH CHECK ADD  CONSTRAINT [FK_NewsVideos_News] FOREIGN KEY([NewsID])
REFERENCES [dbo].[News] ([NewsID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NewsVideos] CHECK CONSTRAINT [FK_NewsVideos_News]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_tblOrders_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_tblOrders_Users]
GO
ALTER TABLE [dbo].[PreTestQuestionResults]  WITH CHECK ADD  CONSTRAINT [FK_PreTestQuestionResults_PreTestQuestions] FOREIGN KEY([PreTestQuestionID])
REFERENCES [dbo].[PreTestQuestions] ([PreTestQuestionID])
GO
ALTER TABLE [dbo].[PreTestQuestionResults] CHECK CONSTRAINT [FK_PreTestQuestionResults_PreTestQuestions]
GO
ALTER TABLE [dbo].[PreTestQuestionResults]  WITH CHECK ADD  CONSTRAINT [FK_PreTestQuestionResults_PreTestResults] FOREIGN KEY([PreTestResultID])
REFERENCES [dbo].[PreTestResults] ([PreTestResultID])
GO
ALTER TABLE [dbo].[PreTestQuestionResults] CHECK CONSTRAINT [FK_PreTestQuestionResults_PreTestResults]
GO
ALTER TABLE [dbo].[PreTestQuestions]  WITH CHECK ADD  CONSTRAINT [FK_PreTestQuestions_PreTests] FOREIGN KEY([PreTestID])
REFERENCES [dbo].[PreTests] ([PreTestID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PreTestQuestions] CHECK CONSTRAINT [FK_PreTestQuestions_PreTests]
GO
ALTER TABLE [dbo].[PreTestResults]  WITH CHECK ADD  CONSTRAINT [FK_PreTestResults_EducationPreTestQuestions] FOREIGN KEY([PreTestID])
REFERENCES [dbo].[PreTests] ([PreTestID])
GO
ALTER TABLE [dbo].[PreTestResults] CHECK CONSTRAINT [FK_PreTestResults_EducationPreTestQuestions]
GO
ALTER TABLE [dbo].[PreTestResults]  WITH CHECK ADD  CONSTRAINT [FK_PreTestResults_MyEducations] FOREIGN KEY([MEID])
REFERENCES [dbo].[MyEducations] ([MEID])
GO
ALTER TABLE [dbo].[PreTestResults] CHECK CONSTRAINT [FK_PreTestResults_MyEducations]
GO
ALTER TABLE [dbo].[PreTestResults]  WITH CHECK ADD  CONSTRAINT [FK_PreTestResults_Users] FOREIGN KEY([UID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[PreTestResults] CHECK CONSTRAINT [FK_PreTestResults_Users]
GO
ALTER TABLE [dbo].[ProductQuantities]  WITH CHECK ADD  CONSTRAINT [FK_ProductQuantities_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductQuantities] CHECK CONSTRAINT [FK_ProductQuantities_Products]
GO
ALTER TABLE [dbo].[ProductShoppingTemps]  WITH CHECK ADD  CONSTRAINT [FK_ProductShoppingTemps_DiscountCoupons] FOREIGN KEY([CoupanID])
REFERENCES [dbo].[DiscountCoupons] ([CouponID])
GO
ALTER TABLE [dbo].[ProductShoppingTemps] CHECK CONSTRAINT [FK_ProductShoppingTemps_DiscountCoupons]
GO
ALTER TABLE [dbo].[ProductShoppingTemps]  WITH CHECK ADD  CONSTRAINT [FK_ProductShoppingTemps_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[ProductShoppingTemps] CHECK CONSTRAINT [FK_ProductShoppingTemps_Products]
GO
ALTER TABLE [dbo].[ProductShoppingTemps]  WITH CHECK ADD  CONSTRAINT [FK_ProductShoppingTemps_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[ProductShoppingTemps] CHECK CONSTRAINT [FK_ProductShoppingTemps_Users]
GO
ALTER TABLE [dbo].[ShippingAddresses]  WITH CHECK ADD  CONSTRAINT [FK_ShippingAddresses_States] FOREIGN KEY([SAStateID])
REFERENCES [lookup].[States] ([StateID])
GO
ALTER TABLE [dbo].[ShippingAddresses] CHECK CONSTRAINT [FK_ShippingAddresses_States]
GO
ALTER TABLE [dbo].[ShippingAddresses]  WITH CHECK ADD  CONSTRAINT [FK_tblShippingAddresses_Users] FOREIGN KEY([SAUserID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[ShippingAddresses] CHECK CONSTRAINT [FK_tblShippingAddresses_Users]
GO
ALTER TABLE [dbo].[ShippingPayments]  WITH CHECK ADD  CONSTRAINT [FK_ShippingPayments_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[ShippingPayments] CHECK CONSTRAINT [FK_ShippingPayments_Users]
GO
ALTER TABLE [dbo].[SuggestCourses]  WITH CHECK ADD  CONSTRAINT [FK_SuggestCourses_States] FOREIGN KEY([SCStateID])
REFERENCES [lookup].[States] ([StateID])
GO
ALTER TABLE [dbo].[SuggestCourses] CHECK CONSTRAINT [FK_SuggestCourses_States]
GO
ALTER TABLE [dbo].[UserAllAccessPasses]  WITH CHECK ADD  CONSTRAINT [FK_UserAllAccessPasses_ShippingPayments] FOREIGN KEY([ShippingPaymentID])
REFERENCES [dbo].[ShippingPayments] ([ShippingPaymentID])
GO
ALTER TABLE [dbo].[UserAllAccessPasses] CHECK CONSTRAINT [FK_UserAllAccessPasses_ShippingPayments]
GO
ALTER TABLE [dbo].[UserAllAccessPasses]  WITH CHECK ADD  CONSTRAINT [FK_UserAllAccessPasses_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[UserAllAccessPasses] CHECK CONSTRAINT [FK_UserAllAccessPasses_Users]
GO
ALTER TABLE [dbo].[UserAllAccessPasses]  WITH CHECK ADD  CONSTRAINT [FK_UserAllAccessPasses_UserSubscriptions] FOREIGN KEY([UserSubscriptionID])
REFERENCES [dbo].[UserSubscriptions] ([UserSubscriptionID])
GO
ALTER TABLE [dbo].[UserAllAccessPasses] CHECK CONSTRAINT [FK_UserAllAccessPasses_UserSubscriptions]
GO
ALTER TABLE [dbo].[UserCardDetails]  WITH CHECK ADD  CONSTRAINT [FK_UserCardDetails_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[UserCardDetails] CHECK CONSTRAINT [FK_UserCardDetails_Users]
GO
ALTER TABLE [dbo].[UserResetPasswords]  WITH CHECK ADD  CONSTRAINT [FK_UserResetPasswords_Users] FOREIGN KEY([UID])
REFERENCES [dbo].[Users] ([UID])
GO
ALTER TABLE [dbo].[UserResetPasswords] CHECK CONSTRAINT [FK_UserResetPasswords_Users]
GO
ALTER TABLE [dbo].[UserSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_UserSubscriptions_Users] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserSubscriptions] CHECK CONSTRAINT [FK_UserSubscriptions_Users]
GO
ALTER TABLE [link].[CollegeEducations]  WITH CHECK ADD  CONSTRAINT [FK_CollegeEducations_Colleges] FOREIGN KEY([CollegeID])
REFERENCES [dbo].[Colleges] ([CollegeID])
GO
ALTER TABLE [link].[CollegeEducations] CHECK CONSTRAINT [FK_CollegeEducations_Colleges]
GO
ALTER TABLE [link].[CollegeEducations]  WITH CHECK ADD  CONSTRAINT [FK_CollegeEducations_Educations1] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [link].[CollegeEducations] CHECK CONSTRAINT [FK_CollegeEducations_Educations1]
GO
ALTER TABLE [link].[EducationEvaluations]  WITH CHECK ADD  CONSTRAINT [FK_EducationEvaluations_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
GO
ALTER TABLE [link].[EducationEvaluations] CHECK CONSTRAINT [FK_EducationEvaluations_Educations]
GO
ALTER TABLE [link].[EducationEvaluations]  WITH CHECK ADD  CONSTRAINT [FK_EducationEvaluations_Evaluations] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[Evaluations] ([EvaluationID])
GO
ALTER TABLE [link].[EducationEvaluations] CHECK CONSTRAINT [FK_EducationEvaluations_Evaluations]
GO
ALTER TABLE [link].[EducationExamQuestions]  WITH CHECK ADD  CONSTRAINT [FK_EducationExamQuestions_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [link].[EducationExamQuestions] CHECK CONSTRAINT [FK_EducationExamQuestions_Educations]
GO
ALTER TABLE [link].[EducationExamQuestions]  WITH CHECK ADD  CONSTRAINT [FK_EducationExamQuestions_Exams] FOREIGN KEY([ExamID])
REFERENCES [dbo].[Exams] ([ExamID])
GO
ALTER TABLE [link].[EducationExamQuestions] CHECK CONSTRAINT [FK_EducationExamQuestions_Exams]
GO
ALTER TABLE [link].[EducationFormatAvailables]  WITH CHECK ADD  CONSTRAINT [FK_EducationFormatAvailables_EducationFormats] FOREIGN KEY([EducationFormatID])
REFERENCES [dbo].[EducationFormats] ([EducationFormatID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [link].[EducationFormatAvailables] CHECK CONSTRAINT [FK_EducationFormatAvailables_EducationFormats]
GO
ALTER TABLE [link].[EducationFormatAvailables]  WITH CHECK ADD  CONSTRAINT [FK_EducationFormatAvailables_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [link].[EducationFormatAvailables] CHECK CONSTRAINT [FK_EducationFormatAvailables_Educations]
GO
ALTER TABLE [link].[EducationPreTestQuestions]  WITH CHECK ADD  CONSTRAINT [FK_EducationPreTestQuestions_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [link].[EducationPreTestQuestions] CHECK CONSTRAINT [FK_EducationPreTestQuestions_Educations]
GO
ALTER TABLE [link].[EducationPreTestQuestions]  WITH CHECK ADD  CONSTRAINT [FK_EducationPreTestQuestions_PreTests] FOREIGN KEY([PreTestID])
REFERENCES [dbo].[PreTests] ([PreTestID])
GO
ALTER TABLE [link].[EducationPreTestQuestions] CHECK CONSTRAINT [FK_EducationPreTestQuestions_PreTests]
GO
ALTER TABLE [link].[EducationProfessions]  WITH CHECK ADD  CONSTRAINT [FK_EducationProfession_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
ON DELETE CASCADE
GO
ALTER TABLE [link].[EducationProfessions] CHECK CONSTRAINT [FK_EducationProfession_Educations]
GO
ALTER TABLE [link].[EducationProfessions]  WITH CHECK ADD  CONSTRAINT [FK_EducationProfession_Professions] FOREIGN KEY([ProfessionID])
REFERENCES [dbo].[Professions] ([ProfessionID])
ON DELETE CASCADE
GO
ALTER TABLE [link].[EducationProfessions] CHECK CONSTRAINT [FK_EducationProfession_Professions]
GO
ALTER TABLE [link].[EducationTypesAvailables]  WITH CHECK ADD  CONSTRAINT [FK_EducationTypes_Educations] FOREIGN KEY([EducationID])
REFERENCES [dbo].[Educations] ([EducationID])
GO
ALTER TABLE [link].[EducationTypesAvailables] CHECK CONSTRAINT [FK_EducationTypes_Educations]
GO
ALTER TABLE [link].[EducationTypesAvailables]  WITH CHECK ADD  CONSTRAINT [FK_EducationTypes_EducationTypes] FOREIGN KEY([EducationTypeID])
REFERENCES [dbo].[EducationTypes] ([EducationTypeID])
GO
ALTER TABLE [link].[EducationTypesAvailables] CHECK CONSTRAINT [FK_EducationTypes_EducationTypes]
GO
ALTER TABLE [dbo].[ExamQuestionResults]  WITH CHECK ADD  CONSTRAINT [CK_ExamQuestionResults] CHECK  (([ExamAnswer]='A' OR [ExamAnswer]='B' OR [ExamAnswer]='C' OR [ExamAnswer]='D'))
GO
ALTER TABLE [dbo].[ExamQuestionResults] CHECK CONSTRAINT [CK_ExamQuestionResults]
GO
ALTER TABLE [dbo].[ExamQuestions]  WITH NOCHECK ADD  CONSTRAINT [CK_ExamQuestions] CHECK  (([ExamAnswer]='A' OR [ExamAnswer]='B' OR [ExamAnswer]='C' OR [ExamAnswer]='D'))
GO
ALTER TABLE [dbo].[ExamQuestions] CHECK CONSTRAINT [CK_ExamQuestions]
GO
ALTER TABLE [dbo].[PreTestQuestionResults]  WITH CHECK ADD  CONSTRAINT [CK_PreTestQuestionResults] CHECK  (([PreTestAnswer]='A' OR [PreTestAnswer]='B' OR [PreTestAnswer]='C' OR [PreTestAnswer]='D'))
GO
ALTER TABLE [dbo].[PreTestQuestionResults] CHECK CONSTRAINT [CK_PreTestQuestionResults]
GO
ALTER TABLE [dbo].[PreTestQuestions]  WITH CHECK ADD  CONSTRAINT [CK_PreTestQuestions] CHECK  (([PreTestAnswer]='A' OR [PreTestAnswer]='B' OR [PreTestAnswer]='C' OR [PreTestAnswer]='D'))
GO
ALTER TABLE [dbo].[PreTestQuestions] CHECK CONSTRAINT [CK_PreTestQuestions]
GO
/****** Object:  StoredProcedure [dbo].[Add_EducationModuleToMyEducationByEducationID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: HSingh
-- Create date: 10/27/2014
-- Description: ADD EDUCATION MODULE TO MY EDUCATION MODULE FOR EDUCATION.
-- Version: 1.0
-- ========================================================================================== 
-- Author By: HSingh
-- Create date: 01/12/2015
-- Description: add left time column.
-- Version: 1.1
-- ========================================================================================== 
CREATE PROCEDURE [dbo].[Add_EducationModuleToMyEducationByEducationID]
	@MEID int,
	@EducationID int
AS
BEGIN

--declare @timer bit

--		Select @timer=IsTimerRequired from Educations where  (EducationID = @EducationID)
--			if(@timer=0)
--					Begin
--						INSERT INTO MyEducationModules
--												  (EducationModuleID, MEID, TimeLeft,Completed,CompletedDate)
--							SELECT     EducationModuleID, @MEID AS Expr1, EducationModuleTime,1,GETDATE()
--							FROM         EducationModules WITH (READPAST, ROWLOCK)
--							WHERE     (EducationID = @EducationID) order by EducationModulePosition 
--					end
--			Else
--					begin
							INSERT INTO MyEducationModules
												  (EducationModuleID, MEID, TimeLeft)
							SELECT     EducationModuleID, @MEID AS Expr1, EducationModuleTime
							FROM         EducationModules WITH (READPAST, ROWLOCK)
							WHERE     (EducationID = @EducationID) order by EducationModulePosition 
				--	end
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Add_EvaluationQuestionsFromEvaluationPredefinedQuestions]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: MAHINDER SINGH
-- Create date: 31 AUG 2016
-- Description: ADD EVALUATION QUESTIONS FROM PREDEFINED EVALUATION QUESTIONS.
-- Version: 1.0
-- ========================================================================================== 
CREATE PROCEDURE [dbo].[Add_EvaluationQuestionsFromEvaluationPredefinedQuestions]	
@EvaluationID INT
AS
BEGIN

	INSERT INTO EvaluationQuestions
						  (EvaluationID,EvaluationQues)
	SELECT     @EvaluationID, EvalPredefinedQuestions
	FROM         EvaluationPredefinedQuestions 
	
	SELECT 1
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Check_AnyProductsIsOutOfStock]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================ 
-- Author By: RKumar
-- Create date: 07/18/2016
-- Description: Check Any Products Is Out Of Stock
-- Version: 1.1
-- ================================================================ 
-- [dbo].[Check_AnyProductsIsOutOfStock] 173

CREATE PROCEDURE [dbo].[Check_AnyProductsIsOutOfStock]
	@UserID int
AS
BEGIN
	if((SELECT COUNT(*) FROM ProductShoppingTemps INNER JOIN Products ON ProductShoppingTemps.ProductID = Products.ProductID where Products.ProductCurrentBalance = 0 and ProductShoppingTemps.UserID= @UserID) > 0 )
	begin
			DELETE FROM ProductShoppingTemps
			FROM         ProductShoppingTemps INNER JOIN
								  Products ON ProductShoppingTemps.ProductID = Products.ProductID
			WHERE     (Products.ProductCurrentBalance = 0) AND (ProductShoppingTemps.UserID = @UserID)
			
			Select 1
	end
	else
	begin
			Select 0
	end
END
GO
/****** Object:  StoredProcedure [dbo].[Delete_EducationFromShoppingCart]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 08/05/2014
-- Description: to delete education from shopping part.
-- Version: 1.0
-- ================================================================ 
 CREATE PROCEDURE [dbo].[Delete_EducationFromShoppingCart]
	@EducationShoppingTempID int
AS
BEGIN

	DELETE FROM EducationShoppingTemps 
	WHERE     (EducationShoppingTempID = @EducationShoppingTempID)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Delete_EducationFromShoppingCartByUserID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 08/05/2014
-- Description: to delete education from shopping cart by UserID.
-- Version: 1.0
-- ================================================================ 
 Create PROCEDURE [dbo].[Delete_EducationFromShoppingCartByUserID]
	@UserID int
AS
BEGIN

	DELETE FROM EducationShoppingTemps 
	WHERE     (UserID = @UserID)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Delete_EducationModule]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 09/24/2014
-- Description: Delete EducationModule by EducationModuleID
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Delete_EducationModule]
		@EducationModuleID int
AS
BEGIN
declare 
@EducationID INT,
@Position int

      SELECT @EducationID=EducationID,@Position=EducationModulePosition FROM EducationModules WHERE EducationModuleID=@EducationModuleID
      
    DELETE FROM EducationModules
WHERE     (EducationModuleID = @EducationModuleID) 
		
			UPDATE    EducationModules
SET              EducationModulePosition = EducationModulePosition - 1
WHERE     (EducationModulePosition > @Position) AND (EducationID = @EducationID)
	
END
GO
/****** Object:  StoredProcedure [dbo].[Delete_EducationModuleFilesByFileTypeIdAndEducationModuleID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Mahinder Singh
-- Create date: 25 JAN 2015
-- Description: to delete education module from educationmodule File ID .
-- ================================================================ 
CREATE PROCEDURE [dbo].[Delete_EducationModuleFilesByFileTypeIdAndEducationModuleID] 
	@EducationModuleFileID INT,
	@FileTypeID INT
	
AS
BEGIN
	DELETE FROM [dbo].[EducationModuleFiles]
	WHERE EducationModuleFileID = @EducationModuleFileID AND FileTypeID = @FileTypeID
END

GO
/****** Object:  StoredProcedure [dbo].[Delete_EducationShoppingCartByShippingPaymentID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: rkumar
-- Create date: 28/06/2016
-- Description: Delete Education Shopping Cart By Shipping PaymentID
-- Version: 1.0
-- ================================================================ 
 CREATE PROCEDURE [dbo].[Delete_EducationShoppingCartByShippingPaymentID]
	@ShippingPaymentID int
AS
BEGIN
	DELETE FROM EducationShoppingTemps where ShippingPaymentID = @ShippingPaymentID
	DELETE FROM ProductShoppingTemps  where ShippingPaymentID = @ShippingPaymentID
END
GO
/****** Object:  StoredProcedure [dbo].[Delete_ProductFromShoppingCart]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 03/31/2016
-- Description: to delete Product from shopping part.
-- Version: 1.0
-- ================================================================ 
 Create PROCEDURE [dbo].[Delete_ProductFromShoppingCart]
	@ProductShoppingTempID int
AS
BEGIN

	DELETE FROM ProductShoppingTemps 
	WHERE     (ProductShoppingTempID = @ProductShoppingTempID)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Delete_ProductFromShoppingCartByUserID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 04/01/2015
-- Description: to delete Product from shopping cart by UserID.
-- Version: 1.0
-- ================================================================ 
 Create PROCEDURE [dbo].[Delete_ProductFromShoppingCartByUserID]
	@UserID int
AS
BEGIN

	DELETE FROM ProductShoppingTemps 
	WHERE     (UserID = @UserID)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_CarouselSetUpAll]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author     :	MMSingh
-- Create date: 06/24/2015
-- Description:	Get Carousel Result after Saving the data in CarouselSetUp Table
-- ==============================================================================
CREATE PROCEDURE [dbo].[Get_CarouselSetUpAll]

AS
BEGIN
	
SELECT     CarouselSetUps.CarouselID, CarouselSetUps.CarouselTitle, CarouselSetUps.CarouselDescription, CarouselSetUps.CarouselBgColor, CarouselSetUps.NewsID, 
                      News.NewsTitle, News.NewsDescription, News.NewsType
FROM         CarouselSetUps WITH (READPAST, ROWLOCK) INNER JOIN
                      News WITH (READPAST, ROWLOCK) ON News.NewsID = CarouselSetUps.NewsID
END

GO
/****** Object:  StoredProcedure [dbo].[Get_CertificateDetailByMEID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 08/05/2015
-- Description: GET Certificate Detail By MEID
-- Version: 1.0
-- ================================================================ 
-- Update History: -
--	1.1 : HSingh : 08/25/2015
--		  Description: Credentitals no more required.
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_CertificateDetailByMEID]
	@MEID int
AS
BEGIN
	
	SELECT     Educations.CourseName, MyEducations.CompletedDate, UPPER(LEFT(Users.FirstName, 1)) + SUBSTRING(Users.FirstName, 2, LEN(Users.FirstName))
						  + ' ' + UPPER(LEFT(Users.LastName, 1)) + LOWER(SUBSTRING(Users.LastName, 2, LEN(Users.LastName))) AS Name, EducationCredentials.CertificateMessage, 
						  Accreditors.AccreditorName, EducationCredentials.CredentialUnit, EducationCredentials.CredentialProgram
	FROM         Accreditors WITH (READPAST, ROWLOCK) INNER JOIN
						  EducationCredentials WITH (READPAST, ROWLOCK) ON Accreditors.AccreditorID = EducationCredentials.AccreditorID RIGHT OUTER JOIN
						  Educations WITH (READPAST, ROWLOCK) INNER JOIN
						  MyEducations WITH (READPAST, ROWLOCK) ON Educations.EducationID = MyEducations.EducationID INNER JOIN
						  Users WITH (READPAST, ROWLOCK) ON MyEducations.UserID = Users.UID ON EducationCredentials.CredentialID = MyEducations.CredentialID
	WHERE     (MyEducations.MEID = @MEID)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_CollegeEducationByEducationID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 08/24/2015
-- Description: GET COLLEGE education.
-- Version: 1.0
-- ================================================================ 

Create PROCEDURE [dbo].[Get_CollegeEducationByEducationID]
	@EducationID int
AS
BEGIN

	SELECT     Colleges.CollegeID, Colleges.CollegeName, link.CollegeEducations.CollegeCourseID,link.CollegeEducations.EducationID, link.CollegeEducations.IsActive
	FROM         Colleges WITH (READPAST, ROWLOCK) inner join
						  link.CollegeEducations ON link.CollegeEducations.CollegeID= Colleges.CollegeID
	WHERE     (link.CollegeEducations.EducationID = @EducationID) AND (link.CollegeEducations.IsActive = 1 OR link.CollegeEducations.IsActive IS NULL)
	ORDER BY Colleges.CollegeID
						  
END
GO
/****** Object:  StoredProcedure [dbo].[GET_CourseExpirySendEmailAlert]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,21-09-2015>
-- Description:	<Description,, Send Email to user for alertify expiry date of course>
-- =============================================
CREATE PROCEDURE [dbo].[GET_CourseExpirySendEmailAlert]

AS
BEGIN
SELECT     CASE WHEN Educations.CouseAllotedDaysMonth = 'Days' THEN DATEADD(DD, Educations.CourseAllotedTime, MyEducations.PurchaseDate) ELSE DATEADD(MM, 
                      Educations.CourseAllotedTime, MyEducations.PurchaseDate) END AS 'ExpiryDate', Users.EmailID as Email, Educations.CourseName, (Users.FirstName+' '+Users.LastName) as 
                      UserName
FROM         MyEducations INNER JOIN
                      Educations ON MyEducations.EducationID = Educations.EducationID INNER JOIN
                      Users ON MyEducations.UserID = Users.UID
WHERE     (MyEducations.Completed IS NULL OR
                      MyEducations.Completed = 0) AND (MyEducations.Expired IS NULL OR
                      MyEducations.Expired = 0) AND (DATEDIFF(DD, GETDATE(), CASE WHEN Educations.CouseAllotedDaysMonth = 'Days' THEN DATEADD(DD, 
                      Educations.CourseAllotedTime, MyEducations.PurchaseDate) ELSE DATEADD(MM, Educations.CourseAllotedTime, MyEducations.PurchaseDate) END) IN (7, 1))
END

GO
/****** Object:  StoredProcedure [dbo].[GET_CourseNameDropDownList]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Mahinder Singh>
-- Create date: <Create Date,,11 Aug 2016>
-- Description:	<Description,, Get all DropDownList in Courses>
-- =============================================
CREATE PROCEDURE [dbo].[GET_CourseNameDropDownList]
AS
BEGIN
    
     SELECT EducationID,CourseName FROM Educations WHERE  IsProgramRequired = 1 AND  EducationID NOT IN (SELECT EducationID FROM dbo.CertificationTitleOptions)
    
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DiscountCouponCountForCourses]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: GJain
-- Create date: 05/16/2015
-- Description: GET professions by college id.
-- Version: 1.0
-- ================================================================ 
create  PROCEDURE [dbo].[Get_DiscountCouponCountForCourses]
	AS
BEGIN
SELECT  COUNT(*)
FROM         DiscountCoupons WITH (READPAST, ROWLOCK) INNER JOIN
                      Educations ON Educations.EducationID = DiscountCoupons.CouponEducationID
WHERE     (DiscountCoupons.CouponProduactID = 0)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_DiscountCouponForCourses]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 07/22/2014
-- Description: GET professions by college id.
-- Version: 1.0
-- ================================================================ 
Create PROCEDURE [dbo].[Get_DiscountCouponForCourses]
	AS
BEGIN
SELECT     DiscountCoupons.CouponID, DiscountCoupons.CouponCode, DiscountCoupons.CouponType, DiscountCoupons.CouponEducationID, 
                      DiscountCoupons.CouponProduactID, DiscountCoupons.CouponDiscount, DiscountCoupons.CouponExpiryDate, DiscountCoupons.CouponIssueDate, 
                      DiscountCoupons.CoupanValid, Educations.CourseName
FROM         DiscountCoupons WITH (READPAST, ROWLOCK) INNER JOIN
                      Educations ON Educations.EducationID = DiscountCoupons.CouponEducationID
WHERE     (DiscountCoupons.CouponProduactID = 0)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_DiscountCouponForProducts]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 07/22/2014
-- Description: GET professions by college id.
-- Version: 1.0
-- ================================================================ 
Create PROCEDURE [dbo].[Get_DiscountCouponForProducts]
	AS
BEGIN
SELECT     DiscountCoupons.CouponID, DiscountCoupons.CouponCode, DiscountCoupons.CouponType, DiscountCoupons.CouponEducationID, 
                      DiscountCoupons.CouponProduactID, DiscountCoupons.CouponDiscount, DiscountCoupons.CouponExpiryDate, DiscountCoupons.CouponIssueDate, 
                      DiscountCoupons.CoupanValid, Educations.CourseName
FROM         DiscountCoupons WITH (READPAST, ROWLOCK) INNER JOIN
                      Educations ON Educations.EducationID = DiscountCoupons.CouponEducationID
WHERE     (DiscountCoupons.CouponEducationID = 0)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationAll]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: Gjain
-- Create date:09/19/2014
-- Description: GET All Education for Education pages for which modules are added
-- Version: 1.0
-- ========================================================================================== 

Create PROCEDURE [dbo].[Get_EducationAll]
	@skip int,
	@take int
AS
BEGIN
	
	declare @table as table(
		rownumber int,
		educationID int,
		CourseName varchar(250),
		CourseCode varchar(100),
		CourseDescription varchar(max),
		CourseTime varchar(50),
		CourseCredential bit,
		CourseUploadDate date,
		CoursePrice money,
		IsActive bit,
		TotalCount int
	)
	
		insert into @table(rownumber, EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, CourseUploadDate, CoursePrice, IsActive)
		select ROW_NUMBER() over(ORDER BY CourseUploadDate desc,EducationID desc)as rownumber, * from (
SELECT DISTINCT 
                      Educations.EducationID, Educations.CourseName, Educations.CourseCode, Educations.CourseDescription, Educations.CourseTime, Educations.CourseCredential, 
                      Educations.CourseUploadDate, Educations.CoursePrice, Educations.IsActive
FROM         Educations WITH (READPAST, ROWLOCK) INNER JOIN
                      EducationModules WITH (READPAST, ROWLOCK) ON Educations.EducationID = EducationModules.EducationID
WHERE     (Educations.IsActive <> 0)		)as hp
	
	update @table
	set TotalCount=(select count(*) from @table)
	
	select * from @table
	where rownumber between @skip+1 and (@skip+@take)					  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationAndEducationFormat]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 08/28/2014
-- Description: GET All Education and education format
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_EducationAndEducationFormat]
AS
BEGIN

	SELECT     Educations.CourseName,EducationFormats.EducationFormatType,EducationFormats.EducationPriority, link.EducationFormatAvailables.EducationAvailableID, link.EducationFormatAvailables.EducationFormatID, link.EducationFormatAvailables.EducationID,
						  link.EducationFormatAvailables.IsActive
	FROM         dbo.EducationFormats WITH (READPAST, ROWLOCK) INNER JOIN
						  link.EducationFormatAvailables WITH (READPAST, ROWLOCK) ON EducationFormats.EducationFormatID = link.EducationFormatAvailables.EducationFormatID INNER JOIN
						  Educations ON link.EducationFormatAvailables.EducationID = Educations.EducationID
	WHERE     (link.EducationFormatAvailables.IsActive is null or link.EducationFormatAvailables.IsActive=1)
                      
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationAndProfession]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 07/23/2014
-- Description: GET All Education and profession
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_EducationAndProfession]
AS
BEGIN

	SELECT     Educations.CourseName,Professions.ProfessionTitle, link.EducationProfessions.EducationProfessionID, link.EducationProfessions.EducationID, link.EducationProfessions.ProfessionID, 
						  link.EducationProfessions.IsActive
	FROM         Professions WITH (READPAST, ROWLOCK) INNER JOIN
						  link.EducationProfessions WITH (READPAST, ROWLOCK) ON Professions.ProfessionID = link.EducationProfessions.ProfessionID INNER JOIN
						  Educations ON link.EducationProfessions.EducationID = Educations.EducationID
	WHERE     (link.EducationProfessions.IsActive is null or link.EducationProfessions.IsActive= 1)
                      
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationByCollegeOREduFormatIDORDeptIDORPrfIDPaged]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: Gjain
-- Create date: 11/29/2014
-- Description: GET All Education against available format,departmentid,professionid and collegeid 
-- Version: 1.0
-- ========================================================================================== 
-- Author By: HSingh
-- Create date: 12/03/2014
-- Description: get unique records.
-- Version: 1.1
-- ===========================================================================================
-- Author By: HSingh
-- Create date: 07/31/2015
-- Description: rename sp and apply paging
-- Version: 1.2
-- ===========================================================================================
-- Author By: HSingh
-- Create date: 08/31/2015
-- Description: rename sp and apply paging
-- Version: 1.3
-- ===========================================================================================
-- Author By: GJain
-- Create date: 09/19/2015
-- Description: Show those only those education,for which module exist
-- Version: 1.4
-- ===========================================================================================
-- Author By: GJain
-- Create date: 09/25/2015
-- Description: Show Satrt and end date of education
-- Version: 1.4
-- ===========================================================================================
-- Author By: GJain
-- Create date: 02/04/2016
-- Description: Ispublish condition Add
-- Version: 1.5
-- ===========================================================================================
-- [dbo].[Get_EducationByCollegeOREduFormatIDORDeptIDORPrfIDPaged] null,null,null,227,0,10

CREATE PROCEDURE [dbo].[Get_EducationByCollegeOREduFormatIDORDeptIDORPrfIDPaged]
	@CollegeID int=null,
	@EducationFormatID int=null,
	@ProfessionID int=null,
	@UserID int=null,
	@skip int,
	@take int
AS
BEGIN

	declare @IsCourserPreview as bit=0
	
	set @IsCourserPreview = (SELECT      IsCoursePreview FROM         Users where UID = @UserID)

	
	declare @table as table(
		rownumber int,
		educationID int,
		CourseName varchar(250),
		CourseCode varchar(100),
		CourseDescription varchar(max),
		CourseTime varchar(50),
		CourseCredential bit,
		CourseUploadDate date,
		CoursePrice money,
		IsActive bit,
		TotalCount int,
		CouseAllotedDaysMonth varchar(10),
		CourseAllotedTime int,
		CourseEndDate datetime,
		CourseStartDate datetime
	)
	if(@IsCourserPreview=1)
	begin
	
		insert into @table(rownumber, EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, 
		CourseUploadDate, CoursePrice, IsActive,
		CouseAllotedDaysMonth,CourseAllotedTime,CourseEndDate,CourseStartDate)
		select ROW_NUMBER() over(ORDER BY CourseUploadDate desc,EducationID desc)as rownumber, * from (
			SELECT DISTINCT 
                      Educations.EducationID, Educations.CourseName, Educations.CourseCode, Educations.CourseDescription, Educations.CourseTime, Educations.CourseCredential, 
                      Educations.CourseUploadDate, Educations.CoursePrice, Educations.IsActive, Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
                      Educations.CourseEndDate, Educations.CourseStartDate
			FROM         link.CollegeEducations WITH (READPAST, ROWLOCK) INNER JOIN
                      Educations WITH (READPAST, ROWLOCK) ON link.CollegeEducations.EducationID = Educations.EducationID INNER JOIN
                      link.EducationFormatAvailables WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.EducationFormatAvailables.EducationID AND 
                      Educations.EducationID = link.EducationFormatAvailables.EducationID INNER JOIN
                      link.EducationProfessions ON link.EducationProfessions.EducationID = Educations.EducationID INNER JOIN
                      EducationModules WITH (READPAST, ROWLOCK) ON Educations.EducationID = EducationModules.EducationID
			WHERE     (link.EducationFormatAvailables.EducationFormatID = ISNULL(@EducationFormatID, link.EducationFormatAvailables.EducationFormatID)) AND 
                      (link.EducationProfessions.ProfessionID = ISNULL(@ProfessionID, link.EducationProfessions.ProfessionID)) AND (Educations.IsActive <> 0) AND 
                      (link.CollegeEducations.CollegeID = ISNULL(@CollegeID, link.CollegeEducations.CollegeID)) AND (GETDATE() BETWEEN Educations.CourseStartDate AND 
                      Educations.CourseEndDate) AND (Educations.ReadyToDisplay = 1)	AND (Educations.IsPublished=1)
                      
            union
            
            SELECT DISTINCT 
                      Educations.EducationID, Educations.CourseName, Educations.CourseCode, Educations.CourseDescription, Educations.CourseTime, Educations.CourseCredential, 
                      Educations.CourseUploadDate, Educations.CoursePrice, Educations.IsActive, Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
                      Educations.CourseEndDate, Educations.CourseStartDate
			FROM         link.CollegeEducations WITH (READPAST, ROWLOCK) INNER JOIN
                      Educations WITH (READPAST, ROWLOCK) ON link.CollegeEducations.EducationID = Educations.EducationID INNER JOIN
                      link.EducationFormatAvailables WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.EducationFormatAvailables.EducationID AND 
                      Educations.EducationID = link.EducationFormatAvailables.EducationID INNER JOIN
                      link.EducationProfessions ON link.EducationProfessions.EducationID = Educations.EducationID INNER JOIN
                      EducationModules WITH (READPAST, ROWLOCK) ON Educations.EducationID = EducationModules.EducationID
			WHERE     (link.EducationFormatAvailables.EducationFormatID = ISNULL(@EducationFormatID, link.EducationFormatAvailables.EducationFormatID)) AND 
                      (link.EducationProfessions.ProfessionID = ISNULL(@ProfessionID, link.EducationProfessions.ProfessionID)) AND (Educations.IsActive <> 0) AND 
                      (link.CollegeEducations.CollegeID = ISNULL(@CollegeID, link.CollegeEducations.CollegeID)) AND (GETDATE() BETWEEN Educations.CourseStartDate AND 
                      Educations.CourseEndDate) AND (Educations.ReadyToDisplay = 1)	AND (isnull(Educations.IsPublished,0)=0) and  (isnull(Educations.IsCoursePreview ,0)=1) 
            
                      	)as hp
	end
	else
	
	begin
	insert into @table(rownumber, EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, 
		CourseUploadDate, CoursePrice, IsActive,
		CouseAllotedDaysMonth,CourseAllotedTime,CourseEndDate,CourseStartDate)
		select ROW_NUMBER() over(ORDER BY CourseUploadDate desc,EducationID desc)as rownumber, * from (
			SELECT DISTINCT 
                      Educations.EducationID, Educations.CourseName, Educations.CourseCode, Educations.CourseDescription, Educations.CourseTime, Educations.CourseCredential, 
                      Educations.CourseUploadDate, Educations.CoursePrice, Educations.IsActive, Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
                      Educations.CourseEndDate, Educations.CourseStartDate
			FROM         link.CollegeEducations WITH (READPAST, ROWLOCK) INNER JOIN
                      Educations WITH (READPAST, ROWLOCK) ON link.CollegeEducations.EducationID = Educations.EducationID INNER JOIN
                      link.EducationFormatAvailables WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.EducationFormatAvailables.EducationID AND 
                      Educations.EducationID = link.EducationFormatAvailables.EducationID INNER JOIN
                      link.EducationProfessions ON link.EducationProfessions.EducationID = Educations.EducationID INNER JOIN
                      EducationModules WITH (READPAST, ROWLOCK) ON Educations.EducationID = EducationModules.EducationID
			WHERE     (link.EducationFormatAvailables.EducationFormatID = ISNULL(@EducationFormatID, link.EducationFormatAvailables.EducationFormatID)) AND 
                      (link.EducationProfessions.ProfessionID = ISNULL(@ProfessionID, link.EducationProfessions.ProfessionID)) AND (Educations.IsActive <> 0) AND 
                      (link.CollegeEducations.CollegeID = ISNULL(@CollegeID, link.CollegeEducations.CollegeID)) AND (GETDATE() BETWEEN Educations.CourseStartDate AND 
                      Educations.CourseEndDate) AND (Educations.ReadyToDisplay = 1)	AND (Educations.IsPublished=1)
            
                      	)as hp
	end
	update @table
	set TotalCount=(select count(*) from @table)
	
	select * from @table
	where rownumber between @skip+1 and (@skip+@take)					  
END



GO
/****** Object:  StoredProcedure [dbo].[Get_EducationByProfessionIDPaged]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: GJain
-- Create date: 11/28/2014
-- Description: GET All Education with ProfessionID
-- Version: 1.0
-- ========================================================================================== 
-- Author By: HSingh
-- Create date: 12/03/2014
-- Description: get unique records.
-- Version: 1.1
-- ===========================================================================================
-- Author By: HSingh
-- Create date: 07/31/2015
-- Description: rename sp and apply paging
-- Version: 1.2
-- ===========================================================================================
-- Author By: GJain
-- Create date: 09/19/2015
-- Description: Show those only those education,for which module exist
-- Version: 1.3
-- ===========================================================================================
-- Author By: GJain
-- Create date: 09/25/2015
-- Description: Show Satrt and end date of education
-- Version: 1.4
-- ===========================================================================================
-- Author By: GJain
-- Create date: 02/04/2016
-- Description: Ispublish condition Add
-- Version: 1.5
-- ===========================================================================================
CREATE PROCEDURE [dbo].[Get_EducationByProfessionIDPaged]
	@ProfessionID int,
	@UserID int = null,
	@skip int,
	@take int
AS
BEGIN
	declare @table as table(
		rownumber int,
		educationID int,
		CourseName varchar(250),
		CourseCode varchar(100),
		CourseDescription varchar(max),
		CourseTime varchar(50),
		CourseCredential bit,
		CourseUploadDate date,
		CoursePrice money,
		IsActive bit,
		TotalCount int,
	    CouseAllotedDaysMonth varchar(10),
		CourseAllotedTime int,
		CourseEndDate datetime,
		CourseStartDate datetime
	)

	declare @IsCourserPreview as bit=0
	
	if(@UserID!=0)
	begin
		set @IsCourserPreview = (SELECT      isnull(IsCoursePreview,0) FROM         Users where UID = @UserID)
	end
	
	if(@IsCourserPreview=1)
	begin


	insert into @table(rownumber, EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, CourseUploadDate, CoursePrice, IsActive,	CouseAllotedDaysMonth,CourseAllotedTime,CourseEndDate,CourseStartDate)
	Select * from(SELECT     ROW_NUMBER() over(ORDER BY Educations.CourseUploadDate DESC, Educations.EducationID DESC)as rownumber,
		Educations.EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, CourseUploadDate, CoursePrice, IsActive,Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
                      Educations.CourseEndDate, Educations.CourseStartDate
		FROM         Educations
		--INNER JOIN
  --                    EducationModules WITH (READPAST, ROWLOCK)  ON Educations.EducationID = EducationModules.EducationID
		WHERE     (IsActive IS NULL OR
							  IsActive = 1) AND (Educations.EducationID IN
								  (SELECT DISTINCT EducationID
									FROM          link.EducationProfessions
									WHERE      (ProfessionID = @ProfessionID) AND (IsActive IS NULL OR
														   IsActive = 1)))
		AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) AND (Educations.IsPublished=1)
		union

		SELECT     ROW_NUMBER() over(ORDER BY Educations.CourseUploadDate DESC, Educations.EducationID DESC)as rownumber,
		Educations.EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, CourseUploadDate, CoursePrice, IsActive,Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
                      Educations.CourseEndDate, Educations.CourseStartDate
		FROM         Educations
		--INNER JOIN
  --                    EducationModules WITH (READPAST, ROWLOCK)  ON Educations.EducationID = EducationModules.EducationID
		WHERE     (IsActive IS NULL OR
							  IsActive = 1) AND (Educations.EducationID IN
								  (SELECT DISTINCT EducationID
									FROM          link.EducationProfessions
									WHERE      (ProfessionID = @ProfessionID) AND (IsActive IS NULL OR
														   IsActive = 1)))
		AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND  (Educations.ReadyToDisplay=1) 	AND (isnull(Educations.IsPublished,0)=0) and  (isnull(IsCoursePreview ,0)=1) )rk

	end		
	else

	begin

		insert into @table(rownumber, EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, CourseUploadDate, CoursePrice, IsActive,	CouseAllotedDaysMonth,CourseAllotedTime,CourseEndDate,CourseStartDate)
		SELECT     ROW_NUMBER() over(ORDER BY Educations.CourseUploadDate DESC, Educations.EducationID DESC)as rownumber,
		Educations.EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, CourseUploadDate, CoursePrice, IsActive,Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
                      Educations.CourseEndDate, Educations.CourseStartDate
		FROM         Educations
		--INNER JOIN
  --                    EducationModules WITH (READPAST, ROWLOCK)  ON Educations.EducationID = EducationModules.EducationID
		WHERE     (IsActive IS NULL OR
							  IsActive = 1) AND (Educations.EducationID IN
								  (SELECT DISTINCT EducationID
									FROM          link.EducationProfessions
									WHERE      (ProfessionID = @ProfessionID) AND (IsActive IS NULL OR
														   IsActive = 1)))
		AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) AND (Educations.IsPublished=1)

	end
	
	update @table
	set TotalCount=(select count(*) from @table)
	
	select * from @table
	where rownumber between @skip+1 and (@skip+@take)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationCollegeByCollegeIDPaged]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 07/16/2014
-- Description: GET All Education with college against collegeID
-- Version: 1.0
-- ================================================================ 
-- Author By: HSingh
-- Create date: 12/03/2014
-- Description: get unique records.
-- Version: 1.1
-- ===========================================================================================
-- Author By: HSingh
-- Create date: 07/31/2015
-- Description: rename sp and apply paging
-- Version: 1.2
-- ===========================================================================================
-- Author By: HSingh
-- Create date: 08/24/2015
-- Description: delete department table link
-- Version: 1.3
-- ===========================================================================================
-- Author By: GJain
-- Create date: 09/19/2015
-- Description: Show those only those education,for which module exist
-- Version: 1.4
-- ===========================================================================================
-- Author By: GJain
-- Create date: 09/25/2015
-- Description: Show Satrt and end date of education
-- Version: 1.5
-- ===========================================================================================
-- Author By: GJain
-- Create date: 02/04/2016
-- Description: Ispublish condition Add
-- Version: 1.6
-- ===========================================================================================
CREATE PROCEDURE [dbo].[Get_EducationCollegeByCollegeIDPaged]
	@CollegeID int=NULL,
		@UserID int=null,
	@skip int,
	@take int
AS
BEGIN
	
	declare @table as table(
		rownumber int,
		educationID int,
		CourseName varchar(250),
		CourseCode varchar(100),
		CourseDescription varchar(max),
		CourseTime varchar(50),
		CourseCredential bit,
		CourseUploadDate date,
		CoursePrice money,
		IsActive bit,
		TotalCount int,
	    CouseAllotedDaysMonth varchar(10),
		CourseAllotedTime int,
		CourseEndDate datetime,
		CourseStartDate datetime
	)


	declare @IsCourserPreview as bit=0
	
	if(@UserID!=0)
	begin
		set @IsCourserPreview = (SELECT      isnull(IsCoursePreview,0) FROM         Users where UID = @UserID)
	end

	if(@IsCourserPreview=1)
		begin

			insert into @table(rownumber, EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, CourseUploadDate, CoursePrice, IsActive,	CouseAllotedDaysMonth,CourseAllotedTime,CourseEndDate,CourseStartDate)
			select ROW_NUMBER() over(ORDER BY CourseUploadDate desc,EducationID desc)as rownumber, * from (	
			SELECT DISTINCT 
						  Educations.EducationID, Educations.CourseName, Educations.CourseCode, Educations.CourseDescription, Educations.CourseTime, Educations.CourseCredential, 
						  Educations.CourseUploadDate, Educations.CoursePrice, Educations.IsActive,Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
						  Educations.CourseEndDate, Educations.CourseStartDate
			FROM         Educations WITH (READPAST, ROWLOCK) INNER JOIN
						  link.CollegeEducations WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.CollegeEducations.EducationID inner join
						  Colleges WITH (READPAST, ROWLOCK) on link.CollegeEducations.CollegeID=Colleges.CollegeID
						  --	INNER JOIN
						  --EducationModules WITH (READPAST, ROWLOCK)  ON Educations.EducationID = EducationModules.EducationID
				WHERE     (Colleges.CollegeID = ISNULL(@CollegeID, Colleges.CollegeID))
				 AND(link.CollegeEducations.IsActive<>0)
				AND(dbo.Educations.IsActive<>0)
				AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) AND (Educations.IsPublished=1)

				union

				SELECT DISTINCT 
						  Educations.EducationID, Educations.CourseName, Educations.CourseCode, Educations.CourseDescription, Educations.CourseTime, Educations.CourseCredential, 
						  Educations.CourseUploadDate, Educations.CoursePrice, Educations.IsActive,Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
						  Educations.CourseEndDate, Educations.CourseStartDate
			FROM         Educations WITH (READPAST, ROWLOCK) INNER JOIN
						  link.CollegeEducations WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.CollegeEducations.EducationID inner join
						  Colleges WITH (READPAST, ROWLOCK) on link.CollegeEducations.CollegeID=Colleges.CollegeID
						  --	INNER JOIN
						  --EducationModules WITH (READPAST, ROWLOCK)  ON Educations.EducationID = EducationModules.EducationID
				WHERE     (Colleges.CollegeID = ISNULL(@CollegeID, Colleges.CollegeID))
				 AND(link.CollegeEducations.IsActive<>0)
				AND(dbo.Educations.IsActive<>0)
				AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate)  AND (Educations.ReadyToDisplay=1) 	AND (isnull(Educations.IsPublished,0)=0) and  (isnull(IsCoursePreview ,0)=1) 

			)as hp
		end
		else
		begin
		insert into @table(rownumber, EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, CourseUploadDate, CoursePrice, IsActive,	CouseAllotedDaysMonth,CourseAllotedTime,CourseEndDate,CourseStartDate)
			select ROW_NUMBER() over(ORDER BY CourseUploadDate desc,EducationID desc)as rownumber, * from (	
			SELECT DISTINCT 
						  Educations.EducationID, Educations.CourseName, Educations.CourseCode, Educations.CourseDescription, Educations.CourseTime, Educations.CourseCredential, 
						  Educations.CourseUploadDate, Educations.CoursePrice, Educations.IsActive,Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
						  Educations.CourseEndDate, Educations.CourseStartDate
			FROM         Educations WITH (READPAST, ROWLOCK) INNER JOIN
						  link.CollegeEducations WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.CollegeEducations.EducationID inner join
						  Colleges WITH (READPAST, ROWLOCK) on link.CollegeEducations.CollegeID=Colleges.CollegeID
						  --	INNER JOIN
						  --EducationModules WITH (READPAST, ROWLOCK)  ON Educations.EducationID = EducationModules.EducationID
				WHERE     (Colleges.CollegeID = ISNULL(@CollegeID, Colleges.CollegeID))
				 AND(link.CollegeEducations.IsActive<>0)
				AND(dbo.Educations.IsActive<>0)
				AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) AND (Educations.IsPublished=1)
				)rk
		end

	update @table
	set TotalCount=(select count(*) from @table)
	
	select * from @table
	where rownumber between @skip+1 and (@skip+@take)	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationCollegeByCollegeOREduFormatIDPaged]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: HSingh
-- Create date: 07/16/2014
-- Description: GET All Education with college against available format and collegeid
-- Version: 1.0
-- ========================================================================================== 
-- Author By: HSingh
-- Create date: 12/03/2014
-- Description: get unique records.
-- Version: 1.1
-- ===========================================================================================
-- Author By: HSingh
-- Create date: 07/31/2015
-- Description: rename sp and apply paging
-- Version: 1.2
-- ===========================================================================================
-- Author By: HSingh
-- Create date: 08/24/2015
-- Description: delete department table link
-- Version: 1.3
-- ===========================================================================================
-- Author By: GJain
-- Create date: 09/19/2015
-- Description: Show those only those education,for which module exist
-- Version: 1.4
-- ===========================================================================================
-- Author By: GJain
-- Create date: 09/25/2015
-- Description: Show Satrt and end date of education
-- Version: 1.5
-- ===========================================================================================
-- Author By: GJain
-- Create date: 02/04/2016
-- Description: Ispublish condition Add
-- Version: 1.6
-- ===========================================================================================
CREATE PROCEDURE [dbo].[Get_EducationCollegeByCollegeOREduFormatIDPaged]
	@CollegeID int=null,
	@EducationFormatID int,
	@UserId int,
	@skip int,
	@take int
AS
BEGIN
	
	declare @table as table(
		rownumber int,
		educationID int,
		CourseName varchar(250),
		CourseCode varchar(100),
		CourseDescription varchar(max),
		CourseTime varchar(50),
		CourseCredential bit,
		CourseUploadDate date,
		CoursePrice money,
		IsActive bit,
		TotalCount int,
		CouseAllotedDaysMonth varchar(10),
		CourseAllotedTime int,
		CourseEndDate datetime,
		CourseStartDate datetime
	)
	declare @IsCourserPreview as bit=0
	
	if(@UserID!=0)
	begin
		set @IsCourserPreview = (SELECT      isnull(IsCoursePreview,0) FROM         Users where UID = @UserID)
	end
	
	if(@IsCourserPreview=1)
	begin
	insert into @table(rownumber, EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, CourseUploadDate, CoursePrice, IsActive,	CouseAllotedDaysMonth,CourseAllotedTime,CourseEndDate,CourseStartDate)
		select ROW_NUMBER() over(ORDER BY CourseUploadDate desc,EducationID desc)as rownumber, * from (
			SELECT DISTINCT 
                      Educations.EducationID, Educations.CourseName, Educations.CourseCode, Educations.CourseDescription, Educations.CourseTime, Educations.CourseCredential, 
                      Educations.CourseUploadDate, Educations.CoursePrice, Educations.IsActive,Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
                      Educations.CourseEndDate, Educations.CourseStartDate
			FROM         Educations WITH (READPAST, ROWLOCK) INNER JOIN
                      link.CollegeEducations WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.CollegeEducations.EducationID INNER JOIN
                      link.EducationFormatAvailables WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.EducationFormatAvailables.EducationID AND 
                      Educations.EducationID = link.EducationFormatAvailables.EducationID INNER JOIN
                      EducationFormats WITH (READPAST, ROWLOCK) ON link.EducationFormatAvailables.EducationFormatID = EducationFormats.EducationFormatID inner join
                      Colleges WITH (READPAST, ROWLOCK) on link.CollegeEducations.CollegeID=Colleges.CollegeID
                      	INNER JOIN
                      EducationModules WITH (READPAST, ROWLOCK)  ON Educations.EducationID = EducationModules.EducationID
			WHERE     (Colleges.CollegeID = ISNULL(@CollegeID, Colleges.CollegeID)) AND (EducationFormats.EducationFormatID = @EducationFormatID) AND (Educations.IsActive <> 0)
			AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) AND (Educations.IsPublished=1)
			union
			SELECT DISTINCT 
                      Educations.EducationID, Educations.CourseName, Educations.CourseCode, Educations.CourseDescription, Educations.CourseTime, Educations.CourseCredential, 
                      Educations.CourseUploadDate, Educations.CoursePrice, Educations.IsActive,Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
                      Educations.CourseEndDate, Educations.CourseStartDate
			FROM         Educations WITH (READPAST, ROWLOCK) INNER JOIN
                      link.CollegeEducations WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.CollegeEducations.EducationID INNER JOIN
                      link.EducationFormatAvailables WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.EducationFormatAvailables.EducationID AND 
                      Educations.EducationID = link.EducationFormatAvailables.EducationID INNER JOIN
                      EducationFormats WITH (READPAST, ROWLOCK) ON link.EducationFormatAvailables.EducationFormatID = EducationFormats.EducationFormatID inner join
                      Colleges WITH (READPAST, ROWLOCK) on link.CollegeEducations.CollegeID=Colleges.CollegeID
                      	INNER JOIN
                      EducationModules WITH (READPAST, ROWLOCK)  ON Educations.EducationID = EducationModules.EducationID
			WHERE     (Colleges.CollegeID = ISNULL(@CollegeID, Colleges.CollegeID)) AND (EducationFormats.EducationFormatID = @EducationFormatID) AND (Educations.IsActive <> 0)
			AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) 	AND (isnull(Educations.IsPublished,0)=0) and  (isnull(IsCoursePreview ,0)=1) 
		
		)as hp


		end

		else

		begin
		insert into @table(rownumber, EducationID, CourseName, CourseCode, CourseDescription, CourseTime, CourseCredential, CourseUploadDate, CoursePrice, IsActive,	CouseAllotedDaysMonth,CourseAllotedTime,CourseEndDate,CourseStartDate)
		select ROW_NUMBER() over(ORDER BY CourseUploadDate desc,EducationID desc)as rownumber, * from (
			SELECT DISTINCT 
                      Educations.EducationID, Educations.CourseName, Educations.CourseCode, Educations.CourseDescription, Educations.CourseTime, Educations.CourseCredential, 
                      Educations.CourseUploadDate, Educations.CoursePrice, Educations.IsActive,Educations.CouseAllotedDaysMonth, Educations.CourseAllotedTime, 
                      Educations.CourseEndDate, Educations.CourseStartDate
			FROM         Educations WITH (READPAST, ROWLOCK) INNER JOIN
                      link.CollegeEducations WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.CollegeEducations.EducationID INNER JOIN
                      link.EducationFormatAvailables WITH (READPAST, ROWLOCK) ON Educations.EducationID = link.EducationFormatAvailables.EducationID AND 
                      Educations.EducationID = link.EducationFormatAvailables.EducationID INNER JOIN
                      EducationFormats WITH (READPAST, ROWLOCK) ON link.EducationFormatAvailables.EducationFormatID = EducationFormats.EducationFormatID inner join
                      Colleges WITH (READPAST, ROWLOCK) on link.CollegeEducations.CollegeID=Colleges.CollegeID
                      	INNER JOIN
                      EducationModules WITH (READPAST, ROWLOCK)  ON Educations.EducationID = EducationModules.EducationID
			WHERE     (Colleges.CollegeID = ISNULL(@CollegeID, Colleges.CollegeID)) AND (EducationFormats.EducationFormatID = @EducationFormatID) AND (Educations.IsActive <> 0)
			AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) AND (Educations.IsPublished=1)

			
		
		
		)as rk
	end

	update @table
	set TotalCount=(select count(*) from @table)
	
	select * from @table
	where rownumber between @skip+1 and (@skip+@take)						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationDetailContentByEducationID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 10/15/2014
-- Description: GET Education Page detail By EducationID
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_EducationDetailContentByEducationID]
(@EducationID int)
AS
BEGIN

	SELECT     epage.EPageID, epage.EducationID, epage.PContent, epage.PDate, Educations.CourseName
	FROM         EducationDetailPages  AS epage  WITH (READPAST, ROWLOCK)  INNER JOIN
						  Educations WITH (READPAST, ROWLOCK)  ON Educations.EducationID = epage.EducationID
	WHERE     (epage.EducationID = @EducationID) AND (Educations.IsActive IS NULL OR Educations.IsActive=1)
                  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationFormatByEducationID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: HSingh
-- Create date: 07/17/2014
-- Description: GET All Education format by against education id
-- Version: 1.0
-- ========================================================================================== 
-- Author By: HSingh
-- Create date: 09/19/2014
-- Description: GET All Education format available detail also.
-- Version: 1.1
-- ========================================================================================== 
CREATE PROCEDURE [dbo].[Get_EducationFormatByEducationID]
	@EducationID int
AS
BEGIN

	SELECT     EducationFormats.EducationFormatID, EducationFormats.EducationFormatType, EducationFormats.EducationPriority, 
						  link.EducationFormatAvailables.EducationAvailableID, link.EducationFormatAvailables.IsActive, link.EducationFormatAvailables.EducationID
	FROM         link.EducationFormatAvailables WITH (READPAST, ROWLOCK) INNER JOIN
						  EducationFormats WITH (READPAST, ROWLOCK) ON link.EducationFormatAvailables.EducationFormatID = EducationFormats.EducationFormatID
	WHERE     (link.EducationFormatAvailables.EducationID = @EducationID) AND (link.EducationFormatAvailables.IsActive <> 0)
	
END	
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationFormatNotAssociateWithEducation]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: HSingh
-- Create date: 08/28/2014
-- Description: GET list of education format not associates with education.
-- Version: 1.0
-- ========================================================================================== 
CREATE PROCEDURE [dbo].[Get_EducationFormatNotAssociateWithEducation]
	@EducationID int
AS
BEGIN

	SELECT     e.*
	FROM         dbo.EducationFormats as e WITH(READPAST,ROWLOCK)
	WHERE     (e.EducationFormatID NOT IN
							  (SELECT     ef.EducationFormatID
								FROM          link.EducationFormatAvailables as ef WITH(READPAST,ROWLOCK)
								WHERE      (ef.EducationID = @EducationID) AND (ef.IsActive=1 OR ef.IsActive is null)))
	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationLatestByUserID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKumar
-- Create date: 09/01/2016
-- Description: getEducation in admin preview course.
-- Version: 1.0
-- ===========================================================================================
-- [dbo].[Get_EducationLatestByUserID] 141
CREATE PROCEDURE [dbo].[Get_EducationLatestByUserID]
	@UserID int
AS
BEGIN
	
	if(( SELECT  count(1) FROM Users where UID = @UserID and isnull(IsCoursePreview,0) = 1) > 0 )
	begin
	select top 5  * from (
		SELECT     *
		FROM         Educations 
		where ( CourseStartDate  <=  getdate()  and   CourseEndDate  >=  getdate() ) and   isnull(IsPublished,0)=1 and 	  isnull(IsCoursePreview,0)=0  
		union
		SELECT     *
		FROM         Educations 
		where ( CourseStartDate  <=  getdate()  and   CourseEndDate  >=  getdate() ) 
		and  isnull(IsCoursePreview,0)=1 )tbl
		order by EducationID desc
	end
	else
	begin
		SELECT     top 5 *
		FROM         Educations 
		where ( CourseStartDate  <=  getdate()  and   CourseEndDate  >=  getdate() ) and  isnull(IsPublished,0)=1 and 	  isnull(IsCoursePreview,0)=0  
		order by EducationID desc
	end
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationNewsSearchByTextPaged]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 09/14/2015
-- Description: User Story #2512: Search Bar
-- Version: 1.0
-- ================================================================ 

-- Get_EducationNewsSearchByTextPaged '',167,0,100
CREATE PROCEDURE [dbo].[Get_EducationNewsSearchByTextPaged]
	@searchText varchar(250)=null,
	@UserID int=null,
	@skip int,
	@take int
AS
BEGIN

	declare @IsCourserPreview as bit=0
	
	if(@UserID!=0)
	begin
		set @IsCourserPreview = (SELECT      isnull(IsCoursePreview,0) FROM         Users where UID = @UserID)
	end
	
	if(@IsCourserPreview=1)
	begin

	 
	select ID,DisplayName, descriptions,NewsType,cdate from
		(
			Select *,ROW_NUMBER()over(order by cdate desc) as rownumber from
			(
				SELECT     EducationID as ID, CourseName as DisplayName, CourseDescription as descriptions,'' as NewsType,CourseStartDate as cdate
				FROM         Educations
				where coursename like '%'+@searchText+'%' and (IsActive=1 or IsActive is null)
				AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) 	AND (isnull(Educations.IsPublished,0)=1)

				union
				 
				SELECT     EducationID as ID, CourseName as DisplayName, CourseDescription as descriptions,'' as NewsType,CourseStartDate as cdate
				FROM         Educations
				where coursename like '%'+@searchText+'%' and (IsActive=1 or IsActive is null)
				AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) 	AND (isnull(Educations.IsPublished,0)=0) and  (isnull(IsCoursePreview ,0)=1) 

				union 
				SELECT     NewsID as id, NewsTitle as DisplayName, NewsDescription as descriptions, NewsType,NewsDate as cdate
				FROM         News 
				where NewsTitle like '%'+@searchText+'%' 
			)as hp 
		)as hp1
		where rownumber between  @skip+1 and (@skip+@take) order by cdate desc
	end

	else

	begin
 
		select ID,DisplayName, descriptions,NewsType,cdate from
		(
			Select *,ROW_NUMBER()over(order by cdate desc) as rownumber from
			(
				SELECT     EducationID as ID, CourseName as DisplayName, CourseDescription as descriptions,'' as NewsType,CourseStartDate as cdate
				FROM         Educations
				where coursename like '%'+@searchText+'%' and (IsActive=1 or IsActive is null)
				AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) 	AND (Educations.IsPublished=1)
				union all
				SELECT     NewsID as id, NewsTitle as DisplayName, NewsDescription as descriptions, NewsType,NewsDate as cdate
				FROM         News 
				where NewsTitle like '%'+@searchText+'%' 
			)as hp 
		)as hp1
		where rownumber between  @skip+1 and (@skip+@take) order by cdate desc
    
    end
	
END


GO
/****** Object:  StoredProcedure [dbo].[Get_EducationNewsSearchByTextPagedCount]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 09/14/2015
-- Description: User Story #2512: Search Bar
-- Version: 1.0
-- ================================================================ 

-- Get_EducationNewsSearchByTextPagedCount '',167
CREATE PROCEDURE [dbo].[Get_EducationNewsSearchByTextPagedCount]
	@searchText varchar(250),
	@UserID int=null 
AS
BEGIN


	declare @IsCourserPreview as bit=0
	
	set @IsCourserPreview = (SELECT      isnull(IsCoursePreview,0) FROM         Users where UID = @UserID)
		if(@IsCourserPreview=1)
	begin
	select count(*) from
		(
			Select * from
			(
				SELECT     EducationID as ID, CourseName as DisplayName, CourseDescription as descriptions,'' as NewsType,CourseStartDate as cdate
				FROM         Educations
				where coursename like '%'+@searchText+'%' and (IsActive=1 or IsActive is null)
				AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) 	AND (isnull(Educations.IsPublished,0)=1)

				union
				 
				SELECT     EducationID as ID, CourseName as DisplayName, CourseDescription as descriptions,'' as NewsType,CourseStartDate as cdate
				FROM         Educations
				where coursename like '%'+@searchText+'%' and (IsActive=1 or IsActive is null)
				AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) 	AND (isnull(Educations.IsPublished,0)=0) and  (isnull(IsCoursePreview ,0)=1) 

				union 
				SELECT     NewsID as id, NewsTitle as DisplayName, NewsDescription as descriptions, NewsType,NewsDate as cdate
				FROM         News 
				where NewsTitle like '%'+@searchText+'%'  

			)as hp 
		)as hp1
		
	end

	else

	begin
		select count(*) from
		(
			Select *  from
			(
				SELECT     EducationID as ID, CourseName as DisplayName, CourseDescription as descriptions,'' as NewsType,CourseStartDate as cdate
				FROM         Educations
				where coursename like '%'+@searchText+'%' and (IsActive=1 or IsActive is null)
				AND (GETDATE() BETWEEN Educations.CourseStartDate AND Educations.CourseEndDate) AND (Educations.ReadyToDisplay=1) 	AND (Educations.IsPublished=1)
				union all
				SELECT     NewsID as id, NewsTitle as DisplayName, NewsDescription as descriptions, NewsType,NewsDate as cdate
				FROM         News 
				where NewsTitle like '%'+@searchText+'%' 
			)as hp 
		)as hp1
 
    
    end
	
END


GO
/****** Object:  StoredProcedure [dbo].[Get_EducationProfessionCount]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: GJain
-- Create date: 05/16/2015
-- Description: GET Eduprofessions Count.
-- Version: 1.0
-- ================================================================ 
CREATE  PROCEDURE [dbo].[Get_EducationProfessionCount]
	AS
BEGIN
	SELECT  COUNT(*)
	FROM         Professions WITH (READPAST, ROWLOCK) INNER JOIN
						  link.EducationProfessions WITH (READPAST, ROWLOCK) ON Professions.ProfessionID = link.EducationProfessions.ProfessionID INNER JOIN
						  Educations ON link.EducationProfessions.EducationID = Educations.EducationID
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationShoppingTemp]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 08/04/2014
-- Description: GET Shoping temp Data by Userid
-- Version: 1.0
-- ================================================================ 
-- Author By: HSingh
-- Create date: 08/03/2014
-- Description: get credential id
-- Version: 1.1
-- ================================================================ 
-- ================================================================ 
-- Author By: GJain
-- Create date: 03/29/2016
-- Description: SHow both Education and Product
-- Version: 1.1
-- ================================================================ 
-- [dbo].[Get_EducationShoppingTemp] 222

CREATE PROCEDURE [dbo].[Get_EducationShoppingTemp]
@UserID int=NULL
AS
BEGIN



	declare @AAPAmount as money=0
	Declare @Date as datetime
	
	--SELECT     top 1  @AAPAmount= AllAccessPassPricing, @Date = CreatedOn FROM UserSubscriptions  where CreatedBy = @UserID order by 1 desc
	
	SELECT     top 1  @AAPAmount= AllAccessPassPricing, @Date = CreatedOn FROM UserSubscriptions  order by UserSubscriptionID desc


	SELECT		temp.EducationShoppingTempID as TempID, temp.UserID, temp.Quantity, temp.CoupanID,
				isnull((SELECT     (case when (DiscountCoupons.CouponType = 'Percent') then  (EducationShoppingTemps.Amount * (DiscountCoupons.CouponDiscount / 100 )) else DiscountCoupons.CouponDiscount end) 
	FROM        EducationShoppingTemps INNER JOIN
                DiscountCoupons ON EducationShoppingTemps.CoupanID = DiscountCoupons.CouponID AND 
                EducationShoppingTemps.EducationID = DiscountCoupons.CouponEducationID
	where		CoupanID = temp.CoupanID),0) as DiscountAmount ,
				temp.Amount, temp.Date, edu.CourseName as PName, EducationTypes.EducationType as PType, 
                eduTypeAvailable.Price as Price, temp.EducationID as EduorProID, temp.CredentialID,'Course' as CartType,EducationTypes.EducationTypeID ,temp.TaxPercentage
	FROM        EducationTypes WITH (READPAST, ROWLOCK) INNER JOIN
                link.EducationTypesAvailables AS eduTypeAvailable WITH (READPAST, ROWLOCK) ON 
                EducationTypes.EducationTypeID = eduTypeAvailable.EducationTypeID INNER JOIN
                EducationShoppingTemps AS temp WITH (READPAST, ROWLOCK) INNER JOIN
                Educations AS edu WITH (READPAST, ROWLOCK) ON edu.EducationID = temp.EducationID ON eduTypeAvailable.EducationTypeID = temp.EducationTypeID AND 
                eduTypeAvailable.EducationID = temp.EducationID
	WHERE		(temp.UserID = @UserID)	
	
	UNION
	
	SELECT		ProductShoppingTemps.ProductShoppingTempID as TempID, ProductShoppingTemps.UserID, ProductShoppingTemps.Quantity, 
				ProductShoppingTemps.CoupanID,0 as DiscountAmount, ProductShoppingTemps.Amount, ProductShoppingTemps.Date, Products.ProductName as PName, Products.ProductType as PType, Products.ProductPrice as Price, 
				ProductShoppingTemps.ProductID as EduorProID,Null as CredentialID,'Product' as CartType,0 as EducationTypeID ,ProductShoppingTemps.TaxPercentage
	FROM		ProductShoppingTemps INNER JOIN
				Products ON ProductShoppingTemps.ProductID = Products.ProductID INNER JOIN
                Users ON ProductShoppingTemps.UserID = Users.UID 	WHERE     (ProductShoppingTemps.UserID = @UserID)
   	UNION
   			
	SELECT		0 as  TempID , @UserID as UserID, 1 as Quantity, UserAllAccessPasses.AAPCouponID as CoupanID,
				isnull( (SELECT     (CASE WHEN (DiscountCoupons.CouponType = 'Percent') THEN (@AAPAmount * (DiscountCoupons.CouponDiscount / 100)) 
                ELSE DiscountCoupons.CouponDiscount END) AS Expr1
	FROM		UserAllAccessPasses AS u1 INNER JOIN
                DiscountCoupons ON u1.AAPCouponID = DiscountCoupons.CouponID AND u1.AAPCouponID = DiscountCoupons.CouponID),0) as DiscountAmount,
				@AAPAmount as Amount, @Date as Date,'All Access Pass' as Pname,'AllAccessPass' as PType,@AAPAmount as Price,
				0 as EduorProID,  0 as CredentialID,'AllAccessPass' as CartType,0 as EducationTypeID,0 as TaxPercentage
	FROM         Users LEFT OUTER JOIN
                      UserAllAccessPasses ON Users.UserAllAccessPassID = UserAllAccessPasses.UserAllAccessPassID
	WHERE     (Users.UID = @UserID) AND (ISNULL(Users.IsAllAccessPricing, 0) = 1) AND (ISNULL(Users.UserAllAccessPassID, 0) = 0)
   	 
   	 
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EducationShoppingTempByShippingPaymentID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: rkumar
-- Create date: 16/06/2016
-- Description: Get Education Shopping Temp By ShippingPaymentID
-- Version: 1.0
-- ================================================================ 
 
-- [dbo].[Get_EducationShoppingTempByShippingPaymentID] 95

CREATE PROCEDURE [dbo].[Get_EducationShoppingTempByShippingPaymentID]
@ShippingPaymentID int = NULL
AS
BEGIN

	declare @UserID as int =0 
	
	--if( (SELECT     COUNT(1) FROM         EducationShoppingTemps where ShippingPaymentID = @ShippingPaymentID)>0)
	--	begin
	--		set @UserID = (SELECT	top 1 UserID  FROM EducationShoppingTemps where ShippingPaymentID = @ShippingPaymentID)	
	--	end
	--else
	--	begin
	--		set @UserID = (SELECT   top 1 UserID  FROM ProductShoppingTemps where ShippingPaymentID = @ShippingPaymentID)
	--	end
		
		set @UserID = (SELECT   top 1 UserID  FROM ShippingPayments where ShippingPaymentID = @ShippingPaymentID)
		
	declare @AAPAmount as money=0
	Declare @Date as datetime
	
		--SELECT		top 1  @AAPAmount= AllAccessPassPricing, @Date = CreatedOn FROM         UserSubscriptions  where CreatedBy = @UserID order by 1 desc
		
		SELECT     top 1  @AAPAmount= AllAccessPassPricing, @Date = CreatedOn FROM UserSubscriptions  order by UserSubscriptionID desc
select * from (
		SELECT		temp.EducationShoppingTempID as TempID, temp.UserID, temp.Quantity, temp.CoupanID,
					isnull((SELECT	(case when (DiscountCoupons.CouponType = 'Percent') then  (EducationShoppingTemps.Amount * (DiscountCoupons.CouponDiscount / 100 )) else DiscountCoupons.CouponDiscount end) 
					FROM EducationShoppingTemps INNER JOIN
					DiscountCoupons ON EducationShoppingTemps.CoupanID = DiscountCoupons.CouponID AND 
					EducationShoppingTemps.EducationID = DiscountCoupons.CouponEducationID
					where CoupanID = temp.CoupanID),0) as DiscountAmount ,
					temp.Amount, temp.Date, edu.CourseName as PName, EducationTypes.EducationType as PType, 
					eduTypeAvailable.Price as Price, temp.EducationID as EduorProID, temp.CredentialID,'Course' as CartType,EducationTypes.EducationTypeID ,@ShippingPaymentID as ShippingPaymentID ,isnull(temp.TaxPercentage,0) as TaxPercentage

		FROM	    EducationTypes WITH (READPAST, ROWLOCK) INNER JOIN
					link.EducationTypesAvailables AS eduTypeAvailable WITH (READPAST, ROWLOCK) ON 
					EducationTypes.EducationTypeID = eduTypeAvailable.EducationTypeID INNER JOIN
					EducationShoppingTemps AS temp WITH (READPAST, ROWLOCK) INNER JOIN
                    Educations AS edu WITH (READPAST, ROWLOCK) ON edu.EducationID = temp.EducationID ON eduTypeAvailable.EducationTypeID = temp.EducationTypeID AND 
                    eduTypeAvailable.EducationID = temp.EducationID
		WHERE		(temp.ShippingPaymentID = @ShippingPaymentID)	
	Union
		SELECT		ProductShoppingTemps.ProductShoppingTempID as TempID, ProductShoppingTemps.UserID, ProductShoppingTemps.Quantity, 
					ProductShoppingTemps.CoupanID,0 as DiscountAmount, ProductShoppingTemps.Amount, ProductShoppingTemps.Date, Products.ProductName as PName, Products.ProductType as PType, Products.ProductPrice as Price, 
					ProductShoppingTemps.ProductID as EduorProID,Null as CredentialID,'Product' as CartType,0 as EducationTypeID ,@ShippingPaymentID as ShippingPaymentID , isnull(ProductShoppingTemps.TaxPercentage,0) as TaxPercentage  

		FROM        ProductShoppingTemps INNER JOIN
					Products ON ProductShoppingTemps.ProductID = Products.ProductID INNER JOIN
                    Users ON ProductShoppingTemps.UserID = Users.UID 	WHERE     (ProductShoppingTemps.ShippingPaymentID = @ShippingPaymentID)
	Union
	 
			SELECT	0 as  TempID , @UserID as UserID, 1 as Quantity, UserAllAccessPasses.AAPCouponID as CoupanID,
					isnull( (SELECT     (CASE WHEN (DiscountCoupons.CouponType = 'Percent') THEN (@AAPAmount * (DiscountCoupons.CouponDiscount / 100)) 
					ELSE DiscountCoupons.CouponDiscount END) AS Expr1
					FROM	UserAllAccessPasses AS u1 INNER JOIN
							DiscountCoupons ON u1.AAPCouponID = DiscountCoupons.CouponID AND u1.AAPCouponID = DiscountCoupons.CouponID),0) as DiscountAmount,
							@AAPAmount as Amount, @Date as Date,'All Access Pass' as Pname,'AllAccessPass' as PType,@AAPAmount as Price,
							0 as EduorProID,  0 as CredentialID,'AllAccessPass' as CartType,0 as EducationTypeID, @ShippingPaymentID as ShippingPaymentID , 0 as TaxPercentage  
			FROM    Users LEFT OUTER JOIN
					UserAllAccessPasses ON Users.UserAllAccessPassID = UserAllAccessPasses.UserAllAccessPassID
			WHERE     (Users.UID = @UserID) AND (ISNULL(Users.IsAllAccessPricing, 0) = 1) AND (ISNULL(Users.UserAllAccessPassID, 0) = 0)) tbl
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EvaluationQuestionsByEducationID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 06/22/2015
-- Description: GET All Evaluation Question By EducationID
-- Version: 1.0
-- Update By: GJain
-- Create date: 08/20/2015
-- Description: updated to get only active
-- Version: 1.0
-- ================================================================ 
---[dbo].[Get_EvaluationQuestionsByEducationID]
CREATE PROCEDURE [dbo].[Get_EvaluationQuestionsByEducationID]
(
@EducationID int
)
AS
BEGIN             
                 SELECT     EduEQues.CourseEvaluationID, EduEQues.EvaluationID, EduEQues.EducationID, EQues.EvaluationQues, EQues.EvaluationQuestionID,Edu.CourseName
FROM         link.EducationEvaluations AS EduEQues INNER JOIN
                      EvaluationQuestions AS EQues WITH (READPAST, ROWLOCK) ON EQues.EvaluationID = EduEQues.EvaluationID
                      INNER JOIN
                      Educations AS Edu WITH (READPAST, ROWLOCK) ON Edu.EducationID = EduEQues.EducationID
WHERE     (EduEQues.EducationID = @EducationID) and EduEQues.IsActive=1 and EQues.IsStatus = 1
END


GO
/****** Object:  StoredProcedure [dbo].[Get_EventsAllPaged]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 08/12/2015
-- Description: GET All events
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_EventsAllPaged]
	@skip int,
	@take int
AS
BEGIN

	Select *
	from
	(
		SELECT   ROW_NUMBER() over(Order by Events.EventID desc)as rownumber, Events.EventID, Events.EventName, Events.EventDate, Events.EventDescription, Events.NewsID, Events.EducationID, Educations.CourseName, 
                      News.NewsTitle
		FROM         Events LEFT OUTER JOIN
                      News ON Events.NewsID = News.NewsID LEFT OUTER JOIN
                      Educations ON Events.EducationID = Educations.EducationID
	)as hp
	where rownumber between @skip+1 and (@skip+@take)
	order by rownumber 	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EventsByEventDateRange]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 08/12/2015
-- Description: GET All events
-- Version: 1.0
-- ================================================================ 
Create PROCEDURE [dbo].[Get_EventsByEventDateRange]
	@starDate datetime,
	@endate datetime
AS
BEGIN

	SELECT     e.EventID, e.EventName, e.EventDate, e.EventDescription, e.NewsID, e.EducationID, ed.CourseName, n.NewsTitle, n.NewsType, ed.CourseStartDate, 
						  ed.CoursePresenterName, ed.CourseLocation, ed.CourseStartTime
	FROM         Events AS e with(READPAST,ROWLOCK) LEFT OUTER JOIN
						  News AS n with(READPAST,ROWLOCK) ON e.NewsID = n.NewsID LEFT OUTER JOIN
						  Educations AS ed with(READPAST,ROWLOCK) ON e.EducationID = ed.EducationID
	WHERE     (e.NewsID IS NOT NULL) AND (e.EventDate BETWEEN @starDate AND @endate) OR
						  (e.EventDate BETWEEN @starDate AND @endate) AND (e.EducationID IS NOT NULL)
	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_EventsUpcoming]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 08/20/2015
-- Description: GET upcoming events
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_EventsUpcoming]
AS
BEGIN

	SELECT     TOP (3) e.EventID, e.EventName, e.EventDate, e.EventDescription, e.NewsID, e.EducationID, ed.CourseName, n.NewsTitle, n.NewsType, ed.CourseStartDate, 
						  ed.CoursePresenterName, ed.CourseLocation, ed.CourseStartTime
	FROM         Events AS e WITH (READPAST, ROWLOCK) LEFT OUTER JOIN
						  News AS n WITH (READPAST, ROWLOCK) ON e.NewsID = n.NewsID LEFT OUTER JOIN
						  Educations AS ed WITH (READPAST, ROWLOCK) ON e.EducationID = ed.EducationID
	WHERE     (e.NewsID IS NOT NULL) AND (e.EventDate >= GETDATE()) OR
						  (e.EventDate >= GETDATE()) AND (e.EducationID IS NOT NULL)
	ORDER BY e.EventDate
	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_ExamQuestionsByEducationID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 06/21/2015
-- Description: GET All Exam Question By EducationID
-- Version: 1.0
-- ================================================================ 
-- Update By: GJain
-- Create date: 08/20/2015
-- Description: updated to get only active
-- Version: 1.1
-- ================================================================ 
-- Create date: 08/28/2015
-- Description: updated to add exam answer type
-- Version: 1.2
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_ExamQuestionsByEducationID]
(
@EducationID int
)
AS
BEGIN
	SELECT     EduEQues.EducationID, EQues.ExamID, EQues.ExamQuestionID, EQues.ExamQues, EQues.ExamOptionA, EQues.ExamOptionB, EQues.ExamOptionC, 
						  EQues.ExamOptionD, EQues.ExamAnswer, EQues.ExamAnswerType, EQues.ExamAnswerTrueFalse
	FROM         link.EducationExamQuestions AS EduEQues WITH (READPAST, ROWLOCK) INNER JOIN
						  ExamQuestions AS EQues WITH (READPAST, ROWLOCK) ON EQues.ExamID = EduEQues.ExamID
	WHERE     (EduEQues.EducationID = @EducationID) AND (EduEQues.IsActive = 1)
END
GO
/****** Object:  StoredProcedure [dbo].[Get_ExamQuestionWrongAnswered]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: HSingh
-- Create date: 08/04/2015
-- Description: Task #2477 ( Modified): Exam Results - Incorrect Answer
-- Version: 1.0
-- ========================================================================================== 
-- Author By: HSingh
-- Create date: 08/28/2015
-- Description: User Story #2499: Pre Test - Exam Update Question Answer Type
-- Version: 1.1
-- ========================================================================================== 

CREATE PROCEDURE [dbo].[Get_ExamQuestionWrongAnswered]
	@MEID int
AS
BEGIN
	
	SELECT     ExamQuestions.ExamQuestionID, ExamQuestions.ExamID, ExamQuestions.ExamQues, ExamQuestions.ExamOptionA, ExamQuestions.ExamOptionB, 
						  ExamQuestions.ExamOptionC, ExamQuestions.ExamOptionD, ExamQuestions.ExamAnswer,ExamQuestions.ExamAnswerTrueFalse,ExamQuestions.ExamAnswerType
	FROM         ExamQuestionResults INNER JOIN
						  ExamQuestions ON ExamQuestionResults.ExamQuestionID = ExamQuestions.ExamQuestionID AND 
						  (ExamQuestionResults.ExamAnswer <> ExamQuestions.ExamAnswer OR 
						  ExamQuestionResults.ExamAnswerTrueFalse <> ExamQuestions.ExamAnswerTrueFalse) INNER JOIN
							  (SELECT     TOP (1) ExamResultID, UID, IsPass, MEID
								FROM          ExamResults
								WHERE      (MEID = @MEID)
								ORDER BY ExamResultID DESC) AS hp ON hp.ExamResultID = ExamQuestionResults.ExamResultID


END
GO
/****** Object:  StoredProcedure [dbo].[Get_FAQAll]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 10/31/2014
-- Description: GET All FAQ 
-- Version: 1.0
-- ================================================================ 
CREATE  PROCEDURE [dbo].[Get_FAQAll]
	
AS
BEGIN
SELECT     FAQs.FAQID, FAQs.FAQCatID, FAQs.FAQues, FAQs.FAQAns, FAQCategories.FAQCategoryTitle
FROM         FAQs INNER JOIN
                      FAQCategories ON FAQCategories.FAQCatID = FAQs.FAQCatID


						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_FAQByFaqCatIDAll]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 10/31/2014
-- Description: GET All FAQ By FAQCATID
-- Version: 1.0
-- ================================================================ 
CREATE  PROCEDURE [dbo].[Get_FAQByFaqCatIDAll]
	@FAQCatID int
AS
BEGIN
SELECT     FAQs.FAQID, FAQs.FAQCatID, FAQs.FAQues, FAQs.FAQAns, FAQCategories.FAQCategoryTitle
FROM         FAQs INNER JOIN
                      FAQCategories ON FAQCategories.FAQCatID = FAQs.FAQCatID
WHERE     (FAQs.FAQCatID = @FAQCatID)

						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_LogSessionByUserName]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 10/23/2015
-- Description: GET All LogSession 
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_LogSessionByUserName] 
@username varchar(50),
	@skip int,
	@take int
AS

	BEGIN
	 WITH LogSession AS
   ( 
		SELECT ROW_NUMBER() over (Order by LogSessions.LogSessionID desc)as rownumber,LogSessions.LogSessionID, LogSessions.SessionId, LogSessions.UserId, LogSessions.PageUrl, LogSessions.Browser, LogSessions.MEID, 
                      LogSessions.LogCreatedDate,  Educations.CourseName,
                       Users.FirstName,
                       Users.LastName,
                       Users.EmailID	
   FROM       LogSessions
   INNER JOIN Users ON LogSessions.UserID = Users.UID
   INNER JOIN MyEducations on LogSessions.MEID = MyEducations.MEID
    INNER JOIN  Educations ON MyEducations.EducationID = Educations.EducationID
    where Users.EmailID like @username +'%'
	)
	SELECT * FROM LogSession
	where rownumber between @skip+1 and (@skip+@take) 

	
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[Get_LogSessionByUserNameCount]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 10/23/2015
-- Description: GET All LogSession Count
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_LogSessionByUserNameCount]
@username varchar(50)
AS

	BEGIN
	Select COUNT(*) as TotalCount
	from
	(
		SELECT ROW_NUMBER() over (Order by LogSessions.LogSessionID )as rownumber,Users.EmailID
   FROM       LogSessions
   INNER JOIN Users ON LogSessions.UserID = Users.UID
	)as rs
	where  EmailID like @username +'%'
END

GO
/****** Object:  StoredProcedure [dbo].[Get_MyEducationCompletedByUserIDPaged]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 21/10/2014
-- Description: GET All MYEducation Completed with USERID
-- Version: 1.0
-- ================================================================ 
-- Revision History:
-- 1.1 : HSingh: 07/02/2015
-- Description: Get course completed date
-- ================================================================ 
-- 1.2: HSingh: 08/01/2015
-- Description: apply paging and rename procedure
-- ================================================================ 
-- 1.3: Gjain: 09/19/2015
-- Description: Expiry Date Added
-- ================================================================ 
-- 1.4: TGosain: 01/22/2015
-- Description: Added Allow Revisit Date with a 90 days case(#2666). 
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_MyEducationCompletedByUserIDPaged]
	@userID int,
	@skip int,
	@take int
AS
BEGIN
	Select (TotalModuleCompleted*100/TotalModule) as percentCompleted, EducationID, EducationTypeID, Completed, TotalModuleCompleted, TotalModule,CourseCompletedDate,(TotalModuleCompleted*100/TotalModule) as percentCompleted,CourseName,IsPassed,Expired,MEID,
	CertificatePrinted,CertificateURL,ExpiryDate,AllowRevisit
	from
	(
			SELECT ROW_NUMBER() over (Order by MyEducations.CompletedDate desc)as rownumber, MyEducations.MEID, MyEducations.UserID, MyEducations.EducationID, MyEducations.EducationTypeID, MyEducations.Completed, 
                      SUM(CASE WHEN MyEducationModules.Completed = 1 THEN 1 ELSE 0 END) AS TotalModuleCompleted, COUNT(MyEducations.MEID) AS TotalModule, 
                      CONVERT(datetime, convert(varchar(10),MyEducations.CompletedDate,101)) as 'CourseCompletedDate',Educations.CourseName,MyEducations.IsPassed,MyEducations.Expired,
                      MyEducations.CertificatePrinted,MyEducations.CertificateURL
                      , (CASE WHEN Educations.CouseAllotedDaysMonth = 'Days' THEN DATEADD(DD, Educations.CourseAllotedTime, MyEducations.PurchaseDate)
						ELSE DATEADD(MM, Educations.CourseAllotedTime, MyEducations.PurchaseDate) END) AS 'ExpiryDate'
					, case when ((select CompletedDate from MyEducations Myedu where MEID = MyEducations.MEID) is null) then isnull(AllowRevisit,'false') 
					  else (Case when (DATEDIFF(DAY, (select CompletedDate from MyEducations Myedu where MEID = MyEducations.MEID), GETDATE())) >= 90 then 'false' 
							else isnull(AllowRevisit,'false')end) end AllowRevisit
		FROM         MyEducations WITH (READPAST, ROWLOCK) INNER JOIN
							  Educations WITH (READPAST, ROWLOCK) ON Educations.EducationID = MyEducations.EducationID INNER JOIN
							  MyEducationModules WITH (READPAST, ROWLOCK) ON MyEducationModules.MEID = MyEducations.MEID
		WHERE     (MyEducations.UserID = @userID) AND (MyEducations.Completed = 1 or MyEducations.Expired = 1)
		GROUP BY MyEducations.MEID, MyEducations.UserID, MyEducations.EducationID, MyEducations.EducationTypeID, MyEducations.Completed,Educations.CourseAllotedTime,
			Educations.CouseAllotedDaysMonth,MyEducations.PurchaseDate, MyEducations.CompletedDate,Educations.CourseName,MyEducations.IsPassed,MyEducations.Expired
			,MyEducations.CertificatePrinted,MyEducations.CertificateURL, Educations.AllowRevisit
	)as gj
	where rownumber between @skip+1 and (@skip+@take)
END
GO
/****** Object:  StoredProcedure [dbo].[Get_MyEducationDetailByUserIDPaged]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 11/09/2015
-- Description: GET All MYEducation with USERID
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_MyEducationDetailByUserIDPaged] 246,0,25
CREATE PROCEDURE [dbo].[Get_MyEducationDetailByUserIDPaged]
	@userID int,
	@skip int,
	@take int
AS
BEGIN

select CourseName ,Price,PurchaseDate,UserAllAccessPassID from (
select ROW_NUMBER() over (Order by PurchaseDate desc)as rownumber,* from (
		
SELECT     Products.ProductName as CourseName, ProductShoppings.Date as PurchaseDate, ProductShoppings.ProductShoppingID as EducationShoppingID, ProductShoppings.Grandtotal as Price, 0 as UserAllAccessPassID
FROM         Products INNER JOIN
                      ProductShoppings ON Products.ProductID = ProductShoppings.ProductID where UserID=@userID                      
                      union
   SELECT     Educations.CourseName, EducationShoppings.Date as PurchaseDate, EducationShoppings.EducationShoppingID, EducationShoppings.Grandtotal as Price, isnull(UserAllAccessPassID,0) as UserAllAccessPassID
FROM         Educations INNER JOIN
                      EducationShoppings ON Educations.EducationID = EducationShoppings.EducationID  where UserID=@userID
                      union
	SELECT     'All ACCESS' AS CourseName, UserAllAccessPasses.AllAccessStartDate AS PurchaseDate, 0 AS EducationShoppingID, 
                      UserSubscriptions.AllAccessPassPricing AS Price ,UserAllAccessPassID
FROM         UserAllAccessPasses INNER JOIN
                      UserSubscriptions ON UserAllAccessPasses.UserSubscriptionID = UserSubscriptions.UserSubscriptionID
where UserAllAccessPasses.UserID = @userID  -- and  AllAccessEndDate >= getdate()
                      ) as eduPro     
) as ProEdu where rownumber between @skip+1 and (@skip+@take)  
	 
	
END



 
GO
/****** Object:  StoredProcedure [dbo].[Get_MyEducationDetailByUserIDPagedCOUNT]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: MONIKA KHURANA
-- Create date: 16/AUG/2016
-- Description: GET All MYEducation with USERID COUNT
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_MyEducationDetailByUserIDPagedCOUNT]  246 
CREATE PROCEDURE [dbo].[Get_MyEducationDetailByUserIDPagedCOUNT]
	@userID int
AS
BEGIN

select COUNT(*) AS TotalCount from (
select ROW_NUMBER() over (Order by PurchaseDate desc)as rownumber,* from (
		
SELECT     Products.ProductName as CourseName, ProductShoppings.Date as PurchaseDate, ProductShoppings.ProductShoppingID as EducationShoppingID, ProductShoppings.Grandtotal as Price, 0 as UserAllAccessPassID
FROM         Products INNER JOIN
                      ProductShoppings ON Products.ProductID = ProductShoppings.ProductID where UserID=@userID                      
                      union
   SELECT     Educations.CourseName, EducationShoppings.Date as PurchaseDate, EducationShoppings.EducationShoppingID, EducationShoppings.Grandtotal as Price, UserAllAccessPassID 
FROM         Educations INNER JOIN
                      EducationShoppings ON Educations.EducationID = EducationShoppings.EducationID  where UserID=@userID
                      union
	SELECT     'All ACCESS' AS CourseName, UserAllAccessPasses.AllAccessStartDate AS PurchaseDate, 0 AS EducationShoppingID, 
                      UserSubscriptions.AllAccessPassPricing AS Price ,UserAllAccessPassID
	FROM         UserAllAccessPasses INNER JOIN
						  UserSubscriptions ON UserAllAccessPasses.UserSubscriptionID = UserSubscriptions.UserSubscriptionID
	where UserAllAccessPasses.UserID = @userID  --and  AllAccessEndDate >= getdate()
                      ) as eduPro     
) as ProEdu 
	 
	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_MyEducationInProgressByUserIDPaged]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- 1.0: Gjain: 10/21/2014
-- Description: GET All MYEducation In Progress with USERID
-- ================================================================ 
-- 1.1: HSingh: 06/03/2015
-- Description: alter to get course file
-- ================================================================ 
-- 1.2: HSingh: 09/11/2015
-- Description: apply paging and rename procedure
-- ================================================================ 
-- 1.3: HSingh: 09/17/2015
-- Description: get expiry date
-- ================================================================ 
-- 1.4: TGosain: 01/22/2015
-- Description: Added Allow Revisit Date with a 90 days case(#2666). 
-- ================================================================ 
-- [dbo].[Get_MyEducationInProgressByUserIDPaged] 227,0,100
CREATE PROCEDURE [dbo].[Get_MyEducationInProgressByUserIDPaged]
	@userID int,
	@skip int,
	@take int
AS
BEGIN
	Select *,(TotalModuleCompleted*100/TotalModule) as percentCompleted from
	(
			SELECT    ROW_NUMBER() over (Order by MyEdu.MEID desc)as rownumber,MyEdu.MEID, MyEdu.UserID, MyEdu.EducationID, MyEdu.EducationTypeID, MyEdu.Completed, 
                      SUM(CASE WHEN MyEducationModules.Completed = 1 THEN 1 ELSE 0 END) AS TotalModuleCompleted, COUNT(MyEdu.MEID) AS TotalModule, 
                      Educations.CourseFile,Educations.CourseName,MyEdu.IsPassed,MyEdu.Expired,
                      (CASE WHEN Educations.CouseAllotedDaysMonth = 'Days' THEN DATEADD(DD, Educations.CourseAllotedTime, MyEdu.PurchaseDate)
						ELSE DATEADD(MM, Educations.CourseAllotedTime, MyEdu.PurchaseDate) END) AS 'ExpiryDate'					
					, case when ((select CompletedDate from MyEducations where MEID = MyEdu.MEID) is null) then isnull(AllowRevisit,'false') 
					  else (Case when (DATEDIFF(DAY, (select CompletedDate from MyEducations where MEID = MyEdu.MEID), GETDATE())) >= 90 then 'false' 
							else isnull(AllowRevisit,'false')end) end AllowRevisit					
							
		FROM         MyEducations as MyEdu WITH (READPAST, ROWLOCK) INNER JOIN
							  Educations WITH (READPAST, ROWLOCK) ON Educations.EducationID = MyEdu.EducationID INNER JOIN
							  MyEducationModules WITH (READPAST, ROWLOCK) ON MyEducationModules.MEID = MyEdu.MEID
							 WHERE     (MyEdu.UserID = @userID) AND (MyEdu.Completed = 0) and (MyEdu.Expired is null or  MyEdu.Expired=0)
		GROUP BY MyEdu.MEID, MyEdu.UserID, MyEdu.EducationID, MyEdu.EducationTypeID, MyEdu.Completed, 
							  Educations.CourseFile,Educations.CourseName,MyEdu.IsPassed,MyEdu.Expired,MyEdu.purchasedate,
							  Educations.CouseAllotedDaysMonth,Educations.CourseAllotedTime,MyEdu.CompletedDate,Educations.AllowRevisit							  							  
	)as gj
    where rownumber between @skip+1 and (@skip+@take)
    
END
GO
/****** Object:  StoredProcedure [dbo].[Get_MyEducationModulesDetailByMEMID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--===============================================================================
-- Author By: HSingh
-- Create date: 28/10/2014
-- Description: GET MYEducation modules details with myeducationmoduleID
-- Version: 1.0
--===============================================================================
-- History: - 
-- Create date: 01/12/2015 : HSingh
-- Description: get timeLeft field from myeducatoinmodules table
-- Version: 1.1

-- Create date: 11/26/2015 : TGosain
-- Description: Course File field added for download button in module media page
-- Version: 1.2
-- ==============================================================================
-- [dbo].[Get_MyEducationModulesDetailByMEMID] 933
CREATE PROCEDURE [dbo].[Get_MyEducationModulesDetailByMEMID]
	@MEMID int
AS
BEGIN

	SELECT    CONVERT(INT, ROW_NUMBER() OVER(ORDER BY MEMID)) AS EducationModulePosition, EducationModules.EducationModuleDescription, EducationModules.EducationModuleName, EducationModules.EducationID, EducationModules.EducationModuleID, 
						  FileTypes.FileTypeName, EducationModuleFiles.ModuleFile, MyEducationModules.Completed, MyEducationModules.MEMID, Educations.CourseName, Educations.CourseFile,
						  MyEducations.MEID,MyEducationModules.TimeLeft,Educations.IsTimerRequired
	FROM         MyEducationModules WITH (READPAST, ROWLOCK) INNER JOIN
						  EducationModules WITH (READPAST, ROWLOCK) ON MyEducationModules.EducationModuleID = EducationModules.EducationModuleID INNER JOIN
						  EducationModuleFiles WITH (READPAST, ROWLOCK) ON EducationModules.EducationModuleID = EducationModuleFiles.EducationModuleID INNER JOIN
						  MyEducations WITH (READPAST, ROWLOCK) ON MyEducationModules.MEID = MyEducations.MEID INNER JOIN
						  FileTypes WITH (READPAST, ROWLOCK) ON EducationModuleFiles.FileTypeID = FileTypes.FileTypeID INNER JOIN
						  Educations WITH (READPAST, ROWLOCK) ON EducationModules.EducationID = Educations.EducationID AND MyEducations.EducationID = Educations.EducationID
	WHERE     (MyEducationModules.MEMID = @MEMID) and EducationModuleFiles.FileTypeID <> 4

END
GO
/****** Object:  StoredProcedure [dbo].[Get_MyEducationModulesDetailsByMEID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--===============================================================================
-- Author By: HSingh
-- Create date: 28/10/2014
-- Description: GET All MYEducation modules details with my education id and user id
-- Version: 1.0
--===============================================================================
-- Author By: HSingh
-- Create date: 01/12/2015
-- Description: get timeLeft field from myeducatoinmodules table
-- Version: 1.1
-- ==============================================================================
-- Author By: HSingh
-- Create date: 09/04/2015
-- Description: get EducationModuleTime field from educatoinmodules table
-- Version: 1.2
-- ==============================================================================
-- Author By: HSingh
-- Create date: 09/25/2015
-- Description: get exiry days left
-- Version: 1.3
-- ==============================================================================
-- Author By: RKumar
-- Create date: 01/25/2016
-- Description: Add FileType ID check in where condition
-- Version: 1.4
-- ==============================================================================
-- [dbo].[Get_MyEducationModulesDetailsByMEID] 933,166
CREATE PROCEDURE [dbo].[Get_MyEducationModulesDetailsByMEID]
	@MEID int,
	@UserID int
AS
BEGIN
	SELECT   CONVERT(INT, ROW_NUMBER() OVER(ORDER BY MEMID)) AS EducationModulePosition,  Educations.CourseName, EducationModules.EducationModuleDescription, EducationModules.EducationModuleName, EducationModules.EducationID, 
						  EducationModules.EducationModuleID, FileTypes.FileTypeName, MyEducationModules.Completed, 
						  MyEducationModules.CompletedDate, MyEducationModules.MEMID, MyEducations.MEID, 
						  --EducationModuleFiles.ModuleFile,
						  null as ModuleFile,
						  MyEducationModules.TimeLeft,EducationModules.EducationModuleTime,
						  datediff(dd,getdate(),(CASE WHEN Educations.CouseAllotedDaysMonth = 'Days' THEN DATEADD(DD, Educations.CourseAllotedTime, MyEducations.PurchaseDate)
							ELSE DATEADD(MM, Educations.CourseAllotedTime, MyEducations.PurchaseDate) END)) as 'ExpireDaysLeft',Educations.IsTimerRequired
	FROM         MyEducationModules WITH (READPAST, ROWLOCK) INNER JOIN
						  EducationModules WITH (READPAST, ROWLOCK) ON MyEducationModules.EducationModuleID = EducationModules.EducationModuleID INNER JOIN
						  EducationModuleFiles WITH (READPAST, ROWLOCK) ON EducationModules.EducationModuleID = EducationModuleFiles.EducationModuleID INNER JOIN
						  Educations WITH (READPAST, ROWLOCK) ON EducationModules.EducationID = Educations.EducationID INNER JOIN
						  MyEducations WITH (READPAST, ROWLOCK) ON MyEducationModules.MEID = MyEducations.MEID AND 
						  Educations.EducationID = MyEducations.EducationID INNER JOIN
						  FileTypes WITH (READPAST, ROWLOCK) ON EducationModuleFiles.FileTypeID = FileTypes.FileTypeID
		WHERE     (MyEducations.MEID = @MEID) AND (MyEducations.UserID = @UserID) and EducationModuleFiles.FileTypeID <> 4
			ORDER BY MyEducationModules.MEMID
	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_NewsDetailsAccordingToNewsSearch]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author     :	MMSingh
-- Create date: 06/26/2015
-- Description:	Get News Section Result after searching data
-- ==============================================================================
CREATE PROCEDURE [dbo].[Get_NewsDetailsAccordingToNewsSearch]

 @NewsTitle Varchar(40)
AS
BEGIN
	SELECT  Distinct  News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType, News.NewsAuthor, 
                      NewsSections.NewsSectionTitle
    FROM         News WITH(READPAST,ROWLOCK) INNER JOIN
                      NewsSections WITH(READPAST,ROWLOCK)  ON NewsSections.NewsSectionID = News.NewsSectionID
                      INNER JOIN NewsPhotos photo WITH(READPAST,ROWLOCK)  ON photo.NewsID=News.NewsID 
    WHERE (News.NewsTitle LIKE '%'+  ltrim(rtrim(@NewsTitle)) + '%')
END

GO
/****** Object:  StoredProcedure [dbo].[Get_NewsFullDetailByNewsID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 09/18/2014
-- Description: GET newsfull detail with newsid
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_NewsFullDetailByNewsID]
	@NewsID int = NULL ,	@Type varchar(50)=NULL
AS
BEGIN

if(@Type='Photo')
BEGIN
				SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
                      photo.NewsPhotoID AS PhotoVideoId, photo.NewsPhotos AS PhotoVideoTitle
FROM         News WITH (READPAST, ROWLOCK) INNER JOIN
                      NewsPhotos AS photo WITH (READPAST, ROWLOCK) ON photo.NewsID = News.NewsID INNER JOIN
                      NewsSections AS section WITH (READPAST, ROWLOCK) ON section.NewsSectionID = News.NewsSectionID
WHERE     (News.NewsID = @NewsID)
END
ELSE IF(@Type='Video')
BEGIN
SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
                      video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
FROM         News WITH (READPAST, ROWLOCK) INNER JOIN
                      NewsVideos AS video WITH (READPAST, ROWLOCK) ON video.NewsID = News.NewsID INNER JOIN
                      NewsSections AS section WITH (READPAST, ROWLOCK) ON section.NewsSectionID = News.NewsSectionID 
                      WHERE     (News.NewsID = @NewsID)
END						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_Newslatest]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 11/11/2014
-- Description: GET latest news
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_Newslatest]
AS
BEGIN

select top 3 * from News order by  NewsDate desc
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_NewsWithPhotoAndVideoAllCount]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 09/17/2014
-- Description: GET All news with Photos ANd Video
-- Version: 1.0
-- ================================================================ 
Create PROCEDURE [dbo].[Get_NewsWithPhotoAndVideoAllCount]
	@Type varchar(50)=NULL
	
AS
BEGIN

if(@Type='All')
BEGIN
	SELECT   COUNT(*) as TotalCount from (
			SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID 
			union all

			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK)  on section.NewsSectionID=News.NewsSectionID)
							as g where Rank=1 
							
					) as gj
			
							
							
END
else if(@Type='EditorPick')
BEGIN

	SELECT   COUNT(*) as TotalCount from (
	SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID where News.NewsEditorPick=1

			union all

			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK)  on section.NewsSectionID=News.NewsSectionID where News.NewsEditorPick=1)
							as g where Rank=1 
							) as gj
	

END
else if(@Type='Video')
BEGIN
	SELECT   COUNT(*) as TotalCount from (
	SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID 
) as gj

			

END
else if(@Type='Photo')
BEGIN
	SELECT   COUNT(*) as TotalCount from (
			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK)  on section.NewsSectionID=News.NewsSectionID)
							as g where Rank=1 
							
							) as gj
			

END


						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_NewsWithPhotoAndVideoBySectionIdAndTypeAllCount]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 10/08/2014
-- Description: GET All news with Photos ANd Video by SectionID and type
-- Version: 1.0
-- ================================================================ 
Create PROCEDURE [dbo].[Get_NewsWithPhotoAndVideoBySectionIdAndTypeAllCount]
	@Type varchar(50),
	@SectionID int	
AS
BEGIN

if(@Type='All')
BEGIN

 
	SELECT   COUNT(*) as TotalCount from (
			SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID
								  where News.NewsSectionID=@SectionID

			union all

			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK )  on section.NewsSectionID=News.NewsSectionID where News.NewsSectionID=@SectionID)
							as g where Rank=1 
							) as gj
						
					
	
END
else if(@Type='EditorPick')
BEGIN
	SELECT   COUNT(*) as TotalCount from (
	SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID where News.NewsEditorPick=1 and News.NewsSectionID=@SectionID

			union all

			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK)  on section.NewsSectionID=News.NewsSectionID where News.NewsEditorPick=1 and News.NewsSectionID=@SectionID)
							as g where Rank=1 
									) as gj
					


END
else if(@Type='Video')
BEGIN
	SELECT   COUNT(*) as TotalCount from (
	SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID
where  News.NewsSectionID=@SectionID 
	) as gj
					
	
			

END
else if(@Type='Photo')
BEGIN
	SELECT   COUNT(*) as TotalCount from (
			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK)  on section.NewsSectionID=News.NewsSectionID where  News.NewsSectionID=@SectionID)
							as g where Rank=1 
								) as gj
					

			

END


						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedDiscountCoupon]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: GJain
-- Create date: 05/16/2015
-- Description: GET Discount Coupon with limit record
-- Version: 1.0
-- ================================================================ 
Create PROCEDURE [dbo].[Get_PagedDiscountCoupon]
	@Skip INT,        
	@Take INT

	AS
BEGIN
  WITH DiscountCouponAllSearch AS
   (      
SELECT    ROW_NUMBER() Over(Order by DiscountCoupons.CouponID desc)as Row,
  DiscountCoupons.CouponID, DiscountCoupons.CouponCode, DiscountCoupons.CouponType, DiscountCoupons.CouponEducationID, 
                      DiscountCoupons.CouponProduactID, DiscountCoupons.CouponDiscount, DiscountCoupons.CouponExpiryDate, DiscountCoupons.CouponIssueDate, 
                      DiscountCoupons.CoupanValid
FROM         DiscountCoupons 
		
   )

  SELECT * FROM DiscountCouponAllSearch DIS
   WHERE DIS.ROW BETWEEN @Skip + 1 AND @Skip + @Take  						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedDiscountCouponForCourse]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: GJain
-- Create date: 05/16/2015
-- Description: GET Discount Coupon with limit record
-- Version: 1.0
-- ================================================================ 
Create PROCEDURE [dbo].[Get_PagedDiscountCouponForCourse]
	@Skip INT,        
	@Take INT

	AS
BEGIN
  WITH DiscountCouponAllSearch AS
   (      
SELECT    ROW_NUMBER() Over(Order by DiscountCoupons.CouponID desc)as Row,
  DiscountCoupons.CouponID, DiscountCoupons.CouponCode, DiscountCoupons.CouponType, DiscountCoupons.CouponEducationID, 
                      DiscountCoupons.CouponProduactID, DiscountCoupons.CouponDiscount, DiscountCoupons.CouponExpiryDate, DiscountCoupons.CouponIssueDate, 
                      DiscountCoupons.CoupanValid, Educations.CourseName
FROM         DiscountCoupons WITH (READPAST, ROWLOCK) INNER JOIN
                      Educations ON Educations.EducationID = DiscountCoupons.CouponEducationID 
WHERE     (DiscountCoupons.CouponProduactID = 0) 
		
   )

  SELECT * FROM DiscountCouponAllSearch DIS
   WHERE DIS.ROW BETWEEN @Skip + 1 AND @Skip + @Take  					  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedEducationModuleByEid]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: GJain
-- Create date: 05/20/2015
-- Description: GET EducationModule with limit record
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_PagedEducationModuleByEid]
   @EducationId int,
	@Skip INT,        
	@Take INT

	AS
BEGIN
  WITH EduModuleAllSearch AS
   (  
     SELECT   ROW_NUMBER() Over(Order by EducationModules.EducationModulePosition)as Row,  EducationModuleID, EducationID, EducationModuleName, EducationModuleDescription,ISNULL(EducationModuleTime,'NULL') as EducationModuleTime, EducationModuleDate, EducationModulePosition
FROM         EducationModules where EducationID=@EducationId
 )
   
  

  SELECT * FROM EduModuleAllSearch EduModule
   WHERE EduModule.ROW BETWEEN @Skip + 1 AND @Skip + @Take  						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedEducationProfession]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: GJain
-- Create date: 05/18/2015
-- Description: GET EduProfession with limit record
-- Version: 1.0
-- ================================================================ 
Create PROCEDURE [dbo].[Get_PagedEducationProfession]
	@Skip INT,        
	@Take INT

	AS
BEGIN
  WITH EduProfessionAllSearch AS
   (    
   	SELECT   ROW_NUMBER() Over(Order by link.EducationProfessions.EducationProfessionID desc)as Row,   Educations.CourseName,Professions.ProfessionTitle, link.EducationProfessions.EducationProfessionID, link.EducationProfessions.EducationID, link.EducationProfessions.ProfessionID, 
						  link.EducationProfessions.IsActive
	FROM         Professions WITH (READPAST, ROWLOCK) INNER JOIN
						  link.EducationProfessions WITH (READPAST, ROWLOCK) ON Professions.ProfessionID = link.EducationProfessions.ProfessionID INNER JOIN
						  Educations ON link.EducationProfessions.EducationID = Educations.EducationID	
 )
   
  

  SELECT * FROM EduProfessionAllSearch EduProf
   WHERE EduProf.ROW BETWEEN @Skip + 1 AND @Skip + @Take  						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedEducationSearchResult]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 09/30/2014
-- Description: GET Educatoin search results.
-- Version: 1.0
-------Updated By GJain date 05/20/2015
-- Description: GET Educatoin search results with paging.
-- Version: 1.1
-- ===========================================================================================
-- Author By: HSingh
-- Create date: 08/24/2015
-- Description: delete department table link
-- Version: 1.3
-- ===========================================================================================
--  [dbo].[Get_PagedEducationSearchResult] 'p',0,10
CREATE PROCEDURE [dbo].[Get_PagedEducationSearchResult]
	@CourseName varchar(250),
	@Skip INT,        
	@Take INT
AS
BEGIN
WITH EduAllSearch AS
   (  
SELECT    ROW_NUMBER() Over(Order by  Educations.EducationID desc)as Row, clg.CollegeName, Educations.CourseName, Educations.CourseUploadDate, COUNT(EducationModules.EducationModuleID) AS NumberOfModule, 
                      Educations.EducationID, Educations.ReadyToDisplay,Educations.IsPublished, Educations.IsCoursePreview
FROM         EducationModules RIGHT OUTER JOIN
                      Educations ON EducationModules.EducationID = Educations.EducationID LEFT OUTER JOIN
                          (SELECT     Colleges.CollegeName, link.CollegeEducations.EducationID
                            FROM          link.CollegeEducations INNER JOIN
                                                   Colleges ON link.CollegeEducations.CollegeID = Colleges.CollegeID
                            WHERE      (link.CollegeEducations.IsActive = 1) OR
                                                   (link.CollegeEducations.IsActive IS NULL)) AS clg ON Educations.EducationID = clg.EducationID
WHERE     (Educations.CourseName LIKE @CourseName + '%')
GROUP BY clg.CollegeName, Educations.CourseName, Educations.CourseUploadDate, Educations.EducationID, Educations.ReadyToDisplay,Educations.IsPublished,IsCoursePreview
	)
  		 

  SELECT * FROM EduAllSearch Edu
   WHERE Edu.ROW BETWEEN @Skip + 1 AND @Skip + @Take 			  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedEnterprisePackageRegisters]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Mahinder Singh
-- Create date: 12/20/2016
-- Description: GET All EnterprisePackageRegisters order by desc
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_PagedEnterprisePackageRegisters]
	@Skip INT,        
	@Take INT

	AS
BEGIN
  WITH EnterprisePackageRegistersAllSearch AS
   (  
	SELECT   ROW_NUMBER() Over(Order by EPRCreatedDate desc)as Row,EPRID,EPRName,EPRPhone,EPREmail,EPRCompany,EPRCreatedDate
    FROM     dbo.EnterprisePackageRegisters
 ) 
  SELECT * FROM EnterprisePackageRegistersAllSearch SC
   WHERE SC.ROW BETWEEN @Skip + 1 AND @Skip + @Take  						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedFaculty]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Mahinder Singh
-- Create date: 09/23/2015
-- Description: GET All Faculty order by desc
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_PagedFaculty]
	@Skip INT,        
	@Take INT

	AS
BEGIN
  WITH FacultyAllSearch AS
   (  
	SELECT   ROW_NUMBER() Over(Order by CreatedDate desc)as Row,FacultyID,FirstName,LastName,Email,Company,Phone,ProfessionalTitle,
                           AddressStreet,AddressFloor,City,State,Zip,AreaOfExpertise,Topics,Resume,CreatedDate
    FROM     dbo.Faculties
 ) 
  SELECT * FROM FacultyAllSearch FAQ
   WHERE FAQ.ROW BETWEEN @Skip + 1 AND @Skip + @Take  						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedFAQ]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: GJain
-- Create date: 05/18/2015
-- Description: GET FAQ with limit record
-- Version: 1.0
-- ================================================================ 
Create PROCEDURE [dbo].[Get_PagedFAQ]
	@Skip INT,        
	@Take INT

	AS
BEGIN
  WITH FAQAllSearch AS
   (  
	SELECT   ROW_NUMBER() Over(Order by FAQs.FAQID desc)as Row,  FAQs.FAQID, FAQs.FAQCatID, FAQs.FAQues, FAQs.FAQAns, FAQCategories.FAQCategoryTitle
FROM         FAQs INNER JOIN
                      FAQCategories ON FAQCategories.FAQCatID = FAQs.FAQCatID
 )
   
  
  

  SELECT * FROM FAQAllSearch FAQ
   WHERE FAQ.ROW BETWEEN @Skip + 1 AND @Skip + @Take  						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedNewsWithPhotoAndVideoAll]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 09/17/2014
-- Description: GET All news with Photos ANd Video with paging
-- Version: 1.0
-- ================================================================ 

--EXEC dbo.Get_PagedNewsWithPhotoAndVideoAll 'All',0,10
CREATE PROCEDURE [dbo].[Get_PagedNewsWithPhotoAndVideoAll] --'All',0,10
	@Type varchar(50)=null,
	@Skip int,
	@Take int
AS
BEGIN

if(@Type='All')
BEGIN
 WITH NewsDetail AS
   (  
	SELECT   ROW_NUMBER() Over(Order by NewsID desc)as Row,* from (
			SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID 
			union all

			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK)  on section.NewsSectionID=News.NewsSectionID)
							as g where Rank=1 
							
					) as gj
					)
					  SELECT * FROM NewsDetail 
   WHERE NewsDetail.ROW BETWEEN @Skip + 1 AND @Skip + @Take 
							
							
END
else if(@Type='EditorPick')
BEGIN

 WITH NewsDetail AS
   (  
	SELECT   ROW_NUMBER() Over(Order by NewsID desc)as Row,* from (
	SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID where News.NewsEditorPick=1

			union all

			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK)  on section.NewsSectionID=News.NewsSectionID where News.NewsEditorPick=1)
							as g where Rank=1 
							) as gj
					)
					  SELECT * FROM NewsDetail 
   WHERE NewsDetail.ROW BETWEEN @Skip + 1 AND @Skip + @Take 

END
else if(@Type='Video')
BEGIN
 WITH NewsDetail AS
   (  
	SELECT   ROW_NUMBER() Over(Order by NewsID desc)as Row,* from (
	SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID 
) as gj
					)
					  SELECT * FROM NewsDetail 
   WHERE NewsDetail.ROW BETWEEN @Skip + 1 AND @Skip + @Take 
			

END
else if(@Type='Photo')
BEGIN
	 WITH NewsDetail AS
   (  
	SELECT   ROW_NUMBER() Over(Order by NewsID desc)as Row,* from (
			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK)  on section.NewsSectionID=News.NewsSectionID)
							as g where Rank=1 
							
							) as gj
					)
					  SELECT * FROM NewsDetail 
   WHERE NewsDetail.ROW BETWEEN @Skip + 1 AND @Skip + @Take 
			

END


						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedNewsWithPhotoAndVideoBySectionIdAndTypeAll]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 10/08/2014
-- Description: GET All news with Photos ANd Video by SectionID and type with paging
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_PagedNewsWithPhotoAndVideoBySectionIdAndTypeAll] --'All',26,0,10
	@Type varchar(50),
	@SectionID int,
	@Skip int,
	@Take int
AS
BEGIN

if(@Type='All')
BEGIN

 WITH NewsDetail AS
   (  
	SELECT   ROW_NUMBER() Over(Order by NewsID desc)as Row,* from (
			SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID
								  where News.NewsSectionID=@SectionID

			union all

			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK )  on section.NewsSectionID=News.NewsSectionID where News.NewsSectionID=@SectionID)
							as g where Rank=1 
							) as gj
					)
					  SELECT * FROM NewsDetail 
   WHERE NewsDetail.ROW BETWEEN @Skip + 1 AND @Skip + @Take 
END
else if(@Type='EditorPick')
BEGIN
 WITH NewsDetail AS
   (  
	SELECT   ROW_NUMBER() Over(Order by NewsID desc)as Row,* from (
	SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID where News.NewsEditorPick=1 and News.NewsSectionID=@SectionID

			union all

			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK)  on section.NewsSectionID=News.NewsSectionID where News.NewsEditorPick=1 and News.NewsSectionID=@SectionID)
							as g where Rank=1 
									) as gj
					)
					  SELECT * FROM NewsDetail 
   WHERE NewsDetail.ROW BETWEEN @Skip + 1 AND @Skip + @Take 

END
else if(@Type='Video')
BEGIN
WITH NewsDetail AS
   (  
	SELECT   ROW_NUMBER() Over(Order by NewsID desc)as Row,* from (
	SELECT     News.NewsID, News.NewsSectionID, News.NewsTitle, News.NewsDescription, News.NewsEditorPick, News.NewsDate, News.NewsType,News.NewsAuthor, section.NewsSectionTitle, 
								  video.NewsVideoID AS PhotoVideoId, video.NewsVideos AS PhotoVideoTitle
			FROM         News  with(READPAST,ROWLOCK) INNER JOIN
								  NewsVideos video with(READPAST,ROWLOCK)  ON video.NewsID = News.NewsID INNER JOIN
								  NewsSections section with(READPAST,ROWLOCK)  ON section.NewsSectionID = News.NewsSectionID
where  News.NewsSectionID=@SectionID 
	) as gj
					)
					  SELECT * FROM NewsDetail 
   WHERE NewsDetail.ROW BETWEEN @Skip + 1 AND @Skip + @Take 
			

END
else if(@Type='Photo')
BEGIN
	WITH NewsDetail AS
   (  
	SELECT   ROW_NUMBER() Over(Order by NewsID desc)as Row,* from (
			select NewsID, NewsSectionID, NewsTitle, NewsDescription, NewsEditorPick, NewsDate, NewsType,NewsAuthor,NewsSectionTitle,PhotoVideoId,PhotoVideoTitle
			 from(
						select  News.*,section.NewsSectionTitle,photo.NewsPhotoID as PhotoVideoId,RANK() OVER 
							(PARTITION BY News.NewsID ORDER BY photo.NewsPhotoID asc) AS Rank,
							photo.NewsPhotos as PhotoVideoTitle from  News  with(READPAST,ROWLOCK)
							inner join NewsPhotos photo with(READPAST,ROWLOCK)  on photo.NewsID=News.NewsID 
							inner join NewsSections section with(READPAST,ROWLOCK)  on section.NewsSectionID=News.NewsSectionID where  News.NewsSectionID=@SectionID)
							as g where Rank=1 
								) as gj
					)
					  SELECT * FROM NewsDetail 
   WHERE NewsDetail.ROW BETWEEN @Skip + 1 AND @Skip + @Take 
			

END


						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PagedSuggestCourse]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Mahinder Singh
-- Create date: 09/23/2015
-- Description: GET All SuggestCourse order by desc
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_PagedSuggestCourse]
	@Skip INT,        
	@Take INT

	AS
BEGIN
  WITH SuggestCoursesAllSearch AS
   (  
	SELECT   ROW_NUMBER() Over(Order by SCCreatedDate desc)as Row,SuggestCourseID,SCMyOccupation,SCStateID
	,SCName,SCPhone,SCEmail,SCPossibleTitle,SCBriefAgendaOutline,SCAudience,SCSingleDaySeminarCourse,SCOndemandLiveWebinarCourse,SCInterestedInstructor,
SCCreatedDate
    FROM     dbo.SuggestCourses
 ) 
  SELECT * FROM SuggestCoursesAllSearch SC
   WHERE SC.ROW BETWEEN @Skip + 1 AND @Skip + @Take  						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_PreTestQuestionsByEducationID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 06/21/2015
-- Description: GET All PreTest Questions By EducationID
-- Version: 1.0
-- Update By: GJain
-- Create date: 08/20/2015
-- Description: updated to get only active
-- Version: 1.1
-- Update By: GJain
-- Create date: 08/28/2015
-- Description: True False Answer added
-- Version: 1.2
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_PreTestQuestionsByEducationID]
(
@EducationID int
)
AS
BEGIN
SELECT     EduPQues.EducationID, PQues.PreTestID, PQues.PreTestQuestionID, PQues.PreTestQues, PQues.PreTestOptionA, PQues.PreTestOptionB, PQues.PreTestOptionC, 
                      PQues.PreTestOptionD, PQues.PreTestAnswer, PQues.PreTestAnswerType, PQues.PreTestAnswerTrueFalse
FROM         link.EducationPreTestQuestions AS EduPQues WITH (READPAST, ROWLOCK) INNER JOIN
                      PreTestQuestions AS PQues WITH (READPAST, ROWLOCK) ON PQues.PreTestID = EduPQues.PreTestID
WHERE     (EduPQues.EducationID = @EducationID) AND (EduPQues.IsActive = 1)
END


GO
/****** Object:  StoredProcedure [dbo].[Get_ProductPurchaseDetail]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKumar
-- Create date: 01/23/2017
-- Description:# 2998 Get Product Purchase Detail 
-- Version: 1.0
-- ================================================================ 
-- Get_ProductPurchaseDetail 0,45
CREATE PROCEDURE [dbo].[Get_ProductPurchaseDetail]
(
@Skip int,
	@Take int
)
AS
BEGIN
 WITH ProductPurchaseDetail AS
   ( 
	
	Select ROW_NUMBER() over (Order by ShippingPaymentID desc)as rownumber,ShippingPaymentID,Date,ProductType ,UserFirstName,UserLastName
	
	from (
	SELECT DISTINCT		  ProductShoppings.ShippingPaymentID,Products.ProductType, CONVERT(date, ProductShoppings.Date) AS Date, 
						Users.FirstName AS UserFirstName, Users.LastName AS UserLastName 
	FROM            ShippingPayments INNER JOIN
							 ShippingAddresses ON ShippingPayments.ShippingAddressID = ShippingAddresses.ShippingAddressID INNER JOIN
							 Products INNER JOIN
							 ProductShoppings ON Products.ProductID = ProductShoppings.ProductID INNER JOIN
							 Users ON ProductShoppings.UserID = Users.UID ON ShippingPayments.ShippingPaymentID = ProductShoppings.ShippingPaymentID
	WHERE        (Products.ProductType = 'Hard Copy'))tbl

	)

 SELECT * FROM ProductPurchaseDetail
	where rownumber between @skip+1 and (@skip+@take) 
                      
END



GO
/****** Object:  StoredProcedure [dbo].[Get_ProductPurchaseDetailCount]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKumar
-- Create date: 01/23/2017
-- Description:# 2998 Get Product Purchase Detail  Count
-- Version: 1.0 
-- ================================================================ 
--  [dbo].[Get_ProductPurchaseDetailCount] 0,45
CREATE PROCEDURE [dbo].[Get_ProductPurchaseDetailCount]
(
@Skip int,
	@Take int
)
AS
BEGIN
    select COUNT(*) as TotalCount from (
	
		Select ROW_NUMBER() over (Order by ShippingPaymentID desc)as rownumber,ShippingPaymentID,Date,ProductType ,UserLastName
	
	from (
	SELECT DISTINCT		  ProductShoppings.ShippingPaymentID,Products.ProductType, CONVERT(date, ProductShoppings.Date) AS Date, 
						Users.FirstName AS UserFirstName, Users.LastName AS UserLastName 
	FROM            ShippingPayments INNER JOIN
							 ShippingAddresses ON ShippingPayments.ShippingAddressID = ShippingAddresses.ShippingAddressID INNER JOIN
							 Products INNER JOIN
							 ProductShoppings ON Products.ProductID = ProductShoppings.ProductID INNER JOIN
							 Users ON ProductShoppings.UserID = Users.UID ON ShippingPayments.ShippingPaymentID = ProductShoppings.ShippingPaymentID
	WHERE        (Products.ProductType = 'Hard Copy'))tbl
	
	)tbl
                      
END
GO
/****** Object:  StoredProcedure [dbo].[Get_ProductShoppingTempByID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 07/22/2014
-- Description: GET professions by college id.
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_ProductShoppingTempByID]
(
@ProductShoppingTempID int
)
	AS
BEGIN
	SELECT     * FROM         ProductShoppingTemps where ProductShoppingTempID = @ProductShoppingTempID
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_ProfessionEducationByEducationID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 09/21/2015
-- Description: GET Profession education.
-- Version: 1.0
-- ================================================================ 

Create PROCEDURE [dbo].[Get_ProfessionEducationByEducationID]
	@EducationID int
AS
BEGIN	
SELECT     Professions.ProfessionID, Professions.ProfessionTitle, link.EducationProfessions.EducationProfessionID, link.EducationProfessions.EducationID, 
                      link.EducationProfessions.IsActive
FROM         link.EducationProfessions INNER JOIN
                      Professions ON link.EducationProfessions.ProfessionID = Professions.ProfessionID
                      	WHERE     (link.EducationProfessions.EducationID = @EducationID) AND (link.EducationProfessions.IsActive = 1 OR link.EducationProfessions.IsActive IS NULL)
	ORDER BY Professions.ProfessionID
END
GO
/****** Object:  StoredProcedure [dbo].[Get_ProfessionNotAssociateWithEducation]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: HSingh
-- Create date: 07/23/2014
-- Description: GET list of profession not associates with education.
-- Version: 1.0
-- ========================================================================================== 
CREATE PROCEDURE [dbo].[Get_ProfessionNotAssociateWithEducation]
	@EducationID int
AS
BEGIN

	SELECT     p.*
	FROM         dbo.Professions as p WITH(READPAST,ROWLOCK)
	WHERE      (p.IsActive IS NULL OR p.IsActive=1) AND 
				(p.ProfessionID NOT IN
							  (SELECT     ep.ProfessionID
								FROM          link.EducationProfessions as ep WITH(READPAST,ROWLOCK)
								WHERE      (ep.EducationID = @EducationID) AND (ep.IsActive=1 OR ep.IsActive is null)))
	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_ProfessionsByCollegeID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 07/22/2014
-- Description: GET professions by college id.
-- Version: 1.0
-- ===========================================================================================
-- Author By: HSingh
-- Create date: 08/24/2015
-- Description: delete department table link
-- Version: 1.3
-- ===========================================================================================
CREATE PROCEDURE [dbo].[Get_ProfessionsByCollegeID]
	@CollegeID int
AS
BEGIN

		SELECT     Professions.ProfessionID, Professions.ProfessionTitle, Professions.IsActive
		FROM         link.CollegeEducations WITH (READPAST, ROWLOCK) INNER JOIN
							  link.EducationProfessions AS EP WITH (READPAST, ROWLOCK) ON link.CollegeEducations.EducationID = EP.EducationID INNER JOIN
							  Professions WITH (READPAST, ROWLOCK) ON Professions.ProfessionID = EP.ProfessionID
		WHERE     (link.CollegeEducations.CollegeID = @CollegeID) AND (link.CollegeEducations.IsActive <> 0) AND (Professions.IsActive <> 0)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Get_ShoppingDetailsByShippingPaymentID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tarun Gosain
-- Create date: 12-29-2016
-- Description:	Get Shopping details by shipping payment id for email.
-- =============================================
-- [Get_ShoppingDetailsByShippingPaymentID] 510

CREATE PROCEDURE [dbo].[Get_ShoppingDetailsByShippingPaymentID] (@ShippingPaymentID int)
AS
BEGIN	
SET NOCOUNT ON;

	
Select 'Product' as  CartType, ProductName as PName, ProductPrice * Quantity as Price, ProductType as PType, ProductShoppings.Date , 
((ProductPrice * Quantity) *  (isnull(ProductShoppings.TaxPercentage,0)/100)) as TaxPercentage
--isnull(ProductShoppings.TaxPercentage,0) as TaxPercentage
	from Products inner join ProductShoppings on Products.ProductID = ProductShoppings.ProductID where ShippingPaymentID = @ShippingPaymentID
union all

select  'Course' as CartType, CourseName as PName, CoursePrice * Quantity as Price, '' as PType, EducationShoppings.Date  , isnull(EducationShoppings.TaxPercentage,0) as TaxPercentage
from EducationShoppings
	inner join Educations on Educations.EducationID = EducationShoppings.EducationID
where ShippingPaymentID = @ShippingPaymentID

union all

select 'AllAccessPass' as CartType, 'All Access Pass' as PName
, (select AllAccessPassPricing from UserSubscriptions where UserSubscriptions.UserSubscriptionID = UserAllAccessPasses.UserSubscriptionID) as Price, '' as PType, isnull(CreatedOn, AllAccessStartDate) as Date
, 0 as TaxPercentage
from UserAllAccessPasses 
where ShippingPaymentID = @ShippingPaymentID

END

GO
/****** Object:  StoredProcedure [dbo].[Insert_EducationModule]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 09/24/2014
-- Description: GET All EducationModule by EducationID
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Insert_EducationModule]
		@EducationID int,
		@EducationModuleName VARCHAR(300),
		@EducationModuleDescription varchar(max),
		@EducationModuleTime VARCHAR(30) = null,
		@EducationModuleDate datetime,
		@EducationModulePosition INT		
AS
BEGIN
declare 
@SETTOPOSTION INT,
@MODULEID INT
set @SETTOPOSTION=@EducationModulePosition
      SELECT @MODULEID=EducationModuleID FROM EducationModules WHERE EducationModulePosition=@SETTOPOSTION AND EducationID=@EducationID
    if(@MODULEID IS NOT NULL)
	begin 
		UPDATE    EducationModules
			SET              EducationModulePosition = EducationModulePosition + 1
			WHERE     (EducationModulePosition >= @SETTOPOSTION) AND (EducationID = @EducationID) 
		
		INSERT INTO EducationModules
                      (EducationID, EducationModuleName,EducationModuleDescription,EducationModuleTime, EducationModuleDate, EducationModulePosition)
		VALUES     (@EducationID,@EducationModuleName,@EducationModuleDescription,@EducationModuleTime,@EducationModuleDate,@EducationModulePosition)
			
	end
	ELSE
	BEGIN
 			INSERT INTO EducationModules
                      (EducationID, EducationModuleName,EducationModuleDescription, EducationModuleTime, EducationModuleDate, EducationModulePosition)
			VALUES     (@EducationID,@EducationModuleName,@EducationModuleDescription,@EducationModuleTime,@EducationModuleDate,@EducationModulePosition)
	END

   SELECT CAST(@@Identity as int)
END
GO
/****** Object:  StoredProcedure [dbo].[SQLJOB_ResetInProcessedShippingOrderItems]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Rkumar
-- Create date: 09/07/2014
-- Description: SQLJOB Reset In Processed Shipping Order Items.
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[SQLJOB_ResetInProcessedShippingOrderItems]
AS
BEGIN
	BEGIN TRANSACTION [Trans1]  
	BEGIN TRY
	DECLARE @tempProductData TABLE
	(
		ProductShoppingTempID int NOT NULL,
		ProductID int NOT NULL,
		Quantity int NOT NULL,
		ShippingPaymentID int NOT NULL,
		IsProcessed int NOT NULL,
		ProcessedDate datetime NOT NULL
	);

	INSERT INTO @tempProductData
	Select ProductShoppingTempID ,
		ProductID ,
		Quantity ,
		ShippingPaymentID ,
		IsProcessed ,
		ProcessedDate 
		 from ProductShoppingTemps WHERE ProcessedDate <= dateadd(minute,-10,getdate()) and isnull(ShippingPaymentID,0) > 0 and isnull(IsProcessed,0)=1 


	--	SELECT        ProductShoppingTemps.ProductShoppingTempID, ProductShoppingTemps.ProductID, ProductShoppingTemps.Quantity, ProductShoppingTemps.ShippingPaymentID, 
 --                        ProductShoppingTemps.IsProcessed, ProductShoppingTemps.ProcessedDate 
	--FROM            ProductShoppingTemps INNER JOIN
	--						 Products ON ProductShoppingTemps.ProductID = Products.ProductID
	--WHERE        (ProductShoppingTemps.ProcessedDate <= DATEADD(minute, - 10, GETDATE())) AND (ISNULL(ProductShoppingTemps.ShippingPaymentID, 0) > 0) AND 
 --                        (ISNULL(ProductShoppingTemps.IsProcessed, 0) = 1)  AND Products.ProductType  <> 'Download'


	
	




	
	Declare @FinalProductCnt int=0

	Set @FinalProductCnt = (Select count(*) from @tempProductData)

	DECLARE @intFlag INT
		SET @intFlag = 1
			WHILE (@intFlag <= @FinalProductCnt)
				BEGIN
					-- ADD THE QUANTITY IN PRODUCT TABLE
						declare @ProductShoppingTempID  int =0
						declare @ProductCurrentBalance int = 0;
						declare @ProductID int = 0;
						declare @Quantity int = 0;

						Select top 1 @ProductShoppingTempID = ProductShoppingTempID , @ProductID = ProductID , @Quantity = Quantity from @tempProductData
						set @ProductCurrentBalance = (SELECT        ProductCurrentBalance FROM            Products where ProductID =  @ProductID)-- AND Products.ProductType  <> 'Download')
						UPDATE       Products SET                ProductCurrentBalance = @ProductCurrentBalance + @Quantity where ProductID =  @ProductID and ProductType <> 'Download'
						delete from @tempProductData where ProductShoppingTempID =@ProductShoppingTempID
						set  @intFlag = @intFlag + 1

					-- END PRODUCT QUANITY UPDATE

						UPDATE       ProductShoppingTemps SET ShippingPaymentID =null, IsProcessed =null, ProcessedDate =null where ProductShoppingTempID =@ProductShoppingTempID

				END


				-- RESET Education Shopping Temps 

						UPDATE  EducationShoppingTemps SET  ShippingPaymentID =null, ProcessedDate = null where ProcessedDate <= dateadd(minute,-10,getdate()) and isnull(ShippingPaymentID,0) > 0 

				COMMIT TRANSACTION	[Trans1]			
    END TRY
		BEGIN CATCH
		ROLLBACK TRANSACTION [Tran1]
	END CATCH	  
END	




GO
/****** Object:  StoredProcedure [dbo].[Update_CarouselSetUp]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author     :	MMSingh
-- Create date: 06/30/2015
-- Description:	Update Carousel data in CarouselSetUp Table
-- ==============================================================================
CREATE PROCEDURE [dbo].[Update_CarouselSetUp]
@CarouselID INT,
@CarouselTitle VARCHAR(50),
@CarouselDescription VARCHAR(200),
@CarouselBgColor VARCHAR(20),
@NewsID INT

AS
BEGIN
	
	UPDATE CarouselSetUps SET  CarouselTitle = @CarouselTitle, CarouselDescription = @CarouselDescription, 
	       CarouselBgColor = @CarouselBgColor , NewsID = @NewsID
    WHERE  CarouselID = @CarouselID
END

GO
/****** Object:  StoredProcedure [dbo].[Update_DiscountCouponStatus]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 08/12/2014
-- Description: To update discount coupons status after use.
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Update_DiscountCouponStatus]
	@CouponCode varchar(30),@CoupanValid bit
AS
BEGIN

	UPDATE    DiscountCoupons
	SET              CoupanValid = @CoupanValid
	WHERE     (CouponCode = @CouponCode)
						  
END
GO
/****** Object:  StoredProcedure [dbo].[Update_EducationEvaluation]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author     :	GJain
-- Create date: 08/19/2015
-- Description:	Update EducationEvaluations Status to false and insert if not added
-- ==============================================================================
CREATE PROCEDURE [dbo].[Update_EducationEvaluation]
@EducationID INT,
@EvaluationID INT,
@CourseEvaluationID INT
AS
BEGIN
		if exists (select * from link.EducationEvaluations where EvaluationID=@EvaluationID and EducationID=@EducationID)
				Begin
						   UPDATE    link.EducationEvaluations SET  IsActive=0 where (IsActive=1 or IsActive is null)
						 and EducationID = @EducationID  and CourseEvaluationID!=@CourseEvaluationID
						UPDATE    link.EducationEvaluations SET  IsActive=1 where CourseEvaluationID=@CourseEvaluationID
				 END
		Else
		       Begin
		   UPDATE    link.EducationEvaluations SET  IsActive=0 where (IsActive=1 or IsActive is null)
				 and EducationID = @EducationID    
				   if(@EvaluationID!=0)
						 begin 
			   INSERT into link.EducationEvaluations (EvaluationID,EducationID,IsActive) values (@EvaluationID,@EducationID,1)
						end 
		       End
				   
END

GO
/****** Object:  StoredProcedure [dbo].[Update_EducationExamQuestion]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author     :	GJain
-- Create date: 08/19/2015
-- Description:	Update EducationExamQuestion Status to false  and insert if not added
-- ==============================================================================
CREATE PROCEDURE [dbo].[Update_EducationExamQuestion]
@EducationID INT,
@ExamID INT,
@CourseExamID INT
AS
BEGIN
		if exists (select * from link.EducationExamQuestions where ExamID=@ExamID and EducationID=@EducationID)
				Begin
				  UPDATE    link.EducationExamQuestions SET  IsActive=0 where (IsActive=1 or IsActive is null)
						 and EducationID = @EducationID 
						UPDATE    link.EducationExamQuestions SET  IsActive=1 where CourseExamID=@CourseExamID
				 END
		Else
		       Begin
		       UPDATE    link.EducationExamQuestions SET  IsActive=0 where (IsActive=1 or IsActive is null)
						 and EducationID = @EducationID  
						 if(@ExamID!=0)
						 begin
							   INSERT into link.EducationExamQuestions (ExamID,EducationID,IsActive) values (@ExamID,@EducationID,1)
						 end
		       End
END

GO
/****** Object:  StoredProcedure [dbo].[Update_EducationModule]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 09/27/2014
-- Description: Update  EducationModule with position
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Update_EducationModule]
        @EducationModuleID int,
		@EducationID int,
		@EducationModuleName VARCHAR(300),
		@EducationModuleDescription varchar(max),
		@EducationModuleTime VARCHAR(30),
		@EducationModuleDate datetime,
		@EducationModulePosition INT	
		
AS
BEGIN
declare 
@SETTOPOSTION INT,
@MODULEID INT,
@PREVIOUSPOSITION INT
 SELECT @PREVIOUSPOSITION=EducationModulePosition FROM EducationModules WHERE EducationModuleID=@EducationModuleID
 SET @SETTOPOSTION=@EducationModulePosition

SELECT @MODULEID=EducationModuleID FROM EducationModules WHERE EducationModulePosition=@SETTOPOSTION AND EducationID=@EducationID

if(@MODULEID IS NOT NULL)
BEGIN
	IF(@PREVIOUSPOSITION>@SETTOPOSTION)
	BEGIN
	UPDATE    EducationModules
	SET             EducationModulePosition = EducationModulePosition + 1
	WHERE     (EducationModulePosition BETWEEN @SETTOPOSTION AND @PREVIOUSPOSITION - 1) AND (EducationID = @EducationID) 
	
	UPDATE    EducationModules
	SET              EducationID = @EducationID, EducationModuleName = @EducationModuleName,EducationModuleDescription=@EducationModuleDescription, EducationModuleTime = @EducationModuleTime, 
                      EducationModuleDate = @EducationModuleDate,   EducationModulePosition = @EducationModulePosition 
	WHERE    EducationModuleID=@EducationModuleID
	
	END			
	ELSE IF(@PREVIOUSPOSITION<@SETTOPOSTION	)		  
	BEGIN
		UPDATE EducationModules  SET    EducationModulePosition = EducationModulePosition - 1
			WHERE     (EducationModulePosition BETWEEN @PREVIOUSPOSITION + 1 AND @SETTOPOSTION) AND (EducationID = @EducationID)
			
				UPDATE    EducationModules
	SET              EducationID = @EducationID, EducationModuleName = @EducationModuleName,EducationModuleDescription=@EducationModuleDescription, EducationModuleTime = @EducationModuleTime, 
                      EducationModuleDate = @EducationModuleDate,   EducationModulePosition = @EducationModulePosition 
	WHERE    EducationModuleID=@EducationModuleID
		
	END
	ELSE IF(@PREVIOUSPOSITION=@SETTOPOSTION)
	BEGIN
	UPDATE EducationModules   SET EducationID = @EducationID, EducationModuleName = @EducationModuleName,EducationModuleDescription=@EducationModuleDescription, EducationModuleTime = @EducationModuleTime, 
                      EducationModuleDate = @EducationModuleDate, EducationModulePosition = @EducationModulePosition
WHERE     (EducationModuleID = @EducationModuleID)
	END
END
SELECT CAST(@EducationModuleID as int)
END
GO
/****** Object:  StoredProcedure [dbo].[Update_EducationModulesTime]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKumar
-- Create date: 08/31/2016
-- Description: Update Education Modules Time in admin preview course.
-- Version: 1.0
-- ===========================================================================================

CREATE PROCEDURE [dbo].[Update_EducationModulesTime]
	@EducationID int
AS
BEGIN
	BEGIN TRANSACTION [Trans1]  
	BEGIN TRY

		--UPDATE    EducationModules 		SET              EducationModuleTime = NULL 		WHERE     (EducationID = @EducationID)
	
				UPDATE    EducationModules
		SET              EducationModuleTime = NULL
		FROM         EducationModules INNER JOIN
							  EducationModuleFiles ON EducationModules.EducationModuleID = EducationModuleFiles.EducationModuleID
		WHERE     (EducationModules.EducationID = @EducationID) AND EducationModuleFiles.FileTypeID <> 3
		
		UPDATE		MyEducationModules
		SET			CompletedDate =null, TimeLeft =null
		FROM		EducationModules INNER JOIN
						  MyEducations ON EducationModules.EducationID = MyEducations.EducationID INNER JOIN
						  MyEducationModules ON EducationModules.EducationModuleID = MyEducationModules.EducationModuleID
		WHERE MyEducationModules.Completed <>  1 AND EducationModules.EducationID = @EducationID
		
		
		
		
		
	COMMIT TRANSACTION	[Trans1]			
    END TRY
		BEGIN CATCH
		ROLLBACK TRANSACTION [Tran1]
	END CATCH	
END
GO
/****** Object:  StoredProcedure [dbo].[Update_EducationModuleTime]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 05/25/201
-- Description: Update  EducationModule Time
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Update_EducationModuleTime]
        @EducationModuleID int,
		@EducationModuleTime VARCHAR(30)=null
		
		
AS
BEGIN
	UPDATE    EducationModules
	SET           EducationModuleTime = @EducationModuleTime                    
	WHERE    EducationModuleID=@EducationModuleID
	SELECT CAST(@EducationModuleID as int)
END
GO
/****** Object:  StoredProcedure [dbo].[Update_EducationPreTestQuestion]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author     :	GJain
-- Create date: 08/19/2015
-- Description:	Update EducationPreTestQuestions Status to false and insert if not added
-- ==============================================================================
CREATE PROCEDURE [dbo].[Update_EducationPreTestQuestion]
@EducationID INT,
@PreTestID INT,
@CoursePreTestID INT
AS
BEGIN
		if exists (select * from link.EducationPreTestQuestions where PreTestID=@PreTestID and EducationID=@EducationID)
				Begin
						 UPDATE    link.EducationPreTestQuestions SET  IsActive=0 where (IsActive=1 or IsActive is null)
						 and EducationID = @EducationID
						UPDATE    link.EducationPreTestQuestions SET  IsActive=1 where CoursePreTestID=@CoursePreTestID
				 END
		Else
		       Begin
		     UPDATE    link.EducationPreTestQuestions SET  IsActive=0 where (IsActive=1 or IsActive is null)
				 and EducationID = @EducationID
				  if(@PreTestID!=0)
						 begin
			   INSERT into link.EducationPreTestQuestions (PreTestID,EducationID,IsActive) values (@PreTestID,@EducationID,1)
					end	 
		       End

				        
END

GO
/****** Object:  StoredProcedure [dbo].[Update_MyEducationCompletedToPassed]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 11/05/2015
-- Description: Set Ispassed to true when Evalution and Exam is removed 
-- Version: 1.0
-- ================================================================ 
cREATE PROCEDURE [dbo].[Update_MyEducationCompletedToPassed] (@EducationID int)
AS
BEGIN

		if(((select count(*) from [link].[EducationExamQuestions] with(READPAST,ROWLOCK) where  (EducationID = @EducationID)and isActive=1)=0) 
		    and (select count(*) from [link].[EducationEvaluations] with(READPAST,ROWLOCK) where  (EducationID = @EducationID)and isActive=1)=0)
		Begin	
			--- Exam Education
			update  [MyEducations] set [IsPassed]=1,completed=1,completeddate=getdate()  where MEID  in 				
		(
	SELECT     gj.MEID
FROM         (SELECT     MEID
                       FROM          MyEducations WITH (READPAST, ROWLOCK)
                       WHERE      (MEID NOT IN
                                                  ((SELECT     MyEducationModules.MEID
                                                      FROM         MyEducationModules WITH (READPAST, ROWLOCK) INNER JOIN
                                                                            MyEducations AS MyEducations_1 WITH (READPAST, ROWLOCK) ON MyEducationModules.MEID = MyEducations_1.MEID INNER JOIN
                                                                            Educations WITH (READPAST, ROWLOCK) ON MyEducations_1.EducationID = Educations.EducationID
                                                      WHERE     (MyEducations_1.EducationID = @EducationID) AND (MyEducationModules.Completed = 0)))) AND (EducationID = @EducationID) AND
                                                  ((SELECT     COUNT(*) AS Expr1
                                                      FROM         link.EducationEvaluations WITH (READPAST, ROWLOCK)
                                                      WHERE     (EducationID = @EducationID) AND (IsActive = 1)) = 0)and ( IsPassed IS NULL)) AS gj LEFT OUTER JOIN
                      ExamResults WITH (READPAST, ROWLOCK) ON gj.MEID = ExamResults.MEID AND ExamResults.IsPass = 1

			)
			
			
			--eVALUTION
				update  [MyEducations] set [IsPassed]=1 ,completed=1,completeddate=getdate() where MEID  in 			
			(			
					SELECT     gj.MEID
FROM         (SELECT     MEID
                       FROM          MyEducations WITH (READPAST, ROWLOCK)
                       WHERE      (MEID NOT IN
                                                  ((SELECT     MyEducationModules.MEID
                                                      FROM         MyEducationModules WITH (READPAST, ROWLOCK) INNER JOIN
                                                                            MyEducations WITH (READPAST, ROWLOCK) ON MyEducationModules.MEID = MyEducations.MEID INNER JOIN
                                                                            Educations WITH (READPAST, ROWLOCK) ON MyEducations.EducationID = Educations.EducationID
                                                      WHERE     (MyEducations.EducationID = @EducationID) AND (MyEducationModules.Completed = 0)))) AND (EducationID = @EducationID)and ( IsPassed IS NULL)) AS gj LEFT OUTER JOIN
                      ExamResults WITH (READPAST, ROWLOCK) ON gj.MEID = ExamResults.MEID AND ExamResults.IsPass = 1
			)
		
		END
		
		

END
GO
/****** Object:  StoredProcedure [dbo].[Update_MyEducationExpiredByUserID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================
-- Author By: HSingh
-- Create date: 08/04/2015
-- Description: User Story #2473 ( Modified): My Eduction - Course Validationk
-- Version: 1.0
-- ========================================================================================== 

CREATE PROCEDURE [dbo].[Update_MyEducationExpiredByUserID]
	@userID int
AS
BEGIN
	
	UPDATE    MyEducations
	SET              Expired = 1,CompletedDate=GETDATE()
	FROM         MyEducations INNER JOIN
							  (SELECT     CASE WHEN Educations.CouseAllotedDaysMonth = 'Days' THEN DATEADD(DD, Educations.CourseAllotedTime, MyEducations.PurchaseDate) 
													   ELSE DATEADD(MM, Educations.CourseAllotedTime, MyEducations.PurchaseDate) END AS 'ExpiryDate', MyEducations.EducationID,MyEducations.MEID
								FROM          MyEducations INNER JOIN
													   Educations ON MyEducations.EducationID = Educations.EducationID
								WHERE      (MyEducations.UserID = @userID)  AND (MyEducations.Completed IS NULL OR
													   MyEducations.Completed = 0) AND (MyEducations.Expired IS NULL OR
													   MyEducations.Expired = 0)) AS hp ON MyEducations.EducationID = hp.EducationID and MyEducations.MEID=hp.MEID
	WHERE     (hp.ExpiryDate < GETDATE())

END
GO
/****** Object:  StoredProcedure [dbo].[Update_MyEducationModuleTimeLeft]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSingh
-- Create date: 01/13/2015
-- Description: Update time left field in myEducationModule table.
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Update_MyEducationModuleTimeLeft] (@MEMID int, @TimeLeft varchar(50))
AS
BEGIN

	UPDATE    MyEducationModules WITH (READPAST, ROWLOCK)
	SET              TimeLeft = @TimeLeft
	WHERE     (MEMID = @MEMID)

END
GO
/****** Object:  StoredProcedure [dbo].[Update_ProductShippingDetailByShippingPaymentID]    Script Date: 10-02-2020 16:03:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================
-- Author     :	RKumar
-- Create date: 01/28/2017
-- Description:	Update Product Shipping Detail By ShippingPaymentID
-- ==============================================================================
create PROCEDURE [dbo].[Update_ProductShippingDetailByShippingPaymentID]
@ShippingPaymentID INT,
@CreatedBy int,
@ProductShippedOn datetime
AS
BEGIN
	UPDATE    ProductShippingDetails SET              ProductShippedOn = @ProductShippedOn, CreatedOn = GETDATE(), CreatedBy = @CreatedBy  where ShippingPaymentID = @ShippingPaymentID
END



GO
USE [master]
GO
ALTER DATABASE [HCRGUniversity] SET  READ_WRITE 
GO

USE [master]
GO
/****** Object:  Database [MMC]    Script Date: 10-02-2020 15:57:35 ******/
CREATE DATABASE [MMC]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MMC', FILENAME = N'E:\SQL_Database\MMC.mdf' , SIZE = 34816KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MMC_log', FILENAME = N'E:\SQL_Database\MMC_log.ldf' , SIZE = 112384KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MMC] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MMC].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MMC] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MMC] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MMC] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MMC] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MMC] SET ARITHABORT OFF 
GO
ALTER DATABASE [MMC] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MMC] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MMC] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MMC] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MMC] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MMC] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MMC] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MMC] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MMC] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MMC] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MMC] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MMC] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MMC] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MMC] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MMC] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MMC] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MMC] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MMC] SET RECOVERY FULL 
GO
ALTER DATABASE [MMC] SET  MULTI_USER 
GO
ALTER DATABASE [MMC] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MMC] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MMC] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MMC] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [MMC] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'MMC', N'ON'
GO
USE [MMC]
GO
/****** Object:  User [VSAINDIA\dheerajs]    Script Date: 10-02-2020 15:57:36 ******/
CREATE USER [VSAINDIA\dheerajs] FOR LOGIN [VSAINDIA\dheerajs] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [VSAINDIA\Developers_JAL]    Script Date: 10-02-2020 15:57:36 ******/
CREATE USER [VSAINDIA\Developers_JAL] FOR LOGIN [VSAINDIA\Developers_JAL]
GO
ALTER ROLE [db_owner] ADD MEMBER [VSAINDIA\dheerajs]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [VSAINDIA\dheerajs]
GO
/****** Object:  Schema [global]    Script Date: 10-02-2020 15:57:36 ******/
CREATE SCHEMA [global]
GO
/****** Object:  Schema [link]    Script Date: 10-02-2020 15:57:36 ******/
CREATE SCHEMA [link]
GO
/****** Object:  Schema [lookup]    Script Date: 10-02-2020 15:57:36 ******/
CREATE SCHEMA [lookup]
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateAcceptedBodyPartsByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateAcceptedBodyPartsByPatientID](
@PatientID int
			) RETURNS VARCHAR(max)
			as
			begin
			 DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ',','') + QUOTENAME(BodyPartName)
			FROM (

			select BodyPartName from (
						SELECT      lookup.BodyParts.BodyPartName 
						FROM         PatientClaimAddOnBodyParts INNER JOIN
								  PatientClaims ON PatientClaimAddOnBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
								  lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
								  lookup.BodyPartStatuses ON PatientClaimAddOnBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
						where PatientClaims.PatientID = @PatientID and lookup.BodyPartStatuses.BodyPartStatusID = 1  
						
						
						union
						
						SELECT     lookup.BodyParts.BodyPartName 
									FROM         PatientClaimPleadBodyParts INNER JOIN
								  PatientClaims ON PatientClaimPleadBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
								  lookup.BodyParts ON PatientClaimPleadBodyParts.PleadBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
								  lookup.BodyPartStatuses ON PatientClaimPleadBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
						
						where PatientClaims.PatientID = @PatientID and lookup.BodyPartStatuses.BodyPartStatusID = 1) tbl2

			) AS PivotExample
			declare @Consolidated_AcceptedBodyParts varchar(max)
			set @Consolidated_AcceptedBodyParts = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			RETURN @Consolidated_AcceptedBodyParts
			end
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateAcceptedBodyPartsByRFAReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateAcceptedBodyPartsByRFAReferralID](
@RFAReferralID int
			) RETURNS VARCHAR(max)
			as
			begin
			 
			DECLARE @Consolidated_AcceptedBodyParts varchar(Max)
			 
			DECLARE @PatientClaimID int
			
			set @PatientClaimID = (SELECT     isnull(PatientClaimID,0) FROM         RFAReferrals where RFAReferralID =@RFAReferralID)
						
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(BodyPartName)
			FROM (
			select Distinct BodyPartName from (
			SELECT      lookup.BodyParts.BodyPartName 
			FROM         PatientClaimAddOnBodyParts INNER JOIN
                      PatientClaims ON PatientClaimAddOnBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
                      lookup.BodyPartStatuses ON PatientClaimAddOnBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
			where PatientClaims.PatientClaimID = @PatientClaimID and lookup.BodyPartStatuses.BodyPartStatusID = 1  
			
			
			union
			
			SELECT     lookup.BodyParts.BodyPartName 
						FROM         PatientClaimPleadBodyParts INNER JOIN
                      PatientClaims ON PatientClaimPleadBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      lookup.BodyParts ON PatientClaimPleadBodyParts.PleadBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
                      lookup.BodyPartStatuses ON PatientClaimPleadBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
			
			where PatientClaims.PatientClaimID = @PatientClaimID and lookup.BodyPartStatuses.BodyPartStatusID = 1) tbl2
			
			
			
			
			) AS PivotExample
			 
			set @Consolidated_AcceptedBodyParts = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			
			
			
			RETURN @Consolidated_AcceptedBodyParts
			end
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateClaimsByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateClaimsByPatientID](
@PatientID int
			) RETURNS VARCHAR(max)
			as
			begin
			 
			DECLARE @Consolidated_Claims varchar(Max)
			
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(PatClaimNumber)
			FROM (SELECT     PatClaimNumber FROM         PatientClaims where PatientID = @PatientID) AS PivotExample
			 
			set @Consolidated_Claims = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			 
			RETURN @Consolidated_Claims  
			end
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateComorbidConditionsByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateComorbidConditionsByPatientID](
@PatientID int
			) RETURNS VARCHAR(max)
			as
			begin
			
			DECLARE @Consolidated_ComorbidConditions varchar(Max)
			
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(CurrentMedicalConditionName)
			FROM (SELECT      lookup.CurrentMedicalConditions.CurrentMedicalConditionName
				FROM         PatientCurrentMedicalConditions INNER JOIN
                      lookup.CurrentMedicalConditions ON PatientCurrentMedicalConditions.CurrentMedicalConditionId = lookup.CurrentMedicalConditions.CurrentMedicalConditionId
				where PatientCurrentMedicalConditions.PatientID = @PatientID) AS PivotExample
			 
			set @Consolidated_ComorbidConditions = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			
			RETURN @Consolidated_ComorbidConditions
			end
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateDeniedBodyPartsByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateDeniedBodyPartsByPatientID](
@PatientID int
			) RETURNS VARCHAR(max)
			as
			begin
			DECLARE @Consolidated_DeniedBodyParts varchar(Max)
			
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(BodyPartName)
			FROM (
			select BodyPartName from (
			SELECT      lookup.BodyParts.BodyPartName
			FROM         PatientClaimAddOnBodyParts INNER JOIN
                      PatientClaims ON PatientClaimAddOnBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
                      lookup.BodyPartStatuses ON PatientClaimAddOnBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
			where PatientClaims.PatientID = @PatientID and lookup.BodyPartStatuses.BodyPartStatusID = 2  
			
			
			union
			
			SELECT     lookup.BodyParts.BodyPartName
						FROM         PatientClaimPleadBodyParts INNER JOIN
                      PatientClaims ON PatientClaimPleadBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      lookup.BodyParts ON PatientClaimPleadBodyParts.PleadBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
                      lookup.BodyPartStatuses ON PatientClaimPleadBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
			
			where PatientClaims.PatientID = @PatientID and lookup.BodyPartStatuses.BodyPartStatusID = 2) tbl2
			
			) AS PivotExample
			 
			set @Consolidated_DeniedBodyParts = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			
			 
			RETURN @Consolidated_DeniedBodyParts
			end
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateDeniedBodyPartsByRFAReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateDeniedBodyPartsByRFAReferralID](
@RFAReferralID int
			) RETURNS VARCHAR(max)
			as
			begin
			
			DECLARE @PatientClaimID int
			
			set @PatientClaimID = (SELECT     isnull(PatientClaimID,0) FROM         RFAReferrals where RFAReferralID =@RFAReferralID)
			
			 
			DECLARE @Consolidated_DeniedBodyParts varchar(Max)
			
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(BodyPartName)
			FROM (
			
			select Distinct BodyPartName from (
			SELECT      lookup.BodyParts.BodyPartName
			FROM         PatientClaimAddOnBodyParts INNER JOIN
                      PatientClaims ON PatientClaimAddOnBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
                      lookup.BodyPartStatuses ON PatientClaimAddOnBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
			where PatientClaims.PatientClaimID = @PatientClaimID and lookup.BodyPartStatuses.BodyPartStatusID = 2  
			
			
			union
			
			SELECT     lookup.BodyParts.BodyPartName
						FROM         PatientClaimPleadBodyParts INNER JOIN
                      PatientClaims ON PatientClaimPleadBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      lookup.BodyParts ON PatientClaimPleadBodyParts.PleadBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
                      lookup.BodyPartStatuses ON PatientClaimPleadBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
			
			where PatientClaims.PatientClaimID = @PatientClaimID and lookup.BodyPartStatuses.BodyPartStatusID = 2) tbl2
			
			) AS PivotExample
			 
			set @Consolidated_DeniedBodyParts = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			
			 
			RETURN @Consolidated_DeniedBodyParts
			end
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateDiagnosisByPatientClaimID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateDiagnosisByPatientClaimID](
@PatientClaimID int
			) RETURNS VARCHAR(max)
			as
			begin
			
			 
			DECLARE @Consolidated_Diagnosis varchar(Max)
			
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(Diagnosis)
			FROM ( 
			
				SELECT DISTINCT (CASE WHEN ICD9Codes.icdICD9Number IS NULL THEN PatientClaimDiagnoses.icdICDNumber + '-  ' + lookup.ICD10Codes.ICD10Description ELSE PatientClaimDiagnoses.icdICDNumber + '-  ' + lookup.ICD9Codes.ICD9Description END) AS Diagnosis
					FROM         PatientClaimDiagnoses LEFT JOIN
										  lookup.ICD9Codes ON PatientClaimDiagnoses.icdICDNumberID = lookup.ICD9Codes.icdICD9NumberID AND PatientClaimDiagnoses.icdICDTab = 'ICD9' LEFT JOIN
										  lookup.ICD10Codes ON PatientClaimDiagnoses.icdICDNumberID = lookup.ICD10Codes.icdICD10NumberID AND PatientClaimDiagnoses.icdICDTab = 'ICD10' INNER JOIN
                      RFARecordSplittings ON PatientClaimDiagnoses.PatientClaimID = RFARecordSplittings.PatientClaimID
					WHERE     RFARecordSplittings.PatientClaimID = @PatientClaimID 
			
			) AS PivotExample
			 
			set @Consolidated_Diagnosis = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			
			 
			RETURN @Consolidated_Diagnosis
			end
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateDiagnosisByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateDiagnosisByPatientID](
@PatientID int
			) RETURNS VARCHAR(max)
			as
			begin
			DECLARE @Consolidated_Diagnosis varchar(Max)
			
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(Diagnosis)
			FROM (
			
			SELECT  distinct  (CASE WHEN ICD9Codes.icdICD9Number IS NULL THEN PatientClaimDiagnoses.icdICDNumber + '-  ' + lookup.ICD10Codes.ICD10Description ELSE PatientClaimDiagnoses.icdICDNumber + '-  ' + lookup.ICD9Codes.ICD9Description END) AS Diagnosis 
					FROM         PatientClaimDiagnoses INNER JOIN
										  PatientClaims ON PatientClaimDiagnoses.PatientClaimID = PatientClaims.PatientClaimID  LEFT JOIN
										  lookup.ICD9Codes ON PatientClaimDiagnoses.icdICDNumberID = lookup.ICD9Codes.icdICD9NumberID AND PatientClaimDiagnoses.icdICDTab = 'ICD9' LEFT JOIN
										  lookup.ICD10Codes ON PatientClaimDiagnoses.icdICDNumberID = lookup.ICD10Codes.icdICD10NumberID AND PatientClaimDiagnoses.icdICDTab = 'ICD10'
					WHERE     (PatientClaims.PatientID = @PatientID) 
			
			) AS PivotExample
			 
			set @Consolidated_Diagnosis = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			
			 
			RETURN @Consolidated_Diagnosis
			end
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateDiagnosisByRFAReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateDiagnosisByRFAReferralID](
@RFAReferralID int
			) RETURNS VARCHAR(max)
			as
			begin
			
			DECLARE @Consolidated_Diagnosis varchar(Max)
			
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(Diagnosis)
			FROM (
			
			SELECT  distinct (CASE WHEN ICD9Codes.icdICD9Number IS NULL THEN PatientClaimDiagnoses.icdICDNumber + '-  ' + lookup.ICD10Codes.ICD10Description ELSE PatientClaimDiagnoses.icdICDNumber + '-  ' + lookup.ICD9Codes.ICD9Description END) AS Diagnosis 
					FROM         PatientClaimDiagnoses LEFT JOIN
										  lookup.ICD9Codes ON PatientClaimDiagnoses.icdICDNumberID = lookup.ICD9Codes.icdICD9NumberID AND PatientClaimDiagnoses.icdICDTab = 'ICD9' LEFT JOIN
										  lookup.ICD10Codes ON PatientClaimDiagnoses.icdICDNumberID = lookup.ICD10Codes.icdICD10NumberID AND PatientClaimDiagnoses.icdICDTab = 'ICD10' INNER JOIN
										  RFAReferrals ON PatientClaimDiagnoses.PatientClaimID = RFAReferrals.PatientClaimID
					WHERE     RFAReferrals.RFAReferralID = @RFAReferralID 
			
			) AS PivotExample
			 
			set @Consolidated_Diagnosis = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			
			 
			RETURN @Consolidated_Diagnosis
			end
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateRequestNameByRFAReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateRequestNameByRFAReferralID](
@RFAReferralID int
			) RETURNS VARCHAR(max)
			as
			begin
			 
			DECLARE @Consolidated_Requests varchar(Max)
			
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			 declare @temp as varchar(max)

			 

			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(RFARequestedTreatment)
			FROM (SELECT   top 1000000000  (RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID(RFARequestID)),'')) as RFARequestedTreatment FROM         RFARequests where RFAReferralID = @RFAReferralID and isnull(DecisionID,0)=0 and  (isnull(RFAStatus,'')= '' or  RFAStatus = 'SendToPreparation' )  order by RFARequestID)  AS PivotExample
			 
			set @Consolidated_Requests = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			 
			RETURN @Consolidated_Requests  
			end
			
-- select [dbo].[CommaSeperateRequestNameByRFAReferralID] (1232)
 
-- SELECT     *
--FROM         RFARequests where RFAReferralID= 473



 
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateRequestUINByRFAReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateRequestUINByRFAReferralID](
@RFAReferralID int
			) RETURNS VARCHAR(max)
			as
			begin
			 
			DECLARE @Consolidated_RequestIDs varchar(Max)
			
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(RFARequestID)
			FROM (SELECT   top 1000000000  RFARequestID FROM         RFARequests where RFAReferralID = @RFAReferralID and isnull(DecisionID,0)=0 and  (isnull(RFAStatus,'')= '' or  RFAStatus = 'SendToPreparation' )   order by RFARequestID)  AS PivotExample
			 
			set @Consolidated_RequestIDs = (SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', ''))
			 
			RETURN @Consolidated_RequestIDs  
			end
 
GO
/****** Object:  UserDefinedFunction [dbo].[CommaSeperateRequestWithBodyPartNameByRFARequestID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[CommaSeperateRequestWithBodyPartNameByRFARequestID](
@RFARequestID int
			) RETURNS VARCHAR(max)
			as
			begin
			 
				DECLARE @Consolidated_Requests varchar(Max)
			 
				declare @ClaimBodyPartID as int = 47


				
					Select  @Consolidated_Requests = COALESCE(@Consolidated_Requests + ') (', '(') +  BodyPartName  
									   from ( SELECT        (case when isnull(PatientClaimAddOnBodyParts.AddOnBodyPartCondition,'') = ''  then lookup.BodyParts.BodyPartName else ( isnull(PatientClaimAddOnBodyParts.AddOnBodyPartCondition+ ' ' + lookup.BodyParts.BodyPartName,'')) end) as BodyPartName ,
					 lookup.BodyParts.BodyPartID, PatientClaimAddOnBodyParts.AddOnBodyPartCondition, 
											 PatientClaimAddOnBodyParts.BodyPartStatusID, PatientClaimAddOnBodyParts.AddOnBodyPartID
					FROM            lookup.BodyParts INNER JOIN
											 PatientClaimAddOnBodyParts ON lookup.BodyParts.BodyPartID = PatientClaimAddOnBodyParts.AddOnBodyPartID
					where PatientClaimAddOnBodyPartID in (select ClaimBodyPartID from RFARequestBodyParts where RFARequestID= @RFARequestID and BodyPartType ='Add On' )

					union

					SELECT     (case when  isnull(PatientClaimPleadBodyParts.PleadBodyPartCondition,'')= '' then lookup.BodyParts.BodyPartName  else ( isnull(PatientClaimPleadBodyParts.PleadBodyPartCondition+ ' ' + lookup.BodyParts.BodyPartName,'')) end) as BodyPartName ,
					   lookup.BodyParts.BodyPartID, PatientClaimPleadBodyParts.PleadBodyPartCondition, 
											 PatientClaimPleadBodyParts.BodyPartStatusID, PatientClaimPleadBodyParts.PleadBodyPartID
					FROM            lookup.BodyParts INNER JOIN
											 PatientClaimPleadBodyParts ON lookup.BodyParts.BodyPartID = PatientClaimPleadBodyParts.PleadBodyPartID
					where PatientClaimPleadBodyPartID in (select ClaimBodyPartID from RFARequestBodyParts where RFARequestID= @RFARequestID and BodyPartType ='Plead'))tbl


					--if((select	count(*)	from RFARequestBodyParts WHERE        (RFARequestBodyParts.RFARequestID = @RFARequestID )AND (RFARequestBodyParts.ClaimBodyPartID <> @ClaimBodyPartID)) =
					--(select	count(*)	from RFARequestBodyParts WHERE        (RFARequestBodyParts.RFARequestID = @RFARequestID ) 
					--and bodyparttype='Plead' and (RFARequestBodyParts.ClaimBodyPartID <> @ClaimBodyPartID)))
					--begin
					-- --select 'Plead'
					--Select  @Consolidated_Requests = COALESCE(@Consolidated_Requests + ') (', '(') +  BodyPartName  
					--				   from  (SELECT        RFARequestBodyParts.ClaimBodyPartID, 

					--						(case when  isnull(PatientClaimPleadBodyParts.PleadBodyPartCondition,'')= '' then lookup.BodyParts.BodyPartName  else (lookup.BodyParts.BodyPartName + ' ' + isnull(PatientClaimPleadBodyParts.PleadBodyPartCondition,'')) end) as BodyPartName , lookup.BodyParts.BodyPartID, 'Plead' AS tblname 
                          
					--						FROM            PatientClaimPleadBodyParts INNER JOIN
					--												 lookup.BodyParts ON PatientClaimPleadBodyParts.PleadBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
					--												 RFARequestBodyParts ON PatientClaimPleadBodyParts.PatientClaimPleadBodyPartID = RFARequestBodyParts.ClaimBodyPartID
					--						WHERE        (RFARequestBodyParts.RFARequestID = @RFARequestID) AND (RFARequestBodyParts.ClaimBodyPartID <> @ClaimBodyPartID))tbl
				 
					--end 
					--else if((select	count(*)	from RFARequestBodyParts WHERE        (RFARequestBodyParts.RFARequestID = @RFARequestID )AND (RFARequestBodyParts.ClaimBodyPartID <> @ClaimBodyPartID)) =
					--(select	count(*)	from RFARequestBodyParts WHERE        (RFARequestBodyParts.RFARequestID = @RFARequestID ) 
					--and bodyparttype='Add On' and (RFARequestBodyParts.ClaimBodyPartID <> @ClaimBodyPartID)))
					--begin
					-- --select 'Add On'
					--	Select  @Consolidated_Requests = COALESCE(@Consolidated_Requests + ') (', '(') +  BodyPartName  
					--				   from ( SELECT        RFARequestBodyParts.ClaimBodyPartID, (case when isnull(PatientClaimAddOnBodyParts.AddOnBodyPartCondition,'') = ''  then lookup.BodyParts.BodyPartName else (lookup.BodyParts.BodyPartName + ' '  + isnull(PatientClaimAddOnBodyParts.AddOnBodyPartCondition,'') ) end) as BodyPartName , lookup.BodyParts.BodyPartID, 'Add On' AS tblname
                         
					--						FROM            RFARequestBodyParts INNER JOIN
					--												 PatientClaimAddOnBodyParts ON RFARequestBodyParts.ClaimBodyPartID = PatientClaimAddOnBodyParts.PatientClaimAddOnBodyPartID INNER JOIN
					--												 lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID
					--						WHERE        (RFARequestBodyParts.RFARequestID = @RFARequestID) AND (RFARequestBodyParts.ClaimBodyPartID <> @ClaimBodyPartID))tbl

					--end 
					--else 
					--begin
					-- --select 'Add On' + ' ' + 'Plead'

					--	Select  @Consolidated_Requests = COALESCE(@Consolidated_Requests + ') (', '(') +  BodyPartName  
					--				   from (SELECT        RFARequestBodyParts.ClaimBodyPartID, (case when isnull(PatientClaimAddOnBodyParts.AddOnBodyPartCondition,'') = ''  then lookup.BodyParts.BodyPartName else (lookup.BodyParts.BodyPartName + ' '  + isnull(PatientClaimAddOnBodyParts.AddOnBodyPartCondition,'') ) end) as BodyPartName , lookup.BodyParts.BodyPartID, 'Add On' AS tblname
                         
					--						FROM            RFARequestBodyParts INNER JOIN
					--												 PatientClaimAddOnBodyParts ON RFARequestBodyParts.ClaimBodyPartID = PatientClaimAddOnBodyParts.PatientClaimAddOnBodyPartID INNER JOIN
					--												 lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID
					--						WHERE        (RFARequestBodyParts.RFARequestID = @RFARequestID) AND (RFARequestBodyParts.ClaimBodyPartID <> @ClaimBodyPartID)

					--						union

					--						SELECT        RFARequestBodyParts.ClaimBodyPartID, 

					--						(case when  isnull(PatientClaimPleadBodyParts.PleadBodyPartCondition,'')= '' then lookup.BodyParts.BodyPartName  else (lookup.BodyParts.BodyPartName + ' ' + isnull(PatientClaimPleadBodyParts.PleadBodyPartCondition,'')) end) as BodyPartName , lookup.BodyParts.BodyPartID, 'Plead' AS tblname 
                          
					--						FROM            PatientClaimPleadBodyParts INNER JOIN
					--												 lookup.BodyParts ON PatientClaimPleadBodyParts.PleadBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
					--												 RFARequestBodyParts ON PatientClaimPleadBodyParts.PatientClaimPleadBodyPartID = RFARequestBodyParts.ClaimBodyPartID
					--						WHERE        (RFARequestBodyParts.RFARequestID = @RFARequestID) AND (RFARequestBodyParts.ClaimBodyPartID <> @ClaimBodyPartID))tbl
					--end 


			 

			 
			 
				RETURN @Consolidated_Requests + ')'   
			end
			 
 
GO
/****** Object:  UserDefinedFunction [dbo].[Get_LatestRFARequestDueDate]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 03/17/2016
-- Description: GET Latest Due Date
-- Version: 1.0
-- ================================================================ 

CREATE FUNCTION [dbo].[Get_LatestRFARequestDueDate]
(
  @AddDay int,
 @RFARequestDate  DateTime
)
RETURNS DateTime
AS

BEGIN


DECLARE @dtEndDate datetime
DECLARE @dtDateHolder datetime
DECLARE @dtNextHol datetime

--Check Request date is Sunday or Saturday
if(DATEPART(DW, @RFARequestDate)=7)
 set @RFARequestDate=DATEADD(d,2,@RFARequestDate)
else if(DATEPART(DW, @RFARequestDate)=1)
 set @RFARequestDate=DATEADD(d,1,@RFARequestDate)

----End



SET @dtDateHolder = @RFARequestDate
SET @dtEndDate = DATEADD(d,@AddDay,@RFARequestDate)
--Find the first Public Holiday Date
select @dtNextHol = MIN(HolidayDate) FROM MMC.lookup.Holidays where HolidayDate >=@dtDateHolder

WHILE (@dtDateHolder <= @dtEndDate)
BEGIN

--Is the date being checked a Saturday or Sunday?
IF((DATEPART(dw, @dtDateHolder) in (1, 7))
--Is the date being checked a holiday?
OR (DATEADD(dd, 0, DATEDIFF(dd, 0, @dtDateHolder))=@dtNextHol))
--NOTE: DATEDIFF trick used above to discard TIMESTAMP

BEGIN

-- Extend the date range for Weekends and Holidays by one day
SET @dtEndDate = DATEADD(d,1,@dtEndDate)
if (DATEADD(dd, 0, DATEDIFF(dd, 0, @dtDateHolder))=@dtNextHol)
BEGIN
-- get the next  public holiday date
select @dtNextHol = MIN(HolidayDate ) FROM MMC.lookup.Holidays where HolidayDate >@dtDateHolder
END
END

--Move to the next day in the range and loop back to check it
SET @dtDateHolder = DATEADD(d,1,@dtDateHolder)

END

--Respond with newly determined end date
return @dtEndDate

END


GO
/****** Object:  UserDefinedFunction [dbo].[ReadWordInitials]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ReadWordInitials] ( @str NVARCHAR(4000) )
RETURNS NVARCHAR(2000)
AS
BEGIN
	
	DECLARE @regex INT,@string varchar(100)
	--SET @string='Medial Branch Block (Diagnostic) - Thoracic'
		SET @string=@str
		SET @regex = PATINDEX('%[^a-zA-Z0-9 ]%', @string)
	WHILE @regex > 0
		BEGIN
			SET @string = STUFF(@string, @regex, 1, ' ' )
			SET @regex = PATINDEX('%[^a-zA-Z0-9 ]%', @string)
		END
	SET @str=@string

    DECLARE @retval NVARCHAR(2000);

    SET @str=RTRIM(LTRIM(@str));
    SET @retval=LEFT(upper(@str),1);

    WHILE CHARINDEX(' ',@str,1)>0 BEGIN
        SET @str=LTRIM(RIGHT(@str,LEN(@str)-CHARINDEX(' ',@str,1)));
        SET @retval+=LEFT(upper(@str),1);
    END

    RETURN @retval+' : ';
END

GO
/****** Object:  UserDefinedFunction [dbo].[ZReadWordInitials]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ZReadWordInitials] (@s AS nvarchar(4000))
RETURNS nvarchar(100)
AS
BEGIN

	DECLARE @regex INT,@string varchar(100)
	--SET @string='Medial Branch Block (Diagnostic) - Thoracic'
		SET @string=@s
		SET @regex = PATINDEX('%[^a-zA-Z0-9 ]%', @string)
	WHILE @regex > 0
		BEGIN
			SET @string = STUFF(@string, @regex, 1, ' ' )
			SET @regex = PATINDEX('%[^a-zA-Z0-9 ]%', @string)
		END
	SET @s=@string
	
    DECLARE @i nvarchar(100) = LEFT(ltrim(rtrim(@s)), 1); -- first char in string
    DECLARE @p int = CHARINDEX(' ', ltrim(rtrim(@s))); -- location of first space
    WHILE (@p > 0) -- while a space has been found
    BEGIN
        SET @i = @i + SUBSTRING(ltrim(rtrim(@s)), @p + 1, 1) -- add char after space
        SET @p = CHARINDEX(' ', ltrim(rtrim(@s)), @p + 1); -- find next space
    END 
    RETURN ltrim(rtrim(@i))+' : '
END

GO
/****** Object:  UserDefinedFunction [global].[Get_SplitStringFormat]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 Create FUNCTION [global].[Get_SplitStringFormat] 
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
/****** Object:  Table [dbo].[Adjusters]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Adjusters](
	[AdjusterID] [int] IDENTITY(1,1) NOT NULL,
	[AdjFirstName] [varchar](50) NOT NULL,
	[AdjLastName] [varchar](50) NOT NULL,
	[AdjAddress1] [varchar](50) NOT NULL,
	[AdjAddress2] [varchar](50) NULL,
	[AdjCity] [varchar](50) NOT NULL,
	[AdjStateID] [int] NOT NULL,
	[AdjZip] [varchar](10) NOT NULL,
	[AdjPhone] [varchar](14) NOT NULL,
	[AdjFax] [varchar](14) NOT NULL,
	[AdjEMail] [varchar](50) NOT NULL,
	[ClientID] [int] NOT NULL,
 CONSTRAINT [PK_Adjusters] PRIMARY KEY CLUSTERED 
(
	[AdjusterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ADRs]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ADRs](
	[ADRID] [int] IDENTITY(1,1) NOT NULL,
	[ADRName] [varchar](50) NOT NULL,
	[ADRAddress] [varchar](max) NOT NULL,
	[ADRAddress2] [varchar](max) NULL,
	[ADRCity] [varchar](50) NOT NULL,
	[ADRStateID] [int] NOT NULL,
	[ADRZip] [varchar](50) NOT NULL,
	[ContactName] [varchar](50) NOT NULL,
	[ContactPhone] [varchar](14) NOT NULL,
 CONSTRAINT [PK_ADRs] PRIMARY KEY CLUSTERED 
(
	[ADRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AttorneyFirms]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttorneyFirms](
	[AttorneyFirmID] [int] IDENTITY(1,1) NOT NULL,
	[AttorneyFirmName] [varchar](50) NOT NULL,
	[AttorneyFirmTypeID] [int] NULL,
	[AttAddress1] [varchar](50) NOT NULL,
	[AttAddress2] [varchar](50) NULL,
	[AttCity] [varchar](50) NOT NULL,
	[AttStateID] [int] NOT NULL,
	[AttZip] [varchar](10) NOT NULL,
	[AttPhone] [varchar](14) NOT NULL,
	[AttFax] [varchar](14) NOT NULL,
 CONSTRAINT [PK_AttorneyFirms] PRIMARY KEY CLUSTERED 
(
	[AttorneyFirmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Attorneys]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attorneys](
	[AttorneyID] [int] IDENTITY(1,1) NOT NULL,
	[AttorneyFirmID] [int] NOT NULL,
	[AttorneyName] [varchar](50) NOT NULL,
	[AttPhone] [varchar](14) NULL,
	[AttFax] [varchar](14) NULL,
	[AttEmail] [varchar](50) NULL,
 CONSTRAINT [PK_Attorneys] PRIMARY KEY CLUSTERED 
(
	[AttorneyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CaseManagers]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CaseManagers](
	[CaseManagerID] [int] IDENTITY(1,1) NOT NULL,
	[CMFirstName] [varchar](25) NOT NULL,
	[CMLastName] [varchar](25) NOT NULL,
	[CMAddress1] [varchar](50) NOT NULL,
	[CMAddress2] [varchar](50) NULL,
	[CMCity] [varchar](50) NOT NULL,
	[CMStateID] [int] NOT NULL,
	[CMZip] [varchar](10) NOT NULL,
	[CMPhone] [varchar](14) NULL,
	[CMFax] [varchar](14) NULL,
	[CMEmail] [varchar](25) NULL,
	[CMNotes] [varchar](max) NULL,
 CONSTRAINT [PK_CaseManagers] PRIMARY KEY CLUSTERED 
(
	[CaseManagerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientBillingRetailRates]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientBillingRetailRates](
	[ClientBillingRetailRateID] [int] IDENTITY(1,1) NOT NULL,
	[ClientBillingID] [int] NOT NULL,
	[ClientBillingRetailRateRN] [money] NOT NULL,
	[ClientBillingRetailRateMD] [money] NOT NULL,
	[ClientBillingRetailRateSpecialityReview] [money] NOT NULL,
	[ClientBillingRetailRateAdminFee] [money] NOT NULL,
	[ClientBillingRetailRateIMRPrep] [money] NULL,
	[ClientBillingRetailRateIMRMD] [money] NULL,
	[ClientBillingRetailRateIMRRush] [money] NULL,
	[ClientBillingRetailRateDeferral] [money] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ClientBillingRates] PRIMARY KEY CLUSTERED 
(
	[ClientBillingRetailRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientBillings]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientBillings](
	[ClientBillingID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[ClientBillingRateTypeID] [int] NOT NULL,
	[ClientIsPrivateLabel] [bit] NULL,
	[ClientInvoiceNumber] [varchar](50) NULL,
	[ClientAttentionToID] [int] NULL,
	[ClientAttentionToFreeText] [varchar](max) NULL,
 CONSTRAINT [PK_ClientBilling] PRIMARY KEY CLUSTERED 
(
	[ClientBillingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientBillingWholesaleRates]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientBillingWholesaleRates](
	[ClientBillingWholesaleRateID] [int] IDENTITY(1,1) NOT NULL,
	[ClientBillingID] [int] NOT NULL,
	[ClientBillingWholesaleRateRN] [money] NOT NULL,
	[ClientBillingWholesaleRateMD] [money] NOT NULL,
	[ClientBillingWholesaleRateSpecialityReview] [money] NOT NULL,
	[ClientBillingWholesaleRateAdminFee] [money] NOT NULL,
	[ClientBillingWholesaleRateIMRPrep] [money] NULL,
	[ClientBillingWholesaleRateIMRMD] [money] NULL,
	[ClientBillingWholesaleRateIMRRush] [money] NULL,
	[ClientBillingWholesaleRateDeferral] [money] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ClientBillingWholesaleRates] PRIMARY KEY CLUSTERED 
(
	[ClientBillingWholesaleRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientEmployers]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientEmployers](
	[ClientEmployerID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[EmployerID] [int] NOT NULL,
 CONSTRAINT [PK_ClientEmployers] PRIMARY KEY CLUSTERED 
(
	[ClientEmployerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientInsuranceBranches]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientInsuranceBranches](
	[ClientInsuranceBranchID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[InsurerID] [int] NOT NULL,
	[InsuranceBranchID] [int] NOT NULL,
 CONSTRAINT [PK_ClientInsurerBranches] PRIMARY KEY CLUSTERED 
(
	[ClientInsuranceBranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientInsurers]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientInsurers](
	[ClientInsurerID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[InsurerID] [int] NOT NULL,
 CONSTRAINT [PK_ClientInsurers] PRIMARY KEY CLUSTERED 
(
	[ClientInsurerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientManagedCareCompanies]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientManagedCareCompanies](
	[ClientCompanyID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[CompanyID] [int] NOT NULL,
 CONSTRAINT [PK_ClientManagedCareCompanies] PRIMARY KEY CLUSTERED 
(
	[ClientCompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientPrivateLabels]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientPrivateLabels](
	[ClientPrivateLabelID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[ClientPrivateLabelName] [varchar](50) NOT NULL,
	[ClientPrivateLabelAddress] [varchar](50) NOT NULL,
	[ClientPrivateLabelCity] [varchar](50) NOT NULL,
	[ClientPrivateLabelStateID] [int] NOT NULL,
	[ClientPrivateLabelZip] [varchar](10) NOT NULL,
	[ClientPrivateLabelLogoName] [varchar](max) NULL,
	[ClientPrivateLabelPhone] [varchar](14) NOT NULL,
	[ClientPrivateLabelFax] [varchar](14) NOT NULL,
	[ClientPrivateLabelTax] [varchar](10) NULL,
	[ClientStatementStart] [varchar](15) NULL,
	[ClientPrivateEmailID] [varchar](50) NULL,
 CONSTRAINT [PK_ClientPrivateLabels] PRIMARY KEY CLUSTERED 
(
	[ClientPrivateLabelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Clients]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[ClientID] [int] IDENTITY(1,1) NOT NULL,
	[ClientName] [varchar](50) NOT NULL,
	[ClaimAdministratorID] [int] NULL,
	[ClaimAdministratorType] [char](4) NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientStatements]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientStatements](
	[ClientStatementID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[ClientStatementNumber] [varchar](15) NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ClientStatementFileName] [varchar](200) NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_ClientStatements] PRIMARY KEY CLUSTERED 
(
	[ClientStatementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientThirdPartyAdministratorBranches]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientThirdPartyAdministratorBranches](
	[ClientTPABranchID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[TPAID] [int] NOT NULL,
	[TPABranchID] [int] NOT NULL,
 CONSTRAINT [PK_ClientTPABranchs] PRIMARY KEY CLUSTERED 
(
	[ClientTPABranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClientThirdPartyAdministrators]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientThirdPartyAdministrators](
	[ClientTPAID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[TPAID] [int] NOT NULL,
 CONSTRAINT [PK_ClientTPAs] PRIMARY KEY CLUSTERED 
(
	[ClientTPAID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CurrentWorkloadReport]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CurrentWorkloadReport](
	[CurrentWorkloadReportID] [int] IDENTITY(1,1) NOT NULL,
	[CurrentWorkloadReportName] [varchar](50) NULL,
 CONSTRAINT [PK_CurrentWorkLoadReport] PRIMARY KEY CLUSTERED 
(
	[CurrentWorkloadReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CurrentWorkloadReportParameters]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CurrentWorkloadReportParameters](
	[CurrentWorkloadReportParameterID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NULL,
	[CurrentWorkloadReportID] [int] NULL,
	[StatusID] [int] NULL,
 CONSTRAINT [PK_CurrentWorkloadParameters] PRIMARY KEY CLUSTERED 
(
	[CurrentWorkloadReportParameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmailRecordAttachments]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailRecordAttachments](
	[EmailAttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[EmailRecordId] [int] NULL,
	[DocumentName] [varchar](250) NULL,
	[DocumentPath] [varchar](500) NULL,
 CONSTRAINT [PK_EmailRecordAttachments] PRIMARY KEY CLUSTERED 
(
	[EmailAttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmailRecords]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailRecords](
	[EmailRecordId] [int] IDENTITY(1,1) NOT NULL,
	[EmRecTo] [varchar](max) NULL,
	[EmRecCC] [varchar](max) NULL,
	[EmRecSubject] [varchar](256) NULL,
	[EmRecBody] [varchar](500) NULL,
	[EmailRecDate] [datetime] NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_EmailRecords] PRIMARY KEY CLUSTERED 
(
	[EmailRecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmailRFARequestLinks]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailRFARequestLinks](
	[EmailRFARequestID] [int] IDENTITY(1,1) NOT NULL,
	[EmailRecordId] [int] NOT NULL,
	[RFARequestID] [int] NOT NULL,
 CONSTRAINT [PK_EmailRFARequestLinks] PRIMARY KEY CLUSTERED 
(
	[EmailRFARequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Employers]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employers](
	[EmployerID] [int] IDENTITY(1,1) NOT NULL,
	[EmpName] [varchar](50) NOT NULL,
	[EmpAddress1] [varchar](50) NOT NULL,
	[EmpAddress2] [varchar](50) NULL,
	[EmpCity] [varchar](50) NOT NULL,
	[EmpStateID] [int] NOT NULL,
	[EmpZip] [varchar](10) NOT NULL,
	[EmpPhone] [varchar](14) NULL,
	[EmpFax] [varchar](14) NULL,
	[EmpEMail] [varchar](50) NULL,
	[EmpContactName] [varchar](20) NULL,
	[EmpPhoneExtension] [varchar](20) NULL,
 CONSTRAINT [PK_Employers] PRIMARY KEY CLUSTERED 
(
	[EmployerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmployerSubsidiaries]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployerSubsidiaries](
	[EMPSubsidiaryID] [int] IDENTITY(1,1) NOT NULL,
	[EmployerId] [int] NOT NULL,
	[EMPSubsidiaryName] [varchar](50) NOT NULL,
	[EMPSubsidiaryAddress] [varchar](50) NOT NULL,
	[EMPSubsidiaryAddress2] [varchar](50) NULL,
	[EMPSubsidiaryCity] [varchar](50) NOT NULL,
	[EMPSubsidiaryStateID] [int] NOT NULL,
	[EMPSubsidiaryZip] [varchar](50) NOT NULL,
	[EMPSubsidiaryPhone] [varchar](14) NULL,
	[EMPSubsidiaryFax] [varchar](14) NULL,
	[EMPSubsidiaryEmail] [varchar](50) NULL,
 CONSTRAINT [PK_EmployerSubsidiaries] PRIMARY KEY CLUSTERED 
(
	[EMPSubsidiaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IMRRFAReferrals]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IMRRFAReferrals](
	[IMRRFAReferralID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralID] [int] NULL,
	[IMRRFAClaimPhysicianID] [int] NULL,
	[IMRApplicationReceivedDate] [datetime] NULL,
	[IMRNoticeInformationDate] [datetime] NULL,
	[IMRCEReceivedDate] [datetime] NULL,
	[IMRInternalReceivedDate] [datetime] NULL,
	[IMRReceivedVia] [int] NULL,
	[IMRDecisionReceivedDate] [datetime] NULL,
	[IMRResponseDueDate] [datetime] NULL,
	[IMRPriority] [int] NULL,
	[IMRResponseType] [int] NULL,
	[IMRDecisionID] [int] NULL,
	[IMRResponseDate] [datetime] NULL,
 CONSTRAINT [PK_IMRRFAReferrals] PRIMARY KEY CLUSTERED 
(
	[IMRRFAReferralID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IMRRFARequests]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IMRRFARequests](
	[IMRRFARequestID] [int] IDENTITY(1,1) NOT NULL,
	[RFARequestID] [int] NULL,
	[Overturn] [bit] NULL,
	[IMRApprovedUnits] [int] NULL,
 CONSTRAINT [PK_IMRRFARequests] PRIMARY KEY CLUSTERED 
(
	[IMRRFARequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InsuranceBranches]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsuranceBranches](
	[InsuranceBranchID] [int] IDENTITY(1,1) NOT NULL,
	[InsurerId] [int] NOT NULL,
	[InsBranchName] [varchar](50) NOT NULL,
	[InsBranchAddress] [varchar](50) NOT NULL,
	[InsBranchCity] [varchar](50) NOT NULL,
	[InsBranchStateID] [int] NOT NULL,
	[InsBranchZip] [varchar](50) NOT NULL,
 CONSTRAINT [PK_InsuranceBranches] PRIMARY KEY CLUSTERED 
(
	[InsuranceBranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Insurers]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Insurers](
	[InsurerID] [int] IDENTITY(1,1) NOT NULL,
	[InsName] [varchar](50) NOT NULL,
	[InsAddress1] [varchar](50) NOT NULL,
	[InsAddress2] [varchar](50) NULL,
	[InsCity] [varchar](50) NOT NULL,
	[InsStateID] [int] NOT NULL,
	[InsZip] [varchar](10) NOT NULL,
	[InsPhone] [varchar](14) NULL,
	[InsFax] [varchar](14) NULL,
	[InsEMail] [varchar](50) NULL,
	[InsContactName] [varchar](20) NULL,
	[InsPhoneExtension] [varchar](50) NULL,
 CONSTRAINT [PK_Insurers] PRIMARY KEY CLUSTERED 
(
	[InsurerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ManagedCareCompanies]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ManagedCareCompanies](
	[CompanyID] [int] IDENTITY(1,1) NOT NULL,
	[CompName] [varchar](50) NOT NULL,
	[CompAddress] [varchar](50) NOT NULL,
	[CompAddress2] [varchar](50) NULL,
	[CompCity] [varchar](50) NOT NULL,
	[CompStateID] [int] NOT NULL,
	[CompZip] [varchar](10) NOT NULL,
 CONSTRAINT [PK_ManagedCareCompanies] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MedicalGroups]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalGroups](
	[MedicalGroupID] [int] IDENTITY(1,1) NOT NULL,
	[MedicalGroupName] [varchar](50) NOT NULL,
	[MGAddress] [varchar](50) NOT NULL,
	[MGAddress2] [varchar](50) NULL,
	[MGCity] [varchar](50) NOT NULL,
	[MGStateID] [int] NOT NULL,
	[MGZip] [varchar](10) NOT NULL,
	[MGNote] [varchar](max) NULL,
 CONSTRAINT [PK_MedicalGroups] PRIMARY KEY CLUSTERED 
(
	[MedicalGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Notes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notes](
	[NoteID] [int] IDENTITY(1,1) NOT NULL,
	[Notes] [varchar](max) NOT NULL,
	[UserID] [int] NOT NULL,
	[PatientClaimID] [int] NOT NULL,
	[RFARequestID] [int] NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Notes] PRIMARY KEY CLUSTERED 
(
	[NoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PatientClaimAddOnBodyParts]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientClaimAddOnBodyParts](
	[PatientClaimAddOnBodyPartID] [int] IDENTITY(1,1) NOT NULL,
	[PatientClaimID] [int] NOT NULL,
	[AddOnBodyPartID] [int] NOT NULL,
	[BodyPartStatusID] [int] NULL,
	[AcceptedDate] [datetime] NULL,
	[AddOnBodyPartCondition] [varchar](50) NULL,
 CONSTRAINT [PK_PatientAddOnBodyParts] PRIMARY KEY CLUSTERED 
(
	[PatientClaimAddOnBodyPartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PatientClaimDiagnoses]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientClaimDiagnoses](
	[PatientClaimDiagnosisID] [int] IDENTITY(1,1) NOT NULL,
	[PatientClaimID] [int] NOT NULL,
	[icdICDNumberID] [int] NOT NULL,
	[icdICDNumber] [char](6) NOT NULL,
	[icdICDTab] [char](10) NOT NULL,
 CONSTRAINT [PK_PatientClaimDiagnoses] PRIMARY KEY CLUSTERED 
(
	[PatientClaimDiagnosisID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PatientClaimPleadBodyParts]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientClaimPleadBodyParts](
	[PatientClaimPleadBodyPartID] [int] IDENTITY(1,1) NOT NULL,
	[PatientClaimID] [int] NOT NULL,
	[PleadBodyPartID] [int] NOT NULL,
	[BodyPartStatusID] [int] NULL,
	[AcceptedDate] [datetime] NULL,
	[PleadBodyPartCondition] [varchar](50) NULL,
 CONSTRAINT [PK_PatientPleadBodyParts] PRIMARY KEY CLUSTERED 
(
	[PatientClaimPleadBodyPartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PatientClaims]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientClaims](
	[PatientClaimID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[PatClaimNumber] [varchar](255) NOT NULL,
	[PatDOI] [datetime] NOT NULL,
	[PatPolicyYear] [char](4) NULL,
	[PatClaimJurisdictionID] [int] NOT NULL,
	[PatAdjudicationStateCaseNumber] [varchar](255) NULL,
	[PatEDIExchangeTrackingNumber] [varchar](255) NULL,
	[PatInjuryReportedDate] [datetime] NULL,
	[PatAdjusterID] [int] NULL,
	[PatApplicantAttorneyID] [int] NULL,
	[PatDefenseAttorneyID] [int] NULL,
	[PatClientID] [int] NULL,
	[PatPhysicianID] [int] NULL,
	[PatCaseManagerID] [int] NULL,
	[PatEmployerID] [int] NULL,
	[PatEmpSubsidiaryID] [int] NULL,
	[PatInsurerID] [int] NULL,
	[PatInsuranceBranchID] [int] NULL,
	[PatTPAID] [int] NULL,
	[PatTPABranchID] [int] NULL,
	[PatADRID] [int] NULL,
 CONSTRAINT [PK_PatientClaims] PRIMARY KEY CLUSTERED 
(
	[PatientClaimID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PatientClaimStatuses]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientClaimStatuses](
	[PatientClaimStatusID] [int] IDENTITY(1,1) NOT NULL,
	[PatientClaimID] [int] NOT NULL,
	[ClaimStatusID] [int] NOT NULL,
	[DeniedRationale] [varchar](max) NOT NULL,
 CONSTRAINT [PK_PatientClaimStatuses] PRIMARY KEY CLUSTERED 
(
	[PatientClaimStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PatientCurrentMedicalConditions]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientCurrentMedicalConditions](
	[PatCurrentMedicalConditionId] [int] IDENTITY(1,1) NOT NULL,
	[CurrentMedicalConditionId] [int] NOT NULL,
	[PatientID] [int] NOT NULL,
 CONSTRAINT [PK_PatientCurrentMedicalConditions] PRIMARY KEY CLUSTERED 
(
	[PatCurrentMedicalConditionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PatientOccupationals]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientOccupationals](
	[PatientOccupationalID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NULL,
	[PatOptJobTitle] [varchar](100) NULL,
	[PatOptJobDescription] [varchar](max) NULL,
	[PatOptInjuryType] [varchar](max) NULL,
	[PatOptInjuryDescription] [varchar](max) NULL,
 CONSTRAINT [PK_PatientOccupationals] PRIMARY KEY CLUSTERED 
(
	[PatientOccupationalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Patients]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patients](
	[PatientID] [int] IDENTITY(1,1) NOT NULL,
	[PatFirstName] [varchar](25) NOT NULL,
	[PatLastName] [varchar](25) NOT NULL,
	[PatSSN] [varchar](11) NULL,
	[PatDOB] [datetime] NOT NULL,
	[PatGender] [char](7) NOT NULL,
	[PatAddress1] [varchar](50) NOT NULL,
	[PatAddress2] [varchar](50) NULL,
	[PatCity] [varchar](50) NOT NULL,
	[PatStateID] [int] NOT NULL,
	[PatZip] [varchar](10) NOT NULL,
	[PatPhone] [varchar](14) NULL,
	[PatFax] [varchar](14) NULL,
	[PatEMail] [varchar](50) NULL,
	[PatEthnicBackground] [varchar](50) NULL,
	[PatPrimaryLanguageId] [int] NULL,
	[PatSecondaryLanguageId] [int] NULL,
	[PatMaritalStatus] [varchar](10) NULL,
	[PatMedicareEligible] [varchar](50) NULL,
 CONSTRAINT [PK_Patients] PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PeerReviews]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeerReviews](
	[PeerReviewID] [int] IDENTITY(1,1) NOT NULL,
	[PeerReviewEmail] [varchar](50) NOT NULL,
	[PeerReviewPhone] [varchar](14) NULL,
	[PeerReviewFax] [varchar](14) NULL,
	[PeerReviewName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_PeerReviews] PRIMARY KEY CLUSTERED 
(
	[PeerReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Physicians]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Physicians](
	[PhysicianId] [int] IDENTITY(1,1) NOT NULL,
	[PhysFirstName] [varchar](25) NOT NULL,
	[PhysLastName] [varchar](25) NOT NULL,
	[PhysQualification] [varchar](25) NULL,
	[PhysSpecialtyId] [int] NOT NULL,
	[PhysNPI] [char](10) NOT NULL,
	[PhysEMail] [varchar](50) NULL,
	[PhysNotes] [varchar](max) NULL,
	[PhysAddress1] [varchar](50) NOT NULL,
	[PhysAddress2] [varchar](50) NULL,
	[PhysCity] [varchar](50) NOT NULL,
	[PhysStateID] [int] NOT NULL,
	[PhysZip] [varchar](10) NOT NULL,
	[PhysPhone] [varchar](14) NULL,
	[PhysFax] [varchar](14) NULL,
 CONSTRAINT [PK_Physicians] PRIMARY KEY CLUSTERED 
(
	[PhysicianId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFAAdditionalInfoes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFAAdditionalInfoes](
	[RFAAdditionalInfoID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralID] [int] NULL,
	[RFAAdditionalInfoRecord] [varchar](100) NULL,
	[RFAAdditionalInfoRecordDate] [datetime] NULL,
 CONSTRAINT [PK_RFAAdditionalInfo] PRIMARY KEY CLUSTERED 
(
	[RFAAdditionalInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFADeletedRequests]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFADeletedRequests](
	[RFADeletedRequestID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralID] [int] NULL,
	[RFAOldRequestID] [int] NULL,
	[RFARequestedTreatment] [varchar](250) NULL,
	[RFAFrequency] [int] NULL,
	[RequestTypeID] [int] NULL,
	[RFADuration] [int] NULL,
	[RFAQuantity] [int] NULL,
	[TreatmentCategoryID] [int] NULL,
	[TreatmentTypeID] [int] NULL,
	[DecisionID] [int] NULL,
	[RFAExpediteReferral] [bit] NULL,
	[RFAStrenght] [varchar](50) NULL,
	[RFADurationTypeID] [int] NULL,
	[RFAStatus] [varchar](50) NULL,
	[RFANotes] [varchar](max) NULL,
	[RFAClinicalReasonforDecision] [varchar](max) NULL,
	[RFAGuidelinesUtilized] [varchar](max) NULL,
	[RFARelevantPortionUtilized] [varchar](max) NULL,
	[RFARequestDate] [datetime] NULL,
	[DecisionDate] [datetime] NULL,
	[RFAReqCertificationNumber] [varchar](50) NULL,
	[RFALatestDueDate] [datetime] NULL,
	[RFARequestIMRCreatedDate] [datetime] NULL,
 CONSTRAINT [PK_RFADeletedRequests] PRIMARY KEY CLUSTERED 
(
	[RFADeletedRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFAMergedReferralHistories]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFAMergedReferralHistories](
	[RFAMergedReferralID] [int] IDENTITY(1,1) NOT NULL,
	[RFAOldReferralID] [int] NULL,
	[RFANewReferralID] [int] NULL,
	[RFAMergedReferralDate] [datetime] NULL,
 CONSTRAINT [PK_RFAMergedReferralHistories] PRIMARY KEY CLUSTERED 
(
	[RFAMergedReferralID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFAPatMedicalRecordReviews]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFAPatMedicalRecordReviews](
	[RFAPatMedicalRecordReviewedID] [int] IDENTITY(1,1) NOT NULL,
	[RFARecSpltID] [int] NULL,
	[RFAReferralID] [int] NULL,
 CONSTRAINT [PK_RFAPatMedicalRecordReviews] PRIMARY KEY CLUSTERED 
(
	[RFAPatMedicalRecordReviewedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFAProcessLevels]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFAProcessLevels](
	[RFAProcessLevelID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralID] [int] NOT NULL,
	[ProcessLevel] [int] NOT NULL,
 CONSTRAINT [PK_RFAProcessLevels] PRIMARY KEY CLUSTERED 
(
	[RFAProcessLevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFARecordSplittings]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFARecordSplittings](
	[RFARecSpltID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralID] [int] NULL,
	[DocumentCategoryID] [int] NULL,
	[DocumentTypeID] [int] NULL,
	[RFARecDocumentName] [varchar](50) NULL,
	[RFARecDocumentDate] [date] NULL,
	[RFARecPageStart] [int] NULL,
	[RFARecPageEnd] [int] NULL,
	[RFARecSpltSummary] [varchar](max) NULL,
	[PatientClaimID] [int] NULL,
	[AuthorName] [varchar](50) NULL,
	[RFAFileName] [varchar](256) NULL,
	[RFAUploadDate] [datetime] NULL,
	[UserID] [int] NULL,
	[RFARequestID] [int] NULL,
 CONSTRAINT [PK_RFARecordSplitings] PRIMARY KEY CLUSTERED 
(
	[RFARecSpltID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFAReferralAdditionalInfoes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFAReferralAdditionalInfoes](
	[RFAReferralAdditionalInfoID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralID] [int] NOT NULL,
	[OriginalRFAReferralID] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RFAReferralAdditionalInfoes] PRIMARY KEY CLUSTERED 
(
	[RFAReferralAdditionalInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFAReferralAdditionalLinks]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFAReferralAdditionalLinks](
	[EmailRequestLinkID] [int] IDENTITY(1,1) NOT NULL,
	[EmailRecordId] [int] NOT NULL,
	[RFARequestID] [int] NOT NULL,
 CONSTRAINT [PK_RFAReferralAdditionalLinks] PRIMARY KEY CLUSTERED 
(
	[EmailRequestLinkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFAReferralFiles]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFAReferralFiles](
	[RFAReferralFileID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralID] [int] NOT NULL,
	[RFAFileTypeID] [int] NULL,
	[RFAReferralFileName] [varchar](256) NULL,
	[RFAFileCreationDate] [datetime] NULL,
	[RFAFileUserID] [int] NULL,
 CONSTRAINT [PK_RFAReferralFiles] PRIMARY KEY CLUSTERED 
(
	[RFAReferralFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFAReferralInvoices]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFAReferralInvoices](
	[RFAReferralInvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[PatientClaimID] [int] NULL,
	[InvoiceNumber] [varchar](max) NULL,
	[ClientID] [int] NULL,
	[InvoiceFileName] [varchar](200) NULL,
	[CreatedDate] [datetime] NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_ReferralInvoices] PRIMARY KEY CLUSTERED 
(
	[RFAReferralInvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFAReferrals]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFAReferrals](
	[RFAReferralID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralCreatedDate] [date] NOT NULL,
	[PatientClaimID] [int] NULL,
	[RFAReferralDate] [date] NULL,
	[RFACEDate] [date] NULL,
	[RFACETime] [varchar](15) NULL,
	[RFAHCRGDate] [date] NULL,
	[RFASignedByPhysician] [bit] NULL,
	[RFATreatmentRequestClear] [bit] NULL,
	[RFADiscrepancies] [varchar](max) NULL,
	[PhysicianID] [int] NULL,
	[EvaluationDate] [date] NULL,
	[EvaluatedBy] [varchar](25) NULL,
	[Credentials] [varchar](25) NULL,
	[InternalAppeal] [bit] NULL,
	[RFASignature] [varchar](max) NULL,
	[RFASignatureDescription] [varchar](max) NULL,
	[RFAIMRReferenceNumber] [varchar](25) NULL,
	[RFAIMRHistoryRationale] [varchar](max) NULL,
 CONSTRAINT [PK_RFAReferrals] PRIMARY KEY CLUSTERED 
(
	[RFAReferralID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFAReferralTimeExtensionHistories]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFAReferralTimeExtensionHistories](
	[RFAReferralTimeExtensionID] [int] IDENTITY(1,1) NOT NULL,
	[RFATimeExtensionUniqueID] [int] NULL,
	[RFAReferralID] [int] NULL,
	[RFARequestID] [int] NULL,
	[RFARequestDueDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_RFAReferralTimeExtensionHistories] PRIMARY KEY CLUSTERED 
(
	[RFAReferralTimeExtensionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFARequestAdditionalInfoes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFARequestAdditionalInfoes](
	[RFARequestAdditionalInfoID] [int] IDENTITY(1,1) NOT NULL,
	[RFARequestID] [int] NOT NULL,
	[URIncompleteRFAForm] [bit] NULL,
	[URNoRFAForm] [bit] NULL,
	[URDeclineInternalAppeal] [bit] NULL,
	[OriginalRFARequestID] [int] NULL,
 CONSTRAINT [PK_RFARequestAdditionalInfoes] PRIMARY KEY CLUSTERED 
(
	[RFARequestAdditionalInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFARequestBillings]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFARequestBillings](
	[RFARequestBillingID] [int] IDENTITY(1,1) NOT NULL,
	[RFARequestID] [int] NOT NULL,
	[RFARequestBillingRN] [money] NULL,
	[RFARequestBillingMD] [money] NULL,
	[RFARequestBillingSpeciality] [money] NULL,
	[RFARequestBillingAdmin] [money] NULL,
	[RFARequestBillingDeferral] [money] NULL,
 CONSTRAINT [PK_RFARequestBillings] PRIMARY KEY CLUSTERED 
(
	[RFARequestBillingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFARequestBodyParts]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFARequestBodyParts](
	[RFARequestBodyPartID] [int] IDENTITY(1,1) NOT NULL,
	[ClaimBodyPartID] [int] NULL,
	[BodyPartType] [varchar](10) NULL,
	[RFARequestID] [int] NULL,
 CONSTRAINT [PK_RFARequestBodyParts] PRIMARY KEY CLUSTERED 
(
	[RFARequestBodyPartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFARequestCPTCodes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFARequestCPTCodes](
	[RFACPTCodeID] [int] IDENTITY(1,1) NOT NULL,
	[RFARequestID] [int] NULL,
	[CPT_NDCCode] [varchar](50) NULL,
 CONSTRAINT [PK_RFAReferralCPTCodes] PRIMARY KEY CLUSTERED 
(
	[RFACPTCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFARequestModifies]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFARequestModifies](
	[RFARequestModifyID] [int] IDENTITY(1,1) NOT NULL,
	[RFARequestID] [int] NOT NULL,
	[RFARequestedTreatment] [varchar](250) NULL,
	[RFAFrequency] [int] NULL,
	[RFADuration] [int] NULL,
	[RFADurationTypeID] [int] NULL,
 CONSTRAINT [PK_RFARequestModifies] PRIMARY KEY CLUSTERED 
(
	[RFARequestModifyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFARequests]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFARequests](
	[RFARequestID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralID] [int] NULL,
	[RFARequestedTreatment] [varchar](250) NULL,
	[RFAFrequency] [int] NULL,
	[RequestTypeID] [int] NULL,
	[RFADuration] [int] NULL,
	[RFAQuantity] [int] NULL,
	[TreatmentCategoryID] [int] NULL,
	[TreatmentTypeID] [int] NULL,
	[DecisionID] [int] NULL,
	[RFAExpediteReferral] [bit] NULL,
	[RFAStrenght] [varchar](50) NULL,
	[RFADurationTypeID] [int] NULL,
	[RFAStatus] [varchar](50) NULL,
	[RFANotes] [varchar](max) NULL,
	[RFAClinicalReasonforDecision] [varchar](max) NULL,
	[RFAGuidelinesUtilized] [varchar](max) NULL,
	[RFARelevantPortionUtilized] [varchar](max) NULL,
	[RFARequestDate] [datetime] NULL,
	[DecisionDate] [datetime] NULL,
	[RFAReqCertificationNumber] [varchar](50) NULL,
	[RFALatestDueDate] [datetime] NULL,
	[RFARequestIMRCreatedDate] [datetime] NULL,
 CONSTRAINT [PK_RFARequests] PRIMARY KEY CLUSTERED 
(
	[RFARequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFARequestTimeExtensions]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFARequestTimeExtensions](
	[RFARequestTimeExtensionID] [int] IDENTITY(1,1) NOT NULL,
	[RFARecSpltID] [int] NOT NULL,
	[RFARequestID] [int] NOT NULL,
	[RFAReferralID] [int] NOT NULL,
	[RFIRecords] [varchar](50) NULL,
	[AdditionalExamination] [varchar](100) NULL,
	[SpecialtyConsult] [varchar](100) NULL,
 CONSTRAINT [PK_RFARequestTimeExtensions] PRIMARY KEY CLUSTERED 
(
	[RFARequestTimeExtensionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RFASplittedReferralHistories]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFASplittedReferralHistories](
	[RFASplittedReferralID] [int] IDENTITY(1,1) NOT NULL,
	[RFAOldReferralID] [int] NULL,
	[RFANewReferralID] [int] NULL,
	[RFASplittedReferralDate] [datetime] NULL,
 CONSTRAINT [PK_RFASplittedReferralHistories] PRIMARY KEY CLUSTERED 
(
	[RFASplittedReferralID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ThirdPartyAdministratorBranches]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThirdPartyAdministratorBranches](
	[TPABranchID] [int] IDENTITY(1,1) NOT NULL,
	[TPAID] [int] NOT NULL,
	[TPABranchName] [varchar](50) NOT NULL,
	[TPABranchAddress] [varchar](50) NOT NULL,
	[TPABranchAddress2] [varchar](50) NULL,
	[TPABranchCity] [varchar](50) NOT NULL,
	[TPABranchStateID] [int] NOT NULL,
	[TPABranchZip] [varchar](10) NOT NULL,
	[TPABranchPhone] [varchar](14) NULL,
	[TPABranchFax] [varchar](14) NULL,
 CONSTRAINT [PK_ThirdPartyAdministratorBranches] PRIMARY KEY CLUSTERED 
(
	[TPABranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ThirdPartyAdministrators]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThirdPartyAdministrators](
	[TPAID] [int] IDENTITY(1,1) NOT NULL,
	[TPAName] [varchar](50) NOT NULL,
	[TPAAddress] [varchar](50) NOT NULL,
	[TPAAddress2] [varchar](50) NULL,
	[TPACity] [varchar](50) NOT NULL,
	[TPAStateID] [int] NOT NULL,
	[TPAZip] [varchar](10) NOT NULL,
	[TPAPhone] [varchar](14) NULL,
	[TPAFax] [varchar](14) NULL,
 CONSTRAINT [PK_ThirdPartyAdministrator] PRIMARY KEY CLUSTERED 
(
	[TPAID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[UserFirstName] [varchar](50) NOT NULL,
	[UserLastName] [varchar](50) NOT NULL,
	[UserPassword] [varchar](200) NOT NULL,
	[UserPhone] [varchar](14) NOT NULL,
	[UserFax] [varchar](14) NOT NULL,
	[UserEmail] [varchar](50) NOT NULL,
	[UserSignatureFileName] [varchar](50) NULL,
	[UserDeletePermission] [bit] NULL,
	[UserManagementPermission] [bit] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Vendors]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vendors](
	[VendorID] [int] IDENTITY(1,1) NOT NULL,
	[VendorName] [varchar](50) NOT NULL,
	[VendorTax] [varchar](10) NULL,
	[VendorAddress1] [varchar](50) NOT NULL,
	[VendorAddress2] [varchar](50) NULL,
	[VendorCity] [varchar](50) NOT NULL,
	[VendorStateID] [int] NOT NULL,
	[VendorZip] [varchar](10) NOT NULL,
	[VendorPhone] [varchar](14) NULL,
	[VendorFax] [varchar](14) NULL,
 CONSTRAINT [PK_Vendors] PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [link].[RFAReferralAdditionalLinks]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[RFAReferralAdditionalLinks](
	[RFAReferralAdditionalInfoID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralID] [int] NOT NULL,
	[RFAReferralInvoiceID] [int] NULL,
	[ClientStatementID] [int] NULL,
 CONSTRAINT [PK_RFAReferralAdditionalInfo] PRIMARY KEY CLUSTERED 
(
	[RFAReferralAdditionalInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [link].[RFARequestTimeExtensionRecords]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[RFARequestTimeExtensionRecords](
	[RFARequestTimeExtensionID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralFileID] [int] NULL,
	[RFAReferralID] [int] NULL,
	[RFARequestID] [int] NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_RFARequestTimeExtensionRecords] PRIMARY KEY CLUSTERED 
(
	[RFARequestTimeExtensionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [link].[RFIReportRFAAdditionalRecords]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[RFIReportRFAAdditionalRecords](
	[RFIReportAdditionalRecordID] [int] IDENTITY(1,1) NOT NULL,
	[RFAAdditionalInfoID] [int] NULL,
	[RFAReferralID] [int] NULL,
	[RFARequestID] [int] NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_RFIReportAdditionalRecords] PRIMARY KEY CLUSTERED 
(
	[RFIReportAdditionalRecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [link].[RFIRFARequestRecords]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [link].[RFIRFARequestRecords](
	[RFIRFARequestRecordID] [int] IDENTITY(1,1) NOT NULL,
	[RFAReferralFileID] [int] NULL,
	[RFAReferralID] [int] NULL,
	[RFARequestID] [int] NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_RFIRFARequestRecords] PRIMARY KEY CLUSTERED 
(
	[RFIRFARequestRecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[AttorneyFirmTypes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[AttorneyFirmTypes](
	[AttorneyFirmTypeID] [int] IDENTITY(1,1) NOT NULL,
	[AttorneyFirmTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_AttorneyFirmTypes] PRIMARY KEY CLUSTERED 
(
	[AttorneyFirmTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[BillingRateTypes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[BillingRateTypes](
	[BillingRateTypeID] [int] IDENTITY(1,1) NOT NULL,
	[BillingRateTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_BillingRateType] PRIMARY KEY CLUSTERED 
(
	[BillingRateTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[BodyParts]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[BodyParts](
	[BodyPartID] [int] IDENTITY(1,1) NOT NULL,
	[BodyPartName] [varchar](64) NOT NULL,
 CONSTRAINT [PK_tblBodyPart] PRIMARY KEY CLUSTERED 
(
	[BodyPartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[BodyPartStatuses]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[BodyPartStatuses](
	[BodyPartStatusID] [int] IDENTITY(1,1) NOT NULL,
	[BodyPartStatusName] [varchar](50) NULL,
 CONSTRAINT [PK_BodyPartStatuses] PRIMARY KEY CLUSTERED 
(
	[BodyPartStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[ClaimStatuses]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[ClaimStatuses](
	[ClaimStatusID] [int] IDENTITY(1,1) NOT NULL,
	[ClaimStatusName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ClaimStatuses] PRIMARY KEY CLUSTERED 
(
	[ClaimStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[CurrentMedicalConditions]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[CurrentMedicalConditions](
	[CurrentMedicalConditionId] [int] IDENTITY(1,1) NOT NULL,
	[CurrentMedicalConditionName] [varchar](255) NOT NULL,
 CONSTRAINT [PK_CurrentMedicalConditions] PRIMARY KEY CLUSTERED 
(
	[CurrentMedicalConditionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[Decisions]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[Decisions](
	[DecisionID] [int] IDENTITY(1,1) NOT NULL,
	[DecisionDesc] [varchar](25) NULL,
 CONSTRAINT [PK_Decisions] PRIMARY KEY CLUSTERED 
(
	[DecisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[DocumentCategories]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[DocumentCategories](
	[DocumentCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[DocumentCategoryName] [varchar](50) NULL,
 CONSTRAINT [PK_DocumentCategories] PRIMARY KEY CLUSTERED 
(
	[DocumentCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[DocumentTypes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[DocumentTypes](
	[DocumentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[DocumentTypeDesc] [varchar](50) NULL,
	[DocumentCategoryID] [int] NOT NULL,
 CONSTRAINT [PK_DocumentTypes_1] PRIMARY KEY CLUSTERED 
(
	[DocumentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[DurationTypes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[DurationTypes](
	[DurationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[DurationTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_Durations] PRIMARY KEY CLUSTERED 
(
	[DurationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[FileTypes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[FileTypes](
	[FileTypeID] [int] IDENTITY(1,1) NOT NULL,
	[FileTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_FileTypes] PRIMARY KEY CLUSTERED 
(
	[FileTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[FrequencyTypes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[FrequencyTypes](
	[FrequencyTypeID] [int] NOT NULL,
	[FrequencyTypeName] [varchar](250) NULL,
 CONSTRAINT [PK_FrequencyTypes] PRIMARY KEY CLUSTERED 
(
	[FrequencyTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[Holidays]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[Holidays](
	[HolidayID] [int] IDENTITY(1,1) NOT NULL,
	[HolidayName] [varchar](50) NOT NULL,
	[HolidayDate] [datetime] NULL,
 CONSTRAINT [PK__Holidays__2D35D59A310335E5] PRIMARY KEY CLUSTERED 
(
	[HolidayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[ICD10Codes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[ICD10Codes](
	[icdICD10NumberID] [int] IDENTITY(1,1) NOT NULL,
	[icdICD10Number] [char](6) NOT NULL,
	[ICD10Description] [varchar](max) NOT NULL,
 CONSTRAINT [PK_ICD10Codes] PRIMARY KEY CLUSTERED 
(
	[icdICD10NumberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [lookup].[ICD9Codes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[ICD9Codes](
	[icdICD9NumberID] [int] IDENTITY(1,1) NOT NULL,
	[icdICD9Number] [char](6) NOT NULL,
	[ICD9Description] [varchar](255) NOT NULL,
	[ICD9Type] [char](1) NULL,
 CONSTRAINT [PK_ICD9Codes] PRIMARY KEY CLUSTERED 
(
	[icdICD9NumberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[IMRDecision]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[IMRDecision](
	[IMRDecisionID] [int] IDENTITY(1,1) NOT NULL,
	[IMRDecisionDesc] [varchar](50) NULL,
 CONSTRAINT [PK_IMRDecision] PRIMARY KEY CLUSTERED 
(
	[IMRDecisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[IMRResponseLetterCheckLists]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[IMRResponseLetterCheckLists](
	[IMRMedicalRecordSubmittedID] [int] IDENTITY(1,1) NOT NULL,
	[IMRMedicalRecordSubmittedDesc] [varchar](1024) NULL,
 CONSTRAINT [PK_IMRResponseLetterCheckLists] PRIMARY KEY CLUSTERED 
(
	[IMRMedicalRecordSubmittedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[IMRResponseLetterDocumentRelations]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[IMRResponseLetterDocumentRelations](
	[IMRResponseLetterDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[IMRMedicalRecordSubmittedID] [int] NOT NULL,
	[DocumentTypeID] [int] NULL,
	[DocumentTableName] [varchar](1) NULL,
 CONSTRAINT [PK_IMRResponseLetterDocumentRelations] PRIMARY KEY CLUSTERED 
(
	[IMRResponseLetterDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[Languages]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[Languages](
	[LanguageID] [int] IDENTITY(1,1) NOT NULL,
	[LanguageName] [varchar](64) NOT NULL,
 CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[ProcessLevels]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[ProcessLevels](
	[ProcessLevel] [int] NOT NULL,
	[ProcessLevelDesc] [varchar](50) NULL,
 CONSTRAINT [PK_ProcessLevels] PRIMARY KEY CLUSTERED 
(
	[ProcessLevel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[RequestTypes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[RequestTypes](
	[RequestTypeID] [int] NOT NULL,
	[RequestTypeName] [int] NULL,
	[RequestTypeDesc] [varchar](50) NULL,
 CONSTRAINT [PK_RequestType] PRIMARY KEY CLUSTERED 
(
	[RequestTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[Specialties]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[Specialties](
	[SpecialtyID] [int] IDENTITY(1,1) NOT NULL,
	[SpecialtyName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Specialties] PRIMARY KEY CLUSTERED 
(
	[SpecialtyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[States]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[States](
	[StateId] [int] IDENTITY(1,1) NOT NULL,
	[StateName] [char](2) NOT NULL,
 CONSTRAINT [PK_States] PRIMARY KEY CLUSTERED 
(
	[StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[Statuses]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[Statuses](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](30) NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[TreatmentCategories]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[TreatmentCategories](
	[TreatmentCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[TreatmentCategoryName] [varchar](50) NULL,
 CONSTRAINT [PK_TreatmentCategories] PRIMARY KEY CLUSTERED 
(
	[TreatmentCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [lookup].[TreatmentTypes]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lookup].[TreatmentTypes](
	[TreatmentTypeID] [int] NOT NULL,
	[TreatmentCategoryID] [int] NULL,
	[TreatmentTypeDesc] [varchar](100) NULL,
	[RFARequestBillingRN] [decimal](18, 2) NULL,
	[RFARequestBillingMD] [decimal](18, 2) NULL,
	[RFARequestBillingPR] [decimal](18, 2) NULL,
	[RFARequestBillingAdmin] [decimal](18, 2) NULL,
	[EstCost] [money] NULL,
	[TreatmentMDRequired] [bit] NOT NULL,
	[TreatmentDescNumber] [varchar](10) NULL,
 CONSTRAINT [PK_TreatmentTypes] PRIMARY KEY CLUSTERED 
(
	[TreatmentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [global].[Get_ClaimAdministratorFieldsAccToClientNameAndClaimAdminstratorID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [global].[Get_ClaimAdministratorFieldsAccToClientNameAndClaimAdminstratorID] --Mahinder Singh/01 APR 2016
(    
    @ClientName VARCHAR(50) ,
    @ClaimAdministratorID INT,
    @PatientClaimID INT
) 
RETURNS TABLE
AS
RETURN
(
   SELECT ClientAdminName,ClientAdminAddress,ClientAdminCity,States.StateName As ClientStateName,ClientAdminZip
FROM(SELECT 
        (CASE  
           WHEN LTRIM(RTRIM(ClaimAdministratorType)) ='emp'  THEN (SELECT ISNULL(EmpName,'') AS EmpName FROM Employers WHERE EmployerID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'ins'  THEN (SELECT ISNULL(InsName,'') AS InsName FROM Insurers WHERE InsurerID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'insb' THEN (SELECT ISNULL(InsBranchName,'') AS InsBranchName FROM InsuranceBranches  WHERE InsuranceBranchID =@ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'tpa' THEN (SELECT ISNULL(TPAName,'') AS TPAName FROM ThirdPartyAdministrators  WHERE TPAID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'tpab' THEN (SELECT ISNULL(TPABranchName,'') AS TPABranchName FROM ThirdPartyAdministratorBranches  WHERE TPABranchID = @ClaimAdministratorID)
           ELSE (SELECT ISNULL(CompName,'') AS CompName FROM ManagedCareCompanies WHERE CompanyID = @ClaimAdministratorID)END) AS ClientAdminName
           ,(CASE  
           WHEN LTRIM(RTRIM(ClaimAdministratorType)) ='emp'  THEN (SELECT (EmpAddress1+' '+ISNULL(EmpAddress2,'')) AS EmpAddress FROM Employers WHERE EmployerID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'ins'  THEN (SELECT (InsAddress1+' '+ISNULL(InsAddress2,'')) AS InsAddress FROM Insurers WHERE InsurerID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'insb' THEN (SELECT InsBranchAddress FROM InsuranceBranches  WHERE InsuranceBranchID =@ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'tpa' THEN (SELECT (TPAAddress+' '+ISNULL(TPAAddress2,'')) AS TpaAddress FROM ThirdPartyAdministrators  WHERE TPAID =@ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'tpab' THEN (SELECT (TPABranchAddress+ ' '+ISNULL(TPABranchAddress2,'')) AS TPABranchAddress FROM ThirdPartyAdministratorBranches  WHERE TPABranchID = @ClaimAdministratorID)
           ELSE (SELECT (CompAddress+' '+ISNULL(CompAddress2,'')) AS CompAddress FROM ManagedCareCompanies WHERE CompanyID = @ClaimAdministratorID)END) AS ClientAdminAddress
           ,(CASE  
           WHEN LTRIM(RTRIM(ClaimAdministratorType)) ='emp'  THEN (SELECT EmpCity FROM Employers WHERE EmployerID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'ins'  THEN (SELECT InsCity FROM Insurers WHERE InsurerID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'insb' THEN (SELECT InsBranchCity FROM InsuranceBranches  WHERE InsuranceBranchID =@ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'tpa' THEN (SELECT  TPACity FROM ThirdPartyAdministrators  WHERE TPAID =@ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'tpab' THEN (SELECT TPABranchCity AS TPABranchCity FROM ThirdPartyAdministratorBranches  WHERE TPABranchID = @ClaimAdministratorID) 
           ELSE (SELECT CompCity FROM ManagedCareCompanies WHERE CompanyID = @ClaimAdministratorID)END) AS ClientAdminCity
           ,(CASE  
           WHEN LTRIM(RTRIM(ClaimAdministratorType)) ='emp'  THEN (SELECT EmpStateID FROM Employers WHERE EmployerID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'ins'  THEN (SELECT InsStateID FROM Insurers WHERE InsurerID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'insb' THEN (SELECT InsBranchStateID FROM InsuranceBranches  WHERE InsuranceBranchID =@ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'tpa' THEN (SELECT TPAStateID FROM ThirdPartyAdministrators  WHERE TPAID =@ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'tpab' THEN (SELECT TPABranchStateID AS TPABranchStateID FROM ThirdPartyAdministratorBranches  WHERE TPABranchID = @ClaimAdministratorID)
           ELSE (SELECT CompStateID FROM ManagedCareCompanies WHERE CompanyID = @ClaimAdministratorID)END) AS ClientAdminStateID
           ,(CASE  
           WHEN LTRIM(RTRIM(ClaimAdministratorType)) ='emp'  THEN (SELECT EmpZip FROM Employers WHERE EmployerID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'ins'  THEN (SELECT InsZip FROM Insurers WHERE InsurerID = @ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'insb' THEN (SELECT InsBranchZip FROM InsuranceBranches  WHERE InsuranceBranchID =@ClaimAdministratorID)
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'tpa' THEN (SELECT TPAZip FROM ThirdPartyAdministrators  WHERE TPAID =@ClaimAdministratorID)          
           WHEN LTRIM(RTRIM(ClaimAdministratorType))= 'tpab' THEN (SELECT TPABranchZip AS TPABranchZip FROM ThirdPartyAdministratorBranches  WHERE TPABranchID = @ClaimAdministratorID)
           ELSE (SELECT CompZip FROM ManagedCareCompanies WHERE CompanyID = @ClaimAdministratorID)END) AS ClientAdminZip
 FROM [MMC].[dbo].[Clients] 
 INNER JOIN PatientClaims pc ON pc.PatClientID = Clients.ClientID 
 WHERE ClientName = @ClientName AND pc.PatientClaimID = @PatientClaimID)T  
 INNER JOIN lookup.States ON States.StateId = t.ClientAdminStateID
)  

GO
/****** Object:  UserDefinedFunction [global].[Get_FieldsFromRFARequests]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [global].[Get_FieldsFromRFARequests] --Mahinder Singh/01 FEB 2016
(    
    @referralID INT 
) 
RETURNS TABLE
AS
RETURN
(
    SELECT Decisions.DecisionDesc,T.DecisionID,T.DecisionDate,T.RFARequestID,T.RFAReqCertificationNumber,T.RFARequestedTreatment
			  FROM (
						SELECT RFARequests.DecisionID,RFARequests.DecisionDate ,RFARequests.RFARequestID ,
						       RFARequests.RFAReqCertificationNumber,RFARequests.RFARequestedTreatment   
						FROM   [dbo].[RFARequests] 
						WHERE 
							   RFARequests.RFARequestID IN(SELECT RFARequestAdditionalInfoes.OriginalRFARequestID FROM dbo.RFARequestAdditionalInfoes
														  WHERE  
																 RFARequestAdditionalInfoes.RFARequestID IN(SELECT  RFARequests.RFARequestID 
																													FROM    [MMC].[dbo].[RFARequests] 
																													WHERE    RFARequests.RFAReferralID = @referralID))
						)T 
						INNER JOIN 	 lookup.Decisions ON Decisions.DecisionID = T.DecisionID
)  

GO
/****** Object:  UserDefinedFunction [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID] --Harpreet Singh/17 March 2016
(    
    @RFAReferralID INT 
) 
RETURNS TABLE
AS
RETURN
(
    
    with name_tree as 
(
   select RFAOldReferralID,RFANewReferralID
   from RFASplittedReferralHistories
   where RFANewReferralID in
   
   (SELECT     RFAReferralID 
	FROM         RFAReferrals
	where PatientClaimID in (
	SELECT     PatientClaims.PatientClaimID
	FROM         RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID where RFAReferrals.RFAReferralID = @RFAReferralID))
   
   
   -- @RFAReferralID
   union all
   select C.RFAOldReferralID,C.RFANewReferralID
   from RFASplittedReferralHistories c
   join name_tree p on C.RFANewReferralID = P.RFAOldReferralID 

    AND C.RFAOldReferralID<>C.RFANewReferralID 
) 
SELECT distinct RFAOldReferralID FROM name_tree
)  

GO
/****** Object:  Index [IX_Users]    Script Date: 10-02-2020 15:57:36 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users] ON [dbo].[Users]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientBillingRetailRates] ADD  CONSTRAINT [DF_ClientBillingRates_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[ClientBillingWholesaleRates] ADD  CONSTRAINT [DF_ClientBillingWholesaleRates_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[RFAMergedReferralHistories] ADD  CONSTRAINT [DF_RFAMergedReferralHistories_RFAMergedReferralDate]  DEFAULT (getdate()) FOR [RFAMergedReferralDate]
GO
ALTER TABLE [dbo].[RFARecordSplittings] ADD  CONSTRAINT [DF_RFARecordSplittings_PatientClaimID]  DEFAULT ((0)) FOR [PatientClaimID]
GO
ALTER TABLE [dbo].[RFAReferralInvoices] ADD  CONSTRAINT [DF_RFAReferralInvoices_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [lookup].[TreatmentTypes] ADD  CONSTRAINT [DF_TreatmentTypes_TreatmentMDRequired]  DEFAULT ((0)) FOR [TreatmentMDRequired]
GO
ALTER TABLE [dbo].[Adjusters]  WITH CHECK ADD  CONSTRAINT [FK_Adjusters_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[Adjusters] CHECK CONSTRAINT [FK_Adjusters_Clients]
GO
ALTER TABLE [dbo].[Adjusters]  WITH CHECK ADD  CONSTRAINT [FK_Adjusters_States] FOREIGN KEY([AdjStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[Adjusters] CHECK CONSTRAINT [FK_Adjusters_States]
GO
ALTER TABLE [dbo].[ADRs]  WITH CHECK ADD  CONSTRAINT [FK_ADRs_States] FOREIGN KEY([ADRID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[ADRs] CHECK CONSTRAINT [FK_ADRs_States]
GO
ALTER TABLE [dbo].[AttorneyFirms]  WITH CHECK ADD  CONSTRAINT [FK_AttorneyFirms_AttorneyFirmTypes] FOREIGN KEY([AttorneyFirmTypeID])
REFERENCES [lookup].[AttorneyFirmTypes] ([AttorneyFirmTypeID])
GO
ALTER TABLE [dbo].[AttorneyFirms] CHECK CONSTRAINT [FK_AttorneyFirms_AttorneyFirmTypes]
GO
ALTER TABLE [dbo].[AttorneyFirms]  WITH CHECK ADD  CONSTRAINT [FK_AttorneyFirms_States] FOREIGN KEY([AttStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[AttorneyFirms] CHECK CONSTRAINT [FK_AttorneyFirms_States]
GO
ALTER TABLE [dbo].[Attorneys]  WITH CHECK ADD  CONSTRAINT [FK_Attorneys_AttorneyFirms] FOREIGN KEY([AttorneyFirmID])
REFERENCES [dbo].[AttorneyFirms] ([AttorneyFirmID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Attorneys] CHECK CONSTRAINT [FK_Attorneys_AttorneyFirms]
GO
ALTER TABLE [dbo].[CaseManagers]  WITH CHECK ADD  CONSTRAINT [FK_CaseManagers_States] FOREIGN KEY([CMStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[CaseManagers] CHECK CONSTRAINT [FK_CaseManagers_States]
GO
ALTER TABLE [dbo].[ClientBillingRetailRates]  WITH CHECK ADD  CONSTRAINT [FK_ClientBillingRetailRates_ClientBillings] FOREIGN KEY([ClientBillingID])
REFERENCES [dbo].[ClientBillings] ([ClientBillingID])
GO
ALTER TABLE [dbo].[ClientBillingRetailRates] CHECK CONSTRAINT [FK_ClientBillingRetailRates_ClientBillings]
GO
ALTER TABLE [dbo].[ClientBillingRetailRates]  WITH CHECK ADD  CONSTRAINT [FK_ClientBillingRetailRates_Users] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[ClientBillingRetailRates] CHECK CONSTRAINT [FK_ClientBillingRetailRates_Users]
GO
ALTER TABLE [dbo].[ClientBillings]  WITH CHECK ADD  CONSTRAINT [FK_ClientBillings_BillingRateTypes] FOREIGN KEY([ClientBillingRateTypeID])
REFERENCES [lookup].[BillingRateTypes] ([BillingRateTypeID])
GO
ALTER TABLE [dbo].[ClientBillings] CHECK CONSTRAINT [FK_ClientBillings_BillingRateTypes]
GO
ALTER TABLE [dbo].[ClientBillings]  WITH CHECK ADD  CONSTRAINT [FK_ClientBillings_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientBillings] CHECK CONSTRAINT [FK_ClientBillings_Clients]
GO
ALTER TABLE [dbo].[ClientBillingWholesaleRates]  WITH CHECK ADD  CONSTRAINT [FK_ClientBillingWholesaleRates_ClientBillings] FOREIGN KEY([ClientBillingID])
REFERENCES [dbo].[ClientBillings] ([ClientBillingID])
GO
ALTER TABLE [dbo].[ClientBillingWholesaleRates] CHECK CONSTRAINT [FK_ClientBillingWholesaleRates_ClientBillings]
GO
ALTER TABLE [dbo].[ClientBillingWholesaleRates]  WITH CHECK ADD  CONSTRAINT [FK_ClientBillingWholesaleRates_Users] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[ClientBillingWholesaleRates] CHECK CONSTRAINT [FK_ClientBillingWholesaleRates_Users]
GO
ALTER TABLE [dbo].[ClientEmployers]  WITH CHECK ADD  CONSTRAINT [FK_ClientEmployers_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientEmployers] CHECK CONSTRAINT [FK_ClientEmployers_Clients]
GO
ALTER TABLE [dbo].[ClientEmployers]  WITH CHECK ADD  CONSTRAINT [FK_ClientEmployers_Employers] FOREIGN KEY([EmployerID])
REFERENCES [dbo].[Employers] ([EmployerID])
GO
ALTER TABLE [dbo].[ClientEmployers] CHECK CONSTRAINT [FK_ClientEmployers_Employers]
GO
ALTER TABLE [dbo].[ClientInsuranceBranches]  WITH CHECK ADD  CONSTRAINT [FK_ClientInsuranceBranches_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientInsuranceBranches] CHECK CONSTRAINT [FK_ClientInsuranceBranches_Clients]
GO
ALTER TABLE [dbo].[ClientInsuranceBranches]  WITH CHECK ADD  CONSTRAINT [FK_ClientInsuranceBranches_InsuranceBranches] FOREIGN KEY([InsuranceBranchID])
REFERENCES [dbo].[InsuranceBranches] ([InsuranceBranchID])
GO
ALTER TABLE [dbo].[ClientInsuranceBranches] CHECK CONSTRAINT [FK_ClientInsuranceBranches_InsuranceBranches]
GO
ALTER TABLE [dbo].[ClientInsuranceBranches]  WITH CHECK ADD  CONSTRAINT [FK_ClientInsuranceBranches_Insurers] FOREIGN KEY([InsurerID])
REFERENCES [dbo].[Insurers] ([InsurerID])
GO
ALTER TABLE [dbo].[ClientInsuranceBranches] CHECK CONSTRAINT [FK_ClientInsuranceBranches_Insurers]
GO
ALTER TABLE [dbo].[ClientInsurers]  WITH CHECK ADD  CONSTRAINT [FK_ClientInsurers_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientInsurers] CHECK CONSTRAINT [FK_ClientInsurers_Clients]
GO
ALTER TABLE [dbo].[ClientInsurers]  WITH CHECK ADD  CONSTRAINT [FK_ClientInsurers_Insurers] FOREIGN KEY([InsurerID])
REFERENCES [dbo].[Insurers] ([InsurerID])
GO
ALTER TABLE [dbo].[ClientInsurers] CHECK CONSTRAINT [FK_ClientInsurers_Insurers]
GO
ALTER TABLE [dbo].[ClientManagedCareCompanies]  WITH CHECK ADD  CONSTRAINT [FK_ClientManagedCareCompanies_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientManagedCareCompanies] CHECK CONSTRAINT [FK_ClientManagedCareCompanies_Clients]
GO
ALTER TABLE [dbo].[ClientManagedCareCompanies]  WITH CHECK ADD  CONSTRAINT [FK_ClientManagedCareCompanies_ManagedCareCompanies] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[ManagedCareCompanies] ([CompanyID])
GO
ALTER TABLE [dbo].[ClientManagedCareCompanies] CHECK CONSTRAINT [FK_ClientManagedCareCompanies_ManagedCareCompanies]
GO
ALTER TABLE [dbo].[ClientPrivateLabels]  WITH CHECK ADD  CONSTRAINT [FK_ClientPrivateLabels_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientPrivateLabels] CHECK CONSTRAINT [FK_ClientPrivateLabels_Clients]
GO
ALTER TABLE [dbo].[ClientPrivateLabels]  WITH CHECK ADD  CONSTRAINT [FK_ClientPrivateLabels_States] FOREIGN KEY([ClientPrivateLabelStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[ClientPrivateLabels] CHECK CONSTRAINT [FK_ClientPrivateLabels_States]
GO
ALTER TABLE [dbo].[ClientStatements]  WITH CHECK ADD  CONSTRAINT [FK_ClientStatements_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[ClientStatements] CHECK CONSTRAINT [FK_ClientStatements_Users]
GO
ALTER TABLE [dbo].[ClientThirdPartyAdministratorBranches]  WITH CHECK ADD  CONSTRAINT [FK_ClientThirdPartyAdministratorBranches_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientThirdPartyAdministratorBranches] CHECK CONSTRAINT [FK_ClientThirdPartyAdministratorBranches_Clients]
GO
ALTER TABLE [dbo].[ClientThirdPartyAdministratorBranches]  WITH CHECK ADD  CONSTRAINT [FK_ClientThirdPartyAdministratorBranches_ThirdPartyAdministratorBranches] FOREIGN KEY([TPABranchID])
REFERENCES [dbo].[ThirdPartyAdministratorBranches] ([TPABranchID])
GO
ALTER TABLE [dbo].[ClientThirdPartyAdministratorBranches] CHECK CONSTRAINT [FK_ClientThirdPartyAdministratorBranches_ThirdPartyAdministratorBranches]
GO
ALTER TABLE [dbo].[ClientThirdPartyAdministratorBranches]  WITH CHECK ADD  CONSTRAINT [FK_ClientThirdPartyAdministratorBranches_ThirdPartyAdministrators] FOREIGN KEY([TPAID])
REFERENCES [dbo].[ThirdPartyAdministrators] ([TPAID])
GO
ALTER TABLE [dbo].[ClientThirdPartyAdministratorBranches] CHECK CONSTRAINT [FK_ClientThirdPartyAdministratorBranches_ThirdPartyAdministrators]
GO
ALTER TABLE [dbo].[ClientThirdPartyAdministrators]  WITH CHECK ADD  CONSTRAINT [FK_ClientThirdPartyAdministrators_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[ClientThirdPartyAdministrators] CHECK CONSTRAINT [FK_ClientThirdPartyAdministrators_Clients]
GO
ALTER TABLE [dbo].[ClientThirdPartyAdministrators]  WITH CHECK ADD  CONSTRAINT [FK_ClientThirdPartyAdministrators_ThirdPartyAdministrators] FOREIGN KEY([TPAID])
REFERENCES [dbo].[ThirdPartyAdministrators] ([TPAID])
GO
ALTER TABLE [dbo].[ClientThirdPartyAdministrators] CHECK CONSTRAINT [FK_ClientThirdPartyAdministrators_ThirdPartyAdministrators]
GO
ALTER TABLE [dbo].[CurrentWorkloadReportParameters]  WITH CHECK ADD  CONSTRAINT [FK_CurrentWorkloadParameters_CurrentWorkloadParameters] FOREIGN KEY([CurrentWorkloadReportParameterID])
REFERENCES [dbo].[CurrentWorkloadReportParameters] ([CurrentWorkloadReportParameterID])
GO
ALTER TABLE [dbo].[CurrentWorkloadReportParameters] CHECK CONSTRAINT [FK_CurrentWorkloadParameters_CurrentWorkloadParameters]
GO
ALTER TABLE [dbo].[CurrentWorkloadReportParameters]  WITH CHECK ADD  CONSTRAINT [FK_CurrentWorkloadReportParameters_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[CurrentWorkloadReportParameters] CHECK CONSTRAINT [FK_CurrentWorkloadReportParameters_Clients]
GO
ALTER TABLE [dbo].[CurrentWorkloadReportParameters]  WITH CHECK ADD  CONSTRAINT [FK_CurrentWorkloadReportParameters_CurrentWorkloadReport] FOREIGN KEY([CurrentWorkloadReportID])
REFERENCES [dbo].[CurrentWorkloadReport] ([CurrentWorkloadReportID])
GO
ALTER TABLE [dbo].[CurrentWorkloadReportParameters] CHECK CONSTRAINT [FK_CurrentWorkloadReportParameters_CurrentWorkloadReport]
GO
ALTER TABLE [dbo].[CurrentWorkloadReportParameters]  WITH CHECK ADD  CONSTRAINT [FK_CurrentWorkloadReportParameters_Statuses] FOREIGN KEY([StatusID])
REFERENCES [lookup].[Statuses] ([StatusID])
GO
ALTER TABLE [dbo].[CurrentWorkloadReportParameters] CHECK CONSTRAINT [FK_CurrentWorkloadReportParameters_Statuses]
GO
ALTER TABLE [dbo].[EmailRecordAttachments]  WITH CHECK ADD  CONSTRAINT [FK_EmailRecordAttachments_EmailRecords] FOREIGN KEY([EmailRecordId])
REFERENCES [dbo].[EmailRecords] ([EmailRecordId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EmailRecordAttachments] CHECK CONSTRAINT [FK_EmailRecordAttachments_EmailRecords]
GO
ALTER TABLE [dbo].[EmailRFARequestLinks]  WITH CHECK ADD  CONSTRAINT [FK_EmailRFARequestLinks_EmailRecords] FOREIGN KEY([EmailRecordId])
REFERENCES [dbo].[EmailRecords] ([EmailRecordId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EmailRFARequestLinks] CHECK CONSTRAINT [FK_EmailRFARequestLinks_EmailRecords]
GO
ALTER TABLE [dbo].[EmailRFARequestLinks]  WITH CHECK ADD  CONSTRAINT [FK_EmailRFARequestLinks_RFARequests] FOREIGN KEY([RFARequestID])
REFERENCES [dbo].[RFARequests] ([RFARequestID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EmailRFARequestLinks] CHECK CONSTRAINT [FK_EmailRFARequestLinks_RFARequests]
GO
ALTER TABLE [dbo].[Employers]  WITH CHECK ADD  CONSTRAINT [FK_Employers_States] FOREIGN KEY([EmpStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[Employers] CHECK CONSTRAINT [FK_Employers_States]
GO
ALTER TABLE [dbo].[EmployerSubsidiaries]  WITH CHECK ADD  CONSTRAINT [FK_EmployerSubsidiaries_Employers] FOREIGN KEY([EmployerId])
REFERENCES [dbo].[Employers] ([EmployerID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EmployerSubsidiaries] CHECK CONSTRAINT [FK_EmployerSubsidiaries_Employers]
GO
ALTER TABLE [dbo].[EmployerSubsidiaries]  WITH CHECK ADD  CONSTRAINT [FK_EmployerSubsidiaries_States] FOREIGN KEY([EMPSubsidiaryStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[EmployerSubsidiaries] CHECK CONSTRAINT [FK_EmployerSubsidiaries_States]
GO
ALTER TABLE [dbo].[IMRRFAReferrals]  WITH CHECK ADD  CONSTRAINT [FK_IMRRFAReferrals_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[IMRRFAReferrals] CHECK CONSTRAINT [FK_IMRRFAReferrals_RFAReferrals]
GO
ALTER TABLE [dbo].[InsuranceBranches]  WITH CHECK ADD  CONSTRAINT [FK_InsuranceBranches_Insurers] FOREIGN KEY([InsurerId])
REFERENCES [dbo].[Insurers] ([InsurerID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[InsuranceBranches] CHECK CONSTRAINT [FK_InsuranceBranches_Insurers]
GO
ALTER TABLE [dbo].[InsuranceBranches]  WITH CHECK ADD  CONSTRAINT [FK_InsuranceBranches_States] FOREIGN KEY([InsBranchStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[InsuranceBranches] CHECK CONSTRAINT [FK_InsuranceBranches_States]
GO
ALTER TABLE [dbo].[Insurers]  WITH CHECK ADD  CONSTRAINT [FK_Insurers_States] FOREIGN KEY([InsStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[Insurers] CHECK CONSTRAINT [FK_Insurers_States]
GO
ALTER TABLE [dbo].[ManagedCareCompanies]  WITH CHECK ADD  CONSTRAINT [FK_ManagedCareCompanies_States] FOREIGN KEY([CompStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[ManagedCareCompanies] CHECK CONSTRAINT [FK_ManagedCareCompanies_States]
GO
ALTER TABLE [dbo].[MedicalGroups]  WITH CHECK ADD  CONSTRAINT [FK_MedicalGroups_States] FOREIGN KEY([MGStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[MedicalGroups] CHECK CONSTRAINT [FK_MedicalGroups_States]
GO
ALTER TABLE [dbo].[Notes]  WITH CHECK ADD  CONSTRAINT [FK_Notes_PatientClaims] FOREIGN KEY([PatientClaimID])
REFERENCES [dbo].[PatientClaims] ([PatientClaimID])
GO
ALTER TABLE [dbo].[Notes] CHECK CONSTRAINT [FK_Notes_PatientClaims]
GO
ALTER TABLE [dbo].[Notes]  WITH CHECK ADD  CONSTRAINT [FK_Notes_RFARequests] FOREIGN KEY([RFARequestID])
REFERENCES [dbo].[RFARequests] ([RFARequestID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Notes] CHECK CONSTRAINT [FK_Notes_RFARequests]
GO
ALTER TABLE [dbo].[Notes]  WITH CHECK ADD  CONSTRAINT [FK_Notes_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Notes] CHECK CONSTRAINT [FK_Notes_Users]
GO
ALTER TABLE [dbo].[PatientClaimAddOnBodyParts]  WITH CHECK ADD  CONSTRAINT [FK_PatientAddOnBodyParts_BodyParts] FOREIGN KEY([AddOnBodyPartID])
REFERENCES [lookup].[BodyParts] ([BodyPartID])
GO
ALTER TABLE [dbo].[PatientClaimAddOnBodyParts] CHECK CONSTRAINT [FK_PatientAddOnBodyParts_BodyParts]
GO
ALTER TABLE [dbo].[PatientClaimAddOnBodyParts]  WITH CHECK ADD  CONSTRAINT [FK_PatientAddOnBodyParts_PatientClaims] FOREIGN KEY([PatientClaimID])
REFERENCES [dbo].[PatientClaims] ([PatientClaimID])
GO
ALTER TABLE [dbo].[PatientClaimAddOnBodyParts] CHECK CONSTRAINT [FK_PatientAddOnBodyParts_PatientClaims]
GO
ALTER TABLE [dbo].[PatientClaimAddOnBodyParts]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaimAddOnBodyParts_BodyPartStatuses] FOREIGN KEY([BodyPartStatusID])
REFERENCES [lookup].[BodyPartStatuses] ([BodyPartStatusID])
GO
ALTER TABLE [dbo].[PatientClaimAddOnBodyParts] CHECK CONSTRAINT [FK_PatientClaimAddOnBodyParts_BodyPartStatuses]
GO
ALTER TABLE [dbo].[PatientClaimDiagnoses]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaimDiagnoses_PatientClaims] FOREIGN KEY([PatientClaimID])
REFERENCES [dbo].[PatientClaims] ([PatientClaimID])
GO
ALTER TABLE [dbo].[PatientClaimDiagnoses] CHECK CONSTRAINT [FK_PatientClaimDiagnoses_PatientClaims]
GO
ALTER TABLE [dbo].[PatientClaimPleadBodyParts]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaimPleadBodyParts_BodyPartStatuses] FOREIGN KEY([BodyPartStatusID])
REFERENCES [lookup].[BodyPartStatuses] ([BodyPartStatusID])
GO
ALTER TABLE [dbo].[PatientClaimPleadBodyParts] CHECK CONSTRAINT [FK_PatientClaimPleadBodyParts_BodyPartStatuses]
GO
ALTER TABLE [dbo].[PatientClaimPleadBodyParts]  WITH CHECK ADD  CONSTRAINT [FK_PatientPleadBodyParts_BodyParts] FOREIGN KEY([PleadBodyPartID])
REFERENCES [lookup].[BodyParts] ([BodyPartID])
GO
ALTER TABLE [dbo].[PatientClaimPleadBodyParts] CHECK CONSTRAINT [FK_PatientPleadBodyParts_BodyParts]
GO
ALTER TABLE [dbo].[PatientClaimPleadBodyParts]  WITH CHECK ADD  CONSTRAINT [FK_PatientPleadBodyParts_PatientClaims] FOREIGN KEY([PatientClaimID])
REFERENCES [dbo].[PatientClaims] ([PatientClaimID])
GO
ALTER TABLE [dbo].[PatientClaimPleadBodyParts] CHECK CONSTRAINT [FK_PatientPleadBodyParts_PatientClaims]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_Adjusters] FOREIGN KEY([PatAdjusterID])
REFERENCES [dbo].[Adjusters] ([AdjusterID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_Adjusters]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_ADRs] FOREIGN KEY([PatADRID])
REFERENCES [dbo].[ADRs] ([ADRID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_ADRs]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_Attorneys] FOREIGN KEY([PatApplicantAttorneyID])
REFERENCES [dbo].[Attorneys] ([AttorneyID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_Attorneys]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_Attorneys1] FOREIGN KEY([PatDefenseAttorneyID])
REFERENCES [dbo].[Attorneys] ([AttorneyID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_Attorneys1]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_CaseManagers] FOREIGN KEY([PatCaseManagerID])
REFERENCES [dbo].[CaseManagers] ([CaseManagerID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_CaseManagers]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_Clients] FOREIGN KEY([PatClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_Clients]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_Employers] FOREIGN KEY([PatEmployerID])
REFERENCES [dbo].[Employers] ([EmployerID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_Employers]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_InsuranceBranches] FOREIGN KEY([PatInsuranceBranchID])
REFERENCES [dbo].[InsuranceBranches] ([InsuranceBranchID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_InsuranceBranches]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_Insurers] FOREIGN KEY([PatInsurerID])
REFERENCES [dbo].[Insurers] ([InsurerID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_Insurers]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_Patients] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patients] ([PatientID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_Patients]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_Physicians] FOREIGN KEY([PatPhysicianID])
REFERENCES [dbo].[Physicians] ([PhysicianId])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_Physicians]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_States] FOREIGN KEY([PatClaimJurisdictionID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_States]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_ThirdPartyAdministratorBranches] FOREIGN KEY([PatTPABranchID])
REFERENCES [dbo].[ThirdPartyAdministratorBranches] ([TPABranchID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_ThirdPartyAdministratorBranches]
GO
ALTER TABLE [dbo].[PatientClaims]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaims_ThirdPartyAdministrators] FOREIGN KEY([PatTPAID])
REFERENCES [dbo].[ThirdPartyAdministrators] ([TPAID])
GO
ALTER TABLE [dbo].[PatientClaims] CHECK CONSTRAINT [FK_PatientClaims_ThirdPartyAdministrators]
GO
ALTER TABLE [dbo].[PatientClaimStatuses]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaimStatuses_ClaimStatuses] FOREIGN KEY([ClaimStatusID])
REFERENCES [lookup].[ClaimStatuses] ([ClaimStatusID])
GO
ALTER TABLE [dbo].[PatientClaimStatuses] CHECK CONSTRAINT [FK_PatientClaimStatuses_ClaimStatuses]
GO
ALTER TABLE [dbo].[PatientClaimStatuses]  WITH CHECK ADD  CONSTRAINT [FK_PatientClaimStatuses_PatientClaims] FOREIGN KEY([PatientClaimID])
REFERENCES [dbo].[PatientClaims] ([PatientClaimID])
GO
ALTER TABLE [dbo].[PatientClaimStatuses] CHECK CONSTRAINT [FK_PatientClaimStatuses_PatientClaims]
GO
ALTER TABLE [dbo].[PatientCurrentMedicalConditions]  WITH CHECK ADD  CONSTRAINT [FK_PatientCurrentMedicalConditions_CurrentMedicalConditions] FOREIGN KEY([CurrentMedicalConditionId])
REFERENCES [lookup].[CurrentMedicalConditions] ([CurrentMedicalConditionId])
GO
ALTER TABLE [dbo].[PatientCurrentMedicalConditions] CHECK CONSTRAINT [FK_PatientCurrentMedicalConditions_CurrentMedicalConditions]
GO
ALTER TABLE [dbo].[PatientCurrentMedicalConditions]  WITH CHECK ADD  CONSTRAINT [FK_PatientCurrentMedicalConditions_Patients] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patients] ([PatientID])
GO
ALTER TABLE [dbo].[PatientCurrentMedicalConditions] CHECK CONSTRAINT [FK_PatientCurrentMedicalConditions_Patients]
GO
ALTER TABLE [dbo].[PatientOccupationals]  WITH CHECK ADD  CONSTRAINT [FK_PatientOccupationals_Patients] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patients] ([PatientID])
GO
ALTER TABLE [dbo].[PatientOccupationals] CHECK CONSTRAINT [FK_PatientOccupationals_Patients]
GO
ALTER TABLE [dbo].[Patients]  WITH CHECK ADD  CONSTRAINT [FK_Patients_Languages] FOREIGN KEY([PatPrimaryLanguageId])
REFERENCES [lookup].[Languages] ([LanguageID])
GO
ALTER TABLE [dbo].[Patients] CHECK CONSTRAINT [FK_Patients_Languages]
GO
ALTER TABLE [dbo].[Patients]  WITH CHECK ADD  CONSTRAINT [FK_Patients_States] FOREIGN KEY([PatStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[Patients] CHECK CONSTRAINT [FK_Patients_States]
GO
ALTER TABLE [dbo].[Physicians]  WITH CHECK ADD  CONSTRAINT [FK_Physicians_Physicians] FOREIGN KEY([PhysSpecialtyId])
REFERENCES [lookup].[Specialties] ([SpecialtyID])
GO
ALTER TABLE [dbo].[Physicians] CHECK CONSTRAINT [FK_Physicians_Physicians]
GO
ALTER TABLE [dbo].[Physicians]  WITH CHECK ADD  CONSTRAINT [FK_Physicians_States] FOREIGN KEY([PhysStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[Physicians] CHECK CONSTRAINT [FK_Physicians_States]
GO
ALTER TABLE [dbo].[RFAAdditionalInfoes]  WITH CHECK ADD  CONSTRAINT [FK_RFAAdditionalInfo_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFAAdditionalInfoes] CHECK CONSTRAINT [FK_RFAAdditionalInfo_RFAReferrals]
GO
ALTER TABLE [dbo].[RFADeletedRequests]  WITH CHECK ADD  CONSTRAINT [FK_RFADeletedRequests_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFADeletedRequests] CHECK CONSTRAINT [FK_RFADeletedRequests_RFAReferrals]
GO
ALTER TABLE [dbo].[RFAMergedReferralHistories]  WITH CHECK ADD  CONSTRAINT [FK_RFAMergedReferralHistories_RFAReferrals] FOREIGN KEY([RFAOldReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFAMergedReferralHistories] CHECK CONSTRAINT [FK_RFAMergedReferralHistories_RFAReferrals]
GO
ALTER TABLE [dbo].[RFAPatMedicalRecordReviews]  WITH CHECK ADD  CONSTRAINT [FK_RFAPatMedicalRecordReviews_RFARecordSplittings] FOREIGN KEY([RFARecSpltID])
REFERENCES [dbo].[RFARecordSplittings] ([RFARecSpltID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RFAPatMedicalRecordReviews] CHECK CONSTRAINT [FK_RFAPatMedicalRecordReviews_RFARecordSplittings]
GO
ALTER TABLE [dbo].[RFAProcessLevels]  WITH CHECK ADD  CONSTRAINT [FK_RFAProcessLevels_ProcessLevels] FOREIGN KEY([ProcessLevel])
REFERENCES [lookup].[ProcessLevels] ([ProcessLevel])
GO
ALTER TABLE [dbo].[RFAProcessLevels] CHECK CONSTRAINT [FK_RFAProcessLevels_ProcessLevels]
GO
ALTER TABLE [dbo].[RFAProcessLevels]  WITH CHECK ADD  CONSTRAINT [FK_RFAProcessLevels_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFAProcessLevels] CHECK CONSTRAINT [FK_RFAProcessLevels_RFAReferrals]
GO
ALTER TABLE [dbo].[RFARecordSplittings]  WITH CHECK ADD  CONSTRAINT [FK_RFARecordSplitings_DocumentCategories] FOREIGN KEY([DocumentCategoryID])
REFERENCES [lookup].[DocumentCategories] ([DocumentCategoryID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RFARecordSplittings] CHECK CONSTRAINT [FK_RFARecordSplitings_DocumentCategories]
GO
ALTER TABLE [dbo].[RFARecordSplittings]  WITH CHECK ADD  CONSTRAINT [FK_RFARecordSplitings_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFARecordSplittings] CHECK CONSTRAINT [FK_RFARecordSplitings_RFAReferrals]
GO
ALTER TABLE [dbo].[RFARecordSplittings]  WITH CHECK ADD  CONSTRAINT [FK_RFARecordSplittings_DocumentTypes] FOREIGN KEY([DocumentTypeID])
REFERENCES [lookup].[DocumentTypes] ([DocumentTypeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RFARecordSplittings] CHECK CONSTRAINT [FK_RFARecordSplittings_DocumentTypes]
GO
ALTER TABLE [dbo].[RFARecordSplittings]  WITH CHECK ADD  CONSTRAINT [FK_RFARecordSplittings_PatientClaims] FOREIGN KEY([PatientClaimID])
REFERENCES [dbo].[PatientClaims] ([PatientClaimID])
GO
ALTER TABLE [dbo].[RFARecordSplittings] CHECK CONSTRAINT [FK_RFARecordSplittings_PatientClaims]
GO
ALTER TABLE [dbo].[RFARecordSplittings]  WITH CHECK ADD  CONSTRAINT [FK_RFARecordSplittings_RFARecordSplittings] FOREIGN KEY([RFARecSpltID])
REFERENCES [dbo].[RFARecordSplittings] ([RFARecSpltID])
GO
ALTER TABLE [dbo].[RFARecordSplittings] CHECK CONSTRAINT [FK_RFARecordSplittings_RFARecordSplittings]
GO
ALTER TABLE [dbo].[RFARecordSplittings]  WITH CHECK ADD  CONSTRAINT [FK_RFARecordSplittings_RFARequests] FOREIGN KEY([RFARequestID])
REFERENCES [dbo].[RFARequests] ([RFARequestID])
GO
ALTER TABLE [dbo].[RFARecordSplittings] CHECK CONSTRAINT [FK_RFARecordSplittings_RFARequests]
GO
ALTER TABLE [dbo].[RFARecordSplittings]  WITH CHECK ADD  CONSTRAINT [FK_RFARecordSplittings_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[RFARecordSplittings] CHECK CONSTRAINT [FK_RFARecordSplittings_Users]
GO
ALTER TABLE [dbo].[RFAReferralAdditionalInfoes]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferralAdditionalInfoes_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFAReferralAdditionalInfoes] CHECK CONSTRAINT [FK_RFAReferralAdditionalInfoes_RFAReferrals]
GO
ALTER TABLE [dbo].[RFAReferralFiles]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferralFiles_FileTypes] FOREIGN KEY([RFAFileTypeID])
REFERENCES [lookup].[FileTypes] ([FileTypeID])
GO
ALTER TABLE [dbo].[RFAReferralFiles] CHECK CONSTRAINT [FK_RFAReferralFiles_FileTypes]
GO
ALTER TABLE [dbo].[RFAReferralFiles]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferralFiles_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFAReferralFiles] CHECK CONSTRAINT [FK_RFAReferralFiles_RFAReferrals]
GO
ALTER TABLE [dbo].[RFAReferralFiles]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferralFiles_Users] FOREIGN KEY([RFAFileUserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[RFAReferralFiles] CHECK CONSTRAINT [FK_RFAReferralFiles_Users]
GO
ALTER TABLE [dbo].[RFAReferralInvoices]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferralInvoices_PatientClaims] FOREIGN KEY([PatientClaimID])
REFERENCES [dbo].[PatientClaims] ([PatientClaimID])
GO
ALTER TABLE [dbo].[RFAReferralInvoices] CHECK CONSTRAINT [FK_RFAReferralInvoices_PatientClaims]
GO
ALTER TABLE [dbo].[RFAReferrals]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferrals_PatientClaims] FOREIGN KEY([PatientClaimID])
REFERENCES [dbo].[PatientClaims] ([PatientClaimID])
GO
ALTER TABLE [dbo].[RFAReferrals] CHECK CONSTRAINT [FK_RFAReferrals_PatientClaims]
GO
ALTER TABLE [dbo].[RFAReferrals]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferrals_Physicians] FOREIGN KEY([PhysicianID])
REFERENCES [dbo].[Physicians] ([PhysicianId])
GO
ALTER TABLE [dbo].[RFAReferrals] CHECK CONSTRAINT [FK_RFAReferrals_Physicians]
GO
ALTER TABLE [dbo].[RFAReferralTimeExtensionHistories]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferralTimeExtensionHistories_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFAReferralTimeExtensionHistories] CHECK CONSTRAINT [FK_RFAReferralTimeExtensionHistories_RFAReferrals]
GO
ALTER TABLE [dbo].[RFAReferralTimeExtensionHistories]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferralTimeExtensionHistories_Users] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[RFAReferralTimeExtensionHistories] CHECK CONSTRAINT [FK_RFAReferralTimeExtensionHistories_Users]
GO
ALTER TABLE [dbo].[RFARequestAdditionalInfoes]  WITH CHECK ADD  CONSTRAINT [FK_RFARequestAdditionalInfoes_RFARequests] FOREIGN KEY([RFARequestID])
REFERENCES [dbo].[RFARequests] ([RFARequestID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RFARequestAdditionalInfoes] CHECK CONSTRAINT [FK_RFARequestAdditionalInfoes_RFARequests]
GO
ALTER TABLE [dbo].[RFARequestBillings]  WITH CHECK ADD  CONSTRAINT [FK_RFARequestBillings_RFARequests] FOREIGN KEY([RFARequestID])
REFERENCES [dbo].[RFARequests] ([RFARequestID])
GO
ALTER TABLE [dbo].[RFARequestBillings] CHECK CONSTRAINT [FK_RFARequestBillings_RFARequests]
GO
ALTER TABLE [dbo].[RFARequestBodyParts]  WITH CHECK ADD  CONSTRAINT [FK_RFARequestBodyParts_RFARequests] FOREIGN KEY([RFARequestID])
REFERENCES [dbo].[RFARequests] ([RFARequestID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RFARequestBodyParts] CHECK CONSTRAINT [FK_RFARequestBodyParts_RFARequests]
GO
ALTER TABLE [dbo].[RFARequestCPTCodes]  WITH CHECK ADD  CONSTRAINT [FK_RFARequestCPTCodes_RFARequests] FOREIGN KEY([RFARequestID])
REFERENCES [dbo].[RFARequests] ([RFARequestID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RFARequestCPTCodes] CHECK CONSTRAINT [FK_RFARequestCPTCodes_RFARequests]
GO
ALTER TABLE [dbo].[RFARequestModifies]  WITH CHECK ADD  CONSTRAINT [FK_RFARequestModifies_RFARequests] FOREIGN KEY([RFARequestID])
REFERENCES [dbo].[RFARequests] ([RFARequestID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RFARequestModifies] CHECK CONSTRAINT [FK_RFARequestModifies_RFARequests]
GO
ALTER TABLE [dbo].[RFARequests]  WITH CHECK ADD  CONSTRAINT [FK_RFARequests_Decisions] FOREIGN KEY([DecisionID])
REFERENCES [lookup].[Decisions] ([DecisionID])
GO
ALTER TABLE [dbo].[RFARequests] CHECK CONSTRAINT [FK_RFARequests_Decisions]
GO
ALTER TABLE [dbo].[RFARequests]  WITH CHECK ADD  CONSTRAINT [FK_RFARequests_DurationTypes] FOREIGN KEY([RFADurationTypeID])
REFERENCES [lookup].[DurationTypes] ([DurationTypeID])
GO
ALTER TABLE [dbo].[RFARequests] CHECK CONSTRAINT [FK_RFARequests_DurationTypes]
GO
ALTER TABLE [dbo].[RFARequests]  WITH CHECK ADD  CONSTRAINT [FK_RFARequests_RequestTypes] FOREIGN KEY([RequestTypeID])
REFERENCES [lookup].[RequestTypes] ([RequestTypeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RFARequests] CHECK CONSTRAINT [FK_RFARequests_RequestTypes]
GO
ALTER TABLE [dbo].[RFARequests]  WITH CHECK ADD  CONSTRAINT [FK_RFARequests_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFARequests] CHECK CONSTRAINT [FK_RFARequests_RFAReferrals]
GO
ALTER TABLE [dbo].[RFARequests]  WITH CHECK ADD  CONSTRAINT [FK_RFARequests_TreatmentCategories] FOREIGN KEY([TreatmentCategoryID])
REFERENCES [lookup].[TreatmentCategories] ([TreatmentCategoryID])
GO
ALTER TABLE [dbo].[RFARequests] CHECK CONSTRAINT [FK_RFARequests_TreatmentCategories]
GO
ALTER TABLE [dbo].[RFARequests]  WITH CHECK ADD  CONSTRAINT [FK_RFARequests_TreatmentTypes] FOREIGN KEY([TreatmentTypeID])
REFERENCES [lookup].[TreatmentTypes] ([TreatmentTypeID])
GO
ALTER TABLE [dbo].[RFARequests] CHECK CONSTRAINT [FK_RFARequests_TreatmentTypes]
GO
ALTER TABLE [dbo].[RFARequestTimeExtensions]  WITH CHECK ADD  CONSTRAINT [FK_RFARequestTimeExtensions_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFARequestTimeExtensions] CHECK CONSTRAINT [FK_RFARequestTimeExtensions_RFAReferrals]
GO
ALTER TABLE [dbo].[RFARequestTimeExtensions]  WITH CHECK ADD  CONSTRAINT [FK_RFARequestTimeExtensions_RFARequests] FOREIGN KEY([RFARequestID])
REFERENCES [dbo].[RFARequests] ([RFARequestID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RFARequestTimeExtensions] CHECK CONSTRAINT [FK_RFARequestTimeExtensions_RFARequests]
GO
ALTER TABLE [dbo].[RFASplittedReferralHistories]  WITH CHECK ADD  CONSTRAINT [FK_RFASplittedReferralHistories_RFAReferrals] FOREIGN KEY([RFAOldReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
GO
ALTER TABLE [dbo].[RFASplittedReferralHistories] CHECK CONSTRAINT [FK_RFASplittedReferralHistories_RFAReferrals]
GO
ALTER TABLE [dbo].[ThirdPartyAdministratorBranches]  WITH CHECK ADD  CONSTRAINT [FK_ThirdPartyAdministratorBranches_States] FOREIGN KEY([TPABranchStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[ThirdPartyAdministratorBranches] CHECK CONSTRAINT [FK_ThirdPartyAdministratorBranches_States]
GO
ALTER TABLE [dbo].[ThirdPartyAdministratorBranches]  WITH CHECK ADD  CONSTRAINT [FK_ThirdPartyAdministratorBranches_ThirdPartyAdministrators] FOREIGN KEY([TPAID])
REFERENCES [dbo].[ThirdPartyAdministrators] ([TPAID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ThirdPartyAdministratorBranches] CHECK CONSTRAINT [FK_ThirdPartyAdministratorBranches_ThirdPartyAdministrators]
GO
ALTER TABLE [dbo].[ThirdPartyAdministrators]  WITH CHECK ADD  CONSTRAINT [FK_ThirdPartyAdministrators_States] FOREIGN KEY([TPAStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[ThirdPartyAdministrators] CHECK CONSTRAINT [FK_ThirdPartyAdministrators_States]
GO
ALTER TABLE [dbo].[Vendors]  WITH CHECK ADD  CONSTRAINT [FK_Vendors_States] FOREIGN KEY([VendorStateID])
REFERENCES [lookup].[States] ([StateId])
GO
ALTER TABLE [dbo].[Vendors] CHECK CONSTRAINT [FK_Vendors_States]
GO
ALTER TABLE [link].[RFAReferralAdditionalLinks]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferralAdditionalInfo_ClientStatements] FOREIGN KEY([ClientStatementID])
REFERENCES [dbo].[ClientStatements] ([ClientStatementID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [link].[RFAReferralAdditionalLinks] CHECK CONSTRAINT [FK_RFAReferralAdditionalInfo_ClientStatements]
GO
ALTER TABLE [link].[RFAReferralAdditionalLinks]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferralAdditionalInfo_RFAReferralInvoices] FOREIGN KEY([RFAReferralInvoiceID])
REFERENCES [dbo].[RFAReferralInvoices] ([RFAReferralInvoiceID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [link].[RFAReferralAdditionalLinks] CHECK CONSTRAINT [FK_RFAReferralAdditionalInfo_RFAReferralInvoices]
GO
ALTER TABLE [link].[RFAReferralAdditionalLinks]  WITH CHECK ADD  CONSTRAINT [FK_RFAReferralAdditionalInfo_RFAReferrals] FOREIGN KEY([RFAReferralID])
REFERENCES [dbo].[RFAReferrals] ([RFAReferralID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [link].[RFAReferralAdditionalLinks] CHECK CONSTRAINT [FK_RFAReferralAdditionalInfo_RFAReferrals]
GO
ALTER TABLE [link].[RFARequestTimeExtensionRecords]  WITH CHECK ADD  CONSTRAINT [FK_RFARequestTimeExtensionRecords_RFAReferralFiles] FOREIGN KEY([RFAReferralFileID])
REFERENCES [dbo].[RFAReferralFiles] ([RFAReferralFileID])
GO
ALTER TABLE [link].[RFARequestTimeExtensionRecords] CHECK CONSTRAINT [FK_RFARequestTimeExtensionRecords_RFAReferralFiles]
GO
ALTER TABLE [link].[RFIReportRFAAdditionalRecords]  WITH CHECK ADD  CONSTRAINT [FK_RFIReportRFAAdditionalRecords_RFAAdditionalInfoes] FOREIGN KEY([RFAAdditionalInfoID])
REFERENCES [dbo].[RFAAdditionalInfoes] ([RFAAdditionalInfoID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [link].[RFIReportRFAAdditionalRecords] CHECK CONSTRAINT [FK_RFIReportRFAAdditionalRecords_RFAAdditionalInfoes]
GO
ALTER TABLE [link].[RFIReportRFAAdditionalRecords]  WITH CHECK ADD  CONSTRAINT [FK_RFIReportRFAAdditionalRecords_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [link].[RFIReportRFAAdditionalRecords] CHECK CONSTRAINT [FK_RFIReportRFAAdditionalRecords_Users]
GO
ALTER TABLE [link].[RFIRFARequestRecords]  WITH CHECK ADD  CONSTRAINT [FK_RFIRFARequestRecords_RFAReferralFiles] FOREIGN KEY([RFAReferralFileID])
REFERENCES [dbo].[RFAReferralFiles] ([RFAReferralFileID])
GO
ALTER TABLE [link].[RFIRFARequestRecords] CHECK CONSTRAINT [FK_RFIRFARequestRecords_RFAReferralFiles]
GO
ALTER TABLE [link].[RFIRFARequestRecords]  WITH CHECK ADD  CONSTRAINT [FK_RFIRFARequestRecords_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [link].[RFIRFARequestRecords] CHECK CONSTRAINT [FK_RFIRFARequestRecords_Users]
GO
ALTER TABLE [lookup].[DocumentTypes]  WITH CHECK ADD  CONSTRAINT [FK_DocumentTypes_DocumentCategories] FOREIGN KEY([DocumentCategoryID])
REFERENCES [lookup].[DocumentCategories] ([DocumentCategoryID])
GO
ALTER TABLE [lookup].[DocumentTypes] CHECK CONSTRAINT [FK_DocumentTypes_DocumentCategories]
GO
ALTER TABLE [lookup].[IMRResponseLetterDocumentRelations]  WITH CHECK ADD  CONSTRAINT [FK_IMRResponseLetterDocumentRelations_IMRResponseLetterCheckLists] FOREIGN KEY([IMRMedicalRecordSubmittedID])
REFERENCES [lookup].[IMRResponseLetterCheckLists] ([IMRMedicalRecordSubmittedID])
GO
ALTER TABLE [lookup].[IMRResponseLetterDocumentRelations] CHECK CONSTRAINT [FK_IMRResponseLetterDocumentRelations_IMRResponseLetterCheckLists]
GO
ALTER TABLE [lookup].[TreatmentTypes]  WITH CHECK ADD  CONSTRAINT [FK_TreatmentTypes_TreatmentCategories] FOREIGN KEY([TreatmentCategoryID])
REFERENCES [lookup].[TreatmentCategories] ([TreatmentCategoryID])
GO
ALTER TABLE [lookup].[TreatmentTypes] CHECK CONSTRAINT [FK_TreatmentTypes_TreatmentCategories]
GO
/****** Object:  StoredProcedure [dbo].[Add_EmailRecordAndRFARequestLinkByRFAReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Mahinder Singh
-- Create date: 07/14/2016
-- Description: Add RFARequestID and EmailRecordID in  EmailRFARequestLinks By RFARequestID 
-- Version: 1.0
-- ================================================================ 
--[dbo].[Add_EmailRecordAndRFARequestLinkByRFITimeExtension] 1008
CREATE PROCEDURE [dbo].[Add_EmailRecordAndRFARequestLinkByRFAReferralID] 
	@RFAReferralID INT,
	@EmailRecordId INT
AS
	BEGIN
		  
		INSERT INTO dbo.EmailRFARequestLinks
                      (EmailRecordId, RFARequestID)
			SELECT    @EmailRecordId,RFARequestID
			FROM     dbo.RFARequests WHERE RFAReferralID =@RFAReferralID
	END

GO
/****** Object:  StoredProcedure [dbo].[Add_EmailRecordAndRFARequestLinkByRFITimeExtension]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Mahinder Singh
-- Create date: 07/14/2016
-- Description: Add RFARequestID and EmailRecordID in  EmailRFARequestLinks By RFARequestID 
-- Version: 1.0
-- ================================================================ 
--[dbo].[Add_EmailRecordAndRFARequestLinkByRFITimeExtension] 1008
CREATE PROCEDURE [dbo].[Add_EmailRecordAndRFARequestLinkByRFITimeExtension] 
    @RFAReferralID INT,
	@RFAReferralFileID INT,
	@EmailRecordId INT
AS
	BEGIN
		IF(@RFAReferralID = 0)
		BEGIN
		INSERT INTO dbo.EmailRFARequestLinks
                      (EmailRecordId, RFARequestID)
			SELECT    @EmailRecordId,RFARequestID
			FROM         RFARequests WHERE   ISNULL(DecisionID,0) = 0 AND  ISNULL(RFAStatus,'') ='' AND  RFAReferralID IN ( SELECT  RFAReferralID
			FROM         RFAReferralFiles WHERE RFAReferralFileID = @RFAReferralFileID)
		END
		ELSE
		BEGIN
		     INSERT INTO dbo.EmailRFARequestLinks
                      (EmailRecordId, RFARequestID)
			SELECT    @EmailRecordId,RFARequestID
			FROM         RFARequests WHERE   ISNULL(DecisionID,0) = 0 AND  ISNULL(RFAStatus,'') ='' AND  RFAReferralID = @RFAReferralID
		END
	END

GO
/****** Object:  StoredProcedure [dbo].[Add_RFARequestTimeExtensionRecordByRFARequestID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: rkumar
-- Create date: 05/16/2016
-- Description: Add RFARequest Time Extension Record By RFARequestID 
-- Version: 1.0
-- ================================================================ 
--[dbo].[Add_RFARequestTimeExtensionRecordByRFARequestID] 1008
CReate PROCEDURE [dbo].[Add_RFARequestTimeExtensionRecordByRFARequestID] 
	@RFAReferralFileID int ,
	@UserID int
AS
	BEGIN
		  
		INSERT INTO link.RFARequestTimeExtensionRecords
                      (RFAReferralFileID, RFAReferralID, RFARequestID, UserID)
			SELECT    @RFAReferralFileID, RFAReferralID ,RFARequestID, @UserID
			FROM         RFARequests where   isnull(DecisionID,0) = 0 and  isnull(RFAStatus,'') ='' and  RFAReferralID in ( SELECT      RFAReferralID
			FROM         RFAReferralFiles where RFAReferralFileID = @RFAReferralFileID)
	END

GO
/****** Object:  StoredProcedure [dbo].[Add_RFIReportAdditionalRecordByRFAReferralFileID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: rkumar
-- Create date: 04/13/2016
-- Description: Add RFI Report Additional Record By RFAReferralFileID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Add_RFIReportAdditionalRecordByRFAReferralFileID] 1008
CREATE PROCEDURE [dbo].[Add_RFIReportAdditionalRecordByRFAReferralFileID] 
	@RFAReferralFileID int ,
	@UserID int
AS
	BEGIN
		  
			INSERT INTO link.RFIReportRFAAdditionalRecords
                      (RFAAdditionalInfoID,RFAReferralID, RFARequestID,UserID)
			SELECT     @RFAReferralFileID, RFAReferralID, RFARequestID	, @UserID FROM RFARequests where RFAReferralID in ( SELECT      RFAReferralID
						FROM         RFAAdditionalInfoes where RFAAdditionalInfoID = @RFAReferralFileID)
						and isnull(DecisionID,0) = 0 and  isnull(RFAStatus,'') =''
	END

GO
/****** Object:  StoredProcedure [dbo].[Add_RFIReportAdditionalRecordByRFARequestID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: rkumar
-- Create date: 05/30/2016
-- Description: Add RFI Report Additional Record By RFARequestID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Add_RFIReportAdditionalRecordByRFARequestID] 1008
Create PROCEDURE [dbo].[Add_RFIReportAdditionalRecordByRFARequestID] 
	@RFAReferralFileID int ,
	@RFARequestID int,
	@UserID int
AS
	BEGIN
		  
			INSERT INTO link.RFIReportRFAAdditionalRecords
                      (RFAAdditionalInfoID,RFAReferralID, RFARequestID,UserID)
			SELECT     @RFAReferralFileID, RFAReferralID, RFARequestID	, @UserID FROM RFARequests where RFARequestID = @RFARequestID
	END

GO
/****** Object:  StoredProcedure [dbo].[Add_RFITemplateRecordByRFARequestID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: rkumar
-- Create date: 05/12/2016
-- Description: Add RFA Referral Files Record By RFAReferralFileID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Add_RFITemplateRecordByRFARequestID] 1008
Create PROCEDURE [dbo].[Add_RFITemplateRecordByRFARequestID] 
	@RFAReferralFileID int ,
	@UserID int
AS
	BEGIN
		  
		INSERT INTO link.RFIRFARequestRecords
                      (RFAReferralFileID, RFAReferralID, RFARequestID, UserID)
			SELECT    @RFAReferralFileID, RFAReferralID ,RFARequestID, @UserID
			FROM         RFARequests where   isnull(DecisionID,0) = 0 and  isnull(RFAStatus,'') ='' and  RFAReferralID in ( SELECT      RFAReferralID
			FROM         RFAReferralFiles where RFAReferralFileID = @RFAReferralFileID)
	END

GO
/****** Object:  StoredProcedure [dbo].[AddUpdate_RFAReferralAdditionalLinkInvoiceIDbyRefID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 04/13/2016
-- Description: Add or Update RFAReferralAdditionalLink InvoiceID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_PatientByReferralID] 32
CREATE PROCEDURE [dbo].[AddUpdate_RFAReferralAdditionalLinkInvoiceIDbyRefID] 
	@RFAReferralID int,
	@RFAReferralInvoiceID int 
AS

	BEGIN

		if exists(select * from link.RFAReferralAdditionalLinks where RFAReferralID = @RFAReferralID)
		Begin
		update link.RFAReferralAdditionalLinks set RFAReferralInvoiceID=@RFAReferralInvoiceID where RFAReferralID = @RFAReferralID
		End
		Else
		begin
		insert into link.RFAReferralAdditionalLinks (RFAReferralID,RFAReferralInvoiceID) values(@RFAReferralID,@RFAReferralInvoiceID)
		end
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddUpdate_RFAReferralAdditionalLinkStatementIDbyRefID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 04/13/2016
-- Description: Add or Update RFAReferralAdditionalLink Statement
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_PatientByReferralID] 32
Create PROCEDURE [dbo].[AddUpdate_RFAReferralAdditionalLinkStatementIDbyRefID] 
	@RFAReferralID int,
	@ClientStatementID int 
AS

	BEGIN

		if exists(select * from link.RFAReferralAdditionalLinks where RFAReferralID = @RFAReferralID)
		Begin
		update link.RFAReferralAdditionalLinks set ClientStatementID=@ClientStatementID where RFAReferralID = @RFAReferralID
		End
		Else
		begin
		insert into link.RFAReferralAdditionalLinks (RFAReferralID,ClientStatementID) values(@RFAReferralID,@ClientStatementID)
		end
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[Create_RFARefferalByRFARefferalID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Rohit Kumar>
-- Create date: <Create Date,,09-03-2016>
-- Description:	<Description,create new RFARefferal records By RFARequestID for IMR Case>
-- =============================================
--[dbo].[Create_RFARefferalByRFARefferalID]32 
CREATE PROCEDURE [dbo].[Create_RFARefferalByRFARefferalID]
(
@RFARefferalID int,
@RFARequestIDs varchar(max),
@Flag int
)
AS
BEGIN
 
BEGIN TRANSACTION [Trans1]  
   BEGIN TRY
		declare @NewRFARefferalID int = 0
		if(@Flag=0)
			begin
					INSERT INTO RFAReferrals
									  (RFAReferralCreatedDate, PatientClaimID, RFAReferralDate, RFACEDate, RFACETime, RFAHCRGDate, RFASignedByPhysician, RFATreatmentRequestClear, 
									  RFADiscrepancies, PhysicianID, EvaluationDate, EvaluatedBy, [Credentials], InternalAppeal, RFASignature, RFASignatureDescription)
				                      
					SELECT     RFAReferralCreatedDate, PatientClaimID, RFAReferralDate, RFACEDate, RFACETime, RFAHCRGDate, RFASignedByPhysician, RFATreatmentRequestClear, 
							  RFADiscrepancies, PhysicianID, EvaluationDate, EvaluatedBy, [Credentials], InternalAppeal, RFASignature, RFASignatureDescription
					FROM         RFAReferrals where RFAReferralID = @RFARefferalID
					
					set @NewRFARefferalID = (select SCOPE_IDENTITY())
			
					-- upadte New RFARefferalID by old RFARequestID
					INSERT INTO RFASplittedReferralHistories
								  (RFAOldReferralID, RFANewReferralID, RFASplittedReferralDate)
					VALUES     (@RFARefferalID,@NewRFARefferalID,GETDATE())
					
					UPDATE    RFARequests SET	RFAReferralID = @NewRFARefferalID where		RFARequests.RFARequestID in (select splitdata from [global].[Get_SplitStringFormat](@RFARequestIDs,'#'))
					
					INSERT INTO RFAReferralFiles (RFAReferralID, RFAFileTypeID, RFAReferralFileName, RFAFileCreationDate, RFAFileUserID)
					SELECT @NewRFARefferalID, RFAFileTypeID, RFAReferralFileName,  GETDATE(),RFAFileUserID
					FROM         RFAReferralFiles
					where  RFAReferralID = @RFARefferalID
					
			end
		else
			begin
				set @NewRFARefferalID = @RFARefferalID
			end
		-- upadte IMR Process level
	
		INSERT INTO RFAProcessLevels 
                      (RFAReferralID, ProcessLevel)
		VALUES     (@NewRFARefferalID,170)
		
		UPDATE    RFARequests 		SET RFARequestIMRCreatedDate = GETDATE() where		RFARequestID in (select splitdata from [global].[Get_SplitStringFormat](@RFARequestIDs,'#'))
		    
	COMMIT TRANSACTION	[Trans1]			
    END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION [Tran1]
	END CATCH		
 
END

GO
/****** Object:  StoredProcedure [dbo].[Delete_RFAReferralIDFromReferralFiles]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 24 MAY 2016
-- Description:	 Preparation - Continue Function :- getting new ID for Merging 
--               RFAReferralID in New RFAReferralID on changing the decision 
--               from Certify or Send To Clincial  to Def,Duplicate,UnableToReview
--               And delete the previous entry
-- ============================================================================
CREATE PROCEDURE [dbo].[Delete_RFAReferralIDFromReferralFiles] 
@ReferralID INT,@RFAFileTypeID INT

AS
BEGIN
	SET NOCOUNT ON;
		DELETE FROM RFAReferralFiles WHERE RFAReferralID = @ReferralID AND RFAFileTypeID = @RFAFileTypeID
END

GO
/****** Object:  StoredProcedure [dbo].[Get_AcceptedBodyPartByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,16-12-2015>
-- Description:	<Description,,get comma seperated accepted body parts by referral id>
-- =============================================
--[dbo].[Get_AcceptedBodyPartByReferralID]32 
CREATE PROCEDURE [dbo].[Get_AcceptedBodyPartByReferralID]
(
@ReferralID int
)
AS
BEGIN

	DECLARE @PatientClaimID int
				
	set @PatientClaimID = (SELECT     isnull(PatientClaimID,0) FROM         RFAReferrals where RFAReferralID =@ReferralID)

	SELECT BodyPartName
INTO #Temp
FROM(   
			SELECT   (CASE WHEN PatientClaimAddOnBodyParts.AddOnBodyPartCondition IS NULL  THEN  lookup.BodyParts.BodyPartName 
	                     ELSE lookup.BodyParts.BodyPartName+' ('+PatientClaimAddOnBodyParts.AddOnBodyPartCondition+')' End) AS BodyPartName,PatientClaimAddOnBodyParts.patientclaimaddonbodypartid as id
						FROM         PatientClaimAddOnBodyParts INNER JOIN
								  PatientClaims ON PatientClaimAddOnBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
								  lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
								  lookup.BodyPartStatuses ON PatientClaimAddOnBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
						where PatientClaims.PatientClaimID = @PatientClaimID and lookup.BodyPartStatuses.BodyPartStatusID = 1  			
						
			UNION

			SELECT     (CASE WHEN PatientClaimPleadBodyParts.PleadBodyPartCondition IS NULL  THEN  lookup.BodyParts.BodyPartName 
	                     ELSE lookup.BodyParts.BodyPartName+' ('+PatientClaimPleadBodyParts.PleadBodyPartCondition+')' End) AS BodyPartName,PatientClaimPleadBodyParts.patientclaimpleadbodypartid as id
									FROM         PatientClaimPleadBodyParts INNER JOIN
								  PatientClaims ON PatientClaimPleadBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
								  lookup.BodyParts ON PatientClaimPleadBodyParts.PleadBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
								  lookup.BodyPartStatuses ON PatientClaimPleadBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
						where PatientClaims.PatientClaimID = @PatientClaimID and lookup.BodyPartStatuses.BodyPartStatusID = 1						
			)as hh
			group by hh.BodyPartName order by min(hh.id)
	DECLARE @Consolidated_AcceptedBodyParts varchar(Max)
	DECLARE   @SQLQuery AS NVARCHAR(MAX)
				DECLARE   @PivotColumns AS NVARCHAR(MAX)
				 
				--Get unique values of pivot column  
				SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(BodyPartName)
				FROM (
					select  BodyPartName from #temp
					
				) AS PivotExample
				 
				SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', '')
				
				drop table #temp
END

GO
/****** Object:  StoredProcedure [dbo].[Get_AccountReceivablesByClientName]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 18 April 2016
-- Description:	To get Invoice Number in Account  Receivables page according to
--              Clients
-- ============================================================================
--[dbo].[Get_AccountReceivablesByClientName] 'billing gurleen',0,10
CREATE PROCEDURE [dbo].[Get_AccountReceivablesByClientName] 
@ClientName VARCHAR(50),@Skip INT, @Take INT

AS
BEGIN
	SET NOCOUNT ON;
WITH AccountReceivablesByClient AS(
SELECT ROW_NUMBER() OVER(ORDER BY RFAReferralInvoiceID) AS ROW ,ClientID , ClientName,PatientID,PatientClaimID,PatientName,PatClaimNumber,RFAReferralInvoiceID
       ,InvoiceNumber,InvoiceFileName,ClientStatementID,ClientStatementNumber,ClientStatementFileName,CreatedDate
FROM(SELECT DISTINCT  c.ClientID,c.ClientName,p.PatientID,pc.PatientClaimID
            ,(p.PatFirstName+' '+p.PatLastName) AS PatientName,pc.PatClaimNumber,rfI.RFAReferralInvoiceID,rfI.InvoiceNumber
            ,rfI.InvoiceFileName,cs.ClientStatementID,cs.ClientStatementNumber,cs.ClientStatementFileName,rfI.CreatedDate   FROM link.RFAReferralAdditionalLinks refLink
INNER JOIN RFAReferralInvoices rfI ON rfI.RFAReferralInvoiceID = refLink.RFAReferralInvoiceID
LEFT JOIN ClientStatements cs ON cs.ClientStatementID = refLink.ClientStatementID
INNER JOIN  PatientClaims pc ON pc.PatientClaimID = rfI.PatientClaimID
INNER JOIN  Patients p ON p.PatientID = pc.PatientID
INNER JOIN Clients c ON c.ClientID = rfI.ClientID
WHERE       c.ClientName = Rtrim(Ltrim(@ClientName)) )T)
SELECT * FROM AccountReceivablesByClient AS AR
		WHERE AR.ROW BETWEEN @Skip + 1 AND @Skip + @Take

END

GO
/****** Object:  StoredProcedure [dbo].[Get_AccountReceivablesByClientNameCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 18 April 2016
-- Description:	To get Invoice Number in Account  Receivables page according to
--              Clients COUNT
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_AccountReceivablesByClientNameCount] 
@ClientName VARCHAR(50)

AS
BEGIN
	SET NOCOUNT ON;
	
SELECT COUNT(*) TotalCount FROM (
	SELECT ROW_NUMBER() OVER(ORDER BY RFAReferralInvoiceID) AS ROW ,ClientID , ClientName,PatientID,PatientName,PatClaimNumber,RFAReferralInvoiceID
		   ,InvoiceNumber,InvoiceFileName,ClientStatementID,ClientStatementNumber,CreatedDate
	FROM(SELECT DISTINCT  c.ClientID,c.ClientName,p.PatientID,pc.PatientClaimID
            ,(p.PatFirstName+' '+p.PatLastName) AS PatientName,pc.PatClaimNumber,rfI.RFAReferralInvoiceID,rfI.InvoiceNumber
            ,rfI.InvoiceFileName,cs.ClientStatementID,cs.ClientStatementNumber,cs.ClientStatementFileName,rfI.CreatedDate   FROM link.RFAReferralAdditionalLinks refLink
INNER JOIN RFAReferralInvoices rfI ON rfI.RFAReferralInvoiceID = refLink.RFAReferralInvoiceID
LEFT JOIN ClientStatements cs ON cs.ClientStatementID = refLink.ClientStatementID
INNER JOIN  PatientClaims pc ON pc.PatientClaimID = rfI.PatientClaimID
INNER JOIN  Patients p ON p.PatientID = pc.PatientID
INNER JOIN Clients c ON c.ClientID = rfI.ClientID
	WHERE       c.ClientName = RTrim(Ltrim(@ClientName)) )T)TS

END

GO
/****** Object:  StoredProcedure [dbo].[Get_AdditionalDocumentByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: MAHINDER SINGH
-- Create date: 06/23/2016
-- Description: GET Patient Additional Document by PatientID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_AdditionalDocumentByPatientID] 148,170,0,340
CREATE PROCEDURE [dbo].[Get_AdditionalDocumentByPatientID]
	@PatientID INT,
	@PatientClaimID INT,
	@Skip INT,
	@Take INT
	
AS
BEGIN
WITH  PatientAdditionalDocument AS
	 (		
		 SELECT ROW_NUMBER() OVER(ORDER BY RFAReferralID) AS RowNumber,TypeName,FileID,RFAReferralID,DocumentName,RFAFileName,DocumentDate,PatientClaimID FROM
		 (	
				SELECT dc.DocumentCategoryName AS TypeName,rs.RFARecSpltID AS FileID,rs.RFAReferralID,rs.RFARecDocumentName AS DocumentName,rs.RFAFileName,rs.RFARecDocumentDate As DocumentDate 
				,pc.PatientClaimID FROM RFARecordSplittings rs
				INNER JOIN lookup.DocumentCategories dc ON dc.DocumentCategoryID = rs.DocumentCategoryID
				INNER JOIN RFAReferrals rfa ON rfa.RFAReferralID = rs.RFAReferralID
				INNER JOIN PatientClaims pc ON pc.PatientClaimID = rfa.PatientClaimID
				WHERE pc.PatientID = @PatientID AND pc.PatientClaimID = @PatientClaimID
				
			UNION 
			   
			    SELECT 'UR History' AS TypeName,f.RFAReferralFileID AS FileID,f.RFAReferralID,f.RFAReferralFileName AS DocumentName,f.RFAReferralFileName AS RFAFileName,f.RFAFileCreationDate AS DocumentDate
				,pc.PatientClaimID FROM RFAReferralFiles f
				INNER JOIN RFAReferrals rfa ON rfa.RFAReferralID = f.RFAReferralID
				INNER JOIN PatientClaims pc ON pc.PatientClaimID = rfa.PatientClaimID
				WHERE pc.PatientID = @PatientID AND pc.PatientClaimID = @PatientClaimID AND f.RFAFileTypeID NOT IN (12,13)
			
		 )T
	 )
	  SELECT * FROM PatientAdditionalDocument 
	   WHERE PatientAdditionalDocument.RowNumber BETWEEN @Skip + 1 AND @Skip + @Take
END

GO
/****** Object:  StoredProcedure [dbo].[Get_AdditionalDocumentByPatientIDCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: MAHINDER SINGH
-- Create date: 06/23/2016
-- Description: GET Patient Additional Document by PatientID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_AdditionalDocumentByPatientIDCount] 130,0,500
CREATE PROCEDURE [dbo].[Get_AdditionalDocumentByPatientIDCount]
	@PatientID INT,
	@PatientClaimID INT
	
AS
BEGIN
WITH  PatientAdditionalDocument AS
	 (		
		 SELECT ROW_NUMBER() OVER(ORDER BY RFAReferralID) AS RowNumber,TypeName,RFAReferralID,DocumentName,RFAFileName,DocumentDate FROM
		 (
			   SELECT dc.DocumentCategoryName AS TypeName,rs.RFARecSpltID AS FileID,rs.RFAReferralID,rs.RFARecDocumentName AS DocumentName,rs.RFAFileName,rs.RFARecDocumentDate As DocumentDate 
				,pc.PatientClaimID FROM RFARecordSplittings rs
				INNER JOIN lookup.DocumentCategories dc ON dc.DocumentCategoryID = rs.DocumentCategoryID
				INNER JOIN RFAReferrals rfa ON rfa.RFAReferralID = rs.RFAReferralID
				INNER JOIN PatientClaims pc ON pc.PatientClaimID = rfa.PatientClaimID
				WHERE pc.PatientID = @PatientID AND pc.PatientClaimID = @PatientClaimID
				
			UNION 
			   
			    SELECT 'UR History' AS TypeName,f.RFAReferralFileID AS FileID,f.RFAReferralID,f.RFAReferralFileName AS DocumentName,f.RFAReferralFileName AS RFAFileName,f.RFAFileCreationDate AS DocumentDate
				,pc.PatientClaimID FROM RFAReferralFiles f
				INNER JOIN RFAReferrals rfa ON rfa.RFAReferralID = f.RFAReferralID
				INNER JOIN PatientClaims pc ON pc.PatientClaimID = rfa.PatientClaimID
				WHERE pc.PatientID = @PatientID AND pc.PatientClaimID = @PatientClaimID AND f.RFAFileTypeID NOT IN (12,13)
			
		 )T
	 )
	  SELECT COUNT(*) FROM PatientAdditionalDocument 
END

GO
/****** Object:  StoredProcedure [dbo].[Get_AdjandPhyEmailByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: GJain
-- Create date: 12/28/2015
-- Description: Get Adjuster and Physician email by  ReferralID
-- Version: 1.0
-- ================================================================ 
--[dbo].[[Get_AdjandPhyEmailByReferralID]] 33
CREATE PROCEDURE [dbo].[Get_AdjandPhyEmailByReferralID] 
	@RFAReferralID int
AS

	BEGIN

SELECT     RFAReferrals.RFAReferralID, Adjusters.AdjEMail AS NotificationEmail
FROM         RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      Adjusters ON PatientClaims.PatAdjusterID = Adjusters.AdjusterID where RFAReferralID=@RFAReferralID
                      
                      union all
                      
               SELECT     RFAReferrals.RFAReferralID , Physicians.PhysEMail AS NotificationEmail
FROM         RFAReferrals INNER JOIN
                      Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId where RFAReferralID=@RFAReferralID
	
	
	END

GO
/****** Object:  StoredProcedure [dbo].[Get_AllBodyPartsbyClaimID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singh>
-- Create date: <Create Date,,25-01-2016>
-- Description:	<Description,,to get body part name , status from both body part table by claim id>
-- =============================================
-- =============================================
-- Author:		<Author,,GJain>
-- Create date: <Create Date,,25-01-2016>
-- Description:	<Description,,to get all without paging body part name , status from both body part table by claim id>
-- =============================================

-- =============================================
-- Author:		<Author,,Rkumar>
-- Create date: <Create Date,15-06-2017>
-- Description:	<Description,User Story #3094: Intake - Data Entry - Body Part Selection Dropdown - Add Condition>
-- =============================================

-- [dbo].[Get_AllBodyPartsbyClaimID]152,0,0
CREATE PROCEDURE [dbo].[Get_AllBodyPartsbyClaimID]
	@ClaimID int,
	@Skip int,
	@Take int
AS
BEGIN

CREATE TABLE #Temp(
Row_num int,
BodyPartName varchar(50),
BodyPartStatusName varchar(50), 
TableName  varchar(50),
BodyPartID int
)
;with BodyPartDetails as(
SELECT     (case when isnull(PatientClaimPleadBodyParts.PleadBodyPartCondition,'') <> '' then lookup.BodyParts.BodyPartName + ' - ' +  isnull(PatientClaimPleadBodyParts.PleadBodyPartCondition,'') else lookup.BodyParts.BodyPartName end)

 as BodyPartName, lookup.BodyPartStatuses.BodyPartStatusName, 'Plead' AS TableName, 
                      PatientClaimPleadBodyParts.PatientClaimPleadBodyPartID as BodyPartID
FROM         lookup.BodyParts INNER JOIN
                      PatientClaimPleadBodyParts ON lookup.BodyParts.BodyPartID = PatientClaimPleadBodyParts.PleadBodyPartID INNER JOIN
                      lookup.BodyPartStatuses ON PatientClaimPleadBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID INNER JOIN
                      PatientClaims ON PatientClaimPleadBodyParts.PatientClaimID = PatientClaims.PatientClaimID
WHERE     (PatientClaims.PatientClaimID = @ClaimID)
Union ALL
SELECT      (case when isnull(PatientClaimAddOnBodyParts.AddOnBodyPartCondition,'') <> '' then lookup.BodyParts.BodyPartName + ' - ' +  isnull(PatientClaimAddOnBodyParts.AddOnBodyPartCondition,'') else lookup.BodyParts.BodyPartName end),

lookup.BodyPartStatuses.BodyPartStatusName, 'Add On' AS TableName, 
                      PatientClaimAddOnBodyParts.PatientClaimAddOnBodyPartID as BodyPartID
FROM         PatientClaimAddOnBodyParts INNER JOIN
                      PatientClaims ON PatientClaimAddOnBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
                      lookup.BodyPartStatuses ON PatientClaimAddOnBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
WHERE     (PatientClaims.PatientClaimID = @ClaimID)
)


 Insert into #Temp select ROW_NUMBER() OVER(ORDER BY (select 1 )) Row_num,* FROM  BodyPartDetails ;
	if(@Take=0)
			Begin
			select * from #Temp
			end
			else
		begin
		select * from #Temp where Row_num between @Skip + 1 and @Skip + @Take
	end
drop table #Temp

END


 
GO
/****** Object:  StoredProcedure [dbo].[Get_AllBodyPartsCountbyClaimID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singh>
-- Create date: <Create Date,,25-01-2016>
-- Description:	<Description,,to get body part count from both body part table by claim id>
-- =============================================
-- [dbo].[Get_AllBodyPartsCountbyClaimID]152
CREATE PROCEDURE [dbo].[Get_AllBodyPartsCountbyClaimID]
	@ClaimID int
AS
BEGIN

with BodyPartDetails as(
SELECT       lookup.BodyParts.BodyPartName, lookup.BodyPartStatuses.BodyPartStatusName , 'Pleed Body Part' as TableName
FROM         lookup.BodyParts INNER JOIN
                      PatientClaimPleadBodyParts ON lookup.BodyParts.BodyPartID = PatientClaimPleadBodyParts.PleadBodyPartID INNER JOIN
                      lookup.BodyPartStatuses ON PatientClaimPleadBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID INNER JOIN
                      PatientClaims ON PatientClaimPleadBodyParts.PatientClaimID = PatientClaims.PatientClaimID                      
Where  PatientClaims.PatientClaimID = @ClaimID
Union ALL
SELECT    lookup.BodyParts.BodyPartName, lookup.BodyPartStatuses.BodyPartStatusName,'Addon Body Part' as TableName
FROM         PatientClaimAddOnBodyParts INNER JOIN
                      PatientClaims ON PatientClaimAddOnBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
                      lookup.BodyPartStatuses ON PatientClaimAddOnBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID

Where  PatientClaims.PatientClaimID = @ClaimID
)

select count(*) from BodyPartDetails

END

GO
/****** Object:  StoredProcedure [dbo].[Get_AllClaimAdministrator]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,19-12-2015>
-- Description:	<Description,,get all clients from emp, ins, tpa,mcc with client table>
-- =============================================
--[dbo].[Get_AllClaimAdministrator]
CREATE PROCEDURE [dbo].[Get_AllClaimAdministrator]

AS
BEGIN
SELECT  *,  CASE 
     WHEN lower(ClaimAdministratorType) = 'emp' THEN  (select (ClientName+' - '+ EmpName) as n from Employers where EmployerID = ClaimAdministratorID)
     WHEN lower(ClaimAdministratorType) = 'ins' THEN  (select (ClientName+' - '+ InsName) as n from Insurers where  InsurerID = ClaimAdministratorID )
      WHEN lower(ClaimAdministratorType) = 'tpa' THEN  (select ( ClientName +' - '+ TPAName)  as n from ThirdPartyAdministrators where TPAID = ClaimAdministratorID )
       WHEN lower(ClaimAdministratorType) = 'mcc' THEN  (select ( ClientName +' - '+ CompName)  as n from ManagedCareCompanies where CompanyID = ClaimAdministratorID )
        WHEN lower(ClaimAdministratorType) = 'insb' THEN  (select (ClientName+' - '+ InsBranchName) as n from InsuranceBranches where  InsuranceBranchID = ClaimAdministratorID )
         WHEN lower(ClaimAdministratorType) = 'tpab' THEN  (select (ClientName+' - '+ TPABranchName) as n from ThirdPartyAdministratorBranches where  TPABranchID = ClaimAdministratorID )
      else null  end as ClaimAdministratorName  
FROM         Clients
WHERE  isnull(ClaimAdministratorId,0)<>0
END

GO
/****** Object:  StoredProcedure [dbo].[Get_CertifiedRequestDetailsInitialNotificationLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tarun Gosain
-- Create date: 12-17-2015
-- Description:	to get approved/certified request details for initial notification letter
-- Version: 1.0
-- =============================================
--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

-- [dbo].[Get_CertifiedRequestDetailsInitialNotificationLetter] 1220
CREATE PROCEDURE [dbo].[Get_CertifiedRequestDetailsInitialNotificationLetter](@referralID int)
AS
BEGIN
	SET NOCOUNT ON;
		SELECT req.RFARequestID as [RequestID]
		, case when (select COUNT(*) from RFARequestModifies where rfarequestid= req.rfarequestID) = 1 then (reqm.RFARequestedTreatment) else (req.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (req.RFARequestID)),'')) end as [Treatment]
		, isnull(case when (select COUNT(*) from RFARequestModifies where rfarequestid= req.rfarequestID) = 1 then reqm.RFAFrequency else req.RFAFrequency end,0) as [Frequency]
		, isnull(case when (select COUNT(*) from RFARequestModifies where rfarequestid= req.rfarequestID) = 1 then reqm.RFADuration else req.RFADuration end,0) as [Duration]			
		,(select DurationTypeName from mmc.lookup.DurationTypes where DurationTypeID = 
		(case when (select COUNT(*) from RFARequestModifies where rfarequestid= req.rfarequestID) = 1 then (reqm.RFADurationTypeID) else req.RFADurationTypeID end)) as [DurationType]
		,(select RequestTypeDesc from mmc.lookup.RequestTypes where RequestTypeID = req.RequestTypeID) as [RequestType]			
		,(SELECT [TreatmentTypeDesc] FROM [MMC].[lookup].[TreatmentTypes] where TreatmentTypeID = req.TreatmentTypeID) as [TreatmentType]
		,req.RFAReqCertificationNumber
		,case when DecisionID = 2 then 
		isnull((reqm.RFADuration * reqm.RFAFrequency),1) 
		else
		isnull(req.RFAQuantity,1)		
		end
		as RFAQuantity
	  FROM [MMC].[dbo].[RFARequests] as req	  
	  left join [RFARequestModifies] reqm on  req.RFARequestID = reqm.RFARequestID	  
	where req.RFAReferralID = @referralID and DecisionID in (1,2,12)
	
END


GO
/****** Object:  StoredProcedure [dbo].[Get_ClaimAdministratorAllByClientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 12/24/2015
-- Description: Get all Claim Administrator Details By ClientID
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_ClaimAdministratorAllByClientID] 16
CREATE PROCEDURE [dbo].[Get_ClaimAdministratorAllByClientID] 
	@ClientID int
AS
	BEGIN
			select * from (SELECT     ClientEmployers.ClientID,  Employers.EmpName as Name ,ClientEmployers.EmployerID as Id ,
			(convert(varchar(10),ClientEmployers.EmployerID) + '-' + 'emp' ) as Ids
			FROM         ClientEmployers INNER JOIN
								  Employers ON ClientEmployers.EmployerID = Employers.EmployerID
			where ClientEmployers.ClientID = @ClientID
			
			union
			
			SELECT     ClientInsurers.ClientID, Insurers.InsName  as Name , Insurers.InsurerID as Id ,
			(convert(varchar(10),ClientInsurers.InsurerID) + '-' + 'ins' ) as Ids
			
			FROM         ClientInsurers INNER JOIN
								  Insurers ON ClientInsurers.InsurerID = Insurers.InsurerID
			WHERE     (ClientInsurers.ClientID = @ClientID)
			
			union
			
			SELECT     ClientInsuranceBranches.ClientID,  InsuranceBranches.InsBranchName  as Name , InsuranceBranches.InsuranceBranchID as Id,
			(convert(varchar(10),ClientInsuranceBranches.InsuranceBranchID) + '-' + 'insb' ) as Ids
			FROM         ClientInsuranceBranches INNER JOIN
								  InsuranceBranches ON ClientInsuranceBranches.InsuranceBranchID = InsuranceBranches.InsuranceBranchID
			WHERE     (ClientInsuranceBranches.ClientID = @ClientID)
			
			union
			
			SELECT     ClientManagedCareCompanies.ClientID, ManagedCareCompanies.CompName  as Name , ManagedCareCompanies.CompanyID as Id ,
			(convert(varchar(10),ClientManagedCareCompanies.CompanyID) + '-' + 'mcc' ) as Ids
			FROM         ClientManagedCareCompanies INNER JOIN
								  ManagedCareCompanies ON ClientManagedCareCompanies.CompanyID = ManagedCareCompanies.CompanyID
			WHERE     (ClientManagedCareCompanies.ClientID = @ClientID)
			
			union
			
			SELECT     ClientThirdPartyAdministrators.ClientID, ThirdPartyAdministrators.TPAName   as Name , ThirdPartyAdministrators.TPAID as Id ,
			(convert(varchar(10),ClientThirdPartyAdministrators.TPAID) + '-' + 'tpa' ) as Ids
			FROM         ClientThirdPartyAdministrators INNER JOIN
								  ThirdPartyAdministrators ON ClientThirdPartyAdministrators.TPAID = ThirdPartyAdministrators.TPAID
			WHERE     (ClientThirdPartyAdministrators.ClientID = @ClientID)
			
			union
			
			SELECT     ClientThirdPartyAdministratorBranches.ClientID,   ThirdPartyAdministratorBranches.TPABranchName as Name ,ThirdPartyAdministratorBranches.TPABranchID as Id,
			(convert(varchar(10),ClientThirdPartyAdministratorBranches.TPABranchID) + '-' + 'tpab' ) as Ids
			FROM         ClientThirdPartyAdministratorBranches INNER JOIN
                      ThirdPartyAdministratorBranches ON ClientThirdPartyAdministratorBranches.TPABranchID = ThirdPartyAdministratorBranches.TPABranchID
			WHERE     (ClientThirdPartyAdministratorBranches.ClientID = @ClientID))tbl order by Name
	
	END

GO
/****** Object:  StoredProcedure [dbo].[Get_ClaimAdministratorByClientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 10/29/2015
-- Description: Get Claim Administrator Details By ClientID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_ClaimAdministratorByClientID] 1
CREATE PROCEDURE [dbo].[Get_ClaimAdministratorByClientID] 
	@ClientID int
AS

	BEGIN

	 SELECT  *,  CASE 
		 WHEN lower(ClaimAdministratorType) = 'emp' THEN  (select EmpName as n from Employers where EmployerID = ClaimAdministratorID)
		 WHEN lower(ClaimAdministratorType) = 'ins' THEN  (select InsName as n from Insurers where  InsurerID = ClaimAdministratorID )
		   WHEN lower(ClaimAdministratorType) = 'insb' THEN  (select InsBranchName as InsBranchName   from InsuranceBranches where  InsuranceBranchID = ClaimAdministratorID )
		 WHEN lower(ClaimAdministratorType) = 'tpa' THEN  (select TPAName  as n from ThirdPartyAdministrators where TPAID = ClaimAdministratorID )
		 WHEN lower(ClaimAdministratorType) = 'mcc' THEN  (select CompName  as n from ManagedCareCompanies where CompanyID = ClaimAdministratorID )
		 else null end as ClaimAdministratorName
	FROM         Clients where ClientID=@ClientID
	
	
	END

GO
/****** Object:  StoredProcedure [dbo].[Get_ClientDetailsByName]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 12/19/2015
-- Description: Get Client Details By Name
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_ClientDetailsByName] 't',0,10
CREATE PROCEDURE [dbo].[Get_ClientDetailsByName] 
	@SearchText varchar(max),
	@Skip int,
	@Take int
AS

	BEGIN
	
	WITH ClientDetailsByName AS
		(
			 SELECT   ROW_NUMBER() Over(Order by ClientID desc) as Row_ID,   ClientID, ClientName, ClaimAdministratorID, ClaimAdministratorType, CASE WHEN lower(ClaimAdministratorType) = 'emp' THEN
                          (SELECT     EmpName AS n
                            FROM          Employers
                            WHERE      EmployerID = ClaimAdministratorID) WHEN lower(ClaimAdministratorType) = 'ins' THEN
                          (SELECT     InsName AS n
                            FROM          Insurers
                            WHERE      InsurerID = ClaimAdministratorID) WHEN lower(ClaimAdministratorType) = 'insb' THEN
                          (SELECT     InsBranchName AS n
                            FROM          InsuranceBranches
                            WHERE      InsuranceBranchID = ClaimAdministratorID) WHEN lower(ClaimAdministratorType) = 'tpa' THEN
                          (SELECT     TPAName AS n
                            FROM          ThirdPartyAdministrators
                            WHERE      TPAID = ClaimAdministratorID) WHEN lower(ClaimAdministratorType) = 'tpab' THEN
                          (SELECT     TPABranchName AS n
                            FROM          ThirdPartyAdministratorBranches
                            WHERE      TPABranchID = ClaimAdministratorID) WHEN lower(ClaimAdministratorType) = 'mcc' THEN
                          (SELECT     CompName AS n
                            FROM          ManagedCareCompanies
                            WHERE      CompanyID = ClaimAdministratorID) ELSE NULL END AS ClaimAdministratorName
			FROM         Clients  where ClientName like @SearchText +'%'
		)
		SELECT * FROM ClientDetailsByName as ClientDetailsByName
		WHERE Row_ID BETWEEN @Skip + 1 AND @Skip + @Take
	END

GO
/****** Object:  StoredProcedure [dbo].[Get_ClientInsuranceBranchesAllByInsurerID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 01/12/2016
-- Description: Get Client Insurance Branches All By InsurerID
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_ClientInsuranceBranchesAllByInsurerID] 16
Create PROCEDURE [dbo].[Get_ClientInsuranceBranchesAllByInsurerID] 
	@ClientID int,
	@InsurerID int
AS
	BEGIN
				Select * from InsuranceBranches where InsurerId = @InsurerID and InsuranceBranchID not in (SELECT       InsuranceBranchID
				FROM         ClientInsuranceBranches
				WHERE     (ClientID = @ClientID))
	
	END

GO
/****** Object:  StoredProcedure [dbo].[Get_ClientTPABranchesAllByTPAID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 01/12/2016
-- Description: Get Client TPA Branches All By TPAID
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_ClientTPABranchesAllByTPAID] 5,5
CREATE PROCEDURE [dbo].[Get_ClientTPABranchesAllByTPAID] 
	@ClientID int,
	@TPAID int
AS
	BEGIN
				SELECT     TPABranchID, TPAID, TPABranchName FROM ThirdPartyAdministratorBranches 
					where tpaid = @TPAID and TPABranchID not in (SELECT       TPABranchID
						FROM         ClientThirdPartyAdministratorBranches
							WHERE     (ClientID = @ClientID))
	
	END

GO
/****** Object:  StoredProcedure [dbo].[Get_ClinicalTriage]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 10/26/2015
-- Description: GET All ClinicalTriage 
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_ClinicalTriage] 
	@skip int,
	@take int
AS

	BEGIN
	 WITH ClinicalTriage AS
   ( SELECT  ROW_NUMBER() over (Order by RFARequests.RFARequestID desc)as rownumber, RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
                      lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName
FROM         RFARequests INNER JOIN
                      RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      Patients ON PatientClaims.PatientID = Patients.PatientID INNER JOIN
                      lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID
	)
	SELECT * FROM ClinicalTriage
	where rownumber between @skip+1 and (@skip+@take) 

	
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DecisionStatusDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Mkhurana>
-- Create date: <08-sept-2017>
-- Description:	<to get status dropdown as per task 3126>
-- =============================================
CREATE PROCEDURE [dbo].[Get_DecisionStatusDetails] 
	
AS
BEGIN
	-- select distinct rtrim(ltrim(lookup.Decisions.DecisionDesc)) as DecisionDesc, lookup.Decisions.DecisionID  
 --from lookup.Decisions inner join 
 --dbo.RFARequests on lookup.Decisions.DecisionID=dbo.RFARequests.DecisionID order by lookup.Decisions.DecisionID
 SELECT distinct
 (case when (RFARequests.DecisionDate IS NULL And RFAProcessLevels.ProcessLevel>60)
             then (Case when(RFARequests.RFAStatus = 'SendToPreparation') then 'Preparation'
                         when(RFARequests.RFAStatus = 'SendToClinical') then 'Clinical'
                         when(RFARequests.DecisionID = 13) then 'Withdrawn'
                         when(RFARequests.DecisionID = 12) then 'Client Authorized'
                         else lookup.ProcessLevels.ProcessLevelDesc end)
			else  (case when exists(select top 1 imrreq.RFARequestID from IMRRFARequests imrreq where imrreq.RFARequestID = RFARequests.RFARequestID) 
					then (select IMRDecisionDesc from lookup.IMRDecision where IMRDecisionID = (select imrref.IMRDecisionID from IMRRFAReferrals imrref where imrref.RFAReferralID = RFAReferrals.RFAReferralID))
					else lookup.Decisions.DecisionDesc end)
			end) as Status
			
			 
			FROM         PatientClaims INNER JOIN
						  RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID INNER JOIN
						  RFARequests ON RFAReferrals.RFAReferralID = RFARequests.RFAReferralID INNER JOIN
						  
						  lookup.Decisions ON RFARequests.DecisionID = lookup.Decisions.DecisionID INNER JOIN
						  RFAProcessLevels ON RFAReferrals.RFAReferralID = RFAProcessLevels.RFAReferralID INNER JOIN
						  lookup.ProcessLevels ON RFAProcessLevels.ProcessLevel = lookup.ProcessLevels.ProcessLevel
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DelayedBodyPartByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Mkhurana>
-- Create date: <05-Sept-2017>
-- Description:	<To get Delayed BodyPart as per task #3125>
-- =============================================
--[dbo].[Get_DelayedBodyPartByReferralID] 1184
CREATE PROCEDURE [dbo].[Get_DelayedBodyPartByReferralID](@ReferralID int)
AS
BEGIN

	DECLARE @PatientClaimID int
				
	set @PatientClaimID = (SELECT     isnull(PatientClaimID,0) FROM         RFAReferrals where RFAReferralID =@ReferralID)

	SELECT BodyPartName
INTO #Temp
FROM(   
			SELECT   (CASE WHEN PatientClaimAddOnBodyParts.AddOnBodyPartCondition IS NULL  THEN  lookup.BodyParts.BodyPartName 
	                     ELSE lookup.BodyParts.BodyPartName+' ('+PatientClaimAddOnBodyParts.AddOnBodyPartCondition+')' End) AS BodyPartName,PatientClaimAddOnBodyParts.patientclaimaddonbodypartid as id
						FROM         PatientClaimAddOnBodyParts INNER JOIN
								  PatientClaims ON PatientClaimAddOnBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
								  lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
								  lookup.BodyPartStatuses ON PatientClaimAddOnBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
						where PatientClaims.PatientClaimID = @PatientClaimID and lookup.BodyPartStatuses.BodyPartStatusID = 3  			
						
			UNION

			SELECT     (CASE WHEN PatientClaimPleadBodyParts.PleadBodyPartCondition IS NULL  THEN  lookup.BodyParts.BodyPartName 
	                     ELSE lookup.BodyParts.BodyPartName+' ('+PatientClaimPleadBodyParts.PleadBodyPartCondition+')' End) AS BodyPartName,PatientClaimPleadBodyParts.patientclaimpleadbodypartid as id
									FROM         PatientClaimPleadBodyParts INNER JOIN
								  PatientClaims ON PatientClaimPleadBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
								  lookup.BodyParts ON PatientClaimPleadBodyParts.PleadBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
								  lookup.BodyPartStatuses ON PatientClaimPleadBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
						where PatientClaims.PatientClaimID = @PatientClaimID and lookup.BodyPartStatuses.BodyPartStatusID = 3						
			)as hh
			group by hh.BodyPartName order by min(hh.id)
	DECLARE @Consolidated_AcceptedBodyParts varchar(Max)
	DECLARE   @SQLQuery AS NVARCHAR(MAX)
				DECLARE   @PivotColumns AS NVARCHAR(MAX)
				 
				--Get unique values of pivot column  
				SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(BodyPartName)
				FROM (
					select  BodyPartName from #temp
					
				) AS PivotExample
				 
				SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', '')
				
				drop table #temp
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DeniedBodyPartByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,16-12-2015>
-- Description:	<Description,,get comma seperated accepted body parts by referral id>
-- =============================================
--[dbo].[Get_DeniedBodyPartByReferralID]32
CREATE PROCEDURE [dbo].[Get_DeniedBodyPartByReferralID] 
(
@ReferralID int
)
AS
BEGIN
		DECLARE @PatientClaimID int
				
	set @PatientClaimID = (SELECT     isnull(PatientClaimID,0) FROM         RFAReferrals where RFAReferralID =@ReferralID)

	SELECT BodyPartName
INTO #Temp
FROM(   
			SELECT      (CASE WHEN PatientClaimAddOnBodyParts.AddOnBodyPartCondition IS NULL  THEN  lookup.BodyParts.BodyPartName 
	                     ELSE lookup.BodyParts.BodyPartName+' ('+PatientClaimAddOnBodyParts.AddOnBodyPartCondition+')' End) AS BodyPartName,PatientClaimAddOnBodyParts.patientclaimaddonbodypartid as id
						FROM         PatientClaimAddOnBodyParts INNER JOIN
								  PatientClaims ON PatientClaimAddOnBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
								  lookup.BodyParts ON PatientClaimAddOnBodyParts.AddOnBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
								  lookup.BodyPartStatuses ON PatientClaimAddOnBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
						where PatientClaims.PatientClaimID = @PatientClaimID and lookup.BodyPartStatuses.BodyPartStatusID = 2  			
						
			UNION

			SELECT     (CASE WHEN PatientClaimPleadBodyParts.PleadBodyPartCondition IS NULL  THEN  lookup.BodyParts.BodyPartName 
	                     ELSE lookup.BodyParts.BodyPartName+' ('+PatientClaimPleadBodyParts.PleadBodyPartCondition+')' End) AS BodyPartName,PatientClaimPleadBodyParts.patientclaimpleadbodypartid as id
									FROM         PatientClaimPleadBodyParts INNER JOIN
								  PatientClaims ON PatientClaimPleadBodyParts.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
								  lookup.BodyParts ON PatientClaimPleadBodyParts.PleadBodyPartID = lookup.BodyParts.BodyPartID INNER JOIN
								  lookup.BodyPartStatuses ON PatientClaimPleadBodyParts.BodyPartStatusID = lookup.BodyPartStatuses.BodyPartStatusID
						where PatientClaims.PatientClaimID = @PatientClaimID and lookup.BodyPartStatuses.BodyPartStatusID = 2						
			)as hh
			group by hh.BodyPartName order by min(hh.id)
	DECLARE @Consolidated_AcceptedBodyParts varchar(Max)
	DECLARE   @SQLQuery AS NVARCHAR(MAX)
				DECLARE   @PivotColumns AS NVARCHAR(MAX)
				 
				--Get unique values of pivot column  
				SELECT   @PivotColumns= COALESCE(@PivotColumns + ', ','') + QUOTENAME(BodyPartName)
				FROM (
					select  BodyPartName from #temp
					
				) AS PivotExample
				 
				SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', '')
				
				drop table #temp
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DeniedRequestDetailsInitialNotificationLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tarun Gosain
-- Create date: 12-17-2015
-- Description:	to get approved/certified request details for initial notification letter
-- Version: 1.0
-- =============================================

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

-- [dbo].[Get_DeniedRequestDetailsInitialNotificationLetter] 1220
CREATE PROCEDURE [dbo].[Get_DeniedRequestDetailsInitialNotificationLetter](@referralID int)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT req.RFARequestID as [RequestID], (req.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (req.RFARequestID)),''))  as [Treatment]
		, isnull(req.RFAFrequency,0) as [Frequency]
		, isnull(req.RFADuration,0) as [Duration]	
		,case when DecisionID = 2 then 
			(case 
				when ((isnull(req.RFAFrequency,1) * isnull(req.RFADuration,1)) - (isnull(reqm.RFAFrequency,0) *  isnull(reqm.RFADuration,0))) = 0 then 1 
			 else 
				(isnull(req.RFAFrequency,1) * isnull(req.RFADuration,1)) - (isnull(reqm.RFAFrequency,0) *  isnull(reqm.RFADuration,0)) end)
		else
		req.RFAQuantity
		END
		as QTY
		, isnull(case when (select COUNT(*) from RFARequestModifies where rfarequestid= req.rfarequestID) = 1 
			then ((select DurationTypeName from mmc.lookup.DurationTypes where DurationTypeID = reqm.RFADurationTypeID))
			else ((select DurationTypeName from mmc.lookup.DurationTypes where DurationTypeID = req.RFADurationTypeID)) end,0) as [DurationType]						
	  FROM [MMC].[dbo].[RFARequests] as req
	    left join [RFARequestModifies] reqm on  req.RFARequestID = reqm.RFARequestID
where req.RFAReferralID = @referralID and DecisionID in (2, 3, 9)
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DetailsForBillingLanding]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Tarun Gosain
-- Create date: 15-03-2016
-- Description:	To get details for billing landing page.

-- Revision History:
-- 1.0 -	TGosain
--			Initial version.
-- 1.1 -    MMSingh
--          28 march 2016
-- Description:	To get details for billing landing page add admin.
-- 1.2 -    MMSingh
--			30 march 2016  
-- Description:	To get details for billing landing page get according to client Name ,RFARequestDate.
-- 1.3 -	TGosain
--			01 June 2016
-- Description: Adding Deferral value to the billing total.
-- ==================================================================================================

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.4
-- ================================================================ 

-- [dbo].[Get_DetailsForBillingLanding]0,1000
CREATE PROCEDURE [dbo].[Get_DetailsForBillingLanding]
@skip int, @take int
AS
BEGIN
	SET NOCOUNT ON;

with BillingDetails as(
		select  ROW_NUMBER() Over(Order by ltrim(rtrim(Clients.ClientName)),DecisionDate DESC) as ROW,Clients.ClientName
		,Patients.PatFirstName +' '+Patients.PatLastName as PatientName
		, RFAReferrals.RFAReferralID
		, RFARequests.RFARequestID
		, (CASE WHEN EXISTS(SELECT rfMOD.RFARequestedTreatment   FROM [MMC].[dbo].[RFARequestModifies] rfMOD WHERE  rfMOD.RFARequestID = RFARequests.RFARequestID) 
		THEN  (SELECT rfaMOD.RFARequestedTreatment  FROM [MMC].[dbo].[RFARequestModifies] rfaMOD WHERE  rfaMOD.RFARequestID = RFARequests.RFARequestID)  
		ELSE (RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) END) AS RFARequestedTreatment
		, RFARequests.DecisionDate
		, PatientClaims.PatientClaimID
		, PatientClaims.PatClientID
		, isnull(RFARequestBillings.RFARequestBillingID,0.0) as RFARequestBillingID
		, isnull(RFARequestBillings.RFARequestBillingRN,0.0)as RFARequestBillingRN
		, isnull(RFARequestBillings.RFARequestBillingMD,0.0)as RFARequestBillingMD
		, isnull(RFARequestBillings.RFARequestBillingSpeciality,0) as RFARequestBillingSpeciality
		, isnull(RFARequestBillings.RFARequestBillingAdmin,0) as RFARequestBillingAdmin
		, ISNULL(RFARequestBillings.RFARequestBillingDeferral,0) AS RFARequestBillingDeferral
		, isnull(round(RFARequestBillings.RFARequestBillingRN * ISNULL(ClientBillingRetailRates.ClientBillingRetailRateRN ,0)
		+ ISNULL(RFARequestBillings.RFARequestBillingMD,0) * ISNULL(ClientBillingRetailRates.ClientBillingRetailRateMD,0)  
		+ ISNULL(RFARequestBillings.RFARequestBillingAdmin,0) * ISNULL(ClientBillingRetailRates.ClientBillingRetailRateAdminFee,0)
		+ ISNULL(RFARequestBillings.RFARequestBillingSpeciality,0)  * ISNULL(ClientBillingRetailRates.ClientBillingRetailRateSpecialityReview,0)
		+ ISNULL(RFARequestBillingDeferral,0) * IsNull(ClientBillingRetailRates.ClientBillingRetailRateDeferral,0),2),0) as BillingTotal	
		, ClientBillings.ClientBillingRateTypeID, ISNULL(RFARequests.DecisionID, 0) AS DecisionID
	from PatientClaims
	inner join Patients on patients.PatientID = PatientClaims.PatientID
	inner join Clients on PatClientID = ClientID
	inner join RFAReferrals on RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID
	inner join RFAProcessLevels on RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID			
	--AND NOT EXISTS(select [RFAReferralID] from RFAProcessLevels rl where rl.RFAReferralID = RFAReferrals.RFAReferralID and ProcessLevel > 160 )
	inner join RFARequests on RFAReferrals.RFAReferralID = RFARequests.RFAReferralID
	left join RFARequestBillings on RFARequestBillings.RFARequestID = RFARequests.RFARequestID
	inner join ClientBillings on ClientBillings.ClientID = Clients.ClientID
	inner join ClientBillingRetailRates on ClientBillingRetailRates.ClientBillingID =  ClientBillings.ClientBillingID		
	where 
	(select top 1 [ProcessLevel] from RFAProcessLevels rl where rl.RFAReferralID = RFAProcessLevels.RFAReferralID order by rl.RFAProcessLevelID desc) = 160 	
	 and 
	ProcessLevel=160
	)
	Select * from BillingDetails as BillingDetail
		WHERE Row BETWEEN @Skip + 1 AND @Skip + @Take
		 
END
GO
/****** Object:  StoredProcedure [dbo].[Get_DetailsForBillingLandingByClientName]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author:		Mahinder Singh
-- Create date: 30-03-2016
-- Description:	To get details for billing landing page search by client name.

-- Revision History:
-- 1.1 -	TGosain
--			01 June 2016
-- Description: Adding Deferral value to the billing total.
-- ============================================================================
-- [dbo].[[Get_DetailsForBillingLandingByClientName]0,20
CREATE PROCEDURE [dbo].[Get_DetailsForBillingLandingByClientName]
@ClientName VARCHAR(50),@skip INT, @take INT
AS
BEGIN
	SET NOCOUNT ON;

WITH BillingDetailByClient AS(
	SELECT  ROW_NUMBER() OVER(ORDER BY LTRIM(RTRIM(Clients.ClientName)),DecisionDate DESC) AS ROW,Clients.ClientName
	,Patients.PatFirstName +' '+Patients.PatLastName AS PatientName
	, RFAReferrals.RFAReferralID
	, RFARequests.RFARequestID
	, (RFARequests.RFARequestedTreatment	 +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) as RFARequestedTreatment
	, RFARequests.DecisionDate
	, PatientClaims.PatientClaimID
	, PatientClaims.PatClientID
	, ISNULL(RFARequestBillings.RFARequestBillingID,0.0) AS RFARequestBillingID
	, ISNULL(RFARequestBillings.RFARequestBillingRN,0.0)AS RFARequestBillingRN
	, ISNULL(RFARequestBillings.RFARequestBillingMD,0.0)AS RFARequestBillingMD
	, ISNULL(RFARequestBillings.RFARequestBillingSpeciality,0) AS RFARequestBillingSpeciality
	, ISNULL(RFARequestBillings.RFARequestBillingAdmin,0) AS RFARequestBillingAdmin	
	, ISNULL(RFARequestBillings.RFARequestBillingDeferral,0) AS RFARequestBillingDeferral
	, ISNULL(ROUND(RFARequestBillings.RFARequestBillingRN * ClientBillingRetailRates.ClientBillingRetailRateRN 
	+ ISNULL(RFARequestBillings.RFARequestBillingMD,0) * ISNULL(ClientBillingRetailRates.ClientBillingRetailRateMD,0)  
	+ ISNULL(RFARequestBillings.RFARequestBillingAdmin,0) * ISNULL(ClientBillingRetailRates.ClientBillingRetailRateAdminFee,0)
	+ ISNULL(RFARequestBillings.RFARequestBillingSpeciality,0)  * ISNULL(ClientBillingRetailRates.ClientBillingRetailRateSpecialityReview,0)
	+ ISNULL(RFARequestBillingDeferral,0) * IsNull(ClientBillingRetailRates.ClientBillingRetailRateDeferral,0),2),0) as BillingTotal		
	, ClientBillings.ClientBillingRateTypeID, ISNULL(RFARequests.DecisionID, 0) AS DecisionID
	FROM PatientClaims
	INNER JOIN Patients ON patients.PatientID = PatientClaims.PatientID
	INNER JOIN Clients ON PatClientID = ClientID
	INNER JOIN RFAReferrals ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID
	INNER JOIN RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID
	INNER JOIN RFARequests ON RFAReferrals.RFAReferralID = RFARequests.RFAReferralID
	LEFT JOIN RFARequestBillings ON RFARequestBillings.RFARequestID = RFARequests.RFARequestID
	INNER JOIN ClientBillings ON ClientBillings.ClientID = Clients.ClientID
	INNER JOIN ClientBillingRetailRates ON ClientBillingRetailRates.ClientBillingID =  ClientBillings.ClientBillingID	
	where 
	(select top 1 [ProcessLevel] from RFAProcessLevels rl where rl.RFAReferralID = RFAProcessLevels.RFAReferralID order by rl.RFAProcessLevelID desc) = 160 	
	 and 
	ProcessLevel=160
	AND Clients.ClientName = @ClientName
	)
	SELECT * FROM BillingDetailByClient AS BillingDetail
		WHERE Row BETWEEN @Skip + 1 AND @Skip + @Take
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DetailsForBillingLandingByClientNameCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================
-- Author:		Mahinder Singh
-- Create date: 30-03-2016
-- Description:	To get details for billing landing page by client name.
-- ===================================================================
-- [dbo].[Get_DetailsForBillingLandingByClientCount]152
CREATE PROCEDURE [dbo].[Get_DetailsForBillingLandingByClientNameCount]
@ClientName VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT  
	COUNT(*) AS TotalCount	
	FROM PatientClaims
	INNER JOIN Patients on patients.PatientID = PatientClaims.PatientID
	INNER JOIN Clients on PatClientID = ClientID
	INNER JOIN RFAReferrals on RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID
	INNER JOIN RFAProcessLevels on RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID
	INNER JOIN RFARequests on RFAReferrals.RFAReferralID = RFARequests.RFAReferralID
	LEFT JOIN RFARequestBillings on RFARequestBillings.RFARequestID = RFARequests.RFARequestID
	INNER JOIN ClientBillings on ClientBillings.ClientID = Clients.ClientID
	INNER JOIN ClientBillingRetailRates on ClientBillingRetailRates.ClientBillingID =  ClientBillings.ClientBillingID	
	where 
	(select top 1 [ProcessLevel] from RFAProcessLevels rl where rl.RFAReferralID = RFAProcessLevels.RFAReferralID order by rl.RFAProcessLevelID desc) = 160 	
	 and 
	ProcessLevel=160 AND Clients.ClientName = @ClientName
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DetailsForBillingLandingCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tarun Gosain
-- Create date: 15-03-2016
-- Description:	To get details for billing landing page.

-- Revision History:
-- 1.0 -	TGosain
--			Initial version.
-- =============================================
-- [dbo].[Get_InitialNotificationLetterDetails]152
CREATE PROCEDURE [dbo].[Get_DetailsForBillingLandingCount]
AS
BEGIN
	SET NOCOUNT ON;
	select  
	COUNT(*) as TotalCount	
	from PatientClaims
	inner join Patients on patients.PatientID = PatientClaims.PatientID
	inner join Clients on PatClientID = ClientID
	inner join RFAReferrals on RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID
	inner join RFAProcessLevels on RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID
	inner join RFARequests on RFAReferrals.RFAReferralID = RFARequests.RFAReferralID
	left join RFARequestBillings on RFARequestBillings.RFARequestID = RFARequests.RFARequestID
	inner join ClientBillings on ClientBillings.ClientID = Clients.ClientID
	inner join ClientBillingRetailRates on ClientBillingRetailRates.ClientBillingID =  ClientBillings.ClientBillingID	
	where 
	(select top 1 [ProcessLevel] from RFAProcessLevels rl where rl.RFAReferralID = RFAProcessLevels.RFAReferralID order by rl.RFAProcessLevelID desc) = 160 	
	 and 
	ProcessLevel=160
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DeterminationLetterDecisionDesc]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 03/08/2016
-- Description: GET  DeterminationLetter DecisionDesc 
-- Version: 1.0
--Get_DeterminationLetterDecisionDesc 126
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_DeterminationLetterDecisionDesc] 
(
@referralID int
)
AS
BEGIN
select top 1
(CASE 
					WHEN (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID and (DecisionID = 1 OR DecisionID = 12))
					= (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID) THEN 'Certified' 
				ELSE 
					(CASE WHEN (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID and DecisionID = 3) 
					 = (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID) THEN 'Denied' 
				ELSE 'Modified' END)END) AS [DecisionDesc] 
				from  [MMC].[dbo].[RFARequests] WHERE RFAReferralID=@referralID
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DiagnosisByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,16-12-2015>
-- Description:	<Description,,get comma seperated diagnosis by referral id>
-- =============================================
CREATE PROCEDURE [dbo].[Get_DiagnosisByReferralID] 
(
@ReferralID int
)
AS
BEGIN
	select  [dbo].[CommaSeperateDiagnosisByRFAReferralID](@ReferralID)
END

GO
/****** Object:  StoredProcedure [dbo].[Get_EmailRecordAttachmentByEmailRecordId]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: MAHINDER SINGH
-- Create date: 08-JULY-2016
-- Description: GET Email Record Attachment By Email RecordId
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_EmailRecordAttachmentByEmailRecordId] 1
CREATE PROCEDURE [dbo].[Get_EmailRecordAttachmentByEmailRecordId]
	@EmailRecordId INT
	
AS
BEGIN
    SELECT era.EmailAttachmentId,era.EmailRecordId,era.DocumentName,era.DocumentPath,er.EmRecTo,er.EmRecCC,er.EmRecSubject,er.EmRecBody
    FROM EmailRecordAttachments era 
    INNER JOIN EmailRecords er ON er.EmailRecordId = era.EmailRecordId
    WHERE era.EmailRecordId = @EmailRecordId
  
END

GO
/****** Object:  StoredProcedure [dbo].[Get_ICDCodesByNumber]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 04 MAY 2016
-- Description:	Get all by icdCode EITHER ICD9 OR ICD10
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_ICDCodesByNumber] 
@ICDNumber VARCHAR(50),@ICDTab VARCHAR(10)

AS
BEGIN
	SET NOCOUNT ON;	
	IF(@ICDTab ='ICD9')
	BEGIN
			SELECT  [icdICD9NumberID] AS icdICDNumberID
				  ,[icdICD9Number] AS icdICDNumber
				  ,[ICD9Description] AS ICDDescription
				  ,[ICD9Type] AS ICDType
				  ,'ICD9' AS icdICDTab
		    FROM [MMC].[lookup].[ICD9Codes] WHERE icdICD9Number = RTRIM(LTRIM(@ICDNumber ))
    END 
    IF(@ICDTab ='ICD10')
    BEGIN
            SELECT  [icdICD10NumberID] AS icdICDNumberID
				  ,[icdICD10Number] AS icdICDNumber
				  ,[ICD10Description] AS ICDDescription
				  ,'1' AS ICDType
				  ,'ICD10' AS icdICDTab
            FROM [MMC].[lookup].[ICD10Codes] WHERE icdICD10Number = RTRIM(LTRIM(@ICDNumber))
    END

END

GO
/****** Object:  StoredProcedure [dbo].[Get_ICDCodesByNumberOrDescription]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================
-- Author     : Mahinder Singh
-- Create date: 05 MAY 2016
-- Description:	Get all by icdCode EITHER ICD9 OR ICD10 BY Number or Description
-- =============================================================================
CREATE PROCEDURE [dbo].[Get_ICDCodesByNumberOrDescription] 
@ICDNumberOrDescription VARCHAR(MAX),
@ICD9Type VARCHAR(1),
@ICDTab VARCHAR(10),
@Skip INT,
@Take INT

AS
BEGIN
	SET NOCOUNT ON;	
	IF(@ICDTab ='ICD9')
	BEGIN
	    WITH ICDCodesByNumberOrDescription AS(
				SELECT ROW_NUMBER() OVER(ORDER BY [icdICD9NumberID]) AS ROW,  [icdICD9NumberID] AS icdICDNumberID
					  ,[icdICD9Number] AS icdICDNumber
					  ,[ICD9Description] AS ICDDescription
					  ,[ICD9Type] AS ICDType
					  ,'ICD9' AS icdICDTab
				FROM [MMC].[lookup].[ICD9Codes] 
				WHERE (icdICD9Number LIKE '%'+ @ICDNumberOrDescription +'%' OR ICD9Description LIKE '%'+ @ICDNumberOrDescription +'%')
					   AND [ICD9Type] = @ICD9Type
		       )
		SELECT * FROM ICDCodesByNumberOrDescription AS CODE
		WHERE CODE.ROW BETWEEN @Skip + 1 AND @Skip + @Take
    END 
    IF(@ICDTab ='ICD10')
    BEGIN
       WITH ICDCodesByNumberOrDescription AS(
				SELECT ROW_NUMBER() OVER(ORDER BY [icdICD10NumberID]) AS ROW,  [icdICD10NumberID] AS icdICDNumberID
					  ,[icdICD10Number] AS icdICDNumber
					  ,[ICD10Description] AS ICDDescription
					  ,'1' AS ICDType
					  ,'ICD10' AS icdICDTab
				FROM [MMC].[lookup].[ICD10Codes] 
				WHERE (icdICD10Number LIKE '%'+ @ICDNumberOrDescription +'%' OR ICD10Description LIKE '%'+ @ICDNumberOrDescription +'%')
				
		    )
		SELECT * FROM ICDCodesByNumberOrDescription AS CODE
		WHERE CODE.ROW BETWEEN @Skip + 1 AND @Skip + @Take
    END

END

GO
/****** Object:  StoredProcedure [dbo].[Get_ICDCodesByNumberOrDescriptionCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author     : Mahinder Singh
-- Create date: 05 MAY 2016
-- Description:	Get all by icdCode EITHER ICD9 OR ICD10 BY Number or Description COUNT
-- ====================================================================================
CREATE PROCEDURE [dbo].[Get_ICDCodesByNumberOrDescriptionCount] 
@ICDNumberOrDescription VARCHAR(MAX),
@ICD9Type VARCHAR(1),
@ICDTab VARCHAR(10)

AS
BEGIN
	SET NOCOUNT ON;	
	IF(@ICDTab ='ICD9')
	BEGIN	    
		SELECT COUNT(*) as TotalCount
		FROM [MMC].[lookup].[ICD9Codes] 
		WHERE (icdICD9Number LIKE '%'+ @ICDNumberOrDescription +'%' OR ICD9Description LIKE '%'+ @ICDNumberOrDescription +'%')
			   AND [ICD9Type] = @ICD9Type
		      
    END 
    IF(@ICDTab ='ICD10')
    BEGIN
		SELECT COUNT(*) as TotalCount
		FROM [MMC].[lookup].[ICD10Codes] 
		WHERE (icdICD10Number LIKE '%'+@ICDNumberOrDescription +'%' OR ICD10Description LIKE '%'+@ICDNumberOrDescription +'%')
		      	  
    END
END

GO
/****** Object:  StoredProcedure [dbo].[Get_IMRDecisionPageDetailsByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_IMRDecisionPageDetailsByReferralID]
	@RFAReferralID int
AS
Begin
Select rfareferrals.RFAReferralID
		, IMRRFAReferrals.IMRRFAReferralID
		, PatientClaims.PatientClaimID
		, PatientClaims.PatClaimNumber
		, Patients.PatientID		
		, Patients.PatFirstName
		, Patients.PatLastName		
		, IMRResponseDate + 30 as DueDate
		,IMRRFAReferrals.IMRDecisionReceivedDate
		, isnull(IMRRFAReferrals.IMRDecisionID,1) as IMRDecisionID
From RFAReferrals 
	Inner join PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID 
	INNER JOIN Patients ON PatientClaims.PatientID = Patients.PatientID 
	Inner Join IMRRFAReferrals ON RFAReferrals.RFAReferralID = IMRRFAReferrals.RFAReferralID
Where RFAReferrals.RFAReferralID=@RFAReferralID

END
GO
/****** Object:  StoredProcedure [dbo].[Get_IMRDecisionPageRequestDetailsByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: TGosain
-- Create date: 07/12/2016
-- Description: GET IMR Decision request details.
-- Version: 1.0

-- History:
-- <Version>		<Author Name>:	<Date>
--			<Description>
-- ================================================================ 

CREATE PROCEDURE [dbo].[Get_IMRDecisionPageRequestDetailsByReferralID]
	@RFAReferralID int
AS
Begin
SELECT	req.RFARequestID
		, isnull(reqm.RFARequestedTreatment ,req.RFARequestedTreatment) as RFARequestedTreatment
		, case when DecisionID = 2 then 
			(case 
				when ((isnull(req.RFAFrequency,1) * isnull(req.RFADuration,1)) - (isnull(reqm.RFAFrequency,0) *  isnull(reqm.RFADuration,0))) = 0 then 1 
			 else 
				(isnull(req.RFAFrequency,1) * isnull(req.RFADuration,1)) - (isnull(reqm.RFAFrequency,0) *  isnull(reqm.RFADuration,0)) end)
		else
		req.RFAQuantity
		END
		as RFAQuantity
		, isnull(imrreq.IMRRFARequestID,0) as IMRRFARequestID
		, imrreq.IMRApprovedUnits
		, isnull(imrreq.Overturn,0)	as Overturn	
	  FROM [MMC].[dbo].[RFARequests] as req
	    left join [RFARequestModifies] reqm on  req.RFARequestID = reqm.RFARequestID
	    Left Join [IMRRFARequests] imrreq on imrreq.RFARequestID = req.RFARequestID
where req.RFAReferralID = @RFAReferralID and DecisionID != 1
 
Union all  
 
SELECT req.RFARequestID as [RequestID]
		, isnull(reqm.RFARequestedTreatment ,req.RFARequestedTreatment) as RFARequestedTreatment
		, req.RFAQuantity
		, isnull(imrreq.IMRRFARequestID,0) as IMRRFARequestID
		, imrreq.IMRApprovedUnits
		, isnull(imrreq.Overturn,0) as Overturn
	  FROM [MMC].[dbo].[RFARequests] as req
Inner join (Select OriginalRFARequestID from RFARequestAdditionalInfoes 						
						Inner join  RFARequests on RFARequestAdditionalInfoes.RFARequestID = RFARequests.RFARequestID
							where RFARequests.DecisionID=10 and RFAReferralID=@RFAReferralID) tb1
							on req.RFARequestID = tb1.OriginalRFARequestID
Left join [RFARequestModifies] reqm on  req.RFARequestID = reqm.RFARequestID
Left Join [IMRRFARequests] imrreq on imrreq.RFARequestID = req.RFARequestID
END
GO
/****** Object:  StoredProcedure [dbo].[Get_IMRLandingReferralsByProcessLevels]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: TGosain
-- Create date: 07/04/2016
-- Description: GET Refferal for IMR landing by process levels 
-- Version: 1.2

-- History:
-- 1.1		TGosain:	07/04/2016
--			#2834:	Changed @processLevel parameter to varchar to display records of process levels 190 also.

-- 1.2		TGosain 07/05/2016
--			#2832:	Process Level column added.
-- ================================================================ 
 --=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.3
-- ================================================================ 
 -- Get_IMRLandingReferralsByProcessLevels 0,100,170

CREATE PROCEDURE [dbo].[Get_IMRLandingReferralsByProcessLevels]
	@skip int,
	@take int,
	@processLevel varchar(max)	
AS

	BEGIN
		 WITH ClinicalTriage AS		 
		( 
		SELECT  ROW_NUMBER() over (Order by RFAReferrals.RFAReferralID desc)as rownumber, RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID,
		 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then (RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) 
                         else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
						, RFARequests.RFALatestDueDate
						, (select top 1 rp.ProcessLevel from RFAProcessLevels rp where rp.RFAReferralID = RFAReferrals.RFAReferralID order by rp.RFAProcessLevelID desc) as ProcessLevel
						FROM         RFARequests INNER JOIN
														  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
														  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
														  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
														  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
														  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
														   LEFT JOIN
                                                         RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
						WHERE  RFAReferrals.RFAReferralID 
								IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
									)tbl where Row_ID = 1 and ProcessLevel in (SELECT splitdata FROM global.Get_SplitStringFormat(@ProcessLevel, ',') AS Get_SplitStringFormat_1))
		and RFARequests.DecisionID <> 1
		GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate
	
	)
	SELECT * FROM ClinicalTriage
	where rownumber between @skip+1 and (@skip+@take) 
END
GO
/****** Object:  StoredProcedure [dbo].[Get_IMRLandingReferralsByProcessLevelsCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: TGosain
-- Create date: 07/04/2016
-- Description: GET Refferal for IMR landing by process levels 
-- Version: 1.2

-- History:
-- 1.1		TGosain:	07/04/2016
--			#2834:	Changed @processLevel parameter to varchar to display records of process levels 190 also.

-- 1.2		TGosain 07/05/2016
--			#2832:	Process Level column added.
-- ================================================================ 
 -- Get_IMRLandingReferralsByProcessLevels 0,100,'170,190'

Create PROCEDURE [dbo].[Get_IMRLandingReferralsByProcessLevelsCount]
	@processLevel varchar(max)	
AS
BEGIN
		WITH ClinicalTriage AS		 
		( 
		SELECT  ROW_NUMBER() over (Order by RFAReferrals.RFAReferralID desc)as rownumber, RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID,
		 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then RFARequests.RFARequestedTreatment
                         else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
						, RFARequests.RFALatestDueDate
						, (select top 1 rp.ProcessLevel from RFAProcessLevels rp where rp.RFAReferralID = RFAReferrals.RFAReferralID order by rp.RFAProcessLevelID desc) as ProcessLevel
						FROM         RFARequests INNER JOIN
														  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
														  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
														  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
														  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
														  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
														   LEFT JOIN
                                                         RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
						WHERE  RFAReferrals.RFAReferralID 
								IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
									)tbl where Row_ID = 1 and ProcessLevel in (SELECT splitdata FROM global.Get_SplitStringFormat(@ProcessLevel, ',') AS Get_SplitStringFormat_1))
		
		GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate
	
	)
	SELECT COUNT(1) FROM ClinicalTriage
	where DecisionID <> 1
END
GO
/****** Object:  StoredProcedure [dbo].[get_IMRLetters]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		TGosain
-- Create date: 06-16-2016
-- Description:	Used to get IMR Response Letter and IMR Proof of service
-- Used at:  1. IMRAction Page for IMR Response Letter and IMR Proof of service links.

-- Revision History: -
-- 1.1:		TGosain: 07-18-2016
--			New TypeIDs Added to filter.
-- =============================================
-- [dbo].[get_MedicalAndLegalDocsByReferralID] 552
CREATE PROCEDURE [dbo].[get_IMRLetters]
(@ReferralID int)
AS
BEGIN
	Select * from RFAReferralFiles where RFAReferralID = @ReferralID and RFAFileTypeID in (14,16,17,18,19,20)
END

GO
/****** Object:  StoredProcedure [dbo].[Get_IMRReferralByProcessLevel_PatientClaim]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: rkumar
-- Create date: 04/14/2016
-- Description: Get IMR Referral By ProcessLevel 
-- Version: 1.0

-- Author By: rkumar
-- Create date: 05/31/2016
-- Description: add process level Duplicate,Deferral & Unable to Review
-- Version: 1.1

-- Author By: MAHINDER SINGH
-- UPDATED date: 07/27/2016
-- Description:  ----THIS IS FOR CHECKING  DECISION FOR PREVIOUS REQUEST IN CASE OF DUPLICATE REQUEST
-- Version: 1.2
-- ================================================================ 
 
--[dbo].[Get_IMRReferralByProcessLevel_PatientClaim] 0,200,160,180,'Gu-001-Same'
CREATE PROCEDURE [dbo].[Get_IMRReferralByProcessLevel_PatientClaim] 
	@skip int,
	@take int,
	@processLevel int,
	@processLevel2 int,
	@patClaimNumber varchar(255)
AS

	BEGIN
		 WITH IMRReferral AS		 
		( 
		
	SELECT ROW_NUMBER() over (Order by RFAReferralID desc)as rownumber,RFARequestID,RFAReferralID,DecisionID,RFARequestedTreatment,DecisionDesc,PatFirstName,
	   PatLastName, PhysFirstName,PhysLastName,PatClaimNumber,RFALatestDueDate    
	 FROM (
		
			SELECT   RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID, 
			 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then (RFARequests.RFARequestedTreatment  +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),''))
							 else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
							,RFARequests.RFALatestDueDate
							FROM         RFARequests INNER JOIN
															  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
															  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
															  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
															  RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
															   LEFT JOIN
															 RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
							WHERE RFAProcessLevels.ProcessLevel = @ProcessLevel and PatientClaims.PatClaimNumber = @patClaimNumber and RFARequests.DecisionID in (2,3,8,9) AND RFAReferrals.RFAReferralID IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
							)tbl where Row_ID = 1 and ProcessLevel= @ProcessLevel)
			GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate
							
		UNION
	 
	 
			
			SELECT   RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID, 
			 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then RFARequests.RFARequestedTreatment
							 else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
							,RFARequests.RFALatestDueDate
							FROM         RFARequests INNER JOIN
															  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
															  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
															  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
															  RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
															   LEFT JOIN
															 RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
							WHERE RFAProcessLevels.ProcessLevel = @ProcessLevel2 and PatientClaims.PatClaimNumber = @patClaimNumber and RFARequests.DecisionID in (2,3) AND RFAReferrals.RFAReferralID IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
							)tbl where Row_ID = 1 and ProcessLevel= @ProcessLevel2)
			GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate
									  
									  
		  UNION
		  
		  
		      
			  SELECT  RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID, 
			 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then RFARequests.RFARequestedTreatment
							 else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
							,RFARequests.RFALatestDueDate
							FROM         RFARequests INNER JOIN
															  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
															  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
															  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
															  RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
															   LEFT JOIN
															 RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
							WHERE RFAProcessLevels.ProcessLevel = @ProcessLevel and PatientClaims.PatClaimNumber = @patClaimNumber and RFARequests.DecisionID in (10) AND RFARequests.RFARequestID IN (
							SELECT   ReqOutIN.RFARequestID 
								  FROM   [MMC].[dbo].[RFARequests]  ReqOutIN
								  WHERE    ReqOutIN.RFARequestID IN (SELECT  RQINFO.RFARequestID FROM   dbo.RFARequestAdditionalInfoes  RQINFO
											 WHERE  RQINFO.OriginalRFARequestID  IN (
								 SELECT reqOut.RFARequestID
											FROM   [dbo].[RFARequests] reqOut
											WHERE reqOut.RFARequestID IN  (
											SELECT RFARequestAdditionalInfoes.OriginalRFARequestID 
											 FROM   dbo.RFARequestAdditionalInfoes 
											 WHERE  RFARequestAdditionalInfoes.RFARequestID IN 
								 (SELECT   RFARequestID 
								  FROM   [MMC].[dbo].[RFARequests]  reqIn
								  WHERE    reqIn.RFAReferralID IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
							)tbl where Row_ID = 1 and ProcessLevel= @ProcessLevel) AND reqIn.DecisionID = 10)) AND reqOut.DecisionID  NOT IN (1)) AND ReqOutIN.DecisionID = 10))
			GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate
									  
       )TBL
						
						
	)
	SELECT * FROM IMRReferral 
	where rownumber between @skip+1 and (@skip+@take)  order by RFAReferralID desc
	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_IMRReferralByProcessLevel_PatientClaimCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: rkumar
-- Create date: 04/14/2016
-- Description: Get IMR Referral By ProcessLevel count
-- Version: 1.0

-- Author By: rkumar
-- Create date: 05/31/2016
-- Description: add process level Duplicate,Deferral & Unable to Review
-- Version: 1.1

-- Author By: MAHINDER SINGH
-- UPDATED date: 07/27/2016
-- Description:  ----THIS IS FOR CHECKING  DECISION FOR PREVIOUS REQUEST IN CASE OF DUPLICATE REQUEST
-- Version: 1.2

-- ================================================================ 
 
--[dbo].[Get_IMRReferralByProcessLevel_PatientClaimCount] 160,180,'Gu-001-Same'
CREATE PROCEDURE [dbo].[Get_IMRReferralByProcessLevel_PatientClaimCount] 
	@processLevel int,
	@processLevel2 int,
	@patClaimNumber varchar(255)
AS

	BEGIN
		 WITH IMRReferral AS		 
		( 
		SELECT ROW_NUMBER() over (Order by RFAReferralID desc)as rownumber,RFARequestID,RFAReferralID,DecisionID,RFARequestedTreatment,DecisionDesc,PatFirstName,
	   PatLastName, PhysFirstName,PhysLastName,PatClaimNumber,RFALatestDueDate    
	 FROM (
		
			SELECT   RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID, 
			 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then RFARequests.RFARequestedTreatment
							 else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
							,RFARequests.RFALatestDueDate
							FROM         RFARequests INNER JOIN
															  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
															  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
															  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
															  RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
															   LEFT JOIN
															 RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
							WHERE RFAProcessLevels.ProcessLevel = @ProcessLevel and PatientClaims.PatClaimNumber = @patClaimNumber and RFARequests.DecisionID in (2,3,8,9) AND RFAReferrals.RFAReferralID IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
							)tbl where Row_ID = 1 and ProcessLevel= @ProcessLevel)
			GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate
							
		UNION
	 
	 
			
			SELECT   RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID, 
			 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then RFARequests.RFARequestedTreatment
							 else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
							,RFARequests.RFALatestDueDate
							FROM         RFARequests INNER JOIN
															  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
															  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
															  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
															  RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
															   LEFT JOIN
															 RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
							WHERE RFAProcessLevels.ProcessLevel = @ProcessLevel2 and PatientClaims.PatClaimNumber = @patClaimNumber and RFARequests.DecisionID in (2,3) AND RFAReferrals.RFAReferralID IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
							)tbl where Row_ID = 1 and ProcessLevel= @ProcessLevel2)
			GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate
									  
									  
		  UNION
		  
		  
		      
			  SELECT  RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID, 
			 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then RFARequests.RFARequestedTreatment
							 else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
							,RFARequests.RFALatestDueDate
							FROM         RFARequests INNER JOIN
															  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
															  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
															  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
															  RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
															  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
															   LEFT JOIN
															 RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
							WHERE RFAProcessLevels.ProcessLevel = @ProcessLevel and PatientClaims.PatClaimNumber = @patClaimNumber and RFARequests.DecisionID in (10) AND RFARequests.RFARequestID IN (
							SELECT   ReqOutIN.RFARequestID 
								  FROM   [MMC].[dbo].[RFARequests]  ReqOutIN
								  WHERE    ReqOutIN.RFARequestID IN (SELECT  RQINFO.RFARequestID FROM   dbo.RFARequestAdditionalInfoes  RQINFO
											 WHERE  RQINFO.OriginalRFARequestID  IN (
								 SELECT reqOut.RFARequestID
											FROM   [dbo].[RFARequests] reqOut
											WHERE reqOut.RFARequestID IN  (
											SELECT RFARequestAdditionalInfoes.OriginalRFARequestID 
											 FROM   dbo.RFARequestAdditionalInfoes 
											 WHERE  RFARequestAdditionalInfoes.RFARequestID IN 
								 (SELECT   RFARequestID 
								  FROM   [MMC].[dbo].[RFARequests]  reqIn
								  WHERE    reqIn.RFAReferralID IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
							)tbl where Row_ID = 1 and ProcessLevel= @ProcessLevel) AND reqIn.DecisionID = 10)) AND reqOut.DecisionID  NOT IN (1)) AND ReqOutIN.DecisionID = 10))
			GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
									  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate
									  
       )TBL				
	)
	SELECT COUNT(*) FROM IMRReferral
	 
	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_InitialNotificationLetterDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tarun Gosain
-- Create date: 12-16-2015
-- Description:	To get initial notification letter patient section details. 
--				: Using in IMRInitialNotification Report.
--				: Using in InitialNotification Report.

-- Revision History:
-- 1.0 -	TGosain
--			Initial version.
-- 1.1 -	Hasingh
--			Report version.
-- 1.2 -	Mahinder Singh
--			Report version.
-- =============================================
-- [dbo].[Get_InitialNotificationLetterDetails]152
CREATE PROCEDURE [dbo].[Get_InitialNotificationLetterDetails](@referralID int)
AS
BEGIN
	SET NOCOUNT ON;
	
				
				Select	Convert(varchar(10),getdate(),101)as CurrentDate, RFAReferralID,Patients.PatFirstName + ' ' + Patients.PatLastName as [PatientName]			
			,(case 
				when ClaimAdministratorType='emp' then (select EmpName from Employers where EmployerID = ClaimAdministratorID) 
				when ClaimAdministratorType='ins' then (select InsName from Insurers where InsurerID = ClaimAdministratorID) 
				when ClaimAdministratorType='insb' then (select InsBranchName from InsuranceBranches where InsuranceBranchID = ClaimAdministratorID) 
				when ClaimAdministratorType='tpa' then (select TPAName from ThirdPartyAdministrators where TPAID = ClaimAdministratorID) 
				when ClaimAdministratorType='mcc' then (select CompName from ManagedCareCompanies where CompanyID = ClaimAdministratorID) 
				end) as [ClaimAdministrator]				
			, pc.PatClaimNumber as [ClaimNumber]
			, AdjFirstName + ' ' + AdjLastName as [Adjuster]
			, Convert(varchar(10),pc.PatDOI,101) as [DOI]
			, Convert(varchar(10),rf.RFACEDate,101) as[CEReceivedDate]
			, (case 
					when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and (DecisionID = 1 or DecisionID = 12))
					 = (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'Certified' 
					when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID = 10) 
					 = (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'Duplicate'
					when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID = 8) 
					 = (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'Unable To Review'
				else 
					(case when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID = 3) 
					 = (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'Denied' 
			    
				else 
				(case when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID = 9) > 0
					 then 'Deferred'  
				 else 'Modified' end)end)end) as [Decision]
			,PhysFirstName
			,PhysLastName
			,PhysQualification
			,PhysAddress1
			,(select StateName from mmc.lookup.States where StateId = PhysStateID) as [PhysStates]
			,PhysCity
			,PhysFax
			,PhysZip
			,AA.AttorneyName as ApplicantAttorneyName
			,DA.AttorneyName as DefenseAttorneyName
			,Adjusters.AdjPhone as AdjusterPhoneNumber
			,Convert(varchar(10),rf. RFAReferralDate,101)as RFADate
			,pc.PatADRID
			,ADRs.ADRName			
		from mmc.dbo.RFAReferrals rf		
			inner join PatientClaims pc on rf.PatientClaimID = pc.PatientClaimID
			inner join Patients on pc.PatientID = Patients.PatientID			
			inner join Physicians on Physicians.PhysicianId = rf.PhysicianID
			inner join Clients on pc.PatClientID = Clients.ClientID
			inner join  Adjusters on pc.PatAdjusterID = AdjusterID 	
			Left JOIN  Attorneys as AA ON pc.PatApplicantAttorneyID = AA.AttorneyID
			Left JOIN  Attorneys as DA ON pc.PatDefenseAttorneyID = DA.AttorneyID
            Left Join ADRs on pc.PatADRID = ADRs.ADRID         	
		where RFAReferralID = @referralID

END

GO
/****** Object:  StoredProcedure [dbo].[get_MedicalAndLegalDocsByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singh>
-- Create date: <Create Date,,16-03-2016>
-- Description:	<Description,, user story #2724>
-- =============================================
-- [dbo].[get_MedicalAndLegalDocsByReferralID] 552
CREATE PROCEDURE [dbo].[get_MedicalAndLegalDocsByReferralID] 
(@ReferralID int)
AS
BEGIN	

select * from 
(

	SELECT     (CASE WHEN RFARecordSplittings.DocumentCategoryID = 3 THEN 'Medical' when RFARecordSplittings.DocumentCategoryID = 5 then 'Med Legal' ELSE 'Legal' END) AS RFAType
	, CONVERT(varchar(10), RFARecordSplittings.RFARecSpltID)+'-'+ CONVERT(varchar(10), RFARecordSplittings.RFAReferralID) + 'D' + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID) as Mode, 
                      RFARecordSplittings.RFARecDocumentDate as RFAFileCreationDate, 'RecordSpliting' AS TableName , RFAReferrals.RFAReferralID, RFARecordSplittings.RFAFileName as FileTypeName,RFARecordSplittings.DocumentTypeID
                   ,RFARecordSplittings.RFARecDocumentName  as RFAReferralFileName
                   ,lookup.IMRResponseLetterDocumentRelations.IMRMedicalRecordSubmittedID
FROM         RFARecordSplittings INNER JOIN
                      RFAReferrals ON RFARecordSplittings.RFAReferralID = RFAReferrals.RFAReferralID 
INNER JOIN            RFARequests ON RFAReferrals.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@ReferralID)) 
						or RFARequests.RFAReferralID = RFAReferrals.RFAReferralID
INNER JOIN lookup.IMRResponseLetterDocumentRelations on RFARecordSplittings.DocumentTypeID = lookup.IMRResponseLetterDocumentRelations.DocumentTypeID
Where      (RFAReferrals.RFAReferralID in (select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@ReferralID)) 

or RFAReferrals.RFAReferralID in 
--@ReferralID

(SELECT     RFAReferralID 
FROM         RFAReferrals
where PatientClaimID in (
SELECT     PatientClaims.PatientClaimID
FROM         RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID where RFAReferrals.RFAReferralID = @ReferralID))


)


 and  RFARecordSplittings.DocumentCategoryID in (3,4,5) 
 and  (case when datediff(month,RFARecordSplittings.RFARecDocumentDate ,isnull(RFARequests.RFARequestIMRCreatedDate,getdate()))<= 6 then 1 else 0 end) = 1
 and 'D'+CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID) = lookup.IMRResponseLetterDocumentRelations.DocumentTableName +CONVERT(varchar(10), lookup.IMRResponseLetterDocumentRelations.DocumentTypeID)
  --order by lookup.IMRResponseLetterDocumentRelations.IMRResponseLetterDocumentID
--and RFARecordSplittings.DocumentTypeID in (6,7,8,10,19,20,13,22,23)
union

SELECT    'Legal' as RFAType
			,CONVERT(varchar(10), RFAReferralFiles.RFAReferralFileID )+'-'+CONVERT(varchar(10), RFAReferralFiles.RFAReferralID)+'F'+ CONVERT(varchar(10), RFAReferralFiles.RFAFileTypeID )as Mode, RFAReferralFiles.RFAFileCreationDate
			, 'RFAReferralFile' as TableName , RFAReferrals.RFAReferralID, RFAReferralFiles.RFAReferralFileName as FileTypeName ,RFAReferralFiles.RFAFileTypeID
			,RFAReferralFiles.RFAReferralFileName as RFAReferralFileName
			,lookup.IMRResponseLetterDocumentRelations.IMRMedicalRecordSubmittedID
FROM         RFAReferralFiles INNER JOIN
                      RFAReferrals ON RFAReferralFiles.RFAReferralID = RFAReferrals.RFAReferralID 
INNER JOIN            RFARequests ON RFAReferrals.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@ReferralID)) 
						or RFARequests.RFAReferralID = RFAReferrals.RFAReferralID
INNER JOIN lookup.IMRResponseLetterDocumentRelations on RFAReferralFiles.RFAFileTypeID = lookup.IMRResponseLetterDocumentRelations.DocumentTypeID             
Where    (RFAReferrals.RFAReferralID in (select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@ReferralID)) 
or RFAReferrals.RFAReferralID  in

--@ReferralID

(SELECT     RFAReferralID 
FROM         RFAReferrals
where PatientClaimID in (
SELECT     PatientClaims.PatientClaimID
FROM         RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID where RFAReferrals.RFAReferralID = @ReferralID))

) 

and RFAReferralFiles.RFAFileTypeID <> 6
 and  (case when datediff(month,RFAFileCreationDate ,isnull(RFARequests.RFARequestIMRCreatedDate,getdate()))<= 6 then 1 else 0 end) = 1
and RFAReferralFiles.RFAFileTypeID in (5,8)
 and 'F'+ CONVERT(varchar(10), RFAReferralFiles.RFAFileTypeID ) = lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10),lookup.IMRResponseLetterDocumentRelations.DocumentTypeID)
)tbl  order by IMRMedicalRecordSubmittedID ,RFAReferralID
END

GO
/****** Object:  StoredProcedure [dbo].[Get_NotesByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,30-01-2016>
-- Description:	<Description,,get notes on patient page by patient id>
-- =============================================
-- [dbo].[Get_NotesByPatientID]130,0,200
CREATE PROCEDURE [dbo].[Get_NotesByPatientID]
@PatientID int,
@Skip int,
@Take int
AS
BEGIN
With NotesDetail as
(
	SELECT   ROW_NUMBER() Over(Order by Notes.NoteID) as Row_ID ,Notes.NoteID, Notes.Notes, Notes.UserID, Notes.PatientClaimID, Notes.RFARequestID,
		 CONVERT(varchar(10), Notes.Date, 110) AS NotesDate, CONVERT(varchar(20), 
						  CAST(Notes.Date AS TIME), 100) AS NotesTime, RFARequests.RFARequestedTreatment, Users.UserFirstName + ' ' + Users.UserLastName AS Users, 
						  PatientClaims.PatClaimNumber
	FROM         Notes INNER JOIN
						  PatientClaims ON Notes.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
						   Users ON Notes.UserID = Users.UserId LEFT JOIN
						  RFARequests ON Notes.RFARequestID = RFARequests.RFARequestID 
						 
	WHERE     (PatientClaims.PatientID = @PatientID)
)
SELECT * FROM NotesDetail
WHERE Row_ID BETWEEN @Skip + 1 AND @Skip + @Take
END

GO
/****** Object:  StoredProcedure [dbo].[Get_NotesByPatientIDCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,02-02-2016>
-- Description:	<Description,,get notes on patient page by patient id>
-- =============================================
-- [dbo].[Get_NotesByPatientIDCount]130
CREATE PROCEDURE [dbo].[Get_NotesByPatientIDCount]
@PatientID int
AS
BEGIN

	SELECT   count(Notes.NoteId)
	FROM         Notes INNER JOIN
						  PatientClaims ON Notes.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
						   Users ON Notes.UserID = Users.UserId LEFT JOIN
						  RFARequests ON Notes.RFARequestID = RFARequests.RFARequestID 
						 
	WHERE     (PatientClaims.PatientID = @PatientID)
END

GO
/****** Object:  StoredProcedure [dbo].[Get_PatientByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HASINGH
-- Create date: 10/29/2015
-- Description: GET Patient by Referral Id 
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_PatientByReferralID] 32
CREATE PROCEDURE [dbo].[Get_PatientByReferralID] 
	@ReferralID int
AS

	BEGIN

SELECT     PatientClaims.PatDOI, PatientClaims.PatClaimNumber, Patients.PatFirstName, Patients.PatLastName, RFAReferrals.RFAReferralID,Patients.PatientID,RFAReferrals.PatientClaimID
		   ,ClientBillings.ClientBillingRateTypeID
FROM         RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      Patients ON PatientClaims.PatientID = Patients.PatientID AND
                      RFAReferrals.RFAReferralID = @ReferralID
                      inner join Clients on Clients.ClientID = PatientClaims.PatClientID
                      inner join ClientBillings on ClientBillings.ClientID = Clients.ClientID
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[Get_PatientClaimDiagnoseByPatientClaimId]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 05 MAY 2016
-- Description:	Get patient claim Diagnosis by Patient claim ID
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_PatientClaimDiagnoseByPatientClaimId] 
@PatientClaimID INT,
@Skip INT,
@Take INT
AS
BEGIN
	SET NOCOUNT ON;	
	WITH PatientClaimDiagnoseByPatientClaim AS(
	SELECT ROW_NUMBER() OVER(ORDER BY pcd.PatientClaimDiagnosisID desc) AS ROW, pcd.PatientClaimDiagnosisID,pc.PatientClaimID,(CASE WHEN icd9.icdICD9Number IS NULL THEN icd10.icdICD10Number  ELSE icd9.icdICD9Number END) AS icdICDNumber,
	(CASE WHEN icd9.icdICD9Number IS NULL THEN icd10.ICD10Description  ELSE icd9.ICD9Description END) AS ICDDescription,pcd.icdICDTab
    FROM dbo.PatientClaims pc
	INNER JOIN dbo.PatientClaimDiagnoses pcd ON pcd.PatientClaimID = pc.PatientClaimID
	LEFT JOIN lookup.ICD9Codes icd9 ON icd9.icdICD9NumberID = pcd.icdICDNumberID AND pcd.icdICDTab = 'ICD9'
	LEFT JOIN lookup.ICD10Codes icd10 ON icd10.icdICD10NumberID = pcd.icdICDNumberID AND pcd.icdICDTab = 'ICD10'
	WHERE pc.PatientClaimID = @PatientClaimID	)
	SELECT * FROM PatientClaimDiagnoseByPatientClaim AS CODE
	WHERE CODE.ROW BETWEEN @Skip + 1 AND @Skip + @Take

END

GO
/****** Object:  StoredProcedure [dbo].[Get_PatientClaimDiagnoseByPatientClaimIdCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 05 MAY 2016
-- Description:	Get patient claim Diagnosis by Patient claim ID Count
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_PatientClaimDiagnoseByPatientClaimIdCount] 
@PatientClaimID INT
AS
BEGIN
	SET NOCOUNT ON;	
	WITH PatientClaimDiagnoseByPatientClaim AS(
	SELECT ROW_NUMBER() OVER(ORDER BY pcd.PatientClaimDiagnosisID desc) AS ROW, pcd.PatientClaimDiagnosisID,pc.PatientClaimID,(CASE WHEN icd9.icdICD9Number IS NULL THEN icd10.icdICD10Number  ELSE icd9.icdICD9Number END) AS icdICDNumber,
	(CASE WHEN icd9.icdICD9Number IS NULL THEN icd10.ICD10Description  ELSE icd9.ICD9Description END) AS ICDDescription,pcd.icdICDTab
    FROM dbo.PatientClaims pc
	INNER JOIN dbo.PatientClaimDiagnoses pcd ON pcd.PatientClaimID = pc.PatientClaimID
	LEFT JOIN lookup.ICD9Codes icd9 ON icd9.icdICD9NumberID = pcd.icdICDNumberID AND pcd.icdICDTab = 'ICD9'
	LEFT JOIN lookup.ICD10Codes icd10 ON icd10.icdICD10NumberID = pcd.icdICDNumberID AND pcd.icdICDTab = 'ICD10'
	WHERE pc.PatientClaimID = @PatientClaimID	)
	SELECT COUNT(*) AS TotalCount FROM PatientClaimDiagnoseByPatientClaim AS CODE
	
END

GO
/****** Object:  StoredProcedure [dbo].[Get_PatientComorbidConditionsByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 12/08/2015
-- Description: GET All Patient Medical condition Record
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_PatientComorbidConditionsByPatientID] 92
CREATE PROCEDURE [dbo].[Get_PatientComorbidConditionsByPatientID] 
	@PatientID int
AS

	BEGIN
	declare @ComorbidConditions as varchar(max)=null
			set @ComorbidConditions = (select dbo.CommaSeperateComorbidConditionsByPatientID (@PatientID))
			select isnull(@ComorbidConditions ,'&nbsp;')  as  ComorbidConditions
	
	END
 

GO
/****** Object:  StoredProcedure [dbo].[Get_PatientHistoryByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 01/02/2016
-- Description: GET Patient UR History
-- Version: 1.0

-- History: -
-- 1.0:	TGosain: 26-09-2016
--			User Story #2832: IMR Decision Page (added a condition for status column in case of IMR)
-- ================================================================ 

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

--[dbo].[Get_PatientHistoryByPatientID] 148,0,500
CREATE PROCEDURE [dbo].[Get_PatientHistoryByPatientID]
	@PatientID int,
	@skip int,
	@take int,
	@sortBy varchar(50) = 'Request',
	@order varchar(5) = 'DESC' 
AS
BEGIN
WITH  PatientURHistory AS
		(
	         select *, ROW_NUMBER() Over(Order by 
         		case when @order = 'ASC'
					then (case
					when @sortBy = 'Referral' then  CAST(RFAReferralID as varchar(50))
					when @sortBy = 'Request' then CAST(RFARequestID as varchar(50))
					when @sortBy = 'RequestDate' then CONVERT(varchar, RFARequestDate,101)
					when @sortBy = 'Physician' then CAST(Physician as varchar(50))
					when @sortBy = 'RequestName' then RFARequestedTreatment
					when @sortBy = 'DecisionDate' then CAST(DecisionDate as varchar(50))
					when @sortBy = 'Status' then Status

				end) else '' end ASC,
				case when @order = 'DESC'
				then (case
					when @sortBy = 'Referral' then  CAST(RFAReferralID as varchar(50))
					when @sortBy = 'Request' then CAST(RFARequestID as varchar(50))
					when @sortBy = 'RequestDate' then CONVERT(varchar, RFARequestDate,101)
					when @sortBy = 'Physician' then CAST(Physician as varchar(50))
					when @sortBy = 'RequestName' then RFARequestedTreatment
					when @sortBy = 'DecisionDate' then CAST(DecisionDate as varchar(50))
					when @sortBy = 'Status' then Status
				end) else '' end DESC	
	         ) as Row_ID from (
	         
	         SELECT ROW_NUMBER() OVER(PARTITION BY  RFARequests.RFARequestID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as RowNumber ,   
			PatientClaims.PatientClaimID, PatientClaims.PatientID, RFARequests.RFAReferralID, RFARequests.RFARequestID, 
						   (Case when(RFARequestModifies.RFARequestedTreatment IS null) then (RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID ( RFARequests.RFARequestID)),'')) 
                         else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, Physicians.PhysFirstName+' ' + Physicians.PhysLastName as Physician
                         , Physicians.PhysicianId
                         , (case when (RFARequests.DecisionDate IS NULL And RFAProcessLevels.ProcessLevel>60)
             then (Case when(RFARequests.RFAStatus = 'SendToPreparation') then 'Preparation'
                         when(RFARequests.RFAStatus = 'SendToClinical') then 'Clinical'
                         when(RFARequests.DecisionID = 13) then 'Withdrawn'
                         when(RFARequests.DecisionID = 12) then 'Client Authorized'
                         else lookup.ProcessLevels.ProcessLevelDesc end)
			else  (case when exists(select top 1 imrreq.RFARequestID from IMRRFARequests imrreq where imrreq.RFARequestID = RFARequests.RFARequestID) 
					then (select IMRDecisionDesc from lookup.IMRDecision where IMRDecisionID = (select imrref.IMRDecisionID from IMRRFAReferrals imrref where imrref.RFAReferralID = RFAReferrals.RFAReferralID))
					else lookup.Decisions.DecisionDesc end)
			end) as Status
			, RFARequests.DecisionDate,RFARequests.RFARequestDate
			 
			FROM         PatientClaims INNER JOIN
						  RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID INNER JOIN
						  RFARequests ON RFAReferrals.RFAReferralID = RFARequests.RFAReferralID INNER JOIN
						  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
						   Left JOIN
						  lookup.Decisions ON RFARequests.DecisionID = lookup.Decisions.DecisionID INNER JOIN
						  RFAProcessLevels ON RFAReferrals.RFAReferralID = RFAProcessLevels.RFAReferralID Left JOIN
						  lookup.ProcessLevels ON RFAProcessLevels.ProcessLevel = lookup.ProcessLevels.ProcessLevel
						  LEFT JOIN
                                                         RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
						   where
						   PatientClaims.PatientID=@PatientID	
			
			 ) as rs where RowNumber=1
			 
			 
			 
			 
			 
			 )
			  SELECT * FROM PatientURHistory --where RFARequestID in (1185,1184,1183,1182,1181)
			   WHERE PatientURHistory.Row_ID BETWEEN @Skip + 1 AND @Skip + @Take
END

GO
/****** Object:  StoredProcedure [dbo].[Get_PatientHistoryByPatientIDCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 01/02/2016
-- Description: GET Patient UR History
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_PatientHistoryByPatientIDCount] 130
CREATE PROCEDURE [dbo].[Get_PatientHistoryByPatientIDCount]
	@PatientID int
AS
BEGIN
declare @TotalCount as int
	set @TotalCount  = (SELECT  COUNT(*) as TotalCount from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFARequests.RFARequestID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as RowNumber ,   
							PatientClaims.PatientClaimID, PatientClaims.PatientID						  
							FROM         PatientClaims INNER JOIN
						  RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID INNER JOIN
						  RFARequests ON RFAReferrals.RFAReferralID = RFARequests.RFAReferralID INNER JOIN
						  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
						   Left JOIN
						  lookup.Decisions ON RFARequests.DecisionID = lookup.Decisions.DecisionID INNER JOIN
						  RFAProcessLevels ON RFAReferrals.RFAReferralID = RFAProcessLevels.RFAReferralID Left JOIN
						  lookup.ProcessLevels ON RFAProcessLevels.ProcessLevel = lookup.ProcessLevels.ProcessLevel where
						   PatientClaims.PatientID=@PatientID
			 )  as rs  where RowNumber=1 )
--	print @TotalCount 
	
--declare @TotalCount2 as int

--	set @TotalCount2  = (SELECT		 COUNT(*)
--				FROM         link.RFIReportRFAAdditionalRecords INNER JOIN
--							 RFARequests ON link.RFIReportRFAAdditionalRecords.RFARequestID = RFARequests.RFARequestID INNER JOIN
--							RFAReferrals ON link.RFIReportRFAAdditionalRecords.RFAReferralID = RFAReferrals.RFAReferralID AND 
--							 link.RFIReportRFAAdditionalRecords.RFAReferralID = RFAReferrals.RFAReferralID AND RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
--							 Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId INNER JOIN
--							PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
--							RFAAdditionalInfoes ON link.RFIReportRFAAdditionalRecords.RFAAdditionalInfoID = RFAAdditionalInfoes.RFAAdditionalInfoID 
--				where		PatientClaims.PatientID = @PatientID)
				
				Select @TotalCount  as TotalCount
END

GO
/****** Object:  StoredProcedure [dbo].[Get_PatientMedicalRecordByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 11/25/2015
-- Description: GET All Patient Medical Record
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_PatientMedicalRecordByPatientID] 130,0,100,'Physician'
CREATE PROCEDURE [dbo].[Get_PatientMedicalRecordByPatientID] 
	@PatientID int,
	@skip int,
	@take int,
	@sortBy varchar(50) = 'Date',
	@order varchar(5) = NULL
AS

	BEGIN
		
		WITH PatientMedicalRecordByPatientID AS
		(
		SELECT  ROW_NUMBER() Over(Order by 
			case when @order = 'ASC'
				then (case
				when @sortBy = 'Date' then  CAST(PatMRDocumentDate as varchar(50))
				when @sortBy = 'Claim' then PatClaimNumber
				when @sortBy = 'Name' then PatMRDocumentName
				when @sortBy = 'Category' then DocumentCategoryName
				when @sortBy = 'Physician' then AuthorName
				end) else '' end ASC,
				case when @order = 'DESC'
				then (case
				when @sortBy = 'Date' then  CAST(PatMRDocumentDate as varchar(50))
				when @sortBy = 'Claim' then PatClaimNumber
				when @sortBy = 'Name' then PatMRDocumentName
				when @sortBy = 'Category' then DocumentCategoryName
				when @sortBy = 'Physician' then AuthorName
				end) else '' end DESC
			) as Row_ID,  
			 PatientMedicalRecordID , PatMRDocumentName, PatMRDocumentDate, PhysicianName, PatientID ,RFAReferralID ,PatClaimNumber,RFARecSpltSummary as Summary,AuthorName as Author 
			 ,PatientClaimID,DocumentCategoryName
			 FROM (
			SELECT   RFARecordSplittings.RFARecSpltID as PatientMedicalRecordID,  REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') as PatMRDocumentName,
					RFARecordSplittings.RFARecDocumentDate as PatMRDocumentDate,	
					(Physicians.PhysFirstName + ' ' + Physicians.PhysLastName) as PhysicianName, 
					PatientClaims.PatientID, RFAReferrals.RFAReferralID,PatientClaims.PatClaimNumber
					,RFARecordSplittings.AuthorName,RFARecordSplittings.RFARecSpltSummary,RFAReferrals.PatientClaimID,
				DocumentCategories.DocumentCategoryName
			FROM    RFARecordSplittings INNER JOIN																										
					RFAReferrals ON RFARecordSplittings.RFAReferralID = RFAReferrals.RFAReferralID left JOIN									
					Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId INNER JOIN												
					PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID	INNER JOIN		
					lookup.DocumentCategories on lookup.DocumentCategories.DocumentCategoryID= RFARecordSplittings.DocumentCategoryID
																
			WHERE   (PatientClaims.PatientID = @PatientID)
			
			UNION
			
			SELECT     RFARecordSplittings.RFARecSpltID AS PatientMedicalRecordID, REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') AS PatMRDocumentName, 
								  RFARecordSplittings.RFARecDocumentDate AS PatMRDocumentDate,  RFARecordSplittings.AuthorName AS PhysicianName,PatientClaims.PatientID, 0 AS RFAReferralID, PatientClaims.PatClaimNumber
								  ,RFARecordSplittings.AuthorName as Author ,RFARecordSplittings.RFARecSpltSummary as Summary,PatientClaims.PatientClaimID, DocumentCategories.DocumentCategoryName
			FROM         RFARecordSplittings INNER JOIN
								  PatientClaims ON RFARecordSplittings.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN		
					lookup.DocumentCategories on lookup.DocumentCategories.DocumentCategoryID= RFARecordSplittings.DocumentCategoryID
								  
			WHERE     (PatientClaims.PatientID = @PatientID) AND RFARecordSplittings.RFAReferralID IS NULL) tbl
			
	)
     SELECT * FROM PatientMedicalRecordByPatientID _PatientMedicalRecordByPatientID
     WHERE _PatientMedicalRecordByPatientID.Row_ID BETWEEN @Skip + 1 AND @Skip + @Take
	
	END


 
GO
/****** Object:  StoredProcedure [dbo].[Get_PatientMedicalRecordByPatientIDCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 11/25/2015
-- Description: GET All Patient Medical Record count
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_PatientMedicalRecordByPatientIDCount] 92
CREATE PROCEDURE [dbo].[Get_PatientMedicalRecordByPatientIDCount] 
	@PatientID int 
AS

	BEGIN
		
		 
			SELECT  COUNT(*) as TotalCount FROM (
			SELECT   RFARecordSplittings.RFARecSpltID as PatientMedicalRecordID,  REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') as PatMRDocumentName,
					RFARecordSplittings.RFARecDocumentDate as PatMRDocumentDate,	
					(Physicians.PhysFirstName + ' ' + Physicians.PhysLastName) as PhysicianName, 
					PatientClaims.PatientID, RFAReferrals.RFAReferralID,PatientClaims.PatClaimNumber
			FROM    RFARecordSplittings INNER JOIN																										
					RFAReferrals ON RFARecordSplittings.RFAReferralID = RFAReferrals.RFAReferralID left JOIN									
					Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId INNER JOIN												
					PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID												
			WHERE   (PatientClaims.PatientID = @PatientID)
			
			UNION
			
			SELECT     RFARecordSplittings.RFARecSpltID AS PatientMedicalRecordID, REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') AS PatMRDocumentName, 
								  RFARecordSplittings.RFARecDocumentDate AS PatMRDocumentDate,  NULL AS PhysicianName,PatientClaims.PatientID, 0 AS RFAReferralID, PatientClaims.PatClaimNumber
			FROM         RFARecordSplittings INNER JOIN
								  PatientClaims ON RFARecordSplittings.PatientClaimID = PatientClaims.PatientClaimID
			WHERE     (PatientClaims.PatientID = @PatientID) AND RFARecordSplittings.RFAReferralID IS NULL
			) TBL
	 
	 
	END


 
GO
/****** Object:  StoredProcedure [dbo].[Get_PatientMedicalRecordMultipleTemplateByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 11/25/2015
-- Description: GET All Patient Medical Record
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_PatientMedicalRecordMultipleTemplateByPatientID] 92
CREATE PROCEDURE [dbo].[Get_PatientMedicalRecordMultipleTemplateByPatientID] 
	@PatientID int
AS

	BEGIN
			Select REPLACE(PatMRDocumentName, '.pdf', '') as PatMRDocumentName ,PatMRDocumentDate,isnull(PhysicianName,'') as PhysicianName ,RFAReferralID ,PatientMedicalRecordID,isnull(Diagnosis ,'') as Diagnosis ,isnull(Summary,'') as Summary from (
			SELECT     RFARecordSplittings.RFARecDocumentName as PatMRDocumentName, RFARecordSplittings.RFARecDocumentDate as PatMRDocumentDate , 
						Physicians.PhysFirstName+ ' '+ Physicians.PhysLastName as PhysicianName ,RFAReferrals.RFAReferralID,RFARecordSplittings.RFARecSpltID as PatientMedicalRecordID,
						(select dbo.CommaSeperateDiagnosisByRFAReferralID (RFAReferrals.RFAReferralID)) as Diagnosis, RFARecordSplittings.RFARecSpltSummary as Summary
			FROM         RFARecordSplittings INNER JOIN
                      RFAReferrals ON RFARecordSplittings.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
			where PatientClaims.PatientID = @PatientID --@PatientID
			 union
			SELECT     RFARecordSplittings.RFARecDocumentName AS PatMRDocumentName, RFARecordSplittings.RFARecDocumentDate AS PatMRDocumentDate, 
                      null as PhysicianName,0 as RFAReferralID  ,RFARecordSplittings.RFARecSpltID AS PatientMedicalRecordID,
                          (select dbo.CommaSeperateDiagnosisByPatientClaimID (RFARecordSplittings.PatientClaimID )) as Diagnosis, RFARecordSplittings.RFARecSpltSummary AS Summary
			FROM         RFARecordSplittings INNER JOIN
								  PatientClaims ON RFARecordSplittings.PatientClaimID = PatientClaims.PatientClaimID
			WHERE     (PatientClaims.PatientID = @PatientID) and RFARecordSplittings.RFAReferralID is null
			) as tbl order by PatMRDocumentDate
			 
	END

GO
/****** Object:  StoredProcedure [dbo].[Get_PatientMedicalRecordTemplateByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 11/25/2015
-- Description: GET All Patient Medical Record
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_PatientMedicalRecordTemplateByPatientID] 92
CREATE PROCEDURE [dbo].[Get_PatientMedicalRecordTemplateByPatientID] 
	@PatientID int
AS

	BEGIN
			SELECT     (PatFirstName +' ' + PatLastName ) as PatientName ,  
			(select  isnull(dbo.CommaSeperateDiagnosisByPatientID (@PatientID),'')) as Diagnosis,
			(select  isnull(dbo.CommaSeperateClaimsByPatientID (@PatientID),''))  as Claims,
			(select  isnull(dbo.CommaSeperateAcceptedBodyPartsByPatientID (@PatientID),''))  as AcceptedBodyParts,
			(select  isnull(dbo.CommaSeperateDeniedBodyPartsByPatientID (@PatientID),''))  as DeniedBodyParts,
			'Unknown' as DiscoveryBodyParts
			FROM         Patients where PatientID = @PatientID
	
	END

GO
/****** Object:  StoredProcedure [dbo].[Get_PatientsClaimByName]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,31/12/2015>
-- Description:	<Description,,To get Claim Search with client name and claim administrator in Intake>
-- =============================================
--[dbo].[Get_PatientsClaimByName]'g',0,10 
CREATE PROCEDURE [dbo].[Get_PatientsClaimByName] 
	@SearchText varchar(max),
	@Skip int,
	@Take int
AS
BEGIN
	WITH PatientClaimDetail AS
		(
		SELECT  ROW_NUMBER() Over(Order by PatientClaims.PatClaimNumber) as Row_ID ,  
		Clients.ClientName, PatientClaims.PatClaimNumber, PatientClaims.PatDOI,PatientClaims.PatientClaimID, 
		 (Patients.PatFirstName +' '+Patients.PatLastName)as PatientName,
		CASE 
			WHEN lower(ClaimAdministratorType) = 'emp' THEN  (select (EmpName) as n from Employers where EmployerID = ClaimAdministratorID)
			WHEN lower(ClaimAdministratorType) = 'ins' THEN  (select ( InsName) as n from Insurers where  InsurerID = ClaimAdministratorID )
			WHEN lower(ClaimAdministratorType) = 'tpa' THEN  (select ( TPAName)  as n from ThirdPartyAdministrators where TPAID = ClaimAdministratorID )
			WHEN lower(ClaimAdministratorType) = 'mcc' THEN  (select ( CompName)  as n from ManagedCareCompanies where CompanyID = ClaimAdministratorID )
			WHEN lower(ClaimAdministratorType) = 'insb' THEN  (select ( InsBranchName) as n from InsuranceBranches where  InsuranceBranchID = ClaimAdministratorID )
			WHEN lower(ClaimAdministratorType) = 'tpab' THEN  (select ( TPABranchName) as n from ThirdPartyAdministratorBranches where  TPABranchID = ClaimAdministratorID )
			  else null  end as ClaimAdministratorName  

		FROM         Clients INNER JOIN
							  PatientClaims ON Clients.ClientID = PatientClaims.PatClientID INNER JOIN
							  Patients ON PatientClaims.PatientID = Patients.PatientID
		where PatientClaims.PatClaimNumber like @SearchText +'%' 
		or Patients.PatFirstName like @SearchText +'%' 
		or Patients.PatLastName like @SearchText +'%' 
		or (Patients.PatFirstName + ' '+ Patients.PatLastName) like @SearchText +'%' 
)
SELECT * FROM PatientClaimDetail
		WHERE Row_ID BETWEEN @Skip + 1 AND @Skip + @Take
END

GO
/****** Object:  StoredProcedure [dbo].[Get_PatientsClaimByNameCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,31/12/2015>
-- Description:	<Description,,To get count of Claim Search with client name and claim administrator in Intake>
-- =============================================
--[dbo].[Get_PatientsClaimByName]'p'
CREATE PROCEDURE [dbo].[Get_PatientsClaimByNameCount] 
	@SearchText varchar(max)
AS
BEGIN

		SELECT   count(PatientClaims.PatClaimNumber) 

		FROM         Clients INNER JOIN
							  PatientClaims ON Clients.ClientID = PatientClaims.PatClientID INNER JOIN
							  Patients ON PatientClaims.PatientID = Patients.PatientID
		where PatientClaims.PatClaimNumber like @SearchText +'%' 
		or Patients.PatFirstName like @SearchText +'%' 
		or Patients.PatLastName like @SearchText +'%' 
		or (Patients.PatFirstName + ' '+ Patients.PatLastName) like @SearchText +'%' 

END

GO
/****** Object:  StoredProcedure [dbo].[Get_PreviousReferralIDFromCurrentReferralInDuplicate]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--============================================================================
-- Author By: MAHINDER SINGH
-- Create date: 01 JUN 2016
-- Description: GET Referral ID from Current Referral from Previous Referral
-- Version: 1.0
-- ============================================================================ 
CREATE PROCEDURE [dbo].[Get_PreviousReferralIDFromCurrentReferralInDuplicate] 
	@ReferralID int
AS
BEGIN
	  
	SELECT RFARequests.RFAReferralID ,RFARequests.DecisionID
	FROM   [dbo].[RFARequests] 
	WHERE 
		   RFARequests.RFARequestID IN(SELECT RFARequestAdditionalInfoes.OriginalRFARequestID FROM dbo.RFARequestAdditionalInfoes
									  WHERE  
											 RFARequestAdditionalInfoes.RFARequestID IN(SELECT  RFARequests.RFARequestID 
																								FROM    [MMC].[dbo].[RFARequests] 
																								WHERE    RFARequests.RFAReferralID = @ReferralID))
		   AND RFARequests.DecisionID IN (1,2,3,12)
					
					
END

GO
/****** Object:  StoredProcedure [dbo].[Get_ReferralByProcessLevel]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HASINGH
-- Create date: 10/26/2015
-- Description: GET Refferal by process level 
-- Version: 1.0
-- ================================================================ 
-- Author By: HSINGH
-- Create date: 12/14/2015
-- Description: get physician name and claimnumber
-- Version: 1.1
-- ================================================================ 

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.2
-- ================================================================ 
--[dbo].[Get_ReferralByProcessLevel] 0,200,70
CREATE PROCEDURE [dbo].[Get_ReferralByProcessLevel] 
	@skip int,
	@take int,
	@processLevel int
AS

	BEGIN
		 WITH ClinicalTriage AS		 
		( 
		
		
		SELECT  ROW_NUMBER() over (Order by RFAReferrals.RFAReferralID desc)as rownumber, RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID,
		 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then (RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) 
                         else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
						,RFARequests.RFALatestDueDate
						FROM         RFARequests INNER JOIN
														  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
														  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
														  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
														  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
														  RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
														  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
														   LEFT JOIN
                                                         RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
						WHERE RFAProcessLevels.ProcessLevel = @ProcessLevel AND RFAReferrals.RFAReferralID IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
						)tbl where Row_ID = 1 and ProcessLevel= @ProcessLevel)
		GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate
						
	
	)
	SELECT * FROM ClinicalTriage
	where rownumber between @skip+1 and (@skip+@take) 
	
END
GO
/****** Object:  StoredProcedure [dbo].[Get_ReferralCountByProcessLevel]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HASINGH
-- Create date: 10/26/2015
-- Description: GET Refferal Count by process level 
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_ReferralCountByProcessLevel] 70
CREATE PROCEDURE [dbo].[Get_ReferralCountByProcessLevel] 
	@processLevel int
AS

	BEGIN




 WITH ClinicalTriage AS		 
		( 
		
		
		SELECT  ROW_NUMBER() over (Order by RFAReferrals.RFAReferralID desc)as rownumber, RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID, RFARequests.RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
						FROM         RFARequests INNER JOIN
														  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
														  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
														  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
														  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
														  RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
														  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
						WHERE RFAProcessLevels.ProcessLevel = @ProcessLevel AND RFAReferrals.RFAReferralID IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
						)tbl where Row_ID = 1 and ProcessLevel= @ProcessLevel)
		GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
						
		
			)
	SELECT Count(*) FROM ClinicalTriage
	
							
END

GO
/****** Object:  StoredProcedure [dbo].[Get_ReferralFileByRFAReferralIDandFileType]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================
-- Author     :	Mahinder Singh
-- Create date: 08 Feb 2016
-- Description:	Get ReferralFile By RFAFileTye ID and FileType

-- Revision History:

-- 1.1		TGosain 06-24-2016
--			#2826 - Custom sorting added for letters.
-- ============================================================
-- [dbo].[Get_ReferralFileByRFAReferralIDandFileType]476
CREATE PROCEDURE [dbo].[Get_ReferralFileByRFAReferralIDandFileType]
@referralID INT
AS
BEGIN
				
Select * From (
	SELECT  FileTypes.FileTypeName,RFAReferralFiles.RFAFileTypeID,RFAReferralFiles.RFAReferralFileID,
				 RFAReferralFiles.RFAReferralFileName, RFAReferralFiles.RFAReferralID, RFAReferralFiles.RFAFileCreationDate
	FROM   [MMC].[dbo].[RFAReferralFiles]
			INNER JOIN lookup.FileTypes ON FileTypes.FileTypeID =  RFAReferralFiles.RFAFileTypeID            
	WHERE  FileTypes.FileTypeID IN (2,3,4,5,8,9,10)AND RFAReferralFiles.RFAReferralID = @referralID 

	UNION ALL

	SELECT  FileTypes.FileTypeName,RFAReferralFiles.RFAFileTypeID,RFAReferralFiles.RFAReferralFileID,
			RFAReferralFiles.RFAReferralFileName, RFAReferralFiles.RFAReferralID , RFAReferralFiles.RFAFileCreationDate
	FROM   [MMC].[dbo].[RFAReferralFiles]
			INNER JOIN lookup.FileTypes ON FileTypes.FileTypeID =  RFAReferralFiles.RFAFileTypeID            
	WHERE  FileTypes.FileTypeID IN (5,8,9,10) AND 
		   RFAReferralFiles.RFAReferralID IN (
					SELECT RFARequests.RFAReferralID   
					FROM   [dbo].[RFARequests] 
					WHERE RFARequests.RFARequestID IN
						(SELECT RFARequestAdditionalInfoes.OriginalRFARequestID 
						 FROM   dbo.RFARequestAdditionalInfoes 
						 WHERE  RFARequestAdditionalInfoes.RFARequestID IN 
								 (SELECT   RFARequestID 
								  FROM   [MMC].[dbo].[RFARequests] 
								  WHERE    RFARequests.RFAReferralID = @referralID AND RFARequests.DecisionID = 10)))
) as tb1							 
ORDER BY CASE WHEN RFAFileTypeID = 2 THEN 1
			  WHEN RFAFileTypeID = 9 then 2  -- Duplicate case
              WHEN RFAFileTypeID = 5 then 3
              WHEN RFAFileTypeID = 8 then 3	 -- Unable to review/No RFA-Letter case              
              WHEN RFAFileTypeID = 10 then 3 -- Deferral case              
              WHEN RFAFileTypeID = 4 THEN 4                            
              WHEN RFAFileTypeID = 3 THEN 5           
              END ASC
																								 
END

GO
/****** Object:  StoredProcedure [dbo].[Get_ReferralMedicalRecordByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 03/28/2016
-- Description: GET All referral Patient Medical Record
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_ReferralMedicalRecordByPatientID] 130,0,100
CREATE PROCEDURE [dbo].[Get_ReferralMedicalRecordByPatientID] 
	@PatientID int,
	@skip int,
	@take int
AS

	BEGIN
		
		WITH PatientMedicalRecordByPatientID AS
		(
		SELECT  ROW_NUMBER() Over(Order by PatientMedicalRecordID desc) as Row_ID,  
			 PatientMedicalRecordID , PatMRDocumentName, PatMRDocumentDate, PhysicianName, PatientID ,RFAReferralID ,PatClaimNumber,RFARecSpltSummary as Summary,AuthorName as Author 
			 ,PatientClaimID
			 FROM (
			SELECT   RFARecordSplittings.RFARecSpltID as PatientMedicalRecordID,  REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') as PatMRDocumentName,
					RFARecordSplittings.RFARecDocumentDate as PatMRDocumentDate,	
					(Physicians.PhysFirstName + ' ' + Physicians.PhysLastName) as PhysicianName, 
					PatientClaims.PatientID, RFAReferrals.RFAReferralID,PatientClaims.PatClaimNumber
					,RFARecordSplittings.AuthorName,RFARecordSplittings.RFARecSpltSummary,RFAReferrals.PatientClaimID
			FROM    RFARecordSplittings INNER JOIN																										
					RFAReferrals ON RFARecordSplittings.RFAReferralID = RFAReferrals.RFAReferralID left JOIN									
					Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId INNER JOIN												
					PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID												
			WHERE   (PatientClaims.PatientID = @PatientID) and  RFARecordSplittings.DocumentCategoryID=3
			
			UNION
			
			SELECT     RFARecordSplittings.RFARecSpltID AS PatientMedicalRecordID, REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') AS PatMRDocumentName, 
								  RFARecordSplittings.RFARecDocumentDate AS PatMRDocumentDate,  RFARecordSplittings.AuthorName AS PhysicianName,PatientClaims.PatientID, 0 AS RFAReferralID, PatientClaims.PatClaimNumber
								  ,RFARecordSplittings.AuthorName as Author ,RFARecordSplittings.RFARecSpltSummary as Summary,PatientClaims.PatientClaimID
			FROM         RFARecordSplittings INNER JOIN
								  PatientClaims ON RFARecordSplittings.PatientClaimID = PatientClaims.PatientClaimID
			WHERE     (PatientClaims.PatientID = @PatientID) AND RFARecordSplittings.RFAReferralID IS NULL and RFARecordSplittings.DocumentCategoryID=3) tbl
			
	)
     SELECT * FROM PatientMedicalRecordByPatientID _PatientMedicalRecordByPatientID
     WHERE _PatientMedicalRecordByPatientID.Row_ID BETWEEN @Skip + 1 AND @Skip + @Take
	
	END


 
		
		--	SELECT  ROW_NUMBER() Over(Order by PatientMedicalRecordID desc) as Row_ID,  
		--	  PatientMedicalRecordID , PatMRDocumentName, PatMRDocumentDate, PhysicianName, PatientID ,RFAReferralID FROM (
		--	SELECT  RFARecordSplittings.RFARecSpltID as PatientMedicalRecordID,  REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') as PatMRDocumentName,
		--			RFARecordSplittings.RFARecDocumentDate as PatMRDocumentDate,	
		--				(Physicians.PhysFirstName + ' ' + Physicians.PhysLastName) as PhysicianName, 
		--					  PatientClaims.PatientID, RFAReferrals.RFAReferralID
		--	FROM       RFARecordSplittings INNER JOIN																										
		--						  RFAReferrals ON RFARecordSplittings.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN									
		--						  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId INNER JOIN												
		--						  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID												
		--	WHERE     (PatientClaims.PatientID = @PatientID)
		--UNION
		--	SELECT   PatientMedicalRecordID , REPLACE(PatMRDocumentName, '.pdf', '') as  PatMRDocumentName, PatMRDocumentDate, ' ' as PhysicianName, PatientID ,0 as RFAReferralID
		--	FROM         PatientMedicalRecords
		--	WHERE PatientID  = @PatientID  ) TBL
		
		
	 
GO
/****** Object:  StoredProcedure [dbo].[Get_ReferralMedicalRecordByPatientIDCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 11/25/2015
-- Description: GET All referral Patient Medical Record count
-- Version: 1.0
-- ================================================================ 
-- [dbo].[Get_ReferralMedicalRecordByPatientIDCount] 92
create PROCEDURE [dbo].[Get_ReferralMedicalRecordByPatientIDCount] 
	@PatientID int 
AS

	BEGIN
		
		 
			SELECT  COUNT(*) as TotalCount FROM (
			SELECT   RFARecordSplittings.RFARecSpltID as PatientMedicalRecordID,  REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') as PatMRDocumentName,
					RFARecordSplittings.RFARecDocumentDate as PatMRDocumentDate,	
					(Physicians.PhysFirstName + ' ' + Physicians.PhysLastName) as PhysicianName, 
					PatientClaims.PatientID, RFAReferrals.RFAReferralID,PatientClaims.PatClaimNumber
			FROM    RFARecordSplittings INNER JOIN																										
					RFAReferrals ON RFARecordSplittings.RFAReferralID = RFAReferrals.RFAReferralID left JOIN									
					Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId INNER JOIN												
					PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID												
			WHERE   (PatientClaims.PatientID = @PatientID) and  RFARecordSplittings.DocumentCategoryID=3
			
			UNION
			
			SELECT     RFARecordSplittings.RFARecSpltID AS PatientMedicalRecordID, REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') AS PatMRDocumentName, 
								  RFARecordSplittings.RFARecDocumentDate AS PatMRDocumentDate,  NULL AS PhysicianName,PatientClaims.PatientID, 0 AS RFAReferralID, PatientClaims.PatClaimNumber
			FROM         RFARecordSplittings INNER JOIN
								  PatientClaims ON RFARecordSplittings.PatientClaimID = PatientClaims.PatientClaimID
			WHERE     (PatientClaims.PatientID = @PatientID) AND RFARecordSplittings.RFAReferralID IS NULL and  RFARecordSplittings.DocumentCategoryID=3
			) TBL
	 
	 
	END


 
GO
/****** Object:  StoredProcedure [dbo].[Get_ReferralsDistinctByProcessLevels]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Mahinder Singh>
-- Create date: <Create Date,,12 JULY 2017>
-- Description:	<Description,,get Referrals for different Process Levels>
-- =============================================
--[dbo].[Get_ReferralsDistinctByProcessLevels]130 
CREATE PROCEDURE [dbo].[Get_ReferralsDistinctByProcessLevels]
@processLevel INT
AS
BEGIN
SELECT COUNT( DISTINCT RFAReferralID) as TotalCount FROM ( 
SELECT  ROW_NUMBER() over (Order by RFAReferrals.RFAReferralID desc)as rownumber, RFARequests.RFARequestID, RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID,
		 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then (RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) 
                         else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
						,RFARequests.RFALatestDueDate
						FROM         RFARequests INNER JOIN
														  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
														  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
														  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
														  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
														  RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
														  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
														   LEFT JOIN
                                                         RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
						WHERE RFAProcessLevels.ProcessLevel = @processLevel AND RFAReferrals.RFAReferralID IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
						)tbl where Row_ID = 1 and ProcessLevel= @processLevel)
		GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate)T
						
END

GO
/****** Object:  StoredProcedure [dbo].[Get_ReferralsForDifferentProcessLevels]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Mahinder Singh>
-- Create date: <Create Date,,12 JULY 2017>
-- Description:	<Description,,get Referrals for different Process Levels>
-- =============================================
--[dbo].[Get_ReferralsForDifferentProcessLevels] 
CREATE PROCEDURE [dbo].[Get_ReferralsForDifferentProcessLevels]

AS
BEGIN
DECLARE @billingTable TABLE(TotalCount INT)
DECLARE @billingTable1 TABLE(TotalCount INT)
DECLARE @billingTable2 TABLE(TotalCount INT)
DECLARE @billingTable3 TABLE(TotalCount INT)
DECLARE @billingTable4 TABLE(TotalCount INT)

INSERT INTO @billingTable
EXEC [dbo].[Get_ReferralsDistinctByProcessLevels]70

INSERT INTO @billingTable1
EXEC [dbo].[Get_ReferralsDistinctByProcessLevels]120

INSERT INTO @billingTable2
EXEC [dbo].[Get_ReferralsDistinctByProcessLevels]130

INSERT INTO @billingTable3
EXEC [dbo].[Get_ReferralsDistinctByProcessLevels]150

INSERT INTO @billingTable4
EXEC [dbo].[Get_ReferralsDistinctByProcessLevels]125


SELECT
(SELECT COUNT(RFAReferralID) FROM (
 SELECT  ROW_NUMBER() over (Order by RFAReferrals.RFAReferralID desc)as rownumber, RFAReferrals.RFAReferralID, PatientClaims.PatClaimNumber, Patients.PatFirstName, Patients.PatLastName
		 FROM         RFAProcessLevels INNER JOIN
                      RFAReferrals ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID LEFT OUTER JOIN
                      Patients INNER JOIN
                      PatientClaims ON Patients.PatientID = PatientClaims.PatientID AND Patients.PatientID = PatientClaims.PatientID ON 
                      RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID
		 GROUP BY RFAReferrals.RFAReferralID, PatientClaims.PatClaimNumber, Patients.PatFirstName, Patients.PatLastName
		 HAVING MAX(RFAProcessLevels.ProcessLevel)<= 60)T) AS IntakeCount,
(SELECT * FROM @billingTable) AS PreparationCount,
(SELECT * FROM @billingTable1) AS ClinicalTriageCount,
(SELECT * FROM @billingTable2) AS ClinicalAuditCount,
(SELECT * FROM @billingTable3) AS NotificationCount,
(SELECT * FROM @billingTable4) AS PeerReviewCount,
(
SELECT COUNT (DISTINCT RFAReferralID) AS TotalCount FROM(
SELECT  ROW_NUMBER() OVER(ORDER BY LTRIM(RTRIM(Clients.ClientName)),DecisionDate DESC) AS ROW,Clients.ClientName
		,Patients.PatFirstName +' '+Patients.PatLastName as PatientName
		, RFAReferrals.RFAReferralID
	
	FROM PatientClaims
	INNER JOIN Patients ON patients.PatientID = PatientClaims.PatientID
	INNER JOIN Clients ON PatClientID = ClientID
	INNER JOIN RFAReferrals ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID
	INNER JOIN RFAProcessLevels ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID	
	INNER JOIN RFARequests ON RFAReferrals.RFAReferralID = RFARequests.RFAReferralID
	LEFT JOIN RFARequestBillings ON RFARequestBillings.RFARequestID = RFARequests.RFARequestID
	INNER JOIN ClientBillings ON ClientBillings.ClientID = Clients.ClientID
	INNER JOIN ClientBillingRetailRates on ClientBillingRetailRates.ClientBillingID =  ClientBillings.ClientBillingID		
	WHERE 
	(SELECT TOP 1 [ProcessLevel] FROM RFAProcessLevels rl WHERE rl.RFAReferralID = RFAProcessLevels.RFAReferralID ORDER BY rl.RFAProcessLevelID DESC) = 160 	
	 and 
	ProcessLevel=160
	)t) AS BillingCount,

(SELECT 
(SELECT COUNT (DISTINCT RFAReferralID) FROM (
SELECT  RFAReferrals.RFAReferralID, isnull(RFARequests.DecisionID,0) as DecisionID,
		 (Case when(RFARequestModifies.RFARequestedTreatment IS null) then (RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) 
                         else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber
						, RFARequests.RFALatestDueDate
						, (SELECT TOP 1 rp.ProcessLevel from RFAProcessLevels rp where rp.RFAReferralID = RFAReferrals.RFAReferralID order by rp.RFAProcessLevelID desc) as ProcessLevel
						FROM         RFARequests INNER JOIN
														  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
														  PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
														  Patients ON PatientClaims.PatientID = Patients.PatientID LEFT OUTER JOIN
														  lookup.Decisions ON lookup.Decisions.DecisionID = RFARequests.DecisionID INNER JOIN
														  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
														   LEFT JOIN
                                                         RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
						WHERE  RFAReferrals.RFAReferralID 
								IN (select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, * from RFAProcessLevels 
									)tbl where Row_ID = 1 and ProcessLevel in (170,190) )
		and RFARequests.DecisionID <> 1
		GROUP BY RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFARequests.DecisionID, RFARequests.RFARequestedTreatment, 
								  lookup.Decisions.DecisionDesc, Patients.PatFirstName, Patients.PatLastName,Physicians.PhysFirstName, Physicians.PhysLastName, PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFALatestDueDate) T)) AS IMRCount
	
END

GO
/****** Object:  StoredProcedure [dbo].[Get_ReferralsInComplete]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSINGH
-- Create date: 11/17/2015
-- Description: GET all incomplete process level
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_ReferralsInComplete]
	@skip int,
	@take int,
	@processLevel int
AS
BEGIN
	WITH InCmpltRef AS (
		 SELECT  ROW_NUMBER() over (Order by RFAReferrals.RFAReferralID desc)as rownumber, RFAReferrals.RFAReferralID, PatientClaims.PatClaimNumber, Patients.PatFirstName, Patients.PatLastName
		 FROM         RFAProcessLevels INNER JOIN
                      RFAReferrals ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID LEFT OUTER JOIN
                      Patients INNER JOIN
                      PatientClaims ON Patients.PatientID = PatientClaims.PatientID AND Patients.PatientID = PatientClaims.PatientID ON 
                      RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID
		 group by RFAReferrals.RFAReferralID, PatientClaims.PatClaimNumber, Patients.PatFirstName, Patients.PatLastName
		 having MAX(RFAProcessLevels.ProcessLevel)<= @processLevel
	)
	
	SELECT * FROM InCmpltRef
	where rownumber between @skip+1 and (@skip+@take) 
END
GO
/****** Object:  StoredProcedure [dbo].[Get_ReferralsTotalCountInComplete]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HSINGH
-- Create date: 11/17/2015
-- Description: GET all incomplete process level
-- Version: 1.0
-- ================================================================ 
create PROCEDURE [dbo].[Get_ReferralsTotalCountInComplete]
	@processLevel int
AS
BEGIN
	
	SELECT     COUNT(RFAReferralID) AS Expr1
	FROM         (SELECT     COUNT(RFAReferrals.RFAReferralID) AS RFAReferralID
                       FROM          RFAProcessLevels INNER JOIN
                                              RFAReferrals ON RFAProcessLevels.RFAReferralID = RFAReferrals.RFAReferralID
                       GROUP BY RFAReferrals.RFAReferralID
                       HAVING      (MAX(RFAProcessLevels.ProcessLevel) <= @processLevel)) AS hp
END
GO
/****** Object:  StoredProcedure [dbo].[Get_RequestByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: HASINGH
-- Create date: 10/29/2015
-- Description: GET Requests by Referral Id 
-- Version: 1.0
-- ================================================================ 
-- 
--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 
-- [dbo].[Get_RequestByReferralID] 593

CREATE PROCEDURE [dbo].[Get_RequestByReferralID]
	@ReferralID int
AS
	BEGIN
	SELECT    RFAReferrals.RFAReferralID, RFARequests.RFARequestID,   (Case when(RFARequestModifies.RFARequestedTreatment IS null) then  (RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) 
                         else  RFARequestModifies.RFARequestedTreatment end) as RFARequestedTreatment, RFAReferrals.RFAHCRGDate, ISNULL(RFARequests.DecisionID, 0) 
                         
                      AS DecisionID, RFARequests.RFAStatus, 
                      RFARequests.RFANotes, RFARequests.RFAGuidelinesUtilized,
                      (Case when(RFARequestModifies.RFAFrequency IS null) then CAST(RFARequests.RFAFrequency AS INT) 
                         else  RFARequestModifies.RFAFrequency end) as RFAFrequency,
                      (Case when(RFARequestModifies.RFADuration IS null) then CAST(RFARequests.RFAFrequency AS INT) 
                         else  RFARequestModifies.RFADuration end) as RFADuration,
                       (Case when(RFARequestModifies.RFADurationTypeID IS null) then RFARequests.RFADurationTypeID
                         else  RFARequestModifies.RFADurationTypeID end) as RFADurationTypeID,
                       RFARequests.RFAClinicalReasonforDecision, RFARequests.RFARelevantPortionUtilized,  RFARequestModifies.RFARequestModifyID 
                        , convert(date,RFARequests.RFALatestDueDate) as RFALatestDueDate
                        ,(SELECT	COUNT(*) FROM RFAReferralFiles where RFAFileTypeID = 11  and RFAReferralID = @ReferralID) as TimeExtensionPNGenerated
                        
	FROM         RFAReferrals INNER JOIN
                      RFARequests ON RFAReferrals.RFAReferralID = RFARequests.RFAReferralID 
                       LEFT JOIN
                      RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID                     
                      WHERE RFAReferrals.RFAReferralID  = @ReferralID
END

GO
/****** Object:  StoredProcedure [dbo].[Get_RequestCPTNDCCodesByRFARequestID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Rohit Kumar>
-- Create date: <01-02-2016>
-- Description:	<Get Request CPT NDC Codes By RFARequestID>
-- =============================================
-- [dbo].[Get_RequestCPTNDCCodesByRFARequestID] 89
CREATE PROCEDURE [dbo].[Get_RequestCPTNDCCodesByRFARequestID] 
(
	@RFARequestID int
)
AS
BEGIN
	DECLARE @Consolidated_CPTNDC_Code varchar(Max)
			
			DECLARE   @SQLQuery AS NVARCHAR(MAX)
			DECLARE   @PivotColumns AS NVARCHAR(MAX)
			 
			--Get unique values of pivot column  
			SELECT   @PivotColumns= COALESCE(@PivotColumns + ',','') + QUOTENAME(CPT_NDCCode)
			FROM ( SELECT      ltrim(rtrim(CPT_NDCCode)) as CPT_NDCCode FROM         RFARequestCPTCodes where RFARequestID = @RFARequestID) AS PivotExample
			 
			SELECT   REPLACE( REPLACE( @PivotColumns, '[', ''), ']', '') as CPTNDC_Code
			 
			
END

GO
/****** Object:  StoredProcedure [dbo].[Get_RequestDetailsInitialNotificationLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tarun Gosain
-- Create date: 12-17-2015
-- Description:	to get request details for initial notification letter
-- Version: 1.0
-- =============================================

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 
-- [Get_RequestDetailsInitialNotificationLetter]32
 CREATE PROCEDURE [dbo].[Get_RequestDetailsInitialNotificationLetter](@referralID int)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT RFARequestID as [RequestID], 
	
	--RFARequestedTreatment as [Treatment], 

	(RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequestID)),'')) as [Treatment],
	
	isnull(RFAFrequency,0) as [Frequency], isnull(RFADuration,0) as [Duration]		
		,(select DurationTypeName from mmc.lookup.DurationTypes where DurationTypeID = RFADurationTypeID) as [DurationType]
		,(select RequestTypeDesc from mmc.lookup.RequestTypes where RequestTypeID = req.RequestTypeID) as [RequestType]
		,req.RFAQuantity		
	  FROM [MMC].[dbo].[RFARequests] as req
	where req.RFAReferralID =@referralID and DecisionID in (1,2,3,9,12)

END

GO
/****** Object:  StoredProcedure [dbo].[Get_RequestedTreatmentByRFARequestID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Rohit Kumar>
-- Create date: <01-02-2016>
-- Description:	<Get update RequestedTreatment name By RFARequestID>
-- =============================================
-- [dbo].[Get_RequestedTreatmentByRFARequestID] 542
CREATE PROCEDURE [dbo].[Get_RequestedTreatmentByRFARequestID] 
(
	@RFARequestID int
)
AS
BEGIN
	
	if ((select COUNT(1) from RFARequestModifies where RFARequestID = @RFARequestID) >0 )
		begin
			SELECT      RFARequestedTreatment FROM         RFARequestModifies	 where RFARequestID = @RFARequestID
		end
	else
		begin
			SELECT      RFARequestedTreatment FROM         RFARequests where RFARequestID = @RFARequestID
		end
	
	
			
END

GO
/****** Object:  StoredProcedure [dbo].[Get_RequestForDuplicateDecision]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH 
-- Create date: 01/19/2016
-- Description: GET  Request For Duplicate Decision 
-- Version: 1.0  
--Get_RequestForDuplicateDecision 210,0,10
-- ================================================================ 
--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_RequestForDuplicateDecision]  
	@patientClaimID int,
	@skip int,
	@take int
AS
BEGIN
	WITH RequestForDuplicate AS
		(
	 SELECT ROW_NUMBER() Over(Order by  RFARequests.RFARequestID desc) as Row_ID,  RFARequests.RFAReferralID, RFARequests.RFARequestID,
						  (RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) 
						  as RFARequestedTreatment
						  ,RFARequests.DecisionDate,RFARequests.DecisionID
                          FROM        RFARequests  
                      where RFARequests.RFAReferralID IN (
                      select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, RFAProcessLevels.ProcessLevel, RFAProcessLevels.RFAProcessLevelID,RFAProcessLevels.RFAReferralID from RFAProcessLevels 
inner join RFAReferrals on RFAProcessLevels.RFAReferralID=RFAReferrals.RFAReferralID where RFAReferrals.PatientClaimID=@patientClaimID
                      
						)tbl where Row_ID = 1 and ProcessLevel>150)
						)
						
		 SELECT * FROM RequestForDuplicate 
		WHERE RequestForDuplicate.Row_ID BETWEEN @Skip + 1 AND @Skip + @Take
		  
	
END

GO
/****** Object:  StoredProcedure [dbo].[Get_RequestForDuplicateDecisionCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 01/19/2016
-- Description: GET Total of Request For Duplicate Decision 
-- Version: 1.0
--Get_RequestForDuplicateDecision 126,0,10
-- ================================================================ 
CREATE PROCEDURE [dbo].[Get_RequestForDuplicateDecisionCount]  
	@patientClaimID int
AS
BEGIN
	WITH RequestForDuplicate AS
		(
	 SELECT ROW_NUMBER() Over(Order by  RFARequests.RFARequestID desc) as Row_ID,  RFARequests.RFAReferralID, RFARequests.RFARequestID,
						  RFARequests.RFARequestedTreatment,RFARequests.DecisionDate,RFARequests.DecisionID
                          FROM        RFARequests  
                      where RFARequests.RFAReferralID IN (
                      select RFAReferralID from (SELECT  ROW_NUMBER() OVER(PARTITION BY  RFAProcessLevels.RFAReferralID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as Row_ID, RFAProcessLevels.ProcessLevel, RFAProcessLevels.RFAProcessLevelID,RFAProcessLevels.RFAReferralID from RFAProcessLevels 
inner join RFAReferrals on RFAProcessLevels.RFAReferralID=RFAReferrals.RFAReferralID where RFAReferrals.PatientClaimID=@patientClaimID
                      
						)tbl where Row_ID = 1 and ProcessLevel>150)
						)
						
		 SELECT COUNT(*) as TotalCount FROM RequestForDuplicate 
END

GO
/****** Object:  StoredProcedure [dbo].[Get_RequestForNotificationByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 12/14/2015
-- Description: GET Requests by Referral Id for notification page
-- Version: 1.0
-- ================================================================ 
--=================================================================
-- Author By: Mahinder Singh
-- Create date: 04 Feb 2016
-- Description: condition updated for RFARequestedTreatment  when it get
--              request in RFARequestModifies then show RFARequestModifies.RFARequestedTreatment
--              else RFARequests.RFARequestedTreatment
-- Version: 1.1
-- ================================================================ 

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.2
-- ================================================================ 

--[dbo].[Get_RequestForNotificationByReferralID] 1220
CREATE PROCEDURE [dbo].[Get_RequestForNotificationByReferralID] 
	@ReferralID int
AS

	BEGIN

SELECT      RFAReferrals.RFAReferralID
           ,RFARequests.RFARequestID
           ,(CASE WHEN(RFARequestModifies.RFARequestedTreatment IS NULL) THEN (RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) 
                         ELSE  RFARequestModifies.RFARequestedTreatment END) AS RFARequestedTreatment
           ,RFAReferrals.RFAHCRGDate 
           ,ISNULL(RFARequests.DecisionID, 0) AS DecisionID
           ,RFARequests.RFALatestDueDate
           ,RFARequests.RFAStatus, RFARequests.RFANotes
           , lookup.Decisions.DecisionDesc,
           (case 
					when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID = 1)
					= (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'Certified' 
				else 
					(case when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID = 3) 
					 = (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'Denied' 
					 else 
					(case when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID in (4,5,6,7,8,9,10,11)) 
					 = (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'UR Decision' 
				
				 else 'Modified' end)end)end) as [Decision]
FROM         RFAReferrals INNER JOIN
                      RFARequests ON RFAReferrals.RFAReferralID = RFARequests.RFAReferralID INNER JOIN
                      lookup.Decisions ON RFARequests.DecisionID = lookup.Decisions.DecisionID AND RFAReferrals.RFAReferralID = @ReferralID
                      LEFT JOIN RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[Get_RequestForPeerReviewByRFAReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: TGosain
-- Create date: 02/10/2016
-- Description: GET Peer Review Request By ReferralID
-- Version: 1.0
-- ================================================================ 
--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 
--[dbo].[Get_ReferralByProcessLevel] 0,200,70
CREATE PROCEDURE [dbo].[Get_RequestForPeerReviewByRFAReferralID]@referralID int
AS
BEGIN
	Select (RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequestID)),'')) as RFARequestedTreatment, RFAClinicalReasonforDecision,RFARequestID,RFALatestDueDate from RFARequests where RFAReferralID=@referralID
END
GO
/****** Object:  StoredProcedure [dbo].[Get_RequestHistoryByRFARequestID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================
-- Author:		<Author,,Gjain>
-- Create date: <Create Date,,01-04-2016>
-- Description:	<Description,,Display UR History for Request selected in UR History Grid>

-- Author By: MAHINDER SINGH
-- UPDATED date: 03 JULY 2016
-- Description:  Display UR History for RequestID 
--               Add RFARequests according to email and Withdrawn Decision,
--  Author By: Mkhurana
-- UPDATED date: 22 Feb 2017
-- Description:  Pdf to doc file for Withdrawn & ClientAuthorized           
-- Version: 1.2
-- =========================================================================================
-- [dbo].[Get_RequestHistoryByRFARequestID] 879,0,10
CREATE PROCEDURE [dbo].[Get_RequestHistoryByRFARequestID] 
(
	@RFARequestID int,
	@skip int,
	@take int
)
AS
BEGIN
DECLARE @requestFileName VARCHAR(MAX)
DECLARE @requestFileNameClient VARCHAR(MAX)
DECLARE @fileName VARCHAR(MAX)
set @fileName = @RFARequestID
SET @requestFileName = @fileName +'_Withdrawn.pdf'
SET @requestFileNameClient = @fileName +'_ClientAuthorized.pdf'

;WITH RequestHistoryByReqID AS
		(
			select  ROW_NUMBER() Over(Order by UploadDate desc) as Row_ID,* from(

				SELECT     RFARequests.RFARequestID, RFAReferralFiles.RFAReferralID, RFAReferralFiles.RFAReferralFileName AS filename, RFAReferralFiles.RFAFileCreationDate as UploadDate, 
								  Users.UserName, RFAReferralFiles.RFAFileTypeID as FileTypeId
				FROM         RFARequests INNER JOIN
								  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
								  RFAReferralFiles ON RFAReferrals.RFAReferralID = RFAReferralFiles.RFAReferralID INNER JOIN
								  Users ON RFAReferralFiles.RFAFileUserID = Users.UserId
								  WHERE     (RFARequests.RFARequestID = @RFARequestID) and RFAReferralFiles.RFAFileTypeID in (2,3,4,5,6,8,9,10,14,16,17,18,19,22)
								  
								  
			union		
						  
			    SELECT     RFARequests.RFARequestID, RFAReferralFiles.RFAReferralID, RFAReferralFiles.RFAReferralFileName AS filename, RFAReferralFiles.RFAFileCreationDate as UploadDate, 
								  Users.UserName, RFAReferralFiles.RFAFileTypeID as FileTypeId
				FROM         RFARequests INNER JOIN
								  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
								  RFAReferralFiles ON RFAReferrals.RFAReferralID = RFAReferralFiles.RFAReferralID INNER JOIN
								  Users ON RFAReferralFiles.RFAFileUserID = Users.UserId
								  WHERE     (RFARequests.RFARequestID = @RFARequestID) and RFAReferralFiles.RFAFileTypeID = 21 
								  AND RFAReferralFiles.RFAReferralFileName = @requestFileName 
								  
			union		
						  
			    SELECT     RFARequests.RFARequestID, RFAReferralFiles.RFAReferralID, RFAReferralFiles.RFAReferralFileName AS filename, RFAReferralFiles.RFAFileCreationDate as UploadDate, 
								  Users.UserName, RFAReferralFiles.RFAFileTypeID as FileTypeId
				FROM         RFARequests INNER JOIN
								  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
								  RFAReferralFiles ON RFAReferrals.RFAReferralID = RFAReferralFiles.RFAReferralID INNER JOIN
								  Users ON RFAReferralFiles.RFAFileUserID = Users.UserId
								  WHERE     (RFARequests.RFARequestID = @RFARequestID) and  RFAReferralFiles.RFAFileTypeID = 23
								  AND  RFAReferralFiles.RFAReferralFileName = @requestFileNameClient
																											  
			union
			        SELECT em.EmailRecordId AS RFARequestID,0 AS RFAReferralID ,em.EmRecSubject AS filename , em.EmailRecDate AS UploadDate, 
					usr.UserName, -1 AS FileTypeId FROM EmailRecords  em
					INNER JOIN Users usr ON usr.UserId = em.UserID
					INNER JOIN EmailRFARequestLinks emReqLink ON emReqLink.EmailRecordId = em.EmailRecordId
					INNER JOIN RFARequests req  ON req.RFARequestID = emReqLink.RFARequestID
					WHERE  req.RFARequestID = @RFARequestID
					
			union
					SELECT     link.RFIRFARequestRecords.RFARequestID, link.RFIRFARequestRecords.RFAReferralID,RFAReferralFiles.RFAReferralFileName AS filename, RFAReferralFiles.RFAFileCreationDate as UploadDate, 
								 Users.UserName,RFAReferralFiles.RFAFileTypeID as FileTypeId
					FROM         RFAReferralFiles INNER JOIN
										  link.RFIRFARequestRecords ON RFAReferralFiles.RFAReferralFileID = link.RFIRFARequestRecords.RFAReferralFileID INNER JOIN
										  Users ON RFAReferralFiles.RFAFileUserID = Users.UserId
					WHERE     (link.RFIRFARequestRecords.RFARequestID = @RFARequestID)
			union 
					SELECT     link.RFARequestTimeExtensionRecords.RFARequestID, link.RFARequestTimeExtensionRecords.RFAReferralID ,
								RFAReferralFiles.RFAReferralFileName AS filename, RFAReferralFiles.RFAFileCreationDate AS UploadDate, Users.UserName, 
								RFAReferralFiles.RFAFileTypeID AS FileTypeId 
					FROM        RFAReferralFiles INNER JOIN
								Users ON RFAReferralFiles.RFAFileUserID = Users.UserId INNER JOIN
								link.RFARequestTimeExtensionRecords ON RFAReferralFiles.RFAReferralFileID = link.RFARequestTimeExtensionRecords.RFAReferralFileID
					WHERE     (link.RFARequestTimeExtensionRecords.RFARequestID = @RFARequestID)
			union
			
				SELECT     RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFAAdditionalInfoes.RFAAdditionalInfoRecord + '_' + CONVERT(varchar(10), RFAAdditionalInfoes.RFAAdditionalInfoRecordDate, 101) 
                      AS filename, RFAAdditionalInfoes.RFAAdditionalInfoRecordDate AS UploadDate, Users.UserName  , 0 as FileTypeId
				FROM         link.RFIReportRFAAdditionalRecords INNER JOIN
									  RFARequests ON link.RFIReportRFAAdditionalRecords.RFARequestID = RFARequests.RFARequestID INNER JOIN
									  RFAReferrals ON link.RFIReportRFAAdditionalRecords.RFAReferralID = RFAReferrals.RFAReferralID AND 
									  link.RFIReportRFAAdditionalRecords.RFAReferralID = RFAReferrals.RFAReferralID AND RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
									  RFAAdditionalInfoes ON link.RFIReportRFAAdditionalRecords.RFAAdditionalInfoID = RFAAdditionalInfoes.RFAAdditionalInfoID INNER JOIN
									  Users ON link.RFIReportRFAAdditionalRecords.UserID = Users.UserId AND link.RFIReportRFAAdditionalRecords.UserID = Users.UserId
				--SELECT     RFARequests.RFARequestID, RFARequests.RFAReferralID, RFAAdditionalInfoes.RFAAdditionalInfoRecord + '_' + CONVERT(varchar(10), RFAAdditionalInfoes.RFAAdditionalInfoRecordDate, 101) 
    --                  AS filename, RFAAdditionalInfoes.RFAAdditionalInfoRecordDate AS UploadDate, Users.UserName, 0 AS FileTypeId
				--FROM         link.RFIReportRFAAdditionalRecords INNER JOIN
    --                  RFARequests ON link.RFIReportRFAAdditionalRecords.RFARequestID = RFARequests.RFARequestID INNER JOIN
    --                  RFAAdditionalInfoes ON link.RFIReportRFAAdditionalRecords.RFAAdditionalInfoID = RFAAdditionalInfoes.RFAAdditionalInfoID INNER JOIN
    --                  Users ON link.RFIReportRFAAdditionalRecords.UserID = Users.UserId AND link.RFIReportRFAAdditionalRecords.UserID = Users.UserId
				WHERE     (RFARequests.RFARequestID = @RFARequestID)
			) as gj
		)	
		 SELECT * FROM RequestHistoryByReqID WHERE RequestHistoryByReqID.Row_ID BETWEEN @Skip + 1 AND @Skip + @Take
		 
		
END

GO
/****** Object:  StoredProcedure [dbo].[Get_RequestHistoryByRFARequestIDCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Gjain>
-- Create date: <Create Date,,01-05-2016>
-- Description:	<Description,,Display UR History for Request selected in UR History Grid Count>

-- Author By: MAHINDER SINGH
-- UPDATED date: 03 JULY 2016
-- Description:  Display UR History for RequestID 
--               Add RFARequests according to email and Withdrawn Decision,                 
-- Version: 1.2
-- =============================================
-- [dbo].[Get_RequestHistoryByRFARequestIDCount] 183
CREATE PROCEDURE [dbo].[Get_RequestHistoryByRFARequestIDCount] 
(
	@RFARequestID int

)
AS
BEGIN

DECLARE @requestFileName VARCHAR(MAX)
DECLARE @requestFileNameClient VARCHAR(MAX)
DECLARE @fileName VARCHAR(MAX)
set @fileName = @RFARequestID
SET @requestFileName = @fileName +'_Withdrawn.pdf'
SET @requestFileNameClient = @fileName +'_ClientAuthorized.pdf'


		Select  COUNT(*) as TotalCount from(

				SELECT     RFARequests.RFARequestID, RFAReferralFiles.RFAReferralID, RFAReferralFiles.RFAReferralFileName AS filename, RFAReferralFiles.RFAFileCreationDate as UploadDate, 
								  Users.UserName, RFAReferralFiles.RFAFileTypeID as FileTypeId
				FROM         RFARequests INNER JOIN
								  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
								  RFAReferralFiles ON RFAReferrals.RFAReferralID = RFAReferralFiles.RFAReferralID INNER JOIN
								  Users ON RFAReferralFiles.RFAFileUserID = Users.UserId
								  WHERE     (RFARequests.RFARequestID = @RFARequestID) and RFAReferralFiles.RFAFileTypeID in (2,3,4,5,6,8,9,10,14,16,17,18,19,22)
								  
								  
		union		
						  
			    SELECT     RFARequests.RFARequestID, RFAReferralFiles.RFAReferralID, RFAReferralFiles.RFAReferralFileName AS filename, RFAReferralFiles.RFAFileCreationDate as UploadDate, 
								  Users.UserName, RFAReferralFiles.RFAFileTypeID as FileTypeId
				FROM         RFARequests INNER JOIN
								  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
								  RFAReferralFiles ON RFAReferrals.RFAReferralID = RFAReferralFiles.RFAReferralID INNER JOIN
								  Users ON RFAReferralFiles.RFAFileUserID = Users.UserId
								  WHERE     (RFARequests.RFARequestID = @RFARequestID) and RFAReferralFiles.RFAFileTypeID = 21 
								  AND RFAReferralFiles.RFAReferralFileName = @requestFileName 
								  
		union		
						  
			    SELECT     RFARequests.RFARequestID, RFAReferralFiles.RFAReferralID, RFAReferralFiles.RFAReferralFileName AS filename, RFAReferralFiles.RFAFileCreationDate as UploadDate, 
								  Users.UserName, RFAReferralFiles.RFAFileTypeID as FileTypeId
				FROM         RFARequests INNER JOIN
								  RFAReferrals ON RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
								  RFAReferralFiles ON RFAReferrals.RFAReferralID = RFAReferralFiles.RFAReferralID INNER JOIN
								  Users ON RFAReferralFiles.RFAFileUserID = Users.UserId
								  WHERE     (RFARequests.RFARequestID = @RFARequestID) and  RFAReferralFiles.RFAFileTypeID = 23
								  AND  RFAReferralFiles.RFAReferralFileName = @requestFileNameClient
																											  
		union
			        SELECT em.EmailRecordId AS RFARequestID,0 AS RFAReferralID ,em.EmRecSubject AS filename , em.EmailRecDate AS UploadDate, 
					usr.UserName, -1 AS FileTypeId FROM EmailRecords  em
					INNER JOIN Users usr ON usr.UserId = em.UserID
					INNER JOIN EmailRFARequestLinks emReqLink ON emReqLink.EmailRecordId = em.EmailRecordId
					INNER JOIN RFARequests req  ON req.RFARequestID = emReqLink.RFARequestID
					WHERE  req.RFARequestID = @RFARequestID
					
		union
				SELECT     link.RFIRFARequestRecords.RFARequestID, link.RFIRFARequestRecords.RFAReferralID,RFAReferralFiles.RFAReferralFileName AS filename, RFAReferralFiles.RFAFileCreationDate as UploadDate, 
									 Users.UserName,RFAReferralFiles.RFAFileTypeID as FileTypeId
					FROM         RFAReferralFiles INNER JOIN
										  link.RFIRFARequestRecords ON RFAReferralFiles.RFAReferralFileID = link.RFIRFARequestRecords.RFAReferralFileID INNER JOIN
										  Users ON RFAReferralFiles.RFAFileUserID = Users.UserId
					WHERE     (link.RFIRFARequestRecords.RFARequestID = @RFARequestID)
		union
				SELECT     link.RFARequestTimeExtensionRecords.RFARequestID, link.RFARequestTimeExtensionRecords.RFAReferralID ,
								RFAReferralFiles.RFAReferralFileName AS filename, RFAReferralFiles.RFAFileCreationDate AS UploadDate, Users.UserName, 
								RFAReferralFiles.RFAFileTypeID AS FileTypeId 
					FROM        RFAReferralFiles INNER JOIN
								Users ON RFAReferralFiles.RFAFileUserID = Users.UserId INNER JOIN
								link.RFARequestTimeExtensionRecords ON RFAReferralFiles.RFAReferralFileID = link.RFARequestTimeExtensionRecords.RFAReferralFileID
					WHERE     (link.RFARequestTimeExtensionRecords.RFARequestID = @RFARequestID)
		union
				SELECT     RFARequests.RFARequestID, RFAReferrals.RFAReferralID, RFAAdditionalInfoes.RFAAdditionalInfoRecord + '_' + CONVERT(varchar(10), RFAAdditionalInfoes.RFAAdditionalInfoRecordDate, 101) 
                      AS filename, RFAAdditionalInfoes.RFAAdditionalInfoRecordDate AS UploadDate, Users.UserName  , 0 as FileTypeId
				FROM         link.RFIReportRFAAdditionalRecords INNER JOIN
									  RFARequests ON link.RFIReportRFAAdditionalRecords.RFARequestID = RFARequests.RFARequestID INNER JOIN
									  RFAReferrals ON link.RFIReportRFAAdditionalRecords.RFAReferralID = RFAReferrals.RFAReferralID AND 
									  link.RFIReportRFAAdditionalRecords.RFAReferralID = RFAReferrals.RFAReferralID AND RFARequests.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
									  RFAAdditionalInfoes ON link.RFIReportRFAAdditionalRecords.RFAAdditionalInfoID = RFAAdditionalInfoes.RFAAdditionalInfoID INNER JOIN
									  Users ON link.RFIReportRFAAdditionalRecords.UserID = Users.UserId AND link.RFIReportRFAAdditionalRecords.UserID = Users.UserId
				WHERE     (RFARequests.RFARequestID = @RFARequestID)
		) as gj

		 
		
END

GO
/****** Object:  StoredProcedure [dbo].[Get_RFADiagnosisByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 06 MAY 2016
-- Description:	Get rfa referral Diagnosis by RFAReferralID
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_RFADiagnosisByReferralID] --1220,0,10
@RFAReferralID INT,
@Skip INT,
@Take INT
AS
BEGIN
	SET NOCOUNT ON;	
	WITH RFADiagnosisByReferralID AS(	
	SELECT  ROW_NUMBER() OVER(ORDER BY pcd.PatientClaimDiagnosisID DESC) AS ROW,rf.RFAReferralID,pcd.PatientClaimID,(CASE WHEN icd9.icdICD9Number IS NULL THEN icd10.icdICD10Number  ELSE icd9.icdICD9Number END) AS icdICDNumber,
	(CASE WHEN icd9.icdICD9Number IS NULL THEN icd10.ICD10Description  ELSE icd9.ICD9Description END) AS ICDDescription, pcd.PatientClaimDiagnosisID FROM PatientClaimDiagnoses pcd
	INNER JOIN RFAReferrals rf ON rf.PatientClaimID = pcd.PatientClaimID
	LEFT JOIN lookup.ICD9Codes icd9 ON icd9.icdICD9NumberID = pcd.icdICDNumberID AND pcd.icdICDTab = 'ICD9' 
	LEFT JOIN lookup.ICD10Codes icd10 ON icd10.icdICD10NumberID = pcd.icdICDNumberID AND pcd.icdICDTab = 'ICD10'
	WHERE rf.RFAReferralID = @RFAReferralID	
	)
	SELECT * FROM RFADiagnosisByReferralID AS CODE
	WHERE CODE.ROW BETWEEN @Skip + 1 AND @Skip + @Take

END


GO
/****** Object:  StoredProcedure [dbo].[Get_RFADiagnosisByReferralIDCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 06 MAY 2016
-- Description:	Get rfa referral Diagnosis by RFAReferralID
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_RFADiagnosisByReferralIDCount] 
@RFAReferralID INT
AS
BEGIN
	SET NOCOUNT ON;	
	SELECT COUNT(*) AS TotalCount FROM PatientClaimDiagnoses pcd
	INNER JOIN RFAReferrals rf ON rf.PatientClaimID = pcd.PatientClaimID
	LEFT JOIN lookup.ICD9Codes icd9 ON icd9.icdICD9Number = pcd.icdICDNumber AND pcd.icdICDTab = 'ICD9'
	LEFT JOIN lookup.ICD10Codes icd10 ON icd10.icdICD10Number = pcd.icdICDNumber AND pcd.icdICDTab = 'ICD10'
	WHERE rf.RFAReferralID = @RFAReferralID		
END


GO
/****** Object:  StoredProcedure [dbo].[Get_RFANewReferralIDFromRFAOldReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 24 MAY 2016
-- Description:	 Preparation - Continue Function :- getting new ID for Merging 
--               RFAReferralID in New RFAReferralID on changing the decision 
--               from Certify or Send To Clincial  to Def,Duplicate,UnableToReview
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_RFANewReferralIDFromRFAOldReferralID] 
@ReferralID INT,@DecisionID INT

AS
BEGIN
	SET NOCOUNT ON;
		
	    IF EXISTS(SELECT * FROM RFAProcessLevels pl INNER JOIN RFASplittedReferralHistories rfH ON RFH.RFANewReferralID = pl.RFAReferralID
				                                   INNER JOIN RFARequests  rq ON rq.RFAReferralID = rfH.RFANewReferralID 
				  WHERE   rfH.RFAOldReferralID = @ReferralID and rq.DecisionID = @DecisionID )
        BEGIN
           
						IF NOT EXISTS(SELECT * FROM RFAProcessLevels 
						              WHERE RFAReferralID = (
															  SELECT TOP 1 req.RFAReferralID 
															  FROM                          dbo.RFARequests req 
															  INNER JOIN                    dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
												              WHERE                         req.RFAReferralID in (
																												  SELECT RFANewReferralID FROM dbo.RFASplittedReferralHistories rfH 
																												  WHERE rfH.RFAOldReferralID = @ReferralID
												                                                                  ) AND req.DecisionID = @DecisionID 
												             ) AND ProcessLevel = 160
									  )
						BEGIN
						
						            SELECT Top 1 req.RFAReferralID 
						            FROM                         dbo.RFARequests req 
									INNER JOIN                   dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
									WHERE                        req.RFAReferralID IN (
																                       SELECT RFANewReferralID FROM dbo.RFASplittedReferralHistories rfH 
																                       WHERE rfH.RFAOldReferralID = @ReferralID
																                       )
									AND req.DecisionID = @DecisionID
						
						END
						ELSE
						BEGIN
									 SELECT 0 AS RFAReferralID
					    END
						
				
		END
		ELSE
		BEGIN
		     
						IF NOT EXISTS(SELECT * FROM RFAProcessLevels 
						              WHERE         RFAReferralID = (SELECT TOP 1 req.RFAReferralID 
						                                             FROM                    dbo.RFARequests req 
												                     INNER JOIN              dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
												                     WHERE                   req.RFAReferralID IN (SELECT RFANewReferralID FROM dbo.RFASplittedReferralHistories
												                                                                   WHERE RFAOldReferralID IN (
																																		      SELECT RFAOldReferralID FROM dbo.RFASplittedReferralHistories 
																																		      WHERE RFANewReferralID = @ReferralID
																																		      ) 
												                                                                    AND RFANewReferralID NOT IN (@ReferralID)
																												   )
																												   AND req.DecisionID = @DecisionID 
												                     ) AND ProcessLevel = 160
									 )
						BEGIN
									   SELECT  TOP 1 req.RFAReferralID 
									   FROM                          dbo.RFARequests req 
									   INNER JOIN                    dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
									   WHERE                         req.RFAReferralID IN (
																							SELECT  RFANewReferralID from dbo.RFASplittedReferralHistories
																							WHERE RFAOldReferralID IN (
																														SELECT RFAOldReferralID FROM dbo.RFASplittedReferralHistories 
																														WHERE RFANewReferralID = @ReferralID
																													   ) AND RFANewReferralID NOT IN (@ReferralID)
																		                   ) 
									  AND req.DecisionID = @DecisionID
					  
					   END
					   ELSE
					   BEGIN
					                  SELECT 0 AS RFAReferralID
					   END
		
		END

END

GO
/****** Object:  StoredProcedure [dbo].[Get_RFANewReferralIDFromRFAOldReferralIDForWithdrawn]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 24 MAY 2016
-- Description:	 Preparation - Continue Function :- getting new ID for Merging 
--               RFAReferralID in New RFAReferralID on changing the decision 
--               from Certify or Send To Clincial  to Def,Duplicate,UnableToReview
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_RFANewReferralIDFromRFAOldReferralIDForWithdrawn] 
@ReferralID INT,@DecisionID INT

AS
BEGIN
	SET NOCOUNT ON;
		
	    IF EXISTS(SELECT * FROM RFAProcessLevels pl INNER JOIN RFASplittedReferralHistories rfH ON RFH.RFANewReferralID = pl.RFAReferralID
				                                   INNER JOIN RFARequests  rq ON rq.RFAReferralID = rfH.RFANewReferralID 
				  WHERE   rfH.RFAOldReferralID = @ReferralID and rq.DecisionID = @DecisionID )
        BEGIN
           
						IF NOT EXISTS(SELECT * FROM RFAProcessLevels 
						              WHERE RFAReferralID = (
															  SELECT TOP 1 req.RFAReferralID 
															  FROM                          dbo.RFARequests req 
															  INNER JOIN                    dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
												              WHERE                         req.RFAReferralID in (
																												  SELECT RFANewReferralID FROM dbo.RFASplittedReferralHistories rfH 
																												  WHERE rfH.RFAOldReferralID = @ReferralID
												                                                                  ) AND req.DecisionID = @DecisionID 
												             ) AND ProcessLevel = 190
									  )
						BEGIN
						
						            SELECT Top 1 req.RFAReferralID 
						            FROM                         dbo.RFARequests req 
									INNER JOIN                   dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
									WHERE                        req.RFAReferralID IN (
																                       SELECT RFANewReferralID FROM dbo.RFASplittedReferralHistories rfH 
																                       WHERE rfH.RFAOldReferralID = @ReferralID
																                       )
									AND req.DecisionID = @DecisionID
						
						END
						ELSE
						BEGIN
									 SELECT 0 AS RFAReferralID
					    END
						
				
		END
		ELSE
		BEGIN
		     
						IF NOT EXISTS(SELECT * FROM RFAProcessLevels 
						              WHERE         RFAReferralID = (SELECT TOP 1 req.RFAReferralID 
						                                             FROM                    dbo.RFARequests req 
												                     INNER JOIN              dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
												                     WHERE                   req.RFAReferralID IN (SELECT RFANewReferralID FROM dbo.RFASplittedReferralHistories
												                                                                   WHERE RFAOldReferralID IN (
																																		      SELECT RFAOldReferralID FROM dbo.RFASplittedReferralHistories 
																																		      WHERE RFANewReferralID = @ReferralID
																																		      ) 
												                                                                    AND RFANewReferralID NOT IN (@ReferralID)
																												   )
																												   AND req.DecisionID = @DecisionID 
												                     ) AND ProcessLevel = 190
									 )
						BEGIN
									   SELECT  TOP 1 req.RFAReferralID 
									   FROM                          dbo.RFARequests req 
									   INNER JOIN                    dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
									   WHERE                         req.RFAReferralID IN (
																							SELECT  RFANewReferralID from dbo.RFASplittedReferralHistories
																							WHERE RFAOldReferralID IN (
																														SELECT RFAOldReferralID FROM dbo.RFASplittedReferralHistories 
																														WHERE RFANewReferralID = @ReferralID
																													   ) AND RFANewReferralID NOT IN (@ReferralID)
																		                   ) 
									  AND req.DecisionID = @DecisionID
					  
					   END
					   ELSE
					   BEGIN
					                  SELECT 0 AS RFAReferralID
					   END
		
		END

END

GO
/****** Object:  StoredProcedure [dbo].[Get_RFANewReferralIDFromRFAOldReferralIdPeerReview]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     : Mahinder Singh
-- Create date: 24 MAY 2016
-- Description:	 Preparation - Continue Function :- getting new ID for Merging 
--               RFAReferralID in New RFAReferralID on changing the decision 
--               from Certify or Send To Clincial  to Def,Duplicate,UnableToReview
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_RFANewReferralIDFromRFAOldReferralIdPeerReview] 
@ReferralID INT

AS
BEGIN
	SET NOCOUNT ON;
		    IF EXISTS(SELECT * FROM RFAProcessLevels pl INNER JOIN RFASplittedReferralHistories rfH ON RFH.RFANewReferralID = pl.RFAReferralID
				                                   INNER JOIN RFARequests  rq ON rq.RFAReferralID = rfH.RFANewReferralID 
				  WHERE   rfH.RFAOldReferralID = @ReferralID and rq.DecisionID IS NULL )
        BEGIN
               
						IF NOT EXISTS(SELECT * FROM RFAProcessLevels 
						              WHERE RFAReferralID = (
															  SELECT TOP 1 req.RFAReferralID 
															  FROM                          dbo.RFARequests req 
															  INNER JOIN                    dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
												              WHERE                         req.RFAReferralID in (
																												  SELECT RFANewReferralID FROM dbo.RFASplittedReferralHistories rfH 
																												  WHERE rfH.RFAOldReferralID = @ReferralID
												                                                                  ) AND req.DecisionID IS NULL 
												             ) AND ProcessLevel = 130
									  )
						BEGIN
						
						            SELECT Top 1 req.RFAReferralID 
						            FROM                         dbo.RFARequests req 
									INNER JOIN                   dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
									WHERE                        req.RFAReferralID IN (
																                       SELECT RFANewReferralID FROM dbo.RFASplittedReferralHistories rfH 
																                       WHERE rfH.RFAOldReferralID = @ReferralID
																                       )
									AND req.DecisionID IS NULL
						
						END
						ELSE
						BEGIN
									 SELECT 0 AS RFAReferralID
					    END
						
				
		END
		ELSE
		BEGIN
		            
						IF NOT EXISTS(SELECT * FROM RFAProcessLevels 
						              WHERE         RFAReferralID = (SELECT TOP 1 req.RFAReferralID 
						                                             FROM                    dbo.RFARequests req 
												                     INNER JOIN              dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
												                     WHERE                   req.RFAReferralID IN (SELECT RFANewReferralID FROM dbo.RFASplittedReferralHistories
												                                                                   WHERE RFAOldReferralID IN (
																																		      SELECT RFAOldReferralID FROM dbo.RFASplittedReferralHistories 
																																		      WHERE RFANewReferralID = @ReferralID
																																		      ) 
												                                                                    AND RFANewReferralID NOT IN (@ReferralID)
																												   )
																												   AND req.DecisionID IS NULL 
												                     ) AND ProcessLevel = 130
									 )
						BEGIN
									   SELECT  TOP 1 req.RFAReferralID 
									   FROM                          dbo.RFARequests req 
									   INNER JOIN                    dbo.RFAProcessLevels pl ON pl.RFAReferralID = req.RFAReferralID
									   WHERE                         req.RFAReferralID IN (
																							SELECT  RFANewReferralID from dbo.RFASplittedReferralHistories
																							WHERE RFAOldReferralID IN (
																														SELECT RFAOldReferralID FROM dbo.RFASplittedReferralHistories 
																														WHERE RFANewReferralID = @ReferralID
																													   ) AND RFANewReferralID NOT IN (@ReferralID)
																		                   ) 
									  AND req.DecisionID IS NULL
					  
					   END
					   ELSE
					   BEGIN
					                  SELECT 0 AS RFAReferralID
					   END
		
		END
END

GO
/****** Object:  StoredProcedure [dbo].[Get_RFAPatMedicalRecordReviewByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 12/17/2015
-- Description: GET All Patient Medical Record Review By PatientID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_RFAPatMedicalRecordReviewByPatientID] 130,537, 0,10
CREATE PROCEDURE [dbo].[Get_RFAPatMedicalRecordReviewByPatientID]
	@PatientID int,
	@ReferralID int,
	@skip int,
	@take int
AS
BEGIN

	
			
		WITH PatientMedicalRecordReviewByPatientID AS
		(
		 
		 		select  ROW_NUMBER() Over(Order by RFAPatMedicalRecordReviewedID desc) as Row_ID, 
		 		RFAPatMedicalRecordReviewedID, RFARecSpltID, RFAReferralID, 
		 		
				PatMRDocumentName,PatMRDocumentDate, PhysicianID,PhysicianName ,PatientClaimID from (	
			SELECT     RFAPatMedicalRecordReviews.RFAPatMedicalRecordReviewedID, RFAPatMedicalRecordReviews.RFARecSpltID, RFAPatMedicalRecordReviews.RFAReferralID, 
								  REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') AS PatMRDocumentName, RFARecordSplittings.RFARecDocumentDate AS PatMRDocumentDate, 
								  RFAReferrals.PhysicianID, RFARecordSplittings.AuthorName AS PhysicianName ,RFAReferrals.PatientClaimID  
			FROM         RFAPatMedicalRecordReviews INNER JOIN
								  RFARecordSplittings ON RFAPatMedicalRecordReviews.RFARecSpltID = RFARecordSplittings.RFARecSpltID INNER JOIN
								  RFAReferrals ON RFAPatMedicalRecordReviews.RFAReferralID = RFAReferrals.RFAReferralID
			WHERE     (RFAPatMedicalRecordReviews.RFAReferralID = @ReferralID) and RFARecordSplittings.RFAReferralID is null
			union
			SELECT     RFAPatMedicalRecordReviews.RFAPatMedicalRecordReviewedID, RFAPatMedicalRecordReviews.RFARecSpltID, RFAPatMedicalRecordReviews.RFAReferralID, 
								  REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') AS PatMRDocumentName, RFARecordSplittings.RFARecDocumentDate AS PatMRDocumentDate, 
								  RFAReferrals.PhysicianID, Physicians.PhysFirstName + ' ' + Physicians.PhysLastName AS PhysicianName, RFAReferrals.PatientClaimID
			FROM         RFAPatMedicalRecordReviews INNER JOIN
								  RFARecordSplittings ON RFAPatMedicalRecordReviews.RFARecSpltID = RFARecordSplittings.RFARecSpltID INNER JOIN
								  RFAReferrals ON RFARecordSplittings.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
								  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
			WHERE     (RFAPatMedicalRecordReviews.RFAReferralID = @ReferralID))tbl
		 
		)
		 SELECT * FROM PatientMedicalRecordReviewByPatientID _PatientMedicalRecordByPatientID
		WHERE _PatientMedicalRecordByPatientID.Row_ID BETWEEN @Skip + 1 AND @Skip + @Take
		end

 
		
--		WITH PatientMedicalRecordReviewByPatientID AS
--		(
--SELECT   ROW_NUMBER() Over(Order by RFAPatMedicalRecordReviews.RFAPatMedicalRecordReviewedID desc) as Row_ID,  RFARecordSplittings.RFAReferralID,  RFARecordSplittings.RFARecSpltID,RFARecordSplittings.RFARecDocumentDate as PatMRDocumentDate, 
--RFAPatMedicalRecordReviews.RFAPatMedicalRecordReviewedID,   REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') as PatMRDocumentName, PatientClaims.PatientClaimID,Physicians.PhysicianId
--, Physicians.PhysFirstName + ' ' + Physicians.PhysLastName as PhysicianName
--FROM         Physicians INNER JOIN
--                      RFAReferrals ON Physicians.PhysicianId = RFAReferrals.PhysicianID RIGHT OUTER JOIN
--                      RFAPatMedicalRecordReviews INNER JOIN
--                      RFARecordSplittings ON RFAPatMedicalRecordReviews.RFARecSpltID = RFARecordSplittings.RFARecSpltID INNER JOIN
--                      PatientClaims ON RFARecordSplittings.PatientClaimID = PatientClaims.PatientClaimID ON RFAReferrals.RFAReferralID = RFARecordSplittings.RFAReferralID
--			where PatientClaims.PatientID = @PatientID ---and RFARecordSplittings.RFAReferralID=@ReferralID
--	)
--     SELECT * FROM PatientMedicalRecordReviewByPatientID _PatientMedicalRecordByPatientID
--     WHERE _PatientMedicalRecordByPatientID.Row_ID BETWEEN @Skip + 1 AND @Skip + @Take
	
 

 

GO
/****** Object:  StoredProcedure [dbo].[Get_RFAPatMedicalRecordReviewByPatientIDCount]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSingh
-- Create date: 17/12/2015
-- Description: GET All Patient Medical Record Review count
-- Version: 1.0
-- ================================================================ 
CREATE PROCEDURE  [dbo].[Get_RFAPatMedicalRecordReviewByPatientIDCount] 
@PatientID int ,@ReferralID int
AS
BEGIN
SELECT  COUNT(*) as TotalCount FROM (

	SELECT     RFAPatMedicalRecordReviews.RFAPatMedicalRecordReviewedID, RFAPatMedicalRecordReviews.RFARecSpltID, RFAPatMedicalRecordReviews.RFAReferralID, 
								  REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') AS PatMRDocumentName, RFARecordSplittings.RFARecDocumentDate AS PatMRDocumentDate, 
								  RFAReferrals.PhysicianID,  '' AS PhysicianName ,RFAReferrals.PatientClaimID  
			FROM         RFAPatMedicalRecordReviews INNER JOIN
								  RFARecordSplittings ON RFAPatMedicalRecordReviews.RFARecSpltID = RFARecordSplittings.RFARecSpltID INNER JOIN
								  RFAReferrals ON RFAPatMedicalRecordReviews.RFAReferralID = RFAReferrals.RFAReferralID
			WHERE     (RFAPatMedicalRecordReviews.RFAReferralID = @ReferralID) and RFARecordSplittings.RFAReferralID is null
			union
			SELECT     RFAPatMedicalRecordReviews.RFAPatMedicalRecordReviewedID, RFAPatMedicalRecordReviews.RFARecSpltID, RFAPatMedicalRecordReviews.RFAReferralID, 
								  REPLACE(RFARecordSplittings.RFARecDocumentName, '.pdf', '') AS PatMRDocumentName, RFARecordSplittings.RFARecDocumentDate AS PatMRDocumentDate, 
								  RFAReferrals.PhysicianID, Physicians.PhysFirstName + ' ' + Physicians.PhysLastName AS PhysicianName, RFAReferrals.PatientClaimID
			FROM         RFAPatMedicalRecordReviews INNER JOIN
								  RFARecordSplittings ON RFAPatMedicalRecordReviews.RFARecSpltID = RFARecordSplittings.RFARecSpltID INNER JOIN
								  RFAReferrals ON RFARecordSplittings.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
								  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
			WHERE     (RFAPatMedicalRecordReviews.RFAReferralID = @ReferralID)


--SELECT   ROW_NUMBER() Over(Order by RFAPatMedicalRecordReviews.RFAPatMedicalRecordReviewedID desc) as Row_ID  
--FROM         Physicians INNER JOIN
--                      RFAReferrals ON Physicians.PhysicianId = RFAReferrals.PhysicianID RIGHT OUTER JOIN
--                      RFAPatMedicalRecordReviews INNER JOIN
--                      RFARecordSplittings ON RFAPatMedicalRecordReviews.RFARecSpltID = RFARecordSplittings.RFARecSpltID INNER JOIN
--                      PatientClaims ON RFARecordSplittings.PatientClaimID = PatientClaims.PatientClaimID ON RFAReferrals.RFAReferralID = RFARecordSplittings.RFAReferralID
--			where PatientClaims.PatientID = @PatientID --and RFARecordSplittings.RFAReferralID=@ReferralID
			
	) as Total
    
END

GO
/****** Object:  StoredProcedure [dbo].[Get_RFAReferralFilesAccToReferralIDInPreparationCase]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================
-- Author     :	Mahinder Singh
-- Create date: 06 Aug 2016
-- Description:	Get ReferralFiles acc to ReferralID
-- ============================================================

CREATE PROCEDURE [dbo].[Get_RFAReferralFilesAccToReferralIDInPreparationCase]
@RFAReferralID INT
AS
BEGIN
		SELECT RFAReferralFileID,RFAReferralID,RFAFileTypeID,RFAReferralFileName,RFAFileCreationDate
		       FROM RFAReferralFiles WHERE RFAReferralID = @RFAReferralID AND RFAFileTypeID IN (22,11,15)																					 
END
GO
/****** Object:  StoredProcedure [dbo].[Get_RFARequestByClaimID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: GJain
-- Create date: 01/28/2016
-- Description: GET Requests by Claim Id 
-- Version: 1.0
-- ================================================================ 

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

--[dbo].[Get_RFARequestByClaimID] 142
CREATE PROCEDURE [dbo].[Get_RFARequestByClaimID] 
	@PatientClaimID int
AS

	BEGIN

SELECT     RFARequestID, RFAReferralID, (RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequestID)),'')) as RFARequestedTreatment , RFAFrequency, RequestTypeID, RFADuration, RFAQuantity, TreatmentCategoryID, TreatmentTypeID, 
                      DecisionID, RFAExpediteReferral, RFAStrenght, RFADurationTypeID, RFAStatus, RFANotes, RFAClinicalReasonforDecision, RFAGuidelinesUtilized, 
                      RFARelevantPortionUtilized, RFARequestDate, DecisionDate, RFAReqCertificationNumber
FROM         RFARequests
WHERE     (RFAReferralID IN
                          (SELECT     RFAReferralID
                            FROM          RFAReferrals
                            WHERE      (PatientClaimID = @PatientClaimID)))
	
END

 
GO
/****** Object:  StoredProcedure [dbo].[Get_RFARequestLatestDueDate]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 03/17/2016
-- Description: GET Latest Due Date
-- Version: 1.0
-- ================================================================ 


CREATE PROCEDURE [dbo].[Get_RFARequestLatestDueDate]
(
 @AddDay int,
 @RFARequestDate  DateTime
 
)
 
AS
BEGIN
select dbo.[Get_LatestRFARequestDueDate](@AddDay, @RFARequestDate) 
END

GO
/****** Object:  StoredProcedure [dbo].[Get_SignaturePathAndDescription]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Mahinder Singh>
-- Create date: <Create Date,,23 feb 2016>
-- Description:	<Get_SignaturePathAndDescription>
-- =============================================
-- [dbo].[Get_SignaturePathAndDescription]152
CREATE PROCEDURE [dbo].[Get_SignaturePathAndDescription]
	@referralID int
AS
BEGIN

DECLARE @MahiTemp Table(ClientID varchar(10),PatientID varchar(10),ClaimID varchar(10),ReferalID varchar(10))
INSERT INTO @MahiTemp(ClientID,PatientID,ClaimID,ReferalID)exec [dbo].[Get_StorageStuctureByID]@referralID,'R'

SELECT ('Storage/'+MT.ClientID+'/'+MT.PatientID+'/'+MT.ClaimID+'/'+MT.ReferalID+'/Signature/'+ RFASignature) as RFASignature
       FROM RFAReferrals rf
       INNER JOIN @MahiTemp MT ON MT.ReferalID = rf.RFAReferralID
WHERE RFAReferralID = @referralID

END

GO
/****** Object:  StoredProcedure [dbo].[Get_StorageStuctureByID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,28-12-2015>
-- Description:	<Description,, get folder structure by claim id or referral id>
-- =============================================\
--[dbo].[Get_StorageStuctureByID]130,'p'
CREATE PROCEDURE [dbo].[Get_StorageStuctureByID]
	@ID int,
	@By char(1)
AS
BEGIN

if(upper(@By)='R')
begin
     SELECT     PatientClaims.PatClientID as ClientID , PatientClaims.PatientID as PatientID, PatientClaims.PatientClaimID as ClaimID ,@ID as ReferralID
FROM         RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID
WHERE     (RFAReferrals.RFAReferralID = @ID)
end
else
begin
if(upper(@By)='C')
begin																					
 SELECT     PatClientID as ClientID, PatientID, PatientClaimID as ClaimID,0 as ReferralID
																					FROM         PatientClaims
																					WHERE     (PatientClaimID = @ID) 
	
end
else if(upper(@By)='P')
begin	
 SELECT top 1     PatClientID as ClientID, PatientID, PatientClaimID as ClaimID,0 as ReferralID
																					FROM         PatientClaims
																					WHERE     (PatientID = @ID) 
	
end
else
begin



 declare @claimID int
  set @claimID =(   SELECT   PatientClaims.PatientClaimID 
	FROM         RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID
	WHERE     (RFAReferrals.RFAReferralID = @ID))
	
	SELECT     PatClientID as ClientID, PatientID, PatientClaimID as ClaimID,0 as ReferralID
																					FROM         PatientClaims
																					WHERE     (PatientClaimID = @claimID)
     end   
   end     
END

GO
/****** Object:  StoredProcedure [dbo].[Move_RFARequestRecordToRFADeletedRequest]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: rkumar
-- Create date: 05/26/2016
-- Description: This function will not delete record but will move Request Record to new table to store as "Deleted" Requests. Request will no longer show as part of ReferralID
-- Version: 1.0
-- ================================================================ 

Create PROCEDURE [dbo].[Move_RFARequestRecordToRFADeletedRequest] 
	@RFARequestID int 
AS
	BEGIN
		  
		INSERT INTO RFADeletedRequests
                      (RFAOldRequestID, RFAReferralID,  RFARequestedTreatment, RFAFrequency, RequestTypeID, RFADuration, RFAQuantity, TreatmentCategoryID, 
                      TreatmentTypeID, DecisionID, RFAExpediteReferral, RFAStrenght, RFADurationTypeID, RFAStatus, RFANotes, RFAClinicalReasonforDecision, RFAGuidelinesUtilized, 
                      RFARelevantPortionUtilized, RFARequestDate, DecisionDate, RFAReqCertificationNumber, RFALatestDueDate, RFARequestIMRCreatedDate)
		SELECT     RFARequestID, RFAReferralID, RFARequestedTreatment, RFAFrequency, RequestTypeID, RFADuration, RFAQuantity, TreatmentCategoryID, TreatmentTypeID, 
                      DecisionID, RFAExpediteReferral, RFAStrenght, RFADurationTypeID, RFAStatus, RFANotes, RFAClinicalReasonforDecision, RFAGuidelinesUtilized, 
                      RFARelevantPortionUtilized, RFARequestDate, DecisionDate, RFAReqCertificationNumber, RFALatestDueDate, RFARequestIMRCreatedDate
		FROM         RFARequests
		where RFARequestID = @RFARequestID
		
		DELETE FROM RFARequests where RFARequestID = @RFARequestID
		
		
	END

GO
/****** Object:  StoredProcedure [dbo].[Rpt_ClientLogoPathAndClientDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Mahinder Singh>
-- Create date: <Create Date,,08 MAR 2016>
-- Description:	<Get_ClientLogoPathForReport>
-- 1.1 -- Added ClientIsPrivateLabel clumn to get Value for RFI Report
-- =============================================
-- [dbo].[Rpt_ClientLogoPathAndClientDetails]138
CREATE PROCEDURE [dbo].[Rpt_ClientLogoPathAndClientDetails]
	@referralID INT
AS
BEGIN

--SELECT    CASE WHEN ClientPrivateLabels.ClientPrivateLabelLogoName IS NOT NULL then ('Storage/'+CONVERT(VARCHAR(10),ClientPrivateLabels.ClientID)+'/ClientPrivateLableLogo/'+ ClientPrivateLabels.ClientPrivateLabelLogoName) else '' end as ClientLogoNameWithPath,
--				ClientPrivateLabels.*, lookup.States.StateName
--FROM         PatientClaims INNER JOIN
--                      RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID INNER JOIN
--                      ClientPrivateLabels ON PatientClaims.PatClientID = ClientPrivateLabels.ClientID INNER JOIN
--                      lookup.States on ClientPrivateLabels.ClientPrivateLabelStateID = lookup.States.StateId
--Where RFAReferrals.RFAReferralID = @referralID
SELECT    CASE WHEN ClientPrivateLabels.ClientPrivateLabelLogoName IS NOT NULL then ('Storage/'+CONVERT(VARCHAR(10),ClientPrivateLabels.ClientID)+'/ClientPrivateLableLogo/'+ ClientPrivateLabels.ClientPrivateLabelLogoName) else '' end as ClientLogoNameWithPath,
				ClientPrivateLabels.*, lookup.States.StateName, dbo.ClientBillings.ClientIsPrivateLabel
FROM         PatientClaims INNER JOIN
                      RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID INNER JOIN
                      ClientPrivateLabels ON PatientClaims.PatClientID = ClientPrivateLabels.ClientID INNER JOIN 
                      lookup.States on ClientPrivateLabels.ClientPrivateLabelStateID = lookup.States.StateId INNER JOIN 
                      ClientBillings on ClientBillings.ClientID=ClientPrivateLabels.ClientID --- added  for get PrivateLable value to show emailID in RFI report
Where RFAReferrals.RFAReferralID = @referralID
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_ClientLogoPathAndClientDetailsByPatClaimID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Mahinder Singh>
-- Create date: <Create Date,,08 MAR 2016>
-- Description:	<Get_ClientLogoPathForReport>
-- =============================================
-- [dbo].[Rpt_ClientLogoPathAndClientDetails]138
CREATE PROCEDURE [dbo].[Rpt_ClientLogoPathAndClientDetailsByPatClaimID]
	@PatientClaimID INT
AS
BEGIN

SELECT  Top 1  CASE WHEN ClientPrivateLabels.ClientPrivateLabelLogoName IS NOT NULL then ('Storage/'+CONVERT(VARCHAR(10),ClientPrivateLabels.ClientID)+'/ClientPrivateLableLogo/'+ ClientPrivateLabels.ClientPrivateLabelLogoName) else '' end as ClientLogoNameWithPath,
				ClientPrivateLabels.*, lookup.States.StateName
FROM         PatientClaims INNER JOIN
                      RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID INNER JOIN
                      ClientPrivateLabels ON PatientClaims.PatClientID = ClientPrivateLabels.ClientID INNER JOIN
                      lookup.States on ClientPrivateLabels.ClientPrivateLabelStateID = lookup.States.StateId
Where RFAReferrals.PatientClaimID = @PatientClaimID

END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_CurrentWorkLoadRecords]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Mkhurana>
-- Create date: <07-sept-2017>
-- Description:	<to get current workload records as per task 3126>
-- =============================================
-- [dbo].[Rpt_CurrentWorkLoadRecords] '2017-09-01','2017-09-30','40','1,2,3,4,5,6,7,8,9,10,11,12'
CREATE PROCEDURE [dbo].[Rpt_CurrentWorkLoadRecords]
	(
	@startDate date, 
	@endDate date,
	@clientID varchar(max),
	@status varchar(max)	
	)
AS
BEGIN

WITH  CurrentWorkLoadRecords AS
		(
	         select * from (
	         
	         SELECT ROW_NUMBER() OVER(PARTITION BY  RFARequests.RFARequestID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as RowNumber ,   
			PatientClaims.PatientClaimID, PatientClaims.PatientID, RFARequests.RFAReferralID, RFARequests.RFARequestID, 
			
			RFAReferralCreatedDate,RFACEDate,RFAHCRGDate,
			 Patients.PatFirstName + ' ' + Patients.PatLastName as Patient, 
			CASE 
		 WHEN lower(ClaimAdministratorType) = 'emp' THEN  (SELECT EmpName as n from Employers where EmployerID = ClaimAdministratorID)
		 WHEN lower(ClaimAdministratorType) = 'ins' THEN  (SELECT InsName as n from Insurers where  InsurerID = ClaimAdministratorID )
		   WHEN lower(ClaimAdministratorType) = 'insb' THEN  (SELECT InsBranchName as InsBranchName   from InsuranceBranches where InsuranceBranchID = ClaimAdministratorID )
		 WHEN lower(ClaimAdministratorType) = 'tpa' THEN  (SELECT TPAName  as n from ThirdPartyAdministrators where TPAID = ClaimAdministratorID )
		 WHEN lower(ClaimAdministratorType) = 'mcc' THEN  (SELECT CompName  as n from ManagedCareCompanies where CompanyID = ClaimAdministratorID )
		 WHEN lower(ClaimAdministratorType) = 'tpab' THEN  (SELECT TPABranchName  as n from ThirdPartyAdministratorBranches where TPABranchID = ClaimAdministratorID )
		 ELSE null END AS ClaimAdministratorName,
		 EmpName,
		 (SELECT RequestTypeDesc from lookup.RequestTypes where lookup.RequestTypes.RequestTypeID=RFARequests.RequestTypeID) as RequestType,			
			 Clients.ClientID, CPT_NDCCode, Adjusters.AdjFirstName +  ' ' + Adjusters.AdjLastName As  Adjuster,
						   
						(Case when(RFARequestModifies.RFARequestID=RFARequests.RFARequestID) 
						   then (RFARequestModifies.RFARequestedTreatment) 
                         else  RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID ( RFARequests.RFARequestID)),'') end) as RFARequestedTreatment, 
                         
                         Physicians.PhysFirstName+' ' + Physicians.PhysLastName as Physician
                         , Physicians.PhysicianId
                         
                         , (case when (RFARequests.DecisionDate IS NULL And RFAProcessLevels.ProcessLevel>60)
             then (Case when(RFARequests.RFAStatus = 'SendToPreparation') then 'Preparation'
                         when(RFARequests.RFAStatus = 'SendToClinical') then 'Clinical'
                         when(RFARequests.DecisionID = 13) then 'Withdrawn'
                         when(RFARequests.DecisionID = 12) then 'Client Authorized'                         
                         else lookup.ProcessLevels.ProcessLevelDesc end)
			else  (case when exists(select top 1 imrreq.RFARequestID from IMRRFARequests imrreq where imrreq.RFARequestID = RFARequests.RFARequestID) 
					then (select IMRDecisionDesc from lookup.IMRDecision where IMRDecisionID = (select imrref.IMRDecisionID from IMRRFAReferrals imrref where imrref.RFAReferralID = RFAReferrals.RFAReferralID))
					else lookup.Decisions.DecisionDesc end)
			end) as Status
			
			
			, RFARequests.DecisionDate,RFARequests.RFARequestDate,RFALatestDueDate,lookup.Decisions.DecisionDesc
			 
			FROM         PatientClaims INNER JOIN
						  RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID INNER JOIN
						  RFARequests ON RFAReferrals.RFAReferralID = RFARequests.RFAReferralID INNER JOIN
						   [dbo].[Patients] ON Patients.PatientID = PatientClaims.PatientID INNER JOIN
						 [dbo].[Clients] ON ClientID = PatientClaims.PatClientID inner join
						 [dbo].[Adjusters] ON Adjusters.AdjusterID = PatientClaims.PatAdjusterID  INNER JOIN
					[dbo].[Employers] ON Employers.EmployerID = PatientClaims.PatEmployerID 	 INNER JOIN 
					 [dbo].[RFARequestCPTCodes] ON RFARequestCPTCodes.RFARequestID=RFARequests.RFARequestID	INNER JOIN
						  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId Left JOIN
						  lookup.Decisions ON RFARequests.DecisionID = lookup.Decisions.DecisionID INNER JOIN
						  RFAProcessLevels ON RFAReferrals.RFAReferralID = RFAProcessLevels.RFAReferralID Left JOIN
						  lookup.ProcessLevels ON RFAProcessLevels.ProcessLevel = lookup.ProcessLevels.ProcessLevel LEFT JOIN
                          RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
						  
			
			 ) as rs where RowNumber=1		 
			 
			 )
			  SELECT * FROM CurrentWorkLoadRecords where
			 CurrentWorkLoadRecords.Status in (select
			 
			   Case when  lookup.Statuses.StatusName='Clinical Triage' then 'Clinical'
			   	else  lookup.Statuses.StatusName 
			 end as StatusName
			   from lookup.Statuses where StatusID in (Select splitdata from [global].[Get_SplitStringFormat](@status,','))) AND 
			   (CurrentWorkLoadRecords.RFAReferralCreatedDate BETWEEN @startDate 
			   and @endDate) 
			   AND CurrentWorkLoadRecords.ClientID in (Select splitdata from [global].[Get_SplitStringFormat](@clientID,','))
			   
END
GO
/****** Object:  StoredProcedure [dbo].[Rpt_GenearateRFILetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,15-01-2016>
-- Description:	<Description,,Generate RFI Letter from Preparation Screen>
-- =============================================

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

-- [dbo].[Rpt_GenearateRFILetter] 1232
CREATE PROCEDURE [dbo].[Rpt_GenearateRFILetter]
	@ReferralID int
AS
BEGIN

SELECT   CONVERT(varchar(10),getDate()  ,101)CurrentDate,(Patients.PatFirstName+' '+ Patients.PatLastName) PatientName,
  REPLACE(SUBSTRING(Patients.PatSSN,1,4),SUBSTRING(Patients.PatSSN,1,4),'XXX')+'-'+REPLACE(SUBSTRING(Patients.PatSSN,5,7),SUBSTRING(Patients.PatSSN,5,7),'XX')+'-'+
   REPLACE(SUBSTRING(Patients.PatSSN,8,11),SUBSTRING(Patients.PatSSN,8,11),SUBSTRING(Patients.PatSSN,8,11)) as PatSSN,
   
					  PatientClaims.PatClaimNumber,(Physicians.PhysFirstName+' '+Physicians.PhysLastName)PhysicianName, 
                      Physicians.PhysPhone , (SELECT DISTINCT 
  STUFF((SELECT distinct ', ' + (RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) 
         FROM RFARequests
       Where  RFARequests.RFAReferralID= @ReferralID
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)')
        ,1,1,'') Request
FROM RFARequests )as Request
FROM         RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      Patients ON PatientClaims.PatientID = Patients.PatientID INNER JOIN
                      Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId 
WHere	RFAReferrals.RFAReferralID = @ReferralID



--SELECT    RFARequestedTreatment AS Requests
--FROM         RFARequests
--Where   RFAReferralID = @ReferralID

--SELECT     (RFAAdditionalInfoRecord + ISNULL( ' - '+ CONVERT(varchar(10),RFAAdditionalInfoRecordDate,101),''))AdditionalInfo
--FROM         RFAAdditionalInfoes
--where  RFAReferralID  = @ReferralID


END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetAdditionalInfoForRFILetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,18-01-2016>
-- Description:	<Description,,to get Additional Info for RFI letter by referral Id>
-- =============================================
-- 1.1: 03-02-2015 TGosain
--		Date removed fromt he conatination to AdditinalInfo column
-- =============================================
-- [dbo].[Rpt_GetAdditionalInfoForRFILetter] 539
CREATE PROCEDURE [dbo].[Rpt_GetAdditionalInfoForRFILetter]
@ReferralID int
AS
BEGIN
		SELECT    RFAAdditionalInfoRecord AS AdditionalInfo 
		FROM      RFAAdditionalInfoes 
		WHERE     (RFAReferralID = @ReferralID) and RFAAdditionalInfoRecordDate is null
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetChiropracticLetterForIMRResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		HaSingh
-- Create date: 31/3/2016
-- Description:	Get QME/AME Letter for IMR Response Letter Report

--Revision History: -
-- 1.1		TGosain 06-15-2016
--			@AttachedDocument pattern updated for uniqueness 
-- =============================================
-- [dbo].[Rpt_GetChiropracticLetterForIMRResponseLetter]542,'235-745D13,179-542D10,167-542D24,168-542D25,169-542D26,170-542D27,185-542D28,173-542D6,174-542D7,204-547D6,175-542D23,177-542D19,178-542D20,205-547D19,206-531D8,171-542D29,172-542D30,176-542D8'
CREATE PROCEDURE [dbo].[Rpt_GetChiropracticLetterForIMRResponseLetter]
	(
	@RFAReferralID int,
	@AttachedDocument varchar(MAX)
	)
AS
BEGIN
SELECT   RFARecordSplittings.RFARecDocumentName+' dated ' + convert(varchar(10), RFARecordSplittings.RFARecDocumentDate,101) +' by ' + RFARecordSplittings.AuthorName as Chiropractic
FROM         RFARecordSplittings INNER JOIN
                      lookup.IMRResponseLetterDocumentRelations ON 
                      lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 
WHERE     
--(RFARecordSplittings.RFAReferralID  in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@RFAReferralID)) 
--						or RFARecordSplittings.RFAReferralID = @RFAReferralID) AND 
						(RFARecordSplittings.DocumentTypeID in(6,7,8,29,30))
 AND 
                      (convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)) IN
                          (SELECT     splitdata
                            FROM          global.Get_SplitStringFormat(@AttachedDocument, ',')))
Order By RFARecordSplittings.RFARecDocumentDate desc
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetClaimAdministratorByClientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,GJain>
-- Create date: <Create Date,,04-16-2016>
-- Description:	<Description,,get CLient Administrator for specific Client>
-- =============================================
--[dbo].[Rpt_GetClaimAdministratorByClientID] 49
CREATE PROCEDURE [dbo].[Rpt_GetClaimAdministratorByClientID]
(
@ClientID int
)
AS
BEGIN
Declare @AdminType varchar(10),
		@AdminID int
SELECT     @AdminID=ClaimAdministratorID, @AdminType=ClaimAdministratorType
FROM         Clients
WHERE     (ClientID = @ClientID)

			if(@AdminType='emp')
			Begin
					SELECT     Employers.EmpName as Name, Employers.EmpAddress1 as [Address], Employers.EmpCity as City, lookup.States.StateName, Employers.EmpZip As Zip
					FROM         Employers INNER JOIN
										  lookup.States ON Employers.EmpStateID = lookup.States.StateId where Employers.EmployerID=@AdminID
			End
			else if(@AdminType='ins')
			Begin
					SELECT     Insurers.InsName as Name, Insurers.InsAddress1 as [Address], Insurers.InsCity as City, Insurers.InsZip as Zip, lookup.States.StateName
					FROM         Insurers INNER JOIN
										  lookup.States ON Insurers.InsStateID = lookup.States.StateId where Insurers.InsurerID=@AdminID
			End
			else if(@AdminType='tpa')
			Begin
						SELECT     ThirdPartyAdministrators.TPAName as Name, ThirdPartyAdministrators.TPAAddress as [Address], ThirdPartyAdministrators.TPACity as City, ThirdPartyAdministrators.TPAZip as Zip, 
									  lookup.States.StateName
				FROM         ThirdPartyAdministrators INNER JOIN
									  lookup.States ON ThirdPartyAdministrators.TPAStateID = lookup.States.StateId  where ThirdPartyAdministrators.TPAID=@AdminID
			End
			else if(@AdminType='mcc')
			Begin
						SELECT     ManagedCareCompanies.CompName as Name, ManagedCareCompanies.CompAddress as [Address], ManagedCareCompanies.CompCity as [City], ManagedCareCompanies.CompZip as Zip, 
								  lookup.States.StateName
			FROM         ManagedCareCompanies INNER JOIN
								  lookup.States ON ManagedCareCompanies.CompStateID = lookup.States.StateId  where ManagedCareCompanies.CompanyID=@AdminID
			End
			else if(@AdminType='insb')
			Begin
						SELECT     lookup.States.StateName, InsuranceBranches.InsBranchName as Name, InsuranceBranches.InsBranchAddress as [Address], InsuranceBranches.InsBranchCity as City, 
										  InsuranceBranches.InsBranchZip as Zip
					FROM         InsuranceBranches INNER JOIN
										  lookup.States ON InsuranceBranches.InsBranchStateID = lookup.States.StateId  where InsuranceBranches.InsuranceBranchID=@AdminID
			End
			else if(@AdminType='tpab')
			Begin
						SELECT     ThirdPartyAdministratorBranches.TPABranchName as Name, ThirdPartyAdministratorBranches.TPABranchAddress As [Address], ThirdPartyAdministratorBranches.TPABranchCity as City, 
									  ThirdPartyAdministratorBranches.TPABranchZip as Zip, lookup.States.StateName
				FROM         ThirdPartyAdministratorBranches INNER JOIN
									  lookup.States ON ThirdPartyAdministratorBranches.TPABranchStateID = lookup.States.StateId where ThirdPartyAdministratorBranches.TPABranchID=@AdminID
			End

END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetClientDetailsList]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ParamKaur>
-- Create date: <015-Sep-2017,>
-- Description:	<To get Client Id and Name>
-- =============================================
CREATE PROCEDURE [dbo].[Rpt_GetClientDetailsList] 
(@CurrentWorkloadReportID int)
AS
BEGIN
	--Select * from dbo.Clients
	if exists( Select cwr.ClientID from dbo.CurrentWorkloadReportParameters cwr 
		where CurrentWorkloadReportID = @CurrentWorkloadReportID and ClientID is not null)
	begin
		Select cwr.ClientID, (Select ClientName from dbo.Clients where ClientID = cwr.ClientID) as ClientName from dbo.CurrentWorkloadReportParameters cwr 
		where CurrentWorkloadReportID = @CurrentWorkloadReportID and ClientID is not null
	end
	else
	begin
		select '' as ClientID, '' as ClientName
	end
	 --delete from dbo.CurrentWorkloadReportParameters
END

GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetDeterminationLetteForIMRResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harpreet Singh
-- Create date: 29-03-2016
-- Description:	Get determination letter detail for IMR Response Letter

--Revision History: -
-- 1.1		TGosain 06-15-2016
--			@AttachedDocument pattern updated for uniqueness 
-- =============================================
-- [dbo].[Rpt_GetDeterminationLetteForIMRResponseLetter]385,'217-383D31,219-383D33,199-384D13,200-384D31,202-384D33,216-384D13,218-384D32,201-385D32'
CREATE PROCEDURE [dbo].[Rpt_GetDeterminationLetteForIMRResponseLetter]
	(
		@RFAReferralID int,
		@AttachedDocument varchar(MAX)
	)
AS
BEGIN

if ((SELECT     count(1)
	 FROM       RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      Clients ON PatientClaims.PatClientID = Clients.ClientID INNER JOIN
                      ClientPrivateLabels ON Clients.ClientID = ClientPrivateLabels.ClientID
                      where RFAReferrals.RFAReferralID = 385)< 1)
                      
begin
select 'Healthcare Resource Group Determination Letter dated '+ convert(varchar(10), RFARecDocumentDate,101)+' ( '+RFARequestedTreatment+' )' as DeterminationLetter from (

SELECT     RFARecordSplittings.RFARecDocumentDate, RFARecordSplittings.RFARecDocumentName, (RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) as RFARequestedTreatment
FROM         PatientClaims INNER JOIN
                      RFARecordSplittings ON PatientClaims.PatientClaimID = RFARecordSplittings.PatientClaimID INNER JOIN
                      lookup.IMRResponseLetterDocumentRelations ON 
                      lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 
                      INNER JOIN RFARequests ON RFARequests.RFAReferralID = RFARecordSplittings.RFAReferralID                      
WHERE                 (convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)
						+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)) 
					  IN (select splitdata from [global].[Get_SplitStringFormat](@AttachedDocument,','))) and RFARecordSplittings.DocumentTypeID in (13,31,32,33)
      
union

SELECT		  RFAReferralFiles.RFAFileCreationDate,RFAReferralFiles.RFAReferralFileName, (RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) as RFARequestedTreatment
FROM          RFAReferralFiles INNER JOIN
              RFARequests ON (RFARequests.RFAReferralID = RFAReferralFiles.RFAReferralID)                      
                       INNER JOIN
                      lookup.IMRResponseLetterDocumentRelations ON RFAReferralFiles.RFAFileTypeID = lookup.IMRResponseLetterDocumentRelations.DocumentTypeID
Where			 (convert(varchar(10),RFAReferralFiles.RFAReferralFileID,101)+'-'+ convert(varchar(10),RFAReferralFiles.RFAReferralID,101)
					+(lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFAReferralFiles.RFAFileTypeID)) 
					IN (select splitdata from [global].[Get_SplitStringFormat](@AttachedDocument,','))) and RFAReferralFiles.RFAFileTypeID = 5
					

                                            
) tbl
Order By RFARecDocumentDate desc

end
else
begin
select ClientPrivateLabelName +' Determination Letter dated '+ convert(varchar(10), RFARecDocumentDate,101)+' ( '+RFARequestedTreatment+' )' as DeterminationLetter from
(
	SELECT     ClientPrivateLabels.ClientPrivateLabelName, RFARecordSplittings.RFARecDocumentDate, RFARecordSplittings.RFARecDocumentName,(RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) as RFARequestedTreatment
FROM         PatientClaims INNER JOIN
                      RFARecordSplittings ON PatientClaims.PatientClaimID = RFARecordSplittings.PatientClaimID INNER JOIN
                      lookup.IMRResponseLetterDocumentRelations ON 
                      lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID INNER JOIN
                      RFARequests ON RFARequests.RFAReferralID = RFARecordSplittings.RFAReferralID
                      INNER JOIN
                      Clients ON PatientClaims.PatClientID = Clients.ClientID 
                      INNER JOIN
                      ClientPrivateLabels ON Clients.ClientID = ClientPrivateLabels.ClientID 
WHERE				(convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+convert(varchar(10),RFARecordSplittings.RFAReferralID,101)
						+(lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)) 
					IN (select splitdata from [global].[Get_SplitStringFormat](@AttachedDocument,','))) and RFARecordSplittings.DocumentTypeID in (13,31,32,33)
                      
union

SELECT    ClientPrivateLabels.ClientPrivateLabelName, RFAReferralFiles.RFAFileCreationDate,RFAReferralFiles.RFAReferralFileName, (RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) as RFARequestedTreatment
FROM         RFAReferralFiles INNER JOIN
              
                      RFARequests ON RFARequests.RFAReferralID = RFAReferralFiles.RFAReferralID  INNER JOIN
						RFAReferrals ON RFAReferrals.RFAReferralID  = RFARequests.RFAReferralID inner join                    
                      lookup.IMRResponseLetterDocumentRelations ON RFAReferralFiles.RFAFileTypeID = lookup.IMRResponseLetterDocumentRelations.DocumentTypeID INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID AND RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      Clients INNER JOIN
                      ClientPrivateLabels ON Clients.ClientID = ClientPrivateLabels.ClientID ON PatientClaims.PatClientID = Clients.ClientID AND PatientClaims.PatClientID = Clients.ClientID

Where			 (convert(varchar(10),RFAReferralFiles.RFAReferralFileID,101)+'-'+convert(varchar(10),RFAReferralFiles.RFAReferralID,101)
					+(lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFAReferralFiles.RFAFileTypeID)) 
				 IN (select splitdata from [global].[Get_SplitStringFormat](@AttachedDocument,','))) and RFAReferralFiles.RFAFileTypeID=5
)tbl Order By RFARecDocumentDate desc
end
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetDeterminationLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     :	Mahinder Singh
-- Create date: 15 FEB 2016
-- Description:	To get NOTIFICATION OF UTILIZATION REVIEW DECISION or DETERMINATION LETTER 
--			:	Using in RptDetermination
--			:	Using in RptIMRDecisionLetter

-- ===========================================================================
-- [dbo].[Rpt_GetDeterminationLetter]433 32
CREATE PROCEDURE [dbo].[Rpt_GetDeterminationLetter](@referralID INT)
AS
BEGIN
	
SELECT	CONVERT(VARCHAR(10),GETDATE(),101)as CurrentDate, rf.RFAReferralID,Patients.PatFirstName + ' ' + Patients.PatLastName AS [PatientName]	
	        ,CONVERT(VARCHAR(2),DATEDIFF(yy, Patients.PatDOB, getdate())) as PatDOBYEAR,Patients.PatGender,rf.EvaluationDate,rf.EvaluatedBy
			,(CASE 
				WHEN ClaimAdministratorType='emp' THEN (SELECT EmpName FROM Employers WHERE EmployerID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='ins' THEN (SELECT InsName FROM Insurers WHERE InsurerID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='insb' THEN (SELECT InsBranchName FROM InsuranceBranches WHERE InsuranceBranchID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='tpa' THEN (SELECT TPAName FROM ThirdPartyAdministrators WHERE TPAID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='mcc' THEN (SELECT CompName FROM ManagedCareCompanies WHERE CompanyID = ClaimAdministratorID) 
				END) AS [ClaimAdministrator]				
			, pc.PatClaimNumber AS [ClaimNumber]
			, AdjFirstName + ' ' + AdjLastName AS [Adjuster]
			, CONVERT(VARCHAR(10),pc.PatDOI,101) AS [DOI]
			, CONVERT(VARCHAR(10),rf.RFACEDate,101) AS[CEReceivedDate]
			,RFARequests.DecisionID 
			,(CASE 
					WHEN (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID and (DecisionID = 1 OR DecisionID = 12))
					= (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID) THEN 'Certified' 
				ELSE 
					(CASE WHEN (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID and DecisionID = 3) 
					 = (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID) THEN 'Denied' 
				ELSE 'Modified' END)END) AS [DecisionDesc]   				 			
			,RFARequests.RFARequestID 
			,CONVERT(VARCHAR(10),RFARequests.DecisionDate ,101) AS  DecisionDate
			,PhysFirstName
			,PhysLastName
			,PhysQualification
			,PhysAddress1
			,(SELECT StateName FROM mmc.lookup.States WHERE StateId = PhysStateID) AS [PhysStates]
			,PhysCity
			,PhysFax
			,PhysZip
			,AA.AttorneyName AS ApplicantAttorneyName
			,DA.AttorneyName AS DefenseAttorneyName
			,Adjusters.AdjPhone AS AdjusterPhoneNumber
			,CONVERT(VARCHAR(10),rf. RFAReferralDate,101)AS RFADate	
			,ISNULL(ADRs.ADRID,0) AS ADRID,ISNULL(ADRs.ADRName,'') AS ADRName
			,ISNULL(ADRs.ContactName,'') AS ADRContactName,ISNULL(ADRs.ContactPhone,'') AS ADRPhoneNumber
			
    FROM MMC.DBO.RFAReferrals rf		
			INNER JOIN PatientClaims pc ON rf.PatientClaimID = pc.PatientClaimID
			INNER JOIN Patients ON pc.PatientID = Patients.PatientID			
			INNER JOIN Physicians ON Physicians.PhysicianId = rf.PhysicianID
			INNER JOIN Clients ON pc.PatClientID = Clients.ClientID
			INNER JOIN  Adjusters ON pc.PatAdjusterID = AdjusterID 	
			LEFT JOIN  Attorneys AS AA ON pc.PatApplicantAttorneyID = AA.AttorneyID
			LEFT JOIN  Attorneys AS DA ON pc.PatDefenseAttorneyID = DA.AttorneyID
            INNER JOIN RFARequests ON rf.RFAReferralID = RFARequests.RFAReferralID 
            LEFT JOIN ADRs ON pc.PatADRID = ADRs.ADRID 
	WHERE rf.RFAReferralID = @referralID
	
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetDeterminationLetterforIMRResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,HaSingh>
-- Create date: <Create Date,,03-18-2016>
-- Description:	<Description,,get determination letter from Record Spliting and RFAReferral File where leter is modified and denied>
-- =============================================
-- [dbo].[Rpt_GetDeterminationLetterforIMRResponseLetter]550
CREATE PROCEDURE [dbo].[Rpt_GetDeterminationLetterforIMRResponseLetter]
	(@RFAReferralID int)
AS
BEGIN
select * from
	(SELECT  top 1  RFARequests.DecisionID , CONVERT(VARCHAR(10),RFAReferralFiles.RFAFileCreationDate,101) as RFAFileCreationDate , CONVERT(VARCHAR(10), RFAReferrals.RFAReferralDate,101)RFAReferralDate
	, (case when lookup.Decisions.DecisionID = 2 then 'Modification' else 'Denial' end) as DecisionDesc 
FROM         RFAReferralFiles INNER JOIN
                      lookup.FileTypes ON RFAReferralFiles.RFAFileTypeID = lookup.FileTypes.FileTypeID INNER JOIN
                      RFAReferrals ON RFAReferralFiles.RFAReferralID = RFAReferrals.RFAReferralID INNER JOIN
                      RFARequests ON (RFARequests.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@RFAReferralID)) 						
						or RFARequests.RFAReferralID = @RFAReferralID) INNER JOIN
                      lookup.Decisions ON RFARequests.DecisionID = lookup.Decisions.DecisionID AND RFARequests.DecisionID = lookup.Decisions.DecisionID
where (RFAReferrals.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@RFAReferralID)) 						
						or RFAReferrals.RFAReferralID = @RFAReferralID)  and RFARequests.DecisionID in(2,3) and FileTypes.FileTypeID = 5 

union

SELECT    RFARecordSplittings.DocumentTypeID as DecisionID, CONVERT(VARCHAR(10), RFARecordSplittings.RFARecDocumentDate ,101), CONVERT(VARCHAR(10), RFAReferrals.RFAReferralDate,101)RFAReferralDate
		 , (case when lookup.DocumentTypes.DocumentTypeID = 13 then '' else lookup.DocumentTypes.DocumentTypeDesc end) as DocumentTypeDesc  
                      
FROM         RFARecordSplittings INNER JOIN
                      lookup.DocumentTypes ON RFARecordSplittings.DocumentTypeID = lookup.DocumentTypes.DocumentTypeID INNER JOIN
                      RFAReferrals ON RFARecordSplittings.RFAReferralID = RFAReferrals.RFAReferralID

where (RFARecordSplittings.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@RFAReferralID)) 						
						or RFARecordSplittings.RFAReferralID = @RFAReferralID)  and RFARecordSplittings.DocumentTypeID in (13,31,32,33)
)tbl order by RFAFileCreationDate desc
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetDictatedLetterForIMRResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		HaSingh
-- Create date: 31/3/2016
-- Description:	Get Dictated Letter for IMR Response Letter Report

--Revision History: -
-- 1.1		TGosain 06-15-2016
--			@AttachedDocument pattern updated for uniqueness 
-- =============================================
-- [dbo].[Rpt_GetDictatedLetterForIMRResponseLetter]745,'235-745D13,179-542D10,167-542D24,168-542D25,169-542D26,170-542D27,185-542D28,173-542D6,174-542D7,204-547D6,175-542D23,177-542D19,178-542D20,205-547D19,206-531D8,171-542D29,172-542D30,176-542D8'
CREATE PROCEDURE [dbo].[Rpt_GetDictatedLetterForIMRResponseLetter]
	(
		@RFAReferralID int,
		@AttachedDocument varchar(Max)
	)
AS
BEGIN
SELECT   RFARecordSplittings.RFARecDocumentName+' dated ' + convert(varchar(10), RFARecordSplittings.RFARecDocumentDate,101) +' by ' + RFARecordSplittings.AuthorName as Dicated
FROM        RFARecordSplittings INNER JOIN
                      lookup.IMRResponseLetterDocumentRelations ON 
                      lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 

WHERE     
--(RFARecordSplittings.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@RFAReferralID)) 
--						or RFARecordSplittings.RFAReferralID = @RFAReferralID) AND 
						(RFARecordSplittings.DocumentTypeID IN (25,26,27,28)) AND 
                      (convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)) IN
                          (SELECT     splitdata FROM global.Get_SplitStringFormat(@AttachedDocument, ',') AS Get_SplitStringFormat_1))
Order By RFARecordSplittings.RFARecDocumentDate desc
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetDuplicateDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,MAHINDER SINGH>
-- Create date: <Create Date,,21-JUNE-2017>
-- Description:	<Description,, GET DUPLICATE DETAILS FOR REPORT>
-- =============================================\

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

--[dbo].[Rpt_GetDuplicateDetails]1232
CREATE PROCEDURE [dbo].[Rpt_GetDuplicateDetails]
	@referralID INT
AS
BEGIN
SELECT req.RFARequestID AS [RequestID], 
(req.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (req.RFARequestID)),'')) AS [Treatment]
		, ISNULL(req.RFAFrequency,0) AS [Frequency]
		, ISNULL(req.RFADuration,0) AS [Duration]	
		,req.RFAQuantity AS QTY
		,req.DecisionID
		, ISNULL(CASE WHEN (SELECT COUNT(*) from RFARequestModifies WHERE rfarequestid= req.rfarequestID) = 1 
			THEN ((SELECT DurationTypeName from mmc.lookup.DurationTypes WHERE DurationTypeID = reqm.RFADurationTypeID))
			ELSE ((SELECT DurationTypeName from mmc.lookup.DurationTypes WHERE DurationTypeID = req.RFADurationTypeID)) END,0) AS [DurationType]						
	  FROM [MMC].[dbo].[RFARequests] AS req
	    LEFT JOIN [RFARequestModifies] reqm ON  req.RFARequestID = reqm.RFARequestID
where req.DecisionID = 10 and req.RFAReferralID = @referralID  
END

GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetIMRAttachedResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Hasingh
-- Create date: 19-03-2016
-- Description:	Get the attached letter for IMR response letter

-- Revision History: 
-- 1.1		TGosain 06-21-2016
--			updated query for referralFiles table records also
-- =============================================
-- [dbo].[Rpt_GetIMRAttachedResponseLetter]'D24,D25,D26,D27,D28,D29,D30,D6,D7,D23,D8,D19,D20,D10,D13,D31,D32,D33,F5'
CREATE PROCEDURE [dbo].[Rpt_GetIMRAttachedResponseLetter]
(@DocumentTpes varchar(MAX))
AS
BEGIN
-- selecting records from [RFAReferralFiles]
SELECT distinct lookup.IMRResponseLetterCheckLists.IMRMedicalRecordSubmittedID, lookup.IMRResponseLetterCheckLists.IMRMedicalRecordSubmittedDesc , 'x' as CheckedDocument
		FROM         lookup.IMRResponseLetterCheckLists LEFT OUTER JOIN
							  lookup.IMRResponseLetterDocumentRelations ON 
							  lookup.IMRResponseLetterCheckLists.IMRMedicalRecordSubmittedID = lookup.IMRResponseLetterDocumentRelations.IMRMedicalRecordSubmittedID
							  left JOIN RFAReferralFiles 							  
							  ON lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFAReferralFiles.RFAFileTypeID 							  
		where Convert(varchar(10),RFAReferralFiles.RFAReferralFileID,101)+'-'+(convert(varchar(10),RFAReferralFiles.RFAReferralID,101) + lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFAReferralFiles .RFAFileTypeID)) 
			  In (SELECT splitdata FROM global.Get_SplitStringFormat(@DocumentTpes, ','))

union 
-- selecting records from [RFARecordSplittings]
SELECT distinct lookup.IMRResponseLetterCheckLists.IMRMedicalRecordSubmittedID, lookup.IMRResponseLetterCheckLists.IMRMedicalRecordSubmittedDesc , 'x' as CheckedDocument
		FROM         lookup.IMRResponseLetterCheckLists LEFT OUTER JOIN	
                      lookup.IMRResponseLetterDocumentRelations ON 
                      lookup.IMRResponseLetterCheckLists.IMRMedicalRecordSubmittedID = lookup.IMRResponseLetterDocumentRelations.IMRMedicalRecordSubmittedID
                      left JOIN RFARecordSplittings 
                      ON lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 
		where Convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)) 
			  In (SELECT splitdata FROM global.Get_SplitStringFormat(@DocumentTpes, ','))

union
-- query to show rows with blank [CheckedDocument] column in result for report.
Select  lookup.IMRResponseLetterCheckLists.IMRMedicalRecordSubmittedID, lookup.IMRResponseLetterCheckLists.IMRMedicalRecordSubmittedDesc  ,  '' as CheckedDocument
	From lookup.IMRResponseLetterCheckLists 
	where IMRMedicalRecordSubmittedID  not in (
								SELECT     IMRMedicalRecordSubmittedID  
								FROM         lookup.IMRResponseLetterDocumentRelations 
								left JOIN RFAReferralFiles 
									ON lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFAReferralFiles.RFAFileTypeID
								where Convert(varchar(10),RFAReferralFiles.RFAReferralFileID,101)+'-'+(convert(varchar(10),RFAReferralFiles.RFAReferralID,101)
									+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFAReferralFiles.RFAFileTypeID))  
									In (SELECT splitdata FROM global.Get_SplitStringFormat(@DocumentTpes, ',')))
		and IMRMedicalRecordSubmittedID  not in (
									SELECT     IMRMedicalRecordSubmittedID  
									FROM         lookup.IMRResponseLetterDocumentRelations 
									left JOIN RFARecordSplittings 
														  ON lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 
									where Convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID))  
									In (SELECT splitdata FROM global.Get_SplitStringFormat(@DocumentTpes, ',')))	
								
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetIMRDecisionLetterDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author     :	Tarun Gosain
-- Create date: 27 Jul 2016
-- Description:	To get Details for 
--			:	RptIMRDecisionLetter Details
-- ===========================================================================

CREATE PROCEDURE [dbo].[Rpt_GetIMRDecisionLetterDetails](@referralID INT)
AS
BEGIN
	SELECT distinct	CONVERT(VARCHAR(10),GETDATE(),101)as CurrentDate, rf.RFAReferralID,Patients.PatFirstName + ' ' + Patients.PatLastName AS [PatientName]	
			,CONVERT(VARCHAR(2),DATEDIFF(yy, Patients.PatDOB, getdate())) as PatDOBYEAR,Patients.PatGender,rf.EvaluationDate,rf.EvaluatedBy
			,(CASE 
				WHEN ClaimAdministratorType='emp' THEN (SELECT EmpName FROM Employers WHERE EmployerID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='ins' THEN (SELECT InsName FROM Insurers WHERE InsurerID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='insb' THEN (SELECT InsBranchName FROM InsuranceBranches WHERE InsuranceBranchID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='tpa' THEN (SELECT TPAName FROM ThirdPartyAdministrators WHERE TPAID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='mcc' THEN (SELECT CompName FROM ManagedCareCompanies WHERE CompanyID = ClaimAdministratorID) 
				END) AS [ClaimAdministrator]
			, pc.PatClaimNumber AS [ClaimNumber]
			, AdjFirstName + ' ' + AdjLastName AS [Adjuster]
			, CONVERT(VARCHAR(10),pc.PatDOI,101) AS [DOI]
			, CONVERT(VARCHAR(10),rf.RFACEDate,101) AS[CEReceivedDate]			
			,(CASE
					WHEN (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID and (DecisionID = 1 OR DecisionID = 12))
					= (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID) THEN 'Certified' 
				ELSE 
					(CASE WHEN (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID and DecisionID = 3) 
					 = (SELECT COUNT(*) FROM [MMC].[dbo].[RFARequests] AS req WHERE RFAReferralID=@referralID) THEN 'Denied' 
				ELSE 'Modified' END)END) AS [DecisionDesc]			
			,CONVERT(VARCHAR(10),RFARequests.DecisionDate ,101) AS  DecisionDate
			,PhysFirstName
			,PhysLastName
			,PhysQualification
			,PhysAddress1
			,(SELECT StateName FROM mmc.lookup.States WHERE StateId = PhysStateID) AS [PhysStates]
			,PhysCity
			,PhysFax
			,PhysZip
			,AA.AttorneyName AS ApplicantAttorneyName
			,DA.AttorneyName AS DefenseAttorneyName
			,Adjusters.AdjPhone AS AdjusterPhoneNumber
			,CONVERT(VARCHAR(10),rf. RFAReferralDate,101)AS RFADate	
			,ISNULL(ADRs.ADRID,0) AS ADRID,ISNULL(ADRs.ADRName,'') AS ADRName
			,ISNULL(ADRs.ContactName,'') AS ADRContactName,ISNULL(ADRs.ContactPhone,'') AS ADRPhoneNumber
			,(Select distinct  
				Substring(
					(
						Select ', ' + Convert(varchar(10), RFARequestID) AS [text()]
						From RFARequests
						Where RFAReferralID=@referralID
						ORDER BY RFARequestID
						For XML PATH ('')
					), 2, 1000) [requestid]
				From RFARequests) as RequestID
			,(Select distinct  
				Substring(
					(
						Select ', ' + (Case when(RFARequestModifies.RFARequestedTreatment IS null) then (RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) 
										else  RFARequestModifies.RFARequestedTreatment end) AS [text()]
						From RFARequests
						LEFT JOIN
						RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
						Where RFAReferralID=@referralID
						ORDER BY RFARequests.RFARequestID
						For XML PATH ('')
					), 2, 1000) [requestid]
				From RFARequests) as RequestedTreatment
				,rf.RFAIMRReferenceNumber
				, IMRRFAReferrals.IMRDecisionID
	FROM MMC.DBO.RFAReferrals rf		
			INNER JOIN PatientClaims pc ON rf.PatientClaimID = pc.PatientClaimID
			INNER JOIN Patients ON pc.PatientID = Patients.PatientID			
			INNER JOIN Physicians ON Physicians.PhysicianId = rf.PhysicianID
			INNER JOIN Clients ON pc.PatClientID = Clients.ClientID
			INNER JOIN  Adjusters ON pc.PatAdjusterID = AdjusterID 	
			LEFT JOIN  Attorneys AS AA ON pc.PatApplicantAttorneyID = AA.AttorneyID
			LEFT JOIN  Attorneys AS DA ON pc.PatDefenseAttorneyID = DA.AttorneyID
			INNER JOIN RFARequests ON rf.RFAReferralID = RFARequests.RFAReferralID 
			LEFT JOIN ADRs ON pc.PatADRID = ADRs.ADRID 
			Inner Join IMRRFAReferrals on rf.RFAReferralID = IMRRFAReferrals.RFAReferralID
	WHERE rf.RFAReferralID = @referralID
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetIMREmployeeDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rohit Kumar
-- Create date: 03-02-2016
-- Description:	To get request fot unable to review - No IMR Form.

-- Revision History:
-- Version 1.0
-- =============================================
-- [dbo].[Rpt_GetIMREmployeeDetails] 972
CREATE PROCEDURE [dbo].[Rpt_GetIMREmployeeDetails]
@RFAReferralID int
AS
BEGIN

	declare @ClaimAdministratorID as int 
	declare @ClaimAdministratorType as char(4) =null
	Declare @ClaimAdministratorName as varchar(50) = null
	
	
    SELECT  @ClaimAdministratorID =     ClaimAdministratorID, @ClaimAdministratorType=  ClaimAdministratorType FROM         Clients where ClientID = (SELECT      PatientClaims.PatClientID
										FROM         PatientClaims INNER JOIN
															  RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID where RFAReferrals.RFAReferralID = @RFAReferralID )

	if (lower(@ClaimAdministratorType)='ins')
		begin
			SELECT   @ClaimAdministratorName = InsName  FROM         Insurers where InsurerID = @ClaimAdministratorID
		end
	else if (lower(@ClaimAdministratorType)='insb')
		begin
			SELECT     @ClaimAdministratorName= InsBranchName FROM         InsuranceBranches where InsuranceBranchID = @ClaimAdministratorID
		end
	else if (lower(@ClaimAdministratorType)='emp')
		begin
			SELECT  @ClaimAdministratorName=   EmpName FROM         Employers	where EmployerID  = @ClaimAdministratorID
		end
	else if (lower(@ClaimAdministratorType)='tpa')
		begin
			SELECT   @ClaimAdministratorName =   TPAName FROM         ThirdPartyAdministrators where TPAID  = @ClaimAdministratorID
		end
	else if (lower(@ClaimAdministratorType)='tpab')
		begin
			SELECT   @ClaimAdministratorName =   TPABranchName FROM         ThirdPartyAdministratorBranches where TPABranchID = @ClaimAdministratorID
		end
		
		
	declare @IsRegular as bit = 0
	declare @IsExpedited as bit = 0	
	if ((SELECT     count(*)  FROM         RFARequests where RFAReferralID = @RFAReferralID and  RequestTypeID = 3)	=
	(SELECT     count(*)  FROM         RFARequests where RFAReferralID = @RFAReferralID))
	begin
		set @IsExpedited = 1
		set @IsRegular = 0
	end
	else
	begin
		set @IsExpedited = 0
		set @IsRegular = 1
	end
	
	
	
	
	




		SELECT     Patients.PatFirstName + ' ' + Patients.PatLastName AS EmployeeName, Patients.PatAddress1 AS EmployeeAddress, Patients.PatPhone AS EmployeePhone, 
							  PatientClaims.PatEDIExchangeTrackingNumber as  EmployeeWCISJurisdictionalClaimNumber,
							  Employers.EmpName AS EmployerName, Attorneys.AttorneyName AS EmployeeAttorneyName, AttorneyFirms.AttAddress1 AS EmployeeAttorneyAddress, 
							  PatientClaims.PatAdjudicationStateCaseNumber as EmployeeEAMSCaseNumber,
							  PatientClaims.PatClaimNumber as EmployeeClaim, convert(varchar(10),PatientClaims.PatDOI,101) as EmployeeDOI,
							  AttorneyFirms.AttPhone AS EmployeeAttorneyPhone, AttorneyFirms.AttFax AS EmployeeAttorneyFax, 
							  Physicians.PhysFirstName + ' ' + Physicians.PhysLastName AS PracticeName, lookup.Specialties.SpecialtyName AS PracticeSpecialty, 
							  Physicians.PhysAddress1 AS PracticeAddress, Physicians.PhysPhone AS PracticePhone, Physicians.PhysFax AS PracticeFax, 
							  @ClaimAdministratorName as ClaimAdministratorName,
							  Adjusters.AdjFirstName + ' ' + Adjusters.AdjLastName AS AdjusterName, Adjusters.AdjAddress1 AS AdjusterAddress, Adjusters.AdjPhone AS AdjusterPhone, 
							  Adjusters.AdjFax AS AdjusterFax, RFAReferrals.RFAReferralID , (select dbo.CommaSeperateDiagnosisByRFAReferralID (@RFAReferralID)) as PrimaryDiagnosis ,
							  convert(varchar(10),(SELECT      isnull(RFAFileCreationDate,getdate()) FROM         RFAReferralFiles  where RFAReferralID = @RFAReferralID and  RFAFileTypeID = 5),101) as DeterminationLetterDate,
							  (SELECT     top 1 (convert(varchar(10),DecisionDate,101)) FROM         RFARequests where RFAReferralID = @RFAReferralID and isnull(DecisionDate,'') <> '') as DecisionDateFinal,
							  isnull(@IsRegular,0) as IsRegular  ,isnull(@IsExpedited,0) as IsExpedited  ,isnull(InternalAppeal,0)  as InternalAppeal
							  
							  
		FROM         Physicians INNER JOIN
                      RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      Patients ON PatientClaims.PatientID = Patients.PatientID INNER JOIN
                      Employers ON PatientClaims.PatEmployerID = Employers.EmployerID ON Physicians.PhysicianId = RFAReferrals.PhysicianID AND 
                      Physicians.PhysicianId = RFAReferrals.PhysicianID INNER JOIN
                      lookup.Specialties ON Physicians.PhysSpecialtyId = lookup.Specialties.SpecialtyID INNER JOIN
                      Adjusters ON PatientClaims.PatAdjusterID = Adjusters.AdjusterID AND PatientClaims.PatAdjusterID = Adjusters.AdjusterID AND 
                      PatientClaims.PatAdjusterID = Adjusters.AdjusterID LEFT OUTER JOIN
                      AttorneyFirms INNER JOIN
                      Attorneys ON AttorneyFirms.AttorneyFirmID = Attorneys.AttorneyFirmID AND AttorneyFirms.AttorneyFirmID = Attorneys.AttorneyFirmID ON 
                      PatientClaims.PatApplicantAttorneyID = Attorneys.AttorneyID
		WHERE     (RFAReferrals.RFAReferralID = @RFAReferralID)
		                      
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetIMREmployeeRequestDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rohit Kumar
-- Create date: 03-02-2016
-- Description:	To get request fot unable to review - No IMR Form.

-- Revision History:
-- Version 1.0
-- =============================================
-- [dbo].[Rpt_GetIMREmployeeRequestDetails] 1232
CREATE PROCEDURE [dbo].[Rpt_GetIMREmployeeRequestDetails]
@RFAReferralID int
AS
BEGIN
		--SELECT   (convert(varchar(10),(ROW_NUMBER() Over(Order by RFARequestID )))  + '.  ' + RFARequestedTreatment) as  RequestName 		FROM         RFARequests where RFAReferralID = @RFAReferralID order by RFARequestID 


	    SELECT   (convert(varchar(10),(ROW_NUMBER() Over(Order by RFARequests.RFARequestID )))  + '.  ' + ( case when RFARequests.DecisionID <> 2 then  (RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),''))  else  RFARequestModifies.RFARequestedTreatment end)) as  RequestName
		FROM         RFARequests LEFT OUTER JOIN
                      RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID
                       where RFAReferralID = @RFAReferralID order by RFARequests.RFARequestID 		
		
		
		                      
END





GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetIMRInitialNotificationLetterDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tarun Gosain
-- Create date: 07-30-2016
-- Description:	To get initial notification letter patient section details. 
--				: Using in IMRInitial Report.

-- Revision History:
-- 1.0 -	TGosain
--			Initial version.
-- =============================================
-- [dbo].[Rpt_GetIMRInitialNotificationLetterDetails]1232
CREATE PROCEDURE [dbo].[Rpt_GetIMRInitialNotificationLetterDetails](@referralID int)
AS
BEGIN
	SET NOCOUNT ON;
				Select	Convert(varchar(10),getdate(),101)as CurrentDate, rf.RFAReferralID,Patients.PatFirstName + ' ' + Patients.PatLastName as [PatientName]			
			,(case 
				when ClaimAdministratorType='emp' then (select EmpName from Employers where EmployerID = ClaimAdministratorID) 
				when ClaimAdministratorType='ins' then (select InsName from Insurers where InsurerID = ClaimAdministratorID) 
				when ClaimAdministratorType='insb' then (select InsBranchName from InsuranceBranches where InsuranceBranchID = ClaimAdministratorID) 
				when ClaimAdministratorType='tpa' then (select TPAName from ThirdPartyAdministrators where TPAID = ClaimAdministratorID) 
				when ClaimAdministratorType='mcc' then (select CompName from ManagedCareCompanies where CompanyID = ClaimAdministratorID) 
				end) as [ClaimAdministrator]				
			, pc.PatClaimNumber as [ClaimNumber]
			, AdjFirstName + ' ' + AdjLastName as [Adjuster]
			, Convert(varchar(10),pc.PatDOI,101) as [DOI]
			, Convert(varchar(10),rf.RFACEDate,101) as[CEReceivedDate]
			, (case 
					when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and (DecisionID = 1 or DecisionID = 12))
					 = (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'Certified' 
					when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID = 10) 
					 = (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'Duplicate'
					when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID = 8) 
					 = (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'Unable To Review'
				else 
					(case when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID = 3) 
					 = (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID) then 'Denied' 
			    
				else 
				(case when (select COUNT(*) FROM [MMC].[dbo].[RFARequests] as req where RFAReferralID=@referralID and DecisionID = 9) > 0
					 then 'Deferred'  
				 else 'Modified' end)end)end) as [Decision]
			, CONVERT(VARCHAR(10),(select top 1 DecisionDate from RFARequests where RFARequests.RFAReferralID=@referralID) ,101)  as URDecisionDate
			,PhysFirstName
			,PhysLastName
			,PhysQualification
			,PhysAddress1
			,(select StateName from mmc.lookup.States where StateId = PhysStateID) as [PhysStates]
			,PhysCity
			,PhysFax
			,PhysZip
			,AA.AttorneyName as ApplicantAttorneyName
			,DA.AttorneyName as DefenseAttorneyName
			,Adjusters.AdjPhone as AdjusterPhoneNumber
			,Convert(varchar(10),rf. RFAReferralDate,101)as RFADate
			,pc.PatADRID
			,ADRs.ADRName	
			,(Select distinct  
				Substring(
					(
						Select ', ' + Convert(varchar(10), RFARequestID) AS [text()]
						From RFARequests
						Where RFAReferralID=@referralID
						ORDER BY RFARequestID
						For XML PATH ('')
					), 2, 1000) [requestid]
				From RFARequests) as RequestID
			,(Select distinct  
				Substring(
					(
						Select ', ' + (Case when(RFARequestModifies.RFARequestedTreatment IS null) then (RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) 
										else  RFARequestModifies.RFARequestedTreatment end) AS [text()]
						From RFARequests
						LEFT JOIN
						RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
						Where RFAReferralID=@referralID
						ORDER BY RFARequests.RFARequestID
						For XML PATH ('')
					), 2, 1000) [requestid]
				From RFARequests) as RequestedTreatment	
			, IMRRFAReferrals.IMRDecisionID	
		from mmc.dbo.RFAReferrals rf		
			inner join PatientClaims pc on rf.PatientClaimID = pc.PatientClaimID
			inner join Patients on pc.PatientID = Patients.PatientID			
			inner join Physicians on Physicians.PhysicianId = rf.PhysicianID
			inner join Clients on pc.PatClientID = Clients.ClientID
			inner join  Adjusters on pc.PatAdjusterID = AdjusterID 	
			Left JOIN  Attorneys as AA ON pc.PatApplicantAttorneyID = AA.AttorneyID
			Left JOIN  Attorneys as DA ON pc.PatDefenseAttorneyID = DA.AttorneyID
            Left Join ADRs on pc.PatADRID = ADRs.ADRID         	
            Inner Join IMRRFAReferrals on rf.RFAReferralID = IMRRFAReferrals.RFAReferralID
		where rf.RFAReferralID = @referralID

END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetIMRRequestWithApprovedUnits]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: TGosain
-- Create date: 07/20/2016
-- Description: GET approved request details.
-- Version: 1.0

-- History:
-- <Version>		<Author Name>:	<Date>
--			<Description>
-- ================================================================ 

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

CREATE PROCEDURE [dbo].[Rpt_GetIMRRequestWithApprovedUnits]
	@RFAReferralID int
AS
Begin
	Select IMRRFARequests.RFARequestID, IMRRFARequests.IMRApprovedUnits
	, isnull(RFARequestModifies.RFARequestedTreatment, (RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) ) as RFARequestedTreatment
	From IMRRFARequests
	Inner Join RFARequests on IMRRFARequests.RFARequestID = RFARequests.RFARequestID
	LEFT JOIN RFARequestModifies ON RFARequests.RFARequestID = RFARequestModifies.RFARequestID 
	where RFARequests.RFAReferralID = @RFAReferralID and IMRApprovedUnits is not null
END

GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetIMRRequestWithDeniedUnits]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: TGosain
-- Create date: 07/20/2016
-- Description: GET approved request details.
-- Version: 1.0

-- History:
-- <Version>		<Author Name>:	<Date>
--			<Description>
-- ================================================================ 
--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 
-- [dbo].[Rpt_GetIMRRequestWithDeniedUnits] 1232
CREATE PROCEDURE [dbo].[Rpt_GetIMRRequestWithDeniedUnits]
	@RFAReferralID int
AS
Begin

SELECT	req.RFARequestID
		, isnull(reqm.RFARequestedTreatment,(req.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (req.RFARequestID)),'')) )as RFARequestedTreatment
		, case when DecisionID = 2 then 
			(case 
				when ((isnull(req.RFAFrequency,1) * isnull(req.RFADuration,1)) - (isnull(reqm.RFAFrequency,0) *  isnull(reqm.RFADuration,0))) = 0 then 1 
			 else 
				(isnull(req.RFAFrequency,1) * isnull(req.RFADuration,1)) - (isnull(reqm.RFAFrequency,0) *  isnull(reqm.RFADuration,0)) end)
		else
		req.RFAQuantity
		END
		- isnull(imrreq.IMRApprovedUnits,0) as RFAQuantity
		
	FROM [MMC].[dbo].[RFARequests] as req
		Inner Join [IMRRFARequests] imrreq on imrreq.RFARequestID = req.RFARequestID
		left join [RFARequestModifies] reqm on  req.RFARequestID = reqm.RFARequestID	    
	where req.RFAReferralID = @RFAReferralID and DecisionID != 1 
 
Union all  
 
SELECT req.RFARequestID as [RequestID]
	, isnull(reqm.RFARequestedTreatment,(req.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (req.RFARequestID)),'')) )as RFARequestedTreatment
	, req.RFAQuantity - isnull(imrreq.IMRApprovedUnits,0) as RFAQuantity

FROM [MMC].[dbo].[RFARequests] as req
	Inner join (Select OriginalRFARequestID from RFARequestAdditionalInfoes 						
							Inner join  RFARequests on RFARequestAdditionalInfoes.RFARequestID = RFARequests.RFARequestID
								where RFARequests.DecisionID=10 and RFAReferralID=@RFAReferralID) tb1
								on req.RFARequestID = tb1.OriginalRFARequestID
	Inner Join [IMRRFARequests] imrreq on imrreq.RFARequestID = req.RFARequestID
	left join [RFARequestModifies] reqm on  req.RFARequestID = reqm.RFARequestID	    
END

GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetInvoiceStatementByClientStatementID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<GJain>
-- Create date: <04-16-2016>
-- Description:	<Get Invoice Detail for a client for particular statement>

-- Revision History:
-- 1.1 -	TGosain
--			01 June 2016
-- Description: Adding Deferral value to the billing total.
-- =============================================
-- [dbo].[Rpt_GetInvoiceStatementByClientStatementID]14
CREATE PROCEDURE [dbo].[Rpt_GetInvoiceStatementByClientStatementID]
@ClientStatementID int

AS
BEGIN


Select InvoiceNumber,PatClaimNumber,Claimant,Adjuster,ClientStatementNumber,ClientStatementID,CreationDate,SUM(BillingTotal) as SumUpBillingTotal,SUM(WholeBillingTotal) as SumUpWholeBillingTotal,
ClientPrivateLabelName, ClientPrivateLabelAddress,
                      ClientPrivateLabelCity, StateName, ClientPrivateLabelZip, ClientPrivateLabelTax
 from (
SELECT     ClientStatements.ClientStatementID, ClientStatements.ClientStatementNumber, ClientStatements.CreationDate, link.RFAReferralAdditionalLinks.RFAReferralID, 
                      RFAReferralInvoices.RFAReferralInvoiceID, RFAReferralInvoices.InvoiceNumber, Patients.PatFirstName + ' ' + Patients.PatLastName AS Claimant, 
                      Adjusters.AdjFirstName + ' ' + Adjusters.AdjLastName AS Adjuster, 
                      ISNULL(ROUND(((RFARequestBillings.RFARequestBillingRN * ClientBillingRetailRates.ClientBillingRetailRateRN + RFARequestBillings.RFARequestBillingMD * ClientBillingRetailRates.ClientBillingRetailRateMD)
                       + RFARequestBillings.RFARequestBillingAdmin * ClientBillingRetailRates.ClientBillingRetailRateAdminFee) 
                      + RFARequestBillings.RFARequestBillingSpeciality * ClientBillingRetailRates.ClientBillingRetailRateSpecialityReview
                      + RFARequestBillings.RFARequestBillingDeferral * ClientBillingRetailRates.ClientBillingRetailRateDeferral, 2), 0) AS BillingTotal, 
                      ISNULL(ROUND(((RFARequestBillings.RFARequestBillingRN * ClientBillingWholesaleRates.ClientBillingWholesaleRateRN + RFARequestBillings.RFARequestBillingMD
                       * ClientBillingWholesaleRates.ClientBillingWholesaleRateMD) 
                      + RFARequestBillings.RFARequestBillingAdmin * ClientBillingWholesaleRates.ClientBillingWholesaleRateAdminFee) 
                      + RFARequestBillings.RFARequestBillingSpeciality * ClientBillingWholesaleRates.ClientBillingWholesaleRateSpecialityReview
                      + RFARequestBillings.RFARequestBillingDeferral * ClientBillingWholesaleRates.ClientBillingWholesaleRateDeferral, 2), 0) AS WholeBillingTotal, 
                      PatientClaims.PatClaimNumber, ClientPrivateLabels.ClientPrivateLabelName, ClientPrivateLabels.ClientPrivateLabelAddress, 
                      ClientPrivateLabels.ClientPrivateLabelCity, lookup.States.StateName, ClientPrivateLabels.ClientPrivateLabelZip, ClientPrivateLabels.ClientPrivateLabelTax
FROM         ClientPrivateLabels INNER JOIN
                      ClientPrivateLabels AS ClientPrivateLabels_1 ON ClientPrivateLabels.ClientPrivateLabelID = ClientPrivateLabels_1.ClientPrivateLabelID INNER JOIN
                      ClientBillingRetailRates INNER JOIN
                      ClientBillings ON ClientBillingRetailRates.ClientBillingID = ClientBillings.ClientBillingID INNER JOIN
                      ClientBillingWholesaleRates ON ClientBillings.ClientBillingID = ClientBillingWholesaleRates.ClientBillingID INNER JOIN
                      RFARequests INNER JOIN
                      RFARequestBillings ON RFARequests.RFARequestID = RFARequestBillings.RFARequestID AND 
                      RFARequests.RFARequestID = RFARequestBillings.RFARequestID INNER JOIN
                      ClientStatements INNER JOIN
                      link.RFAReferralAdditionalLinks ON ClientStatements.ClientStatementID = link.RFAReferralAdditionalLinks.ClientStatementID INNER JOIN
                      RFAReferralInvoices ON link.RFAReferralAdditionalLinks.RFAReferralInvoiceID = RFAReferralInvoices.RFAReferralInvoiceID INNER JOIN
                      PatientClaims ON RFAReferralInvoices.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      Patients ON PatientClaims.PatientID = Patients.PatientID AND PatientClaims.PatientID = Patients.PatientID INNER JOIN
                      Adjusters ON PatientClaims.PatAdjusterID = Adjusters.AdjusterID AND PatientClaims.PatAdjusterID = Adjusters.AdjusterID ON 
                      RFARequests.RFAReferralID = link.RFAReferralAdditionalLinks.RFAReferralID ON ClientBillings.ClientID = ClientStatements.ClientID ON 
                      ClientPrivateLabels.ClientID = ClientStatements.ClientID INNER JOIN
                      lookup.States ON ClientPrivateLabels.ClientPrivateLabelStateID = lookup.States.StateId AND 
                      ClientPrivateLabels.ClientPrivateLabelStateID = lookup.States.StateId
WHERE     (ClientStatements.ClientStatementID = @ClientStatementID)) as Stmnt group by InvoiceNumber,ClientStatementID,PatClaimNumber,Claimant,Adjuster,ClientStatementNumber,CreationDate,ClientPrivateLabelName, ClientPrivateLabelAddress, 
                      ClientPrivateLabelCity, StateName, ClientPrivateLabelZip, ClientPrivateLabelTax

END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetMedicalRecordsReviewsForTimeExtention]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<RSingh>
-- Create date: <14 APR 2016>
-- Description:	<Get_GetMedicalRecordsReviews For TimeExtention Report>
-- =============================================
-- [dbo].[Rpt_GetMedicalRecordsReviewsForTimeExtention]553
CREATE PROCEDURE [dbo].[Rpt_GetMedicalRecordsReviewsForTimeExtention]
	@referralID INT
AS
BEGIN

SELECT   distinct  RFARequestTimeExtensions.RFARecSpltID,RFARecordSplittings.RFARecDocumentName,
                      RFARequestTimeExtensions.RFAReferralID, RFARequestTimeExtensions.RFIRecords, RFARequestTimeExtensions.AdditionalExamination, 
                      RFARequestTimeExtensions.SpecialtyConsult
FROM         RFARequestTimeExtensions INNER JOIN
                      RFARecordSplittings ON RFARequestTimeExtensions.RFARecSpltID = RFARecordSplittings.RFARecSpltID
                       where RFARequestTimeExtensions.RFAReferralID= @referralID
 

END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetMRILetterForIMRResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		HaSingh
-- Create date: 31/3/2016
-- Description:	Get QME/AME Letter for IMR Response Letter Report

--Revision History: -
-- 1.1		TGosain 06-15-2016
--			@AttachedDocument pattern updated for uniqueness 
-- =============================================
-- [dbo].[Rpt_GetMRILetterForIMRResponseLetter]745,'235-745D13,179-542D10,167-542D24,168-542D25,169-542D26,170-542D27,185-542D28,173-542D6,174-542D7,204-547D6,175-542D23,177-542D19,178-542D20,205-547D19,206-531D8,171-542D29,172-542D30,176-542D8'
CREATE PROCEDURE [dbo].[Rpt_GetMRILetterForIMRResponseLetter]
	(
	@RFAReferralID int,
	@AttachedDocument varchar(MAX)
	)
AS
BEGIN
SELECT  RFARecordSplittings.RFARecDocumentName+' dated ' + convert(varchar(10), RFARecordSplittings.RFARecDocumentDate,101) +' by ' + RFARecordSplittings.AuthorName as MRI
FROM         RFARecordSplittings INNER JOIN
                      lookup.IMRResponseLetterDocumentRelations ON 
                      lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 

WHERE     
--(RFARecordSplittings.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@RFAReferralID)) 
--						or RFARecordSplittings.RFAReferralID = @RFAReferralID) AND 
(RFARecordSplittings.DocumentTypeID in (6,7))
 AND (convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)) IN
                          (SELECT     splitdata
                            FROM          global.Get_SplitStringFormat(@AttachedDocument, ',')))
AND  RFARecordSplittings.RFARecDocumentName = 'MRI'
Order By RFARecordSplittings.RFARecDocumentName desc

END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetNotesByPatientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Harpreet Singhh>
-- Create date: <Create Date,,06-02-2016>
-- Description:	<Description,,get notes on patient page Report by patient id>
-- =============================================

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

-- [dbo].[Rpt_GetNotesByPatientID] 32
CREATE PROCEDURE [dbo].[Rpt_GetNotesByPatientID]
@PatientID int

AS
BEGIN

	SELECT   ROW_NUMBER() Over(Order by Notes.NoteID) as Row_ID ,Notes.NoteID, Notes.Notes, Notes.UserID, Notes.PatientClaimID, Notes.RFARequestID,
		 CONVERT(varchar(10), Notes.Date, 110) AS NotesDate, CONVERT(varchar(20), 
						  CAST(Notes.Date AS TIME), 100) AS NotesTime, (RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) as RFARequestedTreatment,
						  
						   Users.UserFirstName + ' ' + Users.UserLastName AS Users, 
						  PatientClaims.PatClaimNumber
	FROM         Notes INNER JOIN
						  PatientClaims ON Notes.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
						   Users ON Notes.UserID = Users.UserId LEFT JOIN
						  RFARequests ON Notes.RFARequestID = RFARequests.RFARequestID 
						 
	WHERE     (PatientClaims.PatientID = @PatientID) order by NoteID desc

END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetOperativeLetterForIMRResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		HaSingh
-- Create date: 31/3/2016
-- Description:	Get PR2 Letter for IMR Response Letter Report

--Revision History: -
-- 1.1		TGosain 06-15-2016
--			@AttachedDocument pattern updated for uniqueness 
-- =============================================
-- [dbo].[Rpt_GetOperativeLetterForIMRResponseLetter]542,'235-745D13,179-542D10,167-542D24,168-542D25,169-542D26,170-542D27,185-542D28,173-542D6,174-542D7,204-547D6,175-542D23,177-542D19,178-542D20,205-547D19,206-531D8,171-542D29,172-542D30,176-542D8'
CREATE PROCEDURE [dbo].[Rpt_GetOperativeLetterForIMRResponseLetter]
	(
	@RFAReferralID int,
	@AttachedDocument varchar(MAX)
	)
AS
BEGIN
SELECT  RFARecordSplittings.RFARecDocumentName+' dated ' + convert(varchar(10), RFARecordSplittings.RFARecDocumentDate,101) +' by ' + RFARecordSplittings.AuthorName as Operative
FROM         RFARecordSplittings INNER JOIN
                      lookup.IMRResponseLetterDocumentRelations ON 
                      lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 

WHERE     
--(RFARecordSplittings.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@RFAReferralID)) 
--						or RFARecordSplittings.RFAReferralID = @RFAReferralID) AND 
(RFARecordSplittings.DocumentTypeID = 23) AND 
                      (convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)) IN
                          (SELECT     splitdata
                            FROM          global.Get_SplitStringFormat(@AttachedDocument, ',') AS Get_SplitStringFormat_1))
Order By RFARecordSplittings.RFARecDocumentName desc
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetPR2LetterForIMRResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		HaSingh
-- Create date: 31/3/2016
-- Description:	Get PR2 Letter for IMR Response Letter Report

--Revision History: -
-- 1.1		TGosain 06-15-2016
--			@AttachedDocument pattern updated for uniqueness 
-- =============================================
-- [dbo].[Rpt_GetPR2LetterForIMRResponseLetter]542,'D13,D31,D32,D33,F5,D10,D25,D26,D27,D24'
CREATE PROCEDURE [dbo].[Rpt_GetPR2LetterForIMRResponseLetter]
	(
	@RFAReferralID int,
	@AttachedDocument varchar(MAX)
	)
AS
BEGIN
SELECT  RFARecordSplittings.RFARecDocumentName+' dated ' + convert(varchar(10), RFARecordSplittings.RFARecDocumentDate,101) +' by ' + RFARecordSplittings.AuthorName as [PR2]
FROM         RFARecordSplittings INNER JOIN
                      lookup.IMRResponseLetterDocumentRelations ON 
                      lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 

WHERE     (RFARecordSplittings.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@RFAReferralID)) 
						or RFARecordSplittings.RFAReferralID = @RFAReferralID) AND (RFARecordSplittings.DocumentTypeID = 24) AND 
                      (convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)) IN
                          (SELECT     splitdata
                            FROM          global.Get_SplitStringFormat(@AttachedDocument, ',') AS Get_SplitStringFormat_1))
Order By RFARecordSplittings.RFARecDocumentName desc
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetProofOfServiceDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		TGosain
-- Create date: 01-28-2016
-- Description:	Get data for proof of service report.

-- History: -
-- 03-08-2016: [Name]
-- 1.1: [Description]
-- =============================================


--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

--[dbo].[Rpt_GetProofOfServiceDetails] 1232
CREATE PROCEDURE [dbo].[Rpt_GetProofOfServiceDetails](@referralID int)
AS
BEGIN	
	SET NOCOUNT ON;
		DECLARE @requestTreatmentNames VARCHAR(MAX)
		Select @requestTreatmentNames = COALESCE(@requestTreatmentNames + ', ', '') + isnull(reqm.RFARequestedTreatment,(req.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (req.RFARequestID)),'')) ) 
		From RFARequests req
		left join [RFARequestModifies] reqm on  req.RFARequestID = reqm.RFARequestID 
		where RFAReferralID =@referralID


    	select  (select @requestTreatmentNames) as RequestTreatmentNames,p.PatFirstName + ' ' + p.PatLastName as PatientName 
				, pc.PatClaimNumber, RFAHCRGDate, PatAddress1 +', '+ PatCity+', '+ (select StateName from lookup.States where stateid = PatStateID) + ', '+ PatZip as PatientAddress
				, ph.PhysFirstName + ' ' + ph.PhysLastName as PhysicianName
				, ph.PhysAddress1 + ', ' + ph.PhysCity + ', ' + (select StateName from lookup.States where stateid = ph.PhysStateID) + ', ' + ph.PhysZip as PhysicianAddress
		, (select  AttorneyName from Attorneys where AttorneyID = pc.PatApplicantAttorneyID) as ApplicantAttorneyName	
	, (select atf.AttAddress1+', '+ atf.AttCity +', '+ (select StateName from lookup.States where stateid = atf.AttStateID) +', ' + atf.AttZip from Attorneys at
			inner join AttorneyFirms atf on at.AttorneyFirmID = atf.AttorneyFirmID where  at.AttorneyID = pc.PatApplicantAttorneyID) as ApplicantAttorneyAddress
	, isnull((select AttorneyName from Attorneys where AttorneyID = pc.PatDefenseAttorneyID),'') as DefenseAttorneyName
	, (select atf.AttAddress1+', '+ atf.AttCity +', '+ (select StateName from lookup.States where stateid = atf.AttStateID) +', ' + atf.AttZip from Attorneys at
			inner join AttorneyFirms atf on at.AttorneyFirmID = atf.AttorneyFirmID where  at.AttorneyID = pc.PatDefenseAttorneyID) as DefenseAttorneyAddress
			, ADRs.ContactName, ADRs.ADRAddress+', '+ ADRs.ADRCity+', '+(select StateName from lookup.States where stateid = ADRs.ADRStateID) +', ' + ADRs.ADRZip as ADRAddress,cpl.ClientPrivateLabelName
		from RFAReferrals rf 
		inner join PatientClaims pc on rf.PatientClaimID = pc.PatientClaimID
		inner join Patients p on pc.PatientID = p.PatientID
		left join Physicians ph on ph.PhysicianID = pc.PatPhysicianID
		left join ADRs on pc.PatADRID = adrs.ADRID INNER JOIN
                      Clients ON pc.PatClientID = Clients.ClientID left join
                       ClientPrivateLabels cpl on Clients.ClientID=cpl.ClientID
		where rf.RFAReferralID = @referralID
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetQME/AMELetterForIMRResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		HaSingh
-- Create date: 31/3/2016
-- Description:	Get QME/AME Letter for IMR Response Letter Report

--Revision History: -
-- 1.1		TGosain 06-15-2016
--			@AttachedDocument pattern updated for uniqueness 
-- =============================================
-- [dbo].[Rpt_GetOperativeLetterForIMRResponseLetter]550,'D13,D31,D32,D33,F5,D10,D25,D26,D27,D24,D23,D19,D20'
CREATE PROCEDURE [dbo].[Rpt_GetQME/AMELetterForIMRResponseLetter]
	(
	@RFAReferralID int,
	@AttachedDocument varchar(MAX)
	)
AS
BEGIN
SELECT  RFARecordSplittings.RFARecDocumentName+' dated ' + convert(varchar(10), RFARecordSplittings.RFARecDocumentDate,101) +' by ' + RFARecordSplittings.AuthorName as QMEAME
FROM         RFARecordSplittings INNER JOIN
                      lookup.IMRResponseLetterDocumentRelations ON 
                      lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 

WHERE     
--(RFARecordSplittings.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@RFAReferralID)) 
--						or RFARecordSplittings.RFAReferralID = @RFAReferralID) AND 
						(RFARecordSplittings.DocumentTypeID in(19,20)) AND 
                      (convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)) IN
                          (SELECT     splitdata
                            FROM          global.Get_SplitStringFormat(@AttachedDocument, ',') AS Get_SplitStringFormat_1))
Order By RFARecordSplittings.RFARecDocumentName desc
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetRequestDueDateByRefferalID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<RSingh>
-- Create date: <14 APR 2016>
-- Description:	<Get RequestDueDateBy RefferalID for Time Extension Letter>

-- =============================================
--Rpt_GetRequestDueDateByRefferalID 487
CREATE PROCEDURE [dbo].[Rpt_GetRequestDueDateByRefferalID]
	@referralID INT
AS
BEGIN
 SELECT  top 1  RFARequests.RFALatestDueDate
FROM         RFARequests INNER JOIN
                      RFARequestTimeExtensions ON RFARequests.RFARequestID = RFARequestTimeExtensions.RFARequestID where RFARequests.RFAReferralID=@referralID
 
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetRequestsNameForLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Author,,Harpreet Singhh
-- Create date: 18-01-2016
-- Description:	To get requests for RFI letter by referral Id, Also being using for Proof of service report.

-- Revision History:
-- Version 1.0
-- =============================================
--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 
-- [dbo].[Rpt_GetRequestsNameForLetter]1232
CREATE PROCEDURE [dbo].[Rpt_GetRequestsNameForLetter]
@ReferralID int
AS
BEGIN
SELECT   (RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),''))  AS Requests
FROM         RFARequests
Where   RFAReferralID = @ReferralID and RFARequestedTreatment is not null
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetRequestsNameForNoRFAForm]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Author,,Harpreet Singhh
-- Create date: 29-01-2016
-- Description:	To get request fot unable to review - No RFA Form.

-- Revision History:
-- Version 1.0
-- =============================================

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

-- [dbo].[Rpt_GetRequestsNameForNoRFAForm]1232
CREATE PROCEDURE [dbo].[Rpt_GetRequestsNameForNoRFAForm]
@referralID int
AS
BEGIN
SELECT   (RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),''))  AS Requests
FROM         RFARequests
Where   RFAReferralID = @ReferralID and RFARequestedTreatment is not null and DecisionID = 8
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetRFALetterForIMRResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		HaSingh
-- Create date: 31/3/2016
-- Description:	Get RFA Letter for IMR Response Letter Report

--Revision History: -
-- 1.1		TGosain 06-15-2016
--			@AttachedDocument pattern updated for uniqueness 
-- =============================================
-- [dbo].[Rpt_GetRFALetterForIMRResponseLetter]745,'235-745D13,179-542D10,167-542D24,168-542D25,169-542D26,170-542D27,185-542D28,173-542D6,174-542D7,204-547D6,175-542D23,177-542D19,178-542D20,205-547D19,206-531D8,171-542D29,172-542D30,176-542D8'
CREATE PROCEDURE [dbo].[Rpt_GetRFALetterForIMRResponseLetter]
	(
	@RFAReferralID int,
	@AttachedDocument varchar(MAX)
	
	)
AS
BEGIN
select * from 
	(SELECT   RFARecordSplittings.RFARecDocumentName +' dated '+ convert(varchar(10), RFARecordSplittings.RFARecDocumentDate,101)+' by ' + RFARecordSplittings.AuthorName as RFALetter, RFARecordSplittings.RFARecDocumentName as DocName 
	FROM         RFARecordSplittings INNER JOIN
						  lookup.IMRResponseLetterDocumentRelations ON 
						  lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 

	WHERE     (RFARecordSplittings.DocumentTypeID IN (10)) AND 
				((convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)))
			   IN
			  (SELECT splitdata FROM global.Get_SplitStringFormat(@AttachedDocument, ',') AS Get_SplitStringFormat_1))


	union 

	SELECT   RFAReferralFiles.RFAReferralFileName +' dated '+ convert(varchar(10), RFAReferralFiles.RFAFileCreationDate,101)+' by ' + (Select UserFirstName + ' ' + UserLastName from Users where Users.UserId = RFAReferralFiles.RFAFileUserID) as RFALetter, RFAReferralFiles.RFAReferralFileName as DocName
	FROM         RFAReferralFiles INNER JOIN
						  lookup.IMRResponseLetterDocumentRelations ON 
						  lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFAReferralFiles.RFAFileTypeID

	WHERE     (RFAReferralFiles.RFAFileTypeID IN (6)) AND 
				((convert(varchar(10),RFAReferralFiles.RFAReferralFileID,101)+'-'+(convert(varchar(10),RFAReferralFiles.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFAReferralFiles.RFAFileTypeID)))
			   IN
			  (SELECT splitdata FROM global.Get_SplitStringFormat(@AttachedDocument, ',') AS Get_SplitStringFormat_1))
	)tb1
Order By DocName desc
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetStatusDetailsList]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ParamKaur>
-- Create date: <15-Sep-2017,>
-- Description:	<To get Status Id and Name>
-- =============================================
CREATE PROCEDURE [dbo].[Rpt_GetStatusDetailsList] 
(@CurrentWorkloadReportID int)
AS
BEGIN
	--Select * from lookup.Statuses
	if exists( Select cwr.StatusID from dbo.CurrentWorkloadReportParameters cwr 
		where CurrentWorkloadReportID = @CurrentWorkloadReportID and StatusID is not null)
	begin
		Select cwr.StatusID, (Select StatusName from lookup.Statuses where StatusID = cwr.StatusID) as StatusName from dbo.CurrentWorkloadReportParameters cwr 
		where CurrentWorkloadReportID = @CurrentWorkloadReportID and StatusID is not null
	end
	else
	begin
		select '' as StatusID, '' as StatusName
	end
	 --delete from dbo.CurrentWorkloadReportParameters
END

GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetUnableToReviewDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,MAHINDER SINGH>
-- Create date: <Create Date,,21-JUNE-2017>
-- Description:	<Description,, GET Unable To Reviews DETAILS FOR REPORT>
-- =============================================\

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

--[dbo].[Rpt_GetUnableToReviewDetails]1268
CREATE PROCEDURE [dbo].[Rpt_GetUnableToReviewDetails]
	@referralID INT
AS
BEGIN
SELECT req.RFARequestID as [RequestID], (req.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (req.RFARequestID)),'')) as [Treatment]
		, ISNULL(req.RFAFrequency,0) as [Frequency]
		, ISNULL(req.RFADuration,0) as [Duration]	
		,
		req.RFAQuantity
		AS QTY
		, ISNULL(CASE WHEN (SELECT COUNT(*) FROM RFARequestModifies WHERE rfarequestid= req.rfarequestID) = 1 
			THEN ((SELECT DurationTypeName FROM mmc.lookup.DurationTypes WHERE DurationTypeID = reqm.RFADurationTypeID))
			ELSE ((SELECT DurationTypeName FROM mmc.lookup.DurationTypes WHERE DurationTypeID = req.RFADurationTypeID)) END,0) AS [DurationType]						
	  FROM [MMC].[dbo].[RFARequests] as req
	    left join [RFARequestModifies] reqm on  req.RFARequestID = reqm.RFARequestID
where req.DecisionID = 8 and req.RFAReferralID = @referralID 
END

GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetURRequestReport]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Mkhurana>
-- Create date: <13-sept-2017>
-- Description:	<get records as per task 3130>
-- =============================================
--[dbo].[Rpt_GetURRequestReport] '40','9','2017'
CREATE PROCEDURE [dbo].[Rpt_GetURRequestReport] 
	(
	@client varchar(max),
	@Month varchar(max),
	@year varchar(max)	
	)
AS
BEGIN
	

WITH  RequestURReport AS
		(
	         select * from (
	         
	         SELECT ROW_NUMBER() OVER(PARTITION BY  RFARequests.RFARequestID ORDER BY  RFAProcessLevels.RFAProcessLevelID   DESC) as RowNumber ,   
			PatientClaims.PatientClaimID, PatientClaims.PatientID, RFARequests.RFAReferralID, RFARequests.RFARequestID, 
			(SELECT RequestTypeDesc from lookup.RequestTypes where lookup.RequestTypes.RequestTypeID=RFARequests.RequestTypeID) as RequestType,
			Patients.PatFirstName + ' ' + Patients.PatLastName as PatientName, PatientClaims.PatClaimNumber,
			
			                    	
	SUM(CONVERT(DECIMAL(10,2), NULLIF(Case when (links.RFAReferralID=RFAReferrals.RFAReferralID) then 
                       ISNULL(ROUND(((rB.RFARequestBillingRN * cbrr.ClientBillingRetailRateRN + rB.RFARequestBillingMD * cbrr.ClientBillingRetailRateMD)
                       + rB.RFARequestBillingAdmin * cbrr.ClientBillingRetailRateAdminFee) 
                      + rB.RFARequestBillingSpeciality * cbrr.ClientBillingRetailRateSpecialityReview
                      + rB.RFARequestBillingDeferral * cbrr.ClientBillingRetailRateDeferral, 2), 0) 
                      else ''
                      end,''))) as BilledAmount,
	
                      
						   (Case when(RFARequestModifies.RFARequestID=RFARequests.RFARequestID) 
						   then (RFARequestModifies.RFARequestedTreatment) 
                         else  RFARequests.RFARequestedTreatment +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID ( RFARequests.RFARequestID)),'') end) as RFARequestedTreatment, 
                         
                         Physicians.PhysFirstName+' ' + Physicians.PhysLastName as Physician
                         , Physicians.PhysicianId
                         , (case when (RFARequests.DecisionDate IS NULL And RFAProcessLevels.ProcessLevel>60)
             then (Case when(RFARequests.RFAStatus = 'SendToPreparation') then 'Preparation'
                         when(RFARequests.RFAStatus = 'SendToClinical') then 'Clinical'
                         when(RFARequests.DecisionID = 13) then 'Withdrawn'
                         when(RFARequests.DecisionID = 12) then 'Client Authorized'
                         else lookup.ProcessLevels.ProcessLevelDesc end)
			else  (case when exists(select top 1 imrreq.RFARequestID from IMRRFARequests imrreq where imrreq.RFARequestID = RFARequests.RFARequestID) 
					then (select IMRDecisionDesc from lookup.IMRDecision where IMRDecisionID = (select imrref.IMRDecisionID from IMRRFAReferrals imrref where imrref.RFAReferralID = RFAReferrals.RFAReferralID))
					else lookup.Decisions.DecisionDesc end)
			end) as Status
			, RFARequests.DecisionDate,RFARequests.RFARequestDate,Clients.ClientID, 
Datepart(MM, RFAReferrals.RFAReferralCreatedDate) AS getMonth, Datepart(YYYY, RFAReferrals.RFAReferralCreatedDate) AS getYear,
 RFAReferrals.RFAReferralCreatedDate
			 
			FROM         PatientClaims INNER JOIN
						  RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID INNER JOIN
						  RFARequests ON RFAReferrals.RFAReferralID = RFARequests.RFAReferralID INNER JOIN
						  [dbo].[Patients] ON Patients.PatientID = PatientClaims.PatientID
INNER JOIN [dbo].[Clients] ON ClientID = PatientClaims.PatClientID inner join
						  Physicians ON RFAReferrals.PhysicianID = Physicians.PhysicianId
						   Left JOIN
						  lookup.Decisions ON RFARequests.DecisionID = lookup.Decisions.DecisionID INNER JOIN
						  RFAProcessLevels ON RFAReferrals.RFAReferralID = RFAProcessLevels.RFAReferralID Left JOIN
						  lookup.ProcessLevels ON RFAProcessLevels.ProcessLevel = lookup.ProcessLevels.ProcessLevel
						  LEFT JOIN RFARequestModifies ON RFARequestModifies.RFARequestID=RFARequests.RFARequestID
						  inner join RFAReferralInvoices rfaInvoice on rfaInvoice.PatientClaimID=PatientClaims.PatientClaimID
						  inner join link.RFAReferralAdditionalLinks links on links.RFAReferralInvoiceID=rfaInvoice.RFAReferralInvoiceID 
						  left JOIN RFARequestBillings rB ON rB.RFARequestID = RFARequests.RFARequestID  
left JOIN ClientBillings cb ON cb.ClientID = Clients.ClientID 
left JOIN ClientBillingRetailRates cbrr ON cbrr.ClientBillingID = cb.ClientBillingID


group by RFARequests.RFARequestID,RFAProcessLevels.RFAProcessLevelID,PatientClaims.PatientClaimID,PatientClaims.PatientID,RFARequests.RFAReferralID
,RFARequests.RequestTypeID,Patients.PatFirstName,Patients.PatLastName,PatientClaims.PatClaimNumber,RFARequestModifies.RFARequestedTreatment,RFARequests.RFARequestedTreatment
,Physicians.PhysFirstName,Physicians.PhysLastName,Physicians.PhysicianId,RFAReferrals.RFAReferralID,RFARequests.DecisionDate,RFAProcessLevels.ProcessLevel,RFARequests.RFAStatus,
RFARequests.DecisionID,lookup.ProcessLevels.ProcessLevelDesc,lookup.Decisions.DecisionDesc,RFARequests.RFARequestDate,Clients.ClientID,RFAReferrals.RFAReferralCreatedDate,RFARequestModifies.RFARequestID
						 
			
			 ) as rs where RowNumber=1	
			 )
			  SELECT * FROM RequestURReport where Datepart(MM, RFAReferralCreatedDate) in (Select splitdata from [global].[Get_SplitStringFormat](@Month,','))	
			  and Datepart(YYYY, RFAReferralCreatedDate) in (Select splitdata from [global].[Get_SplitStringFormat](@year,','))	
			  and ClientID in (Select splitdata from [global].[Get_SplitStringFormat](@client,','))			  

END

GO
/****** Object:  StoredProcedure [dbo].[Rpt_GetWorkStatusLetterForIMRResponseLetter]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		HaSingh
-- Create date: 31/3/2016
-- Description:	Get QME/AME Letter for IMR Response Letter Report

--Revision History: -
-- 1.1		TGosain 06-15-2016
--			@AttachedDocument pattern updated for uniqueness 
-- =============================================
-- [dbo].[Rpt_GetWorkStatusLetterForIMRResponseLetter]542,'D13,D31,D32,D33,F5,D10,D25,D26,D27,D24,D23,D19,D20,D30'
CREATE PROCEDURE [dbo].[Rpt_GetWorkStatusLetterForIMRResponseLetter]
	(
	@RFAReferralID int,
	@AttachedDocument varchar(MAX)
	)
AS
BEGIN
SELECT  RFARecordSplittings.RFARecDocumentName+' dated ' + convert(varchar(10), RFARecordSplittings.RFARecDocumentDate,101) +' by ' + RFARecordSplittings.AuthorName as WorkStatus
FROM         RFARecordSplittings INNER JOIN
                      lookup.IMRResponseLetterDocumentRelations ON 
                      lookup.IMRResponseLetterDocumentRelations.DocumentTypeID = RFARecordSplittings.DocumentTypeID 

WHERE     
--(RFARecordSplittings.RFAReferralID in(select RFAOldReferralID from [global].[Get_OldRFAReferralIDRecordByNewRFAReferralID](@RFAReferralID)) 
--						or RFARecordSplittings.RFAReferralID = @RFAReferralID) 
--AND 
(RFARecordSplittings.DocumentTypeID = 30) AND 

(convert(varchar(10),RFARecordSplittings.RFARecSpltID,101)+'-'+(convert(varchar(10),RFARecordSplittings.RFAReferralID,101)+lookup.IMRResponseLetterDocumentRelations.DocumentTableName + CONVERT(varchar(10), RFARecordSplittings.DocumentTypeID)) IN
  (SELECT     splitdata
    FROM          global.Get_SplitStringFormat(@AttachedDocument, ',')))
AND  RFARecordSplittings.RFARecDocumentName = 'Work Status'
Order By RFARecordSplittings.RFARecDocumentName desc

END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_IMRResponsePatientRecords]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		HaSingh
-- Create date: 03-18-2016
-- Description:	Get detail for IMR Response letter for patient detail
-- =============================================
-- [dbo].[Rpt_IMRResponsePatientRecords]542
CREATE PROCEDURE [dbo].[Rpt_IMRResponsePatientRecords](
@RFAReferralID int
)

AS
BEGIN
SELECT DISTINCT 
                      PatientClaims.PatClaimNumber, Patients.PatFirstName, Patients.PatLastName, CONVERT(VARCHAR(10), PatientClaims.PatDOI, 101) AS PatDOI, 
                      CONVERT(VARCHAR(10), RFARequests.DecisionDate, 101) AS DecisionDate, RFAReferrals.RFAIMRReferenceNumber, CONVERT(VARCHAR(10), 
                      RFARequests.RFARequestIMRCreatedDate, 101) AS RFARequestIMRCreatedDate, RFAReferrals.RFAIMRHistoryRationale
                     ,(select AttorneyName from  dbo.Attorneys where AttorneyID =  PatientClaims.PatApplicantAttorneyID)ApplicantAttorney
                     ,(select AttorneyName from  dbo.Attorneys where AttorneyID = PatientClaims.PatDefenseAttorneyID)DefenceAttorney
                      ,(Adjusters.AdjFirstName+' '+ Adjusters.AdjLastName)AdjName
FROM         RFAReferrals INNER JOIN
                      PatientClaims ON RFAReferrals.PatientClaimID = PatientClaims.PatientClaimID INNER JOIN
                      Patients ON PatientClaims.PatientID = Patients.PatientID INNER JOIN
                      RFARequests ON RFAReferrals.RFAReferralID = RFARequests.RFAReferralID Left JOIN
                      Adjusters ON PatientClaims.PatAdjusterID = Adjusters.AdjusterID
WHERE     (RFAReferrals.RFAReferralID = @RFAReferralID)
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_IMRResponseProofOfServiceDetails]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RSINGH	
-- Create date: 04-04-2016
-- Description:	Get data for IMR Response Proof Of Service report.
-- =============================================

--[dbo].[Rpt_IMRResponseProofOfServiceDetails] 257
-- [dbo].[Rpt_IMRResponseProofOfServiceDetails] 232
CREATE PROCEDURE [dbo].[Rpt_IMRResponseProofOfServiceDetails]
	(@referralID int)
AS
BEGIN
                SELECT     Patients.PatFirstName + ' ' + Patients.PatLastName AS PatientName, Patients.PatAddress1 + '<br/>' + Patients.PatCity + ', ' +
                          (SELECT     StateName
                            FROM          lookup.States
                            WHERE      (StateId = Patients.PatStateID)) + ', ' + Patients.PatZip AS PatientAddress, PatientClaims.PatClaimNumber, 
                      RFAReferrals.RFAIMRReferenceNumber,
                          (SELECT     AttorneyName
                            FROM          Attorneys
                            WHERE      (AttorneyID = PatientClaims.PatApplicantAttorneyID)) AS ApplicantAttorneyName,
                          (SELECT     atf.AttAddress1 + '<br/>' + atf.AttCity + ', ' +
                                                       (SELECT     StateName
                                                         FROM          lookup.States AS States_2
                                                         WHERE      (StateId = atf.AttStateID)) + ', ' + atf.AttZip AS Expr1
                            FROM          Attorneys AS at INNER JOIN
                                                   AttorneyFirms AS atf ON at.AttorneyFirmID = atf.AttorneyFirmID
                            WHERE      (at.AttorneyID = PatientClaims.PatApplicantAttorneyID)) AS ApplicantAttorneyAddress, ISNULL
                          ((SELECT     AttorneyName
                              FROM         Attorneys AS Attorneys_1
                              WHERE     (AttorneyID = PatientClaims.PatDefenseAttorneyID)), '') AS DefenseAttorneyName,
                          (SELECT     atf.AttAddress1 + '<br/>' + atf.AttCity + ', ' +
                                                       (SELECT     StateName
                                                         FROM          lookup.States AS States_1
                                                         WHERE      (StateId = atf.AttStateID)) + ', ' + atf.AttZip AS Expr1
                            FROM          Attorneys AS at INNER JOIN
                                                   AttorneyFirms AS atf ON at.AttorneyFirmID = atf.AttorneyFirmID
                            WHERE      (at.AttorneyID = PatientClaims.PatDefenseAttorneyID)) AS DefenseAttorneyAddress,
                             (case when  Clients.ClaimAdministratorType ='ins'
            then (SELECT    ins.InsName + '<br/>'+ ins.InsAddress1 + '<br/>' + ins.InsCity +', '+(select StateName from lookup.States where stateid = ins.InsurerID) +', '+ins.InsZip 
 FROM        Insurers ins
WHERE     (ins.InsurerID = Clients.ClaimAdministratorID))
            when  Clients.ClaimAdministratorType ='emp'
            then (SELECT    emp.EmpName + '<br/>'+ emp.EmpAddress1 
            +'<br/>' + emp.EmpCity +', '+(select StateName from lookup.States where stateid = emp.EmployerID) +', '+emp.EmpZip 
 FROM        Employers emp
WHERE     (emp.EmployerID = Clients.ClaimAdministratorID))
            when  Clients.ClaimAdministratorType ='insb'
            then (SELECT    insb.InsBranchName + '<br/>'+ insb.InsBranchAddress +'<br/>' + insb.InsBranchCity +', '+(select StateName from lookup.States where stateid = insb.InsBranchStateID) +', '+insb.InsBranchZip 
 FROM         InsuranceBranches insb
WHERE     (insb.InsuranceBranchID = Clients.ClaimAdministratorID))
            when  Clients.ClaimAdministratorType ='tpa'
            then (SELECT    tpa.TPAName + '<br/>'+ tpa.TPAAddress + '<br/>'+ tpa.TPACity+', '+(select StateName from lookup.States where stateid = tpa.TPAStateID) +', '+tpa.TPAZip 
 FROM        ThirdPartyAdministrators tpa
WHERE     (tpa.TPAID = Clients.ClaimAdministratorID))
 when  Clients.ClaimAdministratorType ='tpab'
            then (SELECT    tpab.TPABranchName + '<br/>'+ tpab.TPABranchAddress +'<br/>'+ 
             tpab.TPABranchCity+', '+(select StateName from lookup.States where stateid = tpab.TPABranchStateID) +', '+tpab.TPABranchZip 
 FROM        ThirdPartyAdministratorBranches tpab
WHERE     (tpab.TPABranchID = Clients.ClaimAdministratorID))
              when  Clients.ClaimAdministratorType ='mcc'
            then (SELECT    mmc.CompName + '<br/>'+ mmc.CompAddress + '<br/>'+ mmc.CompCity+', '+(select StateName from lookup.States where stateid = mmc.CompStateID) +', '+mmc.CompZip 
 FROM        ManagedCareCompanies mmc
 WHERE     (mmc.CompanyID = Clients.ClaimAdministratorID))           
        end) as ClaimAdministratorAddress,
       cpl.ClientPrivateLabelName
       , ph.PhysFirstName + ' ' + ph.PhysLastName as PhysicianName
				, ph.PhysAddress1 + '<br/>' + ph.PhysCity + ', ' + (select StateName from lookup.States where stateid = ph.PhysStateID) + ', ' + ph.PhysZip as PhysicianAddress, imrref.IMRApplicationReceivedDate
FROM         Patients INNER JOIN
                      PatientClaims ON Patients.PatientID = PatientClaims.PatientID INNER JOIN
                      RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID INNER JOIN
                      Clients ON PatientClaims.PatClientID = Clients.ClientID left join
                       ClientPrivateLabels cpl on Clients.ClientID=cpl.ClientID left join
                       IMRRFAReferrals imrRef on RFAReferrals.RFAReferralID =imrref.RFAReferralID left join
                       Physicians ph on ph.PhysicianID = imrref.IMRRFAClaimPhysicianID
                       where RFAReferrals.RFAReferralID=@referralID
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_InvoiceForUtilizationReview]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================
-- Author     :	MAHINDER SINGH
-- Create date: 1 April 2016
-- Description:	To Get a Details for Invoice for Utilization Review

-- Revision History:
-- 1.1 -	TGosain
--			01 June 2016
-- Description: Adding Deferral value to the billing total.
-- 1.2 -	TGosain 15 June 2016
-- Description: #2824 - unpivot used to make result according to billingTime .
-- =================================================================

-- --=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================  


CREATE PROCEDURE [dbo].[Rpt_InvoiceForUtilizationReview]
@referralID VARCHAR(MAX),
@PatientClaimID INT,
@InvoiceNumber VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @tmp Table(refID INT)
DECLARE @InvId INT
DECLARE @InvoiceFileName VARCHAR(100)

INSERT INTO @tmp
            SELECT splitdata FROM  [global].[Get_SplitStringFormat] (@referralID,',')

SET @InvId = (SELECT RFAReferralInvoiceID FROM RFAReferralInvoices WHERE InvoiceNumber = @InvoiceNumber)
SET @InvoiceFileName = @InvoiceNumber+'_Invoice.pdf';

UPDATE  RFAReferralInvoices SET InvoiceFileName = @InvoiceFileName WHERE RFAReferralInvoiceID = @InvId

select * from (
Select RFARequestID
	, InvoiceDate	
	, ClientInvoiceNumber
	, EmpName
	, AdjusterName
	, PatientName
	, PatClaimNumber
	, PatDOI
	, RFAReferralID
	, ClaimAdministratorID
	, ClientName
	, ClientID
	, ClientAdminName
	, ClientAdminAddress
	, ClientAdminCity
	, ClientStateName
	, ClientAdminZip
	, ClientAttentionToID	
	, AttentionTo
	, ClientIsPrivateLabel
	, ClientPrivateLabelName
	, ClientPrivateLabelAddress
	, ClientPrivateLabelCity
	, StateName
	, DecisionDate
	, (RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequestID)),'')) as RFARequestedTreatment
	, [Hours]
	, HoursValue
	, Case	when [Hours] = 'BillingTimeRN' then RetailRateRN 
			when [Hours] = 'BillingTimeMD' then RetailRateMD 
			when [Hours] = 'BillingTimeSpeciality' then RetailRateSpecialReview
			when [Hours] = 'BillingTimeAdmin' then RetailRateAdminFee 
			when [Hours] = 'BillingTimeDeferral' then RetailRateDeferral end Rate	
			
	, Case	when [Hours] = 'BillingTimeRN' then RetailRateRN *  HoursValue
			when [Hours] = 'BillingTimeMD' then RetailRateMD * HoursValue
			when [Hours] = 'BillingTimeSpeciality' then RetailRateSpecialReview * HoursValue
			when [Hours] = 'BillingTimeAdmin' then RetailRateAdminFee * HoursValue
			when [Hours] = 'BillingTimeDeferral' then RetailRateDeferral * HoursValue end BilledAmount	
			
	, Case	when [Hours] = 'BillingTimeRN' then 'Level 1(RN) Review'
			when [Hours] = 'BillingTimeMD' then 'Level 2(MD) Review'
			when [Hours] = 'BillingTimeSpeciality' then 'Level 3(Specialty) Review'
			when [Hours] = 'BillingTimeAdmin' then 'Admin'
			when [Hours] = 'BillingTimeDeferral' then 'Deferral' end Activity
from 
(
	       
SELECT      CONVERT(DATE,GETDATE()) AS InvoiceDate,(@InvoiceNumber) AS ClientInvoiceNumber,emp.EmpName,(adj.AdjFirstName+' '+ adj.AdjLastName) AS AdjusterName,(p.PatFirstName+' '+p.PatLastName)as PatientName
	       ,pc.PatClaimNumber,pc.PatDOI,rf.RFAReferralID,cl.ClaimAdministratorID,cl.ClientName,cl.ClientID
	       ,(SELECT ClientAdminName FROM [global].[Get_ClaimAdministratorFieldsAccToClientNameAndClaimAdminstratorID](cl.ClientName,cl.ClaimAdministratorID,@PatientClaimID)) AS  ClientAdminName
	       ,(SELECT ClientAdminAddress FROM [global].[Get_ClaimAdministratorFieldsAccToClientNameAndClaimAdminstratorID](cl.ClientName,cl.ClaimAdministratorID,@PatientClaimID)) AS  ClientAdminAddress
	       ,(SELECT ClientAdminCity FROM [global].[Get_ClaimAdministratorFieldsAccToClientNameAndClaimAdminstratorID](cl.ClientName,cl.ClaimAdministratorID,@PatientClaimID)) AS  ClientAdminCity
	       ,(SELECT ClientStateName FROM [global].[Get_ClaimAdministratorFieldsAccToClientNameAndClaimAdminstratorID](cl.ClientName,cl.ClaimAdministratorID,@PatientClaimID)) AS  ClientStateName
	       ,(SELECT ClientAdminZip FROM [global].[Get_ClaimAdministratorFieldsAccToClientNameAndClaimAdminstratorID](cl.ClientName,cl.ClaimAdministratorID,@PatientClaimID)) AS  ClientAdminZip	       
	       ,cb.ClientAttentionToID
	        ,(CASE 
            WHEN cb.ClientAttentionToID = 1 THEN ''
            WHEN cb.ClientAttentionToID = 2  THEN (adj.AdjFirstName+' '+ adj.AdjLastName)
            ELSE cb.ClientAttentionToFreeText END) AS AttentionTo,cb.ClientIsPrivateLabel,cpl.ClientPrivateLabelName,cpl.ClientPrivateLabelAddress,cpl.ClientPrivateLabelCity,st.StateName	       
	       ,req.RFARequestID,req.DecisionDate,req.RFARequestedTreatment,'Level 1(RN) Review' AS ActivityRN,'Level 2(MD) Review' AS ActivityMD,'Level 3(Specialty) Review' AS ActivitySpecialty,'Admin' AS ActivityAdmin
	       ,'Deferral' as ActivityDeferral
	       ,cbrr.ClientBillingRetailRateRN AS RetailRateRN
	       ,cbrr.ClientBillingRetailRateMD AS RetailRateMD,cbrr.ClientBillingRetailRateSpecialityReview AS RetailRateSpecialReview
	       ,cbrr.ClientBillingRetailRateAdminFee AS RetailRateAdminFee,IsNuLL(cbrr.ClientBillingRetailRateDeferral,0) AS RetailRateDeferral, rB.RFARequestBillingRN AS BillingTimeRN, rB.RFARequestBillingMD AS BillingTimeMD
	       ,rB.RFARequestBillingSpeciality AS BillingTimeSpeciality, rB.RFARequestBillingAdmin AS BillingTimeAdmin, ISNULL(rb.RFARequestBillingDeferral,0) AS BillingTimeDeferral
	       ,(cbrr.ClientBillingRetailRateRN * rB.RFARequestBillingRN) AS TotalRN,(cbrr.ClientBillingRetailRateMD * rB.RFARequestBillingMD) AS TotalMD
	       ,(cbrr.ClientBillingRetailRateSpecialityReview * rB.RFARequestBillingSpeciality) AS TotalSpeciality,(cbrr.ClientBillingRetailRateAdminFee * rB.RFARequestBillingAdmin) AS TotalAdminFee
	       ,(IsNuLL(cbrr.ClientBillingRetailRateDeferral,0) * IsNuLL(rB.RFARequestBillingDeferral,0)) AS TotalDeferral
	       ,((cbrr.ClientBillingRetailRateRN * rB.RFARequestBillingRN) + (cbrr.ClientBillingRetailRateMD * rB.RFARequestBillingMD) +
	       (cbrr.ClientBillingRetailRateSpecialityReview * rB.RFARequestBillingSpeciality) +(cbrr.ClientBillingRetailRateAdminFee * rB.RFARequestBillingAdmin)
	       +(cbrr.ClientBillingRetailRateDeferral * rB.RFARequestBillingDeferral))AS TotalPaymentAmount
FROM RFARequests req
INNER JOIN RFAReferrals  rf ON rf.RFAReferralID = req.RFAReferralID
INNER JOIN PatientClaims pc ON pc.PatientClaimID = rf.PatientClaimID
INNER JOIN Patients p ON p.PatientID = pc.PatientID 
INNER JOIN Clients cl ON cl.ClientID = pc.PatClientID 
INNER JOIN Adjusters adj ON adj.AdjusterID = pc.PatAdjusterID
INNER JOIN Employers emp ON emp.EmployerID = pc.PatEmployerID
INNER JOIN RFAProcessLevels rpl ON rpl.RFAReferralID = rf.RFAReferralID
INNER JOIN RFARequestBillings rB ON rB.RFARequestID = req.RFARequestID  
INNER JOIN ClientBillings cb ON cb.ClientID = cl.ClientID 
INNER JOIN ClientBillingRetailRates cbrr ON cbrr.ClientBillingID = cb.ClientBillingID 
LEFT  JOIN ClientPrivateLabels cpl ON cpl.ClientID = cl.ClientID
LEFT JOIN lookup.States st ON st.StateId = cpl.ClientPrivateLabelStateID
WHERE req.RFAReferralID IN (select refID from @tmp) AND rpl.ProcessLevel = 160 AND rf.PatientClaimID = @PatientClaimID
) as tb1
unpivot
(	
  HoursValue
  for [Hours] in (BillingTimeRN,BillingTimeMD, BillingTimeSpeciality, BillingTimeAdmin, BillingTimeDeferral)  
) unpiv
) as final
where HoursValue != 0.00

End

GO
/****** Object:  StoredProcedure [dbo].[Rpt_NotificationOfUtilizationReviewDeferral]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================
-- Author     :	Mahinder Singh
-- Create date: 02 FEB 2016
-- Description:	To get NOTIFICATION OF UTILIZATION REVIEW DEFERRAL DUE TO LIABILITY DISPUTE letter patient section details. 
-- ==========================================================================================================================
-- [dbo].[Rpt_NotificationOfUtilizationReviewDeferral]1220

--=================================================================
-- Author By: RKUMAR
-- Create date: 6-14-2017
-- Description: 3093- Request Name - Body Part Update
-- Version: 1.1
-- ================================================================ 

CREATE PROCEDURE [dbo].[Rpt_NotificationOfUtilizationReviewDeferral](@referralID INT)
AS
BEGIN
	SELECT CurrentDate,RFAReferralID,[PatientName],[ClaimAdministrator],[ClaimNumber],[Adjuster],[DOI],[CEReceivedDate],
	       Decisions.DecisionID,Decisions.DecisionDesc,RFARequestID,DecisionDate,RFAReqCertificationNumber,RFARequestedTreatment,PhysFirstName,PhysLastName,
	       PhysQualification,PhysAddress1,[PhysStates],PhysCity,PhysFax,PhysZip,ApplicantAttorneyName,DefenseAttorneyName,
	       AdjusterPhoneNumber,RFADate,ADRID,ADRName,ADRContactName,ADRPhoneNumber
	FROM (SELECT	CONVERT(VARCHAR(10),GETDATE(),101)as CurrentDate, rf.RFAReferralID,Patients.PatFirstName + ' ' + Patients.PatLastName AS [PatientName]			
			,(CASE 
				WHEN ClaimAdministratorType='emp' THEN (SELECT EmpName FROM Employers WHERE EmployerID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='ins' THEN (SELECT InsName FROM Insurers WHERE InsurerID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='insb' THEN (SELECT InsBranchName FROM InsuranceBranches WHERE InsuranceBranchID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='tpa' THEN (SELECT TPAName FROM ThirdPartyAdministrators WHERE TPAID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='mcc' THEN (SELECT CompName FROM ManagedCareCompanies WHERE CompanyID = ClaimAdministratorID) 
				END) AS [ClaimAdministrator]				
			, pc.PatClaimNumber AS [ClaimNumber]
			, AdjFirstName + ' ' + AdjLastName AS [Adjuster]
			, CONVERT(VARCHAR(10),pc.PatDOI,101) AS [DOI]
			, CONVERT(VARCHAR(10),rf.RFACEDate,101) AS[CEReceivedDate]
			,RFARequests.DecisionID  			
			,RFARequests.RFARequestID 
			,CONVERT(VARCHAR(10),RFARequests.DecisionDate ,101) AS  DecisionDate
			,RFARequests.RFAReqCertificationNumber 
			--,RFARequests.RFARequestedTreatment  
			,(RFARequests.RFARequestedTreatment + ' ' + +' ' + isnull((select dbo.CommaSeperateRequestWithBodyPartNameByRFARequestID (RFARequests.RFARequestID)),'')) as RFARequestedTreatment
			,PhysFirstName
			,PhysLastName
			,PhysQualification
			,PhysAddress1
			,(SELECT StateName FROM mmc.lookup.States WHERE StateId = PhysStateID) AS [PhysStates]
			,PhysCity
			,PhysFax
			,PhysZip
			,AA.AttorneyName AS ApplicantAttorneyName
			,DA.AttorneyName AS DefenseAttorneyName
			,Adjusters.AdjPhone AS AdjusterPhoneNumber
			,CONVERT(VARCHAR(10),rf. RFAReferralDate,101)AS RFADate
			,ISNULL(ADRs.ADRID,0) AS ADRID,ISNULL(ADRs.ADRName,'') AS ADRName
			,ISNULL(ADRs.ContactName,'') AS ADRContactName,ISNULL(ADRs.ContactPhone,'') AS ADRPhoneNumber
						
    FROM MMC.dbo.RFAReferrals rf		
			INNER JOIN PatientClaims pc ON rf.PatientClaimID = pc.PatientClaimID
			INNER JOIN Patients ON pc.PatientID = Patients.PatientID			
			INNER JOIN Physicians ON Physicians.PhysicianId = rf.PhysicianID
			INNER JOIN Clients ON pc.PatClientID = Clients.ClientID
			INNER JOIN  Adjusters ON pc.PatAdjusterID = AdjusterID 	
			LEFT JOIN  Attorneys AS AA ON pc.PatApplicantAttorneyID = AA.AttorneyID
			LEFT JOIN  Attorneys AS DA ON pc.PatDefenseAttorneyID = DA.AttorneyID
			INNER JOIN RFARequests ON rf.RFAReferralID = RFARequests.RFAReferralID
			LEFT JOIN ADRs ON pc.PatADRID = ADRs.ADRID 
	WHERE rf.RFAReferralID = @referralID AND DecisionID = 9
	)T
	INNER JOIN 	 lookup.Decisions ON Decisions.DecisionID = T.DecisionID
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_RFARefferralTimeExtension]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================
-- Author     :	Rohit Kumar
-- Create date: 15 March 2016
-- Description:	To get NOTIFICATION OF UTILIZATION REVIEW DEFERRAL DUE TO LIABILITY DISPUTE letter patient section details. 
-- ==========================================================================================================================
-- [dbo].[Rpt_RFARefferralTimeExtension] 32
CREATE PROCEDURE [dbo].[Rpt_RFARefferralTimeExtension](@referralID INT)
AS
BEGIN
	SELECT CurrentDate,RFAReferralID,[PatientName],[ClaimAdministrator],[ClaimNumber],[Adjuster],[DOI],[CEReceivedDate],
	       PhysFirstName,PhysLastName,
	       PhysQualification,PhysAddress1,[PhysStates],PhysCity,PhysFax,PhysZip,ApplicantAttorneyName,DefenseAttorneyName,
	       AdjusterPhoneNumber,RFADate,ADRID,ADRName,ADRContactName,ADRPhoneNumber,RFARequestID,RFARequestedTreatment,DecisionDate
	FROM (SELECT     CONVERT(VARCHAR(10), GETDATE(), 101) AS CurrentDate, rf.RFAReferralID, Patients.PatFirstName + ' ' + Patients.PatLastName AS PatientName, 
                      (CASE WHEN ClaimAdministratorType = 'emp' THEN
                          (SELECT     EmpName
                            FROM          Employers
                            WHERE      EmployerID = ClaimAdministratorID) WHEN ClaimAdministratorType = 'ins' THEN
                          (SELECT     InsName
                            FROM          Insurers
                            WHERE      InsurerID = ClaimAdministratorID) WHEN ClaimAdministratorType = 'insb' THEN
                          (SELECT     InsBranchName
                            FROM          InsuranceBranches
                            WHERE      InsuranceBranchID = ClaimAdministratorID) WHEN ClaimAdministratorType = 'tpa' THEN
                          (SELECT     TPAName
                            FROM          ThirdPartyAdministrators
                            WHERE      TPAID = ClaimAdministratorID) WHEN ClaimAdministratorType = 'mcc' THEN
                          (SELECT     CompName
                            FROM          ManagedCareCompanies
                            WHERE      CompanyID = ClaimAdministratorID) END) AS ClaimAdministrator, pc.PatClaimNumber AS ClaimNumber, 
                      Adjusters.AdjFirstName + ' ' + Adjusters.AdjLastName AS Adjuster, CONVERT(VARCHAR(10), pc.PatDOI, 101) AS DOI, CONVERT(VARCHAR(10), rf.RFACEDate, 101) 
                      AS CEReceivedDate, Physicians.PhysFirstName, Physicians.PhysLastName, Physicians.PhysQualification, Physicians.PhysAddress1,
                          (SELECT     StateName
                            FROM          lookup.States
                            WHERE      (StateId = Physicians.PhysStateID)) AS PhysStates, Physicians.PhysCity, Physicians.PhysFax, Physicians.PhysZip, 
                      AA.AttorneyName AS ApplicantAttorneyName, DA.AttorneyName AS DefenseAttorneyName, Adjusters.AdjPhone AS AdjusterPhoneNumber, CONVERT(VARCHAR(10), 
                      rf.RFAReferralDate, 101) AS RFADate, ISNULL(ADRs.ADRID, 0) AS ADRID, ISNULL(ADRs.ADRName, '') AS ADRName, ISNULL(ADRs.ContactName, '') 
                      AS ADRContactName, ISNULL(ADRs.ContactPhone, '') AS ADRPhoneNumber, (select [dbo].[CommaSeperateRequestNameByRFAReferralID] (@referralID)) as RFARequestedTreatment,
                      (select [dbo].[CommaSeperateRequestUINByRFAReferralID] (@referralID)) as RFARequestID , isnull((SELECT  top 1   CreatedOn FROM         RFAReferralTimeExtensionHistories where RFAReferralID = @referralID order by 1),getdate()) as DecisionDate
                      
                      
                      
FROM         RFAReferrals AS rf INNER JOIN
                      PatientClaims AS pc ON rf.PatientClaimID = pc.PatientClaimID INNER JOIN
                      Patients ON pc.PatientID = Patients.PatientID INNER JOIN
                      Physicians ON Physicians.PhysicianId = rf.PhysicianID INNER JOIN
                      Clients ON pc.PatClientID = Clients.ClientID INNER JOIN
                      Adjusters ON pc.PatAdjusterID = Adjusters.AdjusterID LEFT OUTER JOIN
                      Attorneys AS AA ON pc.PatApplicantAttorneyID = AA.AttorneyID LEFT OUTER JOIN
                      Attorneys AS DA ON pc.PatDefenseAttorneyID = DA.AttorneyID LEFT OUTER JOIN
                      ADRs ON pc.PatADRID = ADRs.ADRID
WHERE     (rf.RFAReferralID = @referralID)
	)T
	--INNER JOIN 	 lookup.Decisions ON Decisions.DecisionID = T.DecisionID
END


GO
/****** Object:  StoredProcedure [dbo].[Rpt_UnableToReviewRFADuplicateSubmitted]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author     :	Mahinder Singh
-- Create date: 29 JAN 2016
-- Description:	To get UNABLE TO REVIEW RFA – DUPLICATE SUBMITTED letter patient section details. 
-- =============================================
-- [dbo].[Rpt_UnableToReviewRFADuplicateSubmitted]134  32
CREATE PROCEDURE [dbo].[Rpt_UnableToReviewRFADuplicateSubmitted](@referralID INT)
AS
BEGIN
	
	SELECT	CONVERT(VARCHAR(10),GETDATE(),101)as CurrentDate, rf.RFAReferralID,Patients.PatFirstName + ' ' + Patients.PatLastName AS [PatientName]			
			,(CASE 
				WHEN ClaimAdministratorType='emp' THEN (SELECT EmpName FROM Employers WHERE EmployerID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='ins' THEN (SELECT InsName FROM Insurers WHERE InsurerID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='insb' THEN (SELECT InsBranchName FROM InsuranceBranches WHERE InsuranceBranchID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='tpa' THEN (SELECT TPAName FROM ThirdPartyAdministrators WHERE TPAID = ClaimAdministratorID) 
				WHEN ClaimAdministratorType='mcc' THEN (SELECT CompName FROM ManagedCareCompanies WHERE CompanyID = ClaimAdministratorID) 
				END) AS [ClaimAdministrator]				
			, pc.PatClaimNumber AS [ClaimNumber]
			, AdjFirstName + ' ' + AdjLastName AS [Adjuster]
			, CONVERT(VARCHAR(10),pc.PatDOI,101) AS [DOI]
			, CONVERT(VARCHAR(10),rf.RFACEDate,101) AS[CEReceivedDate]					
			,PhysFirstName
			,PhysLastName
			,PhysQualification
			,PhysAddress1
			,(SELECT StateName FROM mmc.lookup.States WHERE StateId = PhysStateID) AS [PhysStates]
			,PhysCity
			,PhysFax
			,PhysZip
			,AA.AttorneyName AS ApplicantAttorneyName
			,DA.AttorneyName AS DefenseAttorneyName
			,Adjusters.AdjPhone AS AdjusterPhoneNumber
			,CONVERT(VARCHAR(10),rf. RFAReferralDate,101)AS RFADate
			,ISNULL(ADRs.ADRID,0) AS ADRID,ISNULL(ADRs.ADRName,'') AS ADRName
						
    FROM MMC.DBO.RFAReferrals rf		
			INNER JOIN PatientClaims pc ON rf.PatientClaimID = pc.PatientClaimID
			INNER JOIN Patients ON pc.PatientID = Patients.PatientID			
			INNER JOIN Physicians ON Physicians.PhysicianId = rf.PhysicianID
			INNER JOIN Clients ON pc.PatClientID = Clients.ClientID
			INNER JOIN  Adjusters ON pc.PatAdjusterID = AdjusterID 	
			LEFT JOIN  Attorneys AS AA ON pc.PatApplicantAttorneyID = AA.AttorneyID
			LEFT JOIN  Attorneys AS DA ON pc.PatDefenseAttorneyID = DA.AttorneyID
            LEFT JOIN ADRs ON pc.PatADRID = ADRs.ADRID          	
	WHERE rf.RFAReferralID = @referralID
END


GO
/****** Object:  StoredProcedure [dbo].[SaveUpdate_RFAReferralAdditionalInfo]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 03/15/2016
-- Description: save or update RFAReferralAdditionalInfo 
-- Version: 1.0
-- ================================================================ 
-- [dbo].[SaveUpdate_RFAReferralAdditionalInfo]  397,343,1
CREATE PROCEDURE [dbo].[SaveUpdate_RFAReferralAdditionalInfo] 
	@RFAReferralID int,
	@OriginalRFAReferralID int ,
	@UserId int
AS

	BEGIN
if exists  (select * from RFAReferralAdditionalInfoes where RFAReferralID= @RFAReferralID and OriginalRFAReferralID=@OriginalRFAReferralID)
begin
select 1
end
else if exists(select * from RFAReferralAdditionalInfoes where RFAReferralID= @RFAReferralID)
begin
UPDATE    RFAReferralAdditionalInfoes
SET              OriginalRFAReferralID = @OriginalRFAReferralID, UserId = @UserId, CreatedDate = GETDATE()
WHERE     (RFAReferralID = @RFAReferralID)
end
else
begin		
INSERT INTO RFAReferralAdditionalInfoes
                      (RFAReferralID, OriginalRFAReferralID, UserId, CreatedDate)
VALUES     (@RFAReferralID,@OriginalRFAReferralID,@UserId, GETDATE())
	end
END

GO
/****** Object:  StoredProcedure [dbo].[Search_AttorneyFirmByAttorneyORAttorneyFirmName]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 23 DEC 2015
-- Description : THIS SP IS USED FOR SEARCHING THE FIRMS BY FIRMNAME OR ATTORNEYNAME
-- ===================================================================================
CREATE PROCEDURE [dbo].[Search_AttorneyFirmByAttorneyORAttorneyFirmName] 
@AttorneyFirmSearch VARCHAR(50),
@Skip INT,
@Take INT
AS
BEGIN
        WITH AttorneySearch AS		 
		( 
	      SELECT  ROW_NUMBER() OVER (ORDER BY AttorneyFirms.AttorneyFirmID DESC)AS ROWNUMBER, AttorneyFirms.AttorneyFirmID
		  ,AttorneyFirms.AttorneyFirmName
		  ,AttorneyFirms.AttorneyFirmTypeID
		  ,AttorneyFirms.AttAddress1
		  ,AttAddress2
		  ,AttorneyFirms.AttCity
		  ,AttorneyFirms.AttStateID
		  ,AttorneyFirms.AttZip
		  ,AttorneyFirms.AttPhone
		  ,AttorneyFirms.AttFax
		  ,States.StateName AS AttStateName
		  ,AttorneyFirmTypes.AttorneyFirmTypeName AS AttorneyFirmType
		   FROM [MMC].[dbo].AttorneyFirms INNER  JOIN
				[MMC].[lookup].[AttorneyFirmTypes] ON AttorneyFirmTypes.AttorneyFirmTypeID = AttorneyFirms.AttorneyFirmTypeID INNER JOIN
				[MMC].[lookup].[States] ON States.StateId = AttorneyFirms.AttStateID
				 WHERE AttorneyFirms.AttorneyFirmName like @AttorneyFirmSearch +'%' OR 
				 AttorneyFirms.AttorneyFirmID IN (SELECT Attorneys.AttorneyFirmID 
												  FROM [MMC].[dbo].[Attorneys] 
												  WHERE Attorneys.AttorneyName like '%'+ @AttorneyFirmSearch +'%')
                                              
    )
	SELECT * FROM AttorneySearch
	WHERE ROWNUMBER BETWEEN @Skip+1 AND (@Skip+@Take)                                           
    
END

GO
/****** Object:  StoredProcedure [dbo].[Search_AttorneyFirmByAttorneyORAttorneyFirmNameCOUNT]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================
-- Author      : Mahinder Singh
-- Create date : 23 DEC 2015
-- Description : THIS SP IS USED FOR SEARCHING THE FIRMS BY FIRMNAME OR ATTORNEYNAME
-- ===================================================================================
CREATE PROCEDURE [dbo].[Search_AttorneyFirmByAttorneyORAttorneyFirmNameCOUNT] 
@AttorneyFirmSearch VARCHAR(50)
AS
BEGIN
        SELECT COUNT(1)
		   FROM [MMC].[dbo].AttorneyFirms INNER  JOIN
				[MMC].[lookup].[AttorneyFirmTypes] ON AttorneyFirmTypes.AttorneyFirmTypeID = AttorneyFirms.AttorneyFirmTypeID INNER JOIN
				[MMC].[lookup].[States] ON States.StateId = AttorneyFirms.AttStateID
				 WHERE AttorneyFirms.AttorneyFirmName like @AttorneyFirmSearch +'%' OR 
				 AttorneyFirms.AttorneyFirmID IN (SELECT Attorneys.AttorneyFirmID 
												  FROM [MMC].[dbo].[Attorneys] 
												  WHERE Attorneys.AttorneyName like '%'+ @AttorneyFirmSearch +'%')    
    
END

GO
/****** Object:  StoredProcedure [dbo].[Update_ClaimAdministratorResetDetailsByClientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUAMR
-- Create date: 12/31/2015
-- Description: Update Claim Administrator Reset Details By ClientID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_PatientByReferralID] 32
Create PROCEDURE [dbo].[Update_ClaimAdministratorResetDetailsByClientID] 
	@ClientID int 
AS

	BEGIN

		UPDATE    Clients SET              ClaimAdministratorID =0, ClaimAdministratorType = null
		where ClientID = @ClientID
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[Update_ClientManagedCareCompanyByClientID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUAMR
-- Create date: 12/28/2015
-- Description: Update Client Managed Care Company By ClientID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Get_PatientByReferralID] 32
Create PROCEDURE [dbo].[Update_ClientManagedCareCompanyByClientID] 
	@ClientID int,
	@CompanyID int 
AS

	BEGIN

		UPDATE    ClientManagedCareCompanies SET   CompanyID = @CompanyID where ClientID = @ClientID
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[Update_PatientClaimPleadBodyPartByPatientClaimID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: Gjain
-- Create date: 01/14/2016
-- Description: Update PatientClaimPleadBodyPart By PatientClaimID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Update_PatientClaimPleadBodyPartByPatientClaimID] 32
Create PROCEDURE [dbo].[Update_PatientClaimPleadBodyPartByPatientClaimID] 
	@PatientClaimID int ,
	@BodyPartStatusID int
AS

	BEGIN

		UPDATE    PatientClaimPleadBodyParts SET BodyPartStatusID=@BodyPartStatusID             
		where PatientClaimID = @PatientClaimID
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[Update_PatientMedicareEligibleByID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUAMR
-- Create date: 12/31/2015
-- Description: Update Patient Medicare Eligible By ID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Update_PatientMedicareEligibleByID] 72,'Delete'
CREATE PROCEDURE [dbo].[Update_PatientMedicareEligibleByID] 
	@PatientID int ,
	@Mode varchar(10),
	@CurrentMedicalConditionId int
AS	
	BEGIN
		if(LTRIM(rtrim(@Mode))= 'Add')
		begin
			UPDATE	Patients SET PatMedicareEligible = 'Yes' where PatientID = @PatientID
		end
		else if(LTRIM(rtrim(@Mode))= 'Delete')
		begin
		
			if ((SELECT COUNT(*) FROM PatientCurrentMedicalConditions where  PatientID = @PatientID and CurrentMedicalConditionId=@CurrentMedicalConditionId)>0)
			begin
				UPDATE	Patients SET PatMedicareEligible = 'Yes' where PatientID = @PatientID	
			end
			else
			begin
				declare @year as int
				declare @cyear as int
				set @year = (SELECT     year(PatDOB) FROM	Patients where PatientID = @PatientID)
				set @cyear = (select YEAR(getdate()))
				
				if ((@cyear - @year)<65)
				begin
					UPDATE	Patients SET PatMedicareEligible = 'No' where PatientID = @PatientID	
				end
				else
				begin
					UPDATE	Patients SET PatMedicareEligible = 'Yes' where PatientID = @PatientID	
				end
				
				
				
			end
				
		end
	END

GO
/****** Object:  StoredProcedure [dbo].[Update_RFAAdditionalInfoDetailByRequestID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: rkumar
-- Create date: 05/26/2016
-- Description: This function will not delete record but will move Request Record to new table to store as "Deleted" Requests. Request will no longer show as part of ReferralID
-- Version: 1.0
-- ================================================================ 

CREATE PROCEDURE [dbo].[Update_RFAAdditionalInfoDetailByRequestID] 
	@OldRFAReferralID int,
	@RFARequestID int 
AS
	BEGIN
	BEGIN TRANSACTION [Trans1]  
	BEGIN TRY
	
		declare @NewRFAreferralId int
		
		set @NewRFAreferralId = (SELECT      RFAReferralID FROM	RFARequests where RFARequestID = @RFARequestID)
		
		IF(( SELECT     COUNT(1) FROM         RFAAdditionalInfoes WHERE RFAReferralID = @NewRFAreferralId) = 0)
		BEGIN
			INSERT INTO RFAAdditionalInfoes
								  (RFAReferralID, RFAAdditionalInfoRecord, RFAAdditionalInfoRecordDate)
			SELECT      @NewRFAreferralId, RFAAdditionalInfoRecord, RFAAdditionalInfoRecordDate
			FROM         RFAAdditionalInfoes where RFAAdditionalInfoID in (SELECT      RFAAdditionalInfoID
			FROM         link.RFIReportRFAAdditionalRecords where RFARequestID = @RFARequestID)
			
			
			INSERT INTO RFAAdditionalInfoes
						  (RFAReferralID, RFAAdditionalInfoRecord, RFAAdditionalInfoRecordDate)
			SELECT     @NewRFAreferralId , RFAAdditionalInfoRecord, RFAAdditionalInfoRecordDate
			FROM         RFAAdditionalInfoes
			where RFAReferralID  = @OldRFAReferralID AND RFAAdditionalInfoRecordDate IS NULL
			
			
			
		END
			UPDATE    link.RFIReportRFAAdditionalRecords SET	RFAReferralID = @NewRFAreferralId
			where  RFARequestID = @RFARequestID
		COMMIT TRANSACTION	[Trans1]			
    END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION [Tran1]
		END CATCH	
	END


 
GO
/****** Object:  StoredProcedure [dbo].[Update_RFAReferralRequestDecisionByID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 01/22/2016
-- Description: Update RFA Referral Request Decision By ID when Cliam Status is Denied
-- Version: 1.0
-- ================================================================ 
--[dbo].[Update_RFAReqCertificationNumberByID] 102
CREATE PROCEDURE [dbo].[Update_RFAReferralRequestDecisionByID] 
	@RFAReferralID int
AS
	BEGIN
	
		if((SELECT     PatientClaimStatuses.ClaimStatusID
			FROM         PatientClaims INNER JOIN
                      RFAReferrals ON PatientClaims.PatientClaimID = RFAReferrals.PatientClaimID INNER JOIN
                      PatientClaimStatuses ON PatientClaims.PatientClaimID = PatientClaimStatuses.PatientClaimID where RFAReferrals.RFAReferralID= @RFAReferralID)=2)
			begin	
				UPDATE    RFARequests SET              DecisionID = 9 , RFAStatus =null where RFAReferralID =@RFAReferralID
			end
			else
			begin
					UPDATE    RFARequests SET              DecisionID = null , RFAStatus =null where RFAReferralID =@RFAReferralID
			end
	 
	END

GO
/****** Object:  StoredProcedure [dbo].[Update_RFAReferralRequestRFAClinicalReasonforDecisionByID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: MMSINGH
-- Create date: 29 JUNE 2017
-- Description: Update RFA Referral Request RFAClinicalReasonforDecision By ID when Cliam Status is updated
-- Version: 1.0
-- ================================================================ 
--[dbo].[Update_RFAReqCertificationNumberByID] 102
CREATE PROCEDURE [dbo].[Update_RFAReferralRequestRFAClinicalReasonforDecisionByID] 
	@RFAReferralID int,
	@RFAClinicalReasonforDecision VARCHAR(MAX)
AS
	BEGIN
	  
	    UPDATE dbo.RFARequests  SET RFAClinicalReasonforDecision = @RFAClinicalReasonforDecision
	    WHERE RFARequestID IN (SELECT  [RFARequestID]		FROM   dbo.RFARequests  WHERE  RFAReferralID = @RFAReferralID )
	 
	END

GO
/****** Object:  StoredProcedure [dbo].[Update_RFAReqCertificationNumberByID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RKUMAR
-- Create date: 01/22/2016
-- Description: Update RFA Req Certification Number By RequestID
-- Version: 1.0
-- ================================================================ 
--[dbo].[Update_RFAReqCertificationNumberByID] 102
CREATE PROCEDURE [dbo].[Update_RFAReqCertificationNumberByID] 
	@RFARequestID int
AS
	BEGIN
		 Declare @CertificationNumber as varchar(50)
		 Declare @TreatmentTypeCnt as int 
		 Declare @TreatmentTypeID as int 
		 set @TreatmentTypeID = (SELECT     TreatmentTypeID FROM         RFARequests where RFARequestID = @RFARequestID )
		 Set @TreatmentTypeCnt = (SELECT     count(1)
			FROM         RFARequests INNER JOIN
							  lookup.TreatmentTypes ON RFARequests.TreatmentTypeID = lookup.TreatmentTypes.TreatmentTypeID
			WHERE     (RFARequests.RFARequestID <@RFARequestID) and RFARequests.TreatmentTypeID = @TreatmentTypeID )
			
			--select @TreatmentTypeCnt as TreatmentTypeCnt
			
		 set @TreatmentTypeCnt = (Select (10000 +(@TreatmentTypeCnt + 1)))   
		 
		 Declare @ReadWordInitial as varchar(10)
		 Set @ReadWordInitial = (SELECT dbo.ReadWordInitials((SELECT     lookup.TreatmentTypes.TreatmentTypeDesc 
			FROM         RFARequests INNER JOIN
							  lookup.TreatmentTypes ON RFARequests.TreatmentTypeID = lookup.TreatmentTypes.TreatmentTypeID
			WHERE     (RFARequests.RFARequestID = @RFARequestID))))
			
		-- Select @ReadWordInitial as ReadWordInitial
		 
		 set @CertificationNumber = (Select (@ReadWordInitial + '' + convert(varchar(10),@TreatmentTypeCnt)))
		 
			UPDATE    RFARequests
			SET              RFAReqCertificationNumber =@CertificationNumber where RFARequestID = @RFARequestID
			
	END

GO
/****** Object:  StoredProcedure [dbo].[Update_RFARequestDecisionAndRFAStatusByReferralID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: TGosain
-- Create date: 02/16/2016
-- Description: Update RFA Req Decision and RFAStatus By ReferralID
-- Version: 1.0
-- History:
-- 1.1:	[Date]:	[Name]
--		[Description]
-- ================================================================ 
CREATE PROCEDURE [dbo].[Update_RFARequestDecisionAndRFAStatusByReferralID]
	@RFAReferralID int,
	@DecisionID varchar(5),
	@RFAStatus varchar(20)
AS
	BEGIN	
		UPDATE    RFARequests SET DecisionID = @DecisionID , RFAStatus = @RFAStatus where RFAReferralID = @RFAReferralID
	END

GO
/****** Object:  StoredProcedure [dbo].[Update_RFARequestLatestDueDateByRefferalID]    Script Date: 10-02-2020 15:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================================
-- Author By: RSINGH
-- Create date: 03/17/2016
-- Description: Updaet  Latest Due Date
-- Version: 1.0
-- Update_RFARequestLatestDueDateByRefferalID 9,396,1
-- ================================================================ 
CREATE PROCEDURE [dbo].[Update_RFARequestLatestDueDateByRefferalID] 
@AddDay int ,
@rfaRefferalID int,
@Createdby int
AS
BEGIN
declare @RFALatestDueDate datetime
declare @uniqueid int
set @uniqueid =(select top 1 RFATimeExtensionUniqueID from RFAReferralTimeExtensionHistories  where RFAReferralID=@rfaRefferalID order by RFAReferralTimeExtensionID desc)+1
if(@uniqueid is null)
  set @uniqueid=1
set @RFALatestDueDate=dbo.[Get_LatestRFARequestDueDate](@AddDay, GETDATE())
select @RFALatestDueDate
 update RFARequests set RFALatestDueDate =@RFALatestDueDate  where RFAReferralID=@rfaRefferalID and (DecisionID is null and (RFAStatus is null or RFAStatus  ='SendToPreparation'))
 INSERT INTO RFAReferralTimeExtensionHistories (RFARequestID,RFATimeExtensionUniqueID,RFAReferralID,RFARequestDueDate,CreatedBy,CreatedOn)
select RFARequestID,@uniqueid,RFAReferralID,@RFALatestDueDate,@Createdby,GETDATE() from RFARequests where RFAReferralID=@rfaRefferalID and (DecisionID is null and RFAStatus is null or RFAStatus  ='SendToPreparation')



END

GO
USE [master]
GO
ALTER DATABASE [MMC] SET  READ_WRITE 
GO

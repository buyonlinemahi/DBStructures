USE [master]
GO
/****** Object:  Database [PaymentDetailDataB]    Script Date: 10-02-2020 16:06:33 ******/
CREATE DATABASE [PaymentDetailDataB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PaymentDetailDataB', FILENAME = N'E:\SQL_Database\PaymentDetailDataB.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'PaymentDetailDataB_log', FILENAME = N'E:\SQL_Database\PaymentDetailDataB_log.ldf' , SIZE = 17408KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [PaymentDetailDataB] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PaymentDetailDataB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PaymentDetailDataB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET ARITHABORT OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PaymentDetailDataB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PaymentDetailDataB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PaymentDetailDataB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PaymentDetailDataB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET RECOVERY FULL 
GO
ALTER DATABASE [PaymentDetailDataB] SET  MULTI_USER 
GO
ALTER DATABASE [PaymentDetailDataB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PaymentDetailDataB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PaymentDetailDataB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PaymentDetailDataB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [PaymentDetailDataB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'PaymentDetailDataB', N'ON'
GO
USE [PaymentDetailDataB]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 10-02-2020 16:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [varchar](50) NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Items]    Script Date: 10-02-2020 16:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Items](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Price] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Items] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 10-02-2020 16:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[OrderItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[ItemID] [int] NULL,
	[Quantity] [int] NULL,
 CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED 
(
	[OrderItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Orders]    Script Date: 10-02-2020 16:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderNo] [varchar](50) NULL,
	[CustomerID] [int] NOT NULL,
	[PMethod] [varchar](50) NULL,
	[GTotal] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PaymentDetails]    Script Date: 10-02-2020 16:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentDetails](
	[PMId] [int] IDENTITY(1,1) NOT NULL,
	[CardOwnerName] [nvarchar](100) NULL,
	[CardNumber] [varchar](16) NULL,
	[ExpirationDate] [varchar](10) NULL,
	[CVV] [varchar](3) NULL,
 CONSTRAINT [PK_PaymentDetails] PRIMARY KEY CLUSTERED 
(
	[PMId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 10-02-2020 16:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[EmailId] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Customers] ON 

INSERT [dbo].[Customers] ([CustomerID], [CustomerName]) VALUES (1, N'Olivia Kathleen')
INSERT [dbo].[Customers] ([CustomerID], [CustomerName]) VALUES (2, N'Liam Patrick')
INSERT [dbo].[Customers] ([CustomerID], [CustomerName]) VALUES (3, N'Charlotte Rose')
INSERT [dbo].[Customers] ([CustomerID], [CustomerName]) VALUES (4, N'Elijah Burke ')
INSERT [dbo].[Customers] ([CustomerID], [CustomerName]) VALUES (5, N'Ayesha Ameer')
INSERT [dbo].[Customers] ([CustomerID], [CustomerName]) VALUES (6, N'Eva Louis')
SET IDENTITY_INSERT [dbo].[Customers] OFF
SET IDENTITY_INSERT [dbo].[Items] ON 

INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (1, N'Chicken Tenders', CAST(3.50 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (2, N'Chicken Tenders w/ Fries', CAST(4.99 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (3, N'Chicken Tenders w/ Onion', CAST(5.99 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (4, N'Grilled Cheese Sandwich', CAST(2.50 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (5, N'Grilled Cheese Sandwich w/ Fries', CAST(3.99 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (6, N'Grilled Cheese Sandwich w/ Onion', CAST(4.99 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (7, N'Lettuce and Tomato Burger', CAST(1.99 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (8, N'Soup', CAST(2.50 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (9, N'Onion Rings', CAST(2.99 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (10, N'Fries', CAST(1.99 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (11, N'Sweet Potato Fries', CAST(2.49 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (12, N'Sweet Tea', CAST(1.79 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (13, N'Botttle Water', CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[Items] ([ItemID], [Name], [Price]) VALUES (14, N'Canned Drinks', CAST(1.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[Items] OFF
SET IDENTITY_INSERT [dbo].[OrderItems] ON 

INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity]) VALUES (13, 6, 3, 20)
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity]) VALUES (15, 7, 12, 10)
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity]) VALUES (16, 7, 11, 20)
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity]) VALUES (17, 8, 13, 10)
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity]) VALUES (18, 9, 12, 340)
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity]) VALUES (19, 9, 3, 10)
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity]) VALUES (20, 10, 8, 10)
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity]) VALUES (21, 10, 13, 10)
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity]) VALUES (22, 7, 6, 2)
INSERT [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity]) VALUES (23, 6, 6, 20)
SET IDENTITY_INSERT [dbo].[OrderItems] OFF
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([OrderID], [OrderNo], [CustomerID], [PMethod], [GTotal]) VALUES (6, N'464456', 4, N'Card', CAST(219.60 AS Decimal(18, 2)))
INSERT [dbo].[Orders] ([OrderID], [OrderNo], [CustomerID], [PMethod], [GTotal]) VALUES (7, N'785230', 5, N'Card', CAST(77.68 AS Decimal(18, 2)))
INSERT [dbo].[Orders] ([OrderID], [OrderNo], [CustomerID], [PMethod], [GTotal]) VALUES (8, N'872703', 6, N'Cash', CAST(10.00 AS Decimal(18, 2)))
INSERT [dbo].[Orders] ([OrderID], [OrderNo], [CustomerID], [PMethod], [GTotal]) VALUES (9, N'375018', 2, N'Card', CAST(668.50 AS Decimal(18, 2)))
INSERT [dbo].[Orders] ([OrderID], [OrderNo], [CustomerID], [PMethod], [GTotal]) VALUES (10, N'344565', 5, N'Cash', CAST(35.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[Orders] OFF
SET IDENTITY_INSERT [dbo].[PaymentDetails] ON 

INSERT [dbo].[PaymentDetails] ([PMId], [CardOwnerName], [CardNumber], [ExpirationDate], [CVV]) VALUES (7, N'Dev', N'7070707070707070', N'02/03', N'789')
INSERT [dbo].[PaymentDetails] ([PMId], [CardOwnerName], [CardNumber], [ExpirationDate], [CVV]) VALUES (11, N'yadav', N'1414141414141414', N'14/14', N'141')
INSERT [dbo].[PaymentDetails] ([PMId], [CardOwnerName], [CardNumber], [ExpirationDate], [CVV]) VALUES (19, N'Tejdeep', N'7000000000000000', N'02/01', N'121')
INSERT [dbo].[PaymentDetails] ([PMId], [CardOwnerName], [CardNumber], [ExpirationDate], [CVV]) VALUES (20, N'Tej Pratap singh', N'8777777777777777', N'03/01', N'784')
SET IDENTITY_INSERT [dbo].[PaymentDetails] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserId], [UserName], [FirstName], [LastName], [EmailId], [Password]) VALUES (1, N'Tikku', N'Sharma', N'dSharma', N'dsharma@test.com', N's')
INSERT [dbo].[Users] ([UserId], [UserName], [FirstName], [LastName], [EmailId], [Password]) VALUES (2, N'Superman', N'T', N'Sharma', N'sunil@gmail.com', N'1234')
INSERT [dbo].[Users] ([UserId], [UserName], [FirstName], [LastName], [EmailId], [Password]) VALUES (3, N'Spiderman', N't', N'Sharma', N'sunil@gmail.com', N'1234')
SET IDENTITY_INSERT [dbo].[Users] OFF
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Items] FOREIGN KEY([ItemID])
REFERENCES [dbo].[Items] ([ItemID])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Items]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
/****** Object:  StoredProcedure [dbo].[GET_CustomersByName]    Script Date: 10-02-2020 16:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Mahinder Singh
-- Create date: 13-jan-2020
-- Description: Get Customer by Name
-- =============================================  
-- [dbo].[GET_CustomersByName] 'o'
CREATE PROCEDURE [dbo].[GET_CustomersByName] 
(
    @CustomerName varchar(50)
)  
AS  
BEGIN
       SELECT *  FROM [dbo].[Customers] where CustomerName Like '%'+@CustomerName+ '%' order by CustomerID	
END

GO
/****** Object:  StoredProcedure [dbo].[GET_OrderAll]    Script Date: 10-02-2020 16:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Mahinder Singh
-- Create date: 26-DEC-2019
-- Description: Order All
-- =============================================  

CREATE PROCEDURE [dbo].[GET_OrderAll] 
  
AS  
BEGIN
	   SELECT o.OrderID,o.OrderNo,o.CustomerID,o.PMethod,o.GTotal,c.CustomerName as CustomerName  FROM dbo.Orders o
	   INNER JOIN Customers c ON c.CustomerID = o.CustomerID
END

GO
/****** Object:  StoredProcedure [dbo].[GET_OrderItemByOrderId]    Script Date: 10-02-2020 16:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Mahinder Singh
-- Create date: 26-DEC-2019
-- Description: Get Order Item by OrderID
-- =============================================  
--[dbo].[GET_OrderItemByOrderId] 1
CREATE PROCEDURE [dbo].[GET_OrderItemByOrderId] 
  (
   @OrderID BigInt
  )
AS  
BEGIN
	   SELECT OI.OrderItemID,OI.OrderID,OI.ItemID,OI.Quantity,I.Name AS ItemName,I.Price,(OI.Quantity * I.Price) as Total  FROM [dbo].[OrderItems] OI
	   INNER JOIN Items I ON I.ItemID = OI.ItemID
	   WHERE  OI.OrderID = @OrderID
END

GO
/****** Object:  StoredProcedure [dbo].[Update_PasswordByID]    Script Date: 10-02-2020 16:06:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Mahinder Singh
-- Create date: 08-Nov-2019
-- Description:Update Password
-- =============================================  

Create PROCEDURE [dbo].[Update_PasswordByID] 
   (
   @UserID int,
   @Password varchar(1000)
    )  
AS  
BEGIN
	    UPDATE Users SET Password=@Password WHERE UserID=@UserID
		
END

GO
USE [master]
GO
ALTER DATABASE [PaymentDetailDataB] SET  READ_WRITE 
GO

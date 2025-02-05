USE [master]
GO
/****** Object:  Database [dbTaskManager]    Script Date: 29/07/2024 02:59:43 p. m. ******/
CREATE DATABASE [dbTaskManager]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dbTaskManager', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\dbTaskManager.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'dbTaskManager_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\dbTaskManager_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [dbTaskManager] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dbTaskManager].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [dbTaskManager] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [dbTaskManager] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [dbTaskManager] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [dbTaskManager] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [dbTaskManager] SET ARITHABORT OFF 
GO
ALTER DATABASE [dbTaskManager] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [dbTaskManager] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [dbTaskManager] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [dbTaskManager] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [dbTaskManager] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [dbTaskManager] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [dbTaskManager] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [dbTaskManager] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [dbTaskManager] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [dbTaskManager] SET  ENABLE_BROKER 
GO
ALTER DATABASE [dbTaskManager] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [dbTaskManager] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [dbTaskManager] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [dbTaskManager] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [dbTaskManager] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [dbTaskManager] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [dbTaskManager] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [dbTaskManager] SET RECOVERY FULL 
GO
ALTER DATABASE [dbTaskManager] SET  MULTI_USER 
GO
ALTER DATABASE [dbTaskManager] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [dbTaskManager] SET DB_CHAINING OFF 
GO
ALTER DATABASE [dbTaskManager] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [dbTaskManager] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [dbTaskManager] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [dbTaskManager] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'dbTaskManager', N'ON'
GO
ALTER DATABASE [dbTaskManager] SET QUERY_STORE = ON
GO
ALTER DATABASE [dbTaskManager] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [dbTaskManager]
GO
/****** Object:  Table [dbo].[tblGoals]    Script Date: 29/07/2024 02:59:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGoals](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTasks]    Script Date: 29/07/2024 02:59:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTasks](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[IsCompleted] [bit] NOT NULL,
	[IsFavorite] [bit] NOT NULL,
	[GoalID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[LineNum] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGoals] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[tblGoals] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[tblTasks] ADD  DEFAULT ((0)) FOR [IsCompleted]
GO
ALTER TABLE [dbo].[tblTasks] ADD  DEFAULT ((0)) FOR [IsFavorite]
GO
ALTER TABLE [dbo].[tblTasks] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[tblTasks] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[tblTasks]  WITH CHECK ADD  CONSTRAINT [FK_tblTasks_GoalID] FOREIGN KEY([GoalID])
REFERENCES [dbo].[tblGoals] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblTasks] CHECK CONSTRAINT [FK_tblTasks_GoalID]
GO
USE [master]
GO
ALTER DATABASE [dbTaskManager] SET  READ_WRITE 
GO

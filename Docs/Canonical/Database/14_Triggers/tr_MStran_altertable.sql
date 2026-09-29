SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger tr_MStran_altertable on database for ALTER_TABLE as 

							set ANSI_NULLS ON
							set ANSI_PADDING ON
							set ANSI_WARNINGS ON
							set ARITHABORT ON
							set CONCAT_NULL_YIELDS_NULL ON
							set NUMERIC_ROUNDABORT OFF
							set QUOTED_IDENTIFIER ON

							declare @EventData xml
							set @EventData=EventData()

							exec sys.sp_MStran_ddlrepl @EventData, 1
GO
ENABLE TRIGGER [tr_MStran_altertable] ON DATABASE
GO

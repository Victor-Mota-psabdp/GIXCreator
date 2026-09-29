SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger tr_MStran_droptable on database for DROP_TABLE as 

							set ANSI_NULLS ON
							set ANSI_PADDING ON
							set ANSI_WARNINGS ON
							set ARITHABORT ON
							set CONCAT_NULL_YIELDS_NULL ON
							set NUMERIC_ROUNDABORT OFF
							set QUOTED_IDENTIFIER ON

							declare @EventData xml
							set @EventData=EventData()

						    if object_id('dbo.sysarticles') is null or object_id('dbo.syspublications') is null or object_id('dbo.sysextendedarticlesview') is null or exists(
						       select 1
						         from @EventData.nodes('/EVENT_INSTANCE') as R(event_instance)
						        where lower(event_instance.value('SchemaName[1]', 'sysname')) in (N'sys', N'cdc')
						           or lower(event_instance.value('ObjectName[1]', 'sysname')) in (N'sysextendedarticlesview', N'sysarticles', N'syspublications')
						           or event_instance.value('ObjectName[1]', 'sysname') like N'#%'
						    ) return

							exec sys.sp_MStran_ddlrepl @EventData, 5
GO
ENABLE TRIGGER [tr_MStran_droptable] ON DATABASE
GO

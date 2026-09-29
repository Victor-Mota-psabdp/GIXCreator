SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Doc_Anexos_Temp
CREATE VIEW [dbo].[vwDoc_Anexos_Temp_Sel]
AS

		select 
			--convert(varchar(25),'Saved')	[Status],
			D.ID							[ID],
			--D.ID_House_Temp					[ID House Temp],
			D.ID_Req						[ID Req],
			D.Intl_Reference				[Intl Reference],
			D.Num_Proc						[JOB],
			
			D.Item_Doc						[Item],
			D.DMS_Code						[DMS Code],
			
			D.ID_DC							[Doc Type Code],
			tc.Nome_DC						[Doc Type],
			
			D.Nome_Arquivo					[File Name],
			
			D.cd_usuario					[User Code],
			Us.Nome_Usuario					[User],
			D.dt_ins						[Insert Date]
		from Doc_Anexos_Temp D 
		left join House_Temp H on H.ID =D.ID
		left join Tipo_Doc_Cliente TC	on TC.ID_DC  = D.ID_DC	
		left join Usuario Us	on Us.Cd_Usuario  = D.cd_usuario

GO

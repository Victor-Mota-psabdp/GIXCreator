SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPO_Temp_Sel]
AS

		select 
			H.ID						[ID],
			H.ID_Req					[ID Req],
			H.Intl_Reference			[Intl Reference],
			--HOU.ID_House_Temp,
			H.Num_Proc					[JOB],
			
			H.ID_PO_Temp				[Item],
			H.Numero_PO_Temp			[Customer Reference],
			
			H.Data_PO_Temp				[Date]					,
			H.ID_DC						[Doc Type Code],
			tc.Nome_DC					[Doc Type],
			H.Name_Reference			[Doc Type XML],
			H.cd_usuario				[User Code],
			Us.Nome_Usuario				[User],
			H.dt_ins					[Insert Date]
		from PO_Temp H
		left join Tipo_Doc_Cliente TC	on TC.ID_DC  = H.ID_DC	
		left join Usuario Us	on Us.Cd_Usuario  = H.cd_usuario

GO

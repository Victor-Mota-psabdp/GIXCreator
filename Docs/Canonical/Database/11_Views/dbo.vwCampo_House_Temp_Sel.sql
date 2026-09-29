SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ATL_INT.dbo.Campo_House_Temp
--sp_help Campo_House_Temp
CREATE VIEW [dbo].[vwCampo_House_Temp_Sel]
AS
	select 
			TT.ID_TP_House_Temp		[ID Type Aut. Def],
			TT.ID_Campo				[Code],			
			TC.Descr_Campo			[Field Description],
			TT.Update_Field			[Update Field?],
			TT.Email_to_CSR			[Send Email to CSR?],
			TT.Historic_in_JOB		[Include Historic in JOB?],
			TT.Enabled				[Enabled],
			TT.Cd_Usuario [User Code],
			US.Nome_Usuario [User Name], 
			TT.dt_ins [Insert Date]
		from 
			ATL_INT.dbo.Campo_House_Temp TT with(nolock)
			left join ATL_INT.dbo.Tipo_Campo_House_Temp TC with(nolock) on TC.ID_Campo = TT.ID_Campo	
			left join ATL_INT.dbo.Tipo_House_Temp TH with(nolock) on TH.Id_TP_House_Temp = TT.Id_TP_House_Temp	
			left join Usuario US with(nolock) on US.Cd_Usuario = TT.Cd_Usuario			





GO

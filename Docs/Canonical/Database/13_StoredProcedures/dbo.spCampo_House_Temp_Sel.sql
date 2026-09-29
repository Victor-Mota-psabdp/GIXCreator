SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ATL_INT.dbo.Campo_House_Temp
--sp_help Campo_House_Temp
CREATE procedure [dbo].[spCampo_House_Temp_Sel]
(
	@ID_TP_House_Temp		BIGINT,
	@Id_Campo				INT,
	@Tipo					char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'  or @Tipo = 'B'
	Begin
		select
			convert(varchar(25),'Saved') [Status],
			@ID_TP_House_Temp		[ID Type Aut. Def],
			TC.ID_Campo				[Code],			
			TC.Descr_Campo			[Field Description],
			TT.Update_Field			[Update Field?],
			TT.Email_to_CSR			[Send Email to CSR?],
			TT.Historic_in_JOB		[Include Historic in JOB?],
			TT.Enabled				[Enabled],
			TT.Cd_Usuario [User Code],
			US.Nome_Usuario [User Name], 
			TT.dt_ins [Insert Date]
	from ATL_INT.dbo.Tipo_Campo_House_Temp TC with (nolock)
		left join ATL_INT.dbo.Campo_House_Temp TT with (nolock) on TC.Id_Campo=TT.Id_Campo 
			and ID_TP_House_Temp=@ID_TP_House_Temp
		left join Usuario US on US.Cd_Usuario = TT.Cd_Usuario	
	order by
		2
			
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select
			convert(varchar(25),'Saved') [Status],
			ISNULL(tt.ID_TP_House_Temp,@ID_TP_House_Temp)	[ID Type Aut. Def],
			TC.ID_Campo				[Code],			
			TC.Descr_Campo			[Field Description],
			TT.Update_Field			[Update Field?],
			TT.Email_to_CSR			[Send Email to CSR?],
			TT.Historic_in_JOB		[Include Historic in JOB?],
			TT.Enabled				[Enabled],
			TT.Cd_Usuario [User Code],
			US.Nome_Usuario [User Name], 
			TT.dt_ins [Insert Date]
	from ATL_INT.dbo.Tipo_Campo_House_Temp TC with (nolock)
			left join ATL_INT.dbo.Campo_House_Temp TT with (nolock) on TC.Id_Campo=TT.Id_Campo 
			and ID_TP_House_Temp=@ID_TP_House_Temp
			left join Usuario US on US.Cd_Usuario = TT.Cd_Usuario	
		order by
		3
	End
	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select
			convert(varchar(25),'Saved') [Status],
			tt.ID_TP_House_Temp		[ID Type Aut. Def],
			TC.ID_Campo				[Code],			
			TC.Descr_Campo			[Field Description],
			TT.Update_Field			[Update Field?],
			TT.Email_to_CSR			[Send Email to CSR?],
			TT.Historic_in_JOB		[Include Historic in JOB?],
			TT.Enabled				[Enabled],
			TT.Cd_Usuario [User Code],
			US.Nome_Usuario [User Name], 
			TT.dt_ins [Insert Date]
	from ATL_INT.dbo.Tipo_Campo_House_Temp TC with (nolock)
			left join ATL_INT.dbo.Campo_House_Temp TT with (nolock) on TC.Id_Campo=TT.Id_Campo 
			--and ID_TP_House_Temp=@ID_TP_House_Temp
			left join Usuario US on US.Cd_Usuario = TT.Cd_Usuario	
		where
			TT.ID_TP_House_Temp = @ID_TP_House_Temp AND TT.ID_Campo = @ID_Campo
		order by
			TT.ID_Campo	
	End

GO

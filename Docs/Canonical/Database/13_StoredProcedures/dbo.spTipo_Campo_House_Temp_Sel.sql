SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from ATL_INT.dbo.Tipo_Campo_House_Temp
--sp_help ATL_INT.dbo.Tipo_Campo_House_Temp
CREATE procedure [dbo].[spTipo_Campo_House_Temp_Sel]
(
	@ID_Campo		INT,
	@Descr_Campo	varchar(100),
	@Tipo char(1)
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
			TT.ID_Campo [Code],TT.Descr_Campo [Field Description],TT.Ativo [Enabled],TT.Cd_Usuario [User Code],
			US.Nome_Usuario [User Name], TT.dt_ins [Insert Date]
		from 
			ATL_INT.dbo.Tipo_Campo_House_Temp TT with(nolock)
			left join Usuario US on US.Cd_Usuario = TT.Cd_Usuario			
	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			TT.ID_Campo [Code],TT.Descr_Campo [Field Description],TT.Ativo [Enabled],TT.Cd_Usuario [User Code],
			US.Nome_Usuario [User Name], TT.dt_ins [Insert Date]
		from 
			ATL_INT.dbo.Tipo_Campo_House_Temp TT with(nolock)
			left join Usuario US on US.Cd_Usuario = TT.Cd_Usuario		
		where
			TT.ID_Campo = @ID_Campo
	End
	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			TT.ID_Campo [Code],TT.Descr_Campo [Field Description],TT.Ativo [Enabled],TT.Cd_Usuario [User Code],
			US.Nome_Usuario [User Name], TT.dt_ins [Insert Date]
		from 
			ATL_INT.dbo.Tipo_Campo_House_Temp TT with(nolock)
			left join Usuario US on US.Cd_Usuario = TT.Cd_Usuario		
		where
			TT.Descr_Campo = @Descr_Campo
	End
	

	

	
GO

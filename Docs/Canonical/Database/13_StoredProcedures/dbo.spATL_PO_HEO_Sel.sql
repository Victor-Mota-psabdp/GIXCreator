SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PO_HEO
CREATE procedure [dbo].[spATL_PO_HEO_Sel]
(
	@Num_Proc_HEO	varChar(16),
	@ID_DC			int,
	@ID_PO_HEO		int,
	@Tipo			char(1)
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
			PO.Num_Proc_HEO		[JOB],	
			PO.ID_PO_HEO		[Item],
			PO.Numero_PO_HEO	[Customer Reference],	
			PO.Data_PO_HEO		[Date],
			PO.ID_DC			[Client Doc Type Code],
			DO.Nome_DC			[Client Doc Type Name],
			PO.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			PO.dt_ins			[Insert Date]
		from 
			PO_HEO PO with(nolock)
			left join Tipo_Doc_Cliente DO with(nolock) on DO.ID_DC = PO.ID_DC
			left join Usuario US with(nolock) on US.Cd_Usuario = PO.Cd_Usuario
		where
			PO.Num_Proc_HEO = @Num_Proc_HEO
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			PO.Num_Proc_HEO		[JOB],	
			PO.ID_PO_HEO		[Item],
			PO.Numero_PO_HEO	[Customer Reference],	
			PO.Data_PO_HEO		[Date],
			PO.ID_DC			[Client Doc Type Code],
			DO.Nome_DC			[Client Doc Type Name],
			PO.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			PO.dt_ins			[Insert Date]
		from 
			PO_HEO PO with(nolock)
			left join Tipo_Doc_Cliente DO with(nolock) on DO.ID_DC = PO.ID_DC
			left join Usuario US with(nolock) on US.Cd_Usuario = PO.Cd_Usuario
		where
			PO.Num_Proc_HEO = @Num_Proc_HEO and PO.ID_DC = @ID_DC
	End
	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			PO.Num_Proc_HEO		[JOB],	
			PO.ID_PO_HEO		[Item],
			PO.Numero_PO_HEO	[Customer Reference],	
			PO.Data_PO_HEO		[Date],
			PO.ID_DC			[Client Doc Type Code],
			DO.Nome_DC			[Client Doc Type Name],
			PO.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			PO.dt_ins			[Insert Date]
		from 
			PO_HEO PO with(nolock)
			left join Tipo_Doc_Cliente DO with(nolock) on DO.ID_DC = PO.ID_DC
			left join Usuario US with(nolock) on US.Cd_Usuario = PO.Cd_Usuario
		where
			PO.Num_Proc_HEO = @Num_Proc_HEO and PO.ID_PO_HEO = @ID_PO_HEO
	End

GO

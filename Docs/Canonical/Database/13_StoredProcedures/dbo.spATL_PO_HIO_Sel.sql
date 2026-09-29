SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PO_HIO
CREATE procedure [dbo].[spATL_PO_HIO_Sel]
(
	@Num_Proc_HIO	varChar(16),
	@ID_DC			int,
	@ID_PO_HIO		int,
	@Tipo		char(1)
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
			PO.Num_Proc_HIO		[JOB],	
			PO.ID_PO_HIO		[Item],
			PO.Numero_PO_HIO	[Customer Reference],	
			PO.Data_PO_HIO		[Date],
			PO.ID_DC			[Client Doc Type Code],
			DO.Nome_DC			[Client Doc Type Name],
			PO.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			PO.dt_ins			[Insert Date]
		from 
			PO_HIO PO with(nolock)
			left join Tipo_Doc_Cliente DO with(nolock) on DO.ID_DC = PO.ID_DC
			left join Usuario US with(nolock) on US.Cd_Usuario = PO.Cd_Usuario
		where
			PO.Num_Proc_HIO = @Num_Proc_HIO
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			PO.Num_Proc_HIO		[JOB],	
			PO.ID_PO_HIO		[Item],
			PO.Numero_PO_HIO	[Customer Reference],	
			PO.Data_PO_HIO		[Date],
			PO.ID_DC			[Client Doc Type Code],
			DO.Nome_DC			[Client Doc Type Name],
			PO.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			PO.dt_ins			[Insert Date]
		from 
			PO_HIO PO with(nolock)
			left join Tipo_Doc_Cliente DO with(nolock) on DO.ID_DC = PO.ID_DC
			left join Usuario US with(nolock) on US.Cd_Usuario = PO.Cd_Usuario
		where
			PO.Num_Proc_HIO = @Num_Proc_HIO and PO.ID_DC = @ID_DC
	End
	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			PO.Num_Proc_HIO		[JOB],	
			PO.ID_PO_HIO		[Item],
			PO.Numero_PO_HIO	[Customer Reference],	
			PO.Data_PO_HIO		[Date],
			PO.ID_DC			[Client Doc Type Code],
			DO.Nome_DC			[Client Doc Type Name],
			PO.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			PO.dt_ins			[Insert Date]
		from 
			PO_HIO PO with(nolock)
			left join Tipo_Doc_Cliente DO with(nolock) on DO.ID_DC = PO.ID_DC
			left join Usuario US with(nolock) on US.Cd_Usuario = PO.Cd_Usuario
		where
			PO.Num_Proc_HIO = @Num_Proc_HIO and PO.ID_PO_HIO = @ID_PO_HIO
	End

GO

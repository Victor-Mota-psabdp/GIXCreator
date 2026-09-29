SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Courier_Processo
CREATE procedure [dbo].[spATL_Courier_Processo_Sel]
(
	@Num_Proc varchar(16),
	@ID_Tp_Courier int,
	@Cd_Pes varchar(10),
	@Num_Courier varchar(50),
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
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A'  or @Tipo = 'B'
	Begin
		select 
			C.ID				[ID],
			C.ID_Item			[ID_Item],
			C.Num_Proc			[JOB],
			T.ID_Tp_Courier		[Courier Type Code],
			Nome_Tp_Courier		[Courier Type Name],
			C.Cd_Pes			[Client Code],
			P.Apelido			[Client Name],
			Num_Courier			[Courier Number],
			C.Dt_Courier		[Courier Date],
			C.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			C.Dt_Ins			[Insert Date]	

		from 
			dbo.Courier_Processo C with(nolock)
			join Tipo_Courier	 T with(nolock) on C.ID_Tp_Courier = T.ID_Tp_Courier
			join Pessoa			 P with(nolock) on C.Cd_Pes = P.Cd_Pes
			left join Usuario	US with(nolock) on US.Cd_Usuario = C.Cd_Usuario
		where
			C.Num_Proc = @Num_Proc 
			and C.ID_Tp_Courier = @ID_Tp_Courier 
			and C.Cd_Pes = @Cd_Pes 
			and C.Num_Courier = @Num_Courier 
	End	


if @Tipo = 'C'  or @Tipo = 'D' 
	Begin
		select 
			C.ID				[ID],
			C.ID_Item			[ID_Item],
			C.Num_Proc			[JOB],
			T.ID_Tp_Courier		[Courier Type Code],
			Nome_Tp_Courier		[Courier Type Name],
			C.Cd_Pes			[Client Code],
			P.Apelido			[Client Name],
			Num_Courier			[Courier Number],
			C.Dt_Courier		[Courier Date],
			C.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			C.Dt_Ins			[Insert Date]	

		from 
			dbo.Courier_Processo C with(nolock)
			join Tipo_Courier	 T with(nolock) on C.ID_Tp_Courier = T.ID_Tp_Courier
			join Pessoa			 P with(nolock) on C.Cd_Pes = P.Cd_Pes
			left join Usuario	US with(nolock) on US.Cd_Usuario = C.Cd_Usuario
		where
			C.Num_Proc = @Num_Proc 
			and C.ID_Tp_Courier = @ID_Tp_Courier 
			and C.Cd_Pes = @Cd_Pes 
	End
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			C.ID				[ID],
			C.ID_Item			[ID_Item],
			C.Num_Proc			[JOB],
			T.ID_Tp_Courier		[Courier Type Code],
			Nome_Tp_Courier		[Courier Type Name],
			C.Cd_Pes			[Client Code],
			P.Apelido			[Client Name],
			Num_Courier			[Courier Number],
			C.Dt_Courier		[Courier Date],
			C.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			C.Dt_Ins			[Insert Date]	

		from 
			dbo.Courier_Processo C with(nolock)
			join Tipo_Courier	 T with(nolock) on C.ID_Tp_Courier = T.ID_Tp_Courier
			join Pessoa			 P with(nolock) on C.Cd_Pes = P.Cd_Pes
			left join Usuario	US with(nolock) on US.Cd_Usuario = C.Cd_Usuario
		where
			C.Num_Proc = @Num_Proc 
			and C.ID_Tp_Courier = @ID_Tp_Courier 
			and C.Cd_Pes = @Cd_Pes 
			and C.Num_Courier = @Num_Courier 
	End

	
--if @Tipo = 'Z'-- or @Tipo = 'O'
--	Begin
--		select 
--			ID_Tp_Courier  [Code],			
--			Nome_Tp_Courier	[Courier Type Name],
--			[Status]		[Enabled] 
--		from 
--			Courier_Processo with(nolock)
--		where 
--			Nome_Tp_Courier = @Nome_Tp_Courier
--			 and ID_Tp_Courier <> @ID_Tp_Courier		
--	End

GO

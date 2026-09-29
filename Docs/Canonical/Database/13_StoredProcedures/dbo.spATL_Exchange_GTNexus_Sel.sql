SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Envio_GIX
CREATE procedure [dbo].[spATL_Exchange_GTNexus_Sel]
(
	@ID				BigInt,
	@Num_Proc		varchar(16),	
	@cd_tp_gix		varchar(2),
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
Z /// Verifica Nome X Codigo
*/

if @Tipo = 'A'  or @Tipo = 'B'
	Begin
		select 
			E.ID				[ID],
			E.Num_Proc			[JOB],
			E.Type				[GIX Type Code],
			T.Nome_Tp_Gix		[GIX Type Name],
			E.Dt_Ins			[Insert Date],
			E.Dt_Send			[Send Date],
			E.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			US.Email			[User Email],
			E.Tipo_Envio		[Gix Send Type Code],
			G.Nome_Tp_EnvioGix		[Gix Send Type Name]
			,E.Num_Proc [Processo]
		from dbo.Exchange_GTNexus E with(nolock)
			left join Tipo_Gix T on T.cd_tp_gix = E.type
			left join Tipo_Envio_GIX G on G.Cd_Tp_EnvioGix = E.Tipo_Envio
			left join Usuario	US with(nolock) on US.Cd_Usuario = E.Cd_Usuario
		where
			--E.ID = @ID
			E.Type = @cd_tp_gix
			and E.Dt_send is null
			
	End	


if @Tipo = 'C'  or @Tipo = 'D' 
	Begin
		select 
			E.ID				[ID],
			E.Num_Proc			[JOB],
			E.Type				[GIX Type Code],
			T.Nome_Tp_Gix		[GIX Type Name],
			E.Dt_Ins			[Insert Date],
			E.Dt_Send			[Send Date],
			E.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			US.Email			[User Email],
			E.Tipo_Envio		[Gix Send Type Code],
			G.Nome_Tp_EnvioGix		[Gix Send Type Name]
			,E.Num_Proc [Processo]
		from dbo.Exchange_GTNexus E with(nolock)
			left join Tipo_Gix T on T.cd_tp_gix = E.type
			left join Tipo_Envio_GIX G on G.Cd_Tp_EnvioGix = E.Tipo_Envio
			left join Usuario	US with(nolock) on US.Cd_Usuario = E.Cd_Usuario
		where
			E.Num_Proc = @num_proc and E.Type = @cd_tp_gix
	End

if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			E.ID				[ID],
			E.Num_Proc			[JOB],
			E.Type				[GIX Type Code],
			T.Nome_Tp_Gix		[GIX Type Name],
			E.Dt_Ins			[Insert Date],
			E.Dt_Send			[Send Date],
			E.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			US.Email			[User Email],
			E.Tipo_Envio		[Gix Send Type Code],
			G.Nome_Tp_EnvioGix		[Gix Send Type Name]
			,E.Num_Proc [Processo]
		from dbo.Exchange_GTNexus E with(nolock)
			left join Tipo_Gix T on T.cd_tp_gix = E.type
			left join Tipo_Envio_GIX G on G.Cd_Tp_EnvioGix = E.Tipo_Envio
			left join Usuario	US with(nolock) on US.Cd_Usuario = E.Cd_Usuario
		where
			E.Num_Proc = @num_proc and E.Type = @cd_tp_gix
	End


GO

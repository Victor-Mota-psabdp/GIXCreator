SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Exchange_E_AirFreight
CREATE procedure [dbo].[spATL_Exchange_E_AirFreight_Sel]
(
	@ExcId					BigInt,
	@Num_Proc_Mea			varchar(14),
	@Num_Proc_Hea			varchar(16),
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
Z /// Verifica Nome X Codigo
*/

if @Tipo = 'A'
	Begin
		select 				
			ExcId					[ID],
			Num_Proc_Mea			[MasterJOB],
			Num_Proc_Hea			[JOB],
			Num_Proc_Mea_Dt_Ins		[Insert Master Date],
			Num_Proc_Mea_Dt_Envio	[Sent Master Date],
			Num_Proc_Hea_Dt_Envio	[Sent House Date],
			Num_Proc_Hea_Dt_Ins		[Insert House Date]
		from 
			dbo.Exchange_E_AirFreight E with(nolock)
	End

if  @Tipo = 'B'
	Begin
		select 				
			ExcId					[ID],
			Num_Proc_Mea			[MasterJOB],
			Num_Proc_Hea			[JOB],
			Num_Proc_Mea_Dt_Ins		[Insert Master Date],
			Num_Proc_Mea_Dt_Envio	[Sent Master Date],
			Num_Proc_Hea_Dt_Envio	[Sent House Date],
			Num_Proc_Hea_Dt_Ins		[Insert House Date]
		from 
			dbo.Exchange_E_AirFreight E with(nolock)
		Where
			E.ExcId = @ExcId
	End	


if @Tipo = 'C'  or @Tipo = 'D' 
	Begin
		select 				
			ExcId					[ID],
			Num_Proc_Mea			[MasterJOB],
			Num_Proc_Hea			[JOB],
			Num_Proc_Mea_Dt_Ins		[Insert Master Date],
			Num_Proc_Mea_Dt_Envio	[Sent Master Date],
			Num_Proc_Hea_Dt_Envio	[Sent House Date],
			Num_Proc_Hea_Dt_Ins		[Insert House Date]
		from 
			dbo.Exchange_E_AirFreight E with(nolock)	
		where
			E.Num_Proc_Mea = @Num_Proc_Mea
	End

if @Tipo = 'D' 
	Begin
		select 				
			ExcId					[ID],
			Num_Proc_Mea			[MasterJOB],
			Num_Proc_Hea			[JOB],
			Num_Proc_Mea_Dt_Ins		[Insert Master Date],
			Num_Proc_Mea_Dt_Envio	[Sent Master Date],
			Num_Proc_Hea_Dt_Envio	[Sent House Date],
			Num_Proc_Hea_Dt_Ins		[Insert House Date]
		from 
			dbo.Exchange_E_AirFreight E with(nolock)	
		where
			E.Num_Proc_Hea = @Num_Proc_Hea
	End

if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 				
			ExcId					[ID],
			Num_Proc_Mea			[MasterJOB],
			Num_Proc_Hea			[JOB],
			Num_Proc_Mea_Dt_Ins		[Insert Master Date],
			Num_Proc_Mea_Dt_Envio	[Sent Master Date],
			Num_Proc_Hea_Dt_Envio	[Sent House Date],
			Num_Proc_Hea_Dt_Ins		[Insert House Date]
		from 
			dbo.Exchange_E_AirFreight E with(nolock)	
		where
			E.Num_Proc_Hea = @Num_Proc_Hea and E.Num_Proc_Mea = @Num_Proc_Mea
	End


GO

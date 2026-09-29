SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_jobExport_Sel]
(
	@ID_jobExport bigint,
	@numero_pedido varchar(200),
	@num_Proc varchar(200),
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
sp_help Tipo_Modal
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			S.ID_jobExport [Internal Code],
			S.cd_pedido,
			S.numero_pedido,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_jobExport S with(nolock)	
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
			select 
			S.ID_jobExport [Internal Code],
			S.cd_pedido,
			S.numero_pedido,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_jobExport S with(nolock)	
		where 
			ID_jobExport = @ID_jobExport
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
			select 
			S.ID_jobExport [Internal Code],
			S.cd_pedido,
			S.numero_pedido,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_jobExport S with(nolock)	
		where 
			numero_pedido = @numero_pedido
	End

if @Tipo = 'P'
	Begin
			select 
			S.ID_jobExport [Internal Code],
			S.cd_pedido,
			S.numero_pedido,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
		from 
			ATL_INT.dbo.JSON_Oxiteno_jobExport S with(nolock)	
		Where
			S.Dt_Sent is null		
	End
	



GO

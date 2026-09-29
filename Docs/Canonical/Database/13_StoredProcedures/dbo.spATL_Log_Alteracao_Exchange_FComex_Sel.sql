SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spATL_Log_Alteracao_Exchange_FComex_Sel]
(		@Id bigint,
		@Exchange_id bigint,
		@Id_Empresa  bigint,
        @Num_Proc   varchar(16),
		@Tipo		varchar(1)
)
as
/* Tipo de Processo 
   P processos pelo numproc do fcomex  
*/
	if @Tipo ='P'
		BEGIN
			select 
			     lg.Id, 
				 lg.Exchange_id,
				 lg.Num_Proc,
				 lg.processo,
				 lg.Lido_Processo,
				 lg.Dt_Leitura_Processo,
				 lg.Dt_Fim_Processo,
				 lg.processo_id,
 	   		     lg.Id_Empresa,
				 ef.nome_empresa,
				 lg.Cd_Usuario,
				 us.Nome_Usuario,
				 lg.Dt_Ins
			from Log_Alteracao_Exchange_FComex lg with(nolock)
			join ATL_INT.dbo.Empresa_FComex ef with(nolock)   
			on lg.Id_Empresa = ef.Id_Empresa
			join Usuario us with(nolock)
			on us.Cd_Usuario = lg.Cd_Usuario
			where num_proc = @Num_Proc
		END


GO

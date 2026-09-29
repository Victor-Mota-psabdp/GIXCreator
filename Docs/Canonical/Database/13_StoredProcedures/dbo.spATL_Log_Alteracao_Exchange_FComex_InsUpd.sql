SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_Log_Alteracao_Exchange_FComex_InsUpd]
		@Id bigint ,
		@Exchange_id bigint,
		@Processo_id bigint,
        @Num_Proc   varchar(16),
        @Lido_Processo bit,
        @Dt_Leitura_Processo datetime,
		@Dt_Fim_Processo datetime,
		@Id_Empresa bigint,
	    @Processo   varchar(16),
		@Cd_Usuario varchar(10)
AS

--sp_help Log_Alteracao_Exchange_FComex
Begin Transaction
		if not exists(select num_proc from Log_Alteracao_Exchange_FComex  where num_proc = @Num_Proc and Processo = @Processo)
			begin 
    			Insert into Log_Alteracao_Exchange_FComex 
				(
					Exchange_id,Processo_id,Num_Proc,Lido_Processo,Dt_Leitura_Processo,Dt_Fim_Processo,Id_Empresa,Processo,Cd_Usuario,Dt_Ins
				)
	 			Values			
				(
					@Exchange_id,@Processo_id,@Num_Proc,@Lido_Processo,@Dt_Leitura_Processo,@Dt_Fim_Processo,@Id_Empresa,@Processo,@Cd_Usuario,getdate()
				)
			end 

if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction
GO

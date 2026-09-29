SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec spExchange_Alerta_Ins @Num_Proc,1,'ETA_Lem',@Dados_Alterados
CREATE Procedure [dbo].[spExchange_Alerta_Ins]

	@Num_Proc		VARCHAR(16),
	@Id_TP_Alerta	bigint,
	@Campo			VARCHAR(250),
	@Dados_Alterados varchar(max)
AS

	if exists(select Num_Proc_HEM from House_Exp_Mar Hou with(nolock) 
				where Num_Proc_HEM =@Num_Proc and Num_Proc_MEM <> 'JOB')
		Begin
			insert into [dbo].[Exchange_Alerta](Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados) 
			values (@Num_Proc,@Id_TP_Alerta,getdate(),@Campo,@Dados_Alterados)
		End





















GO

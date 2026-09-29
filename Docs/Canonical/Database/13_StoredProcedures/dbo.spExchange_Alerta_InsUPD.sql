SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spExchange_Alerta_InsUPD]

	@Num_Proc		VARCHAR(16),
	@Id_TP_Alerta	bigint,
	@Campo			VARCHAR(250),
	@Dados_Alterados varchar(max)
AS

	Begin
		insert into [dbo].[Exchange_Alerta](Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados) 
		values (@Num_Proc,@Id_TP_Alerta,getdate(),@Campo,@Dados_Alterados)
	End





















GO

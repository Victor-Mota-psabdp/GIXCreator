SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create TRIGGER [dbo].[TrgCustoCliente_Del] ON [dbo].[Custo_Cliente] 
FOR DELETE
AS
	Declare @Processo	varchar(16)
	Select @Processo = Num_Proc from deleted  
	Declare @Cd_Tp_Tx	varchar(3)
	Select @Cd_Tp_Tx = Cd_tp_tx from deleted  
	
	if @Processo is not null and @Cd_Tp_Tx in ('AFR','XAM','XAD','SIS','TXS')
		Begin
			delete Custo_Processo where Num_Proc = @Processo and Cd_Tp_Tx = @Cd_Tp_Tx
	
		End
GO
ALTER TABLE [dbo].[Custo_Cliente] ENABLE TRIGGER [TrgCustoCliente_Del]
GO

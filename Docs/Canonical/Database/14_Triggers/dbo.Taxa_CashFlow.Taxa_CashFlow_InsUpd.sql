SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create TRIGGER [dbo].[Taxa_CashFlow_InsUpd] ON [dbo].[Taxa_CashFlow] 
FOR INSERT,UPDATE
AS
	
	insert Log_Taxa_CashFlow
	Select 	Cd_Tp_Tx,
			ID_TypeExpense,
			Dt_Insert,
			Cd_Usuario From Inserted Ins


GO
ALTER TABLE [dbo].[Taxa_CashFlow] ENABLE TRIGGER [Taxa_CashFlow_InsUpd]
GO

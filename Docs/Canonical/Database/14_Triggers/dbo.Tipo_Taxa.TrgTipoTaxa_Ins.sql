SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER TrgTipoTaxa_Ins ON dbo.Tipo_Taxa 
FOR INSERT
AS
	Declare @Cd_Tp_Tx 	VarChar(3)
	Set @Cd_Tp_Tx = (Select Cd_Tp_Tx From Inserted Ins )
	Update Tipo_Taxa Set Cd_Tp_Tx_Ofc = Cd_Tp_Tx Where Cd_Tp_Tx = @Cd_Tp_Tx

GO
ALTER TABLE [dbo].[Tipo_Taxa] ENABLE TRIGGER [TrgTipoTaxa_Ins]
GO

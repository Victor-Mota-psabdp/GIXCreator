SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_ReenviaAXXML_Del]
(
	@IDAX bigint,
	@Num_Proc Varchar(16),
	@Nome_Tp_Tx Varchar(50),
	@DC Varchar(1),
	@Cancel bit,
	@Cd_Usuario varchar(6)
)
as
Begin Transaction
	Declare @Cd_Tp_Tx_ATL varchar(3)

	Set @Cd_Tp_Tx_ATL = (select Cd_Tp_Tx from Tipo_Taxa with(nolock) where Nome_Tp_Tx = @Nome_Tp_Tx)

	delete AX_DOC_XML_NEW where ID_AX = @IDAX and Num_Proc = @Num_Proc and Cd_tp_Tx_ATL = @Cd_Tp_Tx_ATL and DC = @DC and Cancel = @Cancel

	insert  LOG_AX_DOC_XML
			(
			ID_AX,
			Num_Proc,
			Cd_Tp_TX_aTL,
			DC,
			Cancel,
			Cd_Usuario,
			Dt_Ins
			)
			values
			(
			@IDAX,
			@Num_Proc,
			@Cd_Tp_TX_aTL,
			@DC,
			@Cancel,
			@Cd_Usuario,
			Getdate()
			)
Commit Transaction
GO

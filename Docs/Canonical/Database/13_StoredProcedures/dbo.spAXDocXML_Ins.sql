SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spAXDocXML_Ins]
	(
		@ID_AX bigint,
		@Num_Proc	Varchar(16),	
		@Cd_tp_Tx_ATL	VArchar(10),
		@DC				Varchar(1),
		@Cancel			bit,
		@XML_DOC		XML,
		@Nome_Arquivo	Varchar(75)
	)
	as
Begin

	
		Insert AX_DOC_XML_NEW
			(ID_AX,Num_Proc,Cd_tp_Tx_ATL,DC,Cancel,Dt_Envio,XML_DOC,Nome_Arquivo)
		Values
			(@ID_AX,@Num_Proc,@Cd_tp_Tx_ATL,@DC,@Cancel,GETDATE(),@XML_DOC,@Nome_Arquivo)
End
GO

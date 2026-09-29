SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spMQ_Envio_AX_DOC_XML_Sel]
AS
	select 
		ID_AX, 
		Num_Proc,
		Cd_tp_Tx_ATL,
		DC, 
		Cancel,
		Dt_Envio,
		XML_DOC,
		Nome_Arquivo 
		from AX_DOC_XML_NEW
	where 
		Dt_Envio >=getdate()-0.020833 
		--Dt_Envio is null		
		

























GO

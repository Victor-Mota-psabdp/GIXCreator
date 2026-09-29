SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spSmartXMLODSV2_Ins]
	(
		@Num_Proc	Varchar(16),	
		@XML_DOC		varchar(Max),
		@Nome_Arquivo	Varchar(75)
	)
	as
Begin
	Insert ATL_INT.dbo.Smart_XML_V2 
		(Num_Proc,XML_DOC,Nome_Arquivo,Dt_Ins,Dt_Envio)
	Values
		(@Num_Proc,@XML_DOC,@Nome_Arquivo,GETDATE(),NULL)
End

GO

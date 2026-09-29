SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create Procedure [dbo].[spSmartXMLODS_Ins]
	(
		@Num_Proc	Varchar(16),	
		@XML_DOC		nvarchar(MAX),
		@Nome_Arquivo	Varchar(75)
	)
	as
Begin
	Insert ATL_INT.dbo.Smart_XML 
		(Num_Proc,XML_DOC,Nome_Arquivo,Dt_Ins,Dt_Envio)
	Values
		(@Num_Proc,@XML_DOC,@Nome_Arquivo,GETDATE(),NULL)
End

GO

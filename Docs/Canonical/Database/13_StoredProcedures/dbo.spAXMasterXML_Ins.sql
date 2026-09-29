SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spAXMasterXML_Ins]
	(
		
		@Num_Proc	Varchar(16),	
		@Tipo		varchar(1),
		@XML_DOC		XML,
		@Nome_Arquivo	Varchar(100),
		@MessageId varchar(500)
	)
	as
Begin
Declare @ID_AX bigint
	set @ID_AX = (select isnull(MAX(ID_AX),0)+1 from AX_Master_XML)

	Insert AX_Master_XML 
		(ID_AX,Num_Proc,Tipo,Dt_Envio,XML_DOC,Nome_Arquivo,MessageId)
	Values
		(@ID_AX,@Num_Proc,@Tipo,GETDATE(),@XML_DOC,@Nome_Arquivo,@MessageId)
End
GO

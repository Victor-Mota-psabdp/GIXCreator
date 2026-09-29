SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spAX_DOC_XML_Oracle_Ins]
	(
		@ID_AX bigint,		
		@Cancel			bit,
		@XML_DOC		XML,
		@Nome_Arquivo	Varchar(250)
	)
	as
Begin

	
		Insert AX_DOC_XML_Oracle
			(ID_AX,Cancel,Dt_Envio,XML_DOC,Nome_Arquivo)
		Values
			(@ID_AX,@Cancel,GETDATE(),@XML_DOC,@Nome_Arquivo)
End
GO

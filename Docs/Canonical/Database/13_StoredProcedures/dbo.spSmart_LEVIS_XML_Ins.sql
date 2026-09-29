SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSmart_LEVIS_XML_Ins]
	(
		@Num_Proc	Varchar(16),	
		@XML_DOC		nvarchar(MAX),
		@Nome_Arquivo	Varchar(75),
		@ISD_Number		varchar(200)
	)
	as

	Begin
		Insert Smart_Levis_XML 
			(Num_Proc,XML_DOC,Nome_Arquivo,Dt_Ins,Dt_Envio,ISD_Number)
		Values
			(@Num_Proc,@XML_DOC,@Nome_Arquivo,GETDATE(),NULL,@ISD_Number)
	End


GO

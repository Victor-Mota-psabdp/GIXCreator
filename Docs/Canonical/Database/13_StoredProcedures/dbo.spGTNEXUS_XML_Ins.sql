SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create Procedure [dbo].[spGTNEXUS_XML_Ins]
	(
		@ID_GTNEXUS	bigint,
		@Num_Proc	Varchar(16),	
		@Type		Varchar(2),
		@XML_DOC		nvarchar(MAX),
		@Nome_Arquivo	Varchar(75)
	)
	as
Begin
	Insert GTNEXUS_XML 
		(ID_GTNEXUS,Num_Proc,Type,XML_DOC,Nome_Arquivo,Dt_Ins,Dt_Envio)
	Values
		(@ID_GTNEXUS,@Num_Proc,@Type,@XML_DOC,@Nome_Arquivo,GETDATE(),NULL)
End

GO

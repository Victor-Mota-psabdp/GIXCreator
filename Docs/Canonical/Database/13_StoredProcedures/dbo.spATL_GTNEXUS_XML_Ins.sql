SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_HELP GTNEXUS_XML
CREATE Procedure [dbo].[spATL_GTNEXUS_XML_Ins]
(
	@ID_Smart			bigint,	
	@Id_GTNexus			bigint,
	@Num_Proc			Varchar(16),	
	@Type				Varchar(2),		
	--@XML_DOC2			XML,
	@XML_DOC			nvarchar(MAX),
	@Nome_Arquivo		Varchar(100),
	@Dt_Ins				Datetime,
	@Dt_Envio			Datetime
)
	as
Begin
	Insert GTNEXUS_XML 
	(
		Id_GTNexus,Num_Proc,Type,XML_DOC,Nome_Arquivo,Dt_Ins,Dt_Envio
	)
	Values
	(
		@Id_GTNexus,@Num_Proc,@Type,@XML_DOC,@Nome_Arquivo,getdate(),NULL
	)	
End

--Insert GTNEXUS_XML 
--	(
--		Id_GTNexus,Num_Proc,Type,XML_DOC,XML_DOC2,Nome_Arquivo,Dt_Ins,Dt_Envio
--	)
--	Values
--	(
--		@Id_GTNexus,@Num_Proc,@Type,@XML_DOC,@XML_DOC2,@Nome_Arquivo,getdate(),NULL
--	)	

GO

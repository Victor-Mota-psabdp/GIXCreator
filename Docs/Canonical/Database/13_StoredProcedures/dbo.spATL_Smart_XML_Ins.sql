SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--SP_HELP Smart_XML
CREATE Procedure [dbo].[spATL_Smart_XML_Ins]
(
	@ID_Smart			bigint,	
	@Num_Proc			varchar(16),
	@XML_DOC			nvarchar(MAX),
	@Nome_Arquivo		Varchar(100),
	@Dt_Ins				Datetime,
	@Dt_Envio			Datetime
)
	as
Begin
	Insert ATL_INT.dbo.Smart_XML 
	(
		Num_Proc,XML_DOC,Nome_Arquivo,Dt_Ins,Dt_Envio
	)
	Values
	(
		@Num_Proc,@XML_DOC,@Nome_Arquivo,getdate(),NULL
	)		
End

--Insert Smart_XML 
--	(
--		Id_GTNexus,Num_Proc,Type,XML_DOC,XML_DOC2,Nome_Arquivo,Dt_Ins,Dt_Envio
--	)
--	Values
--	(
--		@Id_GTNexus,@Num_Proc,@Type,@XML_DOC,@XML_DOC2,@Nome_Arquivo,getdate(),NULL
--	)	

GO

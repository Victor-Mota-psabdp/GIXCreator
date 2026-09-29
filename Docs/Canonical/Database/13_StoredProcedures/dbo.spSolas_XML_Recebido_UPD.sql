SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSolas_XML_Recebido_UPD]
(	
	@Nome_Arquivo		Varchar(200),	
	@XML_DOC_Retorno	nvarchar(MAX),
	@ForwarderReferenceNumber varchar(16)
)
as
	Begin
		if exists(select [Nome_Arquivo] from [Solas_XML_Recebido] where [Nome_Arquivo] = @Nome_Arquivo
		 and ForwarderReferenceNumber = @ForwarderReferenceNumber)
			update [Solas_XML_Recebido] 
				set 
					XML_DOC_Retorno = @XML_DOC_Retorno					
				where
					[Nome_Arquivo] = @Nome_Arquivo and
					ForwarderReferenceNumber = @ForwarderReferenceNumber
	End

GO

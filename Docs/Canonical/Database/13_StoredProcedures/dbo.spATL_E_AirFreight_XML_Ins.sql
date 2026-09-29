SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_E_AirFreight_XML_Ins]
(
	@ID_AirFreight		bigint,	
	@Num_Proc			varchar(16),
	@HAWB_MAWB			varchar(50),
	@XML_DOC			nvarchar(MAX),
	@Nome_Arquivo		Varchar(100),	
	@Dt_Envio			Datetime,
	@Status_Envio		varchar(500),
	@XML_DOC_XML_Retorno xml,
	@Dt_Ins_Retorno		datetime,
	@XML_DOC_Retorno	varchar(MAX)
)
	as
	Begin
		Insert E_AirFreight_XML 
			(
				Num_Proc,HAWB_MAWB,XML_DOC,Nome_Arquivo,Dt_Envio,Status_Envio,XML_DOC_XML_Retorno,Dt_Ins_Retorno,XML_DOC_Retorno
			)
			Values
			(
				@Num_Proc,@HAWB_MAWB,@XML_DOC,@Nome_Arquivo,@Dt_Envio,@Status_Envio,@XML_DOC_XML_Retorno,@Dt_Ins_Retorno,@XML_DOC_Retorno
			)	
	End


GO

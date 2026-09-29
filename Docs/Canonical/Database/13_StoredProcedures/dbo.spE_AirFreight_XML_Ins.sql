SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spE_AirFreight_XML_Ins]
	(
		@Num_Proc		Varchar(16),
		@HAWB_MAWB		Varchar(50),	
		@XML_DOC		nvarchar(MAX),
		--@XML_DOC_XML	XML,
		@Nome_Arquivo	Varchar(500),
		@Status_Envio	Varchar(500)
		
	)
	as
Begin
	Insert E_AirFreight_XML 
		--(Num_Proc,HAWB_MAWB,XML_DOC,XML_DOC_XML,Nome_Arquivo,Dt_Ins,Dt_Envio)
		(Num_Proc,HAWB_MAWB,XML_DOC,Nome_Arquivo,Dt_Envio,Status_Envio)
	Values
		--(@Num_Proc,@HAWB_MAWB,@XML_DOC,@XML_DOC_XML,@Nome_Arquivo,GETDATE(),NULL)
		(@Num_Proc,@HAWB_MAWB,@XML_DOC,@Nome_Arquivo,GETDATE(),@Status_Envio)
End

BEGIN
	if len(@Num_Proc) = 14	
		update Exchange_E_AirFreight set Num_Proc_Mea_Dt_Envio = Getdate() where num_proc_mea = @Num_Proc
	else
		update Exchange_E_AirFreight set Num_Proc_Hea_Dt_Envio = Getdate() where Num_Proc_Hea = @Num_Proc
END
GO

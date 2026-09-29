SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table [dbo].[E_AirFreight_XML_Recebido] add [XML_DOC] [varchar](max) NULL
--alter table [dbo].[E_AirFreight_XML_Recebido] add [Dt_Ins_XML] [DateTime] NULL

--sp_help E_AirFreight_XML_Recebido

CREATE Procedure [dbo].[spE_AirFreight_XML_Recebido_UPD]
(	
	@HAWB_MAWB		Varchar(50),
	@Nome_Arquivo	Varchar(200),	
	@XML_DOC		nvarchar(MAX)
)
as
	Begin
		if exists(select * from E_AirFreight_XML_Recebido 
			where Nome_Arquivo = @Nome_Arquivo and HAWB_MAWB = @HAWB_MAWB)
			update E_AirFreight_XML_Recebido 
				set 
					XML_DOC = @XML_DOC,					
					Dt_Ins_XML = getdate()
				where
					Nome_Arquivo = @Nome_Arquivo and
					HAWB_MAWB = @HAWB_MAWB		
		
	End

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from E_AirFreight_XML_Recebido
--select * from E_AirFreight_XML
--where HAWB_MAWB =
--'057-28413313'
--'125-75366686'

--sp_help E_AirFreight_XML

--alter table [dbo].[E_AirFreight_XML] add [XML_DOC_Retorno] [varchar](max) NULL

CREATE Procedure [dbo].[spE_AirFreight_XML_UPD]
(	
	@HAWB_MAWB		Varchar(50),	
	@XML_DOC_Retorno	nvarchar(MAX)
)
as
	Begin
		if exists(select * from E_AirFreight_XML where HAWB_MAWB = @HAWB_MAWB)
			update E_AirFreight_XML 
				set 
					XML_DOC_Retorno = @XML_DOC_Retorno,
					Dt_Ins_Retorno = getdate()
				where
					--Num_Proc = @Num_Proc
					HAWB_MAWB = @HAWB_MAWB
	End

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_IBRokerTXT_Ins 'IMGVD201503002BR'
CREATE procedure [dbo].[spATL_IBRokerTXT_Ins] (
@Processo varchar(16)
)
as

Declare @ITDI table
(
	ID_ITDI bigint
)

declare @ID_ITDI bigint
--Gera o cabeçalho
insert @ITDI
exec [dbo].[spATL_IBrokerITDI_SelIns]
set @ID_ITDI = (select ID_ITDI from @ITDI)

--Gera CAPI
exec [dbo].[spATL_IBrokerCAPI_SelIns] @ID_ITDI, @Processo

--Gera CAP2
exec [dbo].[spATL_IBrokerCAP2_SelIns] @ID_ITDI, @Processo

--Gera ITEA
exec [dbo].[spATL_IBrokerITEA_SelIns] @ID_ITDI, @Processo

--Gera ITEB
exec [dbo].[spATL_IBrokerITEB_SelIns] @ID_ITDI, @Processo

--Gera DPnn
exec [dbo].[spATL_IBrokerDPnn_SelIns] @ID_ITDI, @Processo

--Gera AG4A
exec [dbo].[spATL_IBrokerAG4A_SelIns] @ID_ITDI, @Processo

--Gera FTDI
exec [dbo].[spATL_IBrokerFTDI_SelIns] @ID_ITDI

--Gera TXT
exec [dbo].[spATL_IBrokerTXT_Sel] @ID_ITDI

--LOG
exec [dbo].[spATL_IBrokerLog_Ins] @Processo,'ATL',NULL
 print @ID_ITDI

GO

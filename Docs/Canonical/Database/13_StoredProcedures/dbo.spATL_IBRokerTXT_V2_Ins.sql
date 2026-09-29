SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_IBRokerTXT_V2_Ins 'IAGVD201505035BR'
CREATE procedure [dbo].[spATL_IBRokerTXT_V2_Ins] (
@Processo varchar(16),
@Cd_Usuario varchar(6)
)
as

Declare @ID_View bigint

set @ID_View =(Select ID from IBROKER_CAPI_V2 where JOB = @Processo and status =1 and Status_Doc = 1)
if @ID_View is not null
begin
	Declare @ITDI table
	(
		ID_ITDI bigint
	)

	declare @ID_ITDI bigint
	--Gera o cabeçalho
	insert @ITDI
	exec [dbo].[spATL_IBrokerITDI_V2_SelIns]


	select @ID_ITDI=ID_ITDI from @ITDI

	update  IBROKER_ITDI set ID_View =@ID_View
	where ID_ITDI = @ID_ITDI


	--Gera CAPI
	exec [dbo].[spATL_IBrokerCAPI_V2_SelIns] @ID_ITDI, @ID_View

	--Gera CAP2
	exec [dbo].[spATL_IBrokerCAP2_V2_SelIns] @ID_ITDI, @ID_View

	--Gera ITEA
	exec [dbo].[spATL_IBrokerITEA_V2_SelIns] @ID_ITDI, @ID_View

	--Gera ITEB
	exec [dbo].[spATL_IBrokerITEB_V2_SelIns] @ID_ITDI, @ID_View

	--Gera DPnn
	exec [dbo].[spATL_IBrokerDPnn_V2_SelIns] @ID_ITDI, @ID_View

	--Gera AG4A
	--exec [dbo].[spATL_IBrokerAG4A_V2_SelIns] @ID_ITDI, @ID_View

	--Gera FTDI
	exec [dbo].[spATL_IBrokerFTDI_SelIns] @ID_ITDI

	--Gera TXT
	exec [dbo].[spATL_IBrokerTXT_v2_Sel] @ID_ITDI

	--LOG
	exec [dbo].[spATL_IBrokerLog_Ins] @Processo, @Cd_Usuario, @ID_View
End
 print @ID_ITDI
 print @ID_View

GO

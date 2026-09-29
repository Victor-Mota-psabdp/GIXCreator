SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help spATLINT_AlteraBLDraftBody_Sel
CREATE   procedure [dbo].[spATLINT_AlteraBLDraftBody_Sel]
     @SystemCode as int,
	 @numProc    varchar(20),  
     @tipo       varchar(1) 
as
/*
A - Tras todos
B - Tras por job
C - Traz por Booking 
*/

if @tipo='A'  
		begin 
			Select 
					[ID_ADBB],
					[HblNo],
					[ShipperExporter],
					[Consignee],
					[NotifyParty],
					[ExportReferencesFatura],
					[ExportreferencesBooking],
					[ForwardingAgentReferences],
					[PlaceOfReceipt],
					[Vessel],
					[Voyage],
					[PortOfLoading],
					[PierTerminal],
					[PortOfDischarge],
					[ForTransShipmentTo],
					[PalceOfDelivery],
					[EmissaoBl],
					[FreteBl],
					[Bl],
					[SystemCode], 
					[dt_ins],
					[dt_atualizacao_bl],
					[Nome_Excel_Lido],
					[Message]
		from 
			ATL_INT.dbo.AlteraBLDraftBody with(nolock)	
			Where  dt_atualizacao_bl is null
			and    SystemCode = @SystemCode	
						--and ID_ADBB = 270
			order by [ExportreferencesBooking]
end
if @tipo='B'  
		begin 
			Select 
					[ID_ADBB],
					[HblNo],
					[ShipperExporter],
					[Consignee],
					[NotifyParty],
					[ExportReferencesFatura],
					[ExportreferencesBooking],
					[ForwardingAgentReferences],
					[PlaceOfReceipt],
					[Vessel],
					[Voyage],
					[PortOfLoading],
					[PierTerminal],
					[PortOfDischarge],
					[ForTransShipmentTo],
					[PalceOfDelivery],
					[EmissaoBl],
					[FreteBl],
					[Bl],
					[SystemCode], 
					[dt_ins],
					[dt_atualizacao_bl],
					[Nome_Excel_Lido]
					,[Message]
		from 
			ATL_INT.dbo.AlteraBLDraftBody with(nolock)	
			Where  dt_atualizacao_bl is null
			and    SystemCode = @SystemCode
            and    HblNo = @numProc     
end
if @tipo='C'  
		begin 
			Select 
					[ID_ADBB],
					[HblNo],
					[ShipperExporter],
					[Consignee],
					[NotifyParty],
					[ExportReferencesFatura],
					[ExportreferencesBooking],
					[ForwardingAgentReferences],
					[PlaceOfReceipt],
					[Vessel],
					[Voyage],
					[PortOfLoading],
					[PierTerminal],
					[PortOfDischarge],
					[ForTransShipmentTo],
					[PalceOfDelivery],
					[EmissaoBl],
					[FreteBl],
					[Bl],
					[SystemCode], 
					[dt_ins],
					[dt_atualizacao_bl],
					[Nome_Excel_Lido]
					,[Message]
		from 
			ATL_INT.dbo.AlteraBLDraftBody with(nolock)	
			Where  dt_atualizacao_bl is null
			and    SystemCode = @SystemCode
            and    ExportreferencesBooking = @numProc     
	end


	--For Integration Received
	if @tipo='I'  
		begin 
			Select 
					[ID_ADBB],
					[HblNo],
					[ShipperExporter],
					[Consignee],
					[NotifyParty],
					[ExportReferencesFatura],
					[ExportreferencesBooking],
					[ForwardingAgentReferences],
					[PlaceOfReceipt],
					[Vessel],
					[Voyage],
					[PortOfLoading],
					[PierTerminal],
					[PortOfDischarge],
					[ForTransShipmentTo],
					[PalceOfDelivery],
					[EmissaoBl],
					[FreteBl],
					[Bl],
					[SystemCode], 
					[dt_ins],
					[dt_atualizacao_bl],
					[Nome_Excel_Lido]
					,[Message]
		from 
			ATL_INT.dbo.AlteraBLDraftBody with(nolock)	
			Where  dt_ins > getdate() - 120
	end

GO

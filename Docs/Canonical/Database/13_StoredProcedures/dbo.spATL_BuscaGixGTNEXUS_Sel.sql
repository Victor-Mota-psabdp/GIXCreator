SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BuscaGixGTNEXUS_Sel](
	@Num_Proc varchar(16),
	@Nome_Tp_Gix	varchar(50)
)
as

IF @Nome_Tp_Gix = 'SETS'
	Begin
	select 
		Status [Status File],
		SD.ID,
		'SETS' + ' - ' + E.EventDescription [GIX Type],
		X.XML_DOC [File],
		'Original' [Type Sent],
		X.Dt_Ins [Created Date],
		SD.Dt_Upd [Sent Date]
		  from ATL_INT.dbo.XML315_Event E with(nolock)
				left join ATL_INT.dbo.XML315_Event_ShipmentReferences S with(nolock) on E.ID_Event = S.ID_Event and ID_ShipmentReferences = 1
				left join SETS_Dates SD with(nolock) on  E.ID_Event = SD.ID_Event 
				left join ATL_INT.dbo.XML315_XML X with(nolock) on X.ID_Event = E.ID_Event
		where SD.ReferenceNumber = @Num_Proc
	End
	else
		Begin
			select 
				(Case 
					When G.DT_Envio is NULL then 'Scheduled' else 
				  Case 
					When E.DT_Send is NULL then 'Scheduled' else 
				  Case 
					When  G.DT_Envio is not NULL then 'Sent'
				End End End ) [Status File],
				E.ID, 
				TG.Nome_Tp_Gix [GIX Type] ,
				--(Case when E.Type = 'SH' then 'Shipment' else 'Booking' End) [Type], 
				XML_DOC [File],
				(Case 
					When E.Tipo_Envio = '1' then 'Cancel'
					When E.Tipo_Envio = '4' then 'Change'
					When E.Tipo_Envio = '9' then 'Original' End)
					 [Type Sent],
				E.Dt_Ins	[Created Date],
				 G.DT_Envio [Sent Date],
				 'OK'Status
				from exchange_GTNEXUS E  with(nolock)
			left join GTNEXUS_XML G with(nolock) on E.ID = G.ID_GTNEXUS and E.Type = G.Type
			join Tipo_GIX TG with(nolock)  on  E.Type = TG.cd_Tp_Gix
			where E.Num_Proc = @Num_Proc and TG.Nome_Tp_Gix = @Nome_Tp_Gix
		End




GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwHouse_BDP_OUT]
AS

SELECT LLP.Num_Proc_LBO[Num_Proc], HOU.Dt_Emis_HBO[Dt_Emis], 'BDP Others' [Modal], HOU.Descr_Serv_HBO [Notas], 
	NULL[MAWB],LLP.PO_Req_Date[PO_Req_Date], NULL [ATA], NULL [ATD], NULL [Canal], NULL[ETA], 
    NULL[ETD],NULL [Original_ETA], LLP.ID_Status[ID_Status], NULL [Cd_Export], NULL [Banco], 
    HOU.cd_cliente_hbo[Cd_Consig], 
    NULL[Cd_Org], NULL[Cd_Dst], NULL [Vessel], NULL [Viagem], NULL [Peso_Bruto],NULL[Peso_Liquido], 
	NULL [Peso_cubado],NULL[Cd_Armador],NULL[Cd_Planta],NULL[Cd_DstFinal], NULL [Cd_Tp_Oper], 
	NULL[Cd_Terminal], NULL[HAWB], NULL Intl_Ref, NULL[Vlr_invoice],NULL[Moeda_invoice], 
	NULL [Frete_BL], NULL [Tipo_Frete],NULL [Master], NULL [Tp_Carga],NULL[Moeda_Frete], cd_usuario[cd_usuario], 
	NULL [Cd_Transportadora], NULL [Booking_Number], 
	NULL [Qtd_Vol], NULL [Cd_Agente], 
	NULL [Cd_Vendedor], NULL [Cd_Import], NULL [SAP_ShipNumber], NULL Vol_Tot
FROM LLP_BDP_OUT LLP WITH (nolock) JOIN
      House_BDP_OUT HOU WITH (nolock) ON LLP.Num_Proc_LBO = HOU.Num_Proc_HBO


GO

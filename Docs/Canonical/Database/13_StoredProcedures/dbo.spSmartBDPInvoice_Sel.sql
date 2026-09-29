SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Update REL to BRL when send to ODS - CADU 19/07/2021
CREATE Procedure [dbo].[spSmartBDPInvoice_Sel]
		@FatCod	Varchar(17)

AS


select 
	FAT.FATCOD InvoiceNumber,FatDtEmissao InvoiceDate,(case fatstatus when '0' then 'Y' else 'N' end) fatstatus,
	Isnull(Nome_Tp_Tx_Ing,Nome_Tp_Tx) Charge,TT.cd_tp_tx ChargeCode,Vlr_ORg ,
	(case when item.cd_tp_moeda = 'REL' then 'BRL' else item.cd_tp_moeda end) Cd_Moeda,
	--item.cd_tp_moeda Cd_Moeda,
	Isnull(nome_raz_soc,'') Vendor,isnull(cta.cd_cred_dev_hia,'') Cd_Vendor
from 
	fatura faT with(nolock)
	Join item_Fat ITEM with(nolock) on FAT.fatcod=ITEM.fatCOD
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=item.cd_tp_tx
	Left Join vwcta_cte CTA with(nolock) on cta.num_proc_hia=item.num_proc and CTA.cd_tp_Tx=item.cd_tp_Tx and Cta.dc_hia='D'
	Left Join Pessoa PP with(nolock) on pp.cd_pes=cta.cd_cred_dev_hia
WHERE 
	FAT.FATCOD=@FatCod
	and fatstatus=1



GO

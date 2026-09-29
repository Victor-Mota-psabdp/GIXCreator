SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  Procedure [dbo].[spPlasticosT11_Rel]

as

/**
Relatório referente a Exportacao de SP para Plasticos
Nome do Report: PLASTICS - Posicao Ordens Sao Paulo Exports
Tracking_10
Criacao em 02-02-2008
**/


select 
	Dt_Pedido Enter,Null WkBL,Num_Pedido Order_Nbr, PS.Item, GMID,GMID_Descr_Curta,Null DN_Created,
	PDD.Lote,Null S_Created, Numero_PO_HEM S_Nbr,ETD_Lem ETD,Null ETA_Req, ETA_Lem ETA,ETA_Lem ETA_Real,
	Null Req_Inf,Null Req_Real, Null Info_Real,Null Yins, Null Ycob, Null FC_CO, Hawb_hem BL, Navio_Hem Navio,
	Dst.Nome_Local Port, dbo.Qty_Container(hou.num_proc_hem) Qty_Ctner, Nome_Armador Agent,cd_CsrID CSR,Nr_Reserva Reserva

from 
	house_exp_mar HOU
	Join LLP_Exp_Mar LLP on LLP.num_proc_lem=HOU.num_proc_hem
	Join Pedido_Ship PS on PS.num_proc=HOU.num_proc_hem
	Join Produto_Cliente PC on PC.cd_prod=Ps.cd_produto
	Join DE_Para_Produto DP on GMID=cd_proc_cliente
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det PDD on PDD.cd_pedido=PS.cd_pedido and pdd.cd_produto=ps.cd_produto and (pdd.item=ps.item or ps.item is null)
	Left Join PO_HEM PO on PO.num_proc_hem=HOU.num_proc_hem and ID_DC=8
	Left Join Localidade DST on DST.cd_local=cd_dst_hem
	Left Join Localidade Org on org.cd_local=cd_org_hem
	Left Join Armador ARM on ARM.cd_armador=LLP.cd_armador_lem	
	left Join job_exp_mar job on hou.num_proc_hem=job.num_proc_hem
Where
	PO_GRP IN ('041')
	and cd_org_hem='SSZ'





GO

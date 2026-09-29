SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from nota_cliente

CREATE	Procedure	[dbo].[spReportManager_Rel]
As
select
	HOU.Num_Proc_HIM						Processo,
	DPP.GMID,
	DPP.GMID_Descr_Curta,
	P.Num_Pedido							Ordem,
	P.Num_PO								PO,
	P.Customer_PO							Customer_PO,
	ORG.Pais_Local							Origem,
	DEST.Nome_Local							Destino,
	LLP.Canal_LIM							Parametrizacao,
	DI.Numero_PO_HIM						Numero_DI,
	CONS.Apelido							Consignee,
	Ship.Apelido 							Shipper,
	'OCEAN'									Modal,
	LLP.ATA_LIM								ATA,
	DESEMB.Dt_Conclusao						Desembaraco,
	P.Incoterm								Incoterm,
	INV.Numero_PO_HIM						Invoice_Number,
	isnull(NOTA.Paridade,0)					Tx_Dolar,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Posicionamento%') Posicionamento,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Desova%') Desova,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Pesagem%') Pesagem,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Armazenagem%') Armazenagem,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Consertadores%') Consertadores,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Vistoria%') TransporteVistoria,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%THC%') THC,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%fee%') BL_Fee,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%AFRM%') AFRMM,
	dbo.FBusca_FOB(hou.num_proc_him,'I')	FOB,
	Vlr_Frete_efet_him						Frete,
	dbo.FBusca_FOB(hou.num_proc_him,'S')	Seguro,
--	FOB + Frete + Seguro = CIF  ----------------
	dbo.FBusca_FOB(hou.num_proc_him,'I')	+
	Vlr_Frete_efet_him						+
	dbo.FBusca_FOB(hou.num_proc_him,'S')	CIF,
------------------------------------------------
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Impos% Impor%') Imposto_Importacao,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Impos% Prod% Ind%') IPI,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%ICMS%') ICMS,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%PIS%') PIS,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Cofins%') Cofins,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Frete%Interno%') Frete_Interno,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Servi%Despacho%') Servico_Despacho,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%Demurrage%') Demurrage,
	dbo.fBusca_Custo(HOU.num_proc_him,PS.Cd_Pedido,PS.Cd_Produto,'%SISCOMEX%') Siscomex
from
	House_Imp_Mar HOU with(nolock)
	Join LLP_Imp_Mar		LLP with(nolock)	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Join Pessoa		Ship with(nolock) on Cd_Export_HIM 	= Ship.Cd_Pes
	Left Join Pessoa		CONS with(nolock) on HOU.Cd_Consig_HIM = CONS.Cd_Pes
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido				P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det 		PD with(nolock)	on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto --and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join Localidade	ORG with(nolock)	on HOU.Cd_Org_Him = ORG.Cd_Local
	Left Join Localidade	DEST with(nolock) on HOU.Cd_Dst_HIM = DEST.Cd_Local
	Left Join PO_HIM		DI with(nolock)	on HOU.Num_Proc_HIM = DI.Num_Proc_HIM and DI.ID_PO_HIM = 5
	Left Join PO_HIM		INV with(nolock)	on HOU.Num_Proc_HIM = INV.Num_Proc_HIM and INV.ID_PO_HIM = 2
	Join Produto_Cliente	PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 	DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Join Nota_Cliente	NOTA with(nolock) on HOU.Num_Proc_HIM = NOTA.Num_Proc
	Left Join tarefas_processos	DESEMB with(nolock) on HOU.Num_Proc_HIM = DESEMB.Num_Proc and DESEMB.id_task = 4
Group by
	HOU.Num_Proc_HIM						,
	DPP.GMID,
	DPP.GMID_Descr_Curta,
	P.Num_Pedido							,
	P.Num_PO								,
	P.Customer_PO							,
	ORG.Pais_Local							,
	DEST.Nome_Local							,
	LLP.Canal_LIM							,
	DI.Numero_PO_HIM						,
	CONS.Apelido							,
	Ship.Apelido 							,
	P.Incoterm								,
	Vlr_Frete_efet_him,
	PS.Cd_Pedido,PS.Cd_Produto,NOTA.Paridade,INV.Numero_PO_HIM,
	LLP.ATA_LIM								,
	DESEMB.Dt_Conclusao	
GO

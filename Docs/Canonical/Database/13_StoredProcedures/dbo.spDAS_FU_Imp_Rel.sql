SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alterado pra 31 dias - 1-6-2012 cadu

CREATE	Procedure	 [dbo].[spDAS_FU_Imp_Rel] --'01-01-2010'
--(
--@Data datetime
--)
As
select
	HOU.Num_Proc_HIM						Ref_BDP,
	isnull(PO.Numero_PO_HIM,P.Num_PO)		PU,
	isnull(SO.Numero_PO_HIM,P.Num_Pedido)	Ordem_SAP,
	isnull(SO.Data_PO_HIM,P.Dt_Pedido)		Data_Ordem,
	dbo.fBusca_GMID(HOU.Num_Proc_HIM)		GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)	Produtos,
	PD.UoM									UOM,
--	HOU.Peso_Liquido_HIM					Peso_Liquido_HOU,
--	sum(PD.Peso_Liquido_Tot)				Peso_Liquido,
	(case when HOU.Peso_Liquido_HIM = 0 then sum(PD.Peso_Liquido_Tot) else HOU.Peso_Liquido_HIM end) Peso_Liquido,
	TE.Nome_Tp_Embal						Embalagem,
	HOU.Navio_HIM							Navio,
	TRA.Nome_Armador						Transportador,
	dbo.qty_container(hou.num_proc_him)		NContainers,
	dbo.fBusca_TipoContainers(hou.num_proc_him)	Tipo_Conts,
	dbo.fBusca_Tarefa_Prev(hou.num_proc_him,10)	Prev_Saida,
	dbo.fBusca_Tarefa(hou.num_proc_him,10)	Conf_Saida,
	LLP.ETD_LIM								ETD,
	LLP.ATD_LIM								ATD,
	LLP.ATD_LIM								Data_BL_AWB,
	LLP.ETA_LIM 							ETA,
	LLP.ATA_LIM								ATA,
	dbo.fBusca_Tarefa(hou.num_proc_him,17)	SOLIC_DTAE,
	dbo.fBusca_Tarefa(hou.num_proc_him,18)	LIBER_DTAE,
	dbo.fBusca_Tarefa(hou.num_proc_him,19)	REMOCAO,
	dbo.fBusca_Tarefa(hou.num_proc_him,16)	RECEB_DOCS,
	REQ.Numero_PO_HIM						Requerimento,
	REQ.Data_PO_HIM							Venc_Requerimento,
	dbo.fBusca_TipoDocCliente('D',hou.num_proc_him,23)	ENTRADA_LI,
	dbo.fBusca_Historico_DataFU(hou.num_proc_him,13) Sol_Insp_Produto,
	dbo.fBusca_Tarefa(hou.num_proc_him,20)	DEFERIMENTO_LI,
	dbo.fBusca_Docs_PO_Modal(hou.num_proc_him,23) Nro_LI,
	dbo.fBusca_Tarefa(hou.num_proc_him,4) 	DATA_CI,
	P.DL_Chegada							Prev_Entrega_Planta,
	dbo.fBusca_Tarefa(hou.num_proc_him,13)	Entrega_Planta,
	dbo.fBusca_HistoricoDescr(hou.num_proc_him,52,getdate())	Historico,
	EXPO.Apelido							Exportador,
	ORG.Nome_Local							Local_Origem,
	ORG.Pais_Local							Pais_Origem,
	DST.Nome_Local							Local_Destino,
	LLP.Canal_LIM							Canal,
	HOU.HAWB_HIM							BL_Number,
	DI.Numero_PO_HIM						DI,
	DI.Data_PO_HIM							Data_DI,
	max(NF.Num_NF_HIM)						NF_BDP,
	sum(NF.Vlr_Pgto_NF_HIM)					Valor_NF,
--	dbo.FBusca_FOB(hou.num_proc_him,'I')/Isnull(Paridade,1.7) FobUSD,
	dbo.FBusca_FOB(hou.num_proc_him,'D')	FobUSD,
--	HOU.Vlr_Frete_efet_him /Isnull(Paridade,1.7) FreteUSD,
	HOU.Vlr_Frete_efet_him					FreteUSD,
	P.Vlr_Pedido,
	'OCEAN'									Modal,
	HOU.Cd_Tp_Moeda,
	dbo.fBusca_Tarefa(hou.num_proc_him,15)	PresencaCarga
from
	House_Imp_Mar HOU with(nolock)
	Join LLP_Imp_Mar			LLP	with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Join Job_Imp_Mar		JIM	with(nolock) on HOU.Num_Proc_HIM = JIM.Num_Proc_HIM
	Join Pedido_Ship 			PS with(nolock) on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido					P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det				PD with(nolock) on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join Localidade		DST with(nolock) on HOU.Cd_Dst_HIM = DST.Cd_Local
	Left Join Localidade		ORG with(nolock) on HOU.Cd_Org_HIM = ORG.Cd_Local
	Left Join Armador			TRA with(nolock) on JIM.Cd_Armador   = TRA.Cd_Armador
	Left Join Pessoa 			EXPO with(nolock) on HOU.cd_export_HIM=EXPO.cd_pes
	Left Join Pessoa 			IMP with(nolock) on HOU.cd_Consig_HIM=IMP.cd_pes
	Left Join Volume_IMP_Mar	VOL with(nolock) On HOU.Num_Proc_HIM = VOL.Num_Proc_HIM
	Left Join Tipo_embalagem	TE with(nolock) On VOL.Cd_Tp_Embal = TE.Cd_Tp_Embal
	Left Join PO_HIM			CI with(nolock) on HOU.Num_Proc_HIM = CI.Num_Proc_HIM and CI.ID_DC='6'
--	Left Join PO_HIM			LI	on HOU.Num_Proc_HIM = LI.Num_Proc_HIM and LI.ID_DC='23'
	Left Join PO_HIM			REQ with(nolock) on HOU.Num_Proc_HIM = REQ.Num_Proc_HIM and REQ.ID_DC='25'
	Left Join PO_HIM			DI with(nolock) on HOU.Num_Proc_HIM = DI.Num_Proc_HIM and DI.ID_DC='5'
	Left Join PO_HIM			PO with(nolock) on HOU.Num_Proc_HIM = PO.Num_Proc_HIM and PO.ID_DC='1'
	Left Join PO_HIM			SO with(nolock) on HOU.Num_Proc_HIM = SO.Num_Proc_HIM and SO.ID_DC='3'
	Left Join cta_cte_hou_imp_mar NF with(nolock) on HOU.Num_Proc_HIM = NF.Num_Proc_HIM and NF.DC_HIM='C'
	Join Pessoa_LLP				PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo='1'
where
	convert(datetime,Dt_Emis_HIM,105) > getdate() - 31 and
	IMP.Apelido like 'DOW AGRO%' 
Group by
	HOU.Num_Proc_HIM,
	PO.Numero_PO_HIM,P.Num_PO,
	SO.Numero_PO_HIM,P.Num_Pedido,
	SO.Data_PO_HIM,P.Dt_Pedido,
	PD.UoM,
	HOU.Peso_Liquido_HIM,
	PD.Peso_Liquido_Tot,
	TE.Nome_Tp_Embal,
	HOU.Navio_HIM,
	TRA.Nome_Armador,
	LLP.ETD_Lim,
	LLP.ATD_LIM,
	LLP.ETA_LIM,
--	LI.Data_PO_HIM,
--	LI.Numero_PO_HIM,
	EXPO.Apelido,
	ORG.Nome_Local,
	ORG.Pais_Local,
	DST.Nome_Local,
	LLP.Canal_LIM,
	HOU.HAWB_HIM,
	LLP.ATA_Lim,
	REQ.Numero_PO_HIM,
	REQ.Data_PO_HIM,
	DI.Numero_PO_HIM,
	DI.Data_PO_HIM,
--	NF.Num_NF_HIM,
	HOU.Vlr_Frete_efet_him,
	P.DL_Chegada,
	P.Vlr_Pedido,
	HOU.Cd_Tp_Moeda

Union

select
	HOU.Num_Proc_HIA						Ref_BDP,
	isnull(PO.Numero_PO_HIA,P.Num_PO)		PU,
	isnull(SO.Numero_PO_HIA,P.Num_Pedido)	Ordem_SAP,
	isnull(SO.Data_PO_HIA,P.Dt_Pedido)		Data_Ordem,
	dbo.fBusca_GMID(HOU.Num_Proc_HIA)		GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)	Produtos,
	PD.UoM									UOM,
--	HOU.Peso_Real_HIA						Peso_Liquido_HOU,
--	sum(PD.Peso_Liquido_Tot)				Peso_Liquido,
	(case when HOU.Peso_Real_HIA = 0 then sum(PD.Peso_Liquido_Tot) else HOU.Peso_Real_HIA end) Peso_Liquido,
	TE.Nome_Tp_Embal						Embalagem,
	null									Navio,
	TRA.Nome_Cia_Aer						Transportador,
	dbo.qty_container(hou.num_proc_HIA)		NContainers,
	dbo.fBusca_TipoContainers(hou.num_proc_HIA)	Tipo_Conts,
	dbo.fBusca_Tarefa_Prev(hou.num_proc_HIA,10)	Prev_Saida,
	dbo.fBusca_Tarefa(hou.num_proc_HIA,10)	Conf_Saida,
	LLP.ETD_LIA								ETD,
	LLP.ATD_LIA								ATD,
	LLP.ATD_LIA								Data_BL_AWB,
	LLP.ETA_LIA 							ETA,
	LLP.ATA_LIA								ATA,
	dbo.fBusca_Tarefa(hou.num_proc_HIA,17)	SOLIC_DTAE,
	dbo.fBusca_Tarefa(hou.num_proc_HIA,18)	LIBER_DTAE,
	dbo.fBusca_Tarefa(hou.num_proc_HIA,19)	REMOCAO,
	dbo.fBusca_Tarefa(hou.num_proc_HIA,16)	RECEB_DOCS,
	REQ.Numero_PO_HIA						Requerimento,
	REQ.Data_PO_HIA							Venc_Requerimento,
	dbo.fBusca_TipoDocCliente('D',hou.num_proc_hia,23)	ENTRADA_LI,
	dbo.fBusca_Historico_DataFU(hou.num_proc_hia,13) Sol_Insp_Produto,
	dbo.fBusca_Tarefa(hou.num_proc_HIA,20)	DEFERIMENTO_LI,
	dbo.fBusca_Docs_PO_Modal(hou.num_proc_hia,23) Nro_LI,
	dbo.fBusca_Tarefa(hou.num_proc_HIA,4) 	DATA_CI,
	P.DL_Chegada							Prev_Entrega_Planta,
	dbo.fBusca_Tarefa(hou.num_proc_HIA,13)	Entrega_Planta,
	dbo.fBusca_HistoricoDescr(hou.num_proc_HIA,52,getdate())	Historico,
	EXPO.Apelido							Exportador,
	ORG.Nome_Local							Local_Origem,
	ORG.Pais_Local							Pais_Origem,
	DST.Nome_Local							Local_Destino,
	LLP.Canal_LIA							Canal,
	HOU.HAWB_HIA							BL_Number,
	DI.Numero_PO_HIA						DI,
	DI.Data_PO_HIA							Data_DI,
	max(NF.Num_NF_HIA)						NF_BDP,
	sum(NF.Vlr_Pgto_NF_HIA)					Valor_NF,
	dbo.FBusca_FOB(hou.num_proc_hia,'D')	FobUSD,
	HOU.Vlr_Frete_efet_hia					FreteUSD,
	P.Vlr_Pedido,
	'AIR'									Modal,
	HOU.Cd_Tp_Moeda,
	dbo.fBusca_Tarefa(hou.num_proc_hia,15)	PresencaCarga
from
	House_Imp_Aer HOU with(nolock)
	Join LLP_Imp_Aer			LLP	with(nolock) on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
	Left Join Job_Imp_Aer		JOB	with(nolock) on HOU.Num_Proc_HIA = JOB.Num_Proc_HIA
	Join Pedido_Ship 			PS with(nolock) on HOU.Num_Proc_HIA = PS.Num_Proc
	Join Pedido					P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det				PD with(nolock) on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join Localidade		DST	with(nolock) on HOU.Cd_Dst_HIA = DST.Cd_Local
	Left Join Localidade		ORG	with(nolock) on HOU.Cd_Org_HIA = ORG.Cd_Local
	Left Join Cia_Aerea			TRA with(nolock) on TRA.cd_cia_Aer=JOB.cd_cia_aer
	Left Join Pessoa 			EXPO with(nolock) on HOU.cd_export_HIA=EXPO.cd_pes
	Left Join Pessoa 			IMP	with(nolock) on HOU.cd_Consig_HIA=IMP.cd_pes
	Left Join Volume_IMP_Aer	VOL	with(nolock) On HOU.Num_Proc_HIA = VOL.Num_Proc_HIA
	Left Join Tipo_embalagem	TE with(nolock) On VOL.Cd_Tp_Embal = TE.Cd_Tp_Embal
	Left Join PO_HIA			CI with(nolock) on HOU.Num_Proc_HIA = CI.Num_Proc_HIA and CI.ID_DC='6'
--	Left Join PO_HIA			LI	on HOU.Num_Proc_HIA = LI.Num_Proc_HIA and LI.ID_DC='23'
	Left Join PO_HIA			REQ with(nolock) on HOU.Num_Proc_HIA = REQ.Num_Proc_HIA and REQ.ID_DC='25'
	Left Join PO_HIA			DI with(nolock) on HOU.Num_Proc_HIA = DI.Num_Proc_HIA and DI.ID_DC='5'
	Left Join PO_HIA			PO with(nolock) on HOU.Num_Proc_HIA = PO.Num_Proc_HIA and PO.ID_DC='1'
	Left Join PO_HIA			SO with(nolock) on HOU.Num_Proc_HIA = SO.Num_Proc_HIA and SO.ID_DC='3'
	Left Join cta_cte_hou_imp_aer NF with(nolock) on HOU.Num_Proc_HIA = NF.Num_Proc_HIA and NF.DC_HIA='C'
	Join Pessoa_LLP				PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo='1'
where 
	convert(datetime,Dt_Emis_HIA,105) > getdate() - 31 and 
	IMP.Apelido like 'DOW AGRO%' 
Group by
	HOU.Num_Proc_HIA,
	PO.Numero_PO_HIA,P.Num_PO,
	SO.Numero_PO_HIA,P.Num_Pedido,
	SO.Data_PO_HIA,P.Dt_Pedido,
	PD.UoM,
	HOU.Peso_Real_HIA,
	PD.Peso_Liquido_Tot,
	TE.Nome_Tp_Embal,
--	HOU.Navio_HIA,
	TRA.Nome_Cia_Aer,
	LLP.ETD_LIA,
	LLP.ATD_LIA,
	LLP.ETA_LIA,
--	LI.Data_PO_HIA,
--	LI.Numero_PO_HIA,
	EXPO.Apelido,
	ORG.Nome_Local,
	ORG.Pais_Local,
	DST.Nome_Local,
	LLP.Canal_LIA,
	HOU.HAWB_HIA,
	LLP.ATA_LIA,
	REQ.Numero_PO_HIA,
	REQ.Data_PO_HIA,
	DI.Numero_PO_HIA,
	DI.Data_PO_HIA,
--	NF.Num_NF_HIA,
	HOU.Vlr_Frete_efet_hia,
	P.DL_Chegada,
	P.Vlr_Pedido,
	HOU.Cd_Tp_Moeda

Union

select
	HOU.Num_Proc_HIO						Ref_BDP,
	isnull(PO.Numero_PO_HIO,P.Num_PO)		PU,
	isnull(SO.Numero_PO_HIO,P.Num_Pedido)	Ordem_SAP,
	isnull(SO.Data_PO_HIO,P.Dt_Pedido)		Data_Ordem,
	dbo.fBusca_GMID(HOU.Num_Proc_HIO)		GMIDs,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO)	Produtos,
	PD.UoM									UOM,
--	HOU.Peso_Real_HIO						Peso_Liquido_HOU,
--	sum(PD.Peso_Liquido_Tot)				Peso_Liquido,
	(case when HOU.Peso_Real_HIO = 0 then sum(PD.Peso_Liquido_Tot) else HOU.Peso_Real_HIO end) Peso_Liquido,
	TE.Nome_Tp_Embal						Embalagem,
	null									Navio,
	TRA.Nome_Raz_Soc						Transportador,
	dbo.qty_container(hou.num_proc_HIO)		NContainers,
	dbo.fBusca_TipoContainers(hou.num_proc_HIO)	Tipo_Conts,
	dbo.fBusca_Tarefa_Prev(hou.num_proc_HIO,10)	Prev_Saida,
	dbo.fBusca_Tarefa(hou.num_proc_HIO,10)	Conf_Saida,
	LLP.ETD_LIO								ETD,
	LLP.ATD_LIO								ATD,
	LLP.ATD_LIO								Data_BL_AWB,
	LLP.ETA_LIO 							ETA,
	LLP.ATA_LIO								ATA,
	dbo.fBusca_Tarefa(hou.num_proc_HIO,17)	SOLIC_DTAE,
	dbo.fBusca_Tarefa(hou.num_proc_HIO,18)	LIBER_DTAE,
	dbo.fBusca_Tarefa(hou.num_proc_HIO,19)	REMOCAO,
	dbo.fBusca_Tarefa(hou.num_proc_HIO,16)	RECEB_DOCS,
	REQ.Numero_PO_HIO						Requerimento,
	REQ.Data_PO_HIO							Venc_Requerimento,
	dbo.fBusca_TipoDocCliente('D',hou.num_proc_hio,23)	ENTRADA_LI,
	dbo.fBusca_Historico_DataFU(hou.num_proc_hio,13) Sol_Insp_Produto,
	dbo.fBusca_Tarefa(hou.num_proc_HIO,20)	DEFERIMENTO_LI,
	dbo.fBusca_Docs_PO_Modal(hou.num_proc_hio,23) Nro_LI,
	dbo.fBusca_Tarefa(hou.num_proc_HIO,4) 	DATA_CI,
	P.DL_Chegada							Prev_Entrega_Planta,
	dbo.fBusca_Tarefa(hou.num_proc_HIO,13)	Entrega_Planta,
	dbo.fBusca_HistoricoDescr(hou.num_proc_HIO,52,getdate())	Historico,
	EXPO.Apelido							Exportador,
	ORG.Nome_Local							Local_Origem,
	ORG.Pais_Local							Pais_Origem,
	DST.Nome_Local							Local_Destino,
	LLP.Canal_LIO							Canal,
	HOU.HAWB_HIO							BL_Number,
	DI.Numero_PO_HIO						DI,
	DI.Data_PO_HIO							Data_DI,
	max(NF.Num_NF_HIO)						NF_BDP,
	sum(NF.Vlr_Pgto_NF_HIO)					Valor_NF,
	dbo.FBusca_FOB(hou.num_proc_hio,'D')	FobUSD,
	HOU.Vlr_Frete_efet_hio					FreteUSD,
	P.Vlr_Pedido,
	LLP.Tipo_LIO							Modal,
	HOU.Cd_Tp_Moeda,
	dbo.fBusca_Tarefa(hou.num_proc_hio,15)	PresencaCarga
from
	House_Imp_Out HOU
	Join LLP_Imp_Out			LLP with(nolock) on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
	left Join Pessoa			TRA with(nolock) on TRA.cd_pes=LLP.cd_carrier
	Join Pedido_Ship 			PS with(nolock) on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido					P with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det				PD with(nolock) on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	Left Join Localidade		DST with(nolock) on HOU.Cd_Dst_HIO = DST.Cd_Local
	Left Join Localidade		ORG with(nolock) on HOU.Cd_Org_HIO = ORG.Cd_Local
	Left Join Pessoa 			EXPO with(nolock) on HOU.cd_export_HIO=EXPO.cd_pes
	Left Join Pessoa 			IMP with(nolock) on HOU.cd_Consig_HIO=IMP.cd_pes
	Left Join Volume_IMP_Out	VOL with(nolock) On HOU.Num_Proc_HIO = VOL.Num_Proc_HIO
	Left Join Tipo_embalagem	TE with(nolock) On VOL.Cd_Tp_Embal = TE.Cd_Tp_Embal
	Left Join PO_HIO			CI with(nolock) on HOU.Num_Proc_HIO = CI.Num_Proc_HIO and CI.ID_DC='6'
--	Left Join PO_HIO			LI	on HOU.Num_Proc_HIO = LI.Num_Proc_HIO and LI.ID_DC='23'
	Left Join PO_HIO			REQ with(nolock) on HOU.Num_Proc_HIO = REQ.Num_Proc_HIO and REQ.ID_DC='25'
	Left Join PO_HIO			DI with(nolock) on HOU.Num_Proc_HIO = DI.Num_Proc_HIO and DI.ID_DC='5'
	Left Join PO_HIO			PO with(nolock) on HOU.Num_Proc_HIO = PO.Num_Proc_HIO and PO.ID_DC='1'
	Left Join PO_HIO			SO with(nolock) on HOU.Num_Proc_HIO = SO.Num_Proc_HIO and SO.ID_DC='3'
	Left Join cta_cte_hou_imp_out NF with(nolock) on HOU.Num_Proc_HIO = NF.Num_Proc_HIO and NF.DC_HIO='C'
	Join Pessoa_LLP				PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo='1'
where 
	convert(datetime,Dt_Emis_HIO,105) > getdate() - 31	and 
	IMP.Apelido like 'DOW AGRO%' 
Group by
	HOU.Num_Proc_HIO,
	PO.Numero_PO_HIO,P.Num_PO,
	SO.Numero_PO_HIO,P.Num_Pedido,
	SO.Data_PO_HIO,P.Dt_Pedido,
	PD.UoM,
	HOU.Peso_Real_HIO,
	PD.Peso_Liquido_Tot,
	TE.Nome_Tp_Embal,
--	HOU.Navio_HIO,
	TRA.Nome_Raz_Soc,
	LLP.ETD_LIO,
	LLP.ATD_LIO,
	LLP.ETA_LIO,
--	LI.Data_PO_HIO,
--	LI.Numero_PO_HIO,
	EXPO.Apelido,
	ORG.Nome_Local,
	ORG.Pais_Local,
	DST.Nome_Local,
	LLP.Canal_LIO,
	HOU.HAWB_HIO,
	LLP.ATA_LIO,
	REQ.Numero_PO_HIO,
	REQ.Data_PO_HIO,
	DI.Numero_PO_HIO,
	DI.Data_PO_HIO,
--	NF.Num_NF_HIO,
	HOU.Vlr_Frete_efet_hio,
	P.DL_Chegada,
	P.Vlr_Pedido,
	LLP.Tipo_LIO,
	HOU.Cd_Tp_Moeda















GO

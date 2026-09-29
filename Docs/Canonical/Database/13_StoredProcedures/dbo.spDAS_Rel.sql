SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE               Procedure	 [dbo].[spDAS_Rel] --'01-01-2008'
(
@Data datetime
)
As

select 
	P.Num_Pedido							Ordem_SAP,
	P.Num_PO							PU,
	P.Dt_Pedido							Data_Ordem,
	PD.UoM								Qtd,
	sum(PD.Peso_Item * PD.Qty)					Peso_Liquido,
	TE.Nome_Tp_Embal						Embalagem,
	HOU.Navio_HIM							Navio,
	ARM.Nome_Armador						Ag_Maritma,
	dbo.qty_container(hou.num_proc_him)				NContainers,

	dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate())		Historico,
	EXPO.Apelido							Exportador,
	ORG.Nome_Local							Porto_Origem,
	ORG.Pais_Local							Pais_Origem,
	DST.Nome_Local							Porto_Destino,
	DST.Pais_Local							Destino_Pais,
	DI.Numero_PO_HIM						DI_Number,
	DI.Data_PO_HIM							DI_Data,
	LLP.Canal_LIM							Canal,
	HOU.HAWB_HIM							BL_Number,
	HOU.Num_Proc_HIM						Ref_BDP,
	NF.Nota_Fiscal							NF_BDP,
	NF.Vlr_NF							NF_Valor,
	dbo.FBusca_FOB(hou.num_proc_him,'I')				FOB,
	HOU.Vlr_Frete_efet_him						Frete,
	dbo.FBusca_FOB(hou.num_proc_him,'I') + HOU.Vlr_Frete_efet_him	C_FR
	
--	LLP.ETD_LIM							ETD,
--	LLP.ATD_LIM							DataEmbarque,
--	LLP.ETA_LIM							ETA,
--	ATA_LIM								Atracacao,
--	dbo.fBusca_Historico(hou.num_proc_him,53,getdate()) 			Saida,
--	Isnull(dbo.fBusca_Historico(hou.num_proc_him,54,getdate()),ETA_Lim +7)	Previsao,
--	dbo.fBusca_Historico(hou.num_proc_him,55,getdate()) 			Entrega,
--	dbo.fBusca_Historico(hou.num_proc_him,56,getdate()) 			Deposito,
--	dbo.fBusca_HistoricoDescr(hou.num_proc_him,54,getdate())	Motivo_Atraso,

from
	House_Imp_Mar HOU with(nolock)
	Join LLP_Imp_Mar LLP with(nolock)	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Outer Join Job_Imp_Mar	JIM with(nolock)	on HOU.Num_Proc_HIM = JIM.Num_Proc_HIM
	Join Pedido_Ship 		PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido			P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det			PD with(nolock) 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Left Outer Join Localidade	DST with(nolock)	on HOU.Cd_Dst_HIM = DST.Cd_Local
	Left Outer Join Localidade	ORG with(nolock)	on HOU.Cd_Dst_HIM = ORG.Cd_Local
	Join Produto_Cliente		PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 		DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Armador		ARM with(nolock)	on JIM.Cd_Armador   = ARM.Cd_Armador
	Left Outer Join Pessoa 		EXPO with(nolock)	on HOU.cd_export_HIM=EXPO.cd_pes
	Left Outer Join Volume_IMP_Mar	VOL with(nolock)	On HOU.Num_Proc_HIM = VOL.Num_Proc_HIM
	Left Outer Join Tipo_embalagem	TE with(nolock)	On VOL.Cd_Tp_Embal = TE.Cd_Tp_Embal
	Left Outer Join PO_HIM		DI with(nolock)	on HOU.Num_Proc_HIM = DI.Num_Proc_HIM and DI.ID_DC='5'
	Left Outer Join Nota_Cliente	NF with(nolock)	on HOU.Num_Proc_HIM = NF.Num_Proc
	Left Outer Join Pessoa		CONS with(nolock)	on HOU.cd_consig_HIM=CONS.cd_pes
where 
	convert(datetime,Dt_Emis_HIM,105) > @Data and 	CONS.Apelido like 'DOW AGRO%' 
Group by
	P.Num_Pedido,
	P.Num_PO,
	P.Dt_Pedido,
	PD.UoM,
	TE.Nome_Tp_Embal,
	HOU.Navio_HIM,
	ARM.Nome_Armador,
	HOU.Num_Proc_HIM,
	HOU.Num_Proc_HIM,
	EXPO.Apelido,
	ORG.Nome_Local,
	ORG.Pais_Local,
	DST.Nome_Local,
	DST.Pais_Local,
	DI.Numero_PO_HIM,
	DI.Data_PO_HIM,
	LLP.Canal_Lim,
	HOU.HAWB_HIM,
	HOU.Num_Proc_HIM,
	NF.Nota_Fiscal,
	NF.Vlr_NF,
	HOU.Num_Proc_HIM,
	HOU.Vlr_Frete_Efet_HIM,
	HOU.Num_Proc_HIM,
	HOU.Vlr_Frete_Efet_HIM




GO

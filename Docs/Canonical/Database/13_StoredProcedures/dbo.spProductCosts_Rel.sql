SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	  Procedure	 [dbo].[spProductCosts_Rel] --'dec', '2010-09-24','2010-09-24'
(
	@Grupo varchar(3),
	@Dt_Inicial	datetime,
	@Dt_Final	datetime
)
As

	declare @cd_pes_grupo varchar(10)

	set @cd_pes_grupo = (select cd_pes_grupo from grupo where grupo=@grupo)

	select 
		dbo.fBusca_Pessoa(cd_consig_HIM,'1')					Consignee,
		dbo.fBusca_Pessoa(cd_consig_him,'3')					Consig_CNPJ,
		HOU.Num_Proc_HIM										BDP_Reference,
		convert(datetime,HOU.Dt_Emis_Him,105)					Register_Date,
		IsNull(PO.numero_po_him,P.Num_PO)						PO_Number,
		PS.Item													PO_Item,
		PC.Cd_Proc_Cliente										GMIDs,
		PC.Produto_Descr										Produtos,
		Isnull(hou.cd_tp_oper,incoterm)							Incoterm,
		'Sea Import' 											Mode_Transportation,
		INV.numero_po_him										Invoice_Number,
		INV.Data_po_him											Invoice_Data,
		LLP.ATD_Lim												Sailing_Date,
		LLP.ATA_Lim												Date_Arrival,	
		PS.Qty													Qty_UOM,
		PD.UOM,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'CIF') CIF,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'FOB') FOB,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Quantidade') Vlr_Total_Item,
--		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Frete') + dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'FRETE - CHB%')    Vlr_FRETE,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Vlr_FRETE') Vlr_FRETE,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_II') ALIQ_II,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'VL_II') VL_II,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_IPI') ALIQ_IPI,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Seguro') Seguro,

		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'IPI%') VL_BASE_IPI, -- Aqui é o vlr_IPI
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'%PIS%')	vlrPIS,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'%COFINS%') vlrCOFINS,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'%ICMS%')	vlrICMS,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'%AFRMM%') AFRMM,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Adic%Frete%') Adic_FRETE,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'%Armazenagem%') ARMAZENAGEM,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'%Demurrage%') DEMURRAGE,

		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'THC%') +
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Capatazia%') THC,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'BAF%') BAF,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Frete Int%') Transp_Int,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Serv%Desp%') Serv_Desp,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Lib%BL%') Lib_BL,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'%SISCO%') SISCOMEX,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'ISPS%') ISPS,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Desconso%') Desconsol,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Lavagem CNTR%') Lavagem,
--		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Seguro%') Seguro,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Gestão%') Gestao,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'ISS %') ISS,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'%Siscarga%') Siscarga,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'SDA%')	SDA,
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'LI %') +
		dbo.fBusca_Custo(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'%licen%') LI,
		dbo.fbusca_docs_po_modal(HOU.Num_Proc_Him,'10')	Nr_Nota_Fiscal,
		NF.Data_PO_HIM		Data_NF,
		DI.Numero_PO_HIM		DI_NUMBER,
		DI.Data_PO_HIM			DI_DATE,
		dbo.fBusca_Tarefa(hou.num_proc_him,'40') Dt_Prestacao,
		dbo.fBusca_Tarefa(hou.num_proc_him,'13') entrega_planta,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Capatazias') THCDI,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Peso_Liquido') Peso_Liquido
	from
		House_IMP_Mar HOU
		Join LLP_IMP_Mar			LLP	on HOU.Num_Proc_Him = LLP.Num_Proc_LIM
--		Left outer join Fatura_CHB	FCHB on HOU.Num_Proc_Him = FCHB.Processo_PC
		Left Join Pedido_Ship 		PS	on HOU.Num_Proc_HIM = PS.Num_Proc
		Left Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
		Left Join Localidade		LC	on Hou.Cd_Dst_HIM = Lc.Cd_Local
		Left Join PO_HIM			PO  on hou.num_proc_him = po.num_proc_him and PO.Id_Dc=1
		Left Join PO_HIM			SO	on hou.num_proc_him = SO.num_proC_him and SO.ID_DC=3
		Left Join PO_HIM			INV on HOU.num_proc_him=INV.num_proc_him and INV.ID_DC=2
		Left Join PO_HIM			NF  on hou.num_proc_him = NF.num_proc_him and NF.Id_Dc=10
		left join PO_HIM			DI	on hou.num_proc_him = DI.num_proc_him and DI.id_dc=5
		Left Join Tarefas_Processos	TP	on hou.num_proc_him=TP.num_proc and TP.id_task=13
		join pessoa_LLP				GR	on GR.cd_pes = HOU.cd_consig_him and GR.cd_pes_grupo = @cd_pes_grupo
	where
		dt_conclusao between @Dt_Inicial and @Dt_Final
--		AND HOU.NUM_PROC_HIM='IMDEC20100700901'
	Group by
		Incoterm,
		cd_consig_HIM,PS.CD_Pedido, PS.Cd_Produto,
		HOU.Num_Proc_HIM										,
		convert(datetime,HOU.Dt_Emis_Him,105)					,
		IsNull(PO.numero_po_him,P.Num_PO)						,
		PS.Item													,
		PC.Cd_Proc_Cliente										,
		PC.Produto_Descr										,	
		hou.cd_tp_oper											,
		INV.numero_po_him										,
		INV.Data_po_him											,
		LLP.ATD_Lim												,
		LLP.ATA_Lim												,	
		PS.Qty													,
		PD.UOM,
		NF.Data_PO_HIM		,
		DI.Numero_PO_HIM		,
		DI.Data_PO_HIM			

UNION all

	select 
		dbo.fBusca_Pessoa(cd_consig_hia,'1')					Consignee,
		dbo.fBusca_Pessoa(cd_consig_hia,'3')					Consig_CNPJ,
		HOU.Num_Proc_HIA										BDP_Reference,
		convert(datetime,HOU.Dt_Emis_HiA,105)					Register_Date,
		IsNull(PO.numero_po_hia,P.Num_PO)						PO_Number,
		PS.Item													PO_Item,
		PC.Cd_Proc_Cliente										GMIDs,
		PC.Produto_Descr										Produtos,
		Isnull(hou.cd_tp_oper,incoterm)							Incoterm,
		'Air Import' 											Mode_Transportation,
		INV.numero_po_hia										Invoice_Number,
		INV.Data_po_hia											Invoice_Data,
		LLP.ATD_Lia												Sailing_Date,
		LLP.ATA_Lia												Date_Arrival,	
		PS.Qty													Qty_UOM,
		PD.UOM,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Hia,PS.CD_Pedido, PS.Cd_Produto,'CIF') CIF,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Hia,PS.CD_Pedido, PS.Cd_Produto,'FOB') FOB,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Quantidade') Vlr_Total_Item,
--		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Frete') + dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'FRETE - CHB%')    Vlr_FRETE,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HiA,PS.CD_Pedido, PS.Cd_Produto,'Vlr_FRETE') Vlr_FRETE,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_II') ALIQ_II,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'VL_II') VL_II,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_IPI') ALIQ_IPI,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Hia,PS.CD_Pedido, PS.Cd_Produto,'Seguro') Seguro,

		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'IPI%') VL_BASE_IPI, -- Aqui é o vlr_IPI
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%PIS%')	vlrPIS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%COFINS%') vlrCOFINS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%ICMS%')	vlrICMS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%AFRMM%') AFRMM,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Adic%Frete%') Adic_FRETE,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%Armazenagem%') ARMAZENAGEM,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%Demurrage%') DEMURRAGE,

		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'THC%') +
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Capatazia%') THC,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'BAF%') BAF,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Frete Int%') Transp_Int,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Serv%Desp%') Serv_Desp,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%Retirada%')+ dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'AWB%') Lib_BL,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%SISCO%') SISCOMEX,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'ISPS%') ISPS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Desconso%') Desconsol,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Lavagem CNTR%') Lavagem,
--		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Seguro%') Seguro,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Gestão%') Gestao,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'ISS %') ISS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%Siscarga%') Siscarga,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'SDA%')	SDA,
		dbo.fBusca_Custo(HOU.Num_Proc_HiA,PS.CD_Pedido, PS.Cd_Produto,'LI %') +
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%licen%') LI,

		dbo.fbusca_docs_po_modal(HOU.Num_Proc_Hia,'10')		Nr_Nota_Fiscal,
		NF.Data_PO_HIA		Data_NF,
		DI.Numero_PO_HIA		DI_NUMBER,
		DI.Data_PO_HIA			DI_DATE,
		dbo.fBusca_Tarefa(hou.num_proc_hia,'40') Dt_Prestacao,
		dbo.fBusca_Tarefa(hou.num_proc_hia,'13') entrega_planta,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Hia,PS.CD_Pedido, PS.Cd_Produto,'Capatazias') THCDI,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Hia,PS.CD_Pedido, PS.Cd_Produto,'Peso_Liquido') Peso_Liquido
	from
		House_IMP_Aer HOU
		Join LLP_IMP_Aer			LLP	on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
--		Left outer join Fatura_CHB	FCHB on HOU.Num_Proc_HIA = FCHB.Processo_PC
		Left Join Pedido_Ship 		PS	on HOU.Num_Proc_HIA = PS.Num_Proc
		Left Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
		Left Join Localidade		LC	on Hou.Cd_Dst_HIA = Lc.Cd_Local
		Left Join PO_HIA			PO  on hou.num_proc_HIA = po.num_proc_HIA and PO.Id_Dc=1
		Left Join PO_HIA			SO	on hou.num_proc_HIA = SO.num_proC_HIA and SO.ID_DC=3
		Left Join PO_HIA			INV on HOU.num_proc_HIA=INV.num_proc_HIA and INV.ID_DC=2
		Left Join PO_HIA			NF  on hou.num_proc_HIA = NF.num_proc_HIA and NF.Id_Dc=10
		left join PO_HIA			DI	on hou.num_proc_HIA = DI.num_proc_HIA and DI.id_dc=5
		Left Join Tarefas_Processos	TP	on hou.num_proc_HIA=TP.num_proc and TP.id_task=13
		join pessoa_LLP				GR	on GR.cd_pes = HOU.cd_consig_hia and GR.cd_pes_grupo = @cd_pes_grupo
	where
		dt_conclusao between @Dt_Inicial and @Dt_Final
		and right(left(HOU.Num_Proc_HIA,5),3) = @Grupo
	--	AND HOU.NUM_PROC_HIA='IMDEC20090402401'
	Group by
		cd_consig_hia,
		HOU.Num_Proc_HIA										,
		convert(datetime,HOU.Dt_Emis_HiA,105)					,
		IsNull(PO.numero_po_hia,P.Num_PO)						,
		PS.Item													,
		PC.Cd_Proc_Cliente										,
		PC.Produto_Descr										,
		hou.cd_tp_oper											,
		INV.numero_po_hia										,
		INV.Data_po_hia											,
		LLP.ATD_Lia												,
		LLP.ATA_Lia												,	
		PS.Qty													,
		PD.UOM,
		NF.Data_PO_HIA		,
		DI.Numero_PO_HIA		,
		DI.Data_PO_HIA	,
		PS.CD_Pedido, 
		PS.Cd_Produto,		
		Incoterm
















GO

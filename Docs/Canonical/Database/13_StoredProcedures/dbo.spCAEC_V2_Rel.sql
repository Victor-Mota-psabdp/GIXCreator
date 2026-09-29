SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	nova CAEC passando o processo como parametro
*/
CREATE	Procedure	 [dbo].[spCAEC_V2_Rel] --'IMCSR20090300201'
@Processo varchar(16)
As
	select
		@Processo												BDP_Reference,
		convert(datetime,HOU.Dt_Emis_Him,105)					Register_Date,
		IsNull(dbo.fBusca_Docs_PO_Modal(@Processo,1),P.Num_PO)	PO_Number,
		PS.Item													PO_Item,
		Isnull(dbo.fBusca_Docs_PO_Modal(@Processo,3),P.Num_Pedido) Sap_Order_Number,
		dbo.fBusca_GMID(@Processo)								GMIDs,
		dbo.fBusca_PRODUTO(@Processo)							Produtos,
		isnull(PD.NCM, dbo.fNCM(@Processo))						NCM,
		DC.Cd_Planta 											Delivering_Plant_ID,
		DC.Planta_Nome											Delivering_Company,
		P.Planta												Receiving_Company_Code,
		RC.Planta_Nome											Receiving_Plant,
		num_cpf_cnpj											Receiving_Company_CNPJ,
		LC.Pais_Local											Country_Destination,
		'Sea Import' 											Mode_Transportation,
		INV.numero_po_him										Invoice_Number,
		INV.Data_po_him											Invoice_Data,
		LLP.ATD_Lim												Sailing_Date,
		LLP.ATA_Lim												Date_Arrival,
		TP.Dt_Conclusao											Good_receipt,	
		dbo.fBusca_UoM(@Processo,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'Qty')/ IsNull(dbo.fBusca_NotaFiscal_Paridade(@Processo),1) Qty_UOM,
		dbo.fBusca_UoM(@Processo,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'UOM') UOM,

		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'Quantidade') Quantidade,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'Vlr_FRETE') Vlr_FRETE,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_II') ALIQ_II,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'VL_II') VL_II,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_IPI') ALIQ_IPI,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'VL_IPI') VL_BASE_IPI,

		dbo.fBusca_Custo_Processo(@Processo,'%PIS%')	vlrPIS,
		dbo.fBusca_Custo_Processo(@Processo,'%COFINS%') vlrCOFINS,
		dbo.fBusca_Custo_Processo(@Processo,'%ICMS%')	vlrICMS,
		dbo.fBusca_Custo_Processo(@Processo,'%AFRMM%') +
		dbo.fBusca_Custo_Processo(@Processo,'%Frete Interno%') +
		dbo.fBusca_Custo_Processo(@Processo,'%Armazenagem%') +
		dbo.fBusca_Custo_Processo(@Processo,'%Demurrage%') vlrOutrosCustos,
		dbo.fBusca_Custo_Processo(@Processo,'%AFRMM%') AFRMM,
		dbo.fBusca_Custo_Processo(@Processo,'%Frete Interno%') FRETE,
		dbo.fBusca_Custo_Processo(@Processo,'%Armazenagem%') ARMAZENAGEM,
		dbo.fBusca_Custo_Processo(@Processo,'%Demurrage%') DEMURRAGE,		
		NF.Numero_PO_Him	Nr_Nota_Fiscal,
		NF.Data_PO_HIM		Data_NF,
		max(Processo_PC)	Status,
		Business_Descr
	from
		House_IMP_Mar HOU
		Join LLP_IMP_Mar			LLP	on LLP.Num_Proc_LIM = @Processo
		Left outer join Fatura_CHB	FCHB on FCHB.Processo_PC = @Processo
		Left Join Pedido_Ship 		PS	on PS.Num_Proc = @Processo
		Left Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
		Left Join De_Para_Produto	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
		Left Join Pessoa_LLP		RC	on P.Planta = RC.cd_planta and RC.Planta_Nome is not null and RC.Cd_Pes_Grupo='1'
		Left Join Pessoa_LLP		DC	on P.Cd_Seller = DC.Cd_Pes and DC.Planta_Nome is not null and DC.Cd_Pes_Grupo='1'
		Left Join Pessoa			RCC	on cd_consig_him = RCC.Cd_Pes --and num_cpf_cnpj <> ''
		Left Join Localidade		LC	on Hou.Cd_Dst_HIM = Lc.Cd_Local
		Left Join PO_HIM			INV on @Processo = INV.num_proc_him and INV.ID_DC=2
		Left Join PO_HIM			NF  on @Processo = NF.num_proc_him and NF.Id_Dc=10
		Left Join Tarefas_Processos	TP	on @Processo = TP.num_proc and TP.id_task=13
		Join Pessoa_LLP				PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo='1'
	where
		HOU.Num_Proc_HIM = @Processo and TP.dt_conclusao is not null 
		--and dbo.fBusca_Tarefa(@Processo,'4') <= '2009-12-31'
	Group by
			HOU.Dt_Emis_Him,
			P.Num_PO,
			PS.Item,
			P.Num_Pedido,
			DC.Cd_Planta,
			DC.Planta_Nome,
			P.Planta,
			RC.Planta_Nome,
			LC.Pais_Local,
			INV.numero_po_him,
			INV.Data_po_him,
			LLP.ATD_Lim,
			LLP.ATA_Lim,
			PS.CD_Pedido, PS.Cd_Produto,
			num_cpf_cnpj,
			Dt_conclusao,
			NF.Numero_PO_Him,
			NF.Data_PO_HIM,Business_Descr,PD.NCM

UNION all
	select 
		@Processo												BDP_Reference,
		convert(datetime,HOU.Dt_Emis_HIA,105)					Register_Date,
		IsNull(dbo.fBusca_Docs_PO_Modal(@Processo,1),P.Num_PO)	PO_Number,
		PS.Item													PO_Item,
		Isnull(dbo.fBusca_Docs_PO_Modal(@Processo,3),P.Num_Pedido) Sap_Order_Number,
		dbo.fBusca_GMID(@Processo)								GMIDs,
		dbo.fBusca_PRODUTO(@Processo)							Produtos,
		isnull(PD.NCM, dbo.fNCM(@Processo))						NCM,
		DC.Cd_Planta 											Delivering_Plant_ID,
		DC.Planta_Nome											Delivering_Company,
		P.Planta												Receiving_Company_Code,
		RC.Planta_Nome											Receiving_Plant,
		num_cpf_cnpj											Receiving_Company_CNPJ,
		LC.Pais_Local											Country_Destination,
		'Air Import' 											Mode_Transportation,
		INV.numero_po_HIA										Invoice_Number,
		INV.Data_po_HIA											Invoice_Data,
		LLP.ATD_LIA												Sailing_Date,
		LLP.ATA_LIA												Date_Arrival,
		TP.Dt_Conclusao											Good_receipt,

--		cast(Isnull(sum(PD.Peso_Item * PD.Qty),0)/1000 as float)	
		dbo.fBusca_UoM(@Processo,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'Qty')/ IsNull(dbo.fBusca_NotaFiscal_Paridade(@Processo),1) Qty_UOM,
		dbo.fBusca_UoM(@Processo,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'UOM') UOM,

		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'Quantidade') Quantidade,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'Vlr_FRETE') Vlr_FRETE,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_II') ALIQ_II,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'VL_II') VL_II,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_IPI') ALIQ_IPI,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'VL_IPI') VL_BASE_IPI,

		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%PIS%')	vlrPIS,
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%COFINS%') vlrCOFINS,
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%ICMS%')	vlrICMS,
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%AFRMM%') +
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%Frete Interno%') +
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%Armazenagem%') +
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%Demurrage%') vlrOutrosCustos,
		dbo.fBusca_Custo_Processo (@Processo,'%AFRMM%') AFRMM,
		dbo.fBusca_Custo_Processo (@Processo,'%Frete Interno%') FRETE,
		dbo.fBusca_Custo_Processo (@Processo,'%Armazenagem%') ARMAZENAGEM,
		dbo.fBusca_Custo_Processo (@Processo,'%Demurrage%') DEMURRAGE,
		NF.Numero_PO_HIA	Nr_Nota_Fiscal,
		NF.Data_PO_HIA		Data_NF,
		max(Processo_PC)	Status,	
		Business_Descr
	from
		House_IMP_Aer HOU
		Join LLP_IMP_Aer			LLP	on LLP.Num_Proc_LIA = @Processo
		Left outer join Fatura_CHB	FCHB on FCHB.Processo_PC = @Processo
		Left Join Pedido_Ship 		PS	on PS.Num_Proc = @Processo
		Left Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
		Left Join De_Para_Produto	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
		Left Join Pessoa_LLP		RC	on P.Planta = RC.cd_planta and RC.Planta_Nome is not null and RC.Cd_Pes_Grupo='1'
		Left Join Pessoa_LLP		DC	on P.Cd_Seller = DC.Cd_Pes and DC.Planta_Nome is not null and DC.Cd_Pes_Grupo='1'
		Left Join Pessoa			RCC	on Cd_Consig_Hia = RCC.Cd_Pes --and num_cpf_cnpj <> ''
		Left Join Localidade		LC	on Hou.Cd_Dst_HIA = Lc.Cd_Local
		Left Join PO_HIA			INV on @Processo = INV.num_proc_HIA and INV.ID_DC=2
		Left Join PO_HIA			NF  on @Processo = NF.num_proc_hia and NF.Id_Dc=10
		Left Join Tarefas_Processos	TP	on @Processo = TP.num_proc and TP.id_task=13
		Join Pessoa_LLP				PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo='1'
	where
		HOU.Num_Proc_HIA = @Processo and TP.dt_conclusao is not null 
		--and dbo.fBusca_Tarefa(@Processo,'4') <= '2009-12-31'
	Group by
			HOU.Dt_Emis_HIA,
			P.Num_PO,
			PS.Item,
			P.Num_Pedido,
			DC.Cd_Planta,
			DC.Planta_Nome,
			P.Planta,
			RC.Planta_Nome,
			LC.Pais_Local,
			INV.numero_po_HIA,
			INV.Data_po_HIA,
			LLP.ATD_LIA,
			LLP.ATA_LIA,
			PS.CD_Pedido, PS.Cd_Produto,
			num_cpf_cnpj,
			Dt_conclusao,
			NF.Numero_PO_HIA,
			NF.Data_PO_HIA,
			Business_Descr, PD.NCM

UNION all
	select 
		@Processo												BDP_Reference,
		convert(datetime,HOU.Dt_Emis_HIO,105)					Register_Date,
		IsNull(dbo.fBusca_Docs_PO_Modal(@Processo,1),P.Num_PO)	PO_Number,
		PS.Item													PO_Item,
		Isnull(dbo.fBusca_Docs_PO_Modal(@Processo,3),P.Num_Pedido) Sap_Order_Number,
		dbo.fBusca_GMID(@Processo)								GMIDs,
		dbo.fBusca_PRODUTO(@Processo)							Produtos,
		isnull(PD.NCM, dbo.fNCM(@Processo))						NCM,
		DC.Cd_Planta 											Delivering_Plant_ID,
		DC.Planta_Nome											Delivering_Company,
		P.Planta												Receiving_Company_Code,
		RC.Planta_Nome											Receiving_Plant,
		num_cpf_cnpj											Receiving_Company_CNPJ,
		LC.Pais_Local											Country_Destination,
		'Import' 												Mode_Transportation,
		INV.numero_po_HIO										Invoice_Number,
		INV.Data_po_HIO											Invoice_Data,
		LLP.ATD_LIO												Sailing_Date,
		LLP.ATA_LIO												Date_Arrival,
		TP.Dt_Conclusao											Good_receipt,

		dbo.fBusca_UoM(@Processo,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'Qty')/ IsNull(dbo.fBusca_NotaFiscal_Paridade(@Processo),1) Qty_UOM,
		dbo.fBusca_UoM(@Processo,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'UOM') UOM,

		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'Quantidade') Quantidade,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'Vlr_FRETE') Vlr_FRETE,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_II') ALIQ_II,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'VL_II') VL_II,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_IPI') ALIQ_IPI,
		dbo.fBusca_Vlr_NF_Det(@Processo,PS.CD_Pedido, PS.Cd_Produto,'VL_IPI') VL_BASE_IPI,

		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%PIS%')	vlrPIS,
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%COFINS%') vlrCOFINS,
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%ICMS%')	vlrICMS,
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%AFRMM%') +
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%Frete Interno%') +
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%Armazenagem%') +
		dbo.fBusca_Custo(@Processo,PS.CD_Pedido, PS.Cd_Produto,'%Demurrage%') vlrOutrosCustos,
		dbo.fBusca_Custo_Processo (@Processo,'%AFRMM%') AFRMM,
		dbo.fBusca_Custo_Processo (@Processo,'%Frete Interno%') FRETE,
		dbo.fBusca_Custo_Processo (@Processo,'%Armazenagem%') ARMAZENAGEM,
		dbo.fBusca_Custo_Processo (@Processo,'%Demurrage%') DEMURRAGE,
		NF.Numero_PO_HIO	Nr_Nota_Fiscal,
		NF.Data_PO_HIO		Data_NF,
		max(Processo_PC)	Status,
		Business_Descr
	from
		House_IMP_Out HOU
		Join LLP_IMP_Out			LLP	on LLP.Num_Proc_LIO = @Processo
		Left outer join Fatura_CHB	FCHB on FCHB.Processo_PC = @Processo
		Left Join Pedido_Ship 		PS	on PS.Num_Proc = @Processo
		Left Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
		Left Join De_Para_Produto	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
		Left Join Pessoa_LLP		RC	on P.Planta = RC.cd_planta and RC.Planta_Nome is not null and RC.Cd_Pes_Grupo='1'
		Left Join Pessoa_LLP		DC	on P.Cd_Seller = DC.Cd_Pes and DC.Planta_Nome is not null and DC.Cd_Pes_Grupo='1'
		Left Join Pessoa			RCC	on RC.Cd_Pes = RCC.Cd_Pes and num_cpf_cnpj <> ''
		Left Join Localidade		LC	on Hou.Cd_Dst_HIO = Lc.Cd_Local
		Left Join PO_HIO			INV on @Processo = INV.num_proc_HIO and INV.ID_DC=2
		Left Join PO_HIO			NF  on @Processo = NF.num_proc_hio and NF.Id_Dc=10
		Left Join Tarefas_Processos	TP	on @Processo = TP.num_proc and TP.id_task=13
		Join Pessoa_LLP				PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo='1'
	where
		HOU.Num_Proc_HIO = @Processo and dt_conclusao is not null 
		--and dbo.fBusca_Tarefa(@Processo,'4') <= '2009-12-31'
	Group by
			HOU.Dt_Emis_HIO,
			P.Num_PO,
			PS.Item,
			P.Num_Pedido,
			DC.Cd_Planta,
			DC.Planta_Nome,
			P.Planta,
			RC.Planta_Nome,
			LC.Pais_Local,
			INV.numero_po_HIO,
			INV.Data_po_HIO,
			LLP.ATD_LIO,
			LLP.ATA_LIO,
			PS.CD_Pedido, PS.Cd_Produto,
			num_cpf_cnpj,
			Dt_conclusao,
			NF.Numero_PO_HIO,
			NF.Data_PO_HIO,
			Business_Descr,PD.NCM
















GO

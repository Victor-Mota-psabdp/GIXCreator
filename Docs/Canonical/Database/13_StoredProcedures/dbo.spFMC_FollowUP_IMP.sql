SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from llp_imp_mar where num_proc_lim like '%FMC%'
select *  from tipo_tarefas where cd_pes_grupo=362
select * from tipo_ocorrencia
select * from tipo_doc_cliente
select * from house_imp_mar where num_proc_him like '%FMC%'
*/





CREATE	Procedure [dbo].[spFMC_FollowUP_IMP] 
as
	select
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,1)		PO,
		HOU.Num_Proc_HIM									JOB,
		HOU.Dt_Emis_HIM										Data,
		CSN.Apelido											Buyer,
		null												Status,
		PC.Cd_Proc_Cliente									Cod_Produto,
		PDET.UOM											UN,
		PC.Produto_Descr,
		HOU.Peso_Liquido_HIM								Peso_Liquido,
		null												KGAI,
		HOU.Qtd_Tot_Vol_HIM									QTD,
		dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc_HIM,25)	Data_Req,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,25)		Requerimento,
		dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc_HIM,23)	Data_LI,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,25)		LI,
		null												MAPA_Apl,
		dbo.fBusca_Tarefa(hou.num_proc_him,39)				MAPA_Apr,
		dbo.fBusca_Tarefa(hou.num_proc_him,20)				LI_Apr,
		dbo.fBusca_Tarefa(hou.num_proc_him,16)	+ 120		LI_Val,
		SEL.Apelido											Seller,
		'Origem'											Planta_Embarque,
		ATA_LIM + 10										RTP,
		null												ETP,
		null												ATP,
		ETD_LIM												ETD,
		ATD_LIM												ATD, 	
		'OCEAN'												Modal,
		ARM.Nome_Armador									Carrier,
		Navio_HIM											Navio_Voo,
		ETA_LIM												ETA,
		ATA_LIM												ATA,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,2)		Num_INV,
		LLP.Vlr_Invoice										Vlr_INV,
		HOU.Cd_Tp_Oper										Incoterm,
		HOU.MAWB_HIM										BL_AWB,
		ATD_LIM												BL_Date,
		HOU.Vol_Tot_HIM										Volume,
		isnull(dbo.fBusca_Containers_IM(hou.num_proc_him),dbo.fBusca_Volumes(hou.num_proc_him)) Containers,
		dbo.fBusca_Tarefa(hou.num_proc_him,16)				Chegada_Docs,
		dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc_HIM,45)	Data_DTA,
		null												Canal_DTA,
		null												MAPA_Clear,
		null												DTA_Clear,
		null												Terminal_1,
		null												Dt_Descarga_Terminal,
		TERM.Nome_Terminal									Terminal_2,
		dbo.fBusca_Tarefa(hou.num_proc_him,15)				Presenca_Carga,
		null												Dt_Transito,
		null												Chegada_EADI,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,5)		DI,
		dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc_HIM,5)	Data_DI,
		LLP.Canal_LIM										Canal,
		dbo.fBusca_Tarefa(hou.num_proc_him,4)				Data_Desemb,
		null												Insp_Embalagem,
		Dst.Nome_Local										Destino,
		ETA_LIM + 10										Request_Dt_Plant,
		null												Dt_Est_Uberaba,
		null												Dt_Corrente_Uberaba,
		dbo.fBusca_Tarefa(hou.num_proc_him,13)				Dt_Atual_Uberaba,
		MAS.Dt_Vcto_Devol_IM								Devol_Container,
		null												Devol_Terminal,
		MAS.Dt_Devol_IM										Devol_Data,
		null												Demurrage,
		dbo.fBusca_Tarefa(hou.num_proc_him,14)				Data_Fatura_BDP,
		dbo.fBusca_Tarefa(hou.num_proc_him,40)				Data_Envio_Fatura,
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico
	from
		house_imp_mar HOU with(nolock)
		Join LLp_imp_mar LLP with(nolock) on LLP.num_proc_LIM=hou.num_proc_HIM
		Left Join Pessoa CSN with(nolock) on CSN.Cd_Pes=HOU.Cd_Consig_HIM
		Left Join Pessoa SEL with(nolock) on SEL.Cd_Pes=HOU.Cd_Export_HIM
		left Join Pedido_Ship PS with(nolock) on PS.num_proc=hou.num_proc_HIM
		left Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
		Left Join Pedido_Det PDET with(nolock) on PDET.cd_pedido=PS.cd_pedido 
		left Join Job_imp_mar JOB with(nolock) on JOB.num_proc_him=hou.num_proc_him
		left Join Armador ARM with(nolock) on ARM.cd_armador=job.cd_armador
		left Join Produto_cliente PC with(nolock) on PC.cd_prod=ps.cd_produto
		left Join Localidade Org with(nolock) on hou.cd_org_HIM=Org.cd_local
		left Join Localidade Dst with(nolock) on cd_dst_HIM=DSt.cd_local
		Left Join Terminal TERM with(nolock) on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join Container_Hou_Imp_Mar CONT with(nolock) on CONT.Num_Proc_HIM = HOU.Num_Proc_MIM
		Left Join Container_Mas_Imp_Mar MAS with(nolock) on MAS.Num_Proc_MIM = CONT.Num_Proc_MIM and MAS.Item_Cont_IM = CONT.Item_Cont_IM   
		Join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo='362'
	group by
		HOU.Num_Proc_HIM,
		HOU.Dt_Emis_HIM,
		CSN.Apelido,
		PC.Cd_Proc_Cliente,
		PDET.UOM,
		PC.Produto_Descr,
		HOU.Peso_Liquido_HIM,
		HOU.Qtd_Tot_Vol_HIM,
		SEL.Apelido,
		ETD_LIM,
		ATD_LIM, 	
		ARM.Nome_Armador,
		Navio_HIM,
		ETA_LIM,
		ATA_LIM,
		LLP.Vlr_Invoice,
		HOU.Cd_Tp_Oper,
		HOU.MAWB_HIM,
		ATD_LIM,
		HOU.Vol_Tot_HIM,
		TERM.Nome_Terminal,
		LLP.Canal_LIM,
		Dst.Nome_Local,
		PO_Req_Date,
		MAS.Dt_Vcto_Devol_IM,
		MAS.Dt_Devol_IM



GO

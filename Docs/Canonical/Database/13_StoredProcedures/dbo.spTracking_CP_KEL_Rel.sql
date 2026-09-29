SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	Procedure [dbo].[spTracking_CP_KEL_Rel] --'CPK'
(
@Grupo as varchar(3)
)
As
	select
		HOU.Num_Proc_HEM										Ref_BDP,
		CSN.Apelido												Shipper,
		CONS.Apelido											Consignee,
		Org.Nome_Local											Origem,
		Dst.Nome_Local											Destino,
		Navio_Hem												Navio_Voo,
		HOU.HAWB_HEM											House,
		ETD_LEM													ETD,
		ATD_LEM													ATD,
		ETA_LEM													ETA,
		ATA_LEM													ATA,
		HOU.Viagem_HEM											Voyage,
		TC.Nome_Tp_Carga										Carga,
		BJOB.Numero_po_hem										BDP_Transport,
		JOB.Nr_Reserva											Booking,
		VOL.Qtd_Vol_Em											Volume1,
		TE.Nome_Tp_Embal										Volume2,
		dbo.fBusca_HistoricoDescr(hou.num_proc_hem,0,getdate()) Historico,
		dbo.fBusca_Docs_PO_Modal(hou.num_proc_hem, 3)			Ship_reference,
		dbo.fBusca_Docs_PO_Modal(hou.num_proc_hem, 9)			Cust_reference,
		dbo.fBusca_Containers(Hou.Num_Proc_Hem)					Container,
		dbo.fBusca_TEUS(hou.num_proc_hem)						TEUS,
		LLP.PO_Req_Date											PO_Req,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hem, 13)			ETA_Final,
		dbo.fBusca_Tarefa(hou.num_proc_hem, 13)					ATA_Final,
		PG.Apelido												Nome_Grupo,
		dbo.fBusca_Tarefa(hou.num_proc_hem,4)					Dt_Desemb
--		CONT.Num_Lacre_em										Seal
	from
		House_Exp_Mar HOU
		Join LLp_Exp_mar					LLP on LLP.num_proc_lem=hou.num_proc_hem
		Left Join Job_Exp_Mar				JOB on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM
		Left Join Pessoa					CONS on HOU.Cd_Consig_HEM = CONS.Cd_Pes
		left Join Localidade				Org on hou.cd_org_hem=Org.cd_local
		left Join Localidade				Dst on cd_dst_hem=DSt.cd_local
		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Export_HEM
		left join PO_HEM					BJOB on BJOB.num_proc_hem = HOU.num_proc_hem and id_dc = '19'
		left join Volume_Exp_mar			VOL on VOL.Num_Proc_Hem = HOU.Num_Proc_Hem
		left join Tipo_Embalagem			TE on TE.cd_tp_embal = VOL.cd_tp_embal
		left join tipo_carga				TC on TC.Cd_Tp_Carga = LLP.Cd_Tp_Carga
		left Join Pedido_Ship				PS on PS.num_proc=hou.num_proc_HEM
		left Join Pedido					PD on PD.cd_pedido=PS.cd_pedido
		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HEM,5),3)
		join pessoa							PG on PG.cd_pes=G.cd_pes_grupo
--		join container_mas_exp_mar			CONT on CONT.Num_proc_mem = Hou.NUm_proc_hem
		Left Join Hist_Geral				CNL on num_proc_lem=CNL.hsgprocesso and cd_tp_ocor='28'
	where
		right(left(HOU.Num_Proc_HEM,9),4)>=2009 and right(left(HOU.Num_Proc_Hem, 5), 3) = @Grupo
		and CNL.hsgprocesso is null
	group by
		HOU.Num_Proc_HEM,
		CSN.Apelido,
		CONS.Apelido,
		Org.Nome_Local,
		Dst.Nome_Local,
		Navio_Hem,
		HOU.HAWB_HEM,
		ETD_LEM,
		ATD_LEM,
		ETA_LEM,
		ATA_LEM,
		HOU.Viagem_HEM,
		TC.Nome_Tp_Carga,
		BJOB.Numero_po_hem,
		JOB.Nr_Reserva,
		VOL.Qtd_Vol_Em,
		TE.Nome_Tp_Embal,
		LLP.PO_Req_Date,
		PG.Apelido
--		Cont.Num_Lacre_em

UNION
		select
		HOU.Num_Proc_HEO										Ref_BDP,
		CSN.Apelido												Shipper,
		CONS.Apelido											Consignee,
		Org.Nome_Local											Origem,
		Dst.Nome_Local											Destino,
		Voo_Heo													Navio_Voo,
		HOU.HAWB_HEO											House,
		ETD_LEO													ETD,
		ATD_LEO													ATD,
		ETA_LEO													ETA,
		ATA_LEO													ATA,
		'N/A'													Voyage,
		''														Carga,
		BJOB.Numero_po_heo										BDP_Transport,
		'N/A'													Booking,
		VOL.Qtd_Vol_Eo											Volume1,
		TE.Nome_Tp_Embal										Volume2,
		dbo.fBusca_HistoricoDescr(hou.num_proc_heo,0,getdate()) Historico,
		dbo.fBusca_Docs_PO_Modal(hou.num_proc_heo, 3)			Ship_reference,
		dbo.fBusca_Docs_PO_Modal(hou.num_proc_heo, 9)			Cust_reference,
		dbo.fBusca_Containers(Hou.Num_Proc_Heo)					Container,
		dbo.fBusca_TEUS(hou.num_proc_heo)						TEUS,
		LLP.PO_Req_Date											PO_Req,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_heo, 13)			ETA_Final,
		dbo.fBusca_Tarefa(hou.num_proc_heo, 13)					ATA_Final,
		PG.Apelido												Nome_Grupo,
		dbo.fBusca_Tarefa(hou.num_proc_heo,4)					Dt_Desemb
--		CONT.Num_Lacre_em										Seal
	from
		House_Exp_Out HOU
		Join LLp_Exp_Out					LLP on LLP.num_proc_leo=hou.num_proc_heo
		Left Join Pessoa					CONS on HOU.Cd_Consig_HEO = CONS.Cd_Pes
		left Join Localidade				Org on hou.cd_org_heo=Org.cd_local
		left Join Localidade				Dst on cd_dst_heo=DSt.cd_local
		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Export_HEO
		left join PO_HEO					BJOB on BJOB.num_proc_heo = HOU.num_proc_heo and id_dc = '19'
		left join Volume_Exp_out			VOL on VOL.Num_Proc_Heo = HOU.Num_Proc_Heo
		left join Tipo_Embalagem			TE on TE.cd_tp_embal = VOL.cd_tp_embal	
		left Join Pedido_Ship				PS on PS.num_proc=hou.num_proc_HEO
		left Join Pedido					PD on PD.cd_pedido=PS.cd_pedido
		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HEO,5),3)
		join pessoa							PG on PG.cd_pes=G.cd_pes_grupo
--		join container_mas_exp_mar			CONT on CONT.Num_proc_mem = Hou.Num_proc_heo
		Left Join Hist_Geral				CNL on num_proc_leo=CNL.hsgprocesso and cd_tp_ocor='28'
	where
		right(left(HOU.Num_Proc_HEO,9),4)>=2009 and right(left(HOU.Num_Proc_Heo, 5), 3) = @Grupo
		and CNL.hsgprocesso is null
	group by
		HOU.Num_Proc_HEo,
		CSN.Apelido,
		CONS.Apelido,
		Org.Nome_Local,
		Dst.Nome_Local,
		Voo_Heo,
		HOU.HAWB_HEo,
		ETD_LEO,
		ATD_LEO,
		ETA_LEO,
		ATA_LEO,
		BJOB.Numero_po_heo,
		VOL.Qtd_Vol_Eo,
		TE.Nome_Tp_Embal,
		LLP.PO_Req_Date,
		PG.Apelido
--		Cont.Num_Lacre_em
		

UNION
	select
		HOU.Num_Proc_HEA										Ref_BDP,
		CSN.Apelido												Shipper,
		CONS.Apelido											Consignee,
		Org.Nome_Local											Origem,
		Dst.Nome_Local											Destino,
		Voo_Hea													Navio_Voo,
		HOU.HAWB_HEA											House,
		ETD_LEA													ETD,
		ATD_LEA													ATD,
		ETA_LEA													ETA,
		ATA_LEA													ATA,
		'N/A'													Voyage,
		''														Carga,
		BJOB.Numero_po_hea										BDP_Transport,
		'N/A'													Booking,
		VOL.Qtd_Vol_Ea											Volume1,
		TE.Nome_Tp_Embal										Volume2,
		dbo.fBusca_HistoricoDescr(hou.num_proc_hea,0,getdate()) Historico,
		dbo.fBusca_Docs_PO_Modal(hou.num_proc_hea, 3)			Ship_reference,
		dbo.fBusca_Docs_PO_Modal(hou.num_proc_hea, 9)			Cust_reference,
		dbo.fBusca_Containers(Hou.Num_Proc_Hea)					Container,
		dbo.fBusca_TEUS(hou.num_proc_hea)						TEUS,
		LLP.PO_Req_Date											PO_Req,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hea, 13)			ETA_Final,
		dbo.fBusca_Tarefa(hou.num_proc_hea, 13)					ATA_Final,
		PG.Apelido												Nome_Grupo,
		dbo.fBusca_Tarefa(hou.num_proc_hea,4)					Dt_Desemb
--		CONT.Num_Lacre_em										Seal
	from
		House_Exp_Aer HOU
		Join LLp_Exp_Aer					LLP on LLP.num_proc_lea = hou.num_proc_hea
		Left Join Job_Exp_Aer				JOB on HOU.Num_Proc_HEa = JOB.Num_Proc_HEa
		Left Join Pessoa					CONS on HOU.Cd_Consig_HEA = CONS.Cd_Pes
		left Join Localidade				Org on hou.cd_org_hea = Org.cd_local
		left Join Localidade				Dst on cd_dst_hea=DSt.cd_local
		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Export_HEA
		left join PO_HEA					BJOB on BJOB.num_proc_hea = HOU.num_proc_hea and id_dc = '19'
		left join Volume_Exp_Aer			VOL on VOL.Num_Proc_Hea = HOU.Num_Proc_Hea
		left join Tipo_Embalagem			TE on TE.cd_tp_embal = VOL.cd_tp_embal	
		left Join Pedido_Ship				PS on PS.num_proc=hou.num_proc_HEA
		left Join Pedido					PD on PD.cd_pedido=PS.cd_pedido
		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HEA,5),3)
		join pessoa							PG on PG.cd_pes=G.cd_pes_grupo
--		join container_mas_exp_mar			CONT on CONT.Num_proc_mem = Hou.Num_proc_hea
		Left Join Hist_Geral				CNL on num_proc_lea=CNL.hsgprocesso and cd_tp_ocor='28'
	where
		right(left(HOU.Num_Proc_HEA,9),4)>=2009 and right(left(HOU.Num_Proc_Hea, 5), 3) = @Grupo
		and CNL.hsgprocesso is null
	group by
		HOU.Num_Proc_HEA,
		CSN.Apelido,
		CONS.Apelido,
		Org.Nome_Local,
		Dst.Nome_Local,
		Voo_Hea,
		HOU.HAWB_HEA,
		ETD_LEA,
		ATD_LEA,
		ETA_LEA,
		ATA_LEA,
		BJOB.Numero_po_hea,
		VOL.Qtd_Vol_Ea,
		TE.Nome_Tp_Embal,
		LLP.PO_Req_Date,
		PG.Apelido
--		Cont.Num_Lacre_em












GO

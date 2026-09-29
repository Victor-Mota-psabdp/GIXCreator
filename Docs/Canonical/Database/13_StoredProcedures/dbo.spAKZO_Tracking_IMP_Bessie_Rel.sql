SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spAKZO_Tracking_IMP_Bessie_Rel] 

As
	select
		'OCEAN'											Modal,
		HOU.Num_Proc_HIM								Ref_BDP,
		PG.Apelido										Nome_Grupo,
		CSN.Apelido										Consignee,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,1)	PO,
		ETD_LIM											ETD,
		ATD_LIM											ATD,
		ETA_LIM											ETA,
		ATA_LIM											ATA,
		dbo.fBusca_Tarefa(hou.num_proc_him,60)			Abertura_Pasta,
		dbo.fBusca_Tarefa(hou.num_proc_him,15)			Presenca_Carga,
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico,
		dbo.fBusca_Tarefa(hou.num_proc_him,27)			Digitacao,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_him,59),
		dbo.FBusca_Adto(hou.num_proc_him))				Sol_Numerario,
		max(FCHB.Data_PC)								Prest_Contas,
		BL.DT_Envio										BL_Envio,
		INV.DT_Envio									INV_Envio,
		PLIST.DT_Envio									PLIST_Envio,
		COA.DT_Envio									COA_Envio,
		SHIP.DT_Envio									SHIP_Envio,
		SHP.Apelido										Shipper,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		(case when HOU.Num_Proc_Mim = 'JOB' then null else HOU.Num_Proc_Mim end)	Ref_Consolidada,
		DTRE.dt_envio										Dt_Re,
		DTDSE.dt_envio										Dt_DSE,
		DTDDE.dt_envio										Dt_DDE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_him,10)		Num_NF,
		DTCOMP.campo_dados									Dt_AFComprov,
		DTAVERB.campo_dados									DT_AFAverb,
		dbo.fbusca_docs(hou.num_proc_him,4)					Tp_doc_RE,
		dbo.fbusca_docs(hou.num_proc_him,26)				Tp_doc_DSE,
		vd.descricao										Urgente

	from
		house_imp_mar HOU
		Join LLP_Imp_Mar				LLP on LLP.num_proc_LIM=hou.num_proc_HIM
		left Join Job_Imp_Mar			JOB on JOB.num_proc_him=hou.num_proc_him
		left Join Armador				ARM on ARM.cd_armador=job.cd_armador
		left Join Pedido_Ship			PS on PS.num_proc=hou.num_proc_HIM
		left Join Pedido				PD on PD.cd_pedido=PS.cd_pedido
		Left Join Pedido_Det			PDET on PDET.cd_pedido=PS.cd_pedido
		left Join Produto_cliente		PC on PC.cd_prod=ps.cd_produto
		left Join Localidade			Org on hou.cd_org_HIM=Org.cd_local
		left Join Localidade			Dst on cd_dst_HIM=DSt.cd_local
--		Left Join Terminal				TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIM				DI on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
		Join Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_IMP = 'AKZ')
		Left Join Usuario_Cliente		UC on UC.cd_usuario=PD.PO_Responsible and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_IMP = 'AKZ')
		Join Pessoa						CSN on CSN.cd_pes=HOU.Cd_Consig_HIM
		left Join Fatura_CHB			FCHB on HOU.Num_Proc_HIM = FCHB.Processo_PC or HOU.Num_Proc_MIM=FCHB.Processo_PC
		join Grupo						G on G.grupo= right(left(HOU.Num_Proc_HIM,5),3)
		join pessoa						PG on PG.cd_pes=G.cd_pes_grupo
		left join doc_anexos			BL on BL.Num_Proc = HOU.Num_Proc_Him and BL.id_DC = 20 
		left join doc_anexos			INV on INV.Num_Proc = HOU.Num_Proc_Him and INV.id_DC = 2
		left join doc_anexos			PLIST on PLIST.Num_Proc = HOU.Num_Proc_Him and PLIST.id_DC = 11
		left join doc_anexos			COA on COA.Num_Proc = HOU.Num_Proc_Him and COA.id_DC = 16
		left join doc_anexos			SHIP on SHIP.Num_Proc = HOU.Num_Proc_Him and SHIP.id_DC = 47
		left join Pessoa				SHP on SHP.Cd_Pes = HOU.Cd_Export_Him
		left join doc_anexos			DTRE on DTRE.num_proc = LLP.num_proc_lim and DTRE.id_dc = '4'
		left join doc_anexos			DTDSE on DTDSE.num_proc = LLP.num_proc_lim and DTDSE.id_dc = '26'
		left join doc_anexos			DTDDE on DTDDE.num_proc = LLP.num_proc_lim and DTDDE.id_dc = '12'
		left join campo_processo		DTCOMP on DTCOMP.NUm_proc = LLP.Num_proc_lim and DTCOMP.id_campo = '41'
		left join campo_processo		DTAVERB on DTAVERB.NUm_proc = LLP.Num_proc_lim and DTAVERB.id_campo = '42'
		left join campo_processo      	CP on LLP.num_proc_lim=cp.num_proc and cp.id_campo=36
		left join verdade				VD on cp.campo_dados = VD.id
	where
		(right(left(HOU.Num_Proc_HIM,9),4)='2009' or right(left(HOU.Num_Proc_HIM,9),4)='2010')
		and dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,5) is null
		and ATD_LIM is not null
		and (ATA_LIM is null 
		or ETA_LIM +7 <= getdate()
		or (dbo.fBusca_Tarefa(hou.num_proc_him,59) is null AND dbo.FBusca_Adto(hou.num_proc_him) is null)
		or dbo.fBusca_Tarefa(hou.num_proc_him,27) is null 
		or dbo.fBusca_Tarefa(hou.num_proc_him,15) is null)
	group by
		HOU.Num_Proc_HIM,
		PG.Apelido,
		CSN.Apelido,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,1),
		ETD_LIM,
		ATD_LIM,
		ETA_LIM,
		ATA_LIM,
		dbo.fBusca_Tarefa(hou.num_proc_him,15),
		DI.Numero_PO_Him,
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()),
		dbo.fBusca_Tarefa(hou.num_proc_him,27),
		BL.DT_Envio,
		INV.DT_Envio,
		PLIST.DT_Envio,
		COA.DT_Envio,
		SHIP.DT_Envio,
		SHP.Apelido,
		HOU.Num_Proc_Mim,
		Org.Nome_Local,
		Dst.Nome_Local,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		vd.descricao

UNION ALL
	select
	    'AIR'											Modal,
		HOU.Num_Proc_HIA								Ref_BDP,
		PG.Apelido										Nome_Grupo,
		CSN.Apelido										Consignee,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,1)	PO,
		ETD_LIA											ETD,
		ATD_LIA											ATD,
		ETA_LIA											ETA,
		ATA_LIA											ATA,
		dbo.fBusca_Tarefa(hou.num_proc_hia,60)			Abertura_Pasta,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,15)			Presenca_Carga,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HIA,0,getdate()) Historico,
		dbo.fBusca_Tarefa(hou.num_proc_hia,27)			Digitacao,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hia,59),
		dbo.FBusca_Adto(hou.num_proc_hia))				Sol_Numerario,
		max(FCHB.Data_PC)								Prest_Contas,
		BL.DT_Envio										BL_Envio,
		INV.DT_Envio									INV_Envio,
		PLIST.DT_Envio									PLIST_Envio,
		COA.DT_Envio									COA_Envio,
		SHIP.DT_Envio									SHIP_Envio,
		SHP.Apelido										Shipper,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		(case when HOU.Num_Proc_Mia = 'JOB' then null else HOU.Num_Proc_Mia end)	Ref_Consolidada,
		DTRE.dt_envio									Dt_Re,
		DTDSE.dt_envio									Dt_DSE,
		DTDDE.dt_envio									Dt_DDE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hia,10)	Num_NF,
		DTCOMP.campo_dados								Dt_AFComprov,
		DTAVERB.campo_dados								DT_AFAverb,
		dbo.fbusca_docs(hou.num_proc_hia,4)				Tp_doc_RE,
		dbo.fbusca_docs(hou.num_proc_hia,26)			Tp_doc_DSE,
		vd.descricao									Urgente
	from
		house_imp_Aer HOU
		Join LLP_Imp_Aer				LLP on LLP.num_proc_LIA=hou.num_proc_HIA
		left Join Job_Imp_Aer			JOB on JOB.num_proc_HIA=hou.num_proc_HIA
		left Join Cia_Aerea				CIA on CIA.Cd_Cia_Aer=JOB.Cd_Cia_Aer
		left Join Pedido_Ship			PS on PS.num_proc=hou.num_proc_HIA
		left Join Pedido				PD on PD.cd_pedido=PS.cd_pedido
		Left Join Pedido_Det			PDET on PDET.cd_pedido=PS.cd_pedido
		left Join Produto_cliente		PC on PC.cd_prod=ps.cd_produto
		left Join Localidade			Org on hou.cd_org_HIA=Org.cd_local
		left Join Localidade			Dst on cd_dst_HIA=DSt.cd_local
		Left Join Terminal				TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIA				DI on DI.Num_Proc_HIA=hou.num_proc_HIA and DI.id_dc=5
		Join Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_IMP = 'AKZ')
		Left Join Usuario_Cliente		UC on UC.cd_usuario=PD.PO_Responsible and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_IMP = 'AKZ')
		Join Pessoa						CSN on CSN.cd_pes=HOU.Cd_Consig_HIA
		left Join Fatura_CHB			FCHB on HOU.Num_Proc_HIA = FCHB.Processo_PC or HOU.Num_Proc_MIA = FCHB.Processo_PC
		join Grupo						G on G.grupo= right(left(HOU.Num_Proc_HIa,5),3)
		join pessoa						PG on PG.cd_pes=G.cd_pes_grupo
		left join doc_anexos			BL on BL.Num_Proc = HOU.Num_Proc_Hia and BL.id_DC = 20 
		left join doc_anexos			INV on INV.Num_Proc = HOU.Num_Proc_Hia and INV.id_DC = 2
		left join doc_anexos			PLIST on PLIST.Num_Proc = HOU.Num_Proc_Hia and PLIST.id_DC = 11
		left join doc_anexos			COA on COA.Num_Proc = HOU.Num_Proc_Hia and COA.id_DC = 16
		left join doc_anexos			SHIP on SHIP.Num_Proc = HOU.Num_Proc_Hia and SHIP.id_DC = 47
		left join Pessoa				SHP on SHP.Cd_Pes = HOU.Cd_Export_Hia
		left join doc_anexos			DTRE on DTRE.num_proc = LLP.num_proc_lia and DTRE.id_dc = '4'
		left join doc_anexos			DTDSE on DTDSE.num_proc = LLP.num_proc_lia and DTDSE.id_dc = '26'
		left join doc_anexos			DTDDE on DTDDE.num_proc = LLP.num_proc_lia and DTDDE.id_dc = '12'
		left join campo_processo		DTCOMP on DTCOMP.NUm_proc = LLP.Num_proc_lia and DTCOMP.id_campo = '41'
		left join campo_processo		DTAVERB on DTAVERB.NUm_proc = LLP.Num_proc_lia and DTAVERB.id_campo = '42'
		left join campo_processo      	CP on LLP.num_proc_lia=cp.num_proc and cp.id_campo=36
		left join verdade				VD on cp.campo_dados = VD.id
	where
		(right(left(HOU.Num_Proc_HIA,9),4)='2009' or right(left(HOU.Num_Proc_HIA,9),4)='2010')
		and dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIa,5) is null
		and (ATA_LIA is null 
		or ETA_LIA +7 <= getdate()
		or (dbo.fBusca_Tarefa(hou.num_proc_hia,59) is null AND dbo.FBusca_Adto(hou.num_proc_hia) is null)
		or dbo.fBusca_Tarefa(hou.num_proc_hia,27) is null 
		or dbo.fBusca_Tarefa(hou.num_proc_hia,15) is null)
	group by
		HOU.Num_Proc_HIA,
		PG.Apelido,
		CSN.Apelido,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,1),
		ETD_LIA,
		ATD_LIA,
		ETA_LIA,
		ATA_LIA,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,15),
		dbo.fBusca_HistoricoDescr(hou.num_proc_HIA,0,getdate()),
		dbo.fBusca_Tarefa(hou.num_proc_hia,27),
--		AC.Dt_Solicitacao,
		BL.DT_Envio,
		INV.DT_Envio,
		PLIST.DT_Envio,
		COA.DT_Envio,
		SHIP.DT_Envio,
		SHP.Apelido,
		HOU.Num_Proc_Mia,
		Org.Nome_Local,
		Dst.Nome_Local,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		vd.descricao









GO

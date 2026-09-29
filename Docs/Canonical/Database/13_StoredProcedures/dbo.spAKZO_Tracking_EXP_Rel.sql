SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--
--select * from usuario_cliente
CREATE	Procedure [dbo].[spAKZO_Tracking_EXP_Rel]

As
	select
		BDPCSR.Nome_usuario								BDPCSR,
		'OCEAN'											Modal,
		HOU.Num_Proc_HEM								Ref_BDP,
		PG.Apelido										Nome_Grupo,
		CSN.Apelido										Shipper,
		CSN.Num_CPF_CNPJ								CNPJ,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,9)	CustomerPO,
		CONS.Apelido									Consignee,
		dbo.fBusca_GMID(HOU.Num_Proc_HEM)				Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HEM)			Produto,
		TP.NOME_Tp_Oper									Incoterm,
		dbo.fNCM(HOU.Num_Proc_HEM)						NCM,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		Nome_Armador									Carrier,
		Navio_Hem										Navio_Voo,
		HOU.MAWB_HEM									Master,
		HOU.HAWB_HEM									House,
		ETD_LEM											ETD,
		ATD_LEM											ATD,
		ETA_LEM											ETA,
		ATA_LEM											ATA,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,4)	RE,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,12)	DDE,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,26)	DSE,
		LLP.Canal_LEM									Canal,
		dbo.fBusca_Tarefa(hou.num_proc_hem,4)			Desembaraco,
		LLP.Courier_Number_LEM							Courier_Nr,
		dbo.fBusca_HistoricoDescr(hou.num_proc_hem,0,getdate()) Historico,
		UC.Nome_Usuario									Nome_PO,
		max(FCHB.Data_PC)								Prest_Contas,
		max(AC.Dt_Solicitacao)							Sol_Numerario,
		dbo.fBusca_Containers(hou.num_proc_hem)			Containers,
		dbo.Qty_Container(hou.num_proc_hem)				Qtde,
		dbo.FBusca_Docs(hou.num_proc_hem,2)				SN_Invoice,
		dbo.fbusca_docs(hou.num_proc_hem,11)			SN_Packing,
		dbo.fbusca_docs(hou.num_proc_hem,4)				SN_RE_Number,
		dbo.fbusca_docs(hou.num_proc_hem,12)			SN_DDE,
		dbo.fbusca_docs(hou.num_proc_hem,13)			SN_Certificado,
		dbo.fbusca_docs(hou.num_proc_hem,10)			SN_NF,
		dbo.fbusca_docs(hou.num_proc_hem,18)			SN_Riex,
		dbo.fbusca_docs(hou.num_proc_hem,21)			SN_Cert_Seg,
		dbo.fbusca_docs(hou.num_proc_hem,22)			SN_Cert_Furmica,
		dbo.fbusca_docs(hou.num_proc_hem,45)			SN_BL_Original,
		dbo.fbusca_docs(hou.num_proc_hem,15)			SN_Doc_Cambio,
		DTRE.dt_envio									Dt_Re,
		DTDSE.dt_envio									Dt_DSE,
		DTDDE.dt_envio									Dt_DDE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hem,10)   Num_NF,
		DTCOMP.campo_dados								Dt_AFComprov,
		DTAVERB.campo_dados								DT_AFAverb,
		dbo.fbusca_docs(hou.num_proc_hem,4)				Tp_doc_RE,
		dbo.fbusca_docs(hou.num_proc_hem,26)			Tp_doc_DSE,
		vd.descricao									Urgente,
		ATD_LEM											Dt_Conhecimento
	from
		House_Exp_Mar HOU
		Join LLp_Exp_mar					LLP on LLP.num_proc_lem=hou.num_proc_hem
		Join Job_exp_Mar					Job on job.num_proc_hem=hou.num_proc_hem
		Left Join Pessoa					CONS on HOU.Cd_Consig_HEM = CONS.Cd_Pes
		Left Join Tipo_Oper					TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left Join Pedido_Ship				PS on PS.num_proc=hou.num_proc_hem
		left Join Pedido					P on P.cd_pedido=PS.cd_pedido
		left Join Produto_cliente			PC on PC.cd_prod=ps.cd_produto
		left Join Armador					ARM on ARM.cd_armador=llp.cd_armador_lem
		left Join Localidade				Org on hou.cd_org_hem=Org.cd_local
		left Join Localidade				Dst on cd_dst_hem=DSt.cd_local
		Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Export_HEM and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_EXP = 'AKZ')
		Left Join Usuario_Cliente			UC on UC.cd_usuario=P.PO_Responsible --and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_EXP = 'AKZ')
		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Export_HEM
		left Join Fatura_CHB				FCHB on HOU.Num_Proc_HEM = FCHB.Processo_PC or HOU.Num_Proc_MEM = FCHB.Processo_PC
		left join Adiantamento_Cliente		AC on AC.Num_Proc = Hou.Num_proc_Hem
		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HEM,5),3)
		join pessoa							PG on PG.cd_pes=G.cd_pes_grupo
		left join doc_anexos				DTRE on DTRE.num_proc = LLP.num_proc_lem and DTRE.id_dc = '4'
		left join doc_anexos				DTDSE on DTDSE.num_proc = LLP.num_proc_lem and DTDSE.id_dc = '26'
		left join doc_anexos				DTDDE on DTDDE.num_proc = LLP.num_proc_lem and DTDDE.id_dc = '12'
		left join campo_processo			DTCOMP on DTCOMP.NUm_proc = LLP.Num_proc_lem and DTCOMP.id_campo = '41'
		left join campo_processo			DTAVERB on DTAVERB.NUm_proc = LLP.Num_proc_lem and DTAVERB.id_campo = '42'
		left join campo_processo      		CP on LLP.num_proc_lem=cp.num_proc and cp.id_campo=36
		left join verdade					VD on cp.campo_dados = VD.id
		left Join Usuario					BDPCSR on BDPCSR.cd_usuario=job.cd_usuario
	where
		(right(left(HOU.Num_Proc_HEM,9),4)='2009' or right(left(HOU.Num_Proc_HEM,9),4)='2010')
	group by
		BDPCSR.Nome_usuario,
		HOU.Num_Proc_HEM,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		CONS.Apelido ,
		TP.NOME_Tp_Oper	,
		Org.Nome_Local ,
		Dst.Nome_Local ,
		ETD_LEM ,
		ATD_LEM ,
		ETA_LEM ,
		ATA_LEM,
		Nome_Armador,
		Navio_Hem,
		HOU.MAWB_HEM,
		HAWB_HEM,
		LLP.Canal_LEM,
		LLP.Courier_Number_LEM,
		UC.Nome_Usuario,
--		AC.Dt_Solicitacao,
		PG.Apelido,
		vd.descricao,
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
		vd.descricao,
		ATD_LEM

UNION
	select
		BDPCSR.Nome_Usuario								BDPCSR,
		'AIR'											Modal,
		HOU.Num_Proc_HEA								Ref_BDP,
		PG.Apelido										Nome_Grupo,
		CSN.Apelido										Shipper,
		CSN.Num_CPF_CNPJ								CNPJ,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,9)	CustomerPO,
		CONS.Apelido									Consignee,
		dbo.fBusca_GMID(HOU.Num_Proc_HEA)				Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HEA)			Produto,
		TP.NOME_Tp_Oper									Incoterm,
		dbo.fNCM(HOU.Num_Proc_HEA)						NCM,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		Nome_Cia_Aer									Carrier,
		Voo_HEA											Navio_Voo,
		HOU.MAWB_HEA									Master,
		HOU.HAWB_HEA									House,
		ETD_LEA											ETD,
		ATD_LEA											ATD,
		ETA_LEA											ETA,
		ATA_LEA											ATA,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,4)	RE,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,12)	DDE,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,26)	DSE,
		LLP.Canal_LEA									Canal,
		dbo.fBusca_Tarefa(hou.num_proc_HEA,4)			Desembaraco,
		LLP.Courier_Number_LEA							Courier_Nr,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HEA,0,getdate()) Historico,
		UC.Nome_Usuario									Nome_PO,
		max(FCHB.Data_PC)								Prest_Contas,
		max(AC.Dt_Solicitacao)							Sol_Numerario,
		dbo.fBusca_Containers(hou.num_proc_hea)			Containers,
		dbo.Qty_Container(hou.num_proc_hea)				Qtde,
		dbo.FBusca_Docs(hou.num_proc_hea,2)				SN_Invoice,
		dbo.fbusca_docs(hou.num_proc_hea,11)			SN_Packing,
		dbo.fbusca_docs(hou.num_proc_hea,4)				SN_RE_Number,
		dbo.fbusca_docs(hou.num_proc_hea,12)			SN_DDE,
		dbo.fbusca_docs(hou.num_proc_hea,13)			SN_Certificado,
		dbo.fbusca_docs(hou.num_proc_hea,10)			SN_NF,
		dbo.fbusca_docs(hou.num_proc_hea,18)			SN_Riex,
		dbo.fbusca_docs(hou.num_proc_hea,21)			SN_Cert_Seg,
		dbo.fbusca_docs(hou.num_proc_hea,22)			SN_Cert_Furmica,
		dbo.fbusca_docs(hou.num_proc_hea,45)			SN_BL_Original,
		dbo.fbusca_docs(hou.num_proc_hea,15)			SN_Doc_Cambio,
		DTRE.dt_envio									Dt_Re,
		DTDSE.dt_envio									Dt_DSE,
		DTDDE.dt_envio									Dt_DDE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hea,10)   Num_NF,
		DTCOMP.campo_dados								Dt_AFComprov,
		DTAVERB.campo_dados								DT_AFAverb,
		dbo.fbusca_docs(hou.num_proc_hea,4)				Tp_doc_RE,
		dbo.fbusca_docs(hou.num_proc_hea,26)			Tp_doc_DSE,
		vd.descricao									Urgente,
		ATD_LEA											Dt_Conhecimento
	from
		House_Exp_Aer HOU
		Join LLp_Exp_Aer					LLP on LLP.num_proc_LEA=hou.num_proc_HEA
		Left Join Pessoa					CONS on HOU.Cd_Consig_HEA = CONS.Cd_Pes
		Join Job_Exp_aer					job on job.num_proc_hea=hou.num_proc_hea
		Left Join Tipo_Oper					TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left Join Pedido_Ship				PS on PS.num_proc=hou.num_proc_HEA
		left Join Pedido					P on P.cd_pedido=PS.cd_pedido
		left Join Produto_cliente			PC on PC.cd_prod=ps.cd_produto
		left Join Cia_Aerea					CIA on CIA.cd_cia_Aer=llp.cd_ciaaerea_lea
		left Join Localidade				Org on hou.cd_org_HEA=Org.cd_local
		left Join Localidade				Dst on cd_dst_HEA=DSt.cd_local
		Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Export_HEA and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_EXP = 'AKZ')
		Left Join Usuario_Cliente			UC on UC.cd_usuario=P.PO_Responsible --and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_EXP = 'AKZ')
		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Export_HEA
		left Join Fatura_CHB				FCHB on HOU.Num_Proc_HEA = FCHB.Processo_PC or HOU.Num_Proc_MEA = FCHB.Processo_PC
		left join Adiantamento_Cliente		AC on AC.Num_Proc = Hou.Num_proc_Hea
		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HEA,5),3)
		join pessoa							PG on PG.cd_pes=G.cd_pes_grupo
		left join doc_anexos				DTRE on DTRE.num_proc = LLP.num_proc_lea and DTRE.id_dc = '4'
		left join doc_anexos				DTDSE on DTDSE.num_proc = LLP.num_proc_lea and DTDSE.id_dc = '26'
		left join doc_anexos				DTDDE on DTDDE.num_proc = LLP.num_proc_lea and DTDDE.id_dc = '12'
		left join campo_processo			DTCOMP on DTCOMP.NUm_proc = LLP.Num_proc_lea and DTCOMP.id_campo = '41'
		left join campo_processo			DTAVERB on DTAVERB.NUm_proc = LLP.Num_proc_lea and DTAVERB.id_campo = '42'
		left join campo_processo      		CP on LLP.num_proc_lea=cp.num_proc and cp.id_campo=36
		left join verdade					VD on cp.campo_dados = VD.id
		left Join Usuario					BDPCSR on BDPCSR.cd_usuario=job.cd_usuario
	where
		(right(left(HOU.Num_Proc_HEA,9),4)='2009' or right(left(HOU.Num_Proc_HEA,9),4)='2010')
	group by
		BDPCSR.Nome_USuario,
		HOU.Num_Proc_HEA,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		CONS.Apelido ,
		TP.NOME_Tp_Oper	,
		Org.Nome_Local ,
		Dst.Nome_Local ,
		ETD_LEA ,
		ATD_LEA ,
		ETA_LEA ,
		ATA_LEA,
		Nome_Cia_Aer,
		Voo_HEA,
		HOU.MAWB_HEA,
		HAWB_HEA,
		LLP.Canal_LEA,
		LLP.Courier_Number_LEA,
		UC.Nome_Usuario,
--		AC.Dt_Solicitacao,
		PG.Apelido,
		vd.descricao,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		vd.descricao,
		ATD_LEA

















GO

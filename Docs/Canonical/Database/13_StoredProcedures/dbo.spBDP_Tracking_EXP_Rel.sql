SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	Procedure [dbo].[spBDP_Tracking_EXP_Rel] --'IFB'
(
@Grupo as varchar(3)
)
As
	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select Cd_Pes_Grupo from Grupo where Grupo=@Grupo)

	select --top 100
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
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,26)	DSE,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,16)          Chegada_Docs,
		isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,12),
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,26))	DDE,
		LLP.Canal_LEM									Canal,
		dbo.fBusca_Tarefa(hou.num_proc_hem,4)			Desembaraco,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,3)	DSM_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEM,2)	Num_Invoice,
		LLP.Courier_Number_LEM							Courier_Nr,
		dbo.fBusca_HistoricoDescr(hou.num_proc_hem,0,getdate()) Historico,
		UC.Nome_Usuario									Nome_PO,
		Isnull(dbo.fBusca_Tarefa(hou.num_proc_hem,40),dbo.fBusca_Tarefa(hou.num_proc_hem,14)) Prest_Contas,
		dbo.fBusca_TEUS(hou.num_proc_hem)				TEUS,
		AC.Dt_Solicitacao								Sol_Numerario,
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
		DTDDE.dt_envio									Dt_AFComprov,
	    dbo.fBusca_Tarefa(hou.num_proc_hem,15)			DT_AFAverb,
		dbo.fbusca_docs(hou.num_proc_hem,4)				Tp_doc_RE,
		dbo.fbusca_docs(hou.num_proc_hem,26)			Tp_doc_DSE,
		vd.descricao									Urgente,
		dbo.fbusca_tarefa(hou.num_proc_hem,70)			EnvDrafCom,
		llp.Dt_BL_Lem									Dt_Conhecimento
from
		House_Exp_Mar HOU
		Join LLp_Exp_mar				LLP on LLP.num_proc_lem=hou.num_proc_hem
		Join Job_exp_Mar				Job on job.num_proc_hem=hou.num_proc_hem
		Left Join Pessoa				CONS on HOU.Cd_Consig_HEM = CONS.Cd_Pes
		Left Join Tipo_Oper				TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left Join Pedido_Ship			PS on PS.num_proc=hou.num_proc_hem
		left Join Pedido				P on P.cd_pedido=PS.cd_pedido
		left Join Produto_cliente		PC on PC.cd_prod=ps.cd_produto and PC.cd_cliente = @cd_grupo
		left Join Armador				ARM on ARM.cd_armador=llp.cd_armador_lem
		left Join Localidade			Org on hou.cd_org_hem=Org.cd_local
		left Join Localidade			Dst on cd_dst_hem=DSt.cd_local
		Join Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Export_HEM and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente		UC on UC.cd_usuario=P.PO_Responsible and UC.cd_cliente = @cd_grupo
		Join Pessoa						CSN on CSN.cd_pes=HOU.Cd_Export_HEM
		left Join Fatura_CHB			FCHB on HOU.Num_Proc_HEM = FCHB.Processo_PC or HOU.Num_Proc_MEM = FCHB.Processo_PC
		left join Adiantamento_Cliente	AC on AC.Num_Proc = Hou.Num_proc_Hem
--		join Grupo						G on G.grupo= right(left(HOU.Num_Proc_HEM,5),3)
		join pessoa						PG on PG.cd_pes=@Cd_Grupo
		left join doc_anexos		    DTRE on DTRE.num_proc = LLP.num_proc_lem and DTRE.id_dc = '4'
		left join doc_anexos			DTDSE on DTDSE.num_proc = LLP.num_proc_lem and DTDSE.id_dc = '26'
		left join doc_anexos			DTDDE on DTDDE.num_proc = LLP.num_proc_lem and DTDDE.id_dc = '12'
		left join campo_processo		DTCOMP on DTCOMP.NUm_proc = LLP.Num_proc_lem and DTCOMP.id_campo = '41'
		left join campo_processo		DTAVERB on DTAVERB.NUm_proc = LLP.Num_proc_lem and DTAVERB.id_campo = '42'
		left join campo_processo      	CP on LLP.num_proc_lem=cp.num_proc and cp.id_campo=36
		left join verdade				VD on cp.campo_dados = VD.id
		left Join Usuario				BDPCSR on BDPCSR.cd_usuario=job.cd_usuario
where
		(right(left(HOU.Num_Proc_HEM,9),4)='2009' or right(left(HOU.Num_Proc_HEM,9),4)='2010' or right(left(HOU.Num_Proc_HEM,9),4)='2011')
group by
		BDPCSR.Nome_Usuario,
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
		hou.MAWB_HEM,
		hou.HAWB_HEM,
		LLP.Canal_LEM,
		LLP.Courier_Number_LEM,
		UC.Nome_Usuario,
		AC.Dt_Solicitacao,
		PG.Apelido,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		vd.descricao,
		llp.Dt_BL_Lem
UNION all
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
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,26)	DSE,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,16)          Chegada_Docs,
		isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,12),
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,26))	DDE,
		LLP.Canal_LEA									Canal,
		dbo.fBusca_Tarefa(hou.num_proc_HEA,4)			Desembaraco,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,3)	DSM_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEA,2)	Num_Invoice,
		LLP.Courier_Number_LEA							Courier_Nr,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HEA,0,getdate()) Historico,
		UC.Nome_Usuario									Nome_PO,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hea,40), dbo.fBusca_Tarefa(hou.num_proc_hea,14)) Prest_Contas,
		0												TEUS,
		AC.Dt_Solicitacao								Sol_Numerario,
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
		DTDDE.dt_envio									Dt_AFComprov,
	    dbo.fBusca_Tarefa(hou.num_proc_hea,15)			DT_AFAverb,
		dbo.fbusca_docs(hou.num_proc_hea,4)				Tp_doc_RE,
		dbo.fbusca_docs(hou.num_proc_hea,26)			Tp_doc_DSE,
		vd.descricao									Urgente,
		dbo.fbusca_tarefa(hou.num_proc_hea,70)			EnvDrafCom,
		ATD_LEA											Dt_Conhecimento
from
		House_Exp_Aer HOU
		Join LLp_Exp_Aer					LLP on LLP.num_proc_LEA=hou.num_proc_HEA
		Join Job_Exp_aer					job on job.num_proc_hea=hou.num_proc_hea
		Left Join Pessoa					CONS on HOU.Cd_Consig_HEA = CONS.Cd_Pes
		Left Join Tipo_Oper					TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left Join Pedido_Ship				PS on PS.num_proc=hou.num_proc_HEA
		left Join Pedido					P on P.cd_pedido=PS.cd_pedido
		left Join Produto_cliente			PC on PC.cd_prod=ps.cd_produto and PC.cd_cliente = @cd_grupo
		left Join Cia_Aerea					CIA on CIA.cd_cia_Aer=llp.cd_ciaaerea_lea
		left Join Localidade				Org on hou.cd_org_HEA=Org.cd_local
		left Join Localidade				Dst on cd_dst_HEA=DSt.cd_local
		Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Export_HEA and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente			UC on UC.cd_usuario=P.PO_Responsible and UC.cd_cliente = @cd_grupo
		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Export_HEA
		left Join Fatura_CHB				FCHB on HOU.Num_Proc_HEA = FCHB.Processo_PC or HOU.Num_Proc_MEA = FCHB.Processo_PC
		left join Adiantamento_Cliente		AC on AC.Num_Proc = Hou.Num_proc_Hea
--		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HEA,5),3)
		join pessoa							PG on PG.cd_pes=@Cd_Grupo
		left join doc_anexos				DTRE on DTRE.num_proc = LLP.num_proc_lea and DTRE.id_dc = '4'
		left join doc_anexos				DTDSE on DTDSE.num_proc = LLP.num_proc_lea and DTDSE.id_dc = '26'
		left join doc_anexos				DTDDE on DTDDE.num_proc = LLP.num_proc_lea and DTDDE.id_dc = '12'
		left join doc_anexos				DOC on DOC.num_proc = llp.num_proc_lea
		left join campo_processo			DTCOMP on DTCOMP.NUm_proc = LLP.Num_proc_lea and DTCOMP.id_campo = '41'
		left join campo_processo			DTAVERB on DTAVERB.NUm_proc = LLP.Num_proc_lea and DTAVERB.id_campo = '42'
		left join campo_processo      		CP on LLP.num_proc_lea=cp.num_proc and cp.id_campo=36
		left join verdade					VD on cp.campo_dados = VD.id
		left Join Usuario					BDPCSR on BDPCSR.cd_usuario=job.cd_usuario

	where
		(right(left(HOU.Num_Proc_HEA,9),4)='2009' or right(left(HOU.Num_Proc_HEA,9),4)='2010' or right(left(HOU.Num_Proc_HEA,9),4)='2011')
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
		hou.MAWB_HEA,
		hou.HAWB_HEA,
		LLP.Canal_LEA,
		LLP.Courier_Number_LEA,
		UC.Nome_Usuario,
		AC.Dt_Solicitacao,
		PG.Apelido,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		vd.descricao
UNION all

	select
		BDPCSR.Nome_Usuario								BDPCSR,
		'Other'											Modal,
		HOU.Num_Proc_heo								Ref_BDP,
		PG.Apelido										Nome_Grupo,
		CSN.Apelido										Shipper,
		CSN.Num_CPF_CNPJ								CNPJ,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_heo,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_heo,9)	CustomerPO,
		CONS.Apelido									Consignee,
		dbo.fBusca_GMID(HOU.Num_Proc_heo)				Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_heo)			Produto,
		TP.NOME_Tp_Oper									Incoterm,
		dbo.fNCM(HOU.Num_Proc_heo)						NCM,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		CIA.Apelido										Carrier,
		Voo_heo											Navio_Voo,
		HOU.MAWB_heo									Master,
		HOU.HAWB_heo									House,
		ETD_leo											ETD,
		ATD_leo											ATD,
		ETA_leo											ETA,
		ATA_leo											ATA,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_heo,4)	RE,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEo,26)	DSE,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HEo,16)			Chegada_Docs,
		isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_heo,12),
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_heo,26))	DDE,
		LLP.Canal_leo									Canal,
		dbo.fBusca_Tarefa(hou.num_proc_heo,4)			Desembaraco,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEO,3)	DSM_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEO,2)	Num_Invoice,
		LLP.Courier_Number_leo							Courier_Nr,
		dbo.fBusca_HistoricoDescr(hou.num_proc_heo,0,getdate()) Historico,
		UC.Nome_Usuario									Nome_PO,
		Isnull(dbo.fBusca_Tarefa(hou.num_proc_heo,40),dbo.fBusca_Tarefa(hou.num_proc_heo,14))			Prest_Contas,
		0												TEUS,
		AC.Dt_Solicitacao								Sol_Numerario,
		dbo.fBusca_Containers(hou.num_proc_heo)			Containers,
		dbo.Qty_Container(hou.num_proc_heo)				Qtde,
		dbo.FBusca_Docs(hou.num_proc_heo,2)				SN_Invoice,
		dbo.fbusca_docs(hou.num_proc_heo,11)			SN_Packing,
		dbo.fbusca_docs(hou.num_proc_heo,4)				SN_RE_Number,
		dbo.fbusca_docs(hou.num_proc_heo,12)			SN_DDE,
		dbo.fbusca_docs(hou.num_proc_heo,13)			SN_Certificado,
		dbo.fbusca_docs(hou.num_proc_heo,10)			SN_NF,
		dbo.fbusca_docs(hou.num_proc_heo,18)			SN_Riex,
		dbo.fbusca_docs(hou.num_proc_heo,21)			SN_Cert_Seg,
		dbo.fbusca_docs(hou.num_proc_heo,22)			SN_Cert_Furmica,
		dbo.fbusca_docs(hou.num_proc_heo,45)			SN_BL_Original,
		dbo.fbusca_docs(hou.num_proc_heo,15)			SN_Doc_Cambio,
		DTRE.dt_envio									Dt_Re,
		DTDSE.dt_envio									Dt_DSE,
		DTDDE.dt_envio									Dt_DDE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_heo,10)   Num_NF,
		DTDDE.dt_envio									Dt_AFComprov,
	    dbo.fBusca_Tarefa(hou.num_proc_heo,15)			DT_AFAverb,
		dbo.fbusca_docs(hou.num_proc_heo,4)				Tp_doc_RE,
		dbo.fbusca_docs(hou.num_proc_heo,26)			Tp_doc_DSE,
		vd.descricao									Urgente,
		dbo.fbusca_tarefa(hou.num_proc_heo,70)			EnvDrafCom,
		ATD_leo											Dt_Conhecimento
from
		House_Exp_OUT HOU
		Join LLp_Exp_OUT					LLP on LLP.num_proc_leo=hou.num_proc_heo
		Left Join Pessoa					CONS on HOU.Cd_Consig_heo = CONS.Cd_Pes
		Left Join Tipo_Oper					TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left Join Pedido_Ship				PS on PS.num_proc=hou.num_proc_heo
		left Join Pedido					P on P.cd_pedido=PS.cd_pedido
		left Join Produto_cliente			PC on PC.cd_prod=ps.cd_produto and PC.cd_cliente = @cd_grupo
		left Join pessoa					CIA on CIA.cd_pes=llp.cd_carrier
		left Join Localidade				Org on hou.cd_org_heo=Org.cd_local
		left Join Localidade				Dst on cd_dst_heo=DSt.cd_local
		Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Export_heo and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente			UC on UC.cd_usuario=P.PO_Responsible and UC.cd_cliente = @cd_grupo
		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Export_heo
		left Join Fatura_CHB				FCHB on HOU.Num_Proc_HEO = FCHB.Processo_PC
		left join Adiantamento_Cliente		AC on AC.Num_Proc = Hou.Num_proc_Heo
--		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HEO,5),3)
		join pessoa							PG on PG.cd_pes=@Cd_Grupo
		left join doc_anexos				DTRE on DTRE.num_proc = LLP.num_proc_leo and DTRE.id_dc = '4'
		left join doc_anexos				DTDSE on DTDSE.num_proc = LLP.num_proc_leo and DTDSE.id_dc = '26'
		left join doc_anexos				DTDDE on DTDDE.num_proc = LLP.num_proc_leo and DTDDE.id_dc = '12'
		left join campo_processo			DTCOMP on DTCOMP.NUm_proc = LLP.Num_proc_leo and DTCOMP.id_campo = '41'
		left join campo_processo			DTAVERB on DTAVERB.NUm_proc = LLP.Num_proc_leo and DTAVERB.id_campo = '42'
		left join campo_processo      		CP on LLP.num_proc_leo=cp.num_proc and cp.id_campo=36
		left join verdade					VD on cp.campo_dados = VD.id
		left Join Usuario					BDPCSR on BDPCSR.cd_usuario=llp.cd_usuario

	where
		(right(left(HOU.Num_Proc_heo,9),4)='2009' or right(left(HOU.Num_Proc_heo,9),4)='2010' or right(left(HOU.Num_Proc_heo,9),4)='2011')
	group by
		BDPCSR.Nome_Usuario,
		HOU.Num_Proc_heo,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		CONS.Apelido,
		TP.NOME_Tp_Oper,
		Org.Nome_Local,
		Dst.Nome_Local,
		ETD_leo,
		ATD_leo,
		ETA_leo,
		ATA_leo,
		CIA.Apelido,
		Voo_heo,
		MAWB_heo,
		HAWB_heo,
		LLP.Canal_leo,
		LLP.Courier_Number_leo,
		UC.Nome_Usuario,
		AC.Dt_Solicitacao,
		PG.Apelido,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		vd.descricao













GO

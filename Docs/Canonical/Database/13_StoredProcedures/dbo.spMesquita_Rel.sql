SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[spMesquita_Rel]

as

select 
		HOU.Num_Proc_HIM								Ref_BDP,
		CSN.Apelido										Consignee,
		HOU.HAWB_HIM									BL,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,1)	PO,
		Org.Nome_Local									Origem,
		AD.Nome_Armador									Carrier,
		Navio_HIM										Navio,
--		dbo.fBusca_Containers_IM(HOU.Num_Proc_HIM)		Container,
		TERM.Nome_terminal								Terminal,
		DI.Numero_PO_Him								DI,
--		dbo.fBusca_Tarefa(hou.num_proc_him,29)			Desova,
		CMIM.Dt_Devol_IM								Devolucao,
--		dbo.fBusca_Tarefa(hou.num_proc_him,13)			Entrega
		CMIM.Num_Cont_IM								Num_Cont,
		CMIM.cd_tp_Cont									Tipo_Cont,
		HG.cd_tp_ocor									Ocorrencia,
		Transp.Apelido									Transportadora

FROM
	house_imp_mar HOU
		Join Pessoa CSN on CSN.cd_pes=HOU.Cd_Consig_HIM
		left Join Localidade Org on hou.cd_org_HIM=Org.cd_local
		Left Join PO_HIM DI on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
		left Join Job_Imp_mar JOB on JOB.num_proc_HIM=hou.num_proc_HIM
		join Armador AD on AD.cd_Armador = JOB.cd_armador
		Join LLP_Imp_Mar LLP on LLP.num_proc_LIM=hou.num_proc_HIM
		Left Join Terminal TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Join Pessoa_LLP	PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo in ('10', '10CAR', '10DEC', '10EKA', '10IFI', '10MPC', '10NST', '10PAC', '10POW', '10SUR')
		Join container_hou_imp_mar CHOU on CHOU.num_proc_him=HOU.num_proc_him
		join container_mas_imp_mar CMIM on CMIM.Num_Proc_MIM = CHOU.Num_Proc_MIM and CMIM.Item_Cont_IM=CHOU.Item_cont_im
		Left Join Hist_Geral HG on HG.HSGProcesso = LLP.Num_Proc_LIM and HG.Cd_Tp_Ocor=80
		Left Join Pessoa		Transp		on LLP.Cd_Transportadora = Transp.Cd_Pes
where 
	TERM.Nome_terminal like 'EADI %' and 
	DI.Numero_PO_Him is not null and 
--	(dbo.fBusca_Tarefa(hou.num_proc_him,13) is null or 
--	dbo.fBusca_Tarefa(hou.num_proc_him,29) is null or 
	(CMIM.Dt_Devol_IM is null or CMIM.Dt_Devol_IM='')
group by 
	hou.Num_Proc_Him,
	CSN.Apelido,
	HOU.HAWB_HIM,
	Org.Nome_Local,
	AD.Nome_Armador,
	Navio_HIM,
	TERM.Nome_terminal,
	DI.Numero_PO_Him,
	CMIM.Dt_Devol_IM,
	CMIM.Num_Cont_IM,
	CMIM.cd_tp_Cont,
	HG.cd_tp_ocor,
	Transp.Apelido


GO

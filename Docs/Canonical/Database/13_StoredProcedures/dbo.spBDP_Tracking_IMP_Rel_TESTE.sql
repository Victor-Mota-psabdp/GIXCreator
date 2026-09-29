SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* incluido como regra não ter no add fields o campo despacho = 2 - não
incluido pra nao trazer jobs cancelados - 27-1-2012*/
--select * from AKZO_FUN
CREATE      Procedure [dbo].[spBDP_Tracking_IMP_Rel_TESTE] --'FUN'
(
@Grupo as varchar(3)
)
As
	declare @Cd_Grupo as varchar(10)
	set @Cd_Grupo = (select Cd_Pes_Grupo from grupo where Grupo = @Grupo)
	declare @TempExc Table (
			[ExcProcesso] varchar(16)
	)

Begin transaction

	insert into @TempExc
			select distinct ExcProcesso from  Exchange where ExcDataAlt >= getdate()-2
	
	delete Akzo_fun where Ref_BDP in (select ExcProcesso from @TempExc)   -- EX 	WITH(NOLOCK)	on LLP.num_proc_LIM= Ex.ExcProcesso	and ExcDataAlt >= getdate()-2	
	
	insert AKZO_FUN
	select
		Distinct
		BDPCSR.Nome_Usuario								BDP_CSR,
		UC.nome_usuario									Nome_PO,
		'OCEAN'											Modal,
		HOU.Num_Proc_HIM								Ref_BDP,
		CSN.Apelido										Consignee,
		CSN.Num_CPF_CNPJ								CNPJ,
		HOU.MAWB_HIM									Master,
		HOU.HAWB_HIM									House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,9)	CustomerPO,
		dbo.fBusca_GMID(HOU.Num_Proc_HIM)				Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)			Produto,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		Nome_Armador									Carrier,
		Navio_HIM										Navio_Voo,
		isnull(dbo.fBusca_Containers_IM(HOU.Num_Proc_HIM),dbo.fBusca_Volumes(HOU.Num_Proc_HIM)) Containers_VOL,
		TERM.Nome_Terminal,
		LI.Numero_PO_HIM								LI,
		T20.dt_conclusao								Def_LI,
		ETD_LIM											ETD,
		ATD_LIM											ATD,
		ETA_LIM											ETA,
		ATA_LIM											ATA,
		T16.dt_conclusao						        Chegada_Docs,
		T28.dt_conclusao								Entrada_Terminal,
		T15.dt_conclusao								Presenca_Carga,
		DI.Numero_PO_Him								DI, 
		DI.Data_PO_Him									Data_DI,
		T4.dt_conclusao									Dt_Desemb,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,3)	DSM_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,2)	Num_Invoice,
		Canal_Lim										Canal,
		T7.dt_conclusao									Entr_Docs_Transp,
		T13.dt_conclusao								Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico,
		isnull(T14.dt_conclusao,T40.dt_conclusao)		Prest_Contas,
		T29.dt_conclusao								Desova,
		T27.dt_conclusao								Digitacao,
		dbo.fBusca_Containers(hou.num_proc_him)			Containers,
		dbo.fBusca_TEUS(hou.num_proc_him)				TEUS,
		T67.dt_conclusao								NFE,
		HOU.Obs_HIM										Notes,
		PG.Apelido										Nome_Grupo,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_Him, 5)	N_LI,
		isnull(T59.dt_conclusao,dbo.FBusca_Adto(hou.num_proc_him)) Sol_Numerario,
		SHP.Apelido										Shipper,
		(case when HOU.Num_Proc_Mim = 'JOB' then null else HOU.Num_Proc_Mim end)	Ref_Consolidada,
		TP.NOME_Tp_Oper									Incoterm,
		vd.descricao									Urgente,
		dbo.FBusca_Docs(hou.num_proc_him,44)			SN_BL_Original,
		dbo.fbusca_docs(hou.num_proc_him,2)				SN_Invoice,
		dbo.fbusca_docs(hou.num_proc_him,11)			SN_Packing,
		dbo.fbusca_docs(hou.num_proc_him,20)			SN_Doc_Embarque,
		dbo.fbusca_docs(hou.num_proc_him,47)			SN_Shipping,
		dbo.fbusca_docs(hou.num_proc_him,5)				SN_DI_Number,
		dbo.fbusca_docs(hou.num_proc_him,41)			SN_AFRMM,
		dbo.fbusca_docs(hou.num_proc_him,6)				SN_CI_Number,
		dbo.fbusca_docs(hou.num_proc_him,60)			SN_Prestacao,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_him,13)		Prev_Entrega,
		dbo.fbusca_campocliente(hou.num_proc_him,43)	EnvDrafCom,
		SLI.Dt_Vencimento								LI_dtVcto
	from
		llp_imp_mar LLP	WITH(NOLOCK)
		JOIN @TempExc				EX 		on LLP.num_proc_LIM= Ex.ExcProcesso		
		Inner Join House_Imp_Mar	HOU WITH(NOLOCK)	on LLP.num_proc_LIM=hou.num_proc_HIM
		Inner Join Job_Imp_Mar		JOB WITH(NOLOCK)	on JOB.num_proc_him=hou.num_proc_him
		left Join Armador			ARM WITH(NOLOCK)	on ARM.cd_armador=job.cd_armador
		left Join Pedido_Ship		PS WITH(NOLOCK)		on PS.num_proc=hou.num_proc_HIM
		left Join Pedido			PD WITH(NOLOCK)		on PD.cd_pedido=PS.cd_pedido
		left Join Produto_cliente	PC WITH(NOLOCK)		on PC.cd_prod=ps.cd_produto
		left Join Localidade		Org WITH(NOLOCK)	on hou.cd_org_HIM=Org.cd_local and Org.Desat_loc = 'N'
		left Join Localidade		Dst WITH(NOLOCK)	on cd_dst_HIM=DSt.cd_local and Dst.Desat_loc = 'N'
		Left Join Terminal			TERM WITH(NOLOCK)	on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIM			DI WITH(NOLOCK)		on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
		Join Pessoa_LLP				PLL WITH(NOLOCK)	on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente	UC WITH(NOLOCK)		on UC.cd_usuario=PD.PO_Responsible and PD.Cd_Grupo=UC.cd_Cliente
		Join Pessoa					CSN WITH(NOLOCK)	on CSN.cd_pes=HOU.Cd_Consig_HIM and CSN.desat_pes = 'N'
		join pessoa					PG WITH(NOLOCK)		on PG.cd_pes=@Cd_Grupo and PG.desat_pes = 'N'
		left join Pessoa			SHP WITH(NOLOCK)	on SHP.cd_pes = HOU.cd_export_him and SHP.desat_pes = 'N'
		Left Join PO_HIM			SO WITH(NOLOCK)		on SO.Num_Proc_Him=HOU.num_proc_him and SO.ID_DC='3' and (SO.Numero_PO_HIM not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or SO.Numero_PO_HIM is null)
		Left Join PO_HIM			CU WITH(NOLOCK)		on CU.Num_Proc_Him=HOU.num_proc_him and CU.ID_DC='9' and (CU.Numero_PO_HIM not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_HIM is null)
		Left Join PO_HIM			LI WITH(NOLOCK)		on LI.Num_Proc_Him=HOU.num_proc_him and LI.ID_DC='23'
		LEft join Solicitacao_LI	SLI WITH(NOLOCK)	on SLI.Num_Proc = LI.Num_Proc_Him and SLI.Num_LI = LI.Numero_PO_HIM
		left join Hist_Geral		HG WITH(NOLOCK)		on HG.HSGProcesso=HOU.Num_Proc_Him and HG.cd_tp_ocor = '28'
		left Join Tipo_Oper			TP WITH(NOLOCK)		on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join campo_processo    CP WITH(NOLOCK)		on LLP.num_proc_lim=cp.num_proc and cp.id_campo=36
		left join verdade			VD WITH(NOLOCK)		on cp.campo_dados = VD.id
		left Join Usuario			BDPCSR WITH(NOLOCK)	on BDPCSR.cd_usuario=job.cd_usuario
		left join tarefas_processos	T16	WITH(NOLOCK)	on T16.num_proc=LLP.num_proc_LIM and T16.ID_Task=16 --and dt_conclusao is not null			
		left join tarefas_processos	T28	WITH(NOLOCK)	on T28.num_proc=LLP.num_proc_LIM and T28.ID_Task=28
		left join tarefas_processos	T20	WITH(NOLOCK)	on T20.num_proc=LLP.num_proc_LIM and T20.ID_Task=20
		left join tarefas_processos	T15	WITH(NOLOCK)	on T15.num_proc=LLP.num_proc_LIM and T15.ID_Task=15
		left join tarefas_processos	T4	WITH(NOLOCK)	on T4.num_proc=LLP.num_proc_LIM and T4.ID_Task=4
		left join tarefas_processos	T7	WITH(NOLOCK)	on T7.num_proc=LLP.num_proc_LIM and T7.ID_Task=7
		left join tarefas_processos	T13	WITH(NOLOCK)	on T13.num_proc=LLP.num_proc_LIM and T13.ID_Task=13
		left join tarefas_processos	T14	WITH(NOLOCK)	on T14.num_proc=LLP.num_proc_LIM and T14.ID_Task=14
		left join tarefas_processos	T40	WITH(NOLOCK)	on T40.num_proc=LLP.num_proc_LIM and T40.ID_Task=40
		left join tarefas_processos	T29	WITH(NOLOCK)	on T29.num_proc=LLP.num_proc_LIM and T29.ID_Task=29
		left join tarefas_processos	T27	WITH(NOLOCK)	on T27.num_proc=LLP.num_proc_LIM and T27.ID_Task=27
		left join tarefas_processos	T67	WITH(NOLOCK)	on T67.num_proc=LLP.num_proc_LIM and T67.ID_Task=67
		left join tarefas_processos	T59	WITH(NOLOCK)	on T59.num_proc=LLP.num_proc_LIM and T59.ID_Task=59
	where
	--	(right(left(HOU.Num_Proc_HIM,9),4)='2010' or right(left(HOU.Num_Proc_HIM,9),4)='2011')
		ETD_lim >=GETDATE()-365
		and HG.cd_tp_ocor is null
		and isnull([dbo].[fBusca_CampoCliente](HOU.Num_Proc_HIM,32),0) <> '2'
		and isnull(llp.id_status,0) <> '9'

	group by
		BDPCSR.Nome_Usuario,
		UC.nome_usuario,
		HOU.Num_Proc_HIM,
		HOU.HAWB_HIM,HOU.MAWB_HIM,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Dst.Nome_Local,
		Nome_Armador,
		Navio_HIM,
		TERM.Nome_Terminal,
		ETD_LIM,
		ATD_LIM,
		ETA_LIM,
		ATA_LIM,
		T16.dt_conclusao,
		T28.dt_conclusao,
		T20.dt_conclusao,
		T15.dt_conclusao,
		T4.dt_conclusao,
		T7.dt_conclusao,
		T13.dt_conclusao,
		T14.dt_conclusao,
		T40.dt_conclusao,
		T29.dt_conclusao,
		T27.dt_conclusao,
		T67.dt_conclusao,
		T59.dt_conclusao,
		DI.Numero_PO_Him, 
		DI.Data_PO_Him,
		Canal_Lim,
		HOU.Obs_HIM,
		PG.Apelido,
		SHP.Apelido,
		HOU.Num_Proc_Mim,
		TP.NOME_Tp_Oper,
		vd.descricao,
		SLI.Dt_Vencimento,
		LI.Numero_PO_HIM

UNION all
	select
		Distinct
		BDPCSR.Nome_Usuario								BDP_CSR,
		UC.nome_usuario									Nome_PO,
		'AIR'											Modal,
		HOU.Num_Proc_HIA								Ref_BDP,
		CSN.Apelido										Consignee,
		CSN.Num_CPF_CNPJ								CNPJ,
		HOU.MAWB_HIA									Master,
		HOU.HAWB_HIA									House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,9)	CustomerPO,
		dbo.fBusca_GMID(HOU.Num_Proc_HIA)				Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)			Produto,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		Nome_Cia_Aer									Carrier,
		Voo_HIA											Navio_Voo,
		isnull(dbo.fBusca_Containers_IM(HOU.Num_Proc_HIA),dbo.fBusca_Volumes(HOU.Num_Proc_HIA))			Containers_VOL,
		TERM.Nome_Terminal,
		LI.Numero_PO_HIA								LI,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,20)			Def_LI,
		ETD_LIA											ETD,
		ATD_LIA											ATD,
		ETA_LIA											ETA,
		ATA_LIA											ATA,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,16)          Chegada_Docs,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,28)			Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,15)			Presenca_Carga,
		DI.Numero_PO_HIA								DI, 
		DI.Data_PO_HIA									Data_DI,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,4)			Dt_Desemb,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,3)	DSM_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,2)	Num_Invoice,
		Canal_LIA										Canal,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,7)			Entr_Docs_Transp,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,13)			Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HIA,0,getdate()) Historico,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hia,14),dbo.fBusca_Tarefa(hou.num_proc_hia,40))	Prest_Contas,
		dbo.fBusca_Tarefa(hou.num_proc_hia,29)			Desova,
		dbo.fBusca_Tarefa(hou.num_proc_hia,27)			Digitacao,
		dbo.fBusca_Containers(hou.num_proc_hia)			Containers,
		dbo.fBusca_TEUS(hou.num_proc_hia)				TEUS,
		dbo.fBusca_Tarefa(hou.num_proc_hia,67)			NFE,
		HOU.Obs_HIA Notes,
		PG.Apelido										Nome_Grupo,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_Hia, 5)	N_LI,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hia,59),
		dbo.FBusca_Adto(hou.num_proc_hia))				Sol_Numerario,
		SHP.Apelido										Shipper,
		(case when HOU.Num_Proc_Mia = 'JOB' then null else HOU.Num_Proc_Mia end)	Ref_Consolidada,
		TP.NOME_Tp_Oper									Incoterm,
		vd.descricao									Urgente,
		dbo.FBusca_Docs(hou.num_proc_hia,44)			SN_BL_Original,
		dbo.fbusca_docs(hou.num_proc_hia,2)				SN_Invoice,
		dbo.fbusca_docs(hou.num_proc_hia,11)			SN_Packing,
		dbo.fbusca_docs(hou.num_proc_hia,20)			SN_Doc_Embarque,
		dbo.fbusca_docs(hou.num_proc_hia,47)			SN_Shipping,
		dbo.fbusca_docs(hou.num_proc_hia,5)				SN_DI_Number,
		dbo.fbusca_docs(hou.num_proc_hia,41)			SN_AFRMM,
		dbo.fbusca_docs(hou.num_proc_hia,6)				SN_CI_Number,
		dbo.fbusca_docs(hou.num_proc_hia,60)			SN_Prestacao,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,13)		Prev_Entrega,
		dbo.fbusca_campocliente(hou.num_proc_hia,43)	EnvDrafCom,
		SLI.Dt_Vencimento								LI_dtVcto
	from
		llp_imp_Aer LLP			WITH(NOLOCK)
		JOIN @TempExc							EX 	on LLP.num_proc_LIA= Ex.ExcProcesso	--and ExcDataAlt >= getdate()-2
		Join House_Imp_Aer						HOU WITH(NOLOCK)	on LLP.num_proc_LIA=hou.num_proc_HIA
		left Join Job_Imp_Aer					JOB WITH(NOLOCK)	on JOB.num_proc_HIA=hou.num_proc_HIA
		left Join Cia_Aerea						CIA WITH(NOLOCK)	on CIA.Cd_Cia_Aer=JOB.Cd_Cia_Aer
		left Join Pedido_Ship					PS WITH(NOLOCK)		on PS.num_proc=hou.num_proc_HIA
		left Join Pedido						PD WITH(NOLOCK)		on PD.cd_pedido=PS.cd_pedido
		left Join Produto_cliente				PC WITH(NOLOCK)		on PC.cd_prod=ps.cd_produto
		left Join Localidade					Org WITH(NOLOCK)	on hou.cd_org_HIA=Org.cd_local and Org.desat_loc = 'N'
		left Join Localidade					Dst WITH(NOLOCK)	on cd_dst_HIA=DSt.cd_local and Dst.desat_loc = 'N'
		Left Join Terminal						TERM WITH(NOLOCK)	on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIA						DI WITH(NOLOCK)		on DI.Num_Proc_HIA=hou.num_proc_HIA and DI.id_dc=5
		Left Join PO_HIA						LI WITH(NOLOCK)		on LI.Num_Proc_HiA=HOU.num_proc_hiA and LI.ID_DC='23'
		LEft join Solicitacao_LI				SLI WITH(NOLOCK)	on SLI.Num_Proc = LI.Num_Proc_HiA and SLI.Num_LI = LI.Numero_PO_HIA
		Join Pessoa_LLP							PLL WITH(NOLOCK)	on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente				UC WITH(NOLOCK)		on UC.cd_usuario=PD.PO_Responsible and PD.Cd_Grupo=UC.cd_Cliente
		Join Pessoa								CSN WITH(NOLOCK)	on CSN.cd_pes=HOU.Cd_Consig_HIA and CSN.desat_pes = 'N'
		join pessoa								PG WITH(NOLOCK)		on PG.cd_pes=@Cd_Grupo and PG.desat_pes = 'N'
		left join Pessoa						SHP WITH(NOLOCK)	on SHP.cd_pes = HOU.cd_export_hia and SHP.desat_pes = 'N'
		Left Join PO_HiA						SO WITH(NOLOCK)		on SO.Num_Proc_HiA=HOU.num_proc_hia and SO.ID_DC='3' and (SO.Numero_PO_HiA not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or SO.Numero_PO_HiA is null)
		Left Join PO_HiA						CU WITH(NOLOCK)		on CU.Num_Proc_HiA=HOU.num_proc_hia and CU.ID_DC='9' and (CU.Numero_PO_HiA not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_HiA is null)
		left join Hist_Geral					HG WITH(NOLOCK)		on HG.HSGProcesso=HOU.Num_Proc_HiA and HG.cd_tp_ocor = '28'
		left Join Tipo_Oper						TP WITH(NOLOCK)		on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join campo_processo      			CP WITH(NOLOCK)		on LLP.num_proc_lia=cp.num_proc and cp.id_campo=36
		left join verdade						VD WITH(NOLOCK)		on cp.campo_dados = VD.id
		left Join Usuario						BDPCSR WITH(NOLOCK)	on BDPCSR.cd_usuario=job.cd_usuario					
	where
	--	(right(left(HOU.Num_Proc_HIA,9),4)='2010' or right(left(HOU.Num_Proc_HIA,9),4)='2011')
		ETD_liA >=GETDATE()-365
		and HG.cd_tp_ocor is null
		and isnull([dbo].[fBusca_CampoCliente](HOU.Num_Proc_HIA,32),0) <> '2'
		and isnull(llp.id_status,0) <> '9'

group by
		BDPCSR.Nome_usuario,
		UC.nome_usuario,
		HOU.Num_Proc_HIA,
		HOU.HAWB_HIA,HOU.MAWB_HIA,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Dst.Nome_Local,
		Nome_Cia_Aer,
		Voo_HIA,
		TERM.Nome_Terminal,
		ETD_LIA,
		ATD_LIA,
		ETA_LIA,
		ATA_LIA,
		DI.Numero_PO_HIA, 
		DI.Data_PO_HIA,
		Canal_LIA,
		HOU.Obs_HIA,
		PG.Apelido,
		SHP.Apelido,
		HOU.Num_Proc_Mia,
		TP.NOME_Tp_Oper,
		vd.descricao,
		SLI.Dt_Vencimento,
		LI.Numero_PO_HIA

UNION all

	select
		Distinct
		BDPCSR.Nome_usuario								BDP_CSR,
		UC.nome_usuario									Nome_PO,
		'Other'											Modal,
		HOU.Num_Proc_HIo								Ref_BDP,
		CSN.Apelido										Consignee,
		CSN.Num_CPF_CNPJ								CNPJ,
		HOU.MAWB_HIo									Master,
		HOU.HAWB_HIo									House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,9)	CustomerPO,
		dbo.fBusca_GMID(HOU.Num_Proc_HIo)				Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIo)			Produto,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		CIA.Apelido										Carrier,
		Voo_HIo											Navio_Voo,
		isnull(dbo.fBusca_Containers_IM(HOU.Num_Proc_HIo),dbo.fBusca_Volumes(HOU.Num_Proc_HIo))			Containers_VOL,
		TERM.Nome_Terminal,
		LI.Numero_PO_HIO								LI,
		dbo.fBusca_Tarefa(hou.num_proc_HIo,20)			Def_LI,
		ETD_LIo											ETD,
		ATD_LIo											ATD,
		ETA_LIo											ETA,
		ATA_LIo											ATA,
		Null								          Chegada_Docs,
		dbo.fBusca_Tarefa(hou.num_proc_HIO,28)			Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_HIO,15)			Presenca_Carga,
		DI.Numero_PO_HIo								DI, 
		DI.Data_PO_HIo									Data_DI,
		dbo.fBusca_Tarefa(hou.num_proc_HIO,4)			Dt_Desemb,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,3)	DSM_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,2)	Num_Invoice,
		Canal_LIo										Canal,
		dbo.fBusca_Tarefa(hou.num_proc_HIo,7)			Entr_Docs_Transp,
		dbo.fBusca_Tarefa(hou.num_proc_HIo,13)			Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HIo,0,getdate()) Historico,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hio,14),dbo.fBusca_Tarefa(hou.num_proc_hio,40))	Prest_Contas,
		dbo.fBusca_Tarefa(hou.num_proc_hio,29)			Desova,
		dbo.fBusca_Tarefa(hou.num_proc_hio,27)			Digitacao,
		dbo.fBusca_Containers(hou.num_proc_hio)			Containers,
		dbo.fBusca_TEUS(hou.num_proc_hio)				TEUS,
		dbo.fBusca_Tarefa(hou.num_proc_hio,67)			NFE,
		HOU.Obs_HIo Notes,
		PG.Apelido										Nome_Grupo,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 5)	N_LI,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hio,59),
		dbo.FBusca_Adto(hou.num_proc_hio))				Sol_Numerario,
		SHP.Apelido										Shipper,
		''	Ref_Consolidada,
		TP.NOME_Tp_Oper									Incoterm,
		vd.descricao									Urgente,
		dbo.FBusca_Docs(hou.num_proc_hio,44)			SN_BL_Original,
		dbo.fbusca_docs(hou.num_proc_hio,2)				SN_Invoice,
		dbo.fbusca_docs(hou.num_proc_hio,11)			SN_Packing,
		dbo.fbusca_docs(hou.num_proc_hio,20)			SN_Doc_Embarque,
		dbo.fbusca_docs(hou.num_proc_hio,47)			SN_Shipping,
		dbo.fbusca_docs(hou.num_proc_hio,5)				SN_DI_Number,
		dbo.fbusca_docs(hou.num_proc_hio,41)			SN_AFRMM,
		dbo.fbusca_docs(hou.num_proc_hio,6)				SN_CI_Number,
		dbo.fbusca_docs(hou.num_proc_hio,60)			SN_Prestacao,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,13)		Prev_Entrega,
		dbo.fbusca_campocliente(hou.num_proc_hio,43)	EnvDrafCom,
		SLI.Dt_Vencimento								LI_dtVcto
	from
		llp_imp_out LLP				WITH(NOLOCK)
		JOIN @TempExc						EX 		on LLP.num_proc_LIO= Ex.ExcProcesso	--and ExcDataAlt >= getdate()-2
		Join House_Imp_out					HOU WITH(NOLOCK) on LLP.num_proc_LIo=hou.num_proc_HIo
		left Join Pedido_Ship				PS  WITH(NOLOCK) on PS.num_proc=hou.num_proc_HIo
		left Join Pedido					PD	WITH(NOLOCK) on PD.cd_pedido=PS.cd_pedido
		left Join Produto_cliente			PC	WITH(NOLOCK)on PC.cd_prod=ps.cd_produto
		left Join Localidade				Org WITH(NOLOCK)on hou.cd_org_HIo=Org.cd_local
		left Join Localidade				Dst WITH(NOLOCK) on cd_dst_HIo=DSt.cd_local
		Left Join Terminal					TERM WITH(NOLOCK) on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIo					DI WITH(NOLOCK) on DI.Num_Proc_HIo=hou.num_proc_HIo and DI.id_dc=5
		Join Pessoa_LLP						PLL WITH(NOLOCK) on PLL.Cd_Pes=HOU.Cd_Consig_HIo and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente			UC WITH(NOLOCK) on UC.cd_usuario=PD.PO_Responsible and PD.Cd_Grupo=UC.cd_Cliente
		Join Pessoa							CSN WITH(NOLOCK) on CSN.cd_pes=HOU.Cd_Consig_HIo and CSN.desat_pes = 'N'
		join pessoa							PG WITH(NOLOCK) on PG.cd_pes=@Cd_Grupo and PG.desat_pes = 'N'
		left Join pessoa					CIA WITH(NOLOCK) on CIA.cd_pes=llp.cd_carrier and CIA.desat_pes = 'N'
		left join Pessoa					SHP WITH(NOLOCK) on SHP.cd_pes = HOU.cd_export_hio and SHP.desat_pes = 'N'
		Left Join PO_HIO					SO WITH(NOLOCK) on SO.Num_Proc_Hio=HOU.num_proc_hio and SO.ID_DC='3' and (SO.Numero_PO_Hio not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or SO.Numero_PO_Hio is null)
		Left Join PO_HIO					CU WITH(NOLOCK) on CU.Num_Proc_Hio=HOU.num_proc_hio and CU.ID_DC='9' and (CU.Numero_PO_Hio not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_Hio is null)
		Left Join PO_HIO					LI WITH(NOLOCK) on LI.Num_Proc_Hio=HOU.num_proc_hio and LI.ID_DC='23'
		LEft join Solicitacao_LI			SLI WITH(NOLOCK) on SLI.Num_Proc = LI.Num_Proc_HiO and SLI.Num_LI = LI.Numero_PO_HIO
		left join Hist_Geral				HG WITH(NOLOCK) on HG.HSGProcesso=HOU.Num_Proc_Hio and HG.cd_tp_ocor = '28'
		left Join Tipo_Oper					TP WITH(NOLOCK) on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join campo_processo      		CP WITH(NOLOCK) on LLP.num_proc_lio=cp.num_proc and cp.id_campo=36
		left join verdade					VD WITH(NOLOCK) on cp.campo_dados = VD.id
		left Join Usuario					BDPCSR WITH(NOLOCK) on BDPCSR.cd_usuario=llp.cd_usuario					
	where
		--(right(left(HOU.Num_Proc_HIo,9),4)='2009' or right(left(HOU.Num_Proc_HIo,9),4)='2010' or right(left(HOU.Num_Proc_HIo,9),4)='2011')
		ETD_liO >=GETDATE()-365
		and HG.cd_tp_ocor is null
		and isnull([dbo].[fBusca_CampoCliente](HOU.Num_Proc_HIO,32),0) <> '2'
		and isnull(llp.id_status,0) <> '9'

	group by
		BDPCSR.Nome_Usuario,
		UC.nome_usuario,
		HOU.Num_Proc_HIo,
		HOU.HAWB_HIo,HOU.MAWB_HIo,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Dst.Nome_Local,
		CIA.Apelido,
		Voo_HIo,
		TERM.Nome_Terminal,
		ETD_LIo,
		ATD_LIo,
		ETA_LIo,
		ATA_LIo,
		DI.Numero_PO_HIo, 
		DI.Data_PO_HIo,
		Canal_LIo,
		HOU.Obs_HIo,
		PG.Apelido,
		SHP.Apelido,
		TP.NOME_Tp_Oper,
		vd.descricao,
		SLI.Dt_Vencimento,
		LI.Numero_PO_HIO

Commit Transaction

Select * from AKZO_FUN
/*
	order by 
		4
*/












GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spATL_Tracking_IMP_Rel 'Grupo Owens Corning','2012-02-01','2012-05-16','0',''
--incluido despacho - 16/05 - Cadu

CREATE Procedure [dbo].[spATL_Tracking_IMP_Rel] 
(
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime,
	@Tipo varchar(10),		--	0=OPEN / 1=CLOSE
	@Despacho varchar(3)  --SIM, NAO,'' Vazio
)
As

	set @Tipo = left(@Tipo,1)
	if left(@Despacho,1) = 'A'
		set @Despacho = ''
	else		
		set @Despacho = left(@Despacho,1)
	

	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	select 
		'OCEAN'											[Modal],
		BDPCSR.Nome_usuario								[BDP CSR Name],
		HOU.Num_Proc_HIM								[Ref. BDP],
		(case when HOU.Num_Proc_MIM = 'JOB' then NULL else HOU.Num_Proc_MIM end) [Ref. Consolidada],
		PG.Apelido										[Group],
		CNS.nome_raz_soc								[Consignee],
		CNS.num_cpf_cnpj								[Consignee CNPJ],
		HOU.MAWB_HIM									[Master],
		HOU.HAWB_HIM									[House],
		PO.numero_po_him								[P.O.],
		CU.numero_po_him								[Customer PO],
		dbo.fBusca_GMID(HOU.Num_Proc_HIM)				[Product Code],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)			[Product],
		ORG.Nome_Local									[Origin],
		DST.Nome_Local									[Destination],
		ARM.Nome_Armador								[Carrier],
		HOU.Navio_Him									[Vessel | Flight #],
		dbo.fBusca_Containers(hou.num_proc_him)			[Containers],
		TRM.Nome_Terminal								[Terminal],
		UC.Nome_Usuario									[Responsible PO],
		(case when NLI.campo_dados = '1' then 'YES' Else 'NO'end) [Necessidade LI],
		LI.numero_po_him								[L.I.],
		T20.dt_conclusao								[Data Def. L.I.],
		T20.dt_conclusao + 120							[Data Vcto. L.I.],
		LLP.ETD_LIM										[ETD Data],
		LLP.ATD_LIM										[ATD Data],
		LLP.ETA_LIM										[ETA Data],
		LLP.ATA_LIM										[ATA Data],
		T16.dt_conclusao								[Data Cheg. DOCs.],
		T59.dt_conclusao								[Data Sol. Numerário],
		T29.dt_conclusao								[Data Desova],
		T27.dt_conclusao								[Data Digitação],
		T28.dt_conclusao								[Data Entrada Terminal],
		T15.dt_conclusao								[Data Presença Carga],
		DI.numero_po_him								[DI],
		DI.data_po_him									[Data DI],
		T4.dt_conclusao									[Data Desembaraço],
		LLP.Canal_LIM									[Channel],
		T67.dt_conclusao								[Data Envio Draft NF-E],
		T7.dt_conclusao									[Data Entr.Docs.Transp.],
		T13.dt_previsao									[Data Prev. Entrega],
		T13.dt_conclusao								[Data Entrega Planta],
		dbo.fBusca_HistoricoDescr(HOU.num_proc_him,0,getdate()) [Historico],
		HOU.obs_him										[Notes],
		(case when URG.campo_dados = '1' then 'YES' Else 'NO'end) [Urgente]
	from
		House_Imp_Mar HOU with(nolock)
		Join LLp_Imp_mar LLP with(nolock) on LLP.num_proc_lim = HOU.num_proc_him
		Join Job_imp_Mar JOB with(nolock) on JOB.num_proc_him = HOU.num_proc_him
		join pessoa	PG  with(nolock) on PG.cd_pes=@Cd_Grupo
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Join Pessoa CNS with(nolock) on CNS.Cd_Pes = HOU.Cd_Consig_HIM
		left Join Pedido_Ship PS  with(nolock) on PS.num_proc=HOU.num_proc_him
		left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		left Join Usuario BDPCSR  with(nolock) on BDPCSR.cd_usuario = JOB.cd_usuario
		left Join Localidade ORG with(nolock) on ORG.cd_local = HOU.cd_org_him
		left Join Localidade DST  with(nolock) on DST.cd_local = HOU.cd_dst_him
		left Join Armador ARM with(nolock) on ARM.cd_armador = JOB.cd_armador
		Left Join Terminal TRM with(nolock) on LLP.Cd_Terminal = TRM.Cd_Terminal
		Left Join Usuario_Cliente UC with(nolock) on UC.cd_usuario=P.PO_Responsible and UC.cd_cliente = @cd_grupo
		left join campo_processo NLI with(nolock) on HOU.num_proc_him=NLI.num_proc and NLI.id_campo=5
		left join campo_processo URG with(nolock) on LLP.num_proc_lim=URG.num_proc and URG.id_campo=36
		left join po_him PO with(nolock) on PO.num_proc_him = HOU.num_proc_him and PO.id_dc=1
		left join po_him CU with(nolock) on CU.num_proc_him = HOU.num_proc_him and CU.id_dc=9
		left join po_him LI with(nolock) on LI.num_proc_him = HOU.num_proc_him and LI.id_dc=23
		left join po_him DI with(nolock) on DI.num_proc_him = HOU.num_proc_him and DI.id_dc=5
		left join tarefas_processos T20 with(nolock) on T20.num_proc=HOU.num_proc_him and T20.id_task = 20
		left join tarefas_processos T16 with(nolock) on T16.num_proc=HOU.num_proc_him and T16.id_task = 16
		left join tarefas_processos T59 with(nolock) on T59.num_proc=HOU.num_proc_him and T59.id_task = 59
		left join tarefas_processos T29 with(nolock) on T29.num_proc=HOU.num_proc_him and T29.id_task = 29
		left join tarefas_processos T27 with(nolock) on T27.num_proc=HOU.num_proc_him and T27.id_task = 27
		left join tarefas_processos T28 with(nolock) on T28.num_proc=HOU.num_proc_him and T28.id_task = 28
		left join tarefas_processos T15 with(nolock) on T15.num_proc=HOU.num_proc_him and T15.id_task = 15
		left join tarefas_processos T4 with(nolock) on T4.num_proc=HOU.num_proc_him and T4.id_task = 4
		left join tarefas_processos T67 with(nolock) on T67.num_proc=HOU.num_proc_him and T67.id_task = 67
		left join tarefas_processos T7 with(nolock) on T7.num_proc=HOU.num_proc_him and T7.id_task = 7
		left join tarefas_processos T13 with(nolock) on T13.num_proc=HOU.num_proc_him and T13.id_task = 13
		left join tarefas_processos T14 with(nolock) on T14.num_proc=HOU.num_proc_him and T14.id_task = 14
		left join tarefas_processos T40 with(nolock) on T40.num_proc=HOU.num_proc_him and T40.id_task = 40	
		Left Join Campo_Processo CPD with(nolock) on num_proc_lim=CPD.num_proc and CPD.id_Campo=32 	
	where
		(convert(datetime,HOU.Dt_Emis_HIM,103) between @DtInicial and @DtFinal)
		AND (( @Tipo = '0' and T40.dt_conclusao is NULL  and T14.dt_conclusao is null )
		OR ( @Tipo = '1' and (T40.dt_conclusao is NOT NULL OR T14.dt_conclusao is NOT null )))

		and isnull(llp.id_status,0) <> '9'

		and ((@Despacho = 'S' and (CPD.Campo_Dados = '1' or CPD.Campo_Dados is null)) 
		or (@Despacho = 'N' and CPD.Campo_Dados = '2')
		or (@Despacho = '' ))	
	group by
		BDPCSR.Nome_usuario,
		HOU.Num_Proc_HIM,
		HOU.Num_Proc_MIM,
		PG.Apelido,
		CNS.nome_raz_soc,
		CNS.num_cpf_cnpj,
		HOU.MAWB_HIM,
		HOU.HAWB_HIM,
		PO.numero_po_him,
		CU.numero_po_him,
		ORG.Nome_Local,
		DST.Nome_Local,
		ARM.Nome_Armador,
		HOU.Navio_Him,
		TRM.Nome_Terminal,
		UC.Nome_Usuario,
		NLI.campo_dados,
		LI.numero_po_him,
		T20.dt_conclusao,
		LLP.ETD_LIM,
		LLP.ATD_LIM,
		LLP.ETA_LIM,
		LLP.ATA_LIM,
		T16.dt_conclusao,
		T59.dt_conclusao,
		T29.dt_conclusao,
		T27.dt_conclusao,
		T28.dt_conclusao,
		T15.dt_conclusao,
		DI.numero_po_him,
		DI.data_po_him,
		T4.dt_conclusao,
		LLP.Canal_LIM,
		T67.dt_conclusao,
		T7.dt_conclusao,
		T13.dt_previsao,
		T13.dt_conclusao,
		HOU.obs_him,
		URG.campo_dados

UNION ALL

	select 
        'AIR'											[Modal],
		BDPCSR.Nome_usuario								[BDP CSR Name],
		HOU.Num_Proc_HIA								[Ref. BDP],
		(case when HOU.Num_Proc_MIA = 'JOB' then NULL else HOU.Num_Proc_MIA end) [Ref. Consolidada],
		PG.Apelido										[Group],
		CNS.nome_raz_soc								[Consignee],
		CNS.num_cpf_cnpj								[Consignee CNPJ],
		HOU.MAWB_HIA									[Master],
		HOU.HAWB_HIA									[House],
		PO.numero_po_hia								[P.O.],
		CU.numero_po_hia								[Customer PO],
		dbo.fBusca_GMID(HOU.Num_Proc_HIA)				[Product Code],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)			[Product],
		ORG.Nome_Local									[Origin],
		DST.Nome_Local									[Destination],
		CIA.Nome_cia_aer								[Carrier],
		HOU.voo_Hia										[Vessel | Flight #],
		dbo.fBusca_Containers(hou.num_proc_hia)			[Containers],
		TRM.Nome_Terminal								[Terminal],
		UC.Nome_Usuario									[Responsible PO],
		(case when NLI.campo_dados = '1' then 'YES' Else 'NO'end) [Necessidade LI],
		LI.numero_po_hia								[L.I.],
		T20.dt_conclusao								[Data Def. L.I.],
		T20.dt_conclusao + 120							[Data Vcto. L.I.],
		LLP.ETD_LIA										[ETD Data],
		LLP.ATD_LIA										[ATD Data],
		LLP.ETA_LIA										[ETA Data],
		LLP.ATA_LIA										[ATA Data],
		T16.dt_conclusao								[Data Cheg. DOCs.],
		T59.dt_conclusao								[Data Sol. Numerário],
		T29.dt_conclusao								[Data Desova],
		T27.dt_conclusao								[Data Digitação],
		T28.dt_conclusao								[Data Entrada Terminal],
		T15.dt_conclusao								[Data Presença Carga],
		DI.numero_po_hia								[DI],
		DI.data_po_hia									[Data DI],
		T4.dt_conclusao									[Data Desembaraço],
		LLP.Canal_LIA									[Channel],
		T67.dt_conclusao								[Data Envio Draft NF-E],
		T7.dt_conclusao									[Data Entr.Docs.Transp.],
		T13.dt_previsao									[Data Prev. Entrega],
		T13.dt_conclusao								[Data Entrega Planta],
		dbo.fBusca_HistoricoDescr(HOU.num_proc_hia,0,getdate()) [Historico],
		HOU.obs_hia										[Notes],
		(case when URG.campo_dados = '1' then 'YES' Else 'NO'end) [Urgente]
	from
		House_Imp_aer HOU with(nolock)
		Join LLp_Imp_aer LLP with(nolock) on LLP.num_proc_lia = HOU.num_proc_hia
		Join Job_imp_aer JOB with(nolock) on JOB.num_proc_hia = HOU.num_proc_hia
		join pessoa	PG  with(nolock) on PG.cd_pes=@Cd_Grupo
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Join Pessoa CNS with(nolock) on CNS.Cd_Pes = HOU.Cd_Consig_HIA
		left Join Pedido_Ship PS  with(nolock) on PS.num_proc=HOU.num_proc_hia
		left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		left Join Usuario BDPCSR  with(nolock) on BDPCSR.cd_usuario = JOB.cd_usuario
		left Join Localidade ORG with(nolock) on ORG.cd_local = HOU.cd_org_hia
		left Join Localidade DST  with(nolock) on DST.cd_local = HOU.cd_dst_hia
		left Join cia_Aerea	CIA with(nolock) on CIA.Cd_Cia_Aer=JOB.Cd_Cia_Aer
		Left Join Terminal TRM with(nolock) on LLP.Cd_Terminal = TRM.Cd_Terminal
		Left Join Usuario_Cliente UC with(nolock) on UC.cd_usuario=P.PO_Responsible and UC.cd_cliente = @cd_grupo
		left join campo_processo NLI with(nolock) on HOU.num_proc_hia=NLI.num_proc and NLI.id_campo=5
		left join campo_processo URG with(nolock) on HOU.num_proc_hia=URG.num_proc and URG.id_campo=36
		left join po_hia PO with(nolock) on PO.num_proc_hia = HOU.num_proc_hia and PO.id_dc=1
		left join po_hia CU with(nolock) on CU.num_proc_hia = HOU.num_proc_hia and CU.id_dc=9
		left join po_hia LI with(nolock) on LI.num_proc_hia = HOU.num_proc_hia and LI.id_dc=23
		left join po_hia DI with(nolock) on DI.num_proc_hia = HOU.num_proc_hia and DI.id_dc=5
		left join tarefas_processos T20 with(nolock) on T20.num_proc=HOU.num_proc_hia and T20.id_task = 20
		left join tarefas_processos T16 with(nolock) on T16.num_proc=HOU.num_proc_hia and T16.id_task = 16
		left join tarefas_processos T59 with(nolock) on T59.num_proc=HOU.num_proc_hia and T59.id_task = 59
		left join tarefas_processos T29 with(nolock) on T29.num_proc=HOU.num_proc_hia and T29.id_task = 29
		left join tarefas_processos T27 with(nolock) on T27.num_proc=HOU.num_proc_hia and T27.id_task = 27
		left join tarefas_processos T28 with(nolock) on T28.num_proc=HOU.num_proc_hia and T28.id_task = 28
		left join tarefas_processos T15 with(nolock) on T15.num_proc=HOU.num_proc_hia and T15.id_task = 15
		left join tarefas_processos T4 with(nolock) on T4.num_proc=HOU.num_proc_hia and T4.id_task = 4
		left join tarefas_processos T67 with(nolock) on T67.num_proc=HOU.num_proc_hia and T67.id_task = 67
		left join tarefas_processos T7 with(nolock) on T7.num_proc=HOU.num_proc_hia and T7.id_task = 7
		left join tarefas_processos T13 with(nolock) on T13.num_proc=HOU.num_proc_hia and T13.id_task = 13
		left join tarefas_processos T14 with(nolock) on T14.num_proc=HOU.num_proc_hia and T14.id_task = 14
		left join tarefas_processos T40 with(nolock) on T40.num_proc=HOU.num_proc_hia and T40.id_task = 40	
		Left Join Campo_Processo CPD with(nolock) on num_proc_lia=CPD.num_proc and CPD.id_Campo=32
	where
		(convert(datetime,HOU.Dt_Emis_HIA,103) between @DtInicial and @DtFinal)
		AND (( @Tipo = '0' and T40.dt_conclusao is NULL  and T14.dt_conclusao is null )
		OR ( @Tipo = '1' and (T40.dt_conclusao is NOT NULL OR T14.dt_conclusao is NOT null )))		
		and isnull(llp.id_status,0) <> '9'

		and ((@Despacho = 'S' and (CPD.Campo_Dados = '1' or CPD.Campo_Dados is null)) 
		or (@Despacho = 'N' and CPD.Campo_Dados = '2')
		or (@Despacho = '' ))	
	group by
		BDPCSR.Nome_usuario,
		HOU.Num_Proc_HIA,
		HOU.Num_Proc_MIA,
		PG.Apelido,
		CNS.nome_raz_soc,
		CNS.num_cpf_cnpj,
		HOU.MAWB_HIA,
		HOU.HAWB_HIA,
		PO.numero_po_hia,
		CU.numero_po_hia,
		ORG.Nome_Local,
		DST.Nome_Local,
		CIA.nome_cia_aer,
		HOU.voo_Hia,
		TRM.Nome_Terminal,
		UC.Nome_Usuario,
		NLI.campo_dados,
		LI.numero_po_hia,
		T20.dt_conclusao,
		LLP.ETD_LIA,
		LLP.ATD_LIA,
		LLP.ETA_LIA,
		LLP.ATA_LIA,
		T16.dt_conclusao,
		T59.dt_conclusao,
		T29.dt_conclusao,
		T27.dt_conclusao,
		T28.dt_conclusao,
		T15.dt_conclusao,
		DI.numero_po_hia,
		DI.data_po_hia,
		T4.dt_conclusao,
		LLP.Canal_LIA,
		T67.dt_conclusao,
		T7.dt_conclusao,
		T13.dt_previsao,
		T13.dt_conclusao,
		HOU.obs_hia,
		URG.campo_dados

UNION ALL

	select
        'RAIL/TRUCK'									[Modal],
		BDPCSR.Nome_usuario								[BDP CSR Name],
		HOU.Num_Proc_HIO								[Ref. BDP],
		NULL											[Ref. Consolidada],
		PG.Apelido										[Group],
		CNS.nome_raz_soc								[Consignee],
		CNS.num_cpf_cnpj								[Consignee CNPJ],
		HOU.MAWB_HIO									[Master],
		HOU.HAWB_HIO									[House],
		PO.numero_po_hio								[P.O.],
		CU.numero_po_hio								[Customer PO],
		dbo.fBusca_GMID(HOU.Num_Proc_HIO)				[Product Code],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO)			[Product],
		ORG.Nome_Local									[Origin],
		DST.Nome_Local									[Destination],
		ARM.Nome_raz_soc								[Carrier],
		HOU.voo_Hio										[Vessel | Flight #],
		dbo.fBusca_Containers(hou.num_proc_hio)			[Containers],
		TRM.Nome_Terminal								[Terminal],
		UC.Nome_Usuario									[Responsible PO],
		(case when NLI.campo_dados = '1' then 'YES' Else 'NO'end) [Necessidade LI],
		LI.numero_po_hio								[L.I.],
		T20.dt_conclusao								[Data Def. L.I.],
		T20.dt_conclusao + 120							[Data Vcto. L.I.],
		LLP.ETD_LIO										[ETD Data],
		LLP.ATD_LIO										[ATD Data],
		LLP.ETA_LIO										[ETA Data],
		LLP.ATA_LIO										[ATA Data],
		T16.dt_conclusao								[Data Cheg. DOCs.],
		T59.dt_conclusao								[Data Sol. Numerário],
		T29.dt_conclusao								[Data Desova],
		T27.dt_conclusao								[Data Digitação],
		T28.dt_conclusao								[Data Entrada Terminal],
		T15.dt_conclusao								[Data Presença Carga],
		DI.numero_po_hio								[DI],
		DI.data_po_hio									[Data DI],
		T4.dt_conclusao									[Data Desembaraço],
		LLP.Canal_LIO									[Channel],
		T67.dt_conclusao								[Data Envio Draft NF-E],
		T7.dt_conclusao									[Data Entr.Docs.Transp.],
		T13.dt_previsao									[Data Prev. Entrega],
		T13.dt_conclusao								[Data Entrega Planta],
		dbo.fBusca_HistoricoDescr(HOU.num_proc_hio,0,getdate()) [Historico],
		HOU.obs_hio										[Notes],
		(case when URG.campo_dados = '1' then 'YES' Else 'NO'end) [Urgente]
	from
		House_Imp_out HOU with(nolock)
		Join LLp_Imp_out LLP with(nolock) on LLP.num_proc_lio = HOU.num_proc_hio
		join pessoa	PG with(nolock) on PG.cd_pes=@Cd_Grupo
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Join Pessoa CNS with(nolock) on CNS.Cd_Pes = HOU.Cd_Consig_HIO
		left Join Pedido_Ship PS  with(nolock) on PS.num_proc=HOU.num_proc_hio
		left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		left Join Usuario BDPCSR  with(nolock) on BDPCSR.cd_usuario = LLP.cd_usuario
		left Join Localidade ORG with(nolock) on ORG.cd_local = HOU.cd_org_hio
		left Join Localidade DST  with(nolock) on DST.cd_local = HOU.cd_dst_hio
		left Join pessoa ARM with(nolock) on ARM.cd_pes = LLP.cd_carrier
		Left Join Terminal TRM with(nolock) on LLP.Cd_Terminal = TRM.Cd_Terminal
		Left Join Usuario_Cliente UC with(nolock) on UC.cd_usuario=P.PO_Responsible and UC.cd_cliente = @cd_grupo
		left join campo_processo NLI with(nolock) on HOU.num_proc_hio=NLI.num_proc and NLI.id_campo=5
		left join campo_processo URG with(nolock) on LLP.num_proc_lio=URG.num_proc and URG.id_campo=36
		left join po_hio PO with(nolock) on PO.num_proc_hio = HOU.num_proc_hio and PO.id_dc=1
		left join po_hio CU with(nolock) on CU.num_proc_hio = HOU.num_proc_hio and CU.id_dc=9
		left join po_hio LI with(nolock) on LI.num_proc_hio = HOU.num_proc_hio and LI.id_dc=23
		left join po_hio DI with(nolock) on DI.num_proc_hio = HOU.num_proc_hio and DI.id_dc=5
		left join tarefas_processos T20 with(nolock) on T20.num_proc=HOU.num_proc_hio and T20.id_task = 20
		left join tarefas_processos T16 with(nolock) on T16.num_proc=HOU.num_proc_hio and T16.id_task = 16
		left join tarefas_processos T59 with(nolock) on T59.num_proc=HOU.num_proc_hio and T59.id_task = 59
		left join tarefas_processos T29 with(nolock) on T29.num_proc=HOU.num_proc_hio and T29.id_task = 29
		left join tarefas_processos T27 with(nolock) on T27.num_proc=HOU.num_proc_hio and T27.id_task = 27
		left join tarefas_processos T28 with(nolock) on T28.num_proc=HOU.num_proc_hio and T28.id_task = 28
		left join tarefas_processos T15 with(nolock) on T15.num_proc=HOU.num_proc_hio and T15.id_task = 15
		left join tarefas_processos T4 with(nolock) on T4.num_proc=HOU.num_proc_hio and T4.id_task = 4
		left join tarefas_processos T67 with(nolock) on T67.num_proc=HOU.num_proc_hio and T67.id_task = 67
		left join tarefas_processos T7 with(nolock) on T7.num_proc=HOU.num_proc_hio and T7.id_task = 7
		left join tarefas_processos T13 with(nolock) on T13.num_proc=HOU.num_proc_hio and T13.id_task = 13
		left join tarefas_processos T14 with(nolock) on T14.num_proc=HOU.num_proc_hio and T14.id_task = 14
		left join tarefas_processos T40 with(nolock) on T40.num_proc=HOU.num_proc_hio and T40.id_task = 40	
		Left Join Campo_Processo CPD with(nolock) on num_proc_lio=CPD.num_proc and CPD.id_Campo=32	
	where
		(convert(datetime,HOU.Dt_Emis_HIO,103) between @DtInicial and @DtFinal)
		AND (( @Tipo = '0' and T40.dt_conclusao is NULL  and T14.dt_conclusao is null )
		OR ( @Tipo = '1' and (T40.dt_conclusao is NOT NULL OR T14.dt_conclusao is NOT null )))		
		and isnull(llp.id_status,0) <> '9'

		and ((@Despacho = 'S' and (CPD.Campo_Dados = '1' or CPD.Campo_Dados is null)) 
		or (@Despacho = 'N' and CPD.Campo_Dados = '2')
		or (@Despacho = '' ))

	group by
		BDPCSR.Nome_usuario,
		HOU.Num_Proc_HIO,
		PG.Apelido,
		CNS.nome_raz_soc,
		CNS.num_cpf_cnpj,
		HOU.MAWB_HIO,
		HOU.HAWB_HIO,
		PO.numero_po_hio,
		CU.numero_po_hio,
		ORG.Nome_Local,
		DST.Nome_Local,
		ARM.Nome_raz_soc,
		HOU.voo_Hio,
		TRM.Nome_Terminal,
		UC.Nome_Usuario,
		NLI.campo_dados,
		LI.numero_po_hio,
		T20.dt_conclusao,
		LLP.ETD_LIO,
		LLP.ATD_LIO,
		LLP.ETA_LIO,
		LLP.ATA_LIO,
		T16.dt_conclusao,
		T59.dt_conclusao,
		T29.dt_conclusao,
		T27.dt_conclusao,
		T28.dt_conclusao,
		T15.dt_conclusao,
		DI.numero_po_hio,
		DI.data_po_hio,
		T4.dt_conclusao,
		LLP.Canal_LIO,
		T67.dt_conclusao,
		T7.dt_conclusao,
		T13.dt_previsao,
		T13.dt_conclusao,
		HOU.obs_hio,
		URG.campo_dados
GO

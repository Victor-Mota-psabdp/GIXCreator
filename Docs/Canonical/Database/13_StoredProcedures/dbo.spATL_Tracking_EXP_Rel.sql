SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--spATL_Tracking_EXP_Rel 'GRUPO DOW','2011-07-01','2011-07-31','0'


CREATE Procedure [dbo].[spATL_Tracking_EXP_Rel] 
(
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime,
	@Tipo char(1),		--	0=OPEN / 1=CLOSE
	@Despacho varchar(5)  --SIM, NAO,'' Vazio
)
As
	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	set @Tipo = left(@Tipo,1)
	if left(@Despacho,1) = 'A'
		set @Despacho = ''
	else		
		set @Despacho = left(@Despacho,1)

	select --top 100
        'AIR'											[Modal],
		BDPCSR.Nome_usuario								[BDP CSR Name],
		HOU.Num_Proc_HEA								[Ref. BDP],
		PG.Apelido										[Group],
		SHP.nome_raz_soc								[Shipper],
		SHP.Num_CPF_CNPJ								[Shipper CNPJ],
		CONS.Apelido									[Consignee],
		UC.Nome_Usuario									[Responsible PO],
		PO.numero_po_hea								[P.O.],
		SO.numero_po_hea								[Sales Order],
		CU.numero_po_hea								[Customer PO],
		dbo.fBusca_GMID(HOU.Num_Proc_HEA)				[Product Code],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HEA)			[Product],
		dbo.fBusca_Containers(hou.num_proc_hea)			[Containers],
		TP.NOME_Tp_Oper									[Incoterm],
		dbo.fNCM(HOU.Num_Proc_HEA)						[NCM],
		Org.Nome_Local									[Origin],
		Dst.Nome_Local									[Destination],
		ARM.Nome_cia_aer								[Carrier],
		HOU.voo_Hea									[Vessel | Flight #],
		HOU.MAWB_HEA									[Master],
		HOU.HAWB_HEA									[House],
		ETD_LEa											[ETD Date],
		ATD_LEa											[ATD Date],
		ETA_LEa											[ETA Date],
		ATA_LEa											[ATA Date],
		RE.numero_po_hea								[RE Date],
		RE.data_po_hea									[RE Date],
		DDE.numero_po_hea								[DDE],
		DDE.data_po_hea									[DDE Date],
		DSE.numero_po_hea								[DSE],
		DSE.data_po_hea									[DSE Date],
		LLP.Canal_LEA									[Channel],
		DSB.dt_conclusao								[Data Desembaraço],
		LLP.ATD_LEA										[Data Conhecimento],
	    AVRE.dt_conclusao								[Data Averb. RE],
		(case 
			when RE.numero_po_hea is NOT null  then 'RE'
			when DSE.numero_po_hea is NOT null then 'DSE'
			else 'N/A' 
		end) [Tipo Declaração],
		NF.numero_po_hea								[NF Number],
		AC.Dt_Solicitacao								[Data Solic. Numerario],
		LLP.Courier_Number_LEa							[Courier #],
		dbo.fBusca_HistoricoDescr(hou.num_proc_hea,0,getdate()) [Histórico],
		vd.descricao									[Urgente]
	from
		House_Exp_aer HOU with(nolock)
		Join LLp_Exp_aer LLP with(nolock) on LLP.num_proc_lea=hou.num_proc_hea
		Join Job_exp_aer JOB with(nolock) on job.num_proc_hea=hou.num_proc_hea
		Join Pessoa CONS with(nolock) on HOU.Cd_Consig_HEa = CONS.Cd_Pes
		Join Pessoa	SHP  with(nolock) on SHP.cd_pes=HOU.Cd_Export_HEA
		join pessoa	PG  with(nolock) on PG.cd_pes=@Cd_Grupo
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEA and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Tipo_Oper TP  with(nolock) on HOU.cd_tp_oper = TP.Cd_tp_oper
		left Join Pedido_Ship PS  with(nolock) on PS.num_proc=hou.num_proc_hea
		left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		left Join Cia_Aerea ARM with(nolock) on ARM.cd_cia_aer=LLP.cd_ciaaerea_lea
		left Join Localidade ORG with(nolock) on hou.cd_org_hea=Org.cd_local
		left Join Localidade DST  with(nolock) on cd_dst_hea=DSt.cd_local
		Left Join Usuario_Cliente UC with(nolock) on UC.cd_usuario=P.PO_Responsible and UC.cd_cliente = @cd_grupo
		left join Adiantamento_Cliente	AC with(nolock) on AC.Num_Proc = Hou.Num_proc_Hea
		left join po_hea PO with(nolock) on PO.num_proc_hea = HOU.num_proc_hea and PO.id_dc='1'
		left join po_hea SO with(nolock) on SO.num_proc_hea = HOU.num_proc_hea and SO.id_dc='3'
		left join po_hea CU with(nolock) on CU.num_proc_hea = HOU.num_proc_hea and CU.id_dc='9'
		left join po_hea RE with(nolock) on RE.num_proc_hea = HOU.num_proc_hea and RE.id_dc='4'
		left join po_hea DDE with(nolock) on DDE.num_proc_hea = HOU.num_proc_hea and DDE.id_dc='12'
		left join po_hea DSE with(nolock) on DSE.num_proc_hea = HOU.num_proc_hea and DSE.id_dc='26'
		left join po_hea NF with(nolock) on NF.num_proc_hea = HOU.num_proc_hea and NF.id_dc='10'
		left join campo_processo URG with(nolock) on LLP.num_proc_lea=URG.num_proc and URG.id_campo=36
		left join verdade VD with(nolock) on URG.campo_dados = VD.id
		left Join Usuario BDPCSR  with(nolock) on BDPCSR.cd_usuario=JOB.cd_usuario
		left join tarefas_processos AVRE with(nolock) on AVRE.num_proc=HOU.num_proc_hea and AVRE.id_task = '15'
		left join tarefas_processos PRST with(nolock) on PRST.num_proc=HOU.num_proc_hea and PRST.id_task = '14'
		left join tarefas_processos PRSTE with(nolock) on PRSTE.num_proc=HOU.num_proc_hea and PRSTE.id_task = '40'
		left join tarefas_processos DSB with(nolock) on DSB.num_proc=HOU.num_proc_hea and DSB.id_task = '4'
		Left Join Campo_Processo CPD with(nolock) on num_proc_lea=CPD.num_proc and CPD.id_Campo=32 	
	where
		(convert(datetime,HOU.Dt_Emis_HEA,103) between @DtInicial and @DtFinal)
		AND (( @Tipo = '0' and PRSTE.dt_conclusao is NULL  and PRST.dt_conclusao is null )
		OR ( @Tipo = '1' and (PRSTE.dt_conclusao is NOT NULL OR PRSTE.dt_conclusao is NOT null )))

		and isnull(llp.id_status,0) <> '9'		

		and ((@Despacho = 'S' and (CPD.Campo_Dados = '1' or CPD.Campo_Dados is null)) 
		or (@Despacho = 'N' and CPD.Campo_Dados = '2')
		or (@Despacho = '' ))

	group by
		BDPCSR.Nome_usuario,
		HOU.Num_Proc_HEA,
		PG.Apelido,
		SHP.nome_raz_soc,
		SHP.Num_CPF_CNPJ,
		CONS.Apelido,
		UC.Nome_Usuario,
		PO.numero_po_hea,
		SO.numero_po_hea,
		CU.numero_po_hea,
		TP.NOME_Tp_Oper,
		Org.Nome_Local,
		Dst.Nome_Local,
		ARM.Nome_cia_Aer,
		HOU.voo_Hea,
		HOU.MAWB_HEA,
		HOU.HAWB_HEA,
		ETD_LEA,
		ATD_LEa,
		ETA_LEa,
		ATA_LEa,
		RE.numero_po_hea,
		RE.data_po_hea,
		DDE.numero_po_hea,
		DDE.data_po_hea,
		DSE.numero_po_hea,
		DSE.data_po_hea,
		LLP.Canal_LEa,
		DSB.dt_conclusao,
	    AVRE.dt_conclusao,
		NF.numero_po_hea,
		AC.Dt_Solicitacao,
		LLP.Courier_Number_LEA,
		vd.descricao

UNION ALL

	select --top 100
        'OCEAN'											[Modal],
		BDPCSR.Nome_usuario								[BDP CSR Name],
		HOU.Num_Proc_HEM								[Ref. BDP],
		PG.Apelido										[Group],
		SHP.nome_raz_soc								[Shipper],
		SHP.Num_CPF_CNPJ								[Shipper CNPJ],
		CONS.Apelido									[Consignee],
		UC.Nome_Usuario									[Responsible PO],
		PO.numero_po_hem								[P.O.],
		SO.numero_po_hem								[Sales Order],
		CU.numero_po_hem								[Customer PO],
		dbo.fBusca_GMID(HOU.Num_Proc_HEM)				[Product Code],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HEM)			[Product],
		dbo.fBusca_Containers(hou.num_proc_hem)			[Containers],
		TP.NOME_Tp_Oper									[Incoterm],
		dbo.fNCM(HOU.Num_Proc_HEM)						[NCM],
		Org.Nome_Local									[Origin],
		Dst.Nome_Local									[Destination],
		ARM.Nome_Armador								[Carrier],
		HOU.Navio_Hem									[Vessel | Flight #],
		HOU.MAWB_HEM									[Master],
		HOU.HAWB_HEM									[House],
		ETD_LEM											[ETD Date],
		ATD_LEM											[ATD Date],
		ETA_LEM											[ETA Date],
		ATA_LEM											[ATA Date],
		RE.numero_po_hem								[RE Date],
		RE.data_po_hem									[RE Date],
		DDE.numero_po_hem								[DDE],
		DDE.data_po_hem									[DDE Date],
		DSE.numero_po_hem								[DSE],
		DSE.data_po_hem									[DSE Date],
		LLP.Canal_LEM									[Channel],
		DSB.dt_conclusao								[Data Desembaraço],
		LLP.Dt_BL_Lem									[Data Conhecimento],
	    AVRE.dt_conclusao								[Data Averb. RE],
		(case 
			when RE.numero_po_hem is NOT null  then 'RE'
			when DSE.numero_po_hem is NOT null then 'DSE'
			else 'N/A' 
		end) [Tipo Declaração],
		NF.numero_po_hem								[NF Number],
		AC.Dt_Solicitacao								[Data Solic. Numerario],
		LLP.Courier_Number_LEM							[Courier #],
		dbo.fBusca_HistoricoDescr(hou.num_proc_hem,0,getdate()) [Histórico],
		vd.descricao									[Urgente]
	from
		House_Exp_Mar HOU with(nolock)
		Join LLp_Exp_mar LLP with(nolock) on LLP.num_proc_lem=hou.num_proc_hem
		Join Job_exp_Mar JOB with(nolock) on job.num_proc_hem=hou.num_proc_hem
		Join Pessoa CONS with(nolock) on HOU.Cd_Consig_HEM = CONS.Cd_Pes
		Join Pessoa	SHP  with(nolock) on SHP.cd_pes=HOU.Cd_Export_HEM
		join pessoa	PG  with(nolock) on PG.cd_pes=@Cd_Grupo
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEM and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Tipo_Oper TP  with(nolock) on HOU.cd_tp_oper = TP.Cd_tp_oper
		left Join Pedido_Ship PS  with(nolock) on PS.num_proc=hou.num_proc_hem
		left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		left Join Armador ARM with(nolock) on ARM.cd_armador=llp.cd_armador_lem
		left Join Localidade ORG with(nolock) on hou.cd_org_hem=Org.cd_local
		left Join Localidade DST  with(nolock) on cd_dst_hem=DSt.cd_local
		Left Join Usuario_Cliente UC with(nolock) on UC.cd_usuario=P.PO_Responsible and UC.cd_cliente = @cd_grupo
		left join Adiantamento_Cliente	AC with(nolock) on AC.Num_Proc = Hou.Num_proc_Hem
		left join po_hem PO with(nolock) on PO.num_proc_hem = HOU.num_proc_hem and PO.id_dc='1'
		left join po_hem SO with(nolock) on SO.num_proc_hem = HOU.num_proc_hem and SO.id_dc='3'
		left join po_hem CU with(nolock) on CU.num_proc_hem = HOU.num_proc_hem and CU.id_dc='9'
		left join po_hem RE with(nolock) on RE.num_proc_hem = HOU.num_proc_hem and RE.id_dc='4'
		left join po_hem DDE with(nolock) on DDE.num_proc_hem = HOU.num_proc_hem and DDE.id_dc='12'
		left join po_hem DSE with(nolock) on DSE.num_proc_hem = HOU.num_proc_hem and DSE.id_dc='26'
		left join po_hem NF with(nolock) on NF.num_proc_hem = HOU.num_proc_hem and NF.id_dc='10'
		left join campo_processo URG with(nolock) on LLP.num_proc_lem=URG.num_proc and URG.id_campo=36
		left join verdade VD with(nolock) on URG.campo_dados = VD.id
		left Join Usuario BDPCSR  with(nolock) on BDPCSR.cd_usuario=JOB.cd_usuario
		left join tarefas_processos AVRE with(nolock) on AVRE.num_proc=HOU.num_proc_hem and AVRE.id_task = '15'
		left join tarefas_processos PRST with(nolock) on PRST.num_proc=HOU.num_proc_hem and PRST.id_task = '14'
		left join tarefas_processos PRSTE with(nolock) on PRSTE.num_proc=HOU.num_proc_hem and PRSTE.id_task = '40'
		left join tarefas_processos DSB with(nolock) on DSB.num_proc=HOU.num_proc_hem and DSB.id_task = '4'
		Left Join Campo_Processo CPD with(nolock) on num_proc_lem=CPD.num_proc and CPD.id_Campo=32
	where
		(convert(datetime,HOU.Dt_Emis_HEM,103) between @DtInicial and @DtFinal)
		AND (( @Tipo = '0' and PRSTE.dt_conclusao is NULL  and PRST.dt_conclusao is null )
		OR ( @Tipo = '1' and (PRSTE.dt_conclusao is NOT NULL OR PRSTE.dt_conclusao is NOT null )))

		and isnull(llp.id_status,0) <> '9'		

		and ((@Despacho = 'S' and (CPD.Campo_Dados = '1' or CPD.Campo_Dados is null)) 
		or (@Despacho = 'N' and CPD.Campo_Dados = '2')
		or (@Despacho = '' ))

	group by
		BDPCSR.Nome_usuario,
		HOU.Num_Proc_HEM,
		PG.Apelido,
		SHP.nome_raz_soc,
		SHP.Num_CPF_CNPJ,
		CONS.Apelido,
		UC.Nome_Usuario,
		PO.numero_po_hem,
		SO.numero_po_hem,
		CU.numero_po_hem,
		TP.NOME_Tp_Oper,
		Org.Nome_Local,
		Dst.Nome_Local,
		ARM.Nome_Armador,
		HOU.Navio_Hem,
		HOU.MAWB_HEM,
		HOU.HAWB_HEM,
		ETD_LEM,
		ATD_LEM,
		ETA_LEM,
		ATA_LEM,
		RE.numero_po_hem,
		RE.data_po_hem,
		DDE.numero_po_hem,
		DDE.data_po_hem,
		DSE.numero_po_hem,
		DSE.data_po_hem,
		LLP.Canal_LEM,
		DSB.dt_conclusao,
		LLP.Dt_BL_Lem,
	    AVRE.dt_conclusao,
		NF.numero_po_hem,
		AC.Dt_Solicitacao,
		LLP.Courier_Number_LEM,
		vd.descricao

UNION ALL

	select --top 100
        'Rail/Truck'									[Modal],
		BDPCSR.Nome_usuario								[BDP CSR Name],
		HOU.Num_Proc_HEO								[Ref. BDP],
		PG.Apelido										[Group],
		SHP.nome_raz_soc								[Shipper],
		SHP.Num_CPF_CNPJ								[Shipper CNPJ],
		CONS.Apelido									[Consignee],
		UC.Nome_Usuario									[Responsible PO],
		PO.numero_po_heo								[P.O.],
		SO.numero_po_heo								[Sales Order],
		CU.numero_po_heo								[Customer PO],
		dbo.fBusca_GMID(HOU.Num_Proc_HEO)				[Product Code],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HEO)			[Product],
		dbo.fBusca_Containers(hou.num_proc_heo)			[Containers],
		TP.NOME_Tp_Oper									[Incoterm],
		dbo.fNCM(HOU.Num_Proc_HEO)						[NCM],
		Org.Nome_Local									[Origin],
		Dst.Nome_Local									[Destination],
		ARM.Apelido										[Carrier],
		HOU.voo_Heo										[Vessel | Flight #],
		HOU.MAWB_HEO									[Master],
		HOU.HAWB_HEO									[House],
		ETD_LEO											[ETD Date],
		ATD_LEO											[ATD Date],
		ETA_LEO											[ETA Date],
		ATA_LEO											[ATA Date],
		RE.numero_po_heo								[RE Date],
		RE.data_po_heo									[RE Date],
		DDE.numero_po_heo								[DDE],
		DDE.data_po_heo									[DDE Date],
		DSE.numero_po_heo								[DSE],
		DSE.data_po_heo									[DSE Date],
		LLP.Canal_LEO									[Channel],
		DSB.dt_conclusao								[Data Desembaraço],
		LLP.ATD_LEO										[Data Conhecimento],
	    AVRE.dt_conclusao								[Data Averb. RE],
		(case 
			when RE.numero_po_heo is NOT null  then 'RE'
			when DSE.numero_po_heo is NOT null then 'DSE'
			else 'N/A' 
		end) [Tipo Declaração],
		NF.numero_po_heo								[NF Number],
		AC.Dt_Solicitacao								[Data Solic. Numerario],
		LLP.Courier_Number_LEO							[Courier #],
		dbo.fBusca_HistoricoDescr(hou.num_proc_heo,0,getdate()) [Histórico],
		vd.descricao									[Urgente]
	from
		House_Exp_out HOU with(nolock)
		Join LLp_Exp_out LLP with(nolock) on LLP.num_proc_leo=hou.num_proc_heo
		Join Pessoa CONS with(nolock) on HOU.Cd_Consig_HEO = CONS.Cd_Pes
		Join Pessoa	SHP  with(nolock) on SHP.cd_pes=HOU.Cd_Export_HEO
		join pessoa	PG  with(nolock) on PG.cd_pes=@Cd_Grupo
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEO and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Tipo_Oper TP  with(nolock) on HOU.cd_tp_oper = TP.Cd_tp_oper
		left Join Pedido_Ship PS  with(nolock) on PS.num_proc=hou.num_proc_heo
		left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
		left Join pessoa ARM with(nolock) on ARM.cd_pes=llp.cd_carrier
		left Join Localidade ORG with(nolock) on hou.cd_org_heo=Org.cd_local
		left Join Localidade DST  with(nolock) on cd_dst_heo=DSt.cd_local
		Left Join Usuario_Cliente UC with(nolock) on UC.cd_usuario=P.PO_Responsible and UC.cd_cliente = @cd_grupo
		left join Adiantamento_Cliente	AC with(nolock) on AC.Num_Proc = Hou.Num_proc_Heo
		left join po_heo PO with(nolock) on PO.num_proc_heo = HOU.num_proc_heo and PO.id_dc='1'
		left join po_heo SO with(nolock) on SO.num_proc_heo = HOU.num_proc_heo and SO.id_dc='3'
		left join po_heo CU with(nolock) on CU.num_proc_heo = HOU.num_proc_heo and CU.id_dc='9'
		left join po_heo RE with(nolock) on RE.num_proc_heo = HOU.num_proc_heo and RE.id_dc='4'
		left join po_heo DDE with(nolock) on DDE.num_proc_heo = HOU.num_proc_heo and DDE.id_dc='12'
		left join po_heo DSE with(nolock) on DSE.num_proc_heo = HOU.num_proc_heo and DSE.id_dc='26'
		left join po_heo NF with(nolock) on NF.num_proc_heo = HOU.num_proc_heo and NF.id_dc='10'
		left join campo_processo URG with(nolock) on LLP.num_proc_leo=URG.num_proc and URG.id_campo=36
		left join verdade VD with(nolock) on URG.campo_dados = VD.id
		left Join Usuario BDPCSR  with(nolock) on BDPCSR.cd_usuario=LLP.cd_usuario
		left join tarefas_processos AVRE with(nolock) on AVRE.num_proc=HOU.num_proc_heo and AVRE.id_task = '15'
		left join tarefas_processos PRST with(nolock) on PRST.num_proc=HOU.num_proc_heo and PRST.id_task = '14'
		left join tarefas_processos PRSTE with(nolock) on PRSTE.num_proc=HOU.num_proc_heo and PRSTE.id_task = '40'
		left join tarefas_processos DSB with(nolock) on DSB.num_proc=HOU.num_proc_heo and DSB.id_task = '4'
		Left Join Campo_Processo CPD with(nolock) on num_proc_leo=CPD.num_proc and CPD.id_Campo=32
	where
		(convert(datetime,HOU.Dt_Emis_HEO,103) between @DtInicial and @DtFinal)
		AND (( @Tipo = '0' and PRSTE.dt_conclusao is NULL  and PRST.dt_conclusao is null )
		OR ( @Tipo = '1' and (PRSTE.dt_conclusao is NOT NULL OR PRSTE.dt_conclusao is NOT null )))

		and isnull(llp.id_status,0) <> '9'		

		and ((@Despacho = 'S' and (CPD.Campo_Dados = '1' or CPD.Campo_Dados is null)) 
		or (@Despacho = 'N' and CPD.Campo_Dados = '2')
		or (@Despacho = '' ))

	group by
		BDPCSR.Nome_usuario,
		HOU.Num_Proc_HEO,
		PG.Apelido,
		SHP.nome_raz_soc,
		SHP.Num_CPF_CNPJ,
		CONS.Apelido,
		UC.Nome_Usuario,
		PO.numero_po_heo,
		SO.numero_po_heo,
		CU.numero_po_heo,
		TP.NOME_Tp_Oper,
		Org.Nome_Local,
		Dst.Nome_Local,
		ARM.Apelido,
		HOU.voo_Heo,
		HOU.MAWB_HEo,
		HOU.HAWB_HEo,
		ETD_LEo,
		ATD_LEo,
		ETA_LEo,
		ATA_LEo,
		RE.numero_po_heo,
		RE.data_po_heo,
		DDE.numero_po_heo,
		DDE.data_po_heo,
		DSE.numero_po_heo,
		DSE.data_po_heo,
		LLP.Canal_LEo,
		DSB.dt_conclusao,
		LLP.ATD_LEO,
	    AVRE.dt_conclusao,
		NF.numero_po_heo,
		AC.Dt_Solicitacao,
		LLP.Courier_Number_LEo,
		vd.descricao

GO

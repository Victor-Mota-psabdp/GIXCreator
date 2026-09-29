SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SEA
--AIR
--select * from Net_Revenue_Temp
CREATE Procedure [dbo].[spATL_TrackingWilmarTeste_Rel]--'2012-01-01','2012-12-31','AIR'
(
	@DtInicial datetime,
	@DtFinal datetime,
	@modal	varchar(30)	
)
As

 if @MODAL = 'ALL' or @MODAL = ''
	BEGIN	
		select distinct
			HOU.Num_Proc_HIM															[JOB],
			HOU.Dt_Emis_HIM																[JOB Date],		
			'Ocean Import'																[Modal],
			Ship.Nome_Raz_Soc															[Shipper's Name],
			Consig.Nome_Raz_Soc															[Consignee's Name],		
			ORG.nome_local																[Origin],
			DST.nome_local																[Destination],
			(case when tp_frete_him = 'P' then 'X' end)									[PPD],
			(case when tp_frete_him = 'C' then 'X' end)									[COL],
			LLP.ATD_LIM																	[ATD Date],		
			LLP.ATA_LIM																	[ATA Date],		
			Peso_Bruto_HIM																[Gross Weight KG],
			Peso_Liquido_HIM															[Net Weight KG],
			Vol_Tot_him																	[Volume (M3)],
--			[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HIM)					[Custo Processo],	
--			[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HIM)									[Net Revenue],
			Custo_Processo_SemImpostos													[Custo Processo],	
			Net_revenue																	[Net Revenue],

			(case when CP32.Campo_Dados='2' then 'NÃO'
				else
				'SIM'	end) [Despacho]		
		from			
			House_Imp_Mar	HOU	with(nolock)
			Join LLP_Imp_Mar	LLP		with(nolock) on HOU.Num_Proc_HIM	= LLP.Num_Proc_Lim
			left join Net_Revenue_Temp NET with(nolock) on HOU.Num_Proc_HIM	= NET.Ref_BDP
			Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HIM 	= Ship.Cd_Pes
			Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HIM 	= Consig.Cd_Pes
			Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HIM 		= ORG.Cd_Local 
			Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HIM 		= DST.Cd_Local
			left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HIM and CP32.id_campo=32	
		where
			LLP.ETD_LIM between @DtInicial and @DtFinal
			and isnull(llp.id_status,0) <> '9' and HOU.Num_proc_MIM<>'JOB'

	UNION ALL

		select distinct
			HOU.Num_Proc_HIM															[JOB],
			HOU.Dt_Emis_HIM																[JOB Date],		
			'CHBImport'																	[Modal],
			Ship.Nome_Raz_Soc															[Shipper's Name],
			Consig.Nome_Raz_Soc															[Consignee's Name],		
			ORG.nome_local																[Origin],
			DST.nome_local																[Destination],
			(case when tp_frete_him = 'P' then 'X' end)									[PPD],
			(case when tp_frete_him = 'C' then 'X' end)									[COL],
			LLP.ATD_LIM																	[ATD Date],		
			LLP.ATA_LIM																	[ATA Date],		
			Peso_Bruto_HIM																[Gross Weight KG],
			Peso_Liquido_HIM															[Net Weight KG],
			Vol_Tot_him																	[Volume (M3)],
--			[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HIM)					[Custo Processo],	
--			[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HIM)									[Net Revenue],
			Custo_Processo_SemImpostos													[Custo Processo],	
			Net_revenue																	[Net Revenue],
--
			(case when CP32.Campo_Dados='2' then 'NÃO'
				else
				'SIM'	end) [Despacho]		
		from
			tarefas_processos	TP	
			Join House_Imp_Mar	HOU		with(nolock) on TP.Num_Proc			= HOU.Num_Proc_HIM
			Join LLP_Imp_Mar	LLP		with(nolock) on TP.Num_Proc			= LLP.Num_Proc_Lim
			left join Net_Revenue_Temp NET with(nolock) on TP.Num_Proc		= NET.Ref_BDP
			Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HIM 	= Ship.Cd_Pes
			Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HIM 	= Consig.Cd_Pes
			Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HIM 		= ORG.Cd_Local 
			Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HIM 		= DST.Cd_Local
			left join campo_processo CP32 with(nolock) on CP32.num_proc=TP.Num_Proc and CP32.id_campo=32	
		where
			dt_conclusao between @DtInicial and @DtFinal
			and id_Task=4
			and left(TP.num_proc,1)='I'		
			and isnull(llp.id_status,0) <> '9'
			
	UNION ALL
		select distinct
			HOU.Num_Proc_HIA															[JOB],
			HOU.Dt_Emis_HIA																[JOB Date],		
			'Air Import'																[Modal],
			Ship.Nome_Raz_Soc															[Shipper's Name],
			Consig.Nome_Raz_Soc															[Consignee's Name],		
			ORG.nome_local																[Origin],
			DST.nome_local																[Destination],
			(case when tp_frete_hia = 'P' then 'X' end)									[PPD],
			(case when tp_frete_hia = 'C' then 'X' end)									[COL],
			LLP.ATD_LIA																	[ATD Date],		
			LLP.ATA_LIA																	[ATA Date],		
			Peso_Bruto_HIA																[Gross Weight KG],
			Peso_real_HIA																[Net Weight KG],
			Vol_Tot_hia																	[Volume (M3)],
--			[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HIA)					[Custo Processo],	
--			[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HIA)									[Net Revenue],
			Custo_Processo_SemImpostos													[Custo Processo],	
			Net_revenue																	[Net Revenue],
--				
			(case when CP32.Campo_Dados='2' then 'NÃO'
				else
				'SIM'	end) [Despacho]			
		from
			House_Imp_aer HOU with(nolock)
			Join LLP_Imp_aer	LLP		with(nolock) on HOU.Num_Proc_HIA	= LLP.Num_Proc_Lia
			left join Net_Revenue_Temp NET with(nolock) on HOU.Num_Proc_HIA	= NET.Ref_BDP
			Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HIA 	= Ship.Cd_Pes
			Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HIA 	= Consig.Cd_Pes
			Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HIA 		= ORG.Cd_Local 
			Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HIA 		= DST.Cd_Local
			left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HIA and CP32.id_campo=32 
		where
			LLP.ETA_LIA between @DtInicial and @DtFinal
			and isnull(llp.id_status,0) <> '9' and Num_proc_MIA<>'JOB'
	
	UNION ALL
		select distinct
			HOU.Num_Proc_HEM															[JOB],
			HOU.Dt_Emis_HEM																[JOB Date],		
			'Ocean Export'																[Modal],
			Ship.Nome_Raz_Soc															[Shipper's Name],
			Consig.Nome_Raz_Soc															[Consignee's Name],		
			ORG.nome_local																[Origin],
			DST.nome_local																[Destination],
			(case when tp_frete_hem = 'P' then 'X' end)									[PPD],
			(case when tp_frete_hem = 'C' then 'X' end)									[COL],
			LLP.ATD_LEM																	[ATD Date],		
			LLP.ATA_LEM																	[ATA Date],		
			Peso_Bruto_HEM																[Gross Weight KG],
			Peso_Liquido_HEM															[Net Weight KG],
			Vol_Tot_hem																	[Volume (M3)],
--			[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HEM)					[Custo Processo],	
--			[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HEM)									[Net Revenue],
			Custo_Processo_SemImpostos													[Custo Processo],	
			Net_revenue																	[Net Revenue],
--
			(case when CP32.Campo_Dados='2' then 'NÃO'
				else
				'SIM'	end) [Despacho]		
		from
			House_Exp_Mar HOU with(nolock)
			Join LLP_Exp_Mar	LLP		with(nolock) on HOU.Num_Proc_HeM	= LLP.Num_Proc_Lem
			left join Net_Revenue_Temp NET with(nolock) on HOU.Num_Proc_HEM	= NET.Ref_BDP
			Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HEM 	= Ship.Cd_Pes
			Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HEM 	= Consig.Cd_Pes
			Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HEM 		= ORG.Cd_Local 
			Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HEM 		= DST.Cd_Local
			left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HeM and CP32.id_campo=32	
		where
			LLP.ETA_LEM between @DtInicial and @DtFinal
			and isnull(llp.id_status,0) <> '9'	and Num_proc_MEM <> 'JOB' 
			
	UNION ALL
		select distinct
			HOU.Num_Proc_HEM															[JOB],
			HOU.Dt_Emis_HEM																[JOB Date],		
			'CHBExport'																	[Modal],
			Ship.Nome_Raz_Soc															[Shipper's Name],
			Consig.Nome_Raz_Soc															[Consignee's Name],		
			ORG.nome_local																[Origin],
			DST.nome_local																[Destination],
			(case when tp_frete_hem = 'P' then 'X' end)									[PPD],
			(case when tp_frete_hem = 'C' then 'X' end)									[COL],
			LLP.ATD_LEM																	[ATD Date],		
			LLP.ATA_LEM																	[ATA Date],		
			Peso_Bruto_HEM																[Gross Weight KG],
			Peso_Liquido_HEM															[Net Weight KG],
			Vol_Tot_hem																	[Volume (M3)],
--			[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HEM)					[Custo Processo],	
--			[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HEM)									[Net Revenue],
			Custo_Processo_SemImpostos													[Custo Processo],	
			Net_revenue																	[Net Revenue],
--
			(case when CP32.Campo_Dados='2' then 'NÃO'
				else
				'SIM'	end) [Despacho]		
		from
			tarefas_processos	TP	
			Join House_Exp_Mar	HOU		with(nolock) on TP.Num_Proc			= HOU.Num_Proc_HeM
			Join LLP_Exp_Mar	LLP		with(nolock) on TP.Num_Proc	= LLP.Num_Proc_Lem
			left join Net_Revenue_Temp NET with(nolock) on TP.Num_Proc	= NET.Ref_BDP
			Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HEM 	= Ship.Cd_Pes
			Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HEM 	= Consig.Cd_Pes
			Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HEM 		= ORG.Cd_Local 
			Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HEM 		= DST.Cd_Local
			left join campo_processo CP32 with(nolock) on CP32.num_proc=TP.Num_Proc and CP32.id_campo=32	
		where
			dt_conclusao between @DtInicial and @DtFinal 
			and id_Task=4
			and left(TP.num_proc,1)='E'		
			and isnull(llp.id_status,0) <> '9' 

	UNION ALL
		select distinct
			HOU.Num_Proc_HEA															[JOB],
			HOU.Dt_Emis_HEA																[JOB Date],		
			'Air Export'																[Modal],
			Ship.Nome_Raz_Soc															[Shipper's Name],
			Consig.Nome_Raz_Soc															[Consignee's Name],		
			ORG.nome_local																[Origin],
			DST.nome_local																[Destination],
			(case when tp_frete_hea = 'P' then 'X' end)									[PPD],
			(case when tp_frete_hea = 'C' then 'X' end)									[COL],
			LLP.ATD_LEA																	[ATD Date],		
			LLP.ATA_LEA																	[ATA Date],		
			Peso_Bruto_HEA																[Gross Weight KG],
			Peso_real_HEA																[Net Weight KG],
			Vol_Tot_hea																	[Volume (M3)],
--			[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HEA)					[Custo Processo],	
--			[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HEA)									[Net Revenue],
			Custo_Processo_SemImpostos													[Custo Processo],	
			Net_revenue																	[Net Revenue],
--				
			(case when CP32.Campo_Dados='2' then 'NÃO'
				else
				'SIM'	end) [Despacho]			
		from
			House_Exp_aer HOU with(nolock)
			Join LLP_Exp_aer	LLP		with(nolock) on HOU.Num_Proc_HEA	= LLP.Num_Proc_Lea
			left join Net_Revenue_Temp NET with(nolock) on HOU.Num_Proc_HEA	= NET.Ref_BDP
			Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HEA 	= Ship.Cd_Pes
			Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HEA 	= Consig.Cd_Pes
			Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HEA 		= ORG.Cd_Local 
			Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HEA 		= DST.Cd_Local
			left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HEA and CP32.id_campo=32 
		where
			LLP.ETA_LEA between @DtInicial and @DtFinal
			and isnull(llp.id_status,0) <> '9' and Num_proc_MEA<>'JOB'	
	END
ELSE
	if @MODAL = 'SEA'
		BEGIN
			select distinct
				HOU.Num_Proc_HIM															[JOB],
				HOU.Dt_Emis_HIM																[JOB Date],		
				'Ocean Import'																[Modal],
				Ship.Nome_Raz_Soc															[Shipper's Name],
				Consig.Nome_Raz_Soc															[Consignee's Name],		
				ORG.nome_local																[Origin],
				DST.nome_local																[Destination],
				(case when tp_frete_him = 'P' then 'X' end)									[PPD],
				(case when tp_frete_him = 'C' then 'X' end)									[COL],
				LLP.ATD_LIM																	[ATD Date],		
				LLP.ATA_LIM																	[ATA Date],		
				Peso_Bruto_HIM																[Gross Weight KG],
				Peso_Liquido_HIM															[Net Weight KG],
				Vol_Tot_him																	[Volume (M3)],
--				[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HIM)					[Custo Processo],	
--				[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HIM)									[Net Revenue],
				Custo_Processo_SemImpostos													[Custo Processo],	
				Net_revenue																	[Net Revenue],
--
				(case when CP32.Campo_Dados='2' then 'NÃO'
					else
					'SIM'	end) [Despacho]		
			from
				House_Imp_Mar HOU with(nolock)
				Join LLP_Imp_Mar	LLP		with(nolock) on HOU.Num_Proc_HIM	= LLP.Num_Proc_Lim
				left join Net_Revenue_Temp NET with(nolock) on HOU.Num_Proc_HIM	= NET.Ref_BDP
				Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HIM 	= Ship.Cd_Pes
				Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HIM 	= Consig.Cd_Pes
				Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HIM 		= ORG.Cd_Local 
				Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HIM 		= DST.Cd_Local
				left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HIM and CP32.id_campo=32	
			where
				LLP.ETD_LIM between @DtInicial and @DtFinal
				and isnull(llp.id_status,0) <> '9' and HOU.Num_proc_MIM<>'JOB'
		UNION ALL

			select distinct
				HOU.Num_Proc_HIM															[JOB],
				HOU.Dt_Emis_HIM																[JOB Date],		
				'CHBImport'																	[Modal],
				Ship.Nome_Raz_Soc															[Shipper's Name],
				Consig.Nome_Raz_Soc															[Consignee's Name],		
				ORG.nome_local																[Origin],
				DST.nome_local																[Destination],
				(case when tp_frete_him = 'P' then 'X' end)									[PPD],
				(case when tp_frete_him = 'C' then 'X' end)									[COL],
				LLP.ATD_LIM																	[ATD Date],		
				LLP.ATA_LIM																	[ATA Date],		
				Peso_Bruto_HIM																[Gross Weight KG],
				Peso_Liquido_HIM															[Net Weight KG],
				Vol_Tot_him																	[Volume (M3)],
	--			[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HIM)					[Custo Processo],	
	--			[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HIM)									[Net Revenue],
				Custo_Processo_SemImpostos													[Custo Processo],	
				Net_revenue																	[Net Revenue],
	--
				(case when CP32.Campo_Dados='2' then 'NÃO'
					else
					'SIM'	end) [Despacho]		
			from
				tarefas_processos	TP	
				Join House_Imp_Mar	HOU		with(nolock) on TP.Num_Proc			= HOU.Num_Proc_HIM
				Join LLP_Imp_Mar	LLP		with(nolock) on TP.Num_Proc			= LLP.Num_Proc_Lim
				left join Net_Revenue_Temp NET with(nolock) on TP.Num_Proc		= NET.Ref_BDP
				Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HIM 	= Ship.Cd_Pes
				Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HIM 	= Consig.Cd_Pes
				Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HIM 		= ORG.Cd_Local 
				Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HIM 		= DST.Cd_Local
				left join campo_processo CP32 with(nolock) on CP32.num_proc=TP.Num_Proc and CP32.id_campo=32	
			where
				dt_conclusao between @DtInicial and @DtFinal
				and id_Task=4
				and left(TP.num_proc,1)='I'		
				and isnull(llp.id_status,0) <> '9'

		UNION ALL
			select distinct
				HOU.Num_Proc_HEM															[JOB],
				HOU.Dt_Emis_HEM																[JOB Date],		
				'Ocean Export'																[Modal],
				Ship.Nome_Raz_Soc															[Shipper's Name],
				Consig.Nome_Raz_Soc															[Consignee's Name],		
				ORG.nome_local																[Origin],
				DST.nome_local																[Destination],
				(case when tp_frete_hem = 'P' then 'X' end)									[PPD],
				(case when tp_frete_hem = 'C' then 'X' end)									[COL],
				LLP.ATD_LEM																	[ATD Date],		
				LLP.ATA_LEM																	[ATA Date],		
				Peso_Bruto_HEM																[Gross Weight KG],
				Peso_Liquido_HEM															[Net Weight KG],
				Vol_Tot_hem																	[Volume (M3)],
--				[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HEM)					[Custo Processo],	
--				[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HEM)									[Net Revenue],
				Custo_Processo_SemImpostos													[Custo Processo],	
				Net_revenue																	[Net Revenue],
--
				(case when CP32.Campo_Dados='2' then 'NÃO'
					else
					'SIM'	end) [Despacho]		
			from
				House_Exp_Mar HOU with(nolock)
				Join LLP_Exp_Mar	LLP		with(nolock) on HOU.Num_Proc_HeM	= LLP.Num_Proc_Lem
				left join Net_Revenue_Temp NET with(nolock) on HOU.Num_Proc_HEM	= NET.Ref_BDP
				Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HEM 	= Ship.Cd_Pes
				Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HEM 	= Consig.Cd_Pes
				Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HEM 		= ORG.Cd_Local 
				Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HEM 		= DST.Cd_Local
				left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HeM and CP32.id_campo=32	
			where
				LLP.ETD_LEM between @DtInicial and @DtFinal
				and isnull(llp.id_status,0) <> '9' and HOU.Num_proc_MEM<>'JOB'

		UNION ALL
			select distinct
				HOU.Num_Proc_HEM															[JOB],
				HOU.Dt_Emis_HEM																[JOB Date],		
				'CHBExport'																[Modal],
				Ship.Nome_Raz_Soc															[Shipper's Name],
				Consig.Nome_Raz_Soc															[Consignee's Name],		
				ORG.nome_local																[Origin],
				DST.nome_local																[Destination],
				(case when tp_frete_hem = 'P' then 'X' end)									[PPD],
				(case when tp_frete_hem = 'C' then 'X' end)									[COL],
				LLP.ATD_LEM																	[ATD Date],		
				LLP.ATA_LEM																	[ATA Date],		
				Peso_Bruto_HEM																[Gross Weight KG],
				Peso_Liquido_HEM															[Net Weight KG],
				Vol_Tot_hem																	[Volume (M3)],
	--			[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HEM)					[Custo Processo],	
	--			[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HEM)									[Net Revenue],
				Custo_Processo_SemImpostos													[Custo Processo],	
				Net_revenue																	[Net Revenue],
	--
				(case when CP32.Campo_Dados='2' then 'NÃO'
					else
					'SIM'	end) [Despacho]		
			from
				tarefas_processos	TP	
				Join House_Exp_Mar	HOU		with(nolock) on TP.Num_Proc			= HOU.Num_Proc_HeM
				Join LLP_Exp_Mar	LLP		with(nolock) on TP.Num_Proc			= LLP.Num_Proc_Lem
				left join Net_Revenue_Temp NET with(nolock) on TP.Num_Proc		= NET.Ref_BDP
				Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HEM 	= Ship.Cd_Pes
				Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HEM 	= Consig.Cd_Pes
				Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HEM 		= ORG.Cd_Local 
				Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HEM 		= DST.Cd_Local
				left join campo_processo CP32 with(nolock) on CP32.num_proc=TP.Num_Proc and CP32.id_campo=32	
			where
				dt_conclusao between @DtInicial and @DtFinal 
				and id_Task=4
				and left(TP.num_proc,1)='E'		
				and isnull(llp.id_status,0) <> '9' 		
		END
ELSE
	if @MODAL = 'AIR'
		BEGIN
			select distinct
				HOU.Num_Proc_HIA															[JOB],
				HOU.Dt_Emis_HIA																[JOB Date],		
				'Air Import'																[Modal],
				Ship.Nome_Raz_Soc															[Shipper's Name],
				Consig.Nome_Raz_Soc															[Consignee's Name],		
				ORG.nome_local																[Origin],
				DST.nome_local																[Destination],
				(case when tp_frete_hia = 'P' then 'X' end)									[PPD],
				(case when tp_frete_hia = 'C' then 'X' end)									[COL],
				LLP.ATD_LIA																	[ATD Date],		
				LLP.ATA_LIA																	[ATA Date],		
				Peso_Bruto_HIA																[Gross Weight KG],
				Peso_real_HIA																[Net Weight KG],
				Vol_Tot_hia																	[Volume (M3)],
--				[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HIA)					[Custo Processo],	
--				[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HIA)									[Net Revenue],
				Custo_Processo_SemImpostos													[Custo Processo],	
				Net_revenue																	[Net Revenue],
--					
				(case when CP32.Campo_Dados='2' then 'NÃO'
					else
					'SIM'	end) [Despacho]			
			from
				House_Imp_aer HOU with(nolock)
				Join LLP_Imp_aer	LLP		with(nolock) on HOU.Num_Proc_HIA	= LLP.Num_Proc_Lia
				left join Net_Revenue_Temp NET with(nolock) on HOU.Num_Proc_HIA	= NET.Ref_BDP
				Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HIA 	= Ship.Cd_Pes
				Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HIA 	= Consig.Cd_Pes
				Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HIA 		= ORG.Cd_Local 
				Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HIA 		= DST.Cd_Local
				left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HIA and CP32.id_campo=32 
			where
				LLP.ETD_LIA between @DtInicial and @DtFinal
				and isnull(llp.id_status,0) <> '9' and HOU.Num_proc_MIA<>'JOB'

		UNION ALL
			select distinct
				HOU.Num_Proc_HEA															[JOB],
				HOU.Dt_Emis_HEA																[JOB Date],		
				'Air Export'																[Modal],
				Ship.Nome_Raz_Soc															[Shipper's Name],
				Consig.Nome_Raz_Soc															[Consignee's Name],		
				ORG.nome_local																[Origin],
				DST.nome_local																[Destination],
				(case when tp_frete_hea = 'P' then 'X' end)									[PPD],
				(case when tp_frete_hea = 'C' then 'X' end)									[COL],
				LLP.ATD_LEA																	[ATD Date],		
				LLP.ATA_LEA																	[ATA Date],		
				Peso_Bruto_HEA																[Gross Weight KG],
				Peso_real_HEA																[Net Weight KG],
				Vol_Tot_hea																	[Volume (M3)],
--				[dbo].[fBusca_Custo_Processo_SemImpostos](HOU.Num_Proc_HEA)					[Custo Processo],	
--				[dbo].[fNetRevenue_Sel]	(HOU.Num_Proc_HEA)									[Net Revenue],
				Custo_Processo_SemImpostos													[Custo Processo],	
				Net_revenue																	[Net Revenue],
--					
				(case when CP32.Campo_Dados='2' then 'NÃO'
					else
					'SIM'	end) [Despacho]			
			from
				House_Exp_aer HOU with(nolock)
				Join LLP_Exp_aer	LLP		with(nolock) on HOU.Num_Proc_HEA	= LLP.Num_Proc_Lea
				left join Net_Revenue_Temp NET with(nolock) on HOU.Num_Proc_HEA = NET.Ref_BDP
				Join Pessoa			Ship	with(nolock) on HOU.Cd_Export_HEA 	= Ship.Cd_Pes
				Join Pessoa			Consig	with(nolock) on HOU.Cd_Consig_HEA 	= Consig.Cd_Pes
				Join Localidade		ORG		with(nolock) on HOU.Cd_Org_HEA 		= ORG.Cd_Local 
				Join Localidade		DST		with(nolock) on HOU.Cd_Dst_HEA 		= DST.Cd_Local
				left join campo_processo CP32 with(nolock) on CP32.num_proc=HOU.Num_Proc_HEA and CP32.id_campo=32 
			where
				LLP.ETD_LEA between @DtInicial and @DtFinal
				and isnull(llp.id_status,0) <> '9' and HOU.Num_proc_MEA<>'JOB'
		END


GO

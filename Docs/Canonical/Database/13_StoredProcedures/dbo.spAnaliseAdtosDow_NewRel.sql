SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spAnaliseAdtosDow_NewRel]-- '','2011-01-01','2011-10-06',''
	@Grupo			Varchar(400),
	@DataInicial	Datetime,
	@DataFinal		Datetime
AS

--EXPORTAÇÂO AEREA
select 
	Num_Proc_hia [Job],LO.nome_local [Localidade],cxa.dt_pgto_rcto_hia [Data Adiantamento],convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 e 60 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '> 60 Dias'

from vwcxas CXA
	Join Tipo_Taxa TT on tt.cd_tp_tx=CXA.cd_Tp_Tx
	Join Tarefas_Processos TP on TP.num_proc=CXa.num_proc_hia and id_task=40
	join house_exp_aer HOU on CXA.num_proc_hia = HOU.num_proc_hea
	join localidade LO on Hou.cd_org_hea = LO.cd_local

where substring(CXA.num_proc_hia,3,3) in ('STB','ROB','CSR')
			and CXA.dc_hia='C'
			and TT.nome_Tp_tx like 'Adiantamento%'
			and TP.dt_conclusao between @DataInicial and @DataFinal

UNION ALL

--EXPORTAÇÃO MARITIMA
select 
	Num_Proc_hia [Job],LO.nome_local [Localidade],cxa.dt_pgto_rcto_hia [Data Adiantamento],convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 e 60 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '> 60 Dias'

from vwcxas CXA
	Join Tipo_Taxa TT on tt.cd_tp_tx=CXA.cd_Tp_Tx
	Join Tarefas_Processos TP on TP.num_proc=CXa.num_proc_hia and id_task=40
	join house_exp_mar HOU on CXA.num_proc_hia = HOU.num_proc_hem
	join localidade LO on Hou.cd_org_hem = LO.cd_local

where substring(CXA.num_proc_hia,3,3) in ('STB','ROB','CSR')
			and CXA.dc_hia='C'
			and TT.nome_Tp_tx like 'Adiantamento%'
			and TP.dt_conclusao between @DataInicial and @DataFinal

UNION ALL
-- EXPORTAÇÃO OUTROS
select 
	Num_Proc_hia [Job],LO.nome_local [Localidade],cxa.dt_pgto_rcto_hia [Data Adiantamento],convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 e 60 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '> 60 Dias'

from vwcxas CXA
	Join Tipo_Taxa TT on tt.cd_tp_tx=CXA.cd_Tp_Tx
	Join Tarefas_Processos TP on TP.num_proc=CXa.num_proc_hia and id_task=40
	join house_exp_out HOU on CXA.num_proc_hia = HOU.num_proc_heo
	join localidade LO on Hou.cd_org_heo = LO.cd_local

where substring(CXA.num_proc_hia,3,3) in ('STB','ROB','CSR')
			and CXA.dc_hia='C'
			and TT.nome_Tp_tx like 'Adiantamento%'
			and TP.dt_conclusao between @DataInicial and @DataFinal


UNION ALL
--IMPORTAÇÂO AEREA
select 
	CXA.Num_Proc_hia [Job],LO.nome_local [Localidade],cxa.dt_pgto_rcto_hia [Data Adiantamento],convert(varchar(10),TP.dt_conclusao,103) [Data da Prestação], 
	cast(dt_conclusao-convert(datetime,CXA.dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(TP.dt_conclusao-convert(datetime,CXA.dt_pgto_Rcto_hia,104) as int)  <= 30 Then CXA.Vlr_PGto_Rcto_hia
		Else 0
	End '30 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,cxa.dt_pgto_Rcto_hia,104) as int)  Between 31 and 60 Then cxa.Vlr_PGto_Rcto_hia
		Else 0
	End '30 e 60 Dias',
	Case 
		When cast(TP.dt_conclusao-convert(datetime,CXA.dt_pgto_Rcto_hia,104) as int) > 30 Then CXA.Vlr_PGto_Rcto_hia
		Else 0
	End '> 60 Dias'

from vwcxas CXA
	Join Tipo_Taxa TT on tt.cd_tp_tx=CXA.cd_Tp_Tx
	Join Tarefas_Processos TP on TP.num_proc=CXa.num_proc_hia and id_task=40
	join house_imp_aer HOU on CXA.num_proc_hia = HOU.num_proc_hia
	join localidade LO on Hou.cd_dst_hia = LO.cd_local

where substring(CXA.num_proc_hia,3,3) in ('STB','ROB','CSR')
			and CXA.dc_hia='C'
			and TT.nome_Tp_tx like 'Adiantamento%'
			and TP.dt_conclusao between @DataInicial and @DataFinal

UNION ALL

--IMPORTAÇÃO MARITIMA
select 
	Num_Proc_hia [Job],LO.nome_local [Localidade],cxa.dt_pgto_rcto_hia [Data Adiantamento],convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 e 60 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '> 60 Dias'

from vwcxas CXA
	Join Tipo_Taxa TT on tt.cd_tp_tx=CXA.cd_Tp_Tx
	Join Tarefas_Processos TP on TP.num_proc=CXa.num_proc_hia and id_task=40
	join house_imp_mar HOU on CXA.num_proc_hia = HOU.num_proc_him
	join localidade LO on Hou.cd_dst_him = LO.cd_local

where substring(CXA.num_proc_hia,3,3) in ('STB','ROB','CSR')
			and CXA.dc_hia='C'
			and TT.nome_Tp_tx like 'Adiantamento%'
			and TP.dt_conclusao between @DataInicial and @DataFinal

UNION ALL
-- IMPORTAÇÃO OUTROS
select 
	Num_Proc_hia [Job],LO.nome_local [Localidade],cxa.dt_pgto_rcto_hia [Data Adiantamento],convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 e 60 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '> 60 Dias'

from vwcxas CXA
	Join Tipo_Taxa TT on tt.cd_tp_tx=CXA.cd_Tp_Tx
	Join Tarefas_Processos TP on TP.num_proc=CXa.num_proc_hia and id_task=40
	join house_imp_out HOU on CXA.num_proc_hia = HOU.num_proc_hio
	join localidade LO on Hou.cd_dst_hio = LO.cd_local

where substring(CXA.num_proc_hia,3,3) in ('STB','ROB','CSR')
			and CXA.dc_hia='C'
			and TT.nome_Tp_tx like 'Adiantamento%'
			and TP.dt_conclusao between @DataInicial and @DataFinal



GO

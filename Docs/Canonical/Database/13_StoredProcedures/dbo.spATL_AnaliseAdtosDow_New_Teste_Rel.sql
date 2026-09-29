SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Tarefas_Processos where Num_Proc = 'IMCSR201503571BR' and ID_Task = 40
--select * from vwcxas where Num_Proc_HIA = 'IMCSR201503571BR'
--select * from Tipo_Taxa where nome_tp_tx like 'adiant%' Cd_Tp_Tx in ('XBA','XTH')

--[spATL_AnaliseAdtosDow_New_Rel]--'','2015-01-01','2015-12-31'   907
CREATE Procedure [dbo].[spATL_AnaliseAdtosDow_New_Teste_Rel]--'','2015-01-01','2015-12-31'
	@Grupo			Varchar(400),
	@DataInicial	Datetime,
	@DataFinal		Datetime
AS
			
--IMPORTAÇÃO MARITIMA
select 
	P.Nome_Raz_Soc				[Company Code],	
	HOU.num_proc_him			[Job],
	PO1.Numero_PO_HIM			[Ref. Cliente],
	LO.nome_local				[Localidade],
	cxa.dt_pgto_rcto_hia		[Data Adiantamento],
	convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '1 - 30 Dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 50 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 31 a 50 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 51 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 51 a 60 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Acima de 60 dias'
from house_imp_mar hou
	join Pessoa			P	with(nolock) on P.Cd_Pes = HOU.Cd_Consig_HIM
	join localidade		LO	with(nolock)on Hou.cd_dst_him = LO.cd_local
	left join PO_HIM	PO1 with(nolock) on PO1.Num_Proc_HIM = HOU.num_proc_him and PO1.id_dc=1
	join vwcxas			CXA with(nolock)on CXA.num_proc_hia = HOU.num_proc_him
	Join Tipo_Taxa		TT	with(nolock)on tt.cd_tp_tx=CXA.cd_Tp_Tx
	left Join Tarefas_Processos TP with(nolock)on TP.num_proc=HOU.num_proc_him and id_task=40
where 
	substring(HOU.num_proc_him,3,3) in ('STB','ROB','CSR')
	and CXA.dc_hia='C'
	--and TT.nome_Tp_tx like 'Adiantamento%'
	and TT.Ref_Ctb_Tx  = 'ADT'	
	--and HOU.num_proc_him = 'IMCSR201503571BR'		
	and convert(datetime,Dt_Emis_HIM,105) between @DataInicial and @DataFinal
	and TP.dt_conclusao is null
	and nome_tp_tx not like 'Devol. Adto. (Cliente)%'
	
	
UNION ALL
--IMPORTAÇÃO AEREA
select 
	P.Nome_Raz_Soc				[Company Code],	
	HOU.num_proc_hia				[Job],
	PO1.Numero_PO_HIA			[Ref. Cliente],
	LO.nome_local				[Localidade],
	cxa.dt_pgto_rcto_hia		[Data Adiantamento],
	convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '1 - 30 Dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 50 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 31 a 50 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 51 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 51 a 60 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Acima de 60 dias'
from house_imp_aer hou
	join Pessoa			P	with(nolock) on P.Cd_Pes = HOU.Cd_Consig_HIA
	join localidade		LO	with(nolock)on Hou.Cd_Dst_HIA = LO.cd_local
	left join PO_HIA	PO1 with(nolock) on PO1.Num_Proc_HIA = HOU.Num_Proc_HIA and PO1.id_dc=1
	join vwcxas			CXA with(nolock)on CXA.num_proc_hia = HOU.Num_Proc_HIA
	Join Tipo_Taxa		TT	with(nolock)on tt.cd_tp_tx=CXA.cd_Tp_Tx
	left Join Tarefas_Processos TP with(nolock)on TP.num_proc=HOU.Num_Proc_HIA and id_task=40
where 
	substring(HOU.Num_Proc_HIA,3,3) in ('STB','ROB','CSR')
	and CXA.dc_hia='C'
	--and TT.nome_Tp_tx like 'Adiantamento%'
	and TT.Ref_Ctb_Tx  = 'ADT'			
	and convert(datetime,Dt_Emis_HIA,105) between @DataInicial and @DataFinal
	and TP.dt_conclusao is null
	and nome_tp_tx not like 'Devol. Adto. (Cliente)%'

UNION ALL
	
--IMPORTAÇÃO OUTROS
select 
	P.Nome_Raz_Soc				[Company Code],	
	HOU.Num_Proc_HIO			[Job],
	PO1.Numero_PO_HIO			[Ref. Cliente],
	LO.nome_local				[Localidade],
	cxa.dt_pgto_rcto_hia		[Data Adiantamento],
	convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '1 - 30 Dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 50 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 31 a 50 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 51 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 51 a 60 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Acima de 60 dias'
from House_Imp_Out hou
	join Pessoa			P	with(nolock) on P.Cd_Pes = HOU.Cd_Consig_HIO
	join localidade		LO	with(nolock)on Hou.Cd_Dst_HIO = LO.cd_local
	left join PO_HIO	PO1 with(nolock) on PO1.Num_Proc_HIO = HOU.Num_Proc_HIO and PO1.id_dc=1
	join vwcxas			CXA with(nolock)on CXA.num_proc_hia = HOU.Num_Proc_HIO
	Join Tipo_Taxa		TT	with(nolock)on tt.cd_tp_tx=CXA.cd_Tp_Tx
	left Join Tarefas_Processos TP with(nolock)on TP.num_proc=HOU.Num_Proc_HIO and id_task=40
where 
	substring(HOU.Num_Proc_HIO,3,3) in ('STB','ROB','CSR')
	and CXA.dc_hia='C'
	--and TT.nome_Tp_tx like 'Adiantamento%'
	and TT.Ref_Ctb_Tx  = 'ADT'			
	and convert(datetime,Dt_Emis_HIO,105) between @DataInicial and @DataFinal
	and TP.dt_conclusao is null
	and nome_tp_tx not like 'Devol. Adto. (Cliente)%'
	
UNION ALL

--EXPORTAÇÃO MARITIMA
select 
	P.Nome_Raz_Soc				[Company Code],	
	HOU.Num_Proc_HEM			[Job],
	PO1.Numero_PO_HEM			[Ref. Cliente],
	LO.nome_local				[Localidade],
	cxa.dt_pgto_rcto_hia		[Data Adiantamento],
	convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '1 - 30 Dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 50 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 31 a 50 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 51 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 51 a 60 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Acima de 60 dias'
from House_Exp_Mar hou
	join Pessoa			P	with(nolock) on P.Cd_Pes = HOU.Cd_Consig_HEM
	join localidade		LO	with(nolock)on Hou.Cd_Dst_HEM = LO.cd_local
	left join PO_HEM	PO1 with(nolock) on PO1.Num_Proc_HEM = HOU.Num_Proc_HEM and PO1.id_dc=1
	join vwcxas			CXA with(nolock)on CXA.num_proc_hia = HOU.Num_Proc_HEM
	Join Tipo_Taxa		TT	with(nolock)on tt.cd_tp_tx=CXA.cd_Tp_Tx
	left Join Tarefas_Processos TP with(nolock)on TP.num_proc=HOU.Num_Proc_HEM and id_task=40
where 
	substring(HOU.Num_Proc_HEM,3,3) in ('STB','ROB','CSR')
	and CXA.dc_hia='C'
	--and TT.nome_Tp_tx like 'Adiantamento%'	
	and TT.Ref_Ctb_Tx  = 'ADT'		
	and convert(datetime,Dt_Emis_HEM,105) between @DataInicial and @DataFinal
	and TP.dt_conclusao is null
	and nome_tp_tx not like 'Devol. Adto. (Cliente)%'
	
	
UNION ALL
--EXPORTAÇÃO AEREA
select 
	P.Nome_Raz_Soc				[Company Code],	
	HOU.Num_Proc_HEA				[Job],
	PO1.Numero_PO_HEA			[Ref. Cliente],
	LO.nome_local				[Localidade],
	cxa.dt_pgto_rcto_hia		[Data Adiantamento],
	convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '1 - 30 Dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 50 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 31 a 50 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 51 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 51 a 60 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Acima de 60 dias'
from House_Exp_Aer hou
	join Pessoa			P	with(nolock) on P.Cd_Pes = HOU.Cd_Consig_HEA
	join localidade		LO	with(nolock)on Hou.Cd_Dst_HEA = LO.cd_local
	left join PO_HEA	PO1 with(nolock) on PO1.Num_Proc_HEA = HOU.Num_Proc_HEA and PO1.id_dc=1
	join vwcxas			CXA with(nolock)on CXA.num_proc_hia = HOU.Num_Proc_HEA
	Join Tipo_Taxa		TT	with(nolock)on tt.cd_tp_tx=CXA.cd_Tp_Tx
	left Join Tarefas_Processos TP with(nolock)on TP.num_proc=HOU.Num_Proc_HEA and id_task=40
where 
	substring(HOU.Num_Proc_HEA,3,3) in ('STB','ROB','CSR')
	and CXA.dc_hia='C'
	--and TT.nome_Tp_tx like 'Adiantamento%'
	and TT.Ref_Ctb_Tx  = 'ADT'			
	and convert(datetime,Dt_Emis_HEA,105) between @DataInicial and @DataFinal
	and TP.dt_conclusao is null
	and nome_tp_tx not like 'Devol. Adto. (Cliente)%'

UNION ALL
	
--IMPORTAÇÃO OUTROS
select 
	P.Nome_Raz_Soc				[Company Code],	
	HOU.Num_Proc_HEO			[Job],
	PO1.Numero_PO_HEO			[Ref. Cliente],
	LO.nome_local				[Localidade],
	cxa.dt_pgto_rcto_hia		[Data Adiantamento],
	convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '1 - 30 Dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 50 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 31 a 50 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 51 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Entre 51 a 60 dias',
	Case 
		When cast(GETDATE()-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End 'Acima de 60 dias'
from House_Exp_Out hou
	join Pessoa			P	with(nolock) on P.Cd_Pes = HOU.Cd_Consig_HEO
	join localidade		LO	with(nolock)on Hou.Cd_Dst_HEO = LO.cd_local
	left join PO_HEO	PO1 with(nolock) on PO1.Num_Proc_HEO = HOU.Num_Proc_HEO and PO1.id_dc=1
	join vwcxas			CXA with(nolock)on CXA.num_proc_hia = HOU.Num_Proc_HEO
	Join Tipo_Taxa		TT	with(nolock)on tt.cd_tp_tx=CXA.cd_Tp_Tx
	left Join Tarefas_Processos TP with(nolock)on TP.num_proc=HOU.Num_Proc_HEO and id_task=40
where 
	substring(HOU.Num_Proc_HEO,3,3) in ('STB','ROB','CSR')
	and CXA.dc_hia='C'
	--and TT.nome_Tp_tx like 'Adiantamento%'
	and TT.Ref_Ctb_Tx  = 'ADT'			
	and convert(datetime,Dt_Emis_HEO,105) between @DataInicial and @DataFinal
	and TP.dt_conclusao is null
	and nome_tp_tx not like 'Devol. Adto. (Cliente)%'
GO

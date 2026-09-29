SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spAnaliseAdtosDow_Rel 

		@Grupo			Varchar(400),
		@DataInicial	Datetime,
		@DataFinal		Datetime,
		@Tipo			Char(1)
AS

select 
	Num_Proc_hia [Job],cxa.dt_pgto_rcto_hia [Data Adiantamento],convert(varchar(10),dt_conclusao,103) [Data da Prestação], 
	cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) [Total Dias] ,
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  <= 30 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 31 and 40 Then Vlr_PGto_Rcto_hia
		Else 0
	End '30 e 40 Dias',
	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int)  Between 41 and 60 Then Vlr_PGto_Rcto_hia
		Else 0
	End '41 e 60 Dias',

	Case 
		When cast(dt_conclusao-convert(datetime,dt_pgto_Rcto_hia,104) as int) > 60Then Vlr_PGto_Rcto_hia
		Else 0
	End '> 60 Dias'



from vwcxas CXA
	Join Tipo_Taxa TT on tt.cd_tp_tx=CXA.cd_Tp_Tx
	Join Tarefas_Processos TP on TP.num_proc=CXa.num_proc_hia and id_task=40

where substring(num_proc_hia,3,3) in ('STB','ROB','CSR')
			and dc_hia='C'
			and nome_Tp_tx like 'Adiantamento%'
			and dt_conclusao between @DataInicial and @DataFinal
GO

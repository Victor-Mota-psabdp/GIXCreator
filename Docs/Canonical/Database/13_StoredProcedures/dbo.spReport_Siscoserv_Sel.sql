SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [dbo].[spReport_Siscoserv_Sel] --[spReport_Siscoserv_sel] '2015-10-17', '2016-10-17'

	@DtInicial datetime,
	@DtFinal datetime
				
AS

select
distinct
		Nome_BDP_Produto[BDP Product],
		HOU.Num_Proc	[BDP Ref.],
		LO.Nome_Local	[Origin],
		LD.Nome_Local	[Destination],
		Master			[Consol Ref.],
		SH.Nome_Raz_Soc	[Shipper],
		CO.Nome_Raz_Soc	[Consignee],
		PG.Apelido		[Group Name],
		MAWB			[Master],
		HAWB			[House],
		ETD				[ETD Date],
		ATD				[ATD Date],
		ETA				[ETA Date],
		ATA				[ATA Date],
		Cd_Tp_Oper		[Icoterm],
		Tipo_Frete		[Freight Type],
		Case when DC178.Id_DC='178' then 'YES' else 'NO' End  [PDF - Master],
		Case when DC20.Id_DC='20' then 'YES' else 'NO' End  [PDF - House],
		Case when DC181.Id_DC='181' then 'YES' else 'NO' End  [PDF - Debit Note],
		Case when DC180.Id_DC='180' then 'YES' else 'NO' End  [PDF - Credit Note],
		Case when DC179.Id_DC='179' then 'YES' else 'NO' End  [PDF - NF Profit],
		TP182.Dt_Conclusao  [Data de Envio],
		TP185.Dt_Conclusao  [Siscoserv 2013/2015],
		TP192.Dt_Conclusao [Embarque com Prejuízo],
		TP193.Dt_Conclusao [Embarque sem Profit],
		CSR.Nome_Usuario		[CSR NAME],
		HC.HSDDescricao [Last Historic]
		--[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc)	[Last Historic]
	from vwHouse_Imp HOU with(nolock)
		Join Localidade LO					with(nolock) on LO.cd_local = HOU.Cd_Org
		Join Localidade LD					with(nolock) on LD.cd_local = HOU.Cd_Dst
		Left Join Doc_Anexos DC20		with(nolock) on HOU.Num_Proc = DC20.Num_Proc and DC20.Id_DC = '20'
		Left Join Doc_Anexos DC178		with(nolock) on HOU.Num_Proc = DC178.Num_Proc and DC178.Id_DC = '178'
		Left Join Doc_Anexos DC179		with(nolock) on HOU.Num_Proc = DC179.Num_Proc and DC179.Id_DC = '179'
		Left Join Doc_Anexos DC180		with(nolock) on HOU.Num_Proc = DC180.Num_Proc and DC180.Id_DC = '180'
		Left Join Doc_Anexos DC181		with(nolock) on HOU.Num_Proc = DC181.Num_Proc and DC181.Id_DC = '181'
		Left Join Tarefas_Processos TP182 with(nolock) on HOU.Num_Proc = TP182.Num_Proc and TP182.ID_Task = '182'
		Left Join Tarefas_Processos TP185 with(nolock) on HOU.Num_Proc = TP185.Num_Proc and TP185.ID_Task = '185'
		Left Join Tarefas_Processos TP192 with(nolock) on HOU.Num_Proc = TP192.Num_Proc and TP192.ID_Task = '192'
		Left Join Tarefas_Processos TP193 with(nolock) on HOU.Num_Proc = TP193.Num_Proc and TP193.ID_Task = '193'
		Left Join Campo_Processo CP		with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '143'
		Left Join BDP_Produto PRO			with(nolock) on CP.Campo_Dados = PRO.ID_PD
		Left Join Pessoa SH				with(nolock) on HOU.cd_export = SH.cd_pes
		Left Join Pessoa CO				with(nolock) on HOU.Cd_Consig = CO.cd_pes
		Left Join Pessoa_LLP PLL			with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
		Left Join Grupo G					with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		Left Join pessoa	PG				with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
		Left Join Usuario CSR				with(nolock)on HOU.Cd_Usuario	= CSR.Cd_Usuario
		left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=HOU.Num_Proc
	where 
		isnull(HOU.ID_Status,1) <> 9 
		and convert(Datetime,HOU.ETD,105) between @DtInicial and @DtFinal
		and CP.Campo_Dados <> '1'
		and left(HOU.Num_Proc,2) <> ('IO')
		 

Union All

	select
	distinct
		Nome_BDP_Produto[BDP Product],
		HOU.Num_Proc	[BDP Ref.],
		LO.Nome_Local	[Origin],
		LD.Nome_Local	[Destination],
		Master			[Consol Ref.],
		SH.Nome_Raz_Soc	[Shipper],
		CO.Nome_Raz_Soc	[Consignee],
		PG.Apelido		[Group Name],
		MAWB			[Master],
		HAWB			[House],
		ETD				[ETD Date],
		ATD				[ATD Date],
		ETA				[ETA Date],
		ATA				[ATA Date],
		Cd_Tp_Oper [Icoterm],
		Tipo_Frete [Freight Type],
		Case when DC178.Id_DC='178' then 'YES' else 'NO' End  [PDF - Master],
		Case when DC20.Id_DC='20' then 'YES' else 'NO' End  [PDF - House],
		Case when DC181.Id_DC='181' then 'YES' else 'NO' End  [PDF - Debit Note],
		Case when DC180.Id_DC='180' then 'YES' else 'NO' End  [PDF - Credit Note],
		Case when DC179.Id_DC='179' then 'YES' else 'NO' End  [PDF - NF Profit],
		TP182.Dt_Conclusao  [Data de Envio],
		TP185.Dt_Conclusao  [Siscoserv 2013/2015],
		TP192.Dt_Conclusao [Embarque com Prejuízo],
		TP193.Dt_Conclusao [Embarque sem Profit],
		CSR.Nome_Usuario [CSR NAME],
		--[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc)	[Last Historic]
		HC.HSDDescricao [Last Historic]
	from vwHouse_Exp HOU with(nolock)
		Join Localidade LO					with(nolock) on LO.cd_local = HOU.Cd_Org
		Join Localidade LD					with(nolock) on LD.cd_local = HOU.Cd_Dst
		Left Join Doc_Anexos DC20		with(nolock) on HOU.Num_Proc = DC20.Num_Proc and DC20.Id_DC = '20'
		Left Join Doc_Anexos DC178		with(nolock) on HOU.Num_Proc = DC178.Num_Proc and DC178.Id_DC = '178'
		Left Join Doc_Anexos DC179		with(nolock) on HOU.Num_Proc = DC179.Num_Proc and DC179.Id_DC = '179'
		Left Join Doc_Anexos DC180		with(nolock) on HOU.Num_Proc = DC180.Num_Proc and DC180.Id_DC = '180'
		Left Join Doc_Anexos DC181		with(nolock) on HOU.Num_Proc = DC181.Num_Proc and DC181.Id_DC = '181'
		Left Join Tarefas_Processos TP182 with(nolock) on HOU.Num_Proc = TP182.Num_Proc and TP182.ID_Task = '182'
		Left Join Tarefas_Processos TP185 with(nolock) on HOU.Num_Proc = TP185.Num_Proc and TP185.ID_Task = '185'
		Left Join Tarefas_Processos TP192 with(nolock) on HOU.Num_Proc = TP192.Num_Proc and TP192.ID_Task = '192'
		Left Join Tarefas_Processos TP193 with(nolock) on HOU.Num_Proc = TP193.Num_Proc and TP193.ID_Task = '193'
		Left Join Campo_Processo CP		with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '143'
		Left Join BDP_Produto PRO			with(nolock) on CP.Campo_Dados = PRO.ID_PD
		Left Join Pessoa SH				with(nolock) on HOU.cd_export = SH.cd_pes
		Left Join Pessoa_LLP PLL			with(nolock) on PLL.Cd_Pes=HOU.cd_export
		Left Join Grupo G					with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		Left Join pessoa	PG				with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
		Left Join Pessoa CO				with(nolock) on HOU.Cd_Consig = CO.cd_pes
		Left Join Usuario CSR				with(nolock) on HOU.Cd_Usuario	= CSR.Cd_Usuario
		left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=HOU.Num_Proc
	where 
		isnull(HOU.ID_Status,1) <> 9 
		and convert(Datetime,HOU.ETD,105)  between @DtInicial and @DtFinal
		and CP.Campo_Dados <> '1'
		and left(HOU.Num_Proc,2) <> ('EO')

OPTION (HASH JOIN)
	/*Old
	select
		HOU.Num_Proc	[BDP Ref.],
		Master			[Consol Ref.],
		SH.Nome_Raz_Soc	[Shipper],
		CO.Nome_Raz_Soc	[Consignee],
		PG.Apelido		[Group Name],
		MAWB			[Master],
		HAWB			[House],
		ETD				[ETD Date],
		ATD				[ATD Date],
		ETA				[ETA Date],
		ATA				[ATA Date],
		Cd_Tp_Oper		[Icoterm],
		Tipo_Frete		[Freight Type],
		Case when DC178.Id_DC='178' then 'YES' else 'NO' End  [PDF - Master],
		Case when DC20.Id_DC='20' then 'YES' else 'NO' End  [PDF - House],
		Case when DC181.Id_DC='181' then 'YES' else 'NO' End  [PDF - Debit Note],
		Case when DC180.Id_DC='180' then 'YES' else 'NO' End  [PDF - Credit Note],
		Case when DC179.Id_DC='179' then 'YES' else 'NO' End  [PDF - NF Profit],
		TP182.Dt_Conclusao  [Data de Envio],
		TP185.Dt_Conclusao  [Siscoserv 2013/2015],
		CSR.Nome_Usuario		[CSR NAME],
		[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc)	[Last Historic]
	from vwHouse_Imp HOU
		Left Outer Join Doc_Anexos DC20			with(nolock) on HOU.Num_Proc = DC20.Num_Proc and DC20.Id_DC = '20'
		Left Outer Join Doc_Anexos DC178		with(nolock) on HOU.Num_Proc = DC178.Num_Proc and DC178.Id_DC = '178'
		Left Outer Join Doc_Anexos DC179		with(nolock) on HOU.Num_Proc = DC179.Num_Proc and DC179.Id_DC = '179'
		Left Outer Join Doc_Anexos DC180		with(nolock) on HOU.Num_Proc = DC180.Num_Proc and DC180.Id_DC = '180'
		Left Outer Join Doc_Anexos DC181		with(nolock) on HOU.Num_Proc = DC181.Num_Proc and DC181.Id_DC = '181'
		Left Outer Join Tarefas_Processos TP182 with(nolock) on HOU.Num_Proc = TP182.Num_Proc and TP182.ID_Task = '182'
		Left Outer Join Tarefas_Processos TP185 with(nolock) on HOU.Num_Proc = TP185.Num_Proc and TP185.ID_Task = '185'
		Left Outer Join Campo_Processo CP		with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '143'
		Left Outer Join Pessoa SH				with(nolock) on HOU.cd_export = SH.cd_pes
		Left Outer Join Pessoa CO				with(nolock) on HOU.Cd_Consig = CO.cd_pes
		Left Outer Join Pessoa_LLP PLL			with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
		Left Outer Join Grupo G					with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		Left Outer Join pessoa	PG				with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
		Left Outer Join Usuario CSR				with(nolock)on HOU.Cd_Usuario	= CSR.Cd_Usuario
	where HOU.ID_Status <> 9 
		  and convert(Datetime,HOU.ETD,105) between @DtInicial and @DtFinal
		  and CP.Campo_Dados <> '1'
		  and left(HOU.Num_Proc,2) <> ('IO')
		 

Union All

	select
		HOU.Num_Proc	[BDP Ref.],
		Master			[Consol Ref.],
		SH.Nome_Raz_Soc	[Shipper],
		CO.Nome_Raz_Soc	[Consignee],
		PG.Apelido		[Group Name],
		MAWB			[Master],
		HAWB			[House],
		ETD				[ETD Date],
		ATD				[ATD Date],
		ETA				[ETA Date],
		ATA				[ATA Date],
		Cd_Tp_Oper [Icoterm],
		Tipo_Frete [Freight Type],
		Case when DC178.Id_DC='178' then 'YES' else 'NO' End  [PDF - Master],
		Case when DC20.Id_DC='20' then 'YES' else 'NO' End  [PDF - House],
		Case when DC181.Id_DC='181' then 'YES' else 'NO' End  [PDF - Debit Note],
		Case when DC180.Id_DC='180' then 'YES' else 'NO' End  [PDF - Credit Note],
		Case when DC179.Id_DC='179' then 'YES' else 'NO' End  [PDF - NF Profit],
		TP182.Dt_Conclusao  [Data de Envio],
		TP185.Dt_Conclusao  [Siscoserv 2013/2015],
		CSR.Nome_Usuario [CSR NAME],
		[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc)	[Last Historic]

	from vwHouse_Exp HOU
		Left Outer Join Doc_Anexos DC20			with(nolock) on HOU.Num_Proc = DC20.Num_Proc and DC20.Id_DC = '20'
		Left Outer Join Doc_Anexos DC178		with(nolock) on HOU.Num_Proc = DC178.Num_Proc and DC178.Id_DC = '178'
		Left Outer Join Doc_Anexos DC179		with(nolock) on HOU.Num_Proc = DC179.Num_Proc and DC179.Id_DC = '179'
		Left Outer Join Doc_Anexos DC180		with(nolock) on HOU.Num_Proc = DC180.Num_Proc and DC180.Id_DC = '180'
		Left Outer Join Doc_Anexos DC181		with(nolock) on HOU.Num_Proc = DC181.Num_Proc and DC181.Id_DC = '181'
		Left Outer Join Tarefas_Processos TP182 with(nolock) on HOU.Num_Proc = TP182.Num_Proc and TP182.ID_Task = '182'
		Left Outer Join Tarefas_Processos TP185 with(nolock) on HOU.Num_Proc = TP185.Num_Proc and TP185.ID_Task = '185'
		Left Outer Join Campo_Processo CP		with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '143'
		Left Outer Join Pessoa SH				with(nolock) on HOU.cd_export = SH.cd_pes
		Left Outer Join Pessoa_LLP PLL			with(nolock) on PLL.Cd_Pes=HOU.cd_export
		Left Outer Join Grupo G					with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		Left Outer Join pessoa	PG				with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
		Left Outer Join Pessoa CO				with(nolock) on HOU.Cd_Consig = CO.cd_pes
		Left Outer Join Usuario CSR				with(nolock) on HOU.Cd_Usuario	= CSR.Cd_Usuario
	where HOU.ID_Status <> 9 
		  and convert(Datetime,HOU.ETD,105)  between @DtInicial and @DtFinal
		  and CP.Campo_Dados <> '1'
		  and left(HOU.Num_Proc,2) <> ('EO')
		  */		  
		  
		  /*Old
		  select
HOU.Num_Proc [BDP Ref.],
Master [Consol Ref.],
MAWB [Master],
HAWB [House],
ATD [ATD Date],
ATA [ATA Date],
Cd_Tp_Oper [Icoterm],
Tipo_Frete [Freight Type],
Case when DC178.Id_DC='178' then 'YES' else 'NO' End  [PDF - Master],
Case when DC20.Id_DC='20' then 'YES' else 'NO' End  [PDF - House],
Case when DC181.Id_DC='181' then 'YES' else 'NO' End  [PDF - Debit Note],
Case when DC180.Id_DC='180' then 'YES' else 'NO' End  [PDF - Credit Note],
Case when DC179.Id_DC='179' then 'YES' else 'NO' End  [PDF - NF Profit],
TP.Dt_Conclusao  [Data de Envio],
[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc)	[Last Historic]

from vwHouse_Imp HOU
Left Outer Join Doc_Anexos DC20	with(nolock) on HOU.Num_Proc = DC20.Num_Proc and DC20.Id_DC = '20'
Left Outer Join Doc_Anexos DC178	 with(nolock) on HOU.Num_Proc = DC178.Num_Proc and DC178.Id_DC = '178'
Left Outer Join Doc_Anexos DC179	 with(nolock) on HOU.Num_Proc = DC179.Num_Proc and DC179.Id_DC = '179'
Left Outer Join Doc_Anexos DC180	 with(nolock) on HOU.Num_Proc = DC180.Num_Proc and DC180.Id_DC = '180'
Left Outer Join Doc_Anexos DC181	 with(nolock) on HOU.Num_Proc = DC181.Num_Proc and DC181.Id_DC = '181'
Left Outer Join Tarefas_Processos TP with(nolock) on HOU.Num_Proc = TP.Num_Proc and TP.ID_Task = '182'
Left Outer Join Campo_Processo CP	 with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '143'
where HOU.ID_Status <> 9 
	  and convert(Datetime,HOU.dt_emis,105)  between @DtInicial and @DtFinal
	  and CP.Campo_Dados <> '1'

Union All

select
HOU.Num_Proc [BDP Ref.],
Master [Consol Ref.],
MAWB [Master],
HAWB [House],
ATD [ATD Date],
ATA [ATA Date],
Cd_Tp_Oper [Icoterm],
Tipo_Frete [Freight Type],
Case when DC178.Id_DC='178' then 'YES' else 'NO' End  [PDF - Master],
Case when DC20.Id_DC='20' then 'YES' else 'NO' End  [PDF - House],
Case when DC181.Id_DC='181' then 'YES' else 'NO' End  [PDF - Debit Note],
Case when DC180.Id_DC='180' then 'YES' else 'NO' End  [PDF - Credit Note],
Case when DC179.Id_DC='179' then 'YES' else 'NO' End  [PDF - NF Profit],
TP.Dt_Conclusao  [Data de Envio],
[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc)	[Last Historic]

from vwHouse_Exp HOU
Left Outer Join Doc_Anexos DC20	with(nolock) on HOU.Num_Proc = DC20.Num_Proc and DC20.Id_DC = '20'
Left Outer Join Doc_Anexos DC178	 with(nolock) on HOU.Num_Proc = DC178.Num_Proc and DC178.Id_DC = '178'
Left Outer Join Doc_Anexos DC179	 with(nolock) on HOU.Num_Proc = DC179.Num_Proc and DC179.Id_DC = '179'
Left Outer Join Doc_Anexos DC180	 with(nolock) on HOU.Num_Proc = DC180.Num_Proc and DC180.Id_DC = '180'
Left Outer Join Doc_Anexos DC181	 with(nolock) on HOU.Num_Proc = DC181.Num_Proc and DC181.Id_DC = '181'
Left Outer Join Tarefas_Processos TP with(nolock) on HOU.Num_Proc = TP.Num_Proc and TP.ID_Task = '182'
Left Outer Join Campo_Processo CP	 with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '143'
where HOU.ID_Status <> 9 
	  and convert(Datetime,HOU.dt_emis,105)  between @DtInicial and @DtFinal
	  and CP.Campo_Dados <> '1'
	  */
GO

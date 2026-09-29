SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Tracking_EMIX_Rel]	--'2015-05-28'
	@DtInicial datetime
As

	Declare @Grupo varchar(20)
	set @Grupo = '%'

	select		
		LLP.Num_Proc_LIM		[BDP Ref.],		
		PG.Apelido				[Group Name],
		CSN.Apelido				[Consignee],
		CSN.Num_CPF_CNPJ		[CNPJ],
		DST.Nome_Local			[Destination],
		P5.data_po_him			[Customs Transmission Date],		
		P5.numero_po_him		[Entry Number],
		(case when D5.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - DI],
			
		(case when D6.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - CI],
		T4.Dt_Conclusao			[Data do Desembaraco],
		LLp.Canal_Lim			[Canal]
	from
		LLP_Imp_Mar LLP with(nolock)
		Join House_Imp_Mar HOU with(nolock) on LLP.num_proc_LIm=HOU.Num_Proc_HIM
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo		
		join Pessoa CSN with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIM	
		left Join Localidade DST with(nolock) on HOU.cd_dst_HIM=DST.cd_local		
		Left Join PO_HIM P5 with(nolock) on P5.Num_Proc_Him=HOU.num_proc_hiM and P5.ID_DC=5
		Left Join Doc_anexos D5 with(nolock) on D5.Num_Proc=HOU.num_proc_hiM and D5.ID_DC=5	
		Left Join Doc_anexos D6 with(nolock) on D6.Num_Proc=HOU.num_proc_hiM and D6.ID_DC=6	
		Left Join Tarefas_Processos T4  with(nolock) on LLP.Num_Proc_Lim= T4.num_proc and  T4.id_task=4
	where
		P5.data_po_him	>= @DtInicial	
	
	
	
UNION all

	select
		LLP.Num_Proc_LIA		[BDP Ref.],		
		PG.Apelido				[Group Name],
		CSN.Apelido				[Consignee],
		CSN.Num_CPF_CNPJ		[CNPJ],
		DST.Nome_Local			[Destination],
		P5.data_po_hia			[Customs Transmission Date],		
		P5.numero_po_hia		[Entry Number],
		(case when D5.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - DI],
			
		(case when D6.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - CI],
		T4.Dt_Conclusao			[Data do Desembaraco],
		LLp.Canal_LIA			[Canal]
	from
		llp_imp_aer LLP with(nolock)
		Join House_Imp_aer HOU with(nolock) on LLP.num_proc_LIA=HOU.num_proc_HIA
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIA
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo		
		join Pessoa CSN with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIA	
		left Join Localidade DST with(nolock) on HOU.cd_dst_HIA=DST.cd_local		
		Left Join PO_HIA P5 with(nolock) on P5.Num_Proc_Hia=HOU.num_proc_hia and P5.ID_DC=5		
		Left Join Doc_anexos D5 with(nolock) on D5.Num_Proc=HOU.num_proc_hia and D5.ID_DC=5	
		Left Join Doc_anexos D6 with(nolock) on D6.Num_Proc=HOU.num_proc_hia and D6.ID_DC=6
		Left Join Tarefas_Processos T4  with(nolock) on LLP.num_proc_lia= T4.num_proc and  T4.id_task=4		
	where
		P5.data_po_hia	>= @DtInicial
		
UNION ALL

	select
		LLP.Num_Proc_LIO		[BDP Ref.],		
		PG.Apelido				[Group Name],
		CSN.Apelido				[Consignee],
		CSN.Num_CPF_CNPJ		[CNPJ],
		DST.Nome_Local			[Destination],
		P5.data_po_hio			[Customs Transmission Date],		
		P5.numero_po_hio		[Entry Number],
		(case when D5.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - DI],
			
		(case when D6.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - CI],
		T4.Dt_Conclusao			[Data do Desembaraco],
		LLp.Canal_Lio			[Canal]
	from
		LLP_Imp_Out LLP with(nolock)
		Join House_Imp_out HOU with(nolock) on LLP.num_proc_LIO=HOU.num_proc_HIO
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo		
		join Pessoa CSN with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIO	
		left Join Localidade DST with(nolock) on HOU.cd_dst_HIO=DST.cd_local		
		Left Join PO_HIO P5 with(nolock) on P5.Num_Proc_HiO=HOU.num_proc_hiO and P5.ID_DC=5		
		Left Join Doc_anexos D5 with(nolock) on D5.Num_Proc=HOU.num_proc_hio and D5.ID_DC=5	
		Left Join Doc_anexos D6 with(nolock) on D6.Num_Proc=HOU.num_proc_hio and D6.ID_DC=6
		Left Join Tarefas_Processos T4  with(nolock) on LLP.num_proc_lio= T4.num_proc and  T4.id_task=4	
	where
		P5.Data_PO_HIO	>= @DtInicial 
		
	order by [Customs Transmission Date] desc
OPTION(HASH JOIN)
GO

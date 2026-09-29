SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help vwCta_Cte
CREATE procedure [dbo].[spATL_vwCta_Cte_Sel](
	@Num_Proc			varChar(16),
	@Cd_Tp_Tx			varChar(3),
	@DC_HIA				varChar(1),
	@Num_NF_HIA			Int,
	@Ref_Acesso_NF_HIA	varChar(1),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'  or @Tipo = 'B'
	Begin
		select 
			CC.Num_Proc_HIA			[JOB],
			CC.Cd_Cred_Dev_HIA		[Creditor/Debitor Code],
			CLI.Apelido				[Creditor/Debitor Name],	
			CC.Cd_Tp_Tx				[Charge Code],
			TT.Nome_Tp_Tx			[Charge Name],			
			CC.DC_HIA				[DC Code],
			TD.Descricao_TP_DC		[DC Name],	
			Dt_Ins_HIA				[Register Date],			
			CC.Cd_Tp_Moeda			[Currency Code],
			TM.Nome_Tp_Moeda		[Currency Name],			
			CC.Vlr_Org_HIA			[Value],		
			
			CC.Desp_Org_HIA			[Desp_Org],	
			CC.Num_NF_HIA			[Nota Fiscal Number],	
			CC.Val_Con_Comp			[Value Con_Comp],
			CC.Ref_Acesso_NF_HIA	[Site Code],
			SI.Nome_Site			[Site Name],
			
			CC.Vlr_Pgto_NF_HIA		[Payment Value],
			CC.Par_NF_HIA			[Exchange Rate],
			CC.dt_prev_pgto_hia		[Due Date],
			CC.IC					[IC]
		from 
			vwCta_Cte CC with(nolock)
			left join Pessoa CLI with(nolock) on CLI.Cd_Pes = CC.Cd_Cred_Dev_HIA
			left join Tipo_Taxa TT with(nolock) on TT.Cd_tp_tx = CC.Cd_Tp_Tx
			left join Tipo_DC TD with(nolock) on TD.Cd_Tp_DC = CC.DC_HIA
			left join Tipo_Moeda TM with(nolock) on TM.Cd_Tp_Moeda = CC.Cd_Tp_Moeda
			left join Site SI with(nolock) on SI.Cd_Site = CC.Ref_Acesso_NF_HIA
		Where
			CC.Num_Proc_HIA = @Num_Proc	

	End

if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			CC.Num_Proc_HIA			[JOB],
			CC.Cd_Cred_Dev_HIA		[Creditor/Debitor Code],
			CLI.Apelido				[Creditor/Debitor Name],	
			CC.Cd_Tp_Tx				[Charge Code],
			TT.Nome_Tp_Tx			[Charge Name],			
			CC.DC_HIA				[DC Code],
			TD.Descricao_TP_DC		[DC Name],	
			Dt_Ins_HIA				[Register Date],			
			CC.Cd_Tp_Moeda			[Currency Code],
			TM.Nome_Tp_Moeda		[Currency Name],			
			CC.Vlr_Org_HIA			[Value],		
			
			CC.Desp_Org_HIA			[Desp_Org],	
			CC.Num_NF_HIA			[Nota Fiscal Number],	
			CC.Val_Con_Comp			[Value Con_Comp],
			CC.Ref_Acesso_NF_HIA	[Site Code],
			SI.Nome_Site			[Site Name],
			
			CC.Vlr_Pgto_NF_HIA		[Payment Value],
			CC.Par_NF_HIA			[Exchange Rate],
			CC.dt_prev_pgto_hia		[Due Date],
			CC.IC					[IC]
		from 
			vwCta_Cte CC with(nolock)
			left join Pessoa CLI with(nolock) on CLI.Cd_Pes = CC.Cd_Cred_Dev_HIA
			left join Tipo_Taxa TT with(nolock) on TT.Cd_tp_tx = CC.Cd_Tp_Tx
			left join Tipo_DC TD with(nolock) on TD.Cd_Tp_DC = CC.DC_HIA
			left join Tipo_Moeda TM with(nolock) on TM.Cd_Tp_Moeda = CC.Cd_Tp_Moeda
			left join Site SI with(nolock) on SI.Cd_Site = CC.Ref_Acesso_NF_HIA
		where
			CC.Num_Proc_HIA = @Num_proc and
			CC.Cd_Tp_Tx =@Cd_Tp_Tx  and 
			CC.DC_HIA =@DC_HIA
	End



if @Tipo = 'X'
	Begin
		select distinct
			CC.Num_Proc_HIA			[JOB],
			--CC.Cd_Cred_Dev_HIA		[Creditor/Debitor Code],
			--CLI.Apelido				[Creditor/Debitor Name],	
			--CC.Cd_Tp_Tx				[Charge Code],
			--TT.Nome_Tp_Tx			[Charge Name],			
			--CC.DC_HIA				[DC Code],
			--TD.Descricao_TP_DC		[DC Name],	
			--Dt_Ins_HIA				[Register Date],			
			--CC.Cd_Tp_Moeda			[Currency Code],
			--TM.Nome_Tp_Moeda		[Currency Name],			
			--CC.Vlr_Org_HIA			[Value],		
			
			--CC.Desp_Org_HIA			[Desp_Org],	
			CC.Num_NF_HIA			[Nota Fiscal Number],	
			--CC.Val_Con_Comp			[Value Con_Comp],
			CC.Ref_Acesso_NF_HIA	[Site Code],
			SI.Nome_Site			[Site Name]
			
			--CC.Vlr_Pgto_NF_HIA		[Payment Value],
			--CC.Par_NF_HIA			[Exchange Rate],
			--CC.dt_prev_pgto_hia		[Due Date],
			--CC.IC					[IC]
			
			
		from 
			vwCta_Cte CC with(nolock)
			left join Pessoa CLI with(nolock) on CLI.Cd_Pes = CC.Cd_Cred_Dev_HIA
			left join Tipo_Taxa TT with(nolock) on TT.Cd_tp_tx = CC.Cd_Tp_Tx
			left join Tipo_DC TD with(nolock) on TD.Cd_Tp_DC = CC.DC_HIA
			left join Tipo_Moeda TM with(nolock) on TM.Cd_Tp_Moeda = CC.Cd_Tp_Moeda
			left join Site SI with(nolock) on SI.Cd_Site = CC.Ref_Acesso_NF_HIA
			--left join Doc_Anexos DOC 	with(nolock) on DOC.Num_Proc = CC.Num_Proc_HIA and DOC.Id_DC = '147'
		where
			CC.Num_NF_HIA = @Num_NF_HIA and
			CC.Ref_Acesso_NF_HIA=@Ref_Acesso_NF_HIA
			--and DOC.Item_Doc is null
	End		

GO

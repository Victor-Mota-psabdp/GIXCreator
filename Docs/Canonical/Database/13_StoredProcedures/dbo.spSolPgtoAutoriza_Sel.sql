SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Sol_Pgto_Cta_Cte  where id = '8012036'
--select * from Registro_Financeiro
--[spSolPgtoAutoriza_Sel]'8000007'
CREATE procedure [dbo].[spSolPgtoAutoriza_Sel]--'8024557'
(
	@ID bigint
)
as

select 
	SLI.Num_Proc,
	SLI.Cd_Tp_Tx,
	SLI.DC,
	'Solicitacao' Org_Ins,
	convert(char(10),GETDATE(),103)Dt_Ins,
	'REL' Cd_Tp_Moeda,
	Vlr_Pgto_Rcto Vlr_Org,
	--convert(char(10),Dt_Pgto_Rcto,103) Dt_Prev_Pgto, o siberio flw q tem q ser o due date
	convert(char(10),Dt_Vcto,103) Dt_Prev_Pgto,
	Cd_Cred_Dev,
	'N' Desp_Org,
	'N' CPMF,
	'S' Comp_RP,
	'N' Comp_DN,
	'N'	Comp_CN,
	'N' Comp_CPA,
	NULL Num_DCN,
	NULL Dt_Ctb_CC,
	NULL Num_NF,
	NULL Ref_Acesso_NF,
	NULL Vlr_Pgto_NF,
	NULL Par_NF,
	'N' Comp_Job,
	0 Contab,
	NULL Vlr_Contab,
	0 Contab_Ant,
	NULL Vlr_Contab_Ant,
	NULL Contab_Mes_Ano,
	NULL Val_Con_Comp,
	
	--Doc Register-Novos Campos
	TT.Nome_Tp_Tx Taxa,
	P.apelido Cliente,
	P.Num_CPF_CNPJ RUT,
	Doc_Register,
	Mes,
	Ano,
	Num_Registro,
	Dt_IssueDate,
	Cd_Tipo_Lanc,
	Isento,
	SL.Cd_Tp_Moeda ,
	'REAL' Moeda,
	SL.Par_Moeda,
	Cd_Regra,
	Cd_Tp_Fatura,
	Cd_Tp_Doc_RF,
	Doc_Number,
	Total,
	IVA_Retencoes,
	Total_Doc,
	Cd_Pes_Seguro,
	NUM_CNPJ_Seguro,
	Valor_Total_Moeda_Local,
	Habilita_Impostos,
	Ref_Acesso,
	cd_servico,
	Item_lei,
	right('000' + convert(varchar(10),SLI.ID_Item),3) ID_Item
from 
	Sol_Pgto_Cta_Cte SL with(nolock)
join Sol_Pgto_Cta_Cte_Item  SLI with(nolock) on SL.ID = SLI.ID
join Pessoa P with(nolock) on P.Cd_Pes = SL.Cd_Cred_Dev
join Tipo_Taxa TT with(nolock) on TT.Cd_Tp_Tx = SLI.Cd_Tp_Tx
where 
	SL.ID = @ID	
order by right('000' + convert(varchar(10),SLI.ID_Item),3)
GO

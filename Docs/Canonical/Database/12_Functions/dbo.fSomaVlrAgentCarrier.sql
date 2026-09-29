SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from cta_cte_HOU_exp_aer where num_proc_hea = 'EACSR20110100301'
--select * from caixa_hou_imp_aer
--select [dbo].[fSomaVlrAgentCarrier] ('EACSR20110100301')


CREATE function [dbo].[fSomaVlrAgentCarrier] --'EACSR20110100301'
(
	@num_proc as Varchar(16)
)

RETURNS float

BEGIN

	Declare @Saida float

	Set @Saida= IsNull((select sum(Vlr_Org_HEA) from cta_cte_HOU_exp_aer where Num_Proc_HEA=@num_proc and Comp_JOB_HEA = 'A'),0)

	Set @Saida=@Saida+IsNull((select sum(Vlr_Org_HEA) from cta_cte_HOU_exp_aer where Num_Proc_HEA=@num_proc and Comp_JOB_HEA = 'C'),0)

	Return @Saida

ENd













GO

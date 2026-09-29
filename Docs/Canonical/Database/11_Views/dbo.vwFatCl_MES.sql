SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View vwFatCl_MES

AS


select 
	Nome_Raz_Soc Cliente, nome_tp_tx, 
	dbo.valor(vlr_pgto_nf_mea,cta.dc_mea) Valor_NF 
from 
	cta_cte_MAS_exp_aer CTA
	Join Base_Nota_fiscal NF on CTA.num_nf_mea=nota_fiscal and CTA.Ref_Acesso_NF_meA=Ref_acesso
	Join Tipo_Taxa TT on TT.cd_Tp_Tx=CTA.cd_tp_tx
	Join House_exp_Aer HOU on HOU.num_proc_mea=CTA.num_proc_mea
	Join Pessoa PP on PP.cd_pes=cd_Export_hea
Where
	Emissao between '01-01-2006' and '01-31-2006'

UNION ALL

select  
	Nome_Raz_Soc, nome_tp_tx, dbo.valor(vlr_pgto_nf_hia,cta.dc_hia) Valor_NF 
from 
	cta_cte_hou_imp_aer CTA
	Join Base_Nota_fiscal NF on CTA.num_nf_hia=nota_fiscal and CTA.Ref_Acesso_NF_HiA=Ref_acesso
	Join Tipo_Taxa TT on TT.cd_Tp_Tx=CTA.cd_tp_tx
	Join House_imp_Aer HOU on HOU.num_proc_hia=CTA.num_proc_hia
	Join Pessoa PP on PP.cd_pes=cd_import_hia
Where
	Emissao between '01-01-2006' and '01-31-2006'


UNION ALL


select  
	Nome_Raz_Soc, nome_tp_tx, dbo.valor(vlr_pgto_nf_him,cta.dc_him) Valor_NF 
from 
	cta_cte_hou_imp_mar CTA
	Join Base_Nota_fiscal NF on CTA.num_nf_him=nota_fiscal and CTA.Ref_Acesso_NF_Him=Ref_acesso
	Join Tipo_Taxa TT on TT.cd_Tp_Tx=CTA.cd_tp_tx
	Join House_imp_mar HOU on HOU.num_proc_him=CTA.num_proc_him
	Join Pessoa PP on PP.cd_pes=cd_import_him
Where
	Emissao between '01-01-2006' and '01-31-2006'


UNION ALL

select  
	Nome_Raz_Soc, nome_tp_tx, dbo.valor(vlr_pgto_nf_hEm,cta.dc_hem) Valor_NF 
from 
	cta_cte_hou_exp_mar CTA
	Join Base_Nota_fiscal NF on CTA.num_nf_hem=nota_fiscal and CTA.Ref_Acesso_NF_Hem=Ref_acesso
	Join Tipo_Taxa TT on TT.cd_Tp_Tx=CTA.cd_tp_tx
	Join House_exp_mar HOU on HOU.num_proc_hem=CTA.num_proc_hem
	Join Pessoa PP on PP.cd_pes=cd_export_hem
Where
	Emissao between '01-01-2006' and '01-31-2006'


GO

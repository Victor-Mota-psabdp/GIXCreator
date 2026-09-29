SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--incluido dia 27-06 não trazer tipo taxas com NF ='N' - Cadu
--incluido codigo de servico- 19/07/15
CREATE procedure [dbo].[spNotaFiscalBR_Selec_Sel]

	@Tipo		char(1),
	@Numero		varchar(8)

as

select CC.Num_Proc_HBO Processo, TT.Nome_tp_tx Taxa, CC.DC_HBO DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_HBO Vlr_Org, CC.Num_nf_HBO Num_NF, CC.Ref_Acesso_NF_HBO Ref_Acesso_NF,CC.Vlr_Pgto_NF_HBO Vlr_Pgto_NF,CC.Par_NF_HBO Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from Cta_Cte_HOU_BDP_OUT CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where 
CC.Num_Nf_HBO =@Numero and ref_Acesso_nf_HBO = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')

union

select CC.Num_Proc_hem Processo, TT.Nome_tp_tx Taxa, CC.DC_Hem DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_Hem Vlr_Org, CC.Num_nf_hem Num_NF, CC.Ref_Acesso_NF_HEM Ref_Acesso_NF,CC.Vlr_Pgto_NF_hem Vlr_Pgto_NF,CC.Par_NF_Hem Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from cta_cte_hou_exp_mar CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where 
CC.Num_Nf_Hem =@Numero and ref_Acesso_nf_hem = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')

union

select CC.Num_Proc_him Processo, TT.Nome_tp_tx Taxa, CC.DC_him DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_him Vlr_Org, CC.Num_nf_him Num_NF, CC.Ref_Acesso_NF_him Ref_Acesso_NF,CC.Vlr_Pgto_NF_him Vlr_Pgto_NF,CC.Par_NF_him Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from cta_cte_hou_imp_mar CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where CC.Num_Nf_Him =@Numero and ref_Acesso_nf_him = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')

union

select CC.Num_Proc_Hia Processo, TT.Nome_tp_tx Taxa, CC.DC_Hia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_Hia Vlr_Org, CC.Num_nf_Hia Num_NF, CC.Ref_Acesso_NF_Hia Ref_Acesso_NF,CC.Vlr_Pgto_NF_Hia Vlr_Pgto_NF,CC.Par_NF_Hia Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from cta_cte_hou_imp_aer CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where CC.Num_Nf_Hia =@Numero and ref_Acesso_nf_hia = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')

union 

select CC.Num_Proc_hea Processo, TT.Nome_tp_tx Taxa, CC.DC_hea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hea Vlr_Org, CC.Num_nf_hea Num_NF, CC.Ref_Acesso_NF_hea Ref_Acesso_NF,CC.Vlr_Pgto_NF_hea Vlr_Pgto_NF,CC.Par_NF_hea Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from cta_cte_hou_exp_aer CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where CC.Num_Nf_Hea =@Numero and ref_Acesso_nf_hea = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
and NF = 'S'

union

select CC.Num_Proc_heo Processo, TT.Nome_tp_tx Taxa, CC.DC_heo DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_heo Vlr_Org, CC.Num_nf_heo Num_NF, CC.Ref_Acesso_NF_heo Ref_Acesso_NF,CC.Vlr_Pgto_NF_heo Vlr_Pgto_NF,CC.Par_NF_heo Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from cta_cte_hou_exp_out CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where CC.Num_Nf_Heo =@Numero and ref_Acesso_nf_heo = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
and NF = 'S'

union

select CC.Num_Proc_hio Processo, TT.Nome_tp_tx Taxa, CC.DC_hio DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hio Vlr_Org, CC.Num_nf_hio Num_NF, CC.Ref_Acesso_NF_hio Ref_Acesso_NF,CC.Vlr_Pgto_NF_hio Vlr_Pgto_NF,CC.Par_NF_hio Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from cta_cte_hou_imp_out CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where CC.Num_Nf_Hio =@Numero and ref_Acesso_nf_hio = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
and NF = 'S'

union

select CC.Num_Proc_mia Processo, TT.Nome_tp_tx Taxa, CC.DC_mia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mia Vlr_Org, CC.Num_nf_mia Num_NF, CC.Ref_Acesso_NF_mia Ref_Acesso_NF,CC.Vlr_Pgto_NF_mia Vlr_Pgto_NF,CC.Par_NF_mia Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from cta_cte_mas_imp_aer CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where CC.Num_Nf_mia =@Numero and ref_Acesso_nf_mia = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
and NF = 'S'

union

select CC.Num_Proc_mea Processo, TT.Nome_tp_tx Taxa, CC.DC_mea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mea Vlr_Org, CC.Num_nf_mea Num_NF, CC.Ref_Acesso_NF_mea Ref_Acesso_NF,CC.Vlr_Pgto_NF_mea Vlr_Pgto_NF,CC.Par_NF_mea Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from cta_cte_mas_exp_aer CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where  CC.Num_Nf_mea =@Numero and ref_Acesso_nf_mea = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
and NF = 'S'

Union

select CC.Num_Proc_mim Processo, TT.Nome_tp_tx Taxa, CC.DC_mim DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mim Vlr_Org, CC.Num_nf_mim Num_NF, CC.Ref_Acesso_NF_mim Ref_Acesso_NF,CC.Vlr_Pgto_NF_mim Vlr_Pgto_NF,CC.Par_NF_mim Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from cta_cte_mas_imp_mar CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where  CC.Num_Nf_mim =@Numero and ref_Acesso_nf_mim = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
and NF = 'S'

union

select CC.Num_Proc_mem Processo, TT.Nome_tp_tx Taxa, CC.DC_mem DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mem Vlr_Org, CC.Num_nf_mem Num_NF, CC.Ref_Acesso_NF_mem Ref_Acesso_NF,CC.Vlr_Pgto_NF_mem Vlr_Pgto_NF,CC.Par_NF_mem Par_NF,CC.Val_Con_Comp 
,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
from cta_cte_mas_exp_mar CC
join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left Outer Join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @Tipo
where CC.Num_Nf_mem =@Numero and ref_Acesso_nf_mem = @tipo 
and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
and NF = 'S'






GO

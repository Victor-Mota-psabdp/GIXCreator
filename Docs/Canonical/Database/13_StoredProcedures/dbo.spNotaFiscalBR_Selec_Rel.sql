SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spNotaFiscalBR_Selec_Rel]

	@Tipo		char(1),
	@Numero		varchar(12)

as

select TX.cd_tp_tx TX_NF,CC.Num_Proc_hem Processo, TT.Nome_tp_tx Taxa, CC.DC_Hem DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_Hem Vlr_Org, CC.Num_nf_hem Num_NF, CC.Ref_Acesso_NF_HEM Ref_Acesso_NF,CC.Vlr_Pgto_NF_hem Vlr_Pgto_NF,CC.Par_NF_Hem Par_NF,CC.Val_Con_Comp from cta_cte_hou_exp_mar CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Hem =@Numero and ref_Acesso_nf_hem = @Tipo
group by TX.cd_tp_tx,CC.Num_Proc_hem , TT.Nome_tp_tx , CC.DC_Hem, TM.Nome_tp_moeda,CC.Vlr_Org_Hem , CC.Num_nf_hem, CC.Ref_Acesso_NF_HEM,CC.Vlr_Pgto_NF_hem ,CC.Par_NF_Hem,CC.Val_Con_Comp

union

select TX.cd_tp_tx TX_NF,CC.Num_Proc_him Processo, TT.Nome_tp_tx Taxa, CC.DC_him DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_him Vlr_Org, CC.Num_nf_him Num_NF, CC.Ref_Acesso_NF_him Ref_Acesso_NF,CC.Vlr_Pgto_NF_him Vlr_Pgto_NF,CC.Par_NF_him Par_NF,CC.Val_Con_Comp from cta_cte_hou_imp_mar CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Him =@Numero and ref_Acesso_nf_him = @Tipo
group by TX.cd_tp_tx,CC.Num_Proc_him, TT.Nome_tp_tx , CC.DC_him, TM.Nome_tp_moeda,CC.Vlr_Org_him, CC.Num_nf_him, CC.Ref_Acesso_NF_him,CC.Vlr_Pgto_NF_him,CC.Par_NF_him,CC.Val_Con_Comp 

union

select TX.cd_tp_tx TX_NF,CC.Num_Proc_Hia Processo, TT.Nome_tp_tx Taxa, CC.DC_Hia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_Hia Vlr_Org, CC.Num_nf_Hia Num_NF, CC.Ref_Acesso_NF_Hia Ref_Acesso_NF,CC.Vlr_Pgto_NF_Hia Vlr_Pgto_NF,CC.Par_NF_Hia Par_NF,CC.Val_Con_Comp from cta_cte_hou_imp_aer CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Hia =@Numero and ref_Acesso_nf_hia = @tipo
group by TX.cd_tp_tx,CC.Num_Proc_Hia, TT.Nome_tp_tx, CC.DC_Hia, TM.Nome_tp_moeda,CC.Vlr_Org_Hia, CC.Num_nf_Hia, CC.Ref_Acesso_NF_Hia,CC.Vlr_Pgto_NF_Hia,CC.Par_NF_Hia,CC.Val_Con_Comp

union

select TX.cd_tp_tx TX_NF,CC.Num_Proc_hea Processo, TT.Nome_tp_tx Taxa, CC.DC_hea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hea Vlr_Org, CC.Num_nf_hea Num_NF, CC.Ref_Acesso_NF_hea Ref_Acesso_NF,CC.Vlr_Pgto_NF_hea Vlr_Pgto_NF,CC.Par_NF_hea Par_NF,CC.Val_Con_Comp from cta_cte_hou_exp_aer CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Hea =@Numero and ref_Acesso_nf_hea = @tipo
group by TX.cd_tp_tx,CC.Num_Proc_hea, TT.Nome_tp_tx, CC.DC_hea, TM.Nome_tp_moeda,CC.Vlr_Org_hea, CC.Num_nf_hea, CC.Ref_Acesso_NF_hea,CC.Vlr_Pgto_NF_hea,CC.Par_NF_hea,CC.Val_Con_Comp

union

select TX.cd_tp_tx TX_NF,CC.Num_Proc_heo Processo, TT.Nome_tp_tx Taxa, CC.DC_heo DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_heo Vlr_Org, CC.Num_nf_heo Num_NF, CC.Ref_Acesso_NF_heo Ref_Acesso_NF,CC.Vlr_Pgto_NF_heo Vlr_Pgto_NF,CC.Par_NF_heo Par_NF,CC.Val_Con_Comp from cta_cte_hou_exp_out CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Heo =@Numero and ref_Acesso_nf_heo = @tipo
group by TX.cd_tp_tx,CC.Num_Proc_heo, TT.Nome_tp_tx, CC.DC_heo, TM.Nome_tp_moeda,CC.Vlr_Org_heo, CC.Num_nf_heo, CC.Ref_Acesso_NF_heo,CC.Vlr_Pgto_NF_heo,CC.Par_NF_heo,CC.Val_Con_Comp

union

select TX.cd_tp_tx TX_NF,CC.Num_Proc_hio Processo, TT.Nome_tp_tx Taxa, CC.DC_hio DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hio Vlr_Org, CC.Num_nf_hio Num_NF, CC.Ref_Acesso_NF_hio Ref_Acesso_NF,CC.Vlr_Pgto_NF_hio Vlr_Pgto_NF,CC.Par_NF_hio Par_NF,CC.Val_Con_Comp from cta_cte_hou_imp_out CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Hio =@Numero and ref_Acesso_nf_hio = @tipo
group by TX.cd_tp_tx,CC.Num_Proc_hio, TT.Nome_tp_tx, CC.DC_hio, TM.Nome_tp_moeda,CC.Vlr_Org_hio, CC.Num_nf_hio, CC.Ref_Acesso_NF_hio,CC.Vlr_Pgto_NF_hio,CC.Par_NF_hio,CC.Val_Con_Comp

union

select TX.cd_tp_tx TX_NF,CC.Num_Proc_mia Processo, TT.Nome_tp_tx Taxa, CC.DC_mia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mia Vlr_Org, CC.Num_nf_mia Num_NF, CC.Ref_Acesso_NF_mia Ref_Acesso_NF,CC.Vlr_Pgto_NF_mia Vlr_Pgto_NF,CC.Par_NF_mia Par_NF,CC.Val_Con_Comp from cta_cte_mas_imp_aer CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_mia =@Numero and ref_Acesso_nf_mia = @tipo and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
group by TX.cd_tp_tx,CC.Num_Proc_mia, TT.Nome_tp_tx, CC.DC_mia, TM.Nome_tp_moeda,CC.Vlr_Org_mia, CC.Num_nf_mia, CC.Ref_Acesso_NF_mia,CC.Vlr_Pgto_NF_mia,CC.Par_NF_mia,CC.Val_Con_Comp

union

select TX.cd_tp_tx TX_NF,CC.Num_Proc_mea Processo, TT.Nome_tp_tx Taxa, CC.DC_mea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mea Vlr_Org, CC.Num_nf_mea Num_NF, CC.Ref_Acesso_NF_mea Ref_Acesso_NF,CC.Vlr_Pgto_NF_mea Vlr_Pgto_NF,CC.Par_NF_mea Par_NF,CC.Val_Con_Comp from cta_cte_mas_exp_aer CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_mea =@Numero and ref_Acesso_nf_mea = @tipo and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
group by TX.cd_tp_tx,CC.Num_Proc_mea, TT.Nome_tp_tx, CC.DC_mea, TM.Nome_tp_moeda,CC.Vlr_Org_mea, CC.Num_nf_mea, CC.Ref_Acesso_NF_mea,CC.Vlr_Pgto_NF_mea,CC.Par_NF_mea,CC.Val_Con_Comp

Union

select TX.cd_tp_tx TX_NF,CC.Num_Proc_mim Processo, TT.Nome_tp_tx Taxa, CC.DC_mim DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mim Vlr_Org, CC.Num_nf_mim Num_NF, CC.Ref_Acesso_NF_mim Ref_Acesso_NF,CC.Vlr_Pgto_NF_mim Vlr_Pgto_NF,CC.Par_NF_mim Par_NF,CC.Val_Con_Comp from cta_cte_mas_imp_mar CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_mim =@Numero and ref_Acesso_nf_mim = @tipo and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
group by TX.cd_tp_tx,CC.Num_Proc_mim, TT.Nome_tp_tx, CC.DC_mim, TM.Nome_tp_moeda,CC.Vlr_Org_mim, CC.Num_nf_mim, CC.Ref_Acesso_NF_mim,CC.Vlr_Pgto_NF_mim,CC.Par_NF_mim,CC.Val_Con_Comp

union

select TX.cd_tp_tx TX_NF,CC.Num_Proc_mem Processo, TT.Nome_tp_tx Taxa, CC.DC_mem DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mem Vlr_Org, CC.Num_nf_mem Num_NF, CC.Ref_Acesso_NF_mem Ref_Acesso_NF,CC.Vlr_Pgto_NF_mem Vlr_Pgto_NF,CC.Par_NF_mem Par_NF,CC.Val_Con_Comp from cta_cte_mas_exp_mar CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_mem =@Numero and ref_Acesso_nf_mem = @tipo and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
group by TX.cd_tp_tx,CC.Num_Proc_mem, TT.Nome_tp_tx, CC.DC_mem, TM.Nome_tp_moeda,CC.Vlr_Org_mem, CC.Num_nf_mem, CC.Ref_Acesso_NF_mem,CC.Vlr_Pgto_NF_mem,CC.Par_NF_mem,CC.Val_Con_Comp







GO

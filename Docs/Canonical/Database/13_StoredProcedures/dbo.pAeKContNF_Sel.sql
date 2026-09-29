SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pAeKContNF_Sel]
(
@NF		varchar(8),
@Site		char(1)
)
AS
	Select  Num_Proc_HIM Num_Proc, Num_NF_HIM NF, Ref_Acesso_NF_HIM Ref_Acesso, Vlr_Pgto_NF_HIM  Vlr_Item_NF, Dt_Ins_HIM Dt_Ins, DC_HIM DC, Cte.Cd_tp_Tx, TT.Nome_Tp_Tx,  Nome_Raz_Soc  Cred_Dev from cta_cte_hou_imp_mar   cte join tipo_taxa tt on tt.cd_tp_tx = cte.cd_tp_tx  Join pessoa pes on pes.cd_pes = cte.cd_cred_dev_him where Num_NF_HIM = @NF and Ref_Acesso_NF_HIM = @Site 
	Union 
	Select  Num_Proc_HIA Num_Proc, Num_NF_HIA NF, Ref_Acesso_NF_HIA Ref_Acesso, Vlr_Pgto_NF_HIA  Vlr_Item_NF, Dt_Ins_HIA Dt_Ins, DC_HIA DC, Cte.Cd_tp_Tx, TT.Nome_Tp_Tx,  Nome_Raz_Soc  Cred_Dev  from cta_cte_hou_imp_aer cte join tipo_taxa tt on tt.cd_tp_tx = cte.cd_tp_tx Join pessoa pes on pes.cd_pes = cte.cd_cred_dev_hia where Num_NF_HIA = @NF and Ref_Acesso_NF_HIA = @Site 
	Union 
	Select  Num_Proc_HIO Num_Proc, Num_NF_HIO NF, Ref_Acesso_NF_HIO Ref_Acesso, Vlr_Pgto_NF_HIO  Vlr_Item_NF, Dt_Ins_HIO Dt_Ins, DC_HIO DC, Cte.Cd_tp_Tx, TT.Nome_Tp_Tx,  Nome_Raz_Soc  Cred_Dev  from cta_cte_hou_imp_out cte join tipo_taxa tt on tt.cd_tp_tx = cte.cd_tp_tx Join pessoa pes on pes.cd_pes = cte.cd_cred_dev_hio where Num_NF_HIO = @NF and Ref_Acesso_NF_HIO = @Site 
	Union
	Select  Num_Proc_HEM Num_Proc, Num_NF_HEM NF, Ref_Acesso_NF_HEM Ref_Acesso, Vlr_Pgto_NF_HEM  Vlr_Item_NF, Dt_Ins_HEM Dt_Ins, DC_HEM DC, Cte.Cd_tp_Tx, TT.Nome_Tp_Tx,  Nome_Raz_Soc  Cred_Dev  from cta_cte_hou_exp_mar cte join tipo_taxa tt on tt.cd_tp_tx = cte.cd_tp_tx Join pessoa pes on pes.cd_pes = cte.cd_cred_dev_hem where Num_NF_HEM = @NF and Ref_Acesso_NF_HEM = @Site 
	Union 
	Select  Num_Proc_HEO Num_Proc, Num_NF_HEO NF, Ref_Acesso_NF_HEO Ref_Acesso, Vlr_Pgto_NF_HEO  Vlr_Item_NF, Dt_Ins_HEO Dt_Ins, DC_HEO DC, Cte.Cd_tp_Tx, TT.Nome_Tp_Tx,  Nome_Raz_Soc  Cred_Dev  from cta_cte_hou_exp_out cte join tipo_taxa tt on tt.cd_tp_tx = cte.cd_tp_tx Join pessoa pes on pes.cd_pes = cte.cd_cred_dev_heo where Num_NF_HEO = @NF and Ref_Acesso_NF_HEO = @Site 
	Union
	Select  Num_Proc_HEA Num_Proc, Num_NF_HEA NF, Ref_Acesso_NF_HEA Ref_Acesso, Vlr_Pgto_NF_HEA  Vlr_Item_NF, Dt_Ins_HEA Dt_Ins, DC_HEA DC, Cte.Cd_tp_Tx, TT.Nome_Tp_Tx,  Nome_Raz_Soc Cred_Dev   from cta_cte_hou_exp_aer cte  join tipo_taxa tt on tt.cd_tp_tx = cte.cd_tp_tx Join pessoa pes on pes.cd_pes = cte.cd_cred_dev_hea where Num_NF_HEA = @NF and Ref_Acesso_NF_HEA = @Site 
	Union 

	Select  Num_Proc_MIM Num_Proc,  Num_NF_MIM NF, Ref_Acesso_NF_MIM Ref_Acesso, Vlr_Pgto_NF_MIM  Vlr_Item_NF, Dt_Ins_MIM Dt_Ins, DC_MIM DC, Cte.Cd_tp_Tx, TT.Nome_Tp_Tx,  Nome_Raz_Soc Cred_Dev   from cta_cte_mas_imp_mar cte join tipo_taxa tt on tt.cd_tp_tx = cte.cd_tp_tx Join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mim where Num_NF_MIM = @NF and Ref_Acesso_NF_MIM = @Site 
	Union 
	Select  Num_Proc_MIA Num_Proc, Num_NF_MIA NF, Ref_Acesso_NF_MIA Ref_Acesso, Vlr_Pgto_NF_MIA  Vlr_Item_NF, Dt_Ins_MIA Dt_Ins, DC_MIA DC, Cte.Cd_tp_Tx, TT.Nome_Tp_Tx,  Nome_Raz_Soc Cred_Dev   from cta_cte_mas_imp_aer cte join tipo_taxa tt on tt.cd_tp_tx = cte.cd_tp_tx Join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mia where Num_NF_MIA = @NF and Ref_Acesso_NF_MIA = @Site 
	Union 
	Select  Num_Proc_MEM Num_Proc,  Num_NF_MEM NF, Ref_Acesso_NF_MEM Ref_Acesso, Vlr_Pgto_NF_MEM  Vlr_Item_NF, Dt_Ins_MEM Dt_Ins, DC_MEM DC, Cte.Cd_tp_Tx, TT.Nome_Tp_Tx,  Nome_Raz_Soc Cred_Dev   from cta_cte_mas_exp_mar cte join tipo_taxa tt on tt.cd_tp_tx = cte.cd_tp_tx Join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mem where Num_NF_MEM = @NF and Ref_Acesso_NF_MEM = @Site 
	Union 
	Select  Num_Proc_MEA Num_Proc,  Num_NF_MEA NF, Ref_Acesso_NF_MEA Ref_Acesso, Vlr_Pgto_NF_MEA  Vlr_Item_NF, Dt_Ins_MEA Dt_Ins, DC_MEA DC, Cte.Cd_tp_Tx, TT.Nome_Tp_Tx,  Nome_Raz_Soc Cred_Dev    from cta_cte_mas_exp_aer cte join tipo_taxa tt on tt.cd_tp_tx = cte.cd_tp_tx Join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mea where Num_NF_MEA = @NF and Ref_Acesso_NF_MEA = @Site



GO

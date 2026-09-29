SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pAeKCteVer2_Sel 
(
	@DC	Char(1) 
)
AS
	Declare @Ano		VarChar(4)
	Set @Ano =  '2006'
		
	Select 
		sum(vlr_contab_ant)
	from 	
		Cta_Cte_Hou_Imp_Mar cte 
		left join Caixa_Hou_Imp_Mar Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and convert(datetime, cxa.dt_pgto_rcto_him, 105) <= '2006-03-31' 
	Where 
		
		year(convert(datetime, cte.dt_ins_him, 105)) = @Ano and 
		left(cte.num_proc_him, 5) <> 'IMJOB' and Cxa.Num_Proc_HIM is null  and 
		Cte.DC_HIM = @DC




	Select 
		sum(vlr_contab_ant)
	from 	
		Cta_Cte_Hou_Imp_Aer cte 
		left join Caixa_Hou_Imp_Aer Cxa on Cxa.Num_Proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and convert(datetime, cxa.dt_pgto_rcto_hia, 105) <= '2006-03-31'
	Where 

		year(convert(datetime, cte.dt_ins_HIA, 105)) = @Ano and 
		left(cte.num_proc_HIA, 5) <> 'IAJOB' and Cxa.Num_Proc_HIA is null and 
		Cte.DC_HIA = @DC




	Select 
		sum(vlr_contab_ant)
	from 	
		Cta_Cte_Hou_Exp_Mar cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join Caixa_Hou_Exp_Mar Cxa on Cxa.Num_Proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and convert(datetime, cxa.dt_pgto_rcto_hem, 105) <= '2006-03-31'
	Where 
		year(convert(datetime, cte.dt_ins_HEM, 105)) = @Ano and 
		left(cte.num_proc_HEM, 5) <> 'EMJOB' and Cxa.Num_Proc_HEM is null and 
		Cte.DC_HEM = @DC



	Select 
		sum(vlr_contab_ant)
	from 	
		Cta_Cte_Hou_Exp_Aer cte 
		left join Caixa_Hou_Exp_Aer Cxa on Cxa.Num_Proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and convert(datetime, cxa.dt_pgto_rcto_hea, 105) <= '2006-03-31'
	Where 
		year(convert(datetime, cte.dt_ins_HEA, 105)) = @Ano and 
		left(cte.num_proc_HEA, 5) <> 'EAJOB' and Cxa.Num_Proc_HEA is null and 
		Cte.DC_HEA = @DC



	Select 
		sum(vlr_contab_ant)
	from 	
		Cta_Cte_Mas_Imp_Mar cte 
		left join Caixa_Mas_Imp_Mar Cxa on Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and Cxa.DC_MIM = Cte.DC_MIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and convert(datetime, cxa.dt_pgto_rcto_mim, 105) <= '2006-03-31'
	Where 
		year(convert(datetime, cte.dt_ins_MIM, 105)) = @Ano  and Cxa.Num_Proc_MIM is null and 
		Cte.DC_mIM = @DC



	Select 
		sum(vlr_contab_ant)
	from 	
		Cta_Cte_Mas_Imp_Aer cte 
		left join Caixa_Mas_Imp_Aer Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.DC_MIA = Cte.DC_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and convert(datetime, cxa.dt_pgto_rcto_mia, 105) <= '2006-03-31'
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mia 
	Where 
		year(convert(datetime, cte.dt_ins_MIA, 105)) = @Ano  and Cxa.Num_Proc_MIA is null and 
		Cte.DC_MIA = @DC




	Select 
		sum(vlr_contab_ant)
	from 	
		Cta_Cte_Mas_Exp_Mar cte 
		left join Caixa_Mas_Exp_Mar Cxa on Cxa.Num_Proc_MEM = Cte.Num_Proc_MEM and Cxa.DC_MEM = Cte.DC_MEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and convert(datetime, cxa.dt_pgto_rcto_mem, 105) <= '2006-03-31'
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mem 
	Where 
		year(convert(datetime, cte.dt_ins_MEM, 105)) = @Ano  and Cxa.Num_Proc_MEM is null and 
		Cte.DC_MEM = @DC



	Select 
		sum(vlr_contab_ant)
	from 	
		Cta_Cte_Mas_Exp_Aer cte 
		left join Caixa_Mas_Exp_Aer Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.DC_MEA = Cte.DC_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and convert(datetime, cxa.dt_pgto_rcto_mea, 105) <= '2006-03-31'
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mea 
	Where 
		year(convert(datetime, cte.dt_ins_MEA, 105)) = @Ano and Cxa.Num_Proc_MEA is null and 
		Cte.DC_MEA = @DC
GO

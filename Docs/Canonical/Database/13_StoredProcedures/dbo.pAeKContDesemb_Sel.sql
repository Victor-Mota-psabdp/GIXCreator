SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pAeKContDesemb_Sel] 
(
@Ano		VarChar(4) ,
@Mes		char(2) 
)
AS
	Select 
		dt_pgto_rcto, PR.Num_Lcto Num_Lcto, Forma_Pgto_Rcto, cta.Cd_Cta_Ctb cta_banco,  Num_Doc , cte.dc_hea  DC, Vlr_Doc , cte.Cd_tp_Tx, tt.Nome_Tp_Tx, 
		pes.nome_raz_soc, Vlr_Pgto_Rcto_HEA Vlr_Pgto, Cte.Num_Proc_HEA Num_Proc  
	From 
		pgto_rcto pr join cta_cte cta on cta.cd_banco = pr.cd_banco and cta.cd_agencia = pr.cd_agencia and cta.num_cta_cte = pr.num_cta_cte 
		join caixa_hou_exp_aer cxa on cxa.num_lcto = pr.num_lcto
		join cta_cte_hou_exp_aer cte on cte.num_proc_hea = cxa.num_proc_hea and cte.cd_tp_Tx = cxa.cd_tp_Tx and cte.dc_hea = cxa.dc_hea  
		join tipo_taxa tt on tt.cd_tp_Tx = cte.cd_tp_tx 
		join pessoa pes on pes.cd_pes = pr.cd_pes 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')  and 
		cxa.cd_tp_tx in 
		('AF2', 'AN3', 'ANF', 'AP1','AC2', 'APC', 'CDF', 'CFC', 'DF2', 'DN3', 'DNF', 'DPC')


	Union 

	Select 
		dt_pgto_rcto, PR.Num_Lcto Num_Lcto, Forma_Pgto_Rcto, cta.Cd_Cta_Ctb cta_banco,  Num_Doc , cte.dc_HEO  DC, Vlr_Doc , cte.Cd_tp_Tx, tt.Nome_Tp_Tx, 
		pes.nome_raz_soc, Vlr_Pgto_Rcto_HEO Vlr_Pgto, Cte.Num_Proc_HEO Num_Proc  
	From 
		pgto_rcto pr join cta_cte cta on cta.cd_banco = pr.cd_banco and cta.cd_agencia = pr.cd_agencia and cta.num_cta_cte = pr.num_cta_cte 
		join caixa_hou_exp_out cxa on cxa.num_lcto = pr.num_lcto
		join cta_cte_hou_exp_out cte on cte.num_proc_HEO = cxa.num_proc_HEO and cte.cd_tp_Tx = cxa.cd_tp_Tx and cte.dc_HEO = cxa.dc_HEO  
		join tipo_taxa tt on tt.cd_tp_Tx = cte.cd_tp_tx 
		join pessoa pes on pes.cd_pes = pr.cd_pes 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')  and 
		cxa.cd_tp_tx in 
		('AF2', 'AN3', 'ANF', 'AP1','AC2', 'APC', 'CDF', 'CFC', 'DF2', 'DN3', 'DNF', 'DPC')


	Union 



	Select 
		dt_pgto_rcto, PR.Num_Lcto Num_Lcto, Forma_Pgto_Rcto, cta.Cd_Cta_Ctb cta_banco,  Num_Doc ,cte.dc_hem   DC, Vlr_Doc , cte.Cd_tp_Tx, tt.Nome_Tp_Tx, 
		pes.nome_raz_soc , Vlr_Pgto_Rcto_HEM Vlr_Pgto, Cte.Num_Proc_HEM Num_Proc 
	From 
		pgto_rcto pr join cta_cte cta on cta.cd_banco = pr.cd_banco and cta.cd_agencia = pr.cd_agencia and cta.num_cta_cte = pr.num_cta_cte 
		join caixa_hou_exp_mar cxa on cxa.num_lcto = pr.num_lcto
		join cta_cte_hou_exp_mar cte on cte.num_proc_hem = cxa.num_proc_hem and cte.cd_tp_Tx = cxa.cd_tp_Tx and cte.dc_hem = cxa.dc_hem  
		join tipo_taxa tt on tt.cd_tp_Tx = cte.cd_tp_tx 
		join pessoa pes on pes.cd_pes = pr.cd_pes 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')  and 
		cxa.cd_tp_tx in 
		('AF2', 'AN3', 'ANF', 'AP1','AC2', 'APC', 'CDF', 'CFC', 'DF2', 'DN3', 'DNF', 'DPC')

	Union

	Select 
		dt_pgto_rcto, PR.Num_Lcto Num_Lcto, Forma_Pgto_Rcto, cta.Cd_Cta_Ctb cta_banco,  Num_Doc , cte.dc_hia  DC, Vlr_Doc , cte.Cd_tp_Tx, tt.Nome_Tp_Tx, 
		pes.nome_raz_soc , Vlr_Pgto_Rcto_HIA Vlr_Pgto, Cte.Num_Proc_HIA Num_Proc 
	From 
		pgto_rcto pr join cta_cte cta on cta.cd_banco = pr.cd_banco and cta.cd_agencia = pr.cd_agencia and cta.num_cta_cte = pr.num_cta_cte 
		join caixa_hou_imp_aer cxa on cxa.num_lcto = pr.num_lcto
		join cta_cte_hou_imp_aer cte on cte.num_proc_hia = cxa.num_proc_hia and cte.cd_tp_Tx = cxa.cd_tp_Tx and cte.dc_hia = cxa.dc_hia  
		join tipo_taxa tt on tt.cd_tp_Tx = cte.cd_tp_tx 
		join pessoa pes on pes.cd_pes = pr.cd_pes 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')  and 
		cxa.cd_tp_tx in 
		('AF2', 'AN3', 'ANF', 'AP1','AC2', 'APC', 'CDF', 'CFC', 'DF2', 'DN3', 'DNF', 'DPC')


	Union 

	Select 
		dt_pgto_rcto, PR.Num_Lcto Num_Lcto, Forma_Pgto_Rcto, cta.Cd_Cta_Ctb cta_banco,  Num_Doc , cte.dc_HIO  DC, Vlr_Doc , cte.Cd_tp_Tx, tt.Nome_Tp_Tx, 
		pes.nome_raz_soc , Vlr_Pgto_Rcto_HIO Vlr_Pgto, Cte.Num_Proc_HIO Num_Proc 
	From 
		pgto_rcto pr join cta_cte cta on cta.cd_banco = pr.cd_banco and cta.cd_agencia = pr.cd_agencia and cta.num_cta_cte = pr.num_cta_cte 
		join caixa_hou_imp_out cxa on cxa.num_lcto = pr.num_lcto
		join cta_cte_hou_imp_out cte on cte.num_proc_HIO = cxa.num_proc_HIO and cte.cd_tp_Tx = cxa.cd_tp_Tx and cte.dc_HIO = cxa.dc_HIO  
		join tipo_taxa tt on tt.cd_tp_Tx = cte.cd_tp_tx 
		join pessoa pes on pes.cd_pes = pr.cd_pes 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')  and 
		cxa.cd_tp_tx in 
		('AF2', 'AN3', 'ANF', 'AP1','AC2', 'APC', 'CDF', 'CFC', 'DF2', 'DN3', 'DNF', 'DPC')


	Union 


	Select 
		dt_pgto_rcto, PR.Num_Lcto Num_Lcto, Forma_Pgto_Rcto, cta.Cd_Cta_Ctb cta_banco,  Num_Doc , cte.dc_him  DC, Vlr_Doc , cte.Cd_tp_Tx, tt.Nome_Tp_Tx, 
		pes.nome_raz_soc , Vlr_Pgto_Rcto_HIM Vlr_Pgto, Cte.Num_Proc_HIM Num_Proc 
	From 
		pgto_rcto pr join cta_cte cta on cta.cd_banco = pr.cd_banco and cta.cd_agencia = pr.cd_agencia and cta.num_cta_cte = pr.num_cta_cte 
		join caixa_hou_imp_mar cxa on cxa.num_lcto = pr.num_lcto
		join cta_cte_hou_imp_mar cte on cte.num_proc_him = cxa.num_proc_him and cte.cd_tp_Tx = cxa.cd_tp_Tx and cte.dc_him = cxa.dc_him  
		join tipo_taxa tt on tt.cd_tp_Tx = cte.cd_tp_tx 
		join pessoa pes on pes.cd_pes = pr.cd_pes 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')  and 
		cxa.cd_tp_tx in 
		('AF2', 'AN3', 'ANF', 'AP1','AC2', 'APC', 'CDF', 'CFC', 'DF2', 'DN3', 'DNF', 'DPC')

	Union 

	Select 
		dt_pgto_rcto, PR.Num_Lcto Num_Lcto, Forma_Pgto_Rcto, cta.Cd_Cta_Ctb cta_banco,  Num_Doc ,  cte.dc_mea DC, Vlr_Doc , cte.Cd_tp_Tx, tt.Nome_Tp_Tx, 
		pes.nome_raz_soc , Vlr_Pgto_Rcto_MEA Vlr_Pgto, Cte.Num_Proc_MEA Num_Proc 
	From 
		pgto_rcto pr join cta_cte cta on cta.cd_banco = pr.cd_banco and cta.cd_agencia = pr.cd_agencia and cta.num_cta_cte = pr.num_cta_cte 
		join caixa_mas_exp_aer cxa on cxa.num_lcto = pr.num_lcto
		join cta_cte_mas_exp_aer cte on cte.num_proc_mea = cxa.num_proc_mea and cte.cd_tp_Tx = cxa.cd_tp_Tx and cte.dc_mea = cxa.dc_mea  
		join tipo_taxa tt on tt.cd_tp_Tx = cte.cd_tp_tx 
		join pessoa pes on pes.cd_pes = pr.cd_pes 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')  and 
		cxa.cd_tp_tx in 
		('AF2', 'AN3', 'ANF', 'AP1','AC2', 'APC', 'CDF', 'CFC', 'DF2', 'DN3', 'DNF', 'DPC')


	Union 

	Select 
		dt_pgto_rcto, PR.Num_Lcto Num_Lcto, Forma_Pgto_Rcto, cta.Cd_Cta_Ctb cta_banco,  Num_Doc ,cte.dc_mem   DC, Vlr_Doc , cte.Cd_tp_Tx, tt.Nome_Tp_Tx, 
		pes.nome_raz_soc , Vlr_Pgto_Rcto_MEM Vlr_Pgto, Cte.Num_Proc_MEM Num_Proc 
	From 
		pgto_rcto pr join cta_cte cta on cta.cd_banco = pr.cd_banco and cta.cd_agencia = pr.cd_agencia and cta.num_cta_cte = pr.num_cta_cte 
		join caixa_mas_exp_mar cxa on cxa.num_lcto = pr.num_lcto
		join cta_cte_mas_exp_mar cte on cte.num_proc_mem = cxa.num_proc_mem and cte.cd_tp_Tx = cxa.cd_tp_Tx and cte.dc_mem = cxa.dc_mem  
		join tipo_taxa tt on tt.cd_tp_Tx = cte.cd_tp_tx 
		join pessoa pes on pes.cd_pes = pr.cd_pes 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')  and 
		cxa.cd_tp_tx in 
		('AF2', 'AN3', 'ANF', 'AP1','AC2', 'APC', 'CDF', 'CFC', 'DF2', 'DN3', 'DNF', 'DPC')

	Union

	Select 
		dt_pgto_rcto, PR.Num_Lcto Num_Lcto, Forma_Pgto_Rcto, cta.Cd_Cta_Ctb cta_banco,  Num_Doc , cte.dc_mia  DC, Vlr_Doc , cte.Cd_tp_Tx, tt.Nome_Tp_Tx, 
		pes.nome_raz_soc , Vlr_Pgto_Rcto_MIA Vlr_Pgto, Cte.Num_Proc_MIA Num_Proc 
	From 
		pgto_rcto pr join cta_cte cta on cta.cd_banco = pr.cd_banco and cta.cd_agencia = pr.cd_agencia and cta.num_cta_cte = pr.num_cta_cte 
		join caixa_mas_imp_aer cxa on cxa.num_lcto = pr.num_lcto
		join cta_cte_mas_imp_aer cte on cte.num_proc_mia = cxa.num_proc_mia and cte.cd_tp_Tx = cxa.cd_tp_Tx and cte.dc_mia = cxa.dc_mia  
		join tipo_taxa tt on tt.cd_tp_Tx = cte.cd_tp_tx 
		join pessoa pes on pes.cd_pes = pr.cd_pes 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')  and 
		cxa.cd_tp_tx in 
		('AF2', 'AN3', 'ANF', 'AP1','AC2', 'APC', 'CDF', 'CFC', 'DF2', 'DN3', 'DNF', 'DPC')


	Union 

	Select 
		dt_pgto_rcto, PR.Num_Lcto Num_Lcto, Forma_Pgto_Rcto, cta.Cd_Cta_Ctb cta_banco,  Num_Doc ,cte.dc_mim   DC, Vlr_Doc , cte.Cd_tp_Tx, tt.Nome_Tp_Tx, 
		pes.nome_raz_soc , Vlr_Pgto_Rcto_MIM Vlr_Pgto, Cte.Num_Proc_MIM Num_Proc 
	From 
		pgto_rcto pr join cta_cte cta on cta.cd_banco = pr.cd_banco and cta.cd_agencia = pr.cd_agencia and cta.num_cta_cte = pr.num_cta_cte 
		join caixa_mas_imp_mar cxa on cxa.num_lcto = pr.num_lcto
		join cta_cte_mas_imp_mar cte on cte.num_proc_mim = cxa.num_proc_mim and cte.cd_tp_Tx = cxa.cd_tp_Tx and cte.dc_mim = cxa.dc_mim  
		join tipo_taxa tt on tt.cd_tp_Tx = cte.cd_tp_tx 
		join pessoa pes on pes.cd_pes = pr.cd_pes 
	where 
		month(convert(datetime, dt_pgto_rcto, 105)) = @Mes  and 
		year(convert(datetime, dt_pgto_rcto, 105)) = @Ano and pr.num_lcto not in 
			(Select Num_Lcto From pgto_rcto Where Cd_Banco = '005' and Cd_Agencia = '005' and Num_Cta_Cte = '007')  and 
		cxa.cd_tp_tx in 
		('AF2', 'AN3', 'ANF', 'AP1','AC2', 'APC', 'CDF', 'CFC', 'DF2', 'DN3', 'DNF', 'DPC')

	Order by Num_Lcto

GO

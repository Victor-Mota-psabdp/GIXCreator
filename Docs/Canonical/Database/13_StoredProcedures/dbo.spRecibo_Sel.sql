SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spRecibo_Sel --'10/07/2010','10/07/2010','%'

@DataInicial	varchar(10),
@DataFinal		varchar(10)

As
--Impor Aer
select
	HOU.num_proc_HIA		Processo,
	CA.num_Rcb_Hia			Recibo,
	PR.Dt_Vcto				Dt_Emissao,
	CLI.Apelido				Cliente,
	PR.Vlr_doc				Vlr_Rcb,
	PR.DC					DC
from 
	Caixa_hou_imp_Aer CA
	join Pgto_Rcto PR			on PR.Num_Lcto = CA.Num_Lcto
	join house_imp_aer HOU		on HOU.num_proc_hia = CA.num_proc_hia
	left join Pessoa	CLI		on CLI.cd_pes = PR.cd_pes
where
	convert(Datetime,PR.Dt_Vcto,103) between @DataInicial and @DataFinal
	and left(CA.num_Rcb_hia,3)='RCA'

union all
--Import Mar
select
	HOU.num_proc_HIM		Processo,
	CA.num_Rcb_Him			Recibo,
	PR.Dt_Vcto				Dt_Emissao,
	CLI.Apelido				Cliente,
	PR.Vlr_doc				Vlr_Rcb,
	PR.DC					DC
from 
	Caixa_hou_imp_Mar CA
	join Pgto_Rcto PR			on PR.Num_Lcto = CA.Num_Lcto
	join House_Imp_Mar HOU		on HOU.num_proc_him = CA.Num_proc_him
	left join Pessoa	CLI		on CLI.cd_pes = PR.cd_pes
where
	convert(Datetime,PR.Dt_Vcto,103) between @DataInicial and @DataFinal
	and left(CA.num_Rcb_HIM,3)='RCA'

union all
--Import Out
select
	HOU.num_proc_HIO		Processo,
	PR.Dt_Vcto				Recibo,
	PR.Dt_Pgto_Rcto			Dt_Emissao,
	CLI.Apelido				Cliente,
	PR.Vlr_doc				Vlr_Rcb,
	PR.DC					DC
from 
	Caixa_hou_imp_Out CA
	join Pgto_Rcto PR			on PR.Num_Lcto = CA.Num_Lcto
	join House_Imp_Out HOU		on HOU.Num_Proc_hio = CA.Num_Proc_hio
	left join Pessoa	CLI		on CLI.cd_pes = PR.cd_pes
where
	convert(Datetime,PR.Dt_Vcto,103) between @DataInicial and @DataFinal
	and left(CA.num_Rcb_HIO,3)='RCA'

union all
--Export Aer
select
	HOU.num_proc_HEA		Processo,
	CA.num_Rcb_HEA			Recibo,
	PR.Dt_Vcto				Dt_Emissao,
	CLI.Apelido				Cliente,
	PR.Vlr_doc				Vlr_Rcb,
	PR.DC					DC
from 
	Caixa_hou_Exp_AER CA
	join Pgto_Rcto PR			on PR.Num_Lcto = CA.Num_Lcto
	join House_Exp_Aer HOU		on HOU.num_proc_hea = CA.Num_Proc_hea
	left join Pessoa CLI		on CLI.cd_pes = PR.cd_pes
where
	convert(Datetime,PR.Dt_Vcto,103) between @DataInicial and @DataFinal
	and left(CA.Num_Rcb_HEA,3)='RCA'

union all
--Export Mar
select
	HOU.num_proc_HEM		Processo,
	CA.num_Rcb_Hem			Recibo,
	PR.Dt_Vcto				Dt_Emissao,
	CLI.Apelido				Cliente,
	PR.Vlr_doc				Vlr_Rcb,
	PR.DC					DC
from 
	Caixa_hou_Exp_Mar CA
	join Pgto_Rcto PR			on PR.Num_Lcto = CA.Num_Lcto
	join House_Exp_Mar HOU		on HOU.Num_proc_hem = CA.num_proc_hem
	left join Pessoa	CLI		on CLI.cd_pes = PR.cd_pes
where
	convert(Datetime,PR.Dt_Vcto,103) between @DataInicial and @DataFinal
	and left(CA.Num_Rcb_HEM,3)='RCA'

union all
--Export Out
select
	CA.num_proc_HEO			Processo,
	CA.num_Rcb_HEO			Recibo,
	PR.Dt_Vcto				Dt_Emissao,
	CLI.Apelido				Cliente,
	PR.Vlr_doc				Vlr_Rcb,
	PR.DC					DC
from 
	Caixa_hou_exp_OUT CA
	join Pgto_Rcto PR				on PR.Num_Lcto = CA.Num_Lcto
	join House_Exp_Out HOU			on HOU.num_proc_heo = CA.num_proc_heo
	left join Pessoa	CLI			on CLI.cd_pes = PR.cd_pes
where
	convert(Datetime,PR.Dt_Vcto,103) between @DataInicial and @DataFinal
	and left(CA.Num_Rcb_HEO,3)='RCA'

order by 1








GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spFaturaLLP_Draft_Rel] --'IMLYB20091000201D'
	
	@FatCod varchar(19)

as
	select 
		HOU.HAWB_HIM HAWB, HOU.MAWB_HIM MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_LIM ETA, LLP.ETD_Lim ETD, FAT.FatDtVenc, PS.Nome_Raz_Soc, EN.Rua, EN.Numero, EN.Bairro, EN.Cidade, EN.UF, EN.Pais, PS.Num_CPF_CNPJ, FAT.FatObs  
	from 
		Fatura_Draft FAT with(nolock)
		join Pessoa PS with(nolock) on FAT.cd_pes = PS.cd_pes and PS.Desat_pes = 'N'
		join Endereco EN  with(nolock)on PS.CD_PEs = EN.Cd_Pes and EN.cd_tp_end = 'COM'
		join House_Imp_Mar HOU with(nolock) on left(FAT.FatCod,16) = HOU.Num_Proc_Him
		join Localidade ORG with(nolock) on HOU.CD_Org_Him = ORG.Cd_Local
		join Localidade DST with(nolock) on HOU.CD_Dst_Him = DST.Cd_Local
		join LLP_Imp_Mar LLP with(nolock) on HOU.Num_proc_him = LLP.Num_Proc_Lim
	where 
		FAT.FatCod = @FatCod

Union all

	select 
		HOU.HAWB_HIA HAWB, HOU.MAWB_HIA MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_lia ETA, LLP.ETD_lia ETD, FAT.FatDtVenc, PS.Nome_Raz_Soc, EN.Rua, EN.Numero, EN.Bairro, EN.Cidade, EN.UF, EN.Pais, PS.Num_CPF_CNPJ, FAT.FatObs  
	from 
		Fatura_Draft FAT with(nolock)
		join Pessoa PS with(nolock) on FAT.cd_pes = PS.cd_pes and PS.Desat_pes = 'N'
		join Endereco EN with(nolock) on PS.CD_PEs = EN.Cd_Pes and EN.cd_tp_end = 'COM'
		join House_Imp_aer HOU with(nolock) on left(FAT.FatCod,16) = HOU.Num_Proc_HIA
		join Localidade ORG with(nolock) on HOU.CD_Org_HIA = ORG.Cd_Local
		join Localidade DST with(nolock) on HOU.CD_Dst_HIA = DST.Cd_Local
		join LLP_Imp_aer LLP with(nolock) on HOU.Num_proc_HIA = LLP.Num_Proc_lia
	where 
		FAT.FatCod = @FatCod

Union all

	select 
		HOU.HAWB_HIO HAWB, HOU.MAWB_HIO MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_LIO ETA, LLP.ETD_LIO ETD, FAT.FatDtVenc, PS.Nome_Raz_Soc, EN.Rua, EN.Numero, EN.Bairro, EN.Cidade, EN.UF, EN.Pais, PS.Num_CPF_CNPJ, FAT.FatObs
	from 
		Fatura_Draft FAT with(nolock)
		join Pessoa PS with(nolock) on FAT.cd_pes = PS.cd_pes and PS.Desat_pes = 'N'
		join Endereco EN with(nolock) on PS.CD_PEs = EN.Cd_Pes and EN.cd_tp_end = 'COM'
		join House_Imp_Out HOU with(nolock) on left(FAT.FatCod,16) = HOU.Num_Proc_HIO
		join Localidade ORG with(nolock) on HOU.CD_Org_HIO = ORG.Cd_Local
		join Localidade DST with(nolock) on HOU.CD_Dst_HIO = DST.Cd_Local
		join LLP_Imp_Out LLP with(nolock) on HOU.Num_proc_HIO = LLP.Num_Proc_LIO
	where 
		FAT.FatCod = @FatCod

Union all

	select 
		HOU.HAWB_HEM HAWB, HOU.MAWB_HEM MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_Lem ETA, LLP.ETD_Lem ETD, FAT.FatDtVenc, PS.Nome_Raz_Soc, EN.Rua, EN.Numero, EN.Bairro, EN.Cidade, EN.UF, EN.Pais, PS.Num_CPF_CNPJ, FAT.FatObs  
	from 
		Fatura_Draft FAT with(nolock)
		join Pessoa PS with(nolock) on FAT.cd_pes = PS.cd_pes and PS.Desat_pes = 'N'
		join Endereco EN with(nolock) on PS.CD_PEs = EN.Cd_Pes and EN.cd_tp_end = 'COM'
		join House_exp_mar HOU with(nolock) on left(FAT.FatCod,16) = HOU.Num_Proc_HEM
		join Localidade ORG with(nolock) on HOU.CD_Org_HEM = ORG.Cd_Local
		join Localidade DST with(nolock) on HOU.CD_Dst_HEM = DST.Cd_Local
		join LLP_exp_mar LLP with(nolock) on HOU.Num_proc_HEM = LLP.Num_Proc_Lem
	where 
		FAT.FatCod = @FatCod

Union all

	select 
		HOU.HAWB_hea HAWB, HOU.MAWB_hea MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_lea ETA, LLP.ETD_lea ETD, FAT.FatDtVenc, PS.Nome_Raz_Soc, EN.Rua, EN.Numero, EN.Bairro, EN.Cidade, EN.UF, EN.Pais, PS.Num_CPF_CNPJ, FAT.FatObs  
	from 
		Fatura_Draft FAT with(nolock)
		join Pessoa PS with(nolock) on FAT.cd_pes = PS.cd_pes and PS.Desat_pes = 'N'
		join Endereco EN with(nolock) on PS.CD_PEs = EN.Cd_Pes and EN.cd_tp_end = 'COM'
		join House_exp_aer HOU with(nolock) on left(FAT.FatCod,16) = HOU.Num_Proc_hea
		join Localidade ORG with(nolock) on HOU.CD_Org_hea = ORG.Cd_Local
		join Localidade DST with(nolock) on HOU.CD_Dst_hea = DST.Cd_Local
		join LLP_exp_aer LLP with(nolock) on HOU.Num_proc_hea = LLP.Num_Proc_lea
	where 
		FAT.FatCod = @FatCod

Union all

	select 
		HOU.HAWB_heo HAWB, HOU.MAWB_heo MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_leo ETA, LLP.ETD_leo ETD, FAT.FatDtVenc, PS.Nome_Raz_Soc, EN.Rua, EN.Numero, EN.Bairro, EN.Cidade, EN.UF, EN.Pais, PS.Num_CPF_CNPJ, FAT.FatObs
	from 
		Fatura_Draft FAT with(nolock)
		join Pessoa PS with(nolock) on FAT.cd_pes = PS.cd_pes and PS.Desat_pes = 'N'
		join Endereco EN with(nolock) on PS.CD_PEs = EN.Cd_Pes and EN.cd_tp_end = 'COM'
		join House_exp_out HOU with(nolock) on left(FAT.FatCod,16) = HOU.Num_Proc_heo
		join Localidade ORG with(nolock) on HOU.CD_Org_heo = ORG.Cd_Local
		join Localidade DST with(nolock) on HOU.CD_Dst_heo = DST.Cd_Local
		join LLP_exp_out LLP with(nolock) on HOU.Num_proc_heo = LLP.Num_Proc_leo
	where 
		FAT.FatCod = @FatCod
	
UNION ALL

	select 
		HOU.MAWB_MEA HAWB, HOU.MAWB_MEA MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_Master ETA, LLP.ETD_Master ETD, FAT.FatDtVenc, PS.Nome_Raz_Soc, EN.Rua, EN.Numero, EN.Bairro, EN.Cidade, EN.UF, EN.Pais, PS.Num_CPF_CNPJ, FAT.FatObs		
	from 
		Fatura_Draft FAT with(nolock)
		join Pessoa PS with(nolock) on FAT.cd_pes = PS.cd_pes and PS.Desat_pes = 'N'
		join Endereco EN with(nolock) on PS.CD_PEs = EN.Cd_Pes and EN.cd_tp_end = 'COM'
		join Master_Exp_Aer HOU with(nolock) on left(FAT.FatCod,14) = HOU.Num_Proc_MEA
		join Localidade ORG with(nolock) on HOU.Cd_Org_MEA = ORG.Cd_Local
		join Localidade DST with(nolock) on HOU.CD_Dst_mea = DST.Cd_Local
		join LLP_Master LLP with(nolock) on HOU.Num_proc_mea = LLP.Num_Proc_Master
	where 
		FAT.FatCod = @FatCod








GO

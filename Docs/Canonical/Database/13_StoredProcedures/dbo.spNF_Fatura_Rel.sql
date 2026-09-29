SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spNF_Fatura_Rel]--20
	
	@ID int

as
	select distinct
		Numero_fat,HOU.HAWB_HIM HAWB,HOU.MAWB_HIM MAWB, ORG.Nome_Local Origem,DST.Nome_Local Destino,LLP.ETA_LIM ETA,LLP.ETD_Lim ETD, 
		NF.Prazo,NF.Razao_Social Nome_Raz_Soc,NF.Endereco Rua,NF.Numero,NF.Bairro,NF.Cidade,NF.UF,NF.Pais,NF.Num_CPF_CNPJ,NF.Observ_NF FatObs,
		NF.Emissao,NF.Atencao
	from 
		NF_Fatura NF
		join NF_Fatura_Item NFI on NFI.id = NF.ID
		join House_Imp_Mar HOU on NFI.num_proc = HOU.Num_Proc_Him
		join Localidade ORG on HOU.CD_Org_Him = ORG.Cd_Local
		join Localidade DST on HOU.CD_Dst_Him = DST.Cd_Local
		join LLP_Imp_Mar LLP on HOU.Num_proc_him = LLP.Num_Proc_Lim
	where 
		NF.ID = @ID
	
Union all

	select distinct
		Numero_fat,HOU.HAWB_HIA HAWB, HOU.MAWB_HIA MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_lia ETA, LLP.ETD_lia ETD,
		NF.Prazo,NF.Razao_Social Nome_Raz_Soc,NF.Endereco Rua,NF.Numero,NF.Bairro,NF.Cidade,NF.UF,NF.Pais,NF.Num_CPF_CNPJ,NF.Observ_NF FatObs 
		,NF.Emissao ,NF.Atencao
	from 
		NF_Fatura NF
		join NF_Fatura_Item NFI on NFI.id = NF.ID
		join House_Imp_aer HOU on NFI.num_proc = HOU.Num_Proc_HIA
		join Localidade ORG on HOU.CD_Org_HIA = ORG.Cd_Local
		join Localidade DST on HOU.CD_Dst_HIA = DST.Cd_Local
		join LLP_Imp_aer LLP on HOU.Num_proc_HIA = LLP.Num_Proc_lia
	where 
		NF.ID = @ID

Union all

	select distinct 
		Numero_fat,HOU.HAWB_HIO HAWB, HOU.MAWB_HIO MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_LIO ETA, LLP.ETD_LIO ETD,
		NF.Prazo,NF.Razao_Social Nome_Raz_Soc,NF.Endereco Rua,NF.Numero,NF.Bairro,NF.Cidade,NF.UF,NF.Pais,NF.Num_CPF_CNPJ,NF.Observ_NF FatObs 
		,NF.Emissao,NF.Atencao 
	from 
		NF_Fatura NF
		join NF_Fatura_Item NFI on NFI.id = NF.ID
		join House_Imp_Out HOU on NFI.num_proc = HOU.Num_Proc_HIO
		join Localidade ORG on HOU.CD_Org_HIO = ORG.Cd_Local
		join Localidade DST on HOU.CD_Dst_HIO = DST.Cd_Local
		join LLP_Imp_Out LLP on HOU.Num_proc_HIO = LLP.Num_Proc_LIO
	where 
		NF.ID = @ID

Union all

	
	select distinct 
		Numero_fat,HOU.HAWB_HEM HAWB, HOU.MAWB_HEM MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_Lem ETA, LLP.ETD_Lem ETD,
		NF.Prazo,NF.Razao_Social Nome_Raz_Soc,NF.Endereco Rua,NF.Numero,NF.Bairro,NF.Cidade,NF.UF,NF.Pais,NF.Num_CPF_CNPJ,NF.Observ_NF FatObs 
		,NF.Emissao ,NF.Atencao
	from 
		NF_Fatura NF
		join NF_Fatura_Item NFI on NFI.id = NF.ID
		join House_exp_mar HOU on NFI.num_proc = HOU.Num_Proc_HEM
		join Localidade ORG on HOU.CD_Org_HEM = ORG.Cd_Local
		join Localidade DST on HOU.CD_Dst_HEM = DST.Cd_Local
		join LLP_exp_mar LLP on HOU.Num_proc_HEM = LLP.Num_Proc_Lem
	where 
		NF.ID = @ID

Union all

	
	select distinct
		Numero_fat,HOU.HAWB_hea HAWB, HOU.MAWB_hea MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_lea ETA, LLP.ETD_lea ETD,
		NF.Prazo,NF.Razao_Social Nome_Raz_Soc,NF.Endereco Rua,NF.Numero,NF.Bairro,NF.Cidade,NF.UF,NF.Pais,NF.Num_CPF_CNPJ,NF.Observ_NF FatObs 
		,NF.Emissao,NF.Atencao 
	from 
		NF_Fatura NF
		join NF_Fatura_Item NFI on NFI.id = NF.ID
		join House_exp_aer HOU on NFI.num_proc = HOU.Num_Proc_hea
		join Localidade ORG on HOU.CD_Org_hea = ORG.Cd_Local
		join Localidade DST on HOU.CD_Dst_hea = DST.Cd_Local
		join LLP_exp_aer LLP on HOU.Num_proc_hea = LLP.Num_Proc_lea
	where 
		NF.ID = @ID

Union all

	select distinct
		Numero_fat,HOU.HAWB_heo HAWB, HOU.MAWB_heo MAWB, ORG.Nome_Local Origem, DST.Nome_Local Destino, LLP.ETA_leo ETA, LLP.ETD_leo ETD,
		NF.Prazo,NF.Razao_Social Nome_Raz_Soc,NF.Endereco Rua,NF.Numero,NF.Bairro,NF.Cidade,NF.UF,NF.Pais,NF.Num_CPF_CNPJ,NF.Observ_NF FatObs 
		,NF.Emissao,NF.Atencao 
	from 
		NF_Fatura NF
		join NF_Fatura_Item NFI on NFI.id = NF.ID
		join House_exp_out HOU on NFI.num_proc = HOU.Num_Proc_heo
		join Localidade ORG on HOU.CD_Org_heo = ORG.Cd_Local
		join Localidade DST on HOU.CD_Dst_heo = DST.Cd_Local
		join LLP_exp_out LLP on HOU.Num_proc_heo = LLP.Num_Proc_leo
	where 
		NF.ID = @ID
		
UNION ALL

	select distinct
		Numero_fat,	
		V.HAWB HAWB,V.MAWB MAWB, ORG.Nome_Local Origem,DST.Nome_Local Destino,V.ETA ETA,V.ETD ETD, 
		NF.Prazo,NF.Razao_Social Nome_Raz_Soc,NF.Endereco Rua,NF.Numero,NF.Bairro,NF.Cidade,NF.UF,NF.Pais,NF.Num_CPF_CNPJ,
		NF.Observ_NF FatObs,NF.Emissao,NF.Atencao
	from 
		NF_Fatura NF
		join NF_Fatura_Item NFI on NFI.id = NF.ID
		join House_BDP_OUT HOU on NFI.num_proc = HOU.Num_Proc_HBO		
		join LLP_BDP_OUT LLP on HOU.Num_Proc_HBO = LLP.Num_Proc_LBO
		left join JOB_HBO J on J.Num_Proc_HBO = HOU.Num_Proc_HBO
		Left join vwCliente_Alerta V on V.num_proc = J.Num_Proc
		left join Localidade ORG on ORG.Cd_Local = V.cd_org
		left join Localidade Dst on DST.Cd_Local = V.cd_dst
	where 
		NF.ID = @ID
	








GO

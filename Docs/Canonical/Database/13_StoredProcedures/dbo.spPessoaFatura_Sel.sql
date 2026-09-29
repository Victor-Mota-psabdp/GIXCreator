SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido pra não trazer casos com Sol Pagamento - Cadu 4/4/15
--spPessoaFatura_Sel 'EAGRU201307009'

--select * from Tipo_Campo_Cliente where Id_Campo =143
--select * from BDP_Produto
--1	CHB
--2	Freight Forward
--3	CHB + Freight Forward
--spPessoaFatura_Sel 'IMATL201606123BR'

--26-10-2016 - incluido p trazer o master
--[spPessoaFatura_Sel]'EAGRU201610007'

CREATE procedure [dbo].[spPessoaFatura_Sel] --'EMATL20100303401'

	@Processo varchar(16)
as

	
declare @ID_PD int

if len(@Processo)= 16
	set @ID_PD  = (select Campo_Dados from Campo_Processo with(nolock) where Id_Campo = 143 and Num_Proc = @Processo)
else
	set @ID_PD  = (select CP.Campo_Dados from [vwCliente_Alerta] V with(nolock) 
					join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143
					where V.Master = @Processo)


if @ID_PD = 2 or @ID_PD = 3
	BEGIN
		if len(@Processo) = 16
			BEGIN
				SELECT
					distinct
					PS.apelido 	PESSOA,
					CXA.num_proc_him 
				FROM
					Cta_Cte_Hou_imp_mar CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_him = PS.cd_pes
					Left join Caixa_Hou_imp_mar CXA with(nolock) on	CC.num_proc_him	= CXA.num_proc_him and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_him = CXA.dc_him and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock) on CC.num_proc_HIM = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_him = FAT.dc
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIM and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIM	
					left join LLP_Imp_Mar LLP with(nolock) on LLP.Num_Proc_Lim = CC.num_proc_him
				WHERE 
					CC.Num_Proc_him =@Processo --and CXA.num_proc_him is null 
					and F.cd_pes is null
					and S.ID is null
					and LLp.ATA_Lim is not null

			UNION

				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_hia 
				FROM
					Cta_Cte_Hou_imp_aer CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_hia = PS.cd_pes
					Left join Caixa_Hou_imp_aer CXA with(nolock) on	CC.num_proc_hia	= CXA.num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock) on CC.num_proc_HIA = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hia = FAT.dc
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA
					left join LLP_Imp_Aer LLP with(nolock) on LLP.Num_Proc_Lia = CC.num_proc_hia
				WHERE 
					CC.Num_Proc_hia =@Processo --and CXA.num_proc_hia is null 
					and F.cd_pes is null
					and S.ID is null
					and LLp.ATA_LIA is not null
				
			UNION

				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_hio 
				FROM
					Cta_Cte_Hou_imp_out CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_hio = PS.cd_pes
					Left join Caixa_Hou_imp_out CXA with(nolock) on	CC.num_proc_hio	= CXA.num_proc_hio and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hio = CXA.dc_hio and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock) on CC.num_proc_HIo = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hio = FAT.dc
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIO and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIO
					left join LLP_Imp_Out LLP with(nolock) on LLP.Num_Proc_Lio = CC.Num_Proc_HIO
				WHERE 
					CC.Num_Proc_hio =@Processo --and CXA.num_proc_hio is null 
					and F.cd_pes is null
					and S.ID is null
					and LLp.ATA_LIo is not null
			
			UNION

				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_hem 
				FROM
					Cta_Cte_Hou_exp_mar CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_hem = PS.cd_pes
					Left join Caixa_Hou_exp_mar CXA with(nolock) on	CC.num_proc_hem	= CXA.num_proc_hem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hem = CXA.dc_hem and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock) on CC.num_proc_Hem = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hem = FAT.dc
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HEM and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_Hem
					left join LLP_Exp_Mar LLP with(nolock) on LLP.Num_Proc_Lem = CC.Num_Proc_HEM
				WHERE 
					CC.Num_Proc_hem =@Processo --and CXA.num_proc_hem is null 
					and F.cd_pes is null
					and S.ID is null
					and LLp.ATD_Lem is not null	
			
			UNION

				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_hea 
				FROM
					Cta_Cte_Hou_exp_aer CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_hea = PS.cd_pes
					Left join Caixa_Hou_exp_aer CXA with(nolock) on	CC.num_proc_hea	= CXA.num_proc_hea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hea = CXA.dc_hea and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock) on CC.num_proc_Hea = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc 
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock)on S.num_proc=cc.Num_Proc_HEA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HEA
					left join LLP_Exp_Aer LLP with(nolock) on LLP.Num_Proc_Lea = CC.Num_Proc_HEA
				WHERE 
					CC.Num_Proc_hea =@Processo --and CXA.num_proc_hea is null 
					and F.cd_pes is null
					and S.ID is null
					and LLp.ATD_LeA is not null	
			
			UNION

				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_heo 
				FROM
					Cta_Cte_Hou_exp_out CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_heo = PS.cd_pes
					Left join Caixa_Hou_exp_out CXA with(nolock) on	CC.num_proc_heo	= CXA.num_proc_heo and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_heo = CXA.dc_heo and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock)on CC.num_proc_Heo = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_heo = FAT.dc
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HEO and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HEO
					left join LLP_Exp_Out LLP with(nolock) on LLP.Num_Proc_Leo = CC.Num_Proc_HEO
				WHERE 
					CC.Num_Proc_heo =@Processo --and CXA.num_proc_heo is null 
					and F.cd_pes is null
					and S.ID is null
					and LLp.ATD_Leo is not null
			END
		else
			BEGIN
				SELECT
					distinct
						PS.apelido 			PESSOA,
						CXA.num_proc_mea 
					FROM
						Cta_Cte_mas_exp_aer CC with(nolock)
						left join pessoa PS	with(nolock) on CC.cd_cred_dev_mea = PS.cd_pes
						Left join Caixa_mas_exp_aer CXA with(nolock) on	CC.num_proc_mea	= CXA.num_proc_mea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mea = CXA.dc_mea and Num_LCto <> 'PROVISÓRIO'
						Left Join Item_Fat FAT with(nolock) on CC.num_proc_mea = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_mea = FAT.dc 
						Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
						Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
						Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_MEA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_MEA
						left join LLP_Master LLP with(nolock) on LLP.Num_Proc_Master = CC.Num_Proc_MEA
					WHERE
						CC.Num_Proc_mea =@Processo --and CXA.num_proc_mea is null 
						and F.cd_pes is null
						and S.ID is null
						and LLP.ATD_Master is not null
			END
		
	END


else if @ID_PD = 1

	BEGIN
		if len(@Processo) = 16
			BEGIN
				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_him 
				FROM
					Cta_Cte_Hou_imp_mar CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_him = PS.cd_pes
					Left join Caixa_Hou_imp_mar CXA with(nolock) on	CC.num_proc_him	= CXA.num_proc_him and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_him = CXA.dc_him and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock) on CC.num_proc_HIM = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_him = FAT.dc
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIM and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIM					
				WHERE 
					CC.Num_Proc_him =@Processo --and CXA.num_proc_him is null 
					and F.cd_pes is null
					and S.ID is null				

			UNION

				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_hia 
				FROM
					Cta_Cte_Hou_imp_aer CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_hia = PS.cd_pes
					Left join Caixa_Hou_imp_aer CXA with(nolock) on	CC.num_proc_hia	= CXA.num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock) on CC.num_proc_HIA = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hia = FAT.dc
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA				
				WHERE 
					CC.Num_Proc_hia =@Processo --and CXA.num_proc_hia is null 
					and F.cd_pes is null
					and S.ID is null				
				
			UNION

				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_hio 
				FROM
					Cta_Cte_Hou_imp_out CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_hio = PS.cd_pes
					Left join Caixa_Hou_imp_out CXA with(nolock) on	CC.num_proc_hio	= CXA.num_proc_hio and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hio = CXA.dc_hio and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock) on CC.num_proc_HIo = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hio = FAT.dc
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock)on S.num_proc=cc.Num_Proc_HIO and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIO				
				WHERE 
					CC.Num_Proc_hio =@Processo --and CXA.num_proc_hio is null 
					and F.cd_pes is null
					and S.ID is null				
			
			UNION

				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_hem 
				FROM
					Cta_Cte_Hou_exp_mar CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_hem = PS.cd_pes
					Left join Caixa_Hou_exp_mar CXA with(nolock) on	CC.num_proc_hem	= CXA.num_proc_hem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hem = CXA.dc_hem and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock) on CC.num_proc_Hem = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hem = FAT.dc
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HEM and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_Hem				
				WHERE 
					CC.Num_Proc_hem =@Processo --and CXA.num_proc_hem is null 
					and F.cd_pes is null
					and S.ID is null				
			
			UNION

				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_hea 
				FROM
					Cta_Cte_Hou_exp_aer CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_hea = PS.cd_pes
					Left join Caixa_Hou_exp_aer CXA with(nolock) on	CC.num_proc_hea	= CXA.num_proc_hea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hea = CXA.dc_hea and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock) on CC.num_proc_Hea = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc 
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock)on S.num_proc=cc.Num_Proc_HEA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HEA				
				WHERE 
					CC.Num_Proc_hea =@Processo --and CXA.num_proc_hea is null 
					and F.cd_pes is null
					and S.ID is null					
			
			UNION

				SELECT
					distinct
					PS.apelido 			PESSOA,
					CXA.num_proc_heo 
				FROM
					Cta_Cte_Hou_exp_out CC with(nolock)
					left join pessoa PS	with(nolock) on CC.cd_cred_dev_heo = PS.cd_pes
					Left join Caixa_Hou_exp_out CXA with(nolock) on	CC.num_proc_heo	= CXA.num_proc_heo and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_heo = CXA.dc_heo and Num_LCto <> 'PROVISÓRIO'
					Left Join Item_Fat FAT with(nolock)on CC.num_proc_Heo = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_heo = FAT.dc
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
					Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HEO and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HEO				
				WHERE 
					CC.Num_Proc_heo =@Processo --and CXA.num_proc_heo is null 
					and F.cd_pes is null
					and S.ID is null
			END
		else
			BEGIN
				SELECT
					distinct
						PS.apelido 			PESSOA,
						CXA.num_proc_mea 
					FROM
						Cta_Cte_mas_exp_aer CC with(nolock)
						left join pessoa PS	with(nolock) on CC.cd_cred_dev_mea = PS.cd_pes
						Left join Caixa_mas_exp_aer CXA with(nolock) on	CC.num_proc_mea	= CXA.num_proc_mea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mea = CXA.dc_mea and Num_LCto <> 'PROVISÓRIO'
						Left Join Item_Fat FAT with(nolock)on CC.num_proc_mea = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_mea = FAT.dc 
						Left Join Fatura F with(nolock) on F.FatCod=FAT.FatCod and F.FatStatus = 1
						Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=PS.cd_pes and tipo='C'
						Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_MEA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_MEA					
					WHERE
						CC.Num_Proc_mea =@Processo --and CXA.num_proc_mea is null 
						and F.cd_pes is null
						and S.ID is null
						
			END
	END

/*
--incluido pra não trazer casos com Sol Pagamento - Cadu 4/4/15
--spPessoaFatura_Sel 'EAGRU201307009'


ALTER procedure [dbo].[spPessoaFatura_Sel] --'EMATL20100303401'

	@Processo varchar(16)

as

if len(@Processo) = 16
	BEGIN
		SELECT
			distinct
			PS.apelido 			PESSOA,
			CXA.num_proc_him 
		FROM
			Cta_Cte_Hou_imp_mar CC
			left join pessoa PS	on CC.cd_cred_dev_him = PS.cd_pes
			Left join Caixa_Hou_imp_mar CXA on	CC.num_proc_him	= CXA.num_proc_him and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_him = CXA.dc_him and Num_LCto <> 'PROVISÓRIO'
			Left Join Item_Fat FAT on CC.num_proc_HIM = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_him = FAT.dc
			Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
			Join Pessoa_Atl_AX AX on AX.cd_pes=PS.cd_pes and tipo='C'
			Left join vwSolPgtoCtaCteAprovadas S on S.num_proc=cc.Num_Proc_HIM and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIM
		WHERE 
			CC.Num_Proc_him =@Processo --and CXA.num_proc_him is null 
			and F.cd_pes is null
			and S.ID is null

		Union

		SELECT
			distinct
			PS.apelido 			PESSOA,
			CXA.num_proc_hia 
		FROM
			Cta_Cte_Hou_imp_aer CC
			left join pessoa PS	on CC.cd_cred_dev_hia = PS.cd_pes
			Left join Caixa_Hou_imp_aer CXA on	CC.num_proc_hia	= CXA.num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia and Num_LCto <> 'PROVISÓRIO'
			Left Join Item_Fat FAT on CC.num_proc_HIA = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hia = FAT.dc
			Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
			Join Pessoa_Atl_AX AX on AX.cd_pes=PS.cd_pes and tipo='C'
			Left join vwSolPgtoCtaCteAprovadas S on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA

		WHERE 
			CC.Num_Proc_hia =@Processo --and CXA.num_proc_hia is null 
			and F.cd_pes is null
			and S.ID is null
			
		Union

		SELECT
			distinct
			PS.apelido 			PESSOA,
			CXA.num_proc_hio 
		FROM
			Cta_Cte_Hou_imp_out CC
			left join pessoa PS	on CC.cd_cred_dev_hio = PS.cd_pes
			Left join Caixa_Hou_imp_out CXA on	CC.num_proc_hio	= CXA.num_proc_hio and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hio = CXA.dc_hio and Num_LCto <> 'PROVISÓRIO'
			Left Join Item_Fat FAT on CC.num_proc_HIo = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hio = FAT.dc
			Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
			Join Pessoa_Atl_AX AX on AX.cd_pes=PS.cd_pes and tipo='C'
			Left join vwSolPgtoCtaCteAprovadas S on S.num_proc=cc.Num_Proc_HIO and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIO

		WHERE 
			CC.Num_Proc_hio =@Processo --and CXA.num_proc_hio is null 
			and F.cd_pes is null
			and S.ID is null
			
		union

		SELECT
			distinct
			PS.apelido 			PESSOA,
			CXA.num_proc_hem 
		FROM
			Cta_Cte_Hou_exp_mar CC
			left join pessoa PS	on CC.cd_cred_dev_hem = PS.cd_pes
			Left join Caixa_Hou_exp_mar CXA on	CC.num_proc_hem	= CXA.num_proc_hem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hem = CXA.dc_hem and Num_LCto <> 'PROVISÓRIO'
			Left Join Item_Fat FAT on CC.num_proc_Hem = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hem = FAT.dc
			Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
			Join Pessoa_Atl_AX AX on AX.cd_pes=PS.cd_pes and tipo='C'
			Left join vwSolPgtoCtaCteAprovadas S on S.num_proc=cc.Num_Proc_HEM and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_Hem

		WHERE 
			CC.Num_Proc_hem =@Processo --and CXA.num_proc_hem is null 
			and F.cd_pes is null
			and S.ID is null
			
		union

		SELECT
			distinct
			PS.apelido 			PESSOA,
			CXA.num_proc_hea 
		FROM
			Cta_Cte_Hou_exp_aer CC
			left join pessoa PS	on CC.cd_cred_dev_hea = PS.cd_pes
			Left join Caixa_Hou_exp_aer CXA on	CC.num_proc_hea	= CXA.num_proc_hea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hea = CXA.dc_hea and Num_LCto <> 'PROVISÓRIO'
			Left Join Item_Fat FAT on CC.num_proc_Hea = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc 
			Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
			Join Pessoa_Atl_AX AX on AX.cd_pes=PS.cd_pes and tipo='C'
			Left join vwSolPgtoCtaCteAprovadas S on S.num_proc=cc.Num_Proc_HEA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HEA

		WHERE 
			CC.Num_Proc_hea =@Processo --and CXA.num_proc_hea is null 
			and F.cd_pes is null
			and S.ID is null
			
		union

		SELECT
			distinct
			PS.apelido 			PESSOA,
			CXA.num_proc_heo 
		FROM
			Cta_Cte_Hou_exp_out CC
			left join pessoa PS	on CC.cd_cred_dev_heo = PS.cd_pes
			Left join Caixa_Hou_exp_out CXA on	CC.num_proc_heo	= CXA.num_proc_heo and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_heo = CXA.dc_heo and Num_LCto <> 'PROVISÓRIO'
			Left Join Item_Fat FAT on CC.num_proc_Heo = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_heo = FAT.dc
			Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
			Join Pessoa_Atl_AX AX on AX.cd_pes=PS.cd_pes and tipo='C'
			Left join vwSolPgtoCtaCteAprovadas S on S.num_proc=cc.Num_Proc_HEO and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HEO

		WHERE 
			CC.Num_Proc_heo =@Processo --and CXA.num_proc_heo is null 
			and F.cd_pes is null
			and S.ID is null
			
	END
else
	BEGIN
	SELECT
		distinct
			PS.apelido 			PESSOA,
			CXA.num_proc_mea 
		FROM
			Cta_Cte_mas_exp_aer CC
			left join pessoa PS	on CC.cd_cred_dev_mea = PS.cd_pes
			Left join Caixa_mas_exp_aer CXA on	CC.num_proc_mea	= CXA.num_proc_mea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mea = CXA.dc_mea and Num_LCto <> 'PROVISÓRIO'
			Left Join Item_Fat FAT on CC.num_proc_mea = FAT.Num_Proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_mea = FAT.dc 
			Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
			Join Pessoa_Atl_AX AX on AX.cd_pes=PS.cd_pes and tipo='C'
			Left join vwSolPgtoCtaCteAprovadas S on S.num_proc=cc.Num_Proc_MEA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_MEA
		WHERE 

			CC.Num_Proc_mea =@Processo --and CXA.num_proc_mea is null 
			and F.cd_pes is null
			and S.ID is null
	END
	

*/
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spReportConsolidadoNEW_FEDER] '2014-01-01','2014-08-31','%','%','SCHOSS','%','US Dollar','%','M','ALL'
--select * from cta_cte_hou_exp_mar where num_proc_hem = 'EMFLT201402007AR'

--NO Master estaa comentado o and pp.Apelido like - 11/06/2014
--select dbo.verparidade(convert(varchar(10),'2014-06-13 00:00:00.000',103),'USD','OFC')
--select convert(varchar(10),'2014-06-13 00:00:00.000',101)

create Procedure [dbo].[spReportConsolidadoNEW_FEDER] 
--'2014-01-01','2014-12-31','%','%','%','IMBUE201405056','US Dollar','%','M','ALL'

			@DataInicial	Char(10),
			@DataFinal		Char(10),
			@Modal			Varchar(2),
			@Localidade		Varchar(30),
			@Cliente		Varchar(50),
			@Num_Proc		Varchar(16),
			@currency		varchar(20),
			@nome_tp_tx		varchar(50),
			@tipo			char(1),
			@status			varchar(50)

as	
	
	Declare @Moeda varchar(3)
	set @moeda = (select cd_tp_moeda from tipo_moeda where Nome_tp_moeda = @currency)		

	IF @tipo = 'H'

		BEGIN

		--Importação Maritima
				Select 
					HOU.NUM_PROC_HIM Processo,
					isnull(LLP.id_status,0) [status],
					Upper(pp.Apelido) Cliente,
					TT.Nome_tp_tx,
					DST.Nome_Local,
					cta.dc_him dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_HIM,cta.dc_HIM) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda, 
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF,  
					CREDEV.Apelido CredorDevedor, 
					CTA.num_DCN_him Num_INV, 
					CTA.Dt_Prev_Pgto_him Dt_INV,						
					HOU.NUM_PROC_HIM SomaMaster			
					
					
				From 
					cta_cte_hou_imp_mar CTA	
					Join House_Imp_MAR HOU on cta.num_proc_him=HOU.num_proc_HIM
					Join LLP_Imp_MAR LLP on cta.num_proc_him=LLP.num_proc_LIM
					Join Pessoa pp on pp.cd_pes=HOU.cd_consig_HIM
					Join Localidade DST on DST.cd_local=HOU.cd_dst_HIM		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'	
					left join vwcxas CXA on cta.num_proc_him=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_him
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_him and FAT.status = 'I' and cta.ref_acesso_nf_him = fat.codigo
		--			left join item_Fat iFAT on iFAT.Num_Proc = cta.num_proc_him and iFAT.cd_tp_tx = CTA.cd_tp_tx and iFAT.DC = CTA.dc_hia
		--			left join fatura iFA on IFA.fatcod=iFAT.fatcod and iFA.fatstatus='1'
				where 
					cta.num_proc_him like @num_proc
					and cta.desp_org_HIM='N' 
					and convert(datetime,dt_emis_HIM,105) between @DataInicial and @DataFinal
					and left(hou.num_proc_him,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente					
					and nome_tp_tx like @nome_tp_tx					
					--and isnull(LLP.id_status,0) <> 9					
					and ((@status = 'Open' and (isnull(LLP.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LLP.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LLP.id_status,0) <> 9))	
															

			UNION ALL

		--Importação Aerea
				Select 
					HOU.NUM_PROC_HIA Processo,
					isnull(LLP.id_status,0) [status],
					Upper(pp.Apelido) Cliente,
					Nome_tp_tx,
					Nome_Local,
					cta.dc_hia dc_Hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_HIa,cta.dc_HIa) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda, 
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF,  
					CREDEV.Apelido CredorDevedor, 
					CTA.num_DCN_hia Num_INV, 
					CTA.Dt_Prev_Pgto_hia Dt_INV,
					HOU.NUM_PROC_HIA SomaMaster
				From 
					cta_cte_hou_imp_aer CTA	
					Join House_Imp_AER HOU on cta.num_proc_hia=HOU.num_proc_HIA
					Join LLP_Imp_AER LLP on cta.num_proc_hia=LLP.num_proc_LIA
					Join Pessoa pp on pp.cd_pes=HOU.cd_consig_HIA
					Join Localidade DST on DST.cd_local=HOU.cd_dst_HIA		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'
					left join vwcxas CXA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia		
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_hia
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_hia and FAT.status = 'I' and cta.ref_acesso_nf_hia = fat.codigo
		--			left join item_Fat iFAT on iFAT.Num_Proc = CTA.num_proc_hia and iFAT.cd_tp_tx = CTA.cd_tp_tx and iFAT.DC = CTA.dc_hia
		--			left join fatura iFA on IFA.fatcod=iFAT.fatcod and iFA.fatstatus='1'
				where 
					cta.num_proc_hia like @num_proc
					and cta.desp_org_HIA='N' 
					and convert(datetime,dt_emis_HIA,105) between @DataInicial and @DataFinal
					and left(hou.num_proc_hia,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente					
					and nome_tp_tx like @nome_tp_tx	
					--and isnull(LLP.id_status,0) <> 9
					and ((@status = 'Open' and (isnull(LLP.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LLP.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LLP.id_status,0) <> 9))	

				UNION ALL
			--Importação Outros
				Select 
					HOU.NUM_PROC_HIO Processo,
					isnull(LLP.id_status,0) [status],
					Upper(pp.Apelido) Cliente,
					Nome_tp_tx,
					Nome_Local,
					cta.dc_hio dc_Hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_HIo,cta.dc_HIo) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda, 
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF,  
					CREDEV.Apelido CredorDevedor,
					CTA.num_DCN_hio Num_INV, 
					CTA.Dt_Prev_Pgto_hio Dt_INV,
					HOU.NUM_PROC_HIO SomaMaster
				From 
					cta_cte_hou_imp_out CTA	
					Join House_Imp_OUT HOU on cta.num_proc_hio=HOU.num_proc_HIO
					Join LLP_Imp_OUT LLP on cta.num_proc_hio=LLP.num_proc_LIO
					Join Pessoa pp on pp.cd_pes=HOU.cd_consig_HIO
					Join Localidade DST on DST.cd_local=HOU.cd_dst_HIO		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'
					left join vwcxas CXA on cta.num_proc_hio=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_hio
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_hio and FAT.status = 'I' and cta.ref_acesso_nf_hio = fat.codigo
		--			left join item_Fat iFAT on iFAT.Num_Proc = cta.num_proc_hio and iFAT.cd_tp_tx = CTA.cd_tp_tx and iFAT.DC = CTA.dc_hia
		--			left join fatura iFA on IFA.fatcod=iFAT.fatcod and iFA.fatstatus='1'
				where 
					cta.num_proc_hio like @num_proc
					and cta.desp_org_HIo='N' 
					and convert(datetime,dt_emis_HIO,105) between @DataInicial and @DataFinal
					and left(hou.num_proc_hio,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente					
					and nome_tp_tx like @nome_tp_tx	
					--and isnull(LLP.id_status,0) <> 9
					and ((@status = 'Open' and (isnull(LLP.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LLP.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LLP.id_status,0) <> 9))	

				UNION ALL	

		--EXportação Maritima
				Select 
					HOU.NUM_PROC_HEM Processo,
					isnull(LLP.id_status,0) [status],
					Upper(pp.Apelido) Cliente,
					TT.Nome_tp_tx,
					DST.Nome_Local,
					cta.dc_hem dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_Hem,cta.dc_Hem) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda, 
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF,  
					CREDEV.Apelido CredorDevedor,
					CTA.num_DCN_hem Num_INV, 
					CTA.Dt_Prev_Pgto_hem Dt_INV,
					HOU.NUM_PROC_HEM SomaMaster
				From 
					cta_cte_hou_exp_mar CTA	
					Join House_Exp_MAR HOU on cta.num_proc_hem=HOU.num_proc_HEM
					Join LLP_Exp_MAR LLP on cta.num_proc_hem=LLP.num_proc_LEM		
					Join Pessoa pp on pp.cd_pes=HOU.cd_export_HEM
					Join Localidade DST on DST.cd_local=HOU.cd_org_HEM		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx	and rentabilidade <> 'N'
					left join vwcxas CXA on cta.num_proc_hem=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_hem
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_hem and FAT.status = 'I' and cta.ref_acesso_nf_hem = fat.codigo
		--			left join item_Fat iFAT on iFAT.Num_Proc = cta.num_proc_hem and iFAT.cd_tp_tx = CTA.cd_tp_tx and iFAT.DC = CTA.dc_hia
		--			left join fatura iFA on IFA.fatcod=iFAT.fatcod and iFA.fatstatus='1'
				where 
					cta.num_proc_hem like @num_proc
					and cta.desp_dst_Hem='N' 
					and convert(datetime,dt_emis_HEM,105) between @DataInicial and @DataFinal
					and left(hou.num_proc_hem,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente					
					and nome_tp_tx like @nome_tp_tx	
					--and isnull(LLP.id_status,0) <> 9
					and ((@status = 'Open' and (isnull(LLP.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LLP.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LLP.id_status,0) <> 9))

			UNION ALL

		--Exportação Aerea
				Select 
					HOU.NUM_PROC_HEA Processo,
					isnull(LLP.id_status,0) [status],
					Upper(pp.Apelido) Cliente,
					Nome_tp_tx,
					Nome_Local,
					cta.dc_hea dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_Hea,cta.dc_Hea) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda, 
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF,  
					CREDEV.Apelido CredorDevedor, 
					CTA.num_DCN_hea Num_INV, 
					CTA.Dt_Prev_Pgto_hea Dt_INV,
					HOU.NUM_PROC_HEA SomaMaster
				From 
					cta_cte_hou_exp_aer CTA	
					Join House_EXp_AER HOU on cta.num_proc_hea=HOU.num_proc_HEA
					Join LLP_Exp_AER LLP on cta.num_proc_hea=LLP.num_proc_LEA	
					Join Pessoa pp on pp.cd_pes=HOU.cd_export_HEA
					Join Localidade DST on DST.cd_local=HOU.cd_org_HEA		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx	and rentabilidade <> 'N'
					left join vwcxas CXA on cta.num_proc_hea=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_hea
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_hea and FAT.status = 'I' and cta.ref_acesso_nf_hea = fat.codigo
		--			left join item_Fat iFAT on iFAT.Num_Proc = cta.num_proc_hea and iFAT.cd_tp_tx = CTA.cd_tp_tx and iFAT.DC = CTA.dc_hia
		--			left join fatura iFA on IFA.fatcod=iFAT.fatcod and iFA.fatstatus='1'
				where 
					cta.num_proc_hea like @num_proc
					and cta.desp_dst_HEA='N' 
					and convert(datetime,dt_emis_HEA,105) between @DataInicial and @DataFinal
					and left(hou.num_proc_hea,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente					
					and nome_tp_tx like @nome_tp_tx	
					--and isnull(LLP.id_status,0) <> 9
					and ((@status = 'Open' and (isnull(LLP.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LLP.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LLP.id_status,0) <> 9))

				UNION ALL

		--Exportação Outros
				Select 
					HOU.NUM_PROC_HEO Processo,
					isnull(LLP.id_status,0) [status],
					Upper(pp.Apelido) Cliente,
					Nome_tp_tx,
					Nome_Local,
					cta.dc_heo dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_Heo,cta.dc_Heo) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda, 
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF,  
					CREDEV.Apelido CredorDevedor,
					CTA.num_DCN_heo Num_INV, 
					CTA.Dt_Prev_Pgto_heo Dt_INV, 
					HOU.NUM_PROC_HEO SomaMaster
				From 
					cta_cte_hou_exp_out CTA	
					Join House_Exp_OUT HOU on cta.num_proc_heo=HOU.num_proc_HEO	
					Join LLP_Exp_OUT LLP on cta.num_proc_heo=LLP.num_proc_LEO
					Join Pessoa pp on pp.cd_pes=HOU.cd_export_HEO
					Join Localidade DST on DST.cd_local=HOU.cd_org_HEO		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx	and rentabilidade <> 'N'
					left join vwcxas CXA on cta.num_proc_heo=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_heo
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_heo and FAT.status = 'I' and cta.ref_acesso_nf_heo = fat.codigo
		--			left join item_Fat iFAT on iFAT.Num_Proc = cta.num_proc_heo and iFAT.cd_tp_tx = CTA.cd_tp_tx and iFAT.DC = CTA.dc_hia
		--			left join fatura iFA on IFA.fatcod=iFAT.fatcod and iFA.fatstatus='1'
				where 
					cta.num_proc_heo like @num_proc
					and cta.desp_org_Heo='N' 
					and convert(datetime,dt_emis_HEO,105) between @DataInicial and @DataFinal
					and left(hou.num_proc_heo,2) like @Modal
					and nome_local like @Localidade					
					and pp.Apelido like @Cliente
					and nome_tp_tx like @nome_tp_tx
					and ((@status = 'Open' and (isnull(LLP.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LLP.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LLP.id_status,0) <> 9))


			order by 1					
			END
	
	ELSE

			BEGIN
			--Consolidated Sea - Importação - CTA HOUSE
				Select 
					MAS.NUM_PROC_MIM Processo,
					isnull(LLP.id_status,0) [status],
					Upper(pp.Apelido) Cliente,	
					TT.Nome_tp_tx,
					DST.Nome_Local,
					cta.dc_him dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_HIM,cta.dc_HIM) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda,
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF, 
					CREDEV.Apelido CredorDevedor,
					CTA.num_DCN_him Num_INV, 
					CTA.Dt_Prev_Pgto_him Dt_INV,
					(case when HOU.NUM_PROC_MIM = 'JOB' then
						HOU.NUM_PROC_HIM
					Else
						HOU.NUM_PROC_MIM end) SomaMaster
				From 
					house_imp_mar HOU					
					join LLP_IMP_MAR LLP on Hou.num_proc_him =LLP.num_proc_lim
					Join Master_Imp_mar MAS on MAS.num_proc_mim=HOU.num_proc_mim and hou.num_proc_mim <> 'JOB'	
					join LLP_Master LMAS on LMAS.num_proc_master = MAS.num_proc_mim			
					join cta_cte_hou_imp_mar CTA on CTA.num_proc_him = HOU.num_proc_him			
					Join Pessoa pp on pp.cd_pes=HOU.cd_consig_HIM
					Join Localidade DST on DST.cd_local=HOU.cd_dst_HIM		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'	
					left join vwcxas CXA on cta.num_proc_him=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_him
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_him and FAT.status = 'I' and cta.ref_acesso_nf_him = fat.codigo
				where 
					MAS.num_proc_mim like @num_proc
					and cta.desp_org_HIM='N' 
					and convert(datetime,dt_emis_HIM,105) between @DataInicial and @DataFinal
					and left(hou.num_proc_him,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente
					and nome_tp_tx like @nome_tp_tx	
					--and isnull(LLP.id_status,0) <> 9
					and ((@status = 'Open' and (isnull(LMAS.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LMAS.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LMAS.id_status,0) <> 9))
			UNION ALL
				--Consolidated Sea - Importação - CTA MASTER
				Select 
					MAS.NUM_PROC_MIM Processo,
					''[Status],
					'Consolidated' Cliente,
					TT.Nome_tp_tx,
					DST.Nome_Local,
					cta.dc_mim dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_mIM,cta.dc_mIM) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda,
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF,
					 CREDEV.Apelido CredorDevedor,
					 CTA.num_DCN_mim Num_INV, 
					CTA.Dt_Prev_Pgto_mim Dt_INV,
					MAS.num_proc_mim SomaMaster
					
					from Master_Imp_mar MAS
					join LLP_Master LMAS on LMAS.num_proc_master = MAS.num_proc_mim	
					join cta_cte_mas_imp_mar CTA on CTA.num_proc_mim = MAS.num_proc_mim		
					Join Pessoa pp on pp.cd_pes=MAS.cd_consig_MIM
					Join Localidade DST on DST.cd_local=MAS.cd_dst_MIM		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'	
					left join vwcxas CXA on cta.num_proc_mim=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_mim
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_mim and FAT.status = 'I' and cta.ref_acesso_nf_mim = fat.codigo
				where 
					MAS.num_proc_mim like @num_proc
					and cta.desp_org_MIM='N' 
					and convert(datetime,dt_emis_MIM,105) between @DataInicial and @DataFinal
					and left(MAS.num_proc_mim,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente
					and nome_tp_tx like @nome_tp_tx	
					and ((@status = 'Open' and (isnull(LMAS.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LMAS.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LMAS.id_status,0) <> 9))


			UNION ALL
				--Consolidated AIR - Importação - Cta House
				Select 
					MAS.NUM_PROC_MIA Processo,
					isnull(LLP.id_status,0) [status],
					Upper(pp.Apelido) Cliente,
					TT.Nome_tp_tx,
					DST.Nome_Local,
					cta.dc_hia dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_HIa,cta.dc_HIa) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda,
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF, 
					CREDEV.Apelido CredorDevedor,
					CTA.num_DCN_hia Num_INV, 
					CTA.Dt_Prev_Pgto_hia Dt_INV,
					(case when HOU.NUM_PROC_MIA = 'JOB' then
						HOU.NUM_PROC_HIA
					Else
						HOU.NUM_PROC_MIA end) SomaMaster	
				From 
					house_imp_aer HOU
					join LLP_IMP_AER LLP on Hou.num_proc_hia =LLP.num_proc_lia
					Join Master_Imp_aer MAS on MAS.num_proc_mia=HOU.num_proc_mia and hou.num_proc_mia <> 'JOB'
					join cta_cte_hou_imp_aer CTA on CTA.num_proc_hia = HOU.num_proc_hia
					Join Pessoa pp on pp.cd_pes=HOU.cd_consig_HIA
					Join Localidade DST on DST.cd_local=HOU.cd_dst_HIA		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'	
					left join vwcxas CXA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_hia
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_hia and FAT.status = 'I' and cta.ref_acesso_nf_hia = fat.codigo
				where 
					MAS.num_proc_mia like @num_proc
					and cta.desp_org_HIA='N' 
					and convert(datetime,dt_emis_HIA,105) between @DataInicial and @DataFinal
					and left(hou.num_proc_hia,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente
					and nome_tp_tx like @nome_tp_tx
					--and isnull(LLP.id_status,0) <> 9
					and ((@status = 'Open' and (isnull(LLP.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LLP.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LLP.id_status,0) <> 9))	
			UNION ALL
				--Consolidated AIR - Importação - Cta Master
				Select 
					MAS.NUM_PROC_MIA Processo,
					''[Status],
					'Consolidated' Cliente,
					TT.Nome_tp_tx,
					DST.Nome_Local,
					cta.dc_mia dc_mia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_mIa,cta.dc_mIa) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda,
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF, 
					CREDEV.Apelido CredorDevedor,
					CTA.num_DCN_mia Num_INV, 
					CTA.Dt_Prev_Pgto_mia Dt_INV,
					MAS.num_proc_mia SomaMaster
				From 
					Master_Imp_aer MAS
					join LLP_Master LMAS on LMAS.num_proc_master = MAS.num_proc_mia	
					join cta_cte_mas_imp_aer CTA on CTA.num_proc_mia = MAS.num_proc_mia
					Join Pessoa pp on pp.cd_pes=MAS.cd_consig_MIA
					Join Localidade DST on DST.cd_local=MAS.cd_dst_MIA		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'	
					left join vwcxas CXA on cta.num_proc_mia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_mia
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_mia and FAT.status = 'I' and cta.ref_acesso_nf_mia = fat.codigo
				where 
					MAS.num_proc_mia like @num_proc
					and cta.desp_org_MIA='N' 
					and convert(datetime,dt_emis_MIA,105) between @DataInicial and @DataFinal
					and left(MAS.num_proc_mia,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente
					and nome_tp_tx like @nome_tp_tx	
					and ((@status = 'Open' and (isnull(LMAS.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LMAS.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LMAS.id_status,0) <> 9))


			UNION ALL
				--Consolidated Sea - Exportação - CTA HOUSE
				Select 
					MAS.NUM_PROC_MEM Processo,
					isnull(LLP.id_status,0) [status],
					Upper(pp.Apelido) Cliente,
					TT.Nome_tp_tx,DST.Nome_Local,
					cta.dc_hem dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_HEM,cta.dc_HEM) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda,
					FAT.numero num_NF,
					 FAT.Dt_Fatura Dt_NF, 
					 CREDEV.Apelido CredorDevedor,
					 CTA.num_DCN_hem Num_INV, 
					CTA.Dt_Prev_Pgto_hem Dt_INV,
					(case when HOU.NUM_PROC_MEM = 'JOB' then
						HOU.NUM_PROC_HEM
					Else
						HOU.NUM_PROC_MEM end) SomaMaster
				From 					
					house_exp_mar HOU
					join LLP_exP_MAR LLP on Hou.num_proc_hem =LLP.num_proc_lem
					Join Master_EXp_mar MAS on MAS.num_proc_mem=HOU.num_proc_mem and hou.num_proc_mem <> 'JOB'
					join cta_cte_hou_exp_mar CTA on CTA.num_proc_hem = HOU.num_proc_hem			
					Join Pessoa pp on pp.cd_pes=HOU.cd_export_HEM
					Join Localidade DST on DST.cd_local=HOU.cd_org_HEM		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'	
					left join vwcxas CXA on cta.num_proc_hem=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_hem
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_hem and FAT.status = 'I' and cta.ref_acesso_nf_hem = fat.codigo
				where 
					MAS.num_proc_mem like @num_proc
					and cta.desp_dst_HEM='N' 
					and convert(datetime,dt_emis_HEM,105) between @DataInicial and @DataFinal
					and left(hou.num_proc_hem,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente
					and nome_tp_tx like @nome_tp_tx
					and ((@status = 'Open' and (isnull(LLP.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LLP.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LLP.id_status,0) <> 9))	
				
			UNION ALL
				--Consolidated Sea - Exportação - CTA Master
				Select 
					MAS.NUM_PROC_MEM Processo,
					''[Status],
					'Consolidated' Cliente,
					TT.Nome_tp_tx,
					DST.Nome_Local,
					cta.dc_mem dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_mEM,cta.dc_mEM) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda,
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF,
					 CREDEV.Apelido CredorDevedor,
					 CTA.num_DCN_mem Num_INV, 
					CTA.Dt_Prev_Pgto_mem Dt_INV,
					MAS.num_proc_mem SomaMaster
				From 					
					Master_EXp_mar MAS
					join LLP_Master LMAS on LMAS.num_proc_master = MAS.num_proc_mem
					join cta_cte_mas_exp_mar CTA on CTA.num_proc_mem = MAS.num_proc_mem			
					Join Pessoa pp on pp.cd_pes=MAS.cd_export_mEM
					Join Localidade DST on DST.cd_local=MAS.cd_org_MEM		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'	
					left join vwcxas CXA on cta.num_proc_mem=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_mem
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_mem and FAT.status = 'I' and cta.ref_acesso_nf_mem = fat.codigo
				where 
					MAS.num_proc_mem like @num_proc
					and cta.desp_dst_MEM='N' 
					and convert(datetime,dt_emis_MEM,105) between @DataInicial and @DataFinal
					and left(MAS.num_proc_mem,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente
					and nome_tp_tx like @nome_tp_tx
					and ((@status = 'Open' and (isnull(LMAS.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LMAS.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LMAS.id_status,0) <> 9))
			

			UNION ALL
				--Consolidated AIR - Exportação  - CTA HOUSE
				Select 
					MAS.NUM_PROC_MEA Processo,
					isnull(LLP.id_status,0) [status],
					Upper(pp.Apelido) Cliente,
					TT.Nome_tp_tx,
					DST.Nome_Local,
					cta.dc_hea dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_HEa,cta.dc_HEa) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda,
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF, 
					CREDEV.Apelido CredorDevedor,
					CTA.num_DCN_hea Num_INV, 
					CTA.Dt_Prev_Pgto_hea Dt_INV,
					(case when HOU.NUM_PROC_MEA = 'JOB' then
						HOU.NUM_PROC_HEA
					Else
						HOU.NUM_PROC_MEA end) SomaMaster
				From 
					house_exp_aer HOU
					join LLP_exP_AEr LLP on Hou.num_proc_hea =LLP.num_proc_lea
					Join Master_Exp_aer MAS on MAS.num_proc_mea=HOU.num_proc_mea and hou.num_proc_mea <> 'JOB'
					join cta_cte_hou_exp_aer CTA on CTA.num_proc_hea = HOU.num_proc_hea
					Join Pessoa pp on pp.cd_pes=HOU.cd_export_HEA
					Join Localidade DST on DST.cd_local=HOU.cd_org_HEA		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'	
					left join vwcxas CXA on cta.num_proc_hea=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_hea
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_hea and FAT.status = 'I' and cta.ref_acesso_nf_hea = fat.codigo
				where 
					MAS.num_proc_mea like @num_proc
					and cta.desp_dst_HeA='N' 
					and convert(datetime,dt_emis_HeA,105) between @DataInicial and @DataFinal
					and left(hou.num_proc_hea,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente
					and nome_tp_tx like @nome_tp_tx
					--and isnull(LLP.id_status,0) <> 9
					and ((@status = 'Open' and (isnull(LLP.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LLP.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LLP.id_status,0) <> 9))	

			UNION ALL
				--Consolidated AIR - Exportação  - CTA Master
				Select 
					MAS.NUM_PROC_MEA Processo,
					''[Status],
					'Consolidated' Cliente,
					TT.Nome_tp_tx,
					DST.Nome_Local,
					cta.dc_mea dc_hia, 
					dbo.FConverterMoeda(cta.cd_tp_moeda,@moeda) * dbo.valor(cta.vlr_org_MEa,cta.dc_MEa) Valor,
					Isnull(cxa.num_proc_hia,'N') Caixa,
					@moeda moeda,
					FAT.numero num_NF, 
					FAT.Dt_Fatura Dt_NF, 
					CREDEV.Apelido CredorDevedor,
					CTA.num_DCN_mea Num_INV, 
					CTA.Dt_Prev_Pgto_mea Dt_INV,
					MAS.num_proc_mea SomaMaster
				From 
					Master_Exp_aer MAS
					join LLP_Master LMAS on LMAS.num_proc_master = MAS.num_proc_mea
					join cta_cte_mas_exp_aer CTA on CTA.num_proc_mea = MAS.num_proc_mea
					Join Pessoa pp on pp.cd_pes=MAS.cd_export_MEA
					Join Localidade DST on DST.cd_local=MAS.cd_org_MEA		
					Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx and rentabilidade <> 'N'	
					left join vwcxas CXA on cta.num_proc_mea=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_hia
					join pessoa CREDEV on CREDEV.cd_pes = CTA.cd_cred_dev_mea
					left join fatura_arg FAT on FAT.numero = CTA.num_nf_mea and FAT.status = 'I' and cta.ref_acesso_nf_mea = fat.codigo
				where 
					MAS.num_proc_mea like @num_proc
					and cta.desp_dst_MeA='N' 
					and convert(datetime,dt_emis_MeA,105) between @DataInicial and @DataFinal
					and left(MAS.num_proc_mea,2) like @Modal
					and nome_local like @Localidade
					and pp.Apelido like @Cliente
					and nome_tp_tx like @nome_tp_tx	
					and ((@status = 'Open' and (isnull(LMAS.id_status,0) < 5)) 
					or (@status = 'Closed' and (isnull(LMAS.id_status,0) = 5))
					or (@status = 'ALL' and isnull(LMAS.id_status,0) <> 9))

				order by 1
			END
GO

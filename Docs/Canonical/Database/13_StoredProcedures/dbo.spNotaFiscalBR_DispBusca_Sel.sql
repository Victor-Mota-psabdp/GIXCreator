SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--incluido pra não trazer os casos que já possuem fatura vinculada a taxa - 22/07/2013 - Cadu
--incluido praqdo for is users abaixo, usar a stored antiga q nao verifica se ja existe item fat vinculada a taxa
--revogada a autorização - Osney - 5/8
--Incluido o ver Paridade  - Cadu 09/01/2014
--incluido codigo de servico- 19/07/15
--Erbson 14/09/2015 - Incluido o JOIN para não incluir Vendor--Erbson 14/09/2015 - Incluido o JOIN para não colocar Vendor

--incluido só trazer taxas com vinculação de servico - 15/09/2015 - cadu
--incluido ser pela vwFaturas - cadu 15-09-2015
--incluido usar view - cadu 15-09-2015
-- o codigo antigo esta embaixo :)
--24-10-2016-  incluido verificar o Campo_Processo-BDP Produto, qdo for Freight ou Freight + CHB - tem q ter ATD ou ATA

--26-10-2016 - incluido p trazer o master
--[spNotaFiscalBR_DispBusca_Sel]'ABSA - 1691C','%','EAGRU201610007','admin','A'

CREATE procedure [dbo].[spNotaFiscalBR_DispBusca_Sel]--'REICHHOLD D - 1648C', '%', '%EMATL201503029BR%','ce','A'

	@Cliente	varchar(50),
	@Charge		varchar(50),
	@JOB		varchar(20),
	@cd_user	varchar(6),
	@cd_site	char(1)

as
SET NOCOUNT ON

	declare @CD_PES varchar(10)	
	set @CD_PES = (Select cd_pes from pessoa with(nolock) where apelido = @Cliente)

--	if @cd_user not in ('has','rgl','TTS','lts','acsc','cso','lls','AZ','admin','apsa','avc','amc')
	if @cd_user not in ('ninguemAutorizado')
		Begin			
			Declare @TempTaxas Table
			(
				Processo	varchar(16),
				Taxa		varchar(50),
				DC			varchar(1),				
				Moeda		varchar(50),
				Vlr_org		decimal(10,2),
				Par_Moeda	float,
				NF			varchar(12),
				cd_servico		Bigint,
				Item_lei		varchar(50),
				CNAE			varchar(25),
				Descricao		varchar(500),
				IRRF_Tx			char(1)				
			)
		
			BEGIN
				Insert @TempTaxas				
					select CC.Num_Proc_HIA Processo, TT.Nome_tp_tx Taxa, 
						CC.DC_HIA DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_HIA Vlr_Org,					
					(case When
							CC.Num_NF_HIA is not NULL
						Then 
							CC.Par_NF_HIA 
						else 	
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
							else
								dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Par_Moeda,
					CC.Num_NF_HIA,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx						
					from vwcta_Cte				CC with (nolock)
						join Tipo_Taxa			TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
						left  Join Tipo_Moeda	TM with (nolock)on CC.cd_tp_moeda = TM.cd_tp_moeda
						left Join vwCXAS CXA with (nolock)on CC.Num_Proc_HIA = CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA
						Left Join vwFaturasValidas FAt with (nolock)on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc
						left join Tipo_taxaXTipo_NF_Doc_Register TN with (nolock)on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
						Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.Cd_Cred_Dev_HIA and tipo='C'
						join [vwCliente_Alerta] V with(nolock) on V.num_proc = CC.Num_proc_hia
						join Campo_Processo CP  with(nolock) on CP.Num_Proc = CC.Num_proc_hia and Id_Campo = 143
					where 
						TT.Nome_Tp_Tx like @Charge 
						and CC.Num_Proc_HIA like @JOB 
						and convert(datetime,Dt_Ins_HIA,103) > getdate() - 450 
						--and left(CC.Num_Proc_HIA,5) <>'EMJOB' 
						and SUBSTRING(CC.Num_Proc_HIA,3,3) <>'JOB'
						and CC.cd_tp_tx not like 'X%' 
						and CC.cd_tp_tx not in('FRT','FRC') 
						and CC.Cd_Cred_Dev_HIA = @CD_pes 
						and CC.Num_NF_HIA is null 
						and NF = 'S'  
						and Fat.num_proc is null
						--Alessandra 05/05/2020 - 100-215446 - NF Sao Caetano
						--and (
						--		(@cd_site in ('I','A','C','H') and TN.cd_servico is not null)
						--		OR
						--		(@cd_site not in('I','A','C','H') and TN.cd_servico is null)
						--	)
						and (
							(@cd_site in ('I','J','K','A','C','H') and TN.cd_servico is not null)
							OR
							(@cd_site not in('I','J','K','A','C','H') and TN.cd_servico is null)
						)
						and (
								(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
								or	
								(CP.Campo_Dados =1)
								or
								(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
							)
						--and V.Master = 'JOB'	
							
				UNION ALL
				
					select CC.Num_Proc_HIA Processo, TT.Nome_tp_tx Taxa, 
						CC.DC_HIA DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_HIA Vlr_Org,					
						(case When
							CC.Num_NF_HIA is not NULL
						Then 
							CC.Par_NF_HIA 
						else 	
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
							else
								dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Par_Moeda,
					CC.Num_NF_HIA,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx						
					from vwcta_Cte				CC with (nolock)
						join Tipo_Taxa			TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
						left  Join Tipo_Moeda	TM with (nolock)on CC.cd_tp_moeda = TM.cd_tp_moeda
						left Join vwCXAS CXA with (nolock)on CC.Num_Proc_HIA = CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA
						Left Join vwFaturasValidas FAt with (nolock)on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc
						left join Tipo_taxaXTipo_NF_Doc_Register TN with (nolock)on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
						Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.Cd_Cred_Dev_HIA and tipo='C'
						join [vwCliente_Alerta] V with(nolock) on V.Master = CC.Num_proc_hia 
						join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143
					where 
						TT.Nome_Tp_Tx like @Charge 
						and CC.Num_Proc_HIA like @JOB 
						and convert(datetime,Dt_Ins_HIA,103) > getdate() - 450 
						--and left(CC.Num_Proc_HIA,5) <>'EMJOB' 
						and SUBSTRING(CC.Num_Proc_HIA,3,3) <>'JOB'
						and CC.cd_tp_tx not like 'X%' 
						and CC.cd_tp_tx not in('FRT','FRC') 
						and CC.Cd_Cred_Dev_HIA = @CD_pes 
						and CC.Num_NF_HIA is null 
						and NF = 'S'  
						and Fat.num_proc is null
						
						--Alessandra 05/05/2020 - 100-215446 - NF Sao Caetano
						--and (
						--		(@cd_site in ('I','A','C','H') and TN.cd_servico is not null)
						--		OR
						--		(@cd_site not in('I','A','C','H') and TN.cd_servico is null)
						--	)
						and (
								(@cd_site in ('I','J','K','A','C','H') and TN.cd_servico is not null)
								OR
								(@cd_site not in('I','J','K','A','C','H') and TN.cd_servico is null)
							)

						and (
								(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
								or	
								(CP.Campo_Dados =1)
								or
								(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
							)
						--and V.Master <> 'JOB'
									

					order by Processo
			END			
	END
Else			
	BEGIN
		Insert @TempTaxas
			select CC.Num_Proc_HIA Processo, TT.Nome_tp_tx Taxa, CC.DC_HIA DC, TM.Nome_tp_moeda Moeda,
			CC.Vlr_Org_HIA Vlr_Org,					
			(case When
				CC.Num_NF_HIA is not NULL and CC.Ref_Acesso_NF_HIA <> 'P'
			Then 
				Par_NF_HIA
				--Par_Moeda_hem?? nao entendi pq isso?
			else 
				(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
				else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
				else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
				else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
				else
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
			end)end)end)end)end)Par_Moeda
			,CC.Num_NF_HIA
			,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx	
		from vwcta_Cte				CC with (nolock)
			join Tipo_Taxa			TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
			left  Join Tipo_Moeda	TM with (nolock)on CC.cd_tp_moeda = TM.cd_tp_moeda
			left  Join vwCXAS		CXA with (nolock)on CC.Num_Proc_HIA = CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA
			left join Tipo_taxaXTipo_NF_Doc_Register TN with (nolock)on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
			Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.Cd_Cred_Dev_HIA and tipo='C'
			join [vwCliente_Alerta] V with(nolock) on V.num_proc = CC.Num_proc_hia
			join Campo_Processo CP  with(nolock) on CP.Num_Proc = CC.Num_proc_hia and Id_Campo = 143
		where 
			TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_HIA like @JOB
			and convert(datetime,Dt_Ins_HIA,103) > getdate() - 450 
			and SUBSTRING(CC.Num_Proc_HIA,3,3) <>'JOB'
			and CC.cd_tp_tx not like 'X%' 
			and CC.cd_tp_tx not in('FRT','FRC')  
			and CC.Cd_Cred_Dev_HIA = @CD_pes 
			and CC.Num_NF_HIA is null
			and NF = 'S'
			and (
				--Alessandra 05/05/2020 - 100-215446 - NF Sao Caetano
				--(@cd_site in ('I','A','C','H') and TN.cd_servico is not null)
				--OR
				--(@cd_site not in('I','A','C','H') and TN.cd_servico is null)
				--)

				(@cd_site in ('I','J','K','A','C','H') and TN.cd_servico is not null)
				OR
				(@cd_site not in('I','J','K','A','C','H') and TN.cd_servico is null)
				)
			and (
					(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
					or
					(CP.Campo_Dados =1)
					or
					(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
				)
			--and V.Master = 'JOB'
		
		UNION ALL
			select CC.Num_Proc_HIA Processo, TT.Nome_tp_tx Taxa, CC.DC_HIA DC, TM.Nome_tp_moeda Moeda,
			CC.Vlr_Org_HIA Vlr_Org,					
			(case When
				CC.Num_NF_HIA is not NULL and CC.Ref_Acesso_NF_HIA <> 'P'
			Then 
				Par_NF_HIA
				--Par_Moeda_hem?? nao entendi pq isso?
			else 
				(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
				else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
				else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
				else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
				else
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
			end)end)end)end)end)Par_Moeda
			,CC.Num_NF_HIA
			,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx	
		from vwcta_Cte				CC with (nolock)
			join Tipo_Taxa			TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
			left  Join Tipo_Moeda	TM with (nolock)on CC.cd_tp_moeda = TM.cd_tp_moeda
			left  Join vwCXAS		CXA with (nolock)on CC.Num_Proc_HIA = CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA
			left join Tipo_taxaXTipo_NF_Doc_Register TN with (nolock)on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
			Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.Cd_Cred_Dev_HIA and tipo='C'
			join [vwCliente_Alerta] V with(nolock) on V.Master = CC.Num_proc_hia 
			join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143
		where 
			TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_HIA like @JOB
			and convert(datetime,Dt_Ins_HIA,103) > getdate() - 450 
			and SUBSTRING(CC.Num_Proc_HIA,3,3) <>'JOB'
			and CC.cd_tp_tx not like 'X%' 
			and CC.cd_tp_tx not in('FRT','FRC')  
			and CC.Cd_Cred_Dev_HIA = @CD_pes 
			and CC.Num_NF_HIA is null
			and NF = 'S'
			and (
					--Alessandra 05/05/2020 - 100-215446 - NF Sao Caetano
					--(@cd_site in ('I','A','C','H') and TN.cd_servico is not null)
					--OR
					--(@cd_site not in('I','A','C','H') and TN.cd_servico is null)
					(@cd_site in ('I','J','K','A','C','H') and TN.cd_servico is not null)
					OR
					(@cd_site not in('I','J','K','A','C','H') and TN.cd_servico is null)
				)
			and (
					(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
					or
					(CP.Campo_Dados =1)
					or
					(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
				)
			--and V.Master <> 'JOB'
				
		order by Processo
	END
	
	
	update 
		T  
	set 
		T.Par_Moeda=T1.Par_Moeda
	from 
		@TempTaxas as T
	JOIN
		@TempTaxas  as T1
		on T.Moeda = T1.Moeda and T1.NF is not NULL
	--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
	--where NF is NULL
	
select * from @TempTaxas



/*
ALTER procedure [dbo].[spNotaFiscalBR_DispBusca_Sel]--'REICHHOLD D - 1648C', '%', '%EMATL201503029BR%','ce','A'

	@Cliente	varchar(50),
	@Charge		varchar(50),
	@JOB		varchar(20),
	@cd_user	varchar(6),
	@cd_site	char(1)

as
SET NOCOUNT ON

	declare @CD_PES varchar(10)	
	set @CD_PES = (Select cd_pes from pessoa with(nolock) where apelido = @Cliente)

--	if @cd_user not in ('has','rgl','TTS','lts','acsc','cso','lls','AZ','admin','apsa','avc','amc')
	if @cd_user not in ('ninguemAutorizado')
		Begin			
			Declare @TempTaxas Table
			(
				Processo	varchar(16),
				Taxa		varchar(50),
				DC			varchar(1),				
				Moeda		varchar(50),
				Vlr_org		decimal(10,2),
				Par_Moeda	float,
				NF			varchar(12),
				cd_servico		Bigint,
				Item_lei		varchar(50),
				CNAE			varchar(25),
				Descricao		varchar(500),
				IRRF_Tx			char(1)				
			)
		
			BEGIN
				Insert @TempTaxas				
					select CC.Num_Proc_HIA Processo, TT.Nome_tp_tx Taxa, 
						CC.DC_HIA DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_HIA Vlr_Org,					
					(case When
							CC.Num_NF_HIA is not NULL
						Then 
							CC.Par_NF_HIA 
						else 	
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
							else
								dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Par_Moeda,
					CC.Num_NF_HIA,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx						
					from vwcta_Cte				CC with (nolock)
						join Tipo_Taxa			TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
						left  Join Tipo_Moeda	TM with (nolock)on CC.cd_tp_moeda = TM.cd_tp_moeda
						left Join vwCXAS CXA with (nolock)on CC.Num_Proc_HIA = CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA
						Left Join vwFaturasValidas FAt with (nolock)on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc
						left join Tipo_taxaXTipo_NF_Doc_Register TN with (nolock)on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
						Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.Cd_Cred_Dev_HIA and tipo='C'
					where 
						TT.Nome_Tp_Tx like @Charge 
						and CC.Num_Proc_HIA like @JOB 
						and convert(datetime,Dt_Ins_HIA,103) > getdate() - 450 
						--and left(CC.Num_Proc_HIA,5) <>'EMJOB' 
						and SUBSTRING(CC.Num_Proc_HIA,3,3) <>'JOB'
						and CC.cd_tp_tx not like 'X%' 
						and CC.cd_tp_tx not in('FRT','FRC') 
						and CC.Cd_Cred_Dev_HIA = @CD_pes 
						and CC.Num_NF_HIA is null 
						and NF = 'S'  
						and Fat.num_proc is null
						--and (
						--	(@cd_site = 'I' and TN.cd_servico is not null)
						--	OR
						--	(@cd_site <> 'I' and TN.cd_servico is null)
						--	)
						and (
							(@cd_site in ('I','A','C','H') and TN.cd_servico is not null)
							OR
							(@cd_site not in('I','A','C','H') and TN.cd_servico is null)
							)					

					order by Processo
			END			
	END
Else			
	BEGIN
		Insert @TempTaxas
			select CC.Num_Proc_HIA Processo, TT.Nome_tp_tx Taxa, CC.DC_HIA DC, TM.Nome_tp_moeda Moeda,
			CC.Vlr_Org_HIA Vlr_Org,					
			(case When
				CC.Num_NF_HIA is not NULL and CC.Ref_Acesso_NF_HIA <> 'P'
			Then 
				Par_NF_HIA
				--Par_Moeda_hem?? nao entendi pq isso?
			else 
				(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
				else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
				else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
				else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
				else
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
			end)end)end)end)end)Par_Moeda
			,CC.Num_NF_HIA
			,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx	
		from vwcta_Cte				CC with (nolock)
			join Tipo_Taxa			TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
			left  Join Tipo_Moeda	TM with (nolock)on CC.cd_tp_moeda = TM.cd_tp_moeda
			left  Join vwCXAS		CXA with (nolock)on CC.Num_Proc_HIA = CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA
			left join Tipo_taxaXTipo_NF_Doc_Register TN with (nolock)on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
			Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.Cd_Cred_Dev_HIA and tipo='C'
		where 
			TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_HIA like @JOB
			and convert(datetime,Dt_Ins_HIA,103) > getdate() - 450 
			and SUBSTRING(CC.Num_Proc_HIA,3,3) <>'JOB'
			and CC.cd_tp_tx not like 'X%' 
			and CC.cd_tp_tx not in('FRT','FRC')  
			and CC.Cd_Cred_Dev_HIA = @CD_pes 
			and CC.Num_NF_HIA is null
			and NF = 'S'
			and (
				(@cd_site in ('I','A','C','H') and TN.cd_servico is not null)
				OR
				(@cd_site not in('I','A','C','H') and TN.cd_servico is null)
				)
				
		order by Processo
	END
	
	
	update 
		T  
	set 
		T.Par_Moeda=T1.Par_Moeda
	from 
		@TempTaxas as T
	JOIN
		@TempTaxas  as T1
		on T.Moeda = T1.Moeda and T1.NF is not NULL
	--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
	--where NF is NULL
	
select * from @TempTaxas
*/

/*ultimo codigo
ALTER procedure [dbo].[spNotaFiscalBR_DispBusca_Sel]--'FMC FABRICA2', '%', '%EAFMC201401001BR%','rgl'

-- Stored alterada por Anderson Oliveira em 30/08/2010

	@Cliente	varchar(50),
	@Charge		varchar(50),
	@JOB		varchar(20),
	@cd_user	varchar(6),
	@cd_site	char(1)

as
SET NOCOUNT ON

	declare @CD_PES varchar(10)	
	set @CD_PES = (Select cd_pes from pessoa with(nolock) where apelido = @Cliente)

--	if @cd_user not in ('has','rgl','TTS','lts','acsc','cso','lls','AZ','admin','apsa','avc','amc')
	if @cd_user not in ('ninguemAutorizado')
		Begin
			Declare @Fatura Table
				(
					Num_proc	varchar(16),
					Cd_tp_Tx	Varchar(3),
					DC			Varchar(1)			
				)
			Begin 		
				Insert @Fatura	
					Select left(i.fatcod,16),cd_tp_Tx,dc from item_fat I
					Join Fatura F on F.fatcod=i.fatcod 
				where
					cd_pes=@CD_PES and fatstatus =1
			End	
			
			Declare @TempTaxas Table
			(
				Processo	varchar(16),
				Taxa		varchar(50),
				DC			varchar(1),				
				Moeda		varchar(50),
				Vlr_org		decimal(10,2),
				Par_Moeda	float,
				NF			varchar(12),
				cd_servico		Bigint,
				Item_lei		varchar(50),
				CNAE			varchar(25),
				Descricao		varchar(500)		
			)
		
		BEGIN
			Insert @TempTaxas

			select 
				CC.Num_Proc_hem Processo, TT.Nome_tp_tx Taxa, CC.DC_Hem DC, TM.Nome_tp_moeda Moeda,
				CC.Vlr_Org_Hem Vlr_Org, 
				--Par_Moeda_hem Par_Moeda 
				(case When
						CC.Num_NF_HEM is not NULL and CC.ref_acesso_nf_hem <> 'P'
					Then 
						Par_Moeda_hem
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM') end )Par_Moeda
					,CC.Num_NF_HEM
					,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao					
			from 
				cta_cte_hou_exp_mar CC
				join Tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_exp_mar CXA on CC.Num_proc_hem = CXA.Num_proc_hem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hem = CXA.dc_hem
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hem and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hem=fat.dc   
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hem and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Hem like @JOB 
				and convert(datetime,dt_ins_hem,103) > getdate() - 450 and left(CC.Num_Proc_hem,5) <>'EMJOB' 
				and left(CC.cd_tp_tx,1) <>'X' and CC.cd_tp_tx not in('FRT','FRC')  and CC.cd_cred_dev_hem = @CD_pes and 
				CC.Num_Nf_Hem is null
				and NF='S' 
				and Fat.num_proc is null

			union all

			select 
				CC.Num_Proc_him Processo, TT.Nome_tp_tx Taxa, CC.DC_him DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_him Vlr_Org, 
				--Par_Moeda_him Par_Moeda 
				(case When
						CC.Num_NF_HIM is not NULL and CC.ref_acesso_nf_him <> 'P'
					Then 
						Par_Moeda_him
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') end )Par_Moeda 
					,CC.Num_NF_HIM	
					,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao					
			from 
				cta_cte_hou_imp_mar CC
				join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_imp_mar CXA on CC.Num_proc_him = CXA.Num_proc_him and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_him = CXA.dc_him
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_him and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_him=fat.dc   
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_him and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Him like @JOB and 
				convert(datetime,dt_ins_him,103) > getdate() - 450 and left(CC.Num_Proc_him,5) <>'IMJOB' and 
				left(CC.cd_tp_tx,1) <> 'X' and CC.cd_tp_tx not in('FRT','FRC') and 
				CC.cd_cred_dev_him = @CD_pes and CC.Num_Nf_Him is null
				and NF='S' 
				and Fat.num_proc is null

			union all

			select 
				CC.Num_Proc_Hia Processo, TT.Nome_tp_tx Taxa, CC.DC_Hia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_Hia Vlr_Org, 
				--Par_Moeda_hia Par_Moeda 
				(case When
						CC.Num_NF_HIA is not NULL and CC.ref_acesso_nf_hia <> 'P'
					Then 
						Par_Moeda_hia
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA') end )Par_Moeda 
						
				,CC.Num_NF_HIA
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_hou_imp_aer CC
				join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_imp_aer CXA on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc   
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Hia like @JOB and convert(datetime,dt_ins_hia,103) > getdate() - 450 and 
				left(CC.Num_Proc_hia,5) <>'IAJOB' and left(CC.cd_tp_tx,1)<>'X' and 
				CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_hia = @CD_pes 
				and CC.Num_Nf_Hia is null
				and nf='S' 
				and Fat.num_proc is null
			union  all

			select 
				CC.Num_Proc_hea Processo, TT.Nome_tp_tx Taxa, CC.DC_hea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hea Vlr_Org, 
				--Par_Moeda_hea Par_Moeda 
				(case When
						CC.Num_NF_HEA is not NULL and CC.ref_acesso_nf_hea <> 'P'
					Then 
						Par_Moeda_HEA
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA') end )Par_Moeda 
					,CC.Num_NF_HEA
					,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao						
			from 
				cta_cte_hou_exp_aer CC
				join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_exp_aer CXA on CC.Num_proc_hea = CXA.Num_proc_hea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hea = CXA.dc_hea
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hea and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hea=fat.dc   
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hea and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Hea like @JOB 
				and convert(datetime,dt_ins_hea,103) > getdate() - 450 and 
				left(CC.Num_Proc_hea,5) <>'EAJOB' and 
				left(CC.cd_tp_tx,1) <> 'X'and CC.cd_tp_tx not in('FRT','FRC') 
				and CC.cd_cred_dev_hea = @CD_pes and CC.Num_Nf_Hea is null
				and nf='S' 
				and Fat.num_proc is null

			union all

			select 
				CC.Num_Proc_heo Processo, TT.Nome_tp_tx Taxa, CC.DC_heo DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_heo Vlr_Org, 
				--Par_Moeda_heo Par_Moeda 
				(case When
						CC.Num_NF_HEO is not NULL and CC.ref_acesso_nf_heo <> 'P'
					Then 
						Par_Moeda_HEO
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end )Par_Moeda 						
				,CC.Num_NF_HEO
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_hou_exp_out CC
				join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM  with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_exp_out CXA on CC.Num_proc_heo = CXA.Num_proc_heo and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_heo = CXA.dc_heo
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_heo and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_heo=fat.dc   
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_heo and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Heo like @JOB and 
				convert(datetime,dt_ins_heo,103) > getdate() - 450 and 
				left(CC.Num_Proc_heo,5) <>'EOJOB' and left(CC.cd_tp_tx,1)<> 'X' and 
				CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_heo = @CD_pes 
				and CC.Num_Nf_Heo is null and nf='S' 
				and Fat.num_proc is null

			union all

			select 
				CC.Num_Proc_hio Processo, TT.Nome_tp_tx Taxa, CC.DC_hio DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hio Vlr_Org, 
				--Par_Moeda_hio Par_Moeda
				(case When
						CC.Num_NF_HIO is not NULL and CC.Ref_Acesso_NF_HIO <> 'P'
					Then 
						Par_Moeda_HIO
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end )Par_Moeda   
				,CC.Num_NF_HIO
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_hou_imp_out CC
				join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_imp_out CXA on CC.Num_proc_hio = CXA.Num_proc_hio and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hio = CXA.dc_hio
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hio and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hio=fat.dc   
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hio and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Hio like @JOB 
				and convert(datetime,dt_ins_hio,103) > getdate() - 450 
				and left(CC.Num_Proc_hio,5) <>'IOJOB' and 
				left(CC.cd_tp_tx,1)<>'X' and CC.cd_tp_tx not in('FRT','FRC') and 
				CC.cd_cred_dev_hio = @CD_pes and CC.Num_Nf_Hio is null
				and nf='S' 
				and Fat.num_proc is null

			union all

			select 
				CC.Num_Proc_mia Processo, TT.Nome_tp_tx Taxa, CC.DC_mia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mia Vlr_Org, 
				--Par_Moeda_mia Par_Moeda 
				(case When
						CC.Num_NF_MIA is not NULL and CC.Ref_Acesso_NF_MIA <> 'P'
					Then 
						Par_Moeda_mia
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA') end )Par_Moeda  
				,CC.Num_NF_MIA
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_mas_imp_aer CC
				join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_mas_imp_aer CXA on CC.Num_proc_mia = CXA.Num_proc_mia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mia = CXA.dc_mia
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mia=fat.dc   
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_mia and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_mia like @JOB 
				and convert(datetime,dt_ins_mia,103) > getdate() - 450 and 
				left(CC.cd_tp_tx,1)<>'X' and CC.cd_tp_tx not in('FRT','FRC') and 
				CC.cd_cred_dev_mia = @CD_pes and CC.Num_Nf_mia is null
				and nf='S' 
				and Fat.num_proc is null

			union all

			select 
				CC.Num_Proc_mea Processo, TT.Nome_tp_tx Taxa, CC.DC_mea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mea Vlr_Org, 
				--Par_Moeda_mea Par_Moeda 
				(case When
						CC.Num_NF_MEA is not NULL and CC.Ref_Acesso_NF_MEA <> 'P'
					Then 
						Par_Moeda_mea
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA') end )Par_Moeda 
				,CC.Num_NF_MEA
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_mas_exp_aer CC
				join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_mas_exp_aer CXA on CC.Num_proc_mea = CXA.Num_proc_mea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mea = CXA.dc_mea
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mea and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mea=fat.dc   
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_mea and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_mea like @JOB and 
				convert(datetime,dt_ins_mea,103) > getdate() - 450 and 
				left(CC.cd_tp_tx,1) <>'X' and CC.cd_tp_tx not in('FRT','FRC') and 
				CC.cd_cred_dev_mea = @CD_pes and CC.Num_Nf_mea is null
				and nf='S' 
				and Fat.num_proc is null

			Union all

			select 
				CC.Num_Proc_mim Processo, TT.Nome_tp_tx Taxa, CC.DC_mim DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mim Vlr_Org, 
				--Par_Moeda_mim Par_Moeda 
				(case When
						CC.Num_NF_MIM is not NULL and CC.Ref_Acesso_NF_MIM <> 'P'
					Then 
						Par_Moeda_MIM
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') end )Par_Moeda 
					,CC.Num_NF_MIM
					,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_mas_imp_mar CC
				join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_mas_imp_mar CXA on CC.Num_proc_mim = CXA.Num_proc_mim and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mim = CXA.dc_mim
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mim and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mim=fat.dc   
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_mim and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_mim like @JOB 
				and convert(datetime,dt_ins_mim,103) > getdate() - 450 
				and left(CC.cd_tp_tx,1) <> 'X' and CC.cd_tp_tx not in('FRT','FRC') 
				and CC.cd_cred_dev_mim = @CD_pes and CC.Num_Nf_mim is null
				and nf='S' 
				and Fat.num_proc is null

			union all

			select 
				CC.Num_Proc_mem Processo, TT.Nome_tp_tx Taxa, CC.DC_mem DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mem Vlr_Org, 
				--Par_Moeda_mem Par_Moeda 
				(case When
						CC.Num_NF_MEM is not NULL and CC.Ref_Acesso_NF_MEM <> 'P'
					Then 
						Par_Moeda_MEM
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM') end )Par_Moeda 
				,CC.Num_NF_MEM
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_mas_exp_mar CC
				join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_mas_exp_mar CXA on CC.Num_proc_mem = CXA.Num_proc_mem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mem = CXA.dc_mem
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mem and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mem=fat.dc   
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_mem and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_mem like @JOB and 
				convert(datetime,dt_ins_mem,103) > getdate() - 450 and 
				LEFT(CC.cd_tp_tx,1)<>'X' and CC.cd_tp_tx not in('FRT','FRC') and 
				CC.cd_cred_dev_mem = @CD_pes and CC.Num_Nf_mem is null
				and nf='S' 
				and Fat.num_proc is null

			order by Processo
		End
	End
Else
		Begin
			BEGIN
			Insert @TempTaxas

			select 
				CC.Num_Proc_hem Processo, TT.Nome_tp_tx Taxa, CC.DC_Hem DC, TM.Nome_tp_moeda Moeda,
				CC.Vlr_Org_Hem Vlr_Org, 
				--Par_Moeda_hem Par_Moeda
				(case When
						CC.Num_NF_HEM is not NULL and CC.ref_acesso_nf_hem <> 'P'
					Then 
						Par_Moeda_hem
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM') end )Par_Moeda 
				,CC.Num_NF_HEM
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_hou_exp_mar CC
				join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_exp_mar CXA on CC.Num_proc_hem = CXA.Num_proc_hem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hem = CXA.dc_hem
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hem and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Hem like @JOB 
				and convert(datetime,dt_ins_hem,103) > getdate() - 450 and left(CC.Num_Proc_hem,5) <>'EMJOB' 
				and left(CC.cd_tp_tx,1) <>'X' and CC.cd_tp_tx not in('FRT','FRC')  and CC.cd_cred_dev_hem = @CD_pes and 
				CC.Num_Nf_Hem is null
				and NF='S'
			union all

			select 
				CC.Num_Proc_him Processo, TT.Nome_tp_tx Taxa, CC.DC_him DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_him Vlr_Org, 
				--Par_Moeda_him Par_Moeda 
				(case When
						CC.Num_NF_HIM is not NULL and CC.ref_acesso_nf_him <> 'P'
					Then 
						Par_Moeda_HIM
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') end )Par_Moeda
				,CC.Num_NF_HIM
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_hou_imp_mar CC
				join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_imp_mar CXA on CC.Num_proc_him = CXA.Num_proc_him and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_him = CXA.dc_him
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_him and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Him like @JOB and 
				convert(datetime,dt_ins_him,103) > getdate() - 450 and left(CC.Num_Proc_him,5) <>'IMJOB' and 
				left(CC.cd_tp_tx,1) <> 'X' and CC.cd_tp_tx not in('FRT','FRC') and 
				CC.cd_cred_dev_him = @CD_pes and CC.Num_Nf_Him is null
				and NF='S'

			union all

			select 
				CC.Num_Proc_Hia Processo, TT.Nome_tp_tx Taxa, CC.DC_Hia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_Hia Vlr_Org, 
				--Par_Moeda_hia Par_Moeda 
				(case When
						CC.Num_NF_HIA is not NULL and CC.ref_acesso_nf_hia <> 'P'
					Then 
						Par_Moeda_HIA
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA') end )Par_Moeda
				,CC.Num_NF_HIA
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_hou_imp_aer CC
				join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_imp_aer CXA on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Hia like @JOB and convert(datetime,dt_ins_hia,103) > getdate() - 450 and 
				left(CC.Num_Proc_hia,5) <>'IAJOB' and left(CC.cd_tp_tx,1)<>'X' and 
				CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_hia = @CD_pes 
				and CC.Num_Nf_Hia is null
				and nf='S'
			union  all

			select 
				CC.Num_Proc_hea Processo, TT.Nome_tp_tx Taxa, CC.DC_hea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hea Vlr_Org, 
				--Par_Moeda_hea Par_Moeda 
				(case When
						CC.Num_NF_HEA is not NULL and CC.ref_acesso_nf_hea <> 'P'
					Then 
						Par_Moeda_HEA
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA') end )Par_Moeda 
				,CC.Num_NF_HEA
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_hou_exp_aer CC
				join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_exp_aer CXA on CC.Num_proc_hea = CXA.Num_proc_hea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hea = CXA.dc_hea
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hea and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Hea like @JOB 
				and convert(datetime,dt_ins_hea,103) > getdate() - 450 and 
				left(CC.Num_Proc_hea,5) <>'EAJOB' and 
				left(CC.cd_tp_tx,1) <> 'X'and CC.cd_tp_tx not in('FRT','FRC') 
				and CC.cd_cred_dev_hea = @CD_pes and CC.Num_Nf_Hea is null
				and nf='S'

			union all

			select 
				CC.Num_Proc_heo Processo, TT.Nome_tp_tx Taxa, CC.DC_heo DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_heo Vlr_Org, 
				--Par_Moeda_heo Par_Moeda 
				(case When
						CC.Num_NF_HEO is not NULL and CC.Ref_Acesso_NF_HEO <> 'P'
					Then 
						Par_Moeda_HEO
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end )Par_Moeda 
				,CC.Num_NF_HEO
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_hou_exp_out CC
				join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_exp_out CXA on CC.Num_proc_heo = CXA.Num_proc_heo and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_heo = CXA.dc_heo
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_heo and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Heo like @JOB and 
				convert(datetime,dt_ins_heo,103) > getdate() - 450 and 
				left(CC.Num_Proc_heo,5) <>'EOJOB' and left(CC.cd_tp_tx,1)<> 'X' and 
				CC.cd_tp_tx not in('FRT','FRC') and CC.cd_cred_dev_heo = @CD_pes 
				and CC.Num_Nf_Heo is null and nf='S'

			union all

			select 
				CC.Num_Proc_hio Processo, TT.Nome_tp_tx Taxa, CC.DC_hio DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_hio Vlr_Org, 
				--Par_Moeda_hio Par_Moeda 
				(case When
						CC.Num_NF_HIO is not NULL and CC.Ref_Acesso_NF_HIO <> 'P'
					Then 
						Par_Moeda_HIO
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end )Par_Moeda 
				,CC.Num_NF_HIO
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_hou_imp_out CC
				join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_hou_imp_out CXA on CC.Num_proc_hio = CXA.Num_proc_hio and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hio = CXA.dc_hio
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hio and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Hio like @JOB 
				and convert(datetime,dt_ins_hio,103) > getdate() - 450 
				and left(CC.Num_Proc_hio,5) <>'IOJOB' and 
				left(CC.cd_tp_tx,1)<>'X' and CC.cd_tp_tx not in('FRT','FRC') and 
				CC.cd_cred_dev_hio = @CD_pes and CC.Num_Nf_Hio is null
				and nf='S'

			union all

			select 
				CC.Num_Proc_mia Processo, TT.Nome_tp_tx Taxa, CC.DC_mia DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mia Vlr_Org, 
				--Par_Moeda_mia Par_Moeda 
				(case When
						CC.Num_NF_MIA is not NULL and CC.Ref_Acesso_NF_MIA <> 'P'
					Then 
						Par_Moeda_MIA
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA') end )Par_Moeda  
				,CC.Num_NF_MIA
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_mas_imp_aer CC
				join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_mas_imp_aer CXA on CC.Num_proc_mia = CXA.Num_proc_mia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mia = CXA.dc_mia
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_mia and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_mia like @JOB 
				and convert(datetime,dt_ins_mia,103) > getdate() - 450 and 
				left(CC.cd_tp_tx,1)<>'X' and CC.cd_tp_tx not in('FRT','FRC') and 
				CC.cd_cred_dev_mia = @CD_pes and CC.Num_Nf_mia is null
				and nf='S'

			union all

			select 
				CC.Num_Proc_mea Processo, TT.Nome_tp_tx Taxa, CC.DC_mea DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mea Vlr_Org, 
				--Par_Moeda_mea Par_Moeda 
				(case When
						CC.Num_NF_MEA is not NULL and CC.Ref_Acesso_NF_MEA <> 'P'
					Then 
						Par_Moeda_MEA
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA') end )Par_Moeda 
				,CC.Num_NF_MEA
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_mas_exp_aer CC
				join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_mas_exp_aer CXA on CC.Num_proc_mea = CXA.Num_proc_mea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mea = CXA.dc_mea
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_mea and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_mea like @JOB and 
				convert(datetime,dt_ins_mea,103) > getdate() - 450 and 
				left(CC.cd_tp_tx,1) <>'X' and CC.cd_tp_tx not in('FRT','FRC') and 
				CC.cd_cred_dev_mea = @CD_pes and CC.Num_Nf_mea is null
				and nf='S'

			Union all

			select 
				CC.Num_Proc_mim Processo, TT.Nome_tp_tx Taxa, CC.DC_mim DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mim Vlr_Org, 
				--Par_Moeda_mim Par_Moeda
				(case When
						CC.Num_NF_MIM is not NULL and CC.Ref_Acesso_NF_MIM <> 'P'
					Then 
						Par_Moeda_MIM
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') end )Par_Moeda  
				,CC.Num_NF_MIM
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_mas_imp_mar CC
				join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_mas_imp_mar CXA on CC.Num_proc_mim = CXA.Num_proc_mim and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mim = CXA.dc_mim
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_mim and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_mim like @JOB 
				and convert(datetime,dt_ins_mim,103) > getdate() - 450 
				and left(CC.cd_tp_tx,1) <> 'X' and CC.cd_tp_tx not in('FRT','FRC') 
				and CC.cd_cred_dev_mim = @CD_pes and CC.Num_Nf_mim is null
				and nf='S'

			union all

			select 
				CC.Num_Proc_mem Processo, TT.Nome_tp_tx Taxa, CC.DC_mem DC, TM.Nome_tp_moeda Moeda,CC.Vlr_Org_mem Vlr_Org, 
				--Par_Moeda_mem Par_Moeda 
				(case When
						CC.Num_NF_MEM is not NULL and CC.Ref_Acesso_NF_MEM <> 'P'
					Then 
						Par_Moeda_MEM
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM') end )Par_Moeda
				,CC.Num_NF_MEM
				,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
			from 
				cta_cte_mas_exp_mar CC
				join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
				left Outer Join caixa_mas_exp_mar CXA on CC.Num_proc_mem = CXA.Num_proc_mem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mem = CXA.dc_mem
				left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
				Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_mem and tipo='C'
			where 
				TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_mem like @JOB and 
				convert(datetime,dt_ins_mem,103) > getdate() - 450 and 
				LEFT(CC.cd_tp_tx,1)<>'X' and CC.cd_tp_tx not in('FRT','FRC') and 
				CC.cd_cred_dev_mem = @CD_pes and CC.Num_Nf_mem is null
				and nf='S'

			order by Processo
		
		End
	End
	
	update 
		T  
	set 
		T.Par_Moeda=T1.Par_Moeda
	from 
		@TempTaxas as T
	JOIN
		@TempTaxas  as T1
		on T.Moeda = T1.Moeda and T1.NF is not NULL
	--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
	--where NF is NULL
	
select * from @TempTaxas


*/

GO

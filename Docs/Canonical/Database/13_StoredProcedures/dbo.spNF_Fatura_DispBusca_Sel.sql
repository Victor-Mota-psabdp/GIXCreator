SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Incluido um Table pra fatura_nf, pois estava duplicando os valores igual o item fat -Cadu = 30/06/2014
--incluido só trazer taxas com vinculação de servico - 14/08/2015 - cadu
--Incluido um Table pra fatura_nf, pois estava duplicando os valores igual o item fat -Cadu = 30/06/2014
--incluido ser pela vwFaturas - cadu 15-09-2015
--incluido ser pela vwInvoice_NFValidas - cadu 15-09-2015
--incluido nao trazer taxas sem codigo de serviço - cadu 15-09-2015
--2-9-2016 - incluido o left jon com axdocs - cadu
--incluido verificar o Campo_Processo-BDP Produto, qdo for Freight ou Freight + CHB - tem q ter ATD ou ATA

--26-10-2016 - incluido p trazer o master

--25/01/2023 - 100-376296 –TRANSPORTATION - Faturamento antecipado
--(tirar esta trava qdo for Freight ou Freight + CHB - tem q ter ATD ou ATA)

--[spNF_Fatura_DispBusca_Sel]'ABSA - 1691C','%','EAGRU201610007','admin','A'
CREATE procedure [dbo].[spNF_Fatura_DispBusca_Sel]--'ET LTDA','admin'

	@Cliente varchar(50),
	@Charge		varchar(50),
	@JOB		varchar(20),
	@cd_user varchar(6),
	@cd_site	char(1)

as
SET NOCOUNT ON	

	--Declare 
	--	@Cliente varchar(50),
	--	@Charge		varchar(50),
	--	@JOB		varchar(20),
	--	@cd_user varchar(6),
	--	@cd_site	char(1)

	--set @Cliente = 'GIVAUDAN - 637C'
	--set @Charge ='%'
	--set @JOB = '%EMGVD201609001BR%'
	--set @cd_site = 'A'
	
	declare @CD_PES varchar(10)	
	set @CD_PES = (Select cd_pes  from pessoa With(nolock) where apelido = @Cliente)
		
	select 
		CC.Num_Proc_hia			Processo, 
		TT.Nome_tp_tx			Taxa, 
		CC.DC_hia				DC, 
		TM.Nome_tp_moeda		Moeda,
		CC.Vlr_Org_hia			Vlr_Org,
		(case When
			CC.Num_NF_HIA is not NULL
		Then 
			CC.Par_NF_HIA 
		else 
		--	dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		--end ) Par_Moeda,
		(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
			else
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		end)end)end)end)end)		Par_Moeda,
		TT.NF					T_NF,
		Repasse_TX				Repasse_TX,
		CC.num_nf_hia NF, 
		CC.ref_acesso_nf_hia [Site]
		,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx		
	from vwCTA_CTE CC With(noLock)
		join tipo_Taxa TT With(noLock) on CC.cd_tp_tx = TT.cd_tp_tx
		left Join Tipo_Moeda TM With(noLock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join vwCxas CXA With(noLock) on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia		  
		Join Pessoa_Atl_AX AX With(noLock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'		
		Left Join vwFaturasValidas FAt With(noLock) on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc    		
		Left join vwAXDocs AXD with (nolock)on CC.Num_Proc_HIA = AXD.Num_proc  and CC.cd_tp_tx = AXD.Cd_Tp_Tx_ATL and cc.DC_HIA = AXD.dc				
		Left Join vwInvoice_NFValidas NFI With(noLock) on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc  		
		Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA
		left join Tipo_taxaXTipo_NF_Doc_Register TN With(noLock) on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
		join [vwCliente_Alerta] V with(nolock) on V.num_proc = CC.Num_proc_hia
		join Campo_Processo CP  with(nolock) on CP.Num_Proc = CC.Num_proc_hia and Id_Campo = 143
	where
		TT.Nome_Tp_Tx like @Charge 
		and CC.Num_Proc_Hia like @JOB  
		and convert(datetime,dt_ins_hia,103) > getdate() - 450
		and CC.cd_cred_dev_hia = @CD_pes 		
		and desp_org_hia='N' 
		and desat_tx='N'
		and CXA.Num_Lcto is null
		and Fat.num_proc is null
		and NFI.num_proc is null
		and CC.Num_NF_HIA is null
		and AXD.id_Ax is null		
		and CC.Vlr_Org_hia <> 0
		and S.ID is null		
		and (
			--Alessandra 05/03/2020 - 100-215446 - NF Sao Caetano
			--(@cd_site in ('I','A','C','H') and TN.cd_servico is not null)
			--OR
			--(@cd_site not in('I','A','C','H') and TN.cd_servico is null)
			--)
			(@cd_site in ('I','J','K','A','C','H') and TN.cd_servico is not null)
			OR
			(@cd_site not in('I','J','K','A','C','H') and TN.cd_servico is null)
			)
/* 
		and (
			(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
			or
			(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
			or
			(LEFT(CC.Num_proc_hia,1) = 'B' and isnull(CP.Campo_Dados,1) in (1,2,3))
			or
			(CP.Campo_Dados =1)			
			)
*/
		--and V.Master = 'JOB'	
			
	UNION ALL
		select 
		CC.Num_Proc_hia			Processo, 
		TT.Nome_tp_tx			Taxa, 
		CC.DC_hia				DC, 
		TM.Nome_tp_moeda		Moeda,
		CC.Vlr_Org_hia			Vlr_Org,
		(case When
			CC.Num_NF_HIA is not NULL
		Then 
			CC.Par_NF_HIA 
		else 
		--	dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		--end ) Par_Moeda,
		(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
			else
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		end)end)end)end)end)		Par_Moeda,
		TT.NF					T_NF,
		Repasse_TX				Repasse_TX,
		CC.num_nf_hia NF, 
		CC.ref_acesso_nf_hia [Site]
		,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx		
	from vwCTA_CTE CC With(noLock)
		join tipo_Taxa TT With(noLock) on CC.cd_tp_tx = TT.cd_tp_tx
		left Join Tipo_Moeda TM With(noLock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join vwCxas CXA With(noLock) on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia		  
		Join Pessoa_Atl_AX AX With(noLock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'		
		Left Join vwFaturasValidas FAt With(noLock) on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc    		
		Left join vwAXDocs AXD with (nolock)on CC.Num_Proc_HIA = AXD.Num_proc  and CC.cd_tp_tx = AXD.Cd_Tp_Tx_ATL and cc.DC_HIA = AXD.dc				
		Left Join vwInvoice_NFValidas NFI With(noLock) on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc  		
		Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA
		left join Tipo_taxaXTipo_NF_Doc_Register TN With(noLock) on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site	
		join [vwCliente_Alerta] V with(nolock) on V.Master = CC.Num_proc_hia 
		join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143
	where
		TT.Nome_Tp_Tx like @Charge 
		and CC.Num_Proc_Hia like @JOB  
		and convert(datetime,dt_ins_hia,103) > getdate() - 450
		and CC.cd_cred_dev_hia = @CD_pes 		
		and desp_org_hia='N' 
		and desat_tx='N'
		and CXA.Num_Lcto is null
		and Fat.num_proc is null
		and NFI.num_proc is null
		and CC.Num_NF_HIA is null
		and AXD.id_Ax is null		
		and CC.Vlr_Org_hia <> 0
		and S.ID is null		
		and (
			--Alessandra 05/03/2020 - 100-215446 - NF Sao Caetano
			--(@cd_site in ('I','A','C','H') and TN.cd_servico is not null)
			--OR
			--(@cd_site not in('I','A','C','H') and TN.cd_servico is null)
			--)
			(@cd_site in ('I','J','K','A','C','H') and TN.cd_servico is not null)
			OR
			(@cd_site not in('I','J','K','A','C','H') and TN.cd_servico is null)
			)
	/*
		and (
			(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
			or
			(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
			or
			(LEFT(CC.Num_proc_hia,1) = 'B' and isnull(CP.Campo_Dados,1) in (1,2,3))
			or
			(CP.Campo_Dados =1)
			
			)
    */
		--and V.Master <> 'JOB'
--------------------------------------------------------------------------------------------------------------
--Original da produção em 25/01/2023 ticket 100-376296 –TRANSPORTATION - Faturamento antecipado
/*
USE [Atlantis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Incluido um Table pra fatura_nf, pois estava duplicando os valores igual o item fat -Cadu = 30/06/2014
--incluido só trazer taxas com vinculação de servico - 14/08/2015 - cadu
--Incluido um Table pra fatura_nf, pois estava duplicando os valores igual o item fat -Cadu = 30/06/2014
--incluido ser pela vwFaturas - cadu 15-09-2015
--incluido ser pela vwInvoice_NFValidas - cadu 15-09-2015
--incluido nao trazer taxas sem codigo de serviço - cadu 15-09-2015
--2-9-2016 - incluido o left jon com axdocs - cadu
--incluido verificar o Campo_Processo-BDP Produto, qdo for Freight ou Freight + CHB - tem q ter ATD ou ATA

--26-10-2016 - incluido p trazer o master
--[spNF_Fatura_DispBusca_Sel]'ABSA - 1691C','%','EAGRU201610007','admin','A'
ALTER procedure [dbo].[spNF_Fatura_DispBusca_Sel]--'ET LTDA','admin'

	@Cliente varchar(50),
	@Charge		varchar(50),
	@JOB		varchar(20),
	@cd_user varchar(6),
	@cd_site	char(1)

as
SET NOCOUNT ON	

	--Declare 
	--	@Cliente varchar(50),
	--	@Charge		varchar(50),
	--	@JOB		varchar(20),
	--	@cd_user varchar(6),
	--	@cd_site	char(1)

	--set @Cliente = 'GIVAUDAN - 637C'
	--set @Charge ='%'
	--set @JOB = '%EMGVD201609001BR%'
	--set @cd_site = 'A'
	
	declare @CD_PES varchar(10)	
	set @CD_PES = (Select cd_pes  from pessoa With(nolock) where apelido = @Cliente)
		
	select 
		CC.Num_Proc_hia			Processo, 
		TT.Nome_tp_tx			Taxa, 
		CC.DC_hia				DC, 
		TM.Nome_tp_moeda		Moeda,
		CC.Vlr_Org_hia			Vlr_Org,
		(case When
			CC.Num_NF_HIA is not NULL
		Then 
			CC.Par_NF_HIA 
		else 
		--	dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		--end ) Par_Moeda,
		(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
			else
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		end)end)end)end)end)		Par_Moeda,
		TT.NF					T_NF,
		Repasse_TX				Repasse_TX,
		CC.num_nf_hia NF, 
		CC.ref_acesso_nf_hia [Site]
		,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx		
	from vwCTA_CTE CC With(noLock)
		join tipo_Taxa TT With(noLock) on CC.cd_tp_tx = TT.cd_tp_tx
		left Join Tipo_Moeda TM With(noLock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join vwCxas CXA With(noLock) on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia		  
		Join Pessoa_Atl_AX AX With(noLock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'		
		Left Join vwFaturasValidas FAt With(noLock) on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc    		
		Left join vwAXDocs AXD with (nolock)on CC.Num_Proc_HIA = AXD.Num_proc  and CC.cd_tp_tx = AXD.Cd_Tp_Tx_ATL and cc.DC_HIA = AXD.dc				
		Left Join vwInvoice_NFValidas NFI With(noLock) on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc  		
		Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA
		left join Tipo_taxaXTipo_NF_Doc_Register TN With(noLock) on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
		join [vwCliente_Alerta] V with(nolock) on V.num_proc = CC.Num_proc_hia
		join Campo_Processo CP  with(nolock) on CP.Num_Proc = CC.Num_proc_hia and Id_Campo = 143
	where
		TT.Nome_Tp_Tx like @Charge 
		and CC.Num_Proc_Hia like @JOB  
		and convert(datetime,dt_ins_hia,103) > getdate() - 450
		and CC.cd_cred_dev_hia = @CD_pes 		
		and desp_org_hia='N' 
		and desat_tx='N'
		and CXA.Num_Lcto is null
		and Fat.num_proc is null
		and NFI.num_proc is null
		and CC.Num_NF_HIA is null
		and AXD.id_Ax is null		
		and CC.Vlr_Org_hia <> 0
		and S.ID is null		
		and (
			--Alessandra 05/03/2020 - 100-215446 - NF Sao Caetano
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
			(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
			or
			(LEFT(CC.Num_proc_hia,1) = 'B' and isnull(CP.Campo_Dados,1) in (1,2,3))
			or
			(CP.Campo_Dados =1)			
			)
		--and V.Master = 'JOB'	
			
	UNION ALL
		select 
		CC.Num_Proc_hia			Processo, 
		TT.Nome_tp_tx			Taxa, 
		CC.DC_hia				DC, 
		TM.Nome_tp_moeda		Moeda,
		CC.Vlr_Org_hia			Vlr_Org,
		(case When
			CC.Num_NF_HIA is not NULL
		Then 
			CC.Par_NF_HIA 
		else 
		--	dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		--end ) Par_Moeda,
		(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
			else
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		end)end)end)end)end)		Par_Moeda,
		TT.NF					T_NF,
		Repasse_TX				Repasse_TX,
		CC.num_nf_hia NF, 
		CC.ref_acesso_nf_hia [Site]
		,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx		
	from vwCTA_CTE CC With(noLock)
		join tipo_Taxa TT With(noLock) on CC.cd_tp_tx = TT.cd_tp_tx
		left Join Tipo_Moeda TM With(noLock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join vwCxas CXA With(noLock) on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia		  
		Join Pessoa_Atl_AX AX With(noLock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'		
		Left Join vwFaturasValidas FAt With(noLock) on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc    		
		Left join vwAXDocs AXD with (nolock)on CC.Num_Proc_HIA = AXD.Num_proc  and CC.cd_tp_tx = AXD.Cd_Tp_Tx_ATL and cc.DC_HIA = AXD.dc				
		Left Join vwInvoice_NFValidas NFI With(noLock) on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc  		
		Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA
		left join Tipo_taxaXTipo_NF_Doc_Register TN With(noLock) on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site	
		join [vwCliente_Alerta] V with(nolock) on V.Master = CC.Num_proc_hia 
		join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143
	where
		TT.Nome_Tp_Tx like @Charge 
		and CC.Num_Proc_Hia like @JOB  
		and convert(datetime,dt_ins_hia,103) > getdate() - 450
		and CC.cd_cred_dev_hia = @CD_pes 		
		and desp_org_hia='N' 
		and desat_tx='N'
		and CXA.Num_Lcto is null
		and Fat.num_proc is null
		and NFI.num_proc is null
		and CC.Num_NF_HIA is null
		and AXD.id_Ax is null		
		and CC.Vlr_Org_hia <> 0
		and S.ID is null		
		and (
			--Alessandra 05/03/2020 - 100-215446 - NF Sao Caetano
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
			(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
			or
			(LEFT(CC.Num_proc_hia,1) = 'B' and isnull(CP.Campo_Dados,1) in (1,2,3))
			or
			(CP.Campo_Dados =1)
			
			)
		--and V.Master <> 'JOB'
*/

---
	
/*ALTER procedure [dbo].[spNF_Fatura_DispBusca_Sel]--'ET LTDA','admin'

	@Cliente varchar(50),
	@Charge		varchar(50),
	@JOB		varchar(20),
	@cd_user varchar(6),
	@cd_site	char(1)

as
SET NOCOUNT ON	

	declare @CD_PES varchar(10)	
	set @CD_PES = (Select cd_pes  from pessoa With(nolock) where apelido = @Cliente)
		
	select 
		CC.Num_Proc_hia			Processo, 
		TT.Nome_tp_tx			Taxa, 
		CC.DC_hia				DC, 
		TM.Nome_tp_moeda		Moeda,
		CC.Vlr_Org_hia			Vlr_Org,
		(case When
			CC.Num_NF_HIA is not NULL
		Then 
			CC.Par_NF_HIA 
		else 
		--	dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		--end ) Par_Moeda,
		(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
			else 
		(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
			else
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		end)end)end)end)end)		Par_Moeda,
		TT.NF					T_NF,
		Repasse_TX				Repasse_TX,
		CC.num_nf_hia NF, 
		CC.ref_acesso_nf_hia [Site]
		,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx
	from vwCTA_CTE CC With(noLock)
		join tipo_Taxa TT With(noLock) on CC.cd_tp_tx = TT.cd_tp_tx
		left Join Tipo_Moeda TM With(noLock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join vwCxas CXA With(noLock) on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia		  
		Join Pessoa_Atl_AX AX With(noLock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'
		Left Join vwFaturasValidas FAt With(noLock) on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc    		
		Left join vwAXDocs AXD with (nolock)on CC.Num_Proc_HIA = AXD.Num_proc  and CC.cd_tp_tx = AXD.Cd_Tp_Tx_ATL and cc.DC_HIA = AXD.dc				
		Left Join vwInvoice_NFValidas NFI With(noLock) on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc 
		Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA 		
		left join Tipo_taxaXTipo_NF_Doc_Register TN With(noLock) on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
	where
		TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Hia like @JOB  
		and convert(datetime,dt_ins_hia,103) > getdate() - 450
		and CC.cd_cred_dev_hia = @CD_pes 		
		and desp_org_hia='N' 
		and desat_tx='N'
		and CXA.Num_Lcto is null
		and Fat.num_proc is null
		and NFI.num_proc is null
		and CC.Num_NF_HIA is null
		and AXD.id_Ax is null
		and S.ID is null
		and CC.Vlr_Org_hia <> 0		
		and (
			(@cd_site in ('I','A','C','H') and TN.cd_servico is not null)
			OR
			(@cd_site not in('I','A','C','H') and TN.cd_servico is null)
			)*/

/*Codigo Antigo
ALTER procedure [dbo].[spNF_Fatura_DispBusca_Sel]--'ET LTDA','admin'

	@Cliente varchar(50),
	@Charge		varchar(50),
	@JOB		varchar(20),
	@cd_user varchar(6),
	@cd_site	char(1)

as
SET NOCOUNT ON	

	declare @CD_PES varchar(10)	
	set @CD_PES = (Select cd_pes  from pessoa With(nolock) where apelido = @Cliente)

	Declare @Fatura Table
		(
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1)			
		)
	Begin 		
		Insert @Fatura			
			Select (case when len(i.fatcod)= 15 then left(i.fatcod,14) else	left(i.fatcod,16) end),	
			cd_tp_Tx,dc from item_fat I				
				Join Fatura F on F.fatcod=i.fatcod 
			where
				fatdtEmissao >='01-01-2013' 
				--and i.FatCod like '%imcsr201112219br%' 
				and fatstatus =1
	End	
	
	Declare @Invoice_NF Table
		(
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1)			
		)
	Begin 		
		Insert @Invoice_NF			
			Select I.num_proc,	
			cd_tp_Tx,dc from NF_Fatura_Item I				
				Join NF_Fatura F on F.id=i.id 
			where				 
				--I.num_proc like '%IMATL201312128BR%' 
				I.num_proc like @JOB
				and isnull(cd_status,0) <> 2
	End		

	select 
		CC.Num_Proc_hia			Processo, 
		TT.Nome_tp_tx			Taxa, 
		CC.DC_hia				DC, 
		TM.Nome_tp_moeda		Moeda,
		CC.Vlr_Org_hia			Vlr_Org, 
--		Par_Moeda_him			Par_Moeda,
		(case When
			CC.Num_NF_HIA is not NULL
		Then 
			CC.Par_NF_HIA 
		else 
			dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
		end ) Par_Moeda,
		TT.NF					T_NF,
		Repasse_TX				Repasse_TX,
		CC.num_nf_hia NF, 
		CC.ref_acesso_nf_hia [Site]
		,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao
	from vwCTA_CTE CC
		join tipo_Taxa TT With(noLock) on CC.cd_tp_tx = TT.cd_tp_tx
		left Join Tipo_Moeda TM With(noLock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join vwCxas CXA on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia		  
		--left Join NF_Fatura_Item NFI on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc
		--left Join NF_Fatura NF on  NF.ID = NFI.ID and isnull(cd_status,0) <> 2
		Join Pessoa_Atl_AX AX With(noLock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'
		Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc    		
		Left Join @Invoice_NF NFI on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc  		
		left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
	where
		TT.Nome_Tp_Tx like @Charge and CC.Num_Proc_Hia like @JOB  
		and convert(datetime,dt_ins_hia,103) > getdate() - 450
		and CC.cd_cred_dev_hia = @CD_pes 		
		and desp_org_hia='N' 
		and desat_tx='N'
		and CXA.Num_Lcto is null
		and Fat.num_proc is null
		and NFI.num_proc is null
		and CC.Num_NF_HIA is null
		and CC.Vlr_Org_hia <> 0

*/

GO

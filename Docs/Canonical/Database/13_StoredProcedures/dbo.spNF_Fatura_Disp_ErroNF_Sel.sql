SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spNF_Fatura_Disp_ErroNF_Sel 'VANGUARD SS - 2655C','SRDS','K'

CREATE procedure [dbo].[spNF_Fatura_Disp_ErroNF_Sel]--'OSRAM COMER - 3209C','admin','I'

	@Cliente varchar(50),
	@cd_user varchar(6),
	@cd_site	char(1)
as

SET NOCOUNT ON	
	
	declare @CD_PES varchar(10)	
	set @CD_PES = (Select cd_pes from pessoa with(nolock) where Apelido = @Cliente)	

	select 
		CC.Num_Proc_hia			Processo, 
		TT.Nome_tp_tx			Taxa, 
		CC.DC_hia				DC, 
		TM.Nome_tp_moeda		Moeda,
		CC.Vlr_Org_hia			Vlr_Org, 
----		Par_Moeda_him			Par_Moeda,
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
			end)end)end)end)end)		Par_Moeda,		
		TT.NF					T_NF,
		Repasse_TX				Repasse_TX,
		CC.num_nf_hia NF, 
		CC.ref_acesso_nf_hia [Site]
		
		,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx
	from vwCTA_CTE CC with(nolock)
		join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx		
		left Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join vwCxas CXA with(nolock) on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia		  
		Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'
		Left Join vwFaturasValidas FAt with(nolock) on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc    
		Left join vwAXDocs AXD with (nolock)on CC.Num_Proc_HIA = AXD.Num_proc  and CC.cd_tp_tx = AXD.Cd_Tp_Tx_ATL and cc.DC_HIA = AXD.dc				
		Left Join vwInvoice_NFValidas NFI with(nolock) on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc  		
		Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA
		left join Tipo_taxaXTipo_NF_Doc_Register TN with(nolock) on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
		join [vwCliente_Alerta] V with(nolock) on V.num_proc = CC.Num_proc_hia
		join Campo_Processo CP  with(nolock) on CP.Num_Proc = CC.Num_proc_hia and Id_Campo = 143
	where 
		cc.Num_Proc_HIA in ( 'BOATL202605008BR','BOATL202605009BR','BOSOL202605066BR','BOSUN202605002BR') and
		convert(datetime,dt_ins_hia,103) > getdate() - 450
		and CC.cd_cred_dev_hia = @CD_PES		
		and desp_org_hia='N' 
		and desat_tx='N'
		and CXA.Num_Lcto is null	
		and Fat.num_proc is null
		--and NFI.num_proc is null
		--and CC.Num_NF_HIA is null
		and AXD.id_Ax is null
		and CC.Vlr_Org_hia <> 0
		and S.ID is null
		and (
			   (@cd_site in ('J','K','I','A','C','H') and TN.cd_servico is not null)  
			   OR  
			   (@cd_site not in('J','K','I','A','C','H') and TN.cd_servico is null)  
			)
		and (
			(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
			or
			(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
			or
			(LEFT(CC.Num_proc_hia,1) = 'B' and isnull(CP.Campo_Dados,1) in (1,2,3))
			or
			(CP.Campo_Dados in (1))
			)
		 --and V.Master = 'JOB'
			
	UNION ALL
	
	select 
		CC.Num_Proc_hia			Processo, 
		TT.Nome_tp_tx			Taxa, 
		CC.DC_hia				DC, 
		TM.Nome_tp_moeda		Moeda,
		CC.Vlr_Org_hia			Vlr_Org, 
----		Par_Moeda_him			Par_Moeda,
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
			end)end)end)end)end)		Par_Moeda,		
		TT.NF					T_NF,
		Repasse_TX				Repasse_TX,
		CC.num_nf_hia NF, 
		CC.ref_acesso_nf_hia [Site]		
		,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx
	from vwCTA_CTE CC with(nolock)
		join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx		
		left Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join vwCxas CXA with(nolock) on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia		  
		Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'
		Left Join vwFaturasValidas FAt with(nolock) on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc    
		Left join vwAXDocs AXD with (nolock)on CC.Num_Proc_HIA = AXD.Num_proc  and CC.cd_tp_tx = AXD.Cd_Tp_Tx_ATL and cc.DC_HIA = AXD.dc				
		Left Join vwInvoice_NFValidas NFI with(nolock) on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc  		
		Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA
		left join Tipo_taxaXTipo_NF_Doc_Register TN with(nolock) on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site
		join [vwCliente_Alerta] V with(nolock) on V.Master = CC.Num_proc_hia 
		join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143
	where 
		convert(datetime,dt_ins_hia,103) > getdate() - 450
		and CC.cd_cred_dev_hia = @CD_PES		
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
			(@cd_site in ('J','K','I','A','C','H') and TN.cd_servico is not null)  
		   OR  
		   (@cd_site not in('J','K','I','A','C','H') and TN.cd_servico is null) 
			)
		and (
			(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
			or
			(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
			or
			(LEFT(CC.Num_proc_hia,1) = 'B' and isnull(CP.Campo_Dados,1) in (1,2,3))
			or
			(CP.Campo_Dados in (1))
			)
			
			


GO

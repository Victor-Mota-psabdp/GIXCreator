SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_ExportBrasil_Sel]
	@all varchar(3)

as

	select 
		nome_armador							[Armador],
		sh.nome_Raz_soc							[Shipper],
		mawb_mem								[MAWB],
		Cs.nome_raz_soc							[Razão Social],
		num_proc_hem							[Processo],
		org.nome_local							[Origem],
		dst.nome_local							[Destino],
		datename(mm,(isnull(convert(datetime,dt_saida_mem,105),etd_lem))) [Mês de Saída],
		dbo.fBusca_TEUS(num_proc_hem) [TEUS]
	from 
		  house_exp_mar hou With(nolock)
		  Join Pessoa CS With(nolock) on cd_consig_hem=CS.cd_pes
		  Join Localidade ORG With(nolock) on org.cd_local=cd_org_hem
		  Join Pessoa SH With(nolock) on cd_export_hem=SH.cd_pes
		  Join Localidade dST With(nolock) on dst.cd_local=cd_dst_hem
		  Join Master_Exp_Mar MAS With(nolock) on MAS.num_proc_mem=hou.num_proc_mem and mas.num_proC_mem not like 'EMCLI%' and mas.num_proc_mem <> 'JOB'
		  Left Join LLP_Exp_MAr LLP With(nolock) on llp.num_proc_lem=hou.num_proc_hem
		  Left Join Armador ARM With(nolock) on ARM.cd_armador=mas.cd_armador
	where
		  (convert(datetime,dt_saida_mem,105) >='01-01-2010' or etd_lem >='01-01-2010')


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   procedure spCIA_CLI_REL 
	
		@DataInicial char (10),
		@DataFinal char (10)
	
as

select hea. num_proc_hea, cia.nome_cia_aer, ps.apelido, nl.nome_local, peso_tax_mea, vlr_frete_tot_hea from master_exp_aer as mea
left join house_exp_aer as hea on mea.num_proc_mea = hea.num_proc_mea
left join cia_aerea as cia on mea.cd_cia_aer = cia.cd_cia_aer
left join pessoa as ps on hea.cd_export_hea = ps.cd_pes
left join localidade as nl on mea.cd_dst_mea = nl.cd_local
where convert (datetime,dt_saida_mea, 105) between @DataInicial and @DataFinal 




GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    procedure sp_mov_cta_cte_sts
			
			@Exportador	varchar(30),
			@CredorDevedor	varchar(30),
			@datainicial	varchar(10),
			@dataFinal	varchar(10),
			@DN		varchar(1)
AS
select 
	exportador.apelido as Exportador,cta.num_proc_him, nome_tp_tx,
	convert(datetime, dt_ins_him,105) as Data, CTE.Apelido as CredorDevedor, cta.dc_him, 
	cta.cd_tp_moeda,cast(vlr_org_him as money) as Valor, num_dcn_him 

from cta_cte_hou_imp_mar as cta

	inner join house_imp_mar on house_imp_mar.num_proc_him=cta.num_proc_him
	inner join Pessoa as exportador on cd_export_him=exportador.cd_pes
	inner join Pessoa as CTE on cd_cred_dev_him=cte.cd_pes
	inner join tipo_taxa on tipo_taxa.cd_tp_tx=cta.cd_tp_tx
	left join caixa_hou_imp_mar as cxa on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_him=cxa.dc_him)
where 
	exportador.apelido like @Exportador and cte.apelido like @CredorDevedor
	and comp_dn_him like @DN and convert(datetime, dt_ins_him, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @DataFinal, 105)
 	and cxa.num_proc_him is null




GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE SpFaturamento
	
		@Cliente	varchar(30),
		@DataInicial	varchar(10),
		@DataFinal	varchar(10),
		@BDPSA		varchar(5),
		@usuario	varchar(20)
AS	
select 
apelido, min(obs_pes)as ClienteBDP,sum(cast(vlr_item_nf as money)) as Valor , min(dt_emis_nf) as Data, 'Importação Maritima' as Modal
from item_nota_fiscal
left join house_imp_mar on num_proc=num_proc_him
inner join pessoa on cd_import_him = cd_pes
inner join nota_fiscal on nota_fiscal.num_nf=item_nota_fiscal.num_nf
where convert(datetime, dt_emis_nf, 105) between convert(datetime, @DataInicial, 105) and convert(datetime, @DataFinal, 105) 
and apelido like @Cliente and obs_pes like @BDPSA
group by apelido
Union
select 
apelido, min(obs_pes)as ClienteBDP,sum(cast(vlr_item_nf as money)) as Valor , min(dt_emis_nf) as Data, 'Exportação Maritima' as Modal
from item_nota_fiscal
left join house_exp_mar on num_proc=num_proc_hem
inner join pessoa on cd_export_hem = cd_pes
inner join nota_fiscal on nota_fiscal.num_nf=item_nota_fiscal.num_nf
where convert(datetime, dt_emis_nf, 105) between convert(datetime, @DataInicial, 105) and convert(datetime, @DataFinal, 105) 
and apelido like @Cliente and obs_pes like @BDPSA
group by apelido
Union
select 
apelido, min(obs_pes)as ClienteBDP,sum(cast(vlr_item_nf as money)) as Valor , min(dt_emis_nf) as Data , 'Importação Aérea' as Modal
from item_nota_fiscal
left join house_Imp_aer on num_proc=num_proc_hia
inner join pessoa on cd_import_hia = cd_pes
inner join nota_fiscal on nota_fiscal.num_nf=item_nota_fiscal.num_nf
where convert(datetime, dt_emis_nf, 105) between convert(datetime, @DataInicial, 105) and convert(datetime, @DataFinal, 105) 
and apelido like @Cliente and obs_pes like @BDPSA
group by apelido
Union
select 
apelido, min(obs_pes)as ClienteBDP,sum(cast(vlr_item_nf as money)) as Valor , min(dt_emis_nf) as Data, 'Exportação Aérea' as Modal
from item_nota_fiscal
left join house_exp_aer on num_proc=num_proc_hea
inner join pessoa on cd_export_hea = cd_pes
inner join nota_fiscal on nota_fiscal.num_nf=item_nota_fiscal.num_nf
where convert(datetime, dt_emis_nf, 105) between convert(datetime, @DataInicial, 105) and convert(datetime, @DataFinal, 105) 
and apelido like @Cliente and obs_pes like @BDPSA
group by apelido



GO

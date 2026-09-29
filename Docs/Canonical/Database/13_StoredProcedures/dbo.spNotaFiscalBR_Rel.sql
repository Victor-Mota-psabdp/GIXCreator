SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[spNotaFiscalBR_Rel] --'B', '30560'

	@Tipo		char(1),
	@Numero		varchar(12)

as

select CC.num_proc_hem NUM,Nome_Raz_Soc Razao_Social,ED.Rua Endereco,ED.Numero Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx TX_NF, (case when TX.cd_tp_tx is  not null then 'Serviços Prestados' else TT.Nome_tp_tx end) Taxa, CC.DC_Hem DC, CC.Vlr_Pgto_NF_hem Vlr_Pgto_NF,BNF.HABILITA_Impostos  from cta_cte_hou_exp_mar CC
left outer join base_nota_fiscal BNF on CC.Num_NF_HEM = BNF.Nota_fiscal and CC.Ref_Acesso_NF_HEM = BNF.Ref_Acesso 
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
join Pessoa PS on BNF.cd_pes = PS.cd_pes
join Endereco ED	on BNF.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
where  CC.Num_Nf_Hem =@Numero and ref_Acesso_nf_hem = @Tipo
group by CC.num_proc_hem,Nome_Raz_Soc,ED.Rua,ED.Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx , TT.Nome_tp_tx, CC.DC_Hem, CC.Vlr_Pgto_NF_hem,BNF.HABILITA_Impostos

union

select CC.num_proc_him NUM,Nome_Raz_Soc Razao_Social,ED.Rua Endereco,ED.Numero Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx TX_NF, (case when TX.cd_tp_tx is not null then 'Serviços Prestados' else TT.Nome_tp_tx end) Taxa, CC.DC_Him DC, CC.Vlr_Pgto_NF_him Vlr_Pgto_NF,BNF.HABILITA_Impostos from cta_cte_hou_imp_mar CC
left outer join base_nota_fiscal BNF on CC.Num_NF_HIM = BNF.Nota_fiscal and CC.Ref_Acesso_NF_HIM = BNF.Ref_Acesso
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
join Pessoa PS on BNF.cd_pes = PS.cd_pes
join Endereco ED	on BNF.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
where  CC.Num_Nf_Him =@Numero and ref_Acesso_nf_him = @Tipo
group by  CC.num_proc_him,Nome_Raz_Soc,ED.Rua,ED.Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx , TT.Nome_tp_tx, CC.DC_Him, CC.Vlr_Pgto_NF_him,BNF.HABILITA_Impostos

union

select CC.num_proc_hia NUM, Nome_Raz_Soc Razao_Social,ED.Rua Endereco,ED.Numero Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx TX_NF, (case when TX.cd_tp_tx is not null then 'Serviços Prestados' else TT.Nome_tp_tx end) Taxa, CC.DC_Hia DC, CC.Vlr_Pgto_NF_hia Vlr_Pgto_NF,BNF.HABILITA_Impostos from cta_cte_hou_imp_aer CC
left outer join base_nota_fiscal BNF on CC.Num_NF_Hia = BNF.Nota_fiscal and CC.Ref_Acesso_NF_Hia = BNF.Ref_Acesso
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
join Pessoa PS on BNF.cd_pes = PS.cd_pes
join Endereco ED	on BNF.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
where  CC.Num_Nf_Hia =@Numero and ref_Acesso_nf_hia = @tipo
group by  CC.num_proc_hia, Nome_Raz_Soc,ED.Rua,ED.Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx , TT.Nome_tp_tx, CC.DC_Hia, CC.Vlr_Pgto_NF_hia,BNF.HABILITA_Impostos

union

select CC.num_proc_hea NUM, Nome_Raz_Soc Razao_Social,ED.Rua Endereco,ED.Numero Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx TX_NF, 	(case when TX.cd_tp_tx is not null then 'Serviços Prestados' else TT.Nome_tp_tx end) Taxa, CC.DC_Hea DC, CC.Vlr_Pgto_NF_hea Vlr_Pgto_NF,BNF.HABILITA_Impostos from cta_cte_hou_exp_aer CC
left outer join base_nota_fiscal BNF on CC.Num_NF_HEA = BNF.Nota_fiscal and CC.Ref_Acesso_NF_HEA = BNF.Ref_Acesso
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
join Pessoa PS on BNF.cd_pes = PS.cd_pes
join Endereco ED	on BNF.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
where  CC.Num_Nf_Hea =@Numero and ref_Acesso_nf_hea = @tipo
group by  CC.num_proc_hea,Nome_Raz_Soc,ED.Rua,ED.Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx , TT.Nome_tp_tx, CC.DC_Hea, CC.Vlr_Pgto_NF_hea,BNF.HABILITA_Impostos

union

select CC.num_proc_heo NUM, Nome_Raz_Soc Razao_Social,ED.Rua Endereco,ED.Numero Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx TX_NF, 	(case when TX.cd_tp_tx is not null then 'Serviços Prestados' else TT.Nome_tp_tx end) Taxa, CC.DC_Heo DC, CC.Vlr_Pgto_NF_heo Vlr_Pgto_NF,BNF.HABILITA_Impostos from cta_cte_hou_exp_out CC
left outer join base_nota_fiscal BNF on CC.Num_NF_HEO = BNF.Nota_fiscal and CC.Ref_Acesso_NF_HEO = BNF.Ref_Acesso
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
join Pessoa PS on BNF.cd_pes = PS.cd_pes
join Endereco ED	on BNF.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
where  CC.Num_Nf_Heo =@Numero and ref_Acesso_nf_heo = @tipo
group by  CC.num_proc_heo, Nome_Raz_Soc,ED.Rua,ED.Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx , TT.Nome_tp_tx, CC.DC_Heo, CC.Vlr_Pgto_NF_heo,BNF.HABILITA_Impostos

union

select CC.num_proc_hio NUM, Nome_Raz_Soc Razao_Social,ED.Rua Endereco,ED.Numero Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx TX_NF, (case when TX.cd_tp_tx is not null then 'Serviços Prestados' else TT.Nome_tp_tx end) Taxa, CC.DC_Hio DC, CC.Vlr_Pgto_NF_hio Vlr_Pgto_NF,BNF.HABILITA_Impostos from cta_cte_hou_imp_out CC
left outer join base_nota_fiscal BNF on CC.Num_NF_HIO = BNF.Nota_fiscal and CC.Ref_Acesso_NF_HIO = BNF.Ref_Acesso
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx
join Pessoa PS on BNF.cd_pes = PS.cd_pes
join Endereco ED	on BNF.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
where  CC.Num_Nf_Hio =@Numero and ref_Acesso_nf_hio = @tipo
group by  CC.num_proc_hio, Nome_Raz_Soc,ED.Rua,ED.Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx , TT.Nome_tp_tx, CC.DC_Hio, CC.Vlr_Pgto_NF_hio,BNF.HABILITA_Impostos

union

select CC.num_proc_mia NUM, Nome_Raz_Soc Razao_Social,ED.Rua Endereco,ED.Numero Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx TX_NF, (case when TX.cd_tp_tx is not null then 'Serviços Prestados' else TT.Nome_tp_tx end) Taxa, CC.DC_mia DC, CC.Vlr_Pgto_NF_mia Vlr_Pgto_NF,BNF.HABILITA_Impostos from cta_cte_mas_imp_aer CC
left outer join base_nota_fiscal BNF on CC.Num_NF_MIA = BNF.Nota_fiscal and CC.Ref_Acesso_NF_MIA = BNF.Ref_Acesso
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
join Pessoa PS on BNF.cd_pes = PS.cd_pes
join Endereco ED	on BNF.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
where  CC.Num_Nf_mia =@Numero and ref_Acesso_nf_mia = @tipo and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
group by  CC.num_proc_mia, Nome_Raz_Soc,ED.Rua,ED.Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx , TT.Nome_tp_tx, CC.DC_mia, CC.Vlr_Pgto_NF_mia,BNF.HABILITA_Impostos

union

select CC.num_proc_mea NUM, Nome_Raz_Soc Razao_Social,ED.Rua Endereco,ED.Numero Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx TX_NF,	(case when TX.cd_tp_tx is not null then 'Serviços Prestados' else TT.Nome_tp_tx end) Taxa, CC.DC_mea DC, CC.Vlr_Pgto_NF_mea Vlr_Pgto_NF,BNF.HABILITA_Impostos from cta_cte_mas_exp_aer CC
left outer join base_nota_fiscal BNF on CC.Num_NF_MEA = BNF.Nota_fiscal and CC.Ref_Acesso_NF_MEA = BNF.Ref_Acesso
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx
join Pessoa PS on BNF.cd_pes = PS.cd_pes
join Endereco ED	on BNF.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
where  CC.Num_Nf_mea =@Numero and ref_Acesso_nf_mea = @tipo and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
group by  CC.num_proc_mea, Nome_Raz_Soc,ED.Rua,ED.Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx , TT.Nome_tp_tx, CC.DC_mea, CC.Vlr_Pgto_NF_mea,BNF.HABILITA_Impostos

Union

select CC.num_proc_mim NUM, Nome_Raz_Soc Razao_Social,ED.Rua Endereco,ED.Numero Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx TX_NF, 	(case when TX.cd_tp_tx is not null then 'Serviços Prestados' else TT.Nome_tp_tx end) Taxa, CC.DC_mim DC, CC.Vlr_Pgto_NF_mim Vlr_Pgto_NF,BNF.HABILITA_Impostos from cta_cte_mas_imp_mar CC
left outer join base_nota_fiscal BNF on CC.Num_NF_MIM = BNF.Nota_fiscal and CC.Ref_Acesso_NF_MIM = BNF.Ref_Acesso
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx
join Pessoa PS on BNF.cd_pes = PS.cd_pes
join Endereco ED	on BNF.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
where  CC.Num_Nf_mim =@Numero and ref_Acesso_nf_mim = @tipo and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
group by  CC.num_proc_mim, Nome_Raz_Soc,ED.Rua,ED.Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx , TT.Nome_tp_tx, CC.DC_mim, CC.Vlr_Pgto_NF_mim,BNF.HABILITA_Impostos

union

select CC.num_proc_mem NUM, Nome_Raz_Soc Razao_Social,ED.Rua Endereco,ED.Numero Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx TX_NF,	(case when TX.cd_tp_tx is not null then 'Serviços Prestados' else TT.Nome_tp_tx end) Taxa, CC.DC_mem DC, CC.Vlr_Pgto_NF_mem Vlr_Pgto_NF,BNF.HABILITA_Impostos from cta_cte_mas_exp_mar CC
left outer join base_nota_fiscal BNF on CC.Num_NF_MEM = BNF.Nota_fiscal and CC.Ref_Acesso_NF_MEM = BNF.Ref_Acesso
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx
join Pessoa PS on BNF.cd_pes = PS.cd_pes
join Endereco ED	on BNF.cd_Pes = ED.cd_pes and ED.cd_tp_end = 'COM'
where  CC.Num_Nf_mem =@Numero and ref_Acesso_nf_mem = @tipo and CC.cd_tp_tx not like 'X%' and CC.cd_tp_tx not in('FRT','FRC')
group by  CC.num_proc_mem,BNF.cd_pes, Nome_Raz_Soc,ED.Rua,ED.Numero, ED.Cidade, ED.UF,ED.Pais , num_cpf_cnpj,num_rg_ie,Emissao,Valor_total, Observ_nf, Aliq_ISS, Valor_ISS,  TX.cd_tp_tx , TT.Nome_tp_tx, CC.DC_mem, CC.Vlr_Pgto_NF_mem,BNF.HABILITA_Impostos









GO

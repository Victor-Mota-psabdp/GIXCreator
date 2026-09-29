SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spRelNotaFiscal '2014-10-01','2014-10-02','','A'
--22/05/2014 - incluido o cnpj - solictado por Alex Correa

CREATE PROCEDURE [dbo].[SpRelNotaFiscal] 

	@datainicial datetime,
	@datafinal	datetime,
	
	--gambiarra pra qdo for atualizar o rpt, vc deixa como varchar, atualiza o rpt e depois retorna p/
	--datettime
	--@datainicial varchar(10),
	--@datafinal	varchar(10),
	
	@pessoa		varchar(30),
	@site		varchar(1)
as

If @Site='Y' and @DataInicial >='2006-12-01' 
BEGIN
select num_proc_hia as Processo, nome_tp_tx, pft_aer, apelido, num_nf_hia as NotaFiscal, dc_hia as DC, vlr_pgto_nf_hia  as Valor, emissao, Num_CPF_CNPJ, RPS_NFE,convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_imp_aer with(nolock)
inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_imp_aer.cd_tp_tx)
inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_hia)
inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_hia and ref_acesso=Ref_Acesso_NF_HIA)
left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_hou_imp_aer.num_proc_hia = FV.Num_proc and cta_cte_hou_imp_aer.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_hou_imp_aer.DC_hia = FV.DC
where cta_cte_hou_imp_aer.cd_tp_Tx <> 'FRT' and
RPS_DATA between @datainicial and @datafinal
and apelido like '%' + @pessoa + '%'
and ref_acesso like @site

union

select num_proc_mia as Processo, nome_tp_tx, pft_aer, apelido, num_nf_mia as NotaFiscal, dc_mia as DC, vlr_pgto_nf_mia as  Valor , emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_mas_imp_aer with(nolock)
inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_mas_imp_aer.cd_tp_tx)
inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_mia)
inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_mia AND ref_acesso=Ref_Acesso_NF_MIA)
left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_mas_imp_aer.num_proc_mia = FV.Num_proc and cta_cte_mas_imp_aer.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_mas_imp_aer.DC_mia = FV.DC
where cta_cte_mas_imp_aer.cd_tp_Tx <> 'FRT'
and RPS_DATA between @datainicial and @datafinal
and apelido like '%' + @pessoa + '%'
and ref_acesso like @site

union

select num_proc_hea as Processo, nome_tp_tx, pft_aer, apelido, num_nf_hea as NotaFiscal, dc_hea as DC, vlr_pgto_nf_hea as   Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_exp_aer with(nolock)
inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_exp_aer.cd_tp_tx)
inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_hea)
inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_hea AND ref_acesso=Ref_Acesso_NF_HEA)
left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_hou_exp_aer.num_proc_hea = FV.Num_proc and cta_cte_hou_exp_aer.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_hou_exp_aer.DC_hea = FV.DC
where cta_cte_hou_exp_aer.cd_tp_Tx <> 'FRT'
and RPS_DATA between @datainicial and @datafinal
and apelido like '%' + @pessoa + '%'
and ref_acesso like @site

union

select num_proc_mea as Processo, nome_tp_tx, pft_aer, apelido, num_nf_mea as NotaFiscal, dc_mea as DC, vlr_pgto_nf_mea  as Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_mas_exp_aer with(nolock)
inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_mas_exp_aer.cd_tp_tx)
inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_mea)
inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_mea AND ref_acesso=Ref_Acesso_NF_MEA)
left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_mas_exp_aer.num_proc_mea = FV.Num_proc and cta_cte_mas_exp_aer.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_mas_exp_aer.DC_mea = FV.DC
where cta_cte_mas_exp_aer.cd_tp_Tx <> 'FRT'
and RPS_DATA between @datainicial and @datafinal
and apelido like '%' + @pessoa + '%'
and ref_acesso like @site

union

select num_proc_him as Processo, nome_tp_tx, pft_aer, apelido, num_nf_him as NotaFiscal, dc_him as DC, vlr_pgto_nf_him as Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_imp_mar with(nolock)
inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_imp_mar.cd_tp_tx)
inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_him)
inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_him AND ref_acesso=Ref_Acesso_NF_HIM)
left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_hou_imp_mar.num_proc_him = FV.Num_proc and cta_cte_hou_imp_mar.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_hou_imp_mar.DC_him = FV.DC
where cta_cte_hou_imp_mar.cd_tp_Tx <> 'FRT'
and RPS_DATA between @datainicial and @datafinal
and apelido like '%' + @pessoa + '%'
and ref_acesso like @site

union

select num_proc_hio as Processo, nome_tp_tx, pft_aer, apelido, num_nf_hio as NotaFiscal, dc_hio as DC, vlr_pgto_nf_hio as Valor, emissao , Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_imp_out with(nolock)
inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_imp_out.cd_tp_tx)
inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_hio)
inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_hio AND ref_acesso=Ref_Acesso_NF_hio)
left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_hou_imp_out.num_proc_hio = FV.Num_proc and cta_cte_hou_imp_out.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_hou_imp_out.DC_hio = FV.DC
where cta_cte_hou_imp_out.cd_tp_Tx <> 'FRT'
and RPS_DATA between @datainicial and @datafinal
and apelido like '%' + @pessoa + '%'
and ref_acesso like @site


union

select num_proc_heo as Processo, nome_tp_tx, pft_aer, apelido, num_nf_heo as NotaFiscal, dc_heo as DC, vlr_pgto_nf_heo as Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_exp_out CC with(nolock)
inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=CC.cd_tp_tx)
inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_heo)
inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_heo AND ref_acesso=Ref_Acesso_NF_heo)
left  join dbo.vwFaturasValidas FV with(nolock) on num_proc_heo = FV.Num_proc and CC.Cd_tp_Tx = FV.Cd_Tp_Tx and DC_heo = FV.DC
where CC.cd_tp_Tx <> 'FRT'
and RPS_DATA between @datainicial and @datafinal
and apelido like '%' + @pessoa + '%'
and ref_acesso like @site

union


select num_proc_mim as Processo, nome_tp_tx, pft_aer, apelido, num_nf_mim as NotaFiscal, dc_mim as DC, vlr_pgto_nf_mim  as  Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_mas_imp_mar with(nolock)
inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_mas_imp_mar.cd_tp_tx)
inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_mim)
inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_mim AND ref_acesso=Ref_Acesso_NF_MIM)
left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_mas_imp_mar.num_proc_mim = FV.Num_proc and cta_cte_mas_imp_mar.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_mas_imp_mar.DC_mim = FV.DC
where cta_cte_mas_imp_mar.cd_tp_Tx <> 'FRT'
and RPS_DATA between @datainicial and @datafinal
and apelido like '%' + @pessoa + '%'
and ref_acesso like @site

union

select num_proc_mem as Processo, nome_tp_tx, pft_aer, apelido, num_nf_mem as NotaFiscal, dc_mem as DC,  vlr_pgto_nf_mem  as  Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_mas_exp_mar with(nolock)
inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_mas_exp_mar.cd_tp_tx)
inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_mem)
inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_mem AND ref_acesso=Ref_Acesso_NF_MEM)
left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_mas_exp_mar.num_proc_mem = FV.Num_proc and cta_cte_mas_exp_mar.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_mas_exp_mar.DC_mem = FV.DC
where cta_cte_mas_exp_mar.cd_tp_Tx <> 'FRT'
and RPS_DATA between @datainicial and @datafinal
and apelido like '%' + @pessoa + '%'
and ref_acesso like @site

union

select num_proc_hem as Processo, nome_tp_tx, pft_aer, apelido, num_nf_hem as NotaFiscal, dc_hem as DC, vlr_pgto_nf_hem as  Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_exp_mar with(nolock)
inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_exp_mar.cd_tp_tx)
inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_hem)
inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_hem AND ref_acesso=Ref_Acesso_NF_HEM)
left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_hou_exp_mar.num_proc_hem = FV.Num_proc and cta_cte_hou_exp_mar.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_hou_exp_mar.DC_hem = FV.DC
where cta_cte_hou_exp_mar.cd_tp_Tx <> 'FRT'
and RPS_DATA between @datainicial and @datafinal
and apelido like '%' + @pessoa + '%'
and ref_acesso like @site
option(hash join)
END
ELSE

BEGIN
	select num_proc_hia as Processo, nome_tp_tx, pft_aer, apelido, num_nf_hia as NotaFiscal, dc_hia as DC, vlr_pgto_nf_hia  as Valor, emissao, Num_CPF_CNPJ, RPS_NFE,  convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_imp_aer with(nolock)
	inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_imp_aer.cd_tp_tx)
	inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_hia)
	inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_hia and ref_acesso=Ref_Acesso_NF_HIA)
	left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_hou_imp_aer.num_proc_hia = FV.Num_proc and cta_cte_hou_imp_aer.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_hou_imp_aer.DC_hia = FV.DC
	where cta_cte_hou_imp_aer.cd_tp_Tx <> 'FRT' and
	emissao between @datainicial and @datafinal
	and apelido like '%' + @pessoa + '%'
	and ref_acesso like @site

	union

	select num_proc_mia as Processo, nome_tp_tx, pft_aer, apelido, num_nf_mia as NotaFiscal, dc_mia as DC, vlr_pgto_nf_mia as  Valor , emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_mas_imp_aer with(nolock)
	inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_mas_imp_aer.cd_tp_tx)
	inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_mia)
	inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_mia AND ref_acesso=Ref_Acesso_NF_MIA)
	left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_mas_imp_aer.num_proc_mia = FV.Num_proc and cta_cte_mas_imp_aer.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_mas_imp_aer.DC_mia = FV.DC
	where cta_cte_mas_imp_aer.cd_tp_Tx <> 'FRT'
	and emissao between @datainicial and @datafinal
	and apelido like '%' + @pessoa + '%'
	and ref_acesso like @site

	union

	select num_proc_hea as Processo, nome_tp_tx, pft_aer, apelido, num_nf_hea as NotaFiscal, dc_hea as DC, vlr_pgto_nf_hea as   Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_exp_aer with(nolock)
	inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_exp_aer.cd_tp_tx)
	inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_hea)
	inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_hea AND ref_acesso=Ref_Acesso_NF_HEA)
	left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_hou_exp_aer.num_proc_hea = FV.Num_proc and cta_cte_hou_exp_aer.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_hou_exp_aer.DC_hea = FV.DC
	where cta_cte_hou_exp_aer.cd_tp_Tx <> 'FRT'
	and emissao between @datainicial and @datafinal
	and apelido like '%' + @pessoa + '%'
	and ref_acesso like @site

	union

	select num_proc_mea as Processo, nome_tp_tx, pft_aer, apelido, num_nf_mea as NotaFiscal, dc_mea as DC, vlr_pgto_nf_mea  as Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_mas_exp_aer with(nolock)
	inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_mas_exp_aer.cd_tp_tx)
	inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_mea)
	inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_mea AND ref_acesso=Ref_Acesso_NF_MEA)
	left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_mas_exp_aer.num_proc_mea = FV.Num_proc and cta_cte_mas_exp_aer.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_mas_exp_aer.DC_mea = FV.DC
	where cta_cte_mas_exp_aer.cd_tp_Tx <> 'FRT'
	and emissao between @datainicial and @datafinal
	and apelido like '%' + @pessoa + '%'
	and ref_acesso like @site

	union

	select num_proc_him as Processo, nome_tp_tx, pft_aer, apelido, num_nf_him as NotaFiscal, dc_him as DC, vlr_pgto_nf_him as Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_imp_mar with(nolock)
	inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_imp_mar.cd_tp_tx)
	inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_him)
	inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_him AND ref_acesso=Ref_Acesso_NF_HIM)
	left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_hou_imp_mar.num_proc_him = FV.Num_proc and cta_cte_hou_imp_mar.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_hou_imp_mar.DC_him = FV.DC
	where cta_cte_hou_imp_mar.cd_tp_Tx <> 'FRT'
	and emissao between @datainicial and @datafinal
	and apelido like '%' + @pessoa + '%'
	and ref_acesso like @site

	union

	select num_proc_heo as Processo, nome_tp_tx, pft_aer, apelido, num_nf_heo as NotaFiscal, dc_heo as DC, vlr_pgto_nf_heo as   Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_exp_out with(nolock)
	inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_exp_out.cd_tp_tx)
	inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_heo)
	inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_heo AND ref_acesso=Ref_Acesso_NF_heo)
	left join dbo.vwFaturasValidas FV with(nolock) on num_proc_heo = FV.Num_proc and cta_cte_hou_exp_out.Cd_tp_Tx = FV.Cd_Tp_Tx and DC_heo = FV.DC
	
	where cta_cte_hou_exp_out.cd_tp_Tx <> 'FRT'
	and emissao between @datainicial and @datafinal
	and apelido like '%' + @pessoa + '%'
	and ref_acesso like @site

union

	select num_proc_hio as Processo, nome_tp_tx, pft_aer, apelido, num_nf_hio as NotaFiscal, dc_hio as DC, vlr_pgto_nf_hio as   Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_hou_imp_out with(nolock)
	inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_imp_out.cd_tp_tx)
	inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_hio)
	inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_hio AND ref_acesso=Ref_Acesso_NF_hio)
	left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_hou_imp_out.num_proc_hio = FV.Num_proc and cta_cte_hou_imp_out.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_hou_imp_out.DC_hio = FV.DC
	where cta_cte_hou_imp_out.cd_tp_Tx <> 'FRT'
	and emissao between @datainicial and @datafinal
	and apelido like '%' + @pessoa + '%'
	and ref_acesso like @site


	union

	select num_proc_mim as Processo, nome_tp_tx, pft_aer, apelido, num_nf_mim as NotaFiscal, dc_mim as DC, vlr_pgto_nf_mim  as  Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc  from cta_Cte_mas_imp_mar with(nolock)
	inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_mas_imp_mar.cd_tp_tx)
	inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_mim)
	inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_mim AND ref_acesso=Ref_Acesso_NF_MIM)
	left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_mas_imp_mar.num_proc_mim = FV.Num_proc and cta_cte_mas_imp_mar.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_mas_imp_mar.DC_mim = FV.DC
	where cta_cte_mas_imp_mar.cd_tp_Tx <> 'FRT'
	and emissao between @datainicial and @datafinal
	and apelido like '%' + @pessoa + '%'
	and ref_acesso like @site

	union

	select num_proc_mem as Processo, nome_tp_tx, pft_aer, apelido, num_nf_mem as NotaFiscal, dc_mem as DC,  vlr_pgto_nf_mem  as  Valor, emissao, Num_CPF_CNPJ, RPS_NFE, convert(varchar(10),FatDtVenc,105) FatDtVenc from cta_Cte_mas_exp_mar with(nolock)
	inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_mas_exp_mar.cd_tp_tx)
	inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_mem)
	inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_mem AND ref_acesso=Ref_Acesso_NF_MEM)
	left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_mas_exp_mar.num_proc_mem = FV.Num_proc and cta_cte_mas_exp_mar.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_mas_exp_mar.DC_mem = FV.DC
	where cta_cte_mas_exp_mar.cd_tp_Tx <> 'FRT'
	and emissao between @datainicial and @datafinal
	and apelido like '%' + @pessoa + '%'
	and ref_acesso like @site

	union

	select num_proc_hem as Processo, nome_tp_tx, pft_aer, apelido, num_nf_hem as NotaFiscal, dc_hem as DC, vlr_pgto_nf_hem as  Valor, emissao, Num_CPF_CNPJ, RPS_NFE,convert(varchar(10),FatDtVenc,105) FatDtVenc  from cta_Cte_hou_exp_mar with(nolock)
	inner join tipo_taxa with(nolock) on (tipo_taxa.cd_tp_tx=cta_Cte_hou_exp_mar.cd_tp_tx)
	inner join pessoa with(nolock) on (cd_pes=cd_cred_dev_hem)
	inner join Base_nota_fiscal with(nolock) on (nota_fiscal=num_nf_hem AND ref_acesso=Ref_Acesso_NF_HEM)
	left join dbo.vwFaturasValidas FV with(nolock) on cta_cte_hou_exp_mar.num_proc_hem = FV.Num_proc and cta_cte_hou_exp_mar.Cd_tp_Tx = FV.Cd_Tp_Tx and cta_cte_hou_exp_mar.DC_hem = FV.DC
	where cta_cte_hou_exp_mar.cd_tp_Tx <> 'FRT'
	and emissao between @datainicial and @datafinal
	and apelido like '%' + @pessoa + '%'
	and ref_acesso like @site
option(hash join)
END


GO

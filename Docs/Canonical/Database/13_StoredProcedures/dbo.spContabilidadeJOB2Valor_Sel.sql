SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spContabilidadeJOB2Valor_Sel]--'IMCSR20101000201','S'
	
	@Job varchar(16),
	@Tipo char(1)

As

if @Tipo = 'N'
	BEGIN
		select 
				sum(cast(Isnull(dbo.valor(vlr_pgto_nf_hia,cta.dc_hia),dbo.valor(cta.vlr_org_hia*[dbo].[FConverterMoeda](CTA.cd_tp_moeda,'REL'),cta.dc_hia)) as Decimal(10,2))) Valor
from vwcta_cte CTA
	---	join vwcxas as cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
		join tipo_taxa TT on TT.cd_tp_tx = cta.cd_tp_tx
			
		where 
		cta.num_proc_hia = @JOB
	END
ELSE
	BEGIN
		select 	
			sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) valor 	
		from vwcta_cte CTA	
			Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_hia and NF.ref_acesso=CTA.ref_Acesso_nf_hia
		where cta.num_proc_hia = @JOB and cta.num_nf_hia is not null
	END



GO

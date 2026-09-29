SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spNota_Fiscal_PM_Rel] --'2008-04-01','2008-04-30'

@Dt_Inicial	datetime,
@Dt_Final	datetime

as

select
	right('000000' + nota_fiscal,6)		Nota_fiscal,
	Emissao								dt_emissao,
	right('0000000000' + replace(valor_total,'.',''),10) vlr_total_nf,
	--right('0000' + replace(isnull(aliq_iss,'0000'),'.',''),4)			base_calculo_iss,
	'0300' base_calculo_iss,
	right('0000000000' + replace(isnull(valor_iss,'0000000000')	,'.',''),10)		vlr_iss,	
	left(P.Nome_raz_soc + '                                                ',48)Nome,
	right('00000000000000' + P.num_cpf_cnpj,14)	CNPJ,
	E.rua								RUA,
	E.Numero							Numero,
	E.Compl_End							Complemento,
	E.CEP								CEP,	
	left(E.Cidade + '                         ',25) Cidade,
	E.UF								Estado,
	P.Num_Rg_IE							IE	
from
	base_nota_fiscal NF
	join Pessoa P on P.cd_pes = NF.cd_pes
	join Endereco E on E.cd_pes = P.cd_pes and cd_tp_end = 'COM'

where
	--ref_acesso = 'B' and
	ref_acesso = 'I' and
	emissao between @Dt_Inicial and @Dt_Final
order by
	1





GO

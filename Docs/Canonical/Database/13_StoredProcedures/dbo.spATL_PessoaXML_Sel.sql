SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_PessoaXML_Sel]		

as

Select
		ltrim(PP.Cd_Pes) Cd_Pes,
		ltrim(Apelido) Apelido,
		Nome_Raz_Soc + '|' +
			isnull(Num_CPF_CNPJ + '|','|') +
			isnull('Street:' + Rua,'|') +
			isnull('Nº:'+ Numero,'|') +
			isnull('-'+compl_end + '|','|') +
			isnull('ZIP Code:'+ltrim(Cep) + '|','|') +
			isnull('City:'+Cidade,'|') Completo
From
	Pessoa PP
	Left Join Endereco ED with(nolock) on ED.cd_pes=pp.cd_pes and cd_tp_end='COM'
Where
	Desat_Pes= 'N'
	--and PP.cd_pes = 'P000000017'
GO

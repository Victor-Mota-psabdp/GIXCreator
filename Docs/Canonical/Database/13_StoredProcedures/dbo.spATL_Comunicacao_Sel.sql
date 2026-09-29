SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Comunicacao_Sel] --'ALL'
	@all varchar(3)
AS

select 
Apelido			[Company Name (Short name)], 
Nome_Raz_Soc	[Complete Name],
Num_CPF_CNPJ	[CNPJ],
TC.Nome_Tp_Com	[Type Contact],
C.Contato		[Contact Name],
C.Depto_Ctt		[Responsability],
C.Cd_Int + C.Cd_Area_Fone + C.Prefixo + Num_Fone [Phone Number],
C.Compl_Fone	[E-Mail],
(Case when P.Desat_Pes = 'N' then 'Ativo' Else 'Desativado' end) [Status]
from Pessoa P with(nolock)
left join comunicacao C			with(nolock) on P.Cd_Pes = C.Cd_Pes
left join Tipo_Comunicacao TC	with(nolock) on C.Cd_Tp_Com = TC.Cd_Tp_Com
order by apelido

GO

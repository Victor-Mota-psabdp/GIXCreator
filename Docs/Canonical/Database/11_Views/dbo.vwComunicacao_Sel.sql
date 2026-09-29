SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Comunicacao
CREATE VIEW [dbo].[vwComunicacao_Sel]
AS
SELECT
	A.Cd_Pes 		[Code],
	P.Apelido		[Company Name (Short name)],
	P.Nome_Raz_Soc	[Complete Name],
	Num_CPF_CNPJ	[CNPJ],
	A.Cd_Tp_Com		[Type Contact Code],
	C.Nome_Tp_Com	[Type Contact Name],
	C.Nome_Tp_Com	[Type Contact],--ANTIGO
	A.Contato		[Contact Name],
	A.Depto_Ctt		[Responsability],
	A.Cd_Int		[International Code],
	A.Cd_Area_Fone	[National Code],
	A.Cd_Int + A.Cd_Area_Fone + A.Prefixo + A.Num_Fone	[Complete Phone Number],--ANTIGO
	isnull(A.Prefixo,'') + '-'+ isnull(A.Num_Fone,'')	[Phone Number],	
	A.Compl_Fone	[E-Mail],
	A.Ramal			[Ext.]
FROM 
	Comunicacao A with(nolock)
	join Pessoa P with(nolock) on P.Cd_Pes = A.Cd_Pes
	join Tipo_Comunicacao C with(nolock) ON C.Cd_Tp_Com =A.Cd_Tp_Com
where
	a.Cd_Pes <> '0'

GO

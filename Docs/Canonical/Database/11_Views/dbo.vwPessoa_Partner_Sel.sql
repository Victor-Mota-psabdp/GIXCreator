SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwPessoa_Partner_Sel]
AS
SELECT  
	PS.Apelido, 
	PS.Cd_Pes, 
	PS.Nome_Raz_Soc, 
	PS.Num_CPF_CNPJ,
	B.Nome_BDP_Produto
FROM  dbo.Pessoa PS with (nolock)
	JOIN dbo.Campo_Pessoa PL with (nolock) ON PL.Cd_Pes = PS.Cd_Pes and PL.Id_Campo = 17
	join BDP_Produto B on B.ID_PD = PL.Campo_Dados	
WHERE
	PS.Desat_Pes = 'N'




GO

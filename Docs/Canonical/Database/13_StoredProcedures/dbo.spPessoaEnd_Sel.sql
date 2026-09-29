SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE      Procedure [dbo].[spPessoaEnd_Sel]
		@Apelido VarChar(20)

AS

	Select
		Nome_Raz_Soc,
		Num_CPF_CNPJ,
		Rua,
		Numero,
		compl_end,
		cep,
		cidade,
		Pais,
		ED.Cd_Pais Cd_Pais
from
	Pessoa PP with(nolock)
	Left Join Endereco ED with(nolock) on ED.cd_pes=pp.cd_pes and cd_tp_end='COM'
Where
	Apelido like @Apelido






GO

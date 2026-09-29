SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from altera_bl

CREATE Procedure [dbo].[spPessoaEnd_Alterado_Sel]
		@Apelido VarChar(20)

AS

	Select
		Nome_Raz_Soc,
		Num_CPF_CNPJ,
		Rua,
		Numero,
		compl_end,
		cep,
		bairro,
		cidade,
		Pais
from
	Pessoa PP
	Left Join Endereco ED on ED.cd_pes=pp.cd_pes and cd_tp_end='COM'
Where
	Apelido like @Apelido

GO

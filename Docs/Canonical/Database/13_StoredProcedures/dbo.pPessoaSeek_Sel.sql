SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pPessoaSeek_Sel 
(
@Apelido		VarChar(22)=''
)
 AS
	Set @Apelido = '%' + @Apelido + '%'
	Select 
		PS.*, TC.Nome_Tp_Classe
	From 
		Pessoa as Ps left outer Join Tipo_Classe as TC on PS.Cd_Tp_Classe = TC.Cd_Tp_Classe
	Where 
		Ps.Apelido Like  @Apelido

GO

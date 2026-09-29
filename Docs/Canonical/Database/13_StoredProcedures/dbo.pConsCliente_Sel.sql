SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pConsCliente_Sel 
(
@Apelido		VarChar(22)='',
@CNPJ			VarChar(18)=''
)
 AS
	If @CNPJ <> ''
		Begin 
			Set @CNPJ = '%' + @CNPJ + '%' 
			Select 
				PS.*, TC.Nome_Tp_Classe
			From 
				Pessoa as Ps left outer Join Tipo_Classe as TC on PS.Cd_Tp_Classe = TC.Cd_Tp_Classe
			Where 
				Num_CPF_CNPJ like @CNPJ
		End 
	Else 
		Begin 
			Set @Apelido = '%' + @Apelido + '%'
			Select 
				PS.*, TC.Nome_Tp_Classe
			From 
				Pessoa as Ps left outer Join Tipo_Classe as TC on PS.Cd_Tp_Classe = TC.Cd_Tp_Classe
			Where 
				Ps.Apelido Like  @Apelido or 
				Ps.Nome_Raz_Soc Like @Apelido
		End

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fBusca_Pessoa](
	@Cd_Pes	varchar(10),
	@Tipo	char(1) 
		-- 1 = Apelido
		-- 2 = Razao Social
		-- 3 = CNPJ
)
RETURNS varchar(50)

BEGIN

	Declare @Resultado varchar(50)

	IF @Tipo = '1'
		Begin
			SET @Resultado=(select Apelido from Pessoa where Cd_Pes=@Cd_Pes)
		End

	ELSE IF @Tipo = '2'
		Begin
			SET @Resultado=(select Nome_Raz_Soc from Pessoa where Cd_Pes=@Cd_Pes)
		End

	ELSE IF @Tipo = '3'
		Begin
			SET @Resultado=(select Num_CPF_CNPJ from Pessoa where Cd_Pes=@Cd_Pes)
		End

	RETURN @Resultado

END


GO

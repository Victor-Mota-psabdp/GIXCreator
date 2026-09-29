SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pVerCliSOP_Sel 
(
@CNPJ		varchar(17)	
)
AS
	Set @CNPJ = substring(@CNPJ, 1, Len(@CNPJ) - 1)

	-- Select * From SeaAir.dbo.Pessoa Pes Left Join SeaAir.dbo.Pessoa_Classe PC on PC.PesID = PC.PesId Where PesCNPJ_CPF = @CNPJ and ClpID = 4 and Pes.StaCod = 1
	Select * from Pessoa Where Cd_Pes = '10012'
GO

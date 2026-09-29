SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pVerAtvSOP_Sel 
(
@Cli		VarChar(10), 
@Origem	VarChar(3), 
@Destino	VarChar(3)
)
AS
	Declare @CNPJ 	VarChar(16) 
	Declare @CliSeaAir	Int
	Set @CNPJ = (Select NUM_CPF_CNPJ From Pessoa Where Cd_Pes = @Cli)
	Set @CNPJ = Substring(@CNPJ, 2, len(@CNPJ) -1)
	--Set @CliSeaAir = (Select PesId From SeaAir.dbo.Pessoa Where PesCNPJ_CPF = @CNPJ)
	Set @CliSeaAir =99999
	Select Atv.*, 1 IsaOrdem From SeaAir.dbo.Pessoa_Atividade PA Join  SeaAir.dbo.Atividade Atv on Atv.AtvId = PA.AtvId Where PesId = @CliSeaAir Union Select Atv.*, 1 IsaOrdem From SeaAir.dbo.Pessoa_Atividade_Rota PAR Join  SeaAir.dbo.Atividade Atv on Atv.AtvId = PAR.AtvId Join SeaAir.dbo.Rota Rota on Rota.RotId = Par.RotId Join SeaAir.dbo.Local_IATA Origem on Origem.LoiId = Rota.RotOrigem Join SeaAir.dbo.Local_Iata Destino on Destino.LoiId = Rota.RotDestino  Where PAR.PesId = @CliSeaAir and Origem.LoiRef = @Origem and Destino.LoiRef = @Destino
GO

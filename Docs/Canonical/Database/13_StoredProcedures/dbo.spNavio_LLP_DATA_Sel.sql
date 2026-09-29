SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spNavio_LLP_DATA_Sel] -- spNavio_LLP_DATA_Sel 'MSC AJACCIO','SS709R','Santos','E'
(
	@Nome_Navio		varchar(25),
	@NR_Viagem		varchar(8),
	@Local			varchar(30),
	@modal			varchar(2)	
)

As	
	
Select ETD,ETA,ATD,ATA from Viagem_LLP V
--Select ETA,ATA from Viagem_LLP V
	join Navio_LLP NV on V.ID_Navio = NV.id_navio
	join Localidade D on D.Cd_Local = V.Cd_Dst
Where
	NV.Nome_navio = @Nome_Navio
	and Nome_Local = @Local
	and NR_Viagem = @NR_Viagem
	and Modal= @modal


 
  
 
 
 
 
 
 


GO

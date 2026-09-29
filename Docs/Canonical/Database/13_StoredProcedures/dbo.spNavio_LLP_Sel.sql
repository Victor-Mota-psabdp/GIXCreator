SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spNavio_LLP_Sel] 
(
	@Nome_Navio		varchar(25),
	@Local			varchar(30),
	@modal			varchar(2)
)
AS

if @Nome_Navio  = ''
	begin
		Select distinct Nome_navio from Navio_LLP NV
			join Viagem_LLP V on V.ID_Navio = NV.id_navio
			join Localidade D on D.Cd_Local = V.Cd_Dst
		where
			Nome_Local = @Local
			and Modal= @modal
			--and Ativo=1
	end
else	
	begin
		Select NR_Viagem from Viagem_LLP V
			join Navio_LLP NV on V.ID_Navio = NV.id_navio
			join Localidade D on D.Cd_Local = V.Cd_Dst
		Where
			NV.Nome_navio = @Nome_Navio
			and Nome_Local = @Local
			and Modal= @modal
			--and Ativo=1
	end


 
  
 
 
 
 
 
 


GO

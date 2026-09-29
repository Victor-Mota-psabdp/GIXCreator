SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Recibo_Fatura_Cliente_Sel]--'EMAET201407002BRA'
(	
	@FatCod Varchar(17)
)
as


select 
P.Apelido
from Fatura FAT
Join Pessoa P		with(nolock) on FAT.Cd_Pes = P.Cd_Pes
where 
	FAT.FatCod = @FatCod
GO

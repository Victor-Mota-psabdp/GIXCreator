SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Navio_LLP_Sel] 
(
	@Nome_Navio		varchar(25)
)
AS

select 
	id_navio [Code], 
	nome_navio [Vessel Name], 
	nome_pais [Country], 
	LLoyd , 
	P.Nome_Armador Agency , 
	'Saved' [Status]
from Navio_LLP NV
   left Join pais PS on PS.cd_pais = NV.cd_pais
   left join Armador P on P.Cd_Armador = NV.cd_armador
 where 
	nome_navio like @Nome_Navio and Nome_Navio <> ''
 
GO

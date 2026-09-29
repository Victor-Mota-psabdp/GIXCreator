SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Regiao
CREATE procedure [dbo].[spATL_Regiao_Sel]
(
	@Cd_Regiao			varchar(3),
	@Nome_Regiao		varchar(30),	
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Statuss
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Statuss
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Statuss
*/

if @Tipo = 'A'   or @Tipo = 'B'
	Begin
		select 
			Cd_Regiao [Code], 
			Nome_Regiao [Region Name], 
			isnull(LocICS2,0) [Region ICS2]
		from Regiao T with(nolock)
	End
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			Cd_Regiao [Code], 
			Nome_Regiao [Region Name], 
			isnull(LocICS2,0) [Region ICS2]
		from Regiao T with(nolock)
		where
			Cd_Regiao = @Cd_Regiao
			
	End
	

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			Cd_Regiao [Code], 
			Nome_Regiao [Region Name], 
			isnull(LocICS2,0) [Region ICS2]
		from Regiao T with(nolock)
		where
			Nome_Regiao = @Nome_Regiao
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Regiao [Code], 
			Nome_Regiao [Region Name], 
			isnull(LocICS2,0) [Region ICS2]
		from Regiao T with(nolock)
		where
			Nome_Regiao = @Nome_Regiao
			AND Cd_Regiao <> @Cd_Regiao
	End

GO

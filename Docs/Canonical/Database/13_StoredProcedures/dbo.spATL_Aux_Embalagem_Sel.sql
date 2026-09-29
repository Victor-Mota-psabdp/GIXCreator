SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Aux_Embalagem
CREATE procedure [dbo].[spATL_Aux_Embalagem_Sel]
(
	@Cd_Embal_Ofc		VarChar(10), 
	@Nome_Embalagem		VarChar(60),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'  or @Tipo = 'B'
	Begin
		select 
			T.Cd_Embal_Ofc		[Code],
			T.Nome_Embalagem		[Package Name]						
		from 
			Aux_Embalagem T with(nolock)		
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			T.Cd_Embal_Ofc		[Code],
			T.Nome_Embalagem		[Package Name]						
		from 
			Aux_Embalagem T with(nolock)
		where
			Cd_Embal_Ofc = @Cd_Embal_Ofc
	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			T.Cd_Embal_Ofc		[Code],
			T.Nome_Embalagem		[Package Name]						
		from 
			Aux_Embalagem T with(nolock)
		where
			Nome_Embalagem = @Nome_Embalagem
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			T.Cd_Embal_Ofc		[Code],
			T.Nome_Embalagem		[Package Name]						
		from 
			Aux_Embalagem T with(nolock)
		where
			Nome_Embalagem = @Nome_Embalagem
			AND Cd_Embal_Ofc <> isnull(@Cd_Embal_Ofc,0)
	End

GO

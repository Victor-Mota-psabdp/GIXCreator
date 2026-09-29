SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Range_CP
CREATE procedure [dbo].[spATL_Tipo_Range_CP_Sel]
(
	@Cd_Range			varchar(1),
	@Range_Descricao		varchar(100),
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

if @Tipo = 'A'  OR @Tipo = 'B'
	Begin
		select 
			Cd_Range [Code], Range_Descricao [Range Type Name],Modal [Modal]
		from Tipo_Range_CP T with(nolock)

	End
	
if @Tipo = 'C' OR  @Tipo = 'D'
	Begin
		select 
			Cd_Range [Code], Range_Descricao [Range Type Name],Modal [Modal]
		from Tipo_Range_CP T with(nolock)
		where
			Cd_Range = @Cd_Range
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			Cd_Range [Code], Range_Descricao [Range Type Name],Modal [Modal]
		from Tipo_Range_CP T with(nolock)
		where
			Range_Descricao = @Range_Descricao
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Range [Code], Range_Descricao [Range Type Name],Modal [Modal]
		from Tipo_Range_CP T with(nolock)
		where
			Range_Descricao = @Range_Descricao
			AND Cd_Range <> @Cd_Range
	End

GO

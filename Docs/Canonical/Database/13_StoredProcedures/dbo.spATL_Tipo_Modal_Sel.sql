SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Modal
CREATE procedure [dbo].[spATL_Tipo_Modal_Sel](
	@Id	varChar(1),
	@Modal	varChar(50),
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

if @Tipo = 'A'  OR @Tipo = 'B'
	Begin
		select 
			Id [Code],Modal [Type of Modal]
		from 
			Tipo_Modal with(nolock)
	End

if @Tipo = 'C'  OR @Tipo = 'D'
	Begin
		select 
			Id [Code],Modal [Type of Modal]
		from 
			Tipo_Modal with(nolock)
		where 
			Id = @Id
	End
	
	
if @Tipo = 'N'  OR @Tipo = 'O'
	Begin
		select 
			Id [Code],Modal [Type of Modal]
		from 
			Tipo_Modal with(nolock)
		where 
			Modal = @Modal
	End

	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Id [Code],Modal [Type of Modal]
		from 
			Tipo_Modal with(nolock)
		where 
			Modal = @Modal AND Id <> @Id
	End

GO

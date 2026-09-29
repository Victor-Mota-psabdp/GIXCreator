SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Registro
CREATE procedure [dbo].[spATL_Tipo_Registro_Sel]
(
	@ID_Registro			int,
	@Descr_Registro		varchar(15),
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
			ID_Registro [Code], Descr_Registro [Register Type Name]
		from Tipo_Registro T with(nolock)

	End
	
if @Tipo = 'C' OR  @Tipo = 'D'
	Begin
		select 
			ID_Registro [Code], Descr_Registro [Register Type Name]
		from Tipo_Registro T with(nolock)
		where
			ID_Registro = @ID_Registro
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			ID_Registro [Code], Descr_Registro [Register Type Name]
		from Tipo_Registro T with(nolock)
		where
			Descr_Registro = @Descr_Registro
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			ID_Registro [Code], Descr_Registro [Register Type Name]
		from Tipo_Registro T with(nolock)
		where
			Descr_Registro = @Descr_Registro
			AND ID_Registro <> @ID_Registro
	End

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Metodo_VGM
CREATE procedure [dbo].[spATL_Tipo_Metodo_VGM_Sel]
(
	@ID_Metodo_VGM 	INT,
	@Nome_Metodo_VGM varchar(100),
	@Tipo			char(1)
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
			ID_Metodo_VGM [Code], Nome_Metodo_VGM [VGM Method Name]
		from Tipo_Metodo_VGM T with(nolock)

	End
	
if @Tipo = 'C' OR  @Tipo = 'D'
	Begin
		select 
			ID_Metodo_VGM [Code], Nome_Metodo_VGM [VGM Method Name]
		from Tipo_Metodo_VGM T with(nolock)
		where
			ID_Metodo_VGM = @ID_Metodo_VGM
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			ID_Metodo_VGM [Code], Nome_Metodo_VGM [VGM Method Name]
		from Tipo_Metodo_VGM T with(nolock)
		where
			Nome_Metodo_VGM = @Nome_Metodo_VGM
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			ID_Metodo_VGM [Code], Nome_Metodo_VGM [VGM Method Name]
		from Tipo_Metodo_VGM T with(nolock)
		where
			Nome_Metodo_VGM = @Nome_Metodo_VGM
			AND ID_Metodo_VGM <> @ID_Metodo_VGM
	End

GO

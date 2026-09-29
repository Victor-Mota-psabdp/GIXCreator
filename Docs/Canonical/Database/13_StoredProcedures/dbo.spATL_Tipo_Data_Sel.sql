SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Data
CREATE procedure [dbo].[spATL_Tipo_Data_Sel]
(
	@ID_Tp_Data		BIGINT,
	@Nome_Tp_Data	varchar(100),
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
			ID_Tp_Data [Code], Nome_Tp_Data [Type Date Name]
		from Tipo_Data T with(nolock)

	End
	
if @Tipo = 'C' OR  @Tipo = 'D'
	Begin
		select 
			ID_Tp_Data [Code], Nome_Tp_Data [Type Date Name]
		from Tipo_Data T with(nolock)
		where
			ID_Tp_Data = @ID_Tp_Data
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			ID_Tp_Data [Code],Nome_Tp_Data [Type Date Name]
		from Tipo_Data T with(nolock)
		where
			Nome_Tp_Data = @Nome_Tp_Data
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			ID_Tp_Data [Code], Nome_Tp_Data [Type Date Name]
		from Tipo_Data T with(nolock)
		where
			Nome_Tp_Data = @Nome_Tp_Data
			AND ID_Tp_Data <> @ID_Tp_Data
	End

GO

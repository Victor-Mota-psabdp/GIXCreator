SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Status_CP
CREATE procedure [dbo].[spATL_Tipo_Status_CP_Sel]
(
	@ID_Status_CP			varchar(1),
	@Descr_Status			varchar(40),	
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

if @Tipo = 'A'  
	Begin
		select 
			ID_Status_CP [Code], Descr_Status [Type of Status CP],Ativo [Enabled]
		from Tipo_Status_CP T with(nolock)
	End
	
if  @Tipo = 'B'
	Begin
		select 
			ID_Status_CP [Code], Descr_Status [Type of Status CP],Ativo [Enabled]
		from 
			Tipo_Status_CP T with(nolock)
		where 
			Ativo = 'S'
	End
	
if @Tipo = 'C'
	Begin
		select 
			ID_Status_CP [Code], Descr_Status [Type of Status CP],Ativo [Enabled]
		from Tipo_Status_CP T with(nolock)
		where
			ID_Status_CP = @ID_Status_CP
			
	End
	
if @Tipo = 'D'
	Begin
		select 
			ID_Status_CP [Code], Descr_Status [Type of Status CP],Ativo [Enabled]
		from 
			Tipo_Status_CP T with(nolock)
		where
			ID_Status_CP = @ID_Status_CP
			AND Ativo = 'S'
	End

if @Tipo = 'N'
	Begin
		select 
			ID_Status_CP [Code], Descr_Status [Type of Status CP],Ativo [Enabled]
		from Tipo_Status_CP T with(nolock)
		where
			Descr_Status = @Descr_Status
	End
	
if @Tipo = 'O'
	Begin
		select 
			ID_Status_CP [Code], Descr_Status [Type of Status CP],Ativo [Enabled]
		from Tipo_Status_CP T with(nolock)
		where
			Descr_Status = @Descr_Status
			AND Ativo = 'S'
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			ID_Status_CP [Code], Descr_Status [Type of Status CP],Ativo [Enabled]
		from Tipo_Status_CP T with(nolock)
		where
			Descr_Status = @Descr_Status
			AND ID_Status_CP <> @ID_Status_CP
	End

GO

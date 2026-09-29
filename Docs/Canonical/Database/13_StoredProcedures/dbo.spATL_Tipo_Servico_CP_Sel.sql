SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Servico_CP
CREATE procedure [dbo].[spATL_Tipo_Servico_CP_Sel]
(
	@Cd_Tipo_Servico	varchar(1),
	@Descr_Servico		varchar(50),
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
			Cd_Tipo_Servico [Code], Descr_Servico [Type of Service Name]
		from Tipo_Servico_CP T with(nolock)

	End
	
if @Tipo = 'C' OR  @Tipo = 'D'
	Begin
		select 
			Cd_Tipo_Servico [Code], Descr_Servico [Type of Service Name]
		from Tipo_Servico_CP T with(nolock)
		where
			Cd_Tipo_Servico = @Cd_Tipo_Servico
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			Cd_Tipo_Servico [Code], Descr_Servico [Type of Service Name]
		from Tipo_Servico_CP T with(nolock)
		where
			Descr_Servico = @Descr_Servico
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tipo_Servico [Code], Descr_Servico [Type of Service Name]
		from Tipo_Servico_CP T with(nolock)
		where
			Descr_Servico = @Descr_Servico
			AND Cd_Tipo_Servico <> @Cd_Tipo_Servico
	End

GO

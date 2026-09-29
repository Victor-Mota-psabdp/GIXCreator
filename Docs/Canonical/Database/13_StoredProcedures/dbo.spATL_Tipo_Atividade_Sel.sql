SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Atividade
CREATE procedure [dbo].[spATL_Tipo_Atividade_Sel]
(
	@Cd_Tp_Ativ			VARCHAR(3),
	@Nome_Tp_Ativ			varchar(60),	
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

if @Tipo = 'A'   OR @Tipo = 'B'
	Begin
		select 
			Cd_Tp_Ativ [Code], Nome_Tp_Ativ [Type of Activity Name]
		from 
			Tipo_Atividade T with(nolock)
	End
	
	
if @Tipo = 'C' OR @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Ativ [Code], Nome_Tp_Ativ [Type of Activity Name]
		from 
			Tipo_Atividade T with(nolock)
		where
			Cd_Tp_Ativ = @Cd_Tp_Ativ
			
	End
	
if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Ativ [Code], Nome_Tp_Ativ [Type of Activity Name]
		from 
			Tipo_Atividade T with(nolock)
		where
			Nome_Tp_Ativ = @Nome_Tp_Ativ
	End	
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Ativ [Code], Nome_Tp_Ativ [Type of Activity Name]
		from 
			Tipo_Atividade T with(nolock)
		where
			Nome_Tp_Ativ = @Nome_Tp_Ativ
			AND Cd_Tp_Ativ <> @Cd_Tp_Ativ
	End

GO

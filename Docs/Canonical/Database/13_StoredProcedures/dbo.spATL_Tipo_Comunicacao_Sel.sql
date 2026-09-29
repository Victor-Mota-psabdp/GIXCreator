SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Comunicacao
CREATE procedure [dbo].[spATL_Tipo_Comunicacao_Sel]
(
	@Cd_Tp_Com		varchar(3),
	@Nome_Tp_Com	varchar(30),
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
			Cd_Tp_Com [Code], Nome_Tp_Com [Communication Type Name]
		from Tipo_Comunicacao T with(nolock)

	End
	
if @Tipo = 'C' OR  @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Com [Code], Nome_Tp_Com [Communication Type Name]
		from Tipo_Comunicacao T with(nolock)
		where
			Cd_Tp_Com = @Cd_Tp_Com
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Com [Code], Nome_Tp_Com [Communication Type Name]
		from Tipo_Comunicacao T with(nolock)
		where
			Nome_Tp_Com = @Nome_Tp_Com
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Com [Code], Nome_Tp_Com [Communication Type Name]
		from Tipo_Comunicacao T with(nolock)
		where
			Nome_Tp_Com = @Nome_Tp_Com
			AND Cd_Tp_Com <> @Cd_Tp_Com
	End

GO

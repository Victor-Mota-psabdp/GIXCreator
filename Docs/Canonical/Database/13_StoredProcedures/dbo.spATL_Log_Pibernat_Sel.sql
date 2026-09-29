SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Log_Pibernat_Sel]
(
	@Arquivo		varchar(100),
	@DataIns		Datetime,
	@Status			varchar(200),
	@DataEnvPibernat Datetime,
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
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select Arquivo,Status,DataIns, DataEnvPibernat from Log_Pibernat with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Arquivo,Status,DataIns, DataEnvPibernat from Log_Pibernat with(nolock)
		where Arquivo = @Arquivo
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Arquivo,Status,DataIns, DataEnvPibernat from Log_Pibernat with(nolock)
		where Status = @Status
	End
	
--if @Tipo = 'Z'-- or @Tipo = 'O'
--	Begin
--		select Arquivo,Status,DataIns, DataEnvPibernat from Log_Pibernat with(nolock)
--		where 
--			Status = @Status 
--			and Arquivo <> @Arquivo
--	End

	
GO

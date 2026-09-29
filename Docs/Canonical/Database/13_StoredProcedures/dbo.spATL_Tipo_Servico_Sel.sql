SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Servico
CREATE procedure [dbo].[spATL_Tipo_Servico_Sel]
(
	@Id_TP_Servico		BigInt,
    @Nome_TP_Servico	varchar(30),
	@Tipo				char(1)
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

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT 
			TP.Id_TP_Servico		[Code], 
			TP.Nome_TP_Servico		[Service Type Name], 
			TP.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name],
			TP.Ativo				[Enabled],
			TP.JOB					[JOB_Enabled]
		FROM 
			Tipo_Servico TP wITH(NOLOCK)
			JOIN Usuario US wITH(NOLOCK) ON TP.Cd_Usuario = us.Cd_Usuario
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT 
			TP.Id_TP_Servico		[Code], 
			TP.Nome_TP_Servico		[Service Type Name], 
			TP.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name],
			TP.Ativo				[Enabled],
			TP.JOB					[JOB_Enabled]
		FROM 
			Tipo_Servico TP wITH(NOLOCK)
			JOIN Usuario US wITH(NOLOCK) ON TP.Cd_Usuario = us.Cd_Usuario
		where 
			TP.Id_TP_Servico= @Id_TP_Servico
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT 
			TP.Id_TP_Servico		[Code], 
			TP.Nome_TP_Servico		[Service Type Name], 
			TP.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name],
			TP.Ativo				[Enabled],
			TP.JOB					[JOB_Enabled]
		FROM 
			Tipo_Servico TP wITH(NOLOCK)
			JOIN Usuario US wITH(NOLOCK) ON TP.Cd_Usuario = us.Cd_Usuario
		where 
			TP.Nome_TP_Servico = @Nome_TP_Servico
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT 
			TP.Id_TP_Servico		[Code], 
			TP.Nome_TP_Servico		[Service Type Name], 
			TP.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name],
			TP.Ativo				[Enabled],
			TP.JOB					[JOB_Enabled]
		FROM 
			Tipo_Servico TP wITH(NOLOCK)
			JOIN Usuario US wITH(NOLOCK) ON TP.Cd_Usuario = us.Cd_Usuario
		where 
			TP.Nome_TP_Servico = @Nome_TP_Servico AND TP.Id_TP_Servico <> @Id_TP_Servico
	End
	

	

GO

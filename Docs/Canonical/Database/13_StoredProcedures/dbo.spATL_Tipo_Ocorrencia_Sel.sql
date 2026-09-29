SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Ocorrencia
CREATE procedure [dbo].[spATL_Tipo_Ocorrencia_Sel]--'','','B'
(	
	@Cd_Tp_Ocor		int,
	@Nome_Tp_Ocor	varchar(50),
	@Tipo			char(1)
)
as
	
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
S e L para Solicitacao de LI
*/

IF @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			Cd_Tp_Ocor				[Code],
			Nome_Tp_Ocor			[Occurrence Type Name],
			Previsao_Obrigatoria	[Mandatory Forecast Date],
			Permite_Dias_Anteriores [Allows Previous Days]
		from 
			Tipo_Ocorrencia with(nolock)
	End
	
IF @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Ocor				[Code],
			Nome_Tp_Ocor			[Occurrence Type Name],
			Previsao_Obrigatoria	[Mandatory Forecast Date],
			Permite_Dias_Anteriores [Allows Previous Days]
		from 
			Tipo_Ocorrencia with(nolock)
		where 
			Cd_Tp_Ocor = @Cd_Tp_Ocor
	End
	
IF @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Ocor				[Code],
			Nome_Tp_Ocor			[Occurrence Type Name],
			Previsao_Obrigatoria	[Mandatory Forecast Date],
			Permite_Dias_Anteriores [Allows Previous Days]
		from 
			Tipo_Ocorrencia with(nolock)
		where 
			Nome_Tp_Ocor = @Nome_Tp_Ocor
	End

if @Tipo = 'Z' 
	Begin
		select 
			Cd_Tp_Ocor				[Code],
			Nome_Tp_Ocor			[Occurrence Type Name],
			Previsao_Obrigatoria	[Mandatory Forecast Date],
			Permite_Dias_Anteriores [Allows Previous Days]
		from 
			Tipo_Ocorrencia with(nolock)
		where 
			Nome_Tp_Ocor = @Nome_Tp_Ocor AND Cd_Tp_Ocor <> @Cd_Tp_Ocor
	End	
	
--S e L para Solicitacao de LI
IF @Tipo = 'S' 
	Begin
		select 
			Cd_Tp_Ocor				[Code],
			Nome_Tp_Ocor			[Occurrence Type Name],
			Previsao_Obrigatoria	[Mandatory Forecast Date],
			Permite_Dias_Anteriores [Allows Previous Days]
		from 
			Tipo_Ocorrencia with(nolock)
		where 
			Nome_Tp_Ocor = @Nome_Tp_Ocor
			and cd_tp_ocor in (92,93,94)
	End
	
IF @Tipo = 'L' 
	Begin
		select 
			Cd_Tp_Ocor				[Code],
			Nome_Tp_Ocor			[Occurrence Type Name],
			Previsao_Obrigatoria	[Mandatory Forecast Date],
			Permite_Dias_Anteriores [Allows Previous Days]
		from 
			Tipo_Ocorrencia with(nolock)
		where 
			Cd_Tp_Ocor = @Cd_Tp_Ocor
			and cd_tp_ocor in (92,93,94)
	End

GO

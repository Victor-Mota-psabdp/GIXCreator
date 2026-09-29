SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATLDN_TipoOcorrencia_Sel]--'','','B'
(	
	@Cd_Tp_Ocor		int,
	@Nome_Tp_Ocor	varchar(50),
	@Tipo			char(1)
)
as

	--sp_help Pessoa
	--Declare @Cd_Pes_Grupo varchar(10)
	--set @Cd_Pes_Grupo = (select Cd_Pes from Pessoa where Apelido = @Apelido)
	--if @Cd_Pes_Grupo is null
	--set @Cd_Pes_Grupo = '%'	
	
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

IF @Tipo = 'A' or @Tipo = 'B'
	Begin
		select Cd_Tp_Ocor [Ocorrence Code],Nome_Tp_Ocor [Occorrence Type],Previsao_Obrigatoria,Permite_Dias_Anteriores from Tipo_Ocorrencia with(nolock)
	End
	
IF @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Cd_Tp_Ocor [Ocorrence Code],Nome_Tp_Ocor [Occorrence Type],Previsao_Obrigatoria,Permite_Dias_Anteriores from Tipo_Ocorrencia with(nolock)
		where Cd_Tp_Ocor = @Cd_Tp_Ocor
	End
	
IF @Tipo = 'N' OR @Tipo = 'O'
	Begin
select Cd_Tp_Ocor [Ocorrence Code],Nome_Tp_Ocor [Occorrence Type],Previsao_Obrigatoria,Permite_Dias_Anteriores 
		from Tipo_Ocorrencia with(nolock)
		where Nome_Tp_Ocor = @Nome_Tp_Ocor
	End

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TipoOcor_Sel]
(
	@Cd_Tp_Ocor int,
	@Nome_Tp_Ocor as Varchar(50),
	@Tipo as char
)
as
if @Tipo = 'A'
	Begin
		if @Cd_Tp_Ocor = '' or @Cd_Tp_Ocor is null
		Begin
			select Cd_Tp_Ocor, Nome_Tp_Ocor from Tipo_Ocorrencia with(nolock)
			where Nome_Tp_Ocor = @Nome_Tp_Ocor
		End
		else
		Begin			
			select Cd_Tp_Ocor, Nome_Tp_Ocor from Tipo_Ocorrencia with(nolock)
			where  Cd_Tp_Ocor = @Cd_Tp_Ocor
		End
	End
if @Tipo = 'B'
	Begin
		if @Cd_Tp_Ocor = '' or @Cd_Tp_Ocor is null
			Begin
			select Cd_Tp_Ocor, Nome_Tp_Ocor from Tipo_Ocorrencia with(nolock)
			where Nome_Tp_Ocor = @Nome_Tp_Ocor
		End
		else
		Begin			
			select Cd_Tp_Ocor, Nome_Tp_Ocor from Tipo_Ocorrencia with(nolock)
			where  Cd_Tp_Ocor = @Cd_Tp_Ocor
			End
	End
if @Tipo = 'T'
	Begin
		select Cd_Tp_Ocor,Nome_Tp_Ocor from Tipo_Ocorrencia with(nolock)
		order by Nome_Tp_Ocor
	End
GO

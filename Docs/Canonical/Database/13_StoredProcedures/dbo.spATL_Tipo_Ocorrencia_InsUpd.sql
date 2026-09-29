SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Ocorrencia
CREATE PROCEDURE [dbo].[spATL_Tipo_Ocorrencia_InsUpd]
(
	@Cd_Tp_Ocor				int,
	@Nome_Tp_Ocor			varChar(50),
	@Previsao_Obrigatoria	Char(1),
	@Permite_Dias_Anteriores int
)
AS

Begin Transaction

	If exists (select Cd_Tp_Ocor from Tipo_Ocorrencia where Cd_Tp_Ocor=@Cd_Tp_Ocor)
		Begin
			Update
				Tipo_Ocorrencia
			Set
				Nome_Tp_Ocor=@Nome_Tp_Ocor,
				Previsao_Obrigatoria = @Previsao_Obrigatoria,
				Permite_Dias_Anteriores = @Permite_Dias_Anteriores
			Where
				Cd_Tp_Ocor=@Cd_Tp_Ocor
		End
	Else
		Insert
			Tipo_Ocorrencia(Cd_Tp_Ocor,Nome_Tp_Ocor,Previsao_Obrigatoria,Permite_Dias_Anteriores)
		Values
			(@Cd_Tp_Ocor,@Nome_Tp_Ocor,@Previsao_Obrigatoria,@Permite_Dias_Anteriores)
	

Commit Transaction

GO

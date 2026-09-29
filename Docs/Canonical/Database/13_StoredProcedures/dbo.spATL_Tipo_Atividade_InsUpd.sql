SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Atividade
CREATE PROCEDURE [dbo].[spATL_Tipo_Atividade_InsUpd]
(
	@Cd_Tp_Ativ				VARCHAR(3),
	@Nome_Tp_Ativ			varchar(60),
	@Ativo					varchar(1)	
)
				

AS

Begin Transaction

	If  exists (select Cd_Tp_Ativ from Tipo_Atividade where Cd_Tp_Ativ=@Cd_Tp_Ativ)
		Begin
			Update
				Tipo_Atividade
			Set
				Nome_Tp_Ativ=@Nome_Tp_Ativ
			Where
				Cd_Tp_Ativ=@Cd_Tp_Ativ
		End
	Else
		Begin
			Insert Tipo_Atividade
				(Cd_Tp_Ativ,Nome_Tp_Ativ)
			Values
				(@Cd_Tp_Ativ,@Nome_Tp_Ativ)
		End

Commit Transaction

GO

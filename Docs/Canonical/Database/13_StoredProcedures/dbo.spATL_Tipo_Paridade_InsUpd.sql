SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Paridade
CREATE PROCEDURE [dbo].[spATL_Tipo_Paridade_InsUpd]
(
	@Cd_Tp_Par		varchar(3),
	@Nome_Tp_Par	varchar(50),
	@Parametro		float,
	@Padrao			varchar(1),
	@Status			bit
			
)
AS

Begin Transaction
	
	If  exists (select Cd_Tp_Par from Tipo_Paridade where Cd_Tp_Par=Cd_Tp_Par)
	Begin
		Update
			Tipo_Paridade
		Set
			Nome_Tp_Par=@Nome_Tp_Par,
			Parametro = @Parametro,
			Padrao= @Padrao,
			Status = @Status
		Where
			Cd_Tp_Par=@Cd_Tp_Par
	End
		Else
	Begin		
		Insert
			Tipo_Paridade(Cd_Tp_Par,Nome_Tp_Par,Parametro,Padrao,Status)
		Values
			(@Cd_Tp_Par,@Nome_Tp_Par,@Parametro,@Padrao,@Status)
	End

Commit Transaction

GO

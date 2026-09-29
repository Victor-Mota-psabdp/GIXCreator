SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Carga
CREATE PROCEDURE [dbo].[spATL_Tipo_Carga_InsUpd]

			@Cd_Tp_Carga INT,
			@Nome_Tp_Carga varchar(30),
			@Ativo_TP varchar(1)
			

AS

Begin Transaction

	If  exists (select Cd_Tp_Carga from Tipo_Carga where Cd_Tp_Carga=@Cd_Tp_Carga)
	Begin
		Update
			Tipo_Carga
		Set
			Nome_Tp_Carga=@Nome_Tp_Carga,
			Ativo_TP = @Ativo_TP
		Where
			Cd_Tp_Carga=@Cd_Tp_Carga
	End
	Else
		Insert
			Tipo_Carga(Cd_Tp_Carga,Nome_Tp_Carga,Ativo_TP)
		Values
			(@Cd_Tp_Carga,@Nome_Tp_Carga,@Ativo_TP)
	

Commit Transaction

GO

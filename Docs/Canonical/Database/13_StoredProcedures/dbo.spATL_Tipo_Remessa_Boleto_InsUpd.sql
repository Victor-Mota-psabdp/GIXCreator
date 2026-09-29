SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Remessa_Boleto
CREATE PROCEDURE [dbo].[spATL_Tipo_Remessa_Boleto_InsUpd]
(
	@Id_Tp_Remessa		BIGINT,
	@Nome_Tp_Remessa	VARCHAR(MAX),
	@Ativo				BIT,
	@Cd_Usuario			VARCHAR(6),
	@dt_ins				DATETIME
)

AS

Begin Transaction

	If  exists (select Id_Tp_Remessa from Tipo_Remessa_Boleto where Id_Tp_Remessa=@Id_Tp_Remessa)
		Begin
			Update
				Tipo_Remessa_Boleto
			Set
				Nome_Tp_Remessa=@Nome_Tp_Remessa,
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = @dt_ins			
			Where
				Id_Tp_Remessa=@Id_Tp_Remessa
		End
	Else
		Begin
			Insert Tipo_Remessa_Boleto
				(Nome_Tp_Remessa,Ativo,Cd_Usuario,dt_ins)
			Values
				(@Nome_Tp_Remessa,@Ativo,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO

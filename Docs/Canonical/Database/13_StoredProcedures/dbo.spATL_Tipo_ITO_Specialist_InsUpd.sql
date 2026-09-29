SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_ITO_Specialist
CREATE PROCEDURE [dbo].[spATL_Tipo_ITO_Specialist_InsUpd]
(
	@ID_TP_ITO_Specialist		BIGINT,
	@NOME_TP_ITO_Specialist		VARCHAR(100),
	@Ativo						BIT,
	@Cd_Usuario					VARCHAR(6),
	@dt_ins						DATETIME
)

AS

Begin Transaction

	If  exists (select ID_TP_ITO_Specialist from Tipo_ITO_Specialist 
				where ID_TP_ITO_Specialist=@ID_TP_ITO_Specialist)
		Begin
			Update
				Tipo_ITO_Specialist
			Set
				NOME_TP_ITO_Specialist=@NOME_TP_ITO_Specialist,
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				ID_TP_ITO_Specialist=@ID_TP_ITO_Specialist
		End
	Else
		Begin
			Insert Tipo_ITO_Specialist
				(NOME_TP_ITO_Specialist,Ativo,Cd_Usuario,dt_ins)
			Values
				(@NOME_TP_ITO_Specialist,@Ativo,@Cd_Usuario,GETDATE())
		End

Commit Transaction





GO

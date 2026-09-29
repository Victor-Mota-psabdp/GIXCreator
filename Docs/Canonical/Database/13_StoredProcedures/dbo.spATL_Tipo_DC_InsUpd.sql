SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_DC
CREATE PROCEDURE [dbo].[spATL_Tipo_DC_InsUpd]
(
	@Cd_Tp_DC		char(1),
	@Descricao_TP_DC		varchar(50),
	@Ativo			BIT,
	@Cd_Usuario		VARCHAR(10),
	@dt_ins			DATETIME
)

AS

Begin Transaction

	If  exists (select Cd_Tp_DC from Tipo_DC where Cd_Tp_DC=@Cd_Tp_DC)
		Begin
			Update
				Tipo_DC
			Set
				Descricao_TP_DC=@Descricao_TP_DC,
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				Cd_Tp_DC=@Cd_Tp_DC
		End
	Else
		Begin
			Insert Tipo_DC
				(Descricao_TP_DC,Ativo,Cd_Usuario,dt_ins)
			Values
				(@Descricao_TP_DC,@Ativo,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO

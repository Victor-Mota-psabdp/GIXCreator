SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Frete
CREATE PROCEDURE [dbo].[spATL_Tipo_Frete_InsUpd]
(
		@Cd_Tp_Frete		varchar(1),
		@Nome_Tp_Frete		varchar(60)
)
				

AS

Begin Transaction

	If  exists (select Cd_Tp_Frete from Tipo_Frete where Cd_Tp_Frete=@Cd_Tp_Frete)
		Begin
			Update
				Tipo_Frete
			Set
				Nome_Tp_Frete=@Nome_Tp_Frete
			Where
				Cd_Tp_Frete=@Cd_Tp_Frete
		End
	Else
		Begin
			Insert Tipo_Frete
				(Cd_Tp_Frete,Nome_Tp_Frete)
			Values
				(@Cd_Tp_Frete,@Nome_Tp_Frete)
		End

Commit Transaction

GO

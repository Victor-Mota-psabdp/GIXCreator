SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Envio_GIX
CREATE PROCEDURE [dbo].[spATL_Tipo_Envio_GIX_InsUpd]
(
	@Cd_Tp_EnvioGix				VARCHAR(1),
	@Nome_Tp_EnvioGix			varchar(50),
	@Ativo					varchar(1)	
)
				

AS

Begin Transaction

	If  exists (select Cd_Tp_EnvioGix from Tipo_Envio_GIX where Cd_Tp_EnvioGix=@Cd_Tp_EnvioGix)
		Begin
			Update
				Tipo_Envio_GIX
			Set
				Nome_Tp_EnvioGix=@Nome_Tp_EnvioGix
			Where
				Cd_Tp_EnvioGix=@Cd_Tp_EnvioGix
		End
	Else
		Begin
			Insert Tipo_Envio_GIX
				(Cd_Tp_EnvioGix,Nome_Tp_EnvioGix)
			Values
				(@Cd_Tp_EnvioGix,@Nome_Tp_EnvioGix)
		End

Commit Transaction

GO

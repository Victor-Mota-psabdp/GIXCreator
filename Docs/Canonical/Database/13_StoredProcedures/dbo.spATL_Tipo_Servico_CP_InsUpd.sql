SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Servico_CP
CREATE PROCEDURE [dbo].[spATL_Tipo_Servico_CP_InsUpd]
(
	@Cd_Tipo_Servico	varchar(1),
	@Descr_Servico		varchar(50)
)
				

AS

Begin Transaction

	If  exists (select Cd_Tipo_Servico from Tipo_Servico_CP where Cd_Tipo_Servico=@Cd_Tipo_Servico)
		Begin
			Update
				Tipo_Servico_CP
			Set
				Descr_Servico=@Descr_Servico
			Where
				Cd_Tipo_Servico=@Cd_Tipo_Servico
		End
	Else
		Begin
			Insert Tipo_Servico_CP
				(Cd_Tipo_Servico,Descr_Servico)
			Values
				(@Cd_Tipo_Servico,@Descr_Servico)
		End

Commit Transaction

GO

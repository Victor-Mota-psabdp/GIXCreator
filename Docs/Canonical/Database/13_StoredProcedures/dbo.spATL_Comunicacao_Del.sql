SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Comunicacao
CREATE procedure [dbo].[spATL_Comunicacao_Del]
(
	@Cd_Pes			varchar(10),
	@Cd_Tp_Com		varchar(3)
)
as

	If  exists (select Cd_Pes from Comunicacao where Cd_Pes=@Cd_Pes AND Cd_Tp_Com = @Cd_Tp_Com)
		Begin
			delete Comunicacao where Cd_Pes=@Cd_Pes AND Cd_Tp_Com = @Cd_Tp_Com
		End

GO

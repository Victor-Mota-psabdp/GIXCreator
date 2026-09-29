SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATLDN_Paridade_Del]
(
	@Dt_Par			varchar(10),
	@Cd_Tp_Moeda	varchar(3),
	@Cd_Tp_Par		varchar(3)
)
as
	IF exists(SELECT Dt_Par FROM PARIDADE WHERE Dt_Par=@Dt_Par AND	Cd_Tp_Moeda=@Cd_Tp_Moeda AND Cd_Tp_Par=@Cd_Tp_Par)
		BEGIN
			delete PARIDADE WHERE Dt_Par=@Dt_Par AND Cd_Tp_Moeda=@Cd_Tp_Moeda AND Cd_Tp_Par=@Cd_Tp_Par
		END

GO

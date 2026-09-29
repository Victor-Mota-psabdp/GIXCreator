SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	PROCEDURE [dbo].[spParidade_Sel]

@Data varchar(10)

AS

SELECT
	PAR.Dt_Par, TM.Nome_Tp_Moeda, TP.Nome_Tp_Par, PAR.Par_Moeda
FROM
	PARIDADE PAR with(nolock)
	left Join Tipo_Moeda TM with(nolock) on PAR.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
	left join Tipo_Paridade TP with(nolock) on PAR.Cd_Tp_Par = TP.Cd_Tp_Par
WHERE
	PAR.Dt_Par = @Data



GO

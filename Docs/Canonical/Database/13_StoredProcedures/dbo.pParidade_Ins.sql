SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pParidade_Ins    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pParidade_Ins 
(
@Dt_Par			varchar(10),
@Cd_Tp_Moeda		varchar(3),
@Cd_Tp_Par			varchar(3),
@Par_Moeda			Float
)
 AS
	Insert into 
		Paridade 
		(Dt_Par, Cd_Tp_Moeda, Cd_Tp_Par, Par_Moeda)
	Values 
		(@Dt_Par, @Cd_Tp_Moeda, @Cd_Tp_Par, @Par_Moeda)
	Return @@RowCount



GO

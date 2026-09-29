SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pParidade_Upd    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pParidade_Upd
(
@Dt_Par			varchar(10),
@Cd_Tp_Moeda		varchar(3),
@Cd_Tp_Par			varchar(3),
@Par_Moeda			Float
)
 AS
	Update
		Paridade 
	Set 
		Par_Moeda = @Par_Moeda
	Where
		Dt_Par = @Dt_Par and 
		Cd_Tp_Moeda = @Cd_Tp_Moeda and 
		Cd_Tp_Par = @Cd_Tp_Par
	Return @@RowCount



GO

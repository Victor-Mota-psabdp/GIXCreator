SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHstCom_Del
(
@Cd_Pes			varchar(10),
@Dt_Hist			datetime
)
AS
	Delete
		Hst_Com
	Where 
		Cd_Pes = @Cd_Pes and 
		Dt_Hist = @Dt_Hist

	Return @@RowCount

GO

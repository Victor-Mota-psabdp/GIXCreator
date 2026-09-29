SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHstCom_Upd
(
@Cd_Pes			varchar(10),
@Dt_Hist			datetime,
@Refer_Hist			varchar(16),
@Cd_Usuario			varchar(6),
@Cd_Tp_Ocor			int,
@Descr_Hist			varchar(4000),
@Dt_Follow_Up			DateTime=Null
)
AS
	Update 
		Hst_Com
	Set 
		Refer_Hist=@Refer_Hist,
		Cd_Usuario=@Cd_Usuario,
		Cd_Tp_Ocor=@Cd_Tp_Ocor,
		Descr_Hist = @Descr_Hist,
		Dt_Follow_Up = @Dt_Follow_Up
	Where 
		Cd_Pes = @Cd_Pes and 
		Dt_Hist = @Dt_Hist

	Return @@RowCount

GO

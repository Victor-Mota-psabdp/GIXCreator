SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHstCom_Ins
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
	Insert Into 
		Hst_Com
	Values 
		(@Cd_Pes, @Dt_Hist, @Refer_Hist, @Cd_Usuario, @Cd_Tp_Ocor, @Descr_Hist, @Dt_Follow_Up)

	Return @@RowCount

GO

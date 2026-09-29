SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pReservPca_Ins 
(
@Num_Proc_HEM		VarChar(16), 
@Cd_Tp_Com_Cli		Varchar(3)=Null,
@Cd_Pes_Dcto			Varchar(10)=Null,
@Cd_Tp_Com_Dcto		Varchar(3)=Null,
@Cd_Pes_Crg			Varchar(10)=Null, 
@Cd_Tp_Com_Crg		Varchar(3)=Null,
@Obs				VarChar(500)=Null
)
AS
	Update 
		Job_Exp_Mar
	Set 
		Cd_Tp_Com_Cli=@Cd_Tp_Com_Cli,
		Cd_Pes_Dcto=@Cd_Pes_Dcto, 
		Cd_Tp_Com_Dcto=@Cd_Tp_Com_Dcto, 
		Cd_Pes_Crg=@Cd_Pes_Crg, 
		Cd_Tp_Com_Crg=@Cd_Tp_Com_Crg,
		Obs_JEM = @Obs
	Where
		Num_Proc_HEM = @Num_Proc_HEM

	Return @@RowCount

GO

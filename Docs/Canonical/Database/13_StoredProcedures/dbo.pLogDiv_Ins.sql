SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE pLogDiv_Ins  
(
@LvdProcesso		varchar(16), 
@LvdIdent		varchar(20),
@LvdEvento		varchar(10), 	
@LvdHistorico		varchar(50), 
@Cd_Usuario		varchar(6)
)
AS

	Insert into Log_Diversos (LvdProcesso, LvdEvento, LvdIdent, LvdHistorico, LvdData, Cd_Usuario )
	values (@LvdProcesso, @LvdEvento,  @LvdIdent, @LvdHistorico, GetDate(), @Cd_Usuario)
	If @@Error <> 0 
		Return -1 
	Else
		REturn 1
GO

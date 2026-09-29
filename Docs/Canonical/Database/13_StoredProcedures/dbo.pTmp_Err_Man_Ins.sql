SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTmp_Err_Man_Ins 
(
@Tmp_Processo	varchar(16),
@Tmp_Erro		varchar(200),
@Tmp_ID_Machine	varchar(30)
)
 AS
	Insert Into 
		Tmp_Err_Man
		(Tmp_Processo, Tmp_Erro, Tmp_ID_Machine)
	Values 
		(@Tmp_Processo, @Tmp_Erro, @Tmp_ID_Machine)



GO

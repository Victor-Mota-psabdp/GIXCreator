SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE  pAuditor_Msg_Rel
(
@StrMachine	Varchar(20),
@Processo	Varchar(16)
)
 AS
	Select  * From tmp_auditor_msg where tmpmachine = @Strmachine and tmpprocesso = @Processo


GO

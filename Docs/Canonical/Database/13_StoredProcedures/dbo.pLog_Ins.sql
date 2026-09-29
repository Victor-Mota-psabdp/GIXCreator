SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.pLog_Ins    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pLog_Ins 
(
@Arquivo		varchar(20), 
@Usuario		varchar(40),
@Evento		varchar(100),
@Inconsitencia		bit 
)
AS
	Insert Into Imp_LOG Values (GetDate(), @Arquivo, @Usuario, @Evento, @Inconsitencia)



GO

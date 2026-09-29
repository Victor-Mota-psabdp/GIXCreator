SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spLog_WebService_Ins]
	@Interface	varchar(30),
	@Mensagem	varchar(500),
	@Ref_BDP	varchar(16),
	@Ref_Cliente varchar(50),
	@Referencia	varchar(50),
	@Email	varchar(MAX)

AS
	Insert into Log_WebService
		(Interface, Mensagem, Ref_BDP, Ref_Cliente, Referencia, Log_Dt, Email)
	Values
		(@Interface, @Mensagem, @Ref_BDP, @Ref_Cliente, @Referencia, getdate(), @Email)




GO

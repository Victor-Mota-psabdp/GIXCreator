SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pMensagem_Ins  
(
@MnsOrigem		varchar(6), 
@MnsProc		varchar(16)='',
@Apelido		varchar(20)=null,
@MnsSis		bit, 
@MnsMail		bit, 
@MnsDtEnv		datetime=null,
@MnsTexto		varchar(2000), 
@MnsID		int = null OUTPUT 
)
AS
	Declare @Cd_Pes 	Varchar(10)
	If @MnsDtEnv = null 
		Set  @MnsDtEnv = getdate() 
	
	if @Apelido <> null 
		Set @Cd_Pes = (Select Cd_Pes From Pessoa Where Apelido = @Apelido) 

	else
		Set @Cd_pes = null

	Set @MnsID = IsNull((Select max(MnsID) From Mensagem),0) + 1 

	Insert Into Mensagem (MnsID, MnsOrigem, MnsProc, MnsCliente, MnsSis, MnsMail, MnsDtEnv, MnsTexto) 
	Values (@MnsID, @MnsOrigem, @MnsProc, @Cd_Pes, @MnsSis, @MnsMail, @MnsDtEnv, @MnsTexto) 

	Return @@RowCount

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgHIA_Upd] ON  [dbo].[House_Imp_Aer]    AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @ObsAtual Varchar(2000)
	Declare @ObsNova	Varchar(2000)
	Declare @Num_proc	varchar(16)
	
	--Numero do Job
	select @num_proc=num_proc_HIA from inserted	
	--Pegando dados antidos
	select @ObsAtual=ltrim(rtrim(obs_HIA)) from deleted
	--Pegando dados novos
	select @ObsNova=ltrim(rtrim(obs_HIA)) from inserted
	
	if @ObsAtual <> @ObsNova
		Begin
			Declare @MSG Varchar(2000)
			Set @MSG=left(('Notes updated - from: ' + @obsatual + ' to: ' + @ObsNova),2000)
			exec spHistG_InsUPD @Num_Proc,Null,Null,'Alteração do Processo',@MSG,'01-01-2010',Null,'ATL System','S','U',Null

		End

END


GO
ALTER TABLE [dbo].[House_Imp_Aer] ENABLE TRIGGER [TrgHIA_Upd]
GO

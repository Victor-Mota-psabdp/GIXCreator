SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[TrgHEM_Upd] ON [dbo].[House_Exp_Mar] For Update 

AS 
BEGIN

	Declare @Navio_HEMNovo  Varchar(50)
	Declare @Navio_HEMAnterior  Varchar(50)
	Declare @Viagem_HEMNovo Varchar(25)
	Declare @Viagem_HEMAnterior Varchar(25)
	Declare @Num_PRoc	Varchar(16)
	Declare @Dados_Alterados varchar(max)
	
-- Coletando campos antigos
	Begin
		select 
			@Navio_HEMAnterior=Navio_HEM,
			@Viagem_HEMAnterior=Viagem_HEM,
			@Num_proc=Num_Proc_HEM
		from 
			deleted
	End
	
-- Coletando campos Novos
	Begin
		select 
			@Navio_HEMNovo=Navio_HEM,
			@Viagem_HEMNovo=Viagem_HEM
		from 
			inserted
	End	
		
	if @Navio_HEMAnterior <> @Navio_HEMNovo and @Navio_HEMAnterior is not null
		Begin
			set @Dados_Alterados = 'DE: ' + @Navio_HEMAnterior + ' - PARA: ' + @Navio_HEMNovo
			--insert into Exchange_Alerta (Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados) 
			--values (@Num_Proc,1,getdate(),'Navio_HEM',@Dados_Alterados)
			exec spExchange_Alerta_Ins @Num_Proc,1,'Navio_HEM',@Dados_Alterados
		End
		
	if @Viagem_HEMAnterior <> @Viagem_HEMNovo  and @Viagem_HEMAnterior is not null
		Begin
			set @Dados_Alterados = 'DE: ' + @Viagem_HEMAnterior + ' - PARA: ' + @Viagem_HEMNovo
			--insert into Exchange_Alerta (Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados) 
			--values (@Num_Proc,1,getdate(),'Viagem_HEM',@Dados_Alterados)
			exec spExchange_Alerta_Ins @Num_Proc,1,'Viagem_HEM',@Dados_Alterados
		End
	
	
END


GO
ALTER TABLE [dbo].[House_Exp_Mar] ENABLE TRIGGER [TrgHEM_Upd]
GO

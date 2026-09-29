SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgLLPEM_Upd] ON [dbo].[LLP_Exp_Mar] For Update 

AS 
BEGIN

	Declare @Shipper as varchar(20)	
	Declare @PO_Req_Date Datetime
	
	Declare @ETAAnterior Datetime
	Declare @ETANovo Datetime
	Declare @ETDAnterior Datetime
	Declare @ETDNovo Datetime
	Declare @ATAAnterior Datetime
	Declare @ATANovo Datetime
		
	Declare @Num_PRoc	Varchar(16)
	Declare @MSG Varchar(400)
	
	Declare @DL_Draft_LemAnterior Datetime
	Declare @DL_Draft_LemNovo Datetime
	Declare @DL_Cargo_LemAnterior Datetime
	Declare @DL_Cargo_LemNovo Datetime
	Declare @DL_VGM_LemAnterior Datetime
	Declare @DL_VGM_LemNovo Datetime
	Declare @Dados_Alterados varchar(max)
	Declare @PO_Req_DateOLD Datetime
	

--Esquema pra salvar alteração do status 8 pra qq outro
	Declare @ID_Status as int	
	Declare @ID_Status_Novo as int

-- Coletando campos antigos
	Begin
		select 
			@ETAAnterior=ETA_Lem,
			@ETDAnterior=ETD_LeM,
			@ATAAnterior=ATA_LeM,
			@Num_proc=Num_proc_LeM,
			@ID_Status=ID_Status,
			@DL_Draft_LemAnterior = DL_Draft_Lem,
			@DL_Cargo_LemAnterior = DL_Cargo_Lem,
			@DL_VGM_LemAnterior = DL_VGM_Lem,
			@PO_Req_DateOLD = PO_Req_Date
		from 
			deleted
	End
	
-- Coletando campos Novos
	Begin
		select 
			@ETANovo=eta_lem,
			@ETDNovo=ETD_LeM,
			@ATANovo=ATA_LeM,
			@ID_Status_Novo=ID_Status,
			@DL_Draft_LemNovo = DL_Draft_Lem,
			@DL_Cargo_LemNovo = DL_Cargo_Lem,
			@DL_VGM_LemNovo = DL_VGM_Lem,
			@PO_Req_Date = PO_Req_Date
		from 
			inserted
	End
	
		if @PO_Req_DateOLD <> @PO_Req_Date
		Begin
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Num_Proc, getdate(), 0,GETDATE()) 
		End
	
	set @Shipper = (select P.Apelido from House_Exp_Mar H with (nolock)
		 join Pessoa P with (nolock) on P.Cd_Pes = H.Cd_Export_HEM where Num_Proc_HEM = @Num_Proc)

	if @ETAAnterior <> @ETANovo 
		Begin
			set @MSG=('ETA UPDATED = From: ' +  convert(varchar(10),@ETAAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETANovo,105) + space(10) + 'Historic created by ATL System')
			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETA Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
			
			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@ETAAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@ETANovo)
			--insert into [dbo].[Exchange_Alerta] (Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados)
			--values (@Num_Proc,1,getdate(),'ETA_Lem',@Dados_Alterados)			
			exec spExchange_Alerta_Ins @Num_Proc,1,'ETA_Lem',@Dados_Alterados			
		
			exec spATL_Task_Automatico_Trigger_Ins @Num_Proc,@Shipper,@PO_Req_Date
	
		End	
	
	if @ETDAnterior <> @ETDNovo 
		Begin
			set @MSG='ETD UPDATED = From: ' +  convert(varchar(10),@ETDAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETDNovo,105) + space(10) + 'Historic created by ATL System'
			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETD Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
			
			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@ETDAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@ETDNovo)
			--insert into [dbo].[Exchange_Alerta](Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados)
			-- values (@Num_Proc,1,getdate(),'ETD_Lem',@Dados_Alterados)
			 exec spExchange_Alerta_Ins @Num_Proc,1,'ETD_Lem',@Dados_Alterados
			 
			 exec spATL_Task_Automatico_Trigger_Ins @Num_Proc,@Shipper,@PO_Req_Date
		End	
		
	if @ATAAnterior <> @ATANovo 
		Begin					
			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@ATAAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@ATANovo)
			exec spExchange_Alerta_Ins @Num_Proc,1,'ATA_Lem',@Dados_Alterados
		End	
		
	if @DL_Draft_LemAnterior <> @DL_Draft_LemNovo and @DL_Draft_LemAnterior is not null
		Begin
			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@DL_Draft_LemAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@DL_Draft_LemNovo)
			--insert into Exchange_Alerta (Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados) 
			--values (@Num_Proc,1,getdate(),'DL_Draft_Lem',@Dados_Alterados)
			exec spExchange_Alerta_Ins @Num_Proc,1,'DL_Draft_Lem',@Dados_Alterados
		End
		
	if @DL_Cargo_LemAnterior <> @DL_Cargo_LemNovo and @DL_Cargo_LemAnterior is not null
		Begin
			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@DL_Cargo_LemAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@DL_Cargo_LemNovo)
			--insert into Exchange_Alerta (Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados) 
			--values (@Num_Proc,1,getdate(),'DL_Cargo_Lem',@Dados_Alterados)
			exec spExchange_Alerta_Ins @Num_Proc,1,'DL_Cargo_Lem',@Dados_Alterados
		End
		
	if @DL_VGM_LemAnterior <> @DL_VGM_LemNovo and @DL_VGM_LemAnterior is not null
		Begin
			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@DL_VGM_LemAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@DL_VGM_LemNovo)
			--insert into Exchange_Alerta (Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados) 
			--values (@Num_Proc,1,getdate(),'DL_VGM_Lem',@Dados_Alterados)
			exec spExchange_Alerta_Ins @Num_Proc,1,'DL_VGM_Lem',@Dados_Alterados
		End
		
		
	declare @Processo as varchar(16)
	set @Processo = (select num_proc from [Log_Status] where num_proc = @Num_PRoc and id_status = @ID_Status)
	
	If @ID_Status = 8 and  @ID_Status_Novo<> 5
		BEGIN
			if @Processo is null
				begin			
					insert into [Log_Status](num_proc,dt_ins,ID_Status)values(@Num_PRoc,getdate(),@ID_Status)
				end
			else
				begin
					update [Log_Status] set dt_ins = getdate() where num_proc = @Num_PRoc and id_status = @ID_Status
				end	
		END
	

	
END




--ALTER TRIGGER [dbo].[TrgLLPEM_Upd] ON [dbo].[LLP_Exp_Mar] For Update 

--AS 
--BEGIN
	
--	Declare @ETAAnterior Datetime
--	Declare @ETANovo Datetime
--	Declare @ETDAnterior Datetime
--	Declare @ETDNovo Datetime
--	Declare @ATANovo Datetime	
--	Declare @ATAAntigo Datetime	
--	Declare @Num_PRoc	Varchar(16)
--	Declare @MSG Varchar(400)

----Esquema pra salvar alteração do status 8 pra qq outro
--	Declare @ID_Status as int	
--	Declare @ID_Status_Novo as int

---- Coletando campos antigos
--	select @ETAAnterior=eta_lem,@ETDAnterior=ETD_LeM,@ATAAntigo=ATA_LeM,@Num_proc=Num_proc_LeM,@ID_Status=ID_Status from deleted
---- Coletando campos Novos
--	select @ETANovo=eta_lem,@ETDNovo=ETD_LeM,@ATANovo=ATA_LeM,@ID_Status_Novo=ID_Status from inserted


--	if @ETAAnterior <> @ETANovo 
--		Begin
--			set @MSG=('ETA UPDATED = From: ' +  convert(varchar(10),@ETAAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETANovo,105) + space(10) + 'Historic created by ATL System')
--			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETA Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
--			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
--		End	
	
--	if @ETDAnterior <> @ETDNovo 
--		Begin
--			set @MSG='ETD UPDATED = From: ' +  convert(varchar(10),@ETDAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETDNovo,105) + space(10) + 'Historic created by ATL System'
--			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETD Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
--			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
--		End	
		
		
--	declare @Processo as varchar(16)
--	set @Processo = (select num_proc from [Log_Status] where num_proc = @Num_PRoc and id_status = @ID_Status)
	
--	If @ID_Status = 8 and  @ID_Status_Novo<> 5
--		BEGIN
--			if @Processo is null
--				begin			
--					insert into [Log_Status](num_proc,dt_ins,ID_Status)values(@Num_PRoc,getdate(),@ID_Status)
--				end
--			else
--				begin
--					update [Log_Status] set dt_ins = getdate() where num_proc = @Num_PRoc and id_status = @ID_Status
--				end	
--		END
	
--END




--ALTER TRIGGER [dbo].[TrgLLPEM_Upd] ON [dbo].[LLP_Exp_Mar] For Update 

--AS 
--BEGIN
	
--	Declare @ETAAnterior Datetime
--	Declare @ETANovo Datetime
--	Declare @ETDAnterior Datetime
--	Declare @ETDNovo Datetime
--	Declare @ATAAnterior Datetime
--	Declare @ATANovo Datetime
		
--	Declare @Num_PRoc	Varchar(16)
--	Declare @MSG Varchar(400)
	
--	Declare @DL_Draft_LemAnterior Datetime
--	Declare @DL_Draft_LemNovo Datetime
--	Declare @DL_Cargo_LemAnterior Datetime
--	Declare @DL_Cargo_LemNovo Datetime
--	Declare @DL_VGM_LemAnterior Datetime
--	Declare @DL_VGM_LemNovo Datetime
--	Declare @Dados_Alterados varchar(max)

----Esquema pra salvar alteração do status 8 pra qq outro
--	Declare @ID_Status as int	
--	Declare @ID_Status_Novo as int

---- Coletando campos antigos
--	Begin
--		select 
--			@ETAAnterior=ETA_Lem,
--			@ETDAnterior=ETD_LeM,
--			@ATAAnterior=ATA_LeM,
--			@Num_proc=Num_proc_LeM,
--			@ID_Status=ID_Status,
--			@DL_Draft_LemAnterior = DL_Draft_Lem,
--			@DL_Cargo_LemAnterior = DL_Cargo_Lem,
--			@DL_VGM_LemAnterior = DL_VGM_Lem
--		from 
--			deleted
--	End
	
---- Coletando campos Novos
--	Begin
--		select 
--			@ETANovo=eta_lem,
--			@ETDNovo=ETD_LeM,
--			@ATANovo=ATA_LeM,
--			@ID_Status_Novo=ID_Status,
--			@DL_Draft_LemNovo = DL_Draft_Lem,
--			@DL_Cargo_LemNovo = DL_Cargo_Lem,
--			@DL_VGM_LemNovo = DL_VGM_Lem
--		from 
--			inserted
--	End

--	if @ETAAnterior <> @ETANovo 
--		Begin
--			set @MSG=('ETA UPDATED = From: ' +  convert(varchar(10),@ETAAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETANovo,105) + space(10) + 'Historic created by ATL System')
--			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETA Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
--			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
			
--			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@ETAAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@ETANovo)
--			--insert into [dbo].[Exchange_Alerta] (Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados)
--			--values (@Num_Proc,1,getdate(),'ETA_Lem',@Dados_Alterados)
--			exec spExchange_Alerta_Ins @Num_Proc,1,'ETA_Lem',@Dados_Alterados
--		End	
	
--	if @ETDAnterior <> @ETDNovo 
--		Begin
--			set @MSG='ETD UPDATED = From: ' +  convert(varchar(10),@ETDAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETDNovo,105) + space(10) + 'Historic created by ATL System'
--			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETD Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
--			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
			
--			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@ETDAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@ETDNovo)
--			--insert into [dbo].[Exchange_Alerta](Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados)
--			-- values (@Num_Proc,1,getdate(),'ETD_Lem',@Dados_Alterados)
--			 exec spExchange_Alerta_Ins @Num_Proc,1,'ETD_Lem',@Dados_Alterados
--		End	
		
--	if @ATAAnterior <> @ATANovo 
--		Begin					
--			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@ATAAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@ATANovo)
--			exec spExchange_Alerta_Ins @Num_Proc,1,'ATA_Lem',@Dados_Alterados
--		End	
		
--	if @DL_Draft_LemAnterior <> @DL_Draft_LemNovo and @DL_Draft_LemAnterior is not null
--		Begin
--			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@DL_Draft_LemAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@DL_Draft_LemNovo)
--			--insert into Exchange_Alerta (Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados) 
--			--values (@Num_Proc,1,getdate(),'DL_Draft_Lem',@Dados_Alterados)
--			exec spExchange_Alerta_Ins @Num_Proc,1,'DL_Draft_Lem',@Dados_Alterados
--		End
		
--	if @DL_Cargo_LemAnterior <> @DL_Cargo_LemNovo and @DL_Cargo_LemAnterior is not null
--		Begin
--			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@DL_Cargo_LemAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@DL_Cargo_LemNovo)
--			--insert into Exchange_Alerta (Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados) 
--			--values (@Num_Proc,1,getdate(),'DL_Cargo_Lem',@Dados_Alterados)
--			exec spExchange_Alerta_Ins @Num_Proc,1,'DL_Cargo_Lem',@Dados_Alterados
--		End
		
--	if @DL_VGM_LemAnterior <> @DL_VGM_LemNovo and @DL_VGM_LemAnterior is not null
--		Begin
--			set @Dados_Alterados = 'DE: ' + CONVERT(VARCHAR(50),@DL_VGM_LemAnterior) + ' - PARA: ' + CONVERT(VARCHAR(50),@DL_VGM_LemNovo)
--			--insert into Exchange_Alerta (Num_Proc,Id_TP_Alerta,Dt_Ins,Campo,Dados_Alterados) 
--			--values (@Num_Proc,1,getdate(),'DL_VGM_Lem',@Dados_Alterados)
--			exec spExchange_Alerta_Ins @Num_Proc,1,'DL_VGM_Lem',@Dados_Alterados
--		End
		
		
--	declare @Processo as varchar(16)
--	set @Processo = (select num_proc from [Log_Status] where num_proc = @Num_PRoc and id_status = @ID_Status)
	
--	If @ID_Status = 8 and  @ID_Status_Novo<> 5
--		BEGIN
--			if @Processo is null
--				begin			
--					insert into [Log_Status](num_proc,dt_ins,ID_Status)values(@Num_PRoc,getdate(),@ID_Status)
--				end
--			else
--				begin
--					update [Log_Status] set dt_ins = getdate() where num_proc = @Num_PRoc and id_status = @ID_Status
--				end	
--		END
	

	
--END




----ALTER TRIGGER [dbo].[TrgLLPEM_Upd] ON [dbo].[LLP_Exp_Mar] For Update 

----AS 
----BEGIN
	
----	Declare @ETAAnterior Datetime
----	Declare @ETANovo Datetime
----	Declare @ETDAnterior Datetime
----	Declare @ETDNovo Datetime
----	Declare @ATANovo Datetime	
----	Declare @ATAAntigo Datetime	
----	Declare @Num_PRoc	Varchar(16)
----	Declare @MSG Varchar(400)

------Esquema pra salvar alteração do status 8 pra qq outro
----	Declare @ID_Status as int	
----	Declare @ID_Status_Novo as int

------ Coletando campos antigos
----	select @ETAAnterior=eta_lem,@ETDAnterior=ETD_LeM,@ATAAntigo=ATA_LeM,@Num_proc=Num_proc_LeM,@ID_Status=ID_Status from deleted
------ Coletando campos Novos
----	select @ETANovo=eta_lem,@ETDNovo=ETD_LeM,@ATANovo=ATA_LeM,@ID_Status_Novo=ID_Status from inserted


----	if @ETAAnterior <> @ETANovo 
----		Begin
----			set @MSG=('ETA UPDATED = From: ' +  convert(varchar(10),@ETAAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETANovo,105) + space(10) + 'Historic created by ATL System')
----			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETA Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
----			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
----		End	
	
----	if @ETDAnterior <> @ETDNovo 
----		Begin
----			set @MSG='ETD UPDATED = From: ' +  convert(varchar(10),@ETDAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETDNovo,105) + space(10) + 'Historic created by ATL System'
----			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETD Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
----			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
----		End	
		
		
----	declare @Processo as varchar(16)
----	set @Processo = (select num_proc from [Log_Status] where num_proc = @Num_PRoc and id_status = @ID_Status)
	
----	If @ID_Status = 8 and  @ID_Status_Novo<> 5
----		BEGIN
----			if @Processo is null
----				begin			
----					insert into [Log_Status](num_proc,dt_ins,ID_Status)values(@Num_PRoc,getdate(),@ID_Status)
----				end
----			else
----				begin
----					update [Log_Status] set dt_ins = getdate() where num_proc = @Num_PRoc and id_status = @ID_Status
----				end	
----		END
	
----END


GO
ALTER TABLE [dbo].[LLP_Exp_Mar] ENABLE TRIGGER [TrgLLPEM_Upd]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgLLPEO_Upd] ON [dbo].[LLP_Exp_Out] For Update 

AS 
BEGIN

	Declare @Shipper as varchar(20)
	Declare @PO_Req_Date Datetime
	
	Declare @ETAAnterior Datetime
	Declare @ETANovo Datetime
	Declare @ETDAnterior Datetime
	Declare @ETDNovo Datetime
	Declare @ATANovo Datetime	
	Declare @ATAAntigo Datetime	
	Declare @Num_PRoc	Varchar(16)
	Declare @MSG Varchar(400)
	Declare @PO_Req_DateOLD Datetime
--Esquema pra salvar alteração do status 8 pra qq outro
	Declare @ID_Status as int
	Declare @ID_Status_Novo as int

-- Coletando campos antigos
	select @ETAAnterior=eta_leo,@ETDAnterior=ETD_Leo,@ATAAntigo=ATA_Leo,@Num_proc=Num_proc_Leo,@ID_Status=ID_Status,@PO_Req_DateOLD = PO_Req_Date from deleted
-- Coletando campos Novos
	select @ETANovo=eta_leo,@ETDNovo=ETD_Leo,@ATANovo=ATA_Leo,@ID_Status_Novo=ID_Status,@PO_Req_Date = PO_Req_Date from inserted

		if @PO_Req_DateOLD <> @PO_Req_Date
		Begin
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Num_Proc, getdate(), 0,GETDATE()) 
		End

	set @Shipper = (select P.Apelido from House_Exp_Out H with (nolock)
		 join Pessoa P with (nolock) on P.Cd_Pes = H.Cd_Export_HEO where Num_Proc_HEO = @Num_Proc)
		 
	if @ETAAnterior <> @ETANovo 
		Begin
			set @MSG=('ETA UPDATED = From: ' +  convert(varchar(10),@ETAAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETANovo,105) + space(10) + 'Historic created by ATL System')
			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETA Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
			
			exec spATL_Task_Automatico_Trigger_Ins @Num_Proc,@Shipper,@PO_Req_Date
		End	
	
	if @ETDAnterior <> @ETDNovo 
		Begin
			set @MSG='ETD UPDATED = From: ' +  convert(varchar(10),@ETDAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETDNovo,105)  + space(10) + 'Historic created by ATL System'
			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETD Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
			
			exec spATL_Task_Automatico_Trigger_Ins @Num_Proc,@Shipper,@PO_Req_Date
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




--ALTER TRIGGER [dbo].[TrgLLPEO_Upd] ON [dbo].[LLP_Exp_Out] For Update 

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
--	select @ETAAnterior=eta_leo,@ETDAnterior=ETD_Leo,@ATAAntigo=ATA_Leo,@Num_proc=Num_proc_Leo,@ID_Status=ID_Status from deleted
---- Coletando campos Novos
--	select @ETANovo=eta_leo,@ETDNovo=ETD_Leo,@ATANovo=ATA_Leo,@ID_Status_Novo=ID_Status from inserted


--	if @ETAAnterior <> @ETANovo 
--		Begin
--			set @MSG=('ETA UPDATED = From: ' +  convert(varchar(10),@ETAAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETANovo,105) + space(10) + 'Historic created by ATL System')
--			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETA Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
--			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
--		End	
	
--	if @ETDAnterior <> @ETDNovo 
--		Begin
--			set @MSG='ETD UPDATED = From: ' +  convert(varchar(10),@ETDAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETDNovo,105)  + space(10) + 'Historic created by ATL System'
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


GO
ALTER TABLE [dbo].[LLP_Exp_Out] ENABLE TRIGGER [TrgLLPEO_Upd]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgLLPIO_Upd] ON [dbo].[LLP_Imp_Out] For Update 

AS 
BEGIN
	
	Declare @Consignee as varchar(20)	
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
	Declare @ETAAddDay datetime
	Declare @ATAAddDay datetime
	Declare @QtyDays int


-- Coletando campos antigos
	select @ETAAnterior=eta_lio,@ETDAnterior=ETD_Lio,@ATAAntigo=ATA_Lio,@Num_proc=Num_proc_Lio,@ID_Status=ID_Status,@PO_Req_DateOLD = PO_Req_Date from deleted
-- Coletando campos Novos
	select @ETANovo=eta_lio,@ETDNovo=ETD_Lio,@ATANovo=ATA_Lio,@ID_Status_Novo=ID_Status,@PO_Req_Date = PO_Req_Date from inserted

	if @PO_Req_DateOLD <> @PO_Req_Date
		Begin
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Num_Proc, getdate(), 0,GETDATE()) 
		End
	
	if @ID_Status_Novo = 9
		Begin
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Num_Proc, getdate(), 0,GETDATE()) 
		End
		
	set @Consignee = (select P.Apelido from House_Imp_Out H with (nolock)
		 join Pessoa P with (nolock) on P.Cd_Pes = H.Cd_Consig_HIO where Num_Proc_HIO = @Num_Proc)

	if @ETAAnterior <> @ETANovo 
		Begin
			set @MSG=('ETA UPDATED = From: ' +  convert(varchar(10),@ETAAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETANovo,105) + space(10) + 'Historic created by ATL System')
			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETA Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
			
			exec spATL_Task_Automatico_Trigger_Ins @Num_Proc,@Consignee,@PO_Req_Date
		
		--if  substring(@Num_PRoc,3,3) = 'CSR' 
		--	Begin
		--		set @QtyDays = (select (Case When Cd_DstFinal_Lio in ('ITJ','IOA','NVT','URG','VCP','GRU') then 7 else Case When Cd_DstFinal_Lio ='GIG' then 10 else 0 end end)  from LLP_Imp_Out with(nolock) where Num_Proc_Lio = @Num_PRoc )
		--		if @QtyDays <>0
		--			Begin
		--				set @ETAAddDay = (select dateadd(day,@QtyDays,@ETANovo))
		--				set @MSG= ('Aguardando confirmação de chegada. ETA: ' + convert(varchar(10),@ETANovo,105) +  space(10) + 'Historic created by ATL System')
		--				exec spHistG_InsUPD @Num_Proc,Null,Null,'ETA',@MSG,'01-01-2010',@ETAAddDay,'ATL System','S','U',Null
		--			End
		--	End
			
		End	
	
	if @ETDAnterior <> @ETDNovo 
		Begin
			set @MSG='ETD UPDATED = From: ' +  convert(varchar(10),@ETDAnterior,105) + space(5)+'To: ' + convert(varchar(10),@ETDNovo,105)  + space(10) + 'Historic created by ATL System'
			exec spHistG_InsUPD @Num_Proc,Null,Null,'ETD Updated',@MSG,'01-01-2010',Null,'ATL System','S','U',Null
			--update house_imp_mar set obs_him=@msg where num_proc_him=@Num_Proc
			
			exec spATL_Task_Automatico_Trigger_Ins @Num_Proc,@Consignee,@PO_Req_Date
		End	

		--if @ATANovo <> isnull(@ATAAntigo,0) 
		--	Begin
		--		if substring(@Num_PRoc,3,3) = 'CSR' 
		--		Begin
		--			set @QtyDays = (select (Case When Cd_DstFinal_Lio in ('ITJ','IOA','NVT','URG','VCP','GRU') then 7 else Case When Cd_DstFinal_Lio ='GIG' then 10 else 0 end end)  from LLP_Imp_Out with(nolock) where Num_Proc_Lio = @Num_PRoc )
		--			if @QtyDays <>0
		--				Begin
		--					set @ATAAddDay = (select dateadd(day,@QtyDays,@ATANovo))
		--					set @MSG= ('Confirmação de chegada e aguardando analise do MAPA. ATA: ' + convert(varchar(10),@ATANovo,105) +  space(10) + 'Historic created by ATL System')
		--					exec spHistG_InsUPD @Num_Proc,Null,Null,'ATA',@MSG,'01-01-2010',@ATAAddDay,'ATL System','S','U',Null
		--				End
		--		End
		--	End	

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



--ALTER TRIGGER [dbo].[TrgLLPIO_Upd] ON [dbo].[LLP_Imp_Out] For Update 

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
--	select @ETAAnterior=eta_lio,@ETDAnterior=ETD_Lio,@ATAAntigo=ATA_Lio,@Num_proc=Num_proc_Lio,@ID_Status=ID_Status from deleted
---- Coletando campos Novos
--	select @ETANovo=eta_lio,@ETDNovo=ETD_Lio,@ATANovo=ATA_Lio,@ID_Status_Novo=ID_Status from inserted


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
ALTER TABLE [dbo].[LLP_Imp_Out] ENABLE TRIGGER [TrgLLPIO_Upd]
GO

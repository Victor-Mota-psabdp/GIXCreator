SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  TRIGGER [dbo].[TrgCampoProcesso_InsUpd] ON [dbo].[Campo_Processo] 
FOR INSERT, UPDATE
AS
	--cadu 2021-01-11
	Declare @Descricao_ANTERIOR Varchar(50)
	select @Descricao_ANTERIOR=campo_dados from deleted

	Declare @Processo	varchar(16)
	Select @Processo = Num_Proc from inserted
	Declare @id_campo as int
	Select @id_campo = Id_Campo from inserted

	--cadu 2021-01-11
	Declare @Descricao Varchar(50)
	Select @Descricao = campo_dados  from inserted
	
	 
	Begin 
		IF LEFT(@Processo,2) = 'BO'
			Begin
			--se for sem job, tem q ir p o smart, report manager e ax
				if exists(select LBO.Num_Proc_LBO from LLP_BDP_OUT LBO with(nolock)	
					where LBO.Num_Proc_LBO = @Processo and isnull(LBO.Id_TP_Servico ,0) <> 1)										
						Begin
							Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
							values (@Processo, getdate(), 0,GETDATE()) 
						
							Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
							values (@Processo, getdate()) 
						End
			-- se for = 1, so vai se  tiver job amarrado, só pode ir p o exchange, q envia ao ax, so deixei o dt_envio_JMD_AX = null
				if exists(select j.Num_Proc from LLP_BDP_OUT LBO with(nolock)	
							join JOB_HBO J with(nolock) on J.Num_Proc_HBO = LBO.Num_Proc_LBO
							where LBO.Num_Proc_LBO = @Processo and  j.Num_Proc is not null and isnull(LBO.Id_TP_Servico ,0) = 1)											
						Begin
							Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio,excReportManager,excReportManager2)
							values (@Processo, '2010-01-01', 0,'2010-01-01','2010-01-01','2010-01-01') 						
						End
			
			End
		ELSE
			Begin
				Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
				values (@Processo, getdate(), 0,GETDATE()) 
			
				Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
				values (@Processo, getdate()) 
			End		

	End
		
	Declare @ObsAtual Varchar(2000)
	Declare @ObsNova	Varchar(2000)
	select @ObsAtual=ltrim(rtrim(Campo_Dados)) from deleted
	select @ObsNova=ltrim(rtrim(Campo_Dados)) from inserted
	
	--Declare @id_campo	Int
	--Select @id_campo=Id_Campo from inserted
	
	Declare @cd_usuario Varchar(10)
	Select @cd_usuario = cd_usuario from inserted
	
	if @id_campo = 146 and (@ObsAtual is not null or @ObsAtual <> '')
		Begin
			Insert hist_geral
				select 
					TP.Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc) Seq,null,
					107,'Alterado de '+ @ObsAtual + ' para: ' + @ObsNova + ' ' + convert(varchar(10),GETDATE(),103) +' , histórico gerado por  ' + Nome_usuario ,getdate(),null,'ATL' Usuario,
					null,'S','U',null
				from 
					Campo_Processo TP					
					Left Join Usuario US on US.cd_usuario=@cd_usuario
				where
					TP.Num_Proc=@processo and TP.Id_Campo=@id_campo
		End


	--	ADDED BY CARLOS EDUARDO - 2021-01-11
	if @id_campo=143 and (@Descricao <> @Descricao_ANTERIOR)
		BEGIN
			if exists(select Num_Proc from dbo.Exchange_JMD_AX_ATL with(nolock) where num_proc = @Processo and envio = 1)
				BEGIN				
					UPDATE dbo.Exchange_JMD_AX_ATL set Envio = 0 where num_proc=@Processo
				END
		END


----ALTER  TRIGGER [dbo].[TrgCampoProcesso_InsUpd] ON [dbo].[Campo_Processo] 
----FOR INSERT, UPDATE
----AS
----	Declare @Processo	varchar(16)
----	Select @Processo = Num_Proc from inserted 
----		Begin 
----			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,excdtenvio) 
----			values (@Processo, getdate(), 0,null) 

----		End

--ALTER  TRIGGER [dbo].[TrgCampoProcesso_InsUpd] ON [dbo].[Campo_Processo] 
--FOR INSERT, UPDATE
--AS
--	Declare @Processo	varchar(16)
--	Select @Processo = Num_Proc from inserted 
--		Begin 
--		--if SUBSTRING(@Processo,1,2) not in('IA','EA')
--		--	Begin
--		--		Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus) values (@Processo, getdate(), 0) 
--		--	End
--		--Else
--		--	Begin
--				Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
--				values (@Processo, getdate(), 0,GETDATE()) 
			
--				Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
--				values (@Processo, getdate()) 
--		--	End

--		End
		
--	--select * from Campo_Processo where Id_Campo = 146	 and num_proc = 'IMCSR201512001BR'	
--	Declare @ObsAtual Varchar(2000)
--	Declare @ObsNova	Varchar(2000)
--	select @ObsAtual=ltrim(rtrim(Campo_Dados)) from deleted
--	select @ObsNova=ltrim(rtrim(Campo_Dados)) from inserted
	
--	Declare @id_campo	Int
--	Select @id_campo=Id_Campo from inserted
	
--	Declare @cd_usuario Varchar(10)
--	Select @cd_usuario = cd_usuario from inserted
	
--	if @id_campo = 146 and (@ObsAtual is not null or @ObsAtual <> '')
--		Begin
--			Insert hist_geral
--				select 
--					TP.Num_Proc,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc) Seq,null,
--					107,'Alterado de '+ @ObsAtual + ' para: ' + @ObsNova + ' ' + convert(varchar(10),GETDATE(),103) +' , histórico gerado por  ' + Nome_usuario ,getdate(),null,'ATL' Usuario,
--					null,'S','U',null
--				from 
--					Campo_Processo TP					
--					Left Join Usuario US on US.cd_usuario=@cd_usuario
--				where
--					TP.Num_Proc=@processo and TP.Id_Campo=@id_campo
--		End
	
	
	--Begin
	--			if @id_campo in (174,175,176)
	--				begin
	--					Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio,ExcFile) 
	--					values (@Processo, getdate(), 0,GETDATE(),'1') 
	--				end
	--			ELSE
	--				Begin
	--					Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
	--					values (@Processo, getdate(), 0,GETDATE()) 
					
	--					Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
	--					values (@Processo, getdate()) 
	--				End
	--		End			



GO
ALTER TABLE [dbo].[Campo_Processo] ENABLE TRIGGER [TrgCampoProcesso_InsUpd]
GO

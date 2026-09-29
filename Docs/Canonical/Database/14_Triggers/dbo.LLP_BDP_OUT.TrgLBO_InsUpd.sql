SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgLBO_InsUpd] ON [dbo].[LLP_BDP_OUT] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Declare @Id_TP_Servico bigint
	Select @Processo = Num_Proc_LBO from inserted 
	Select @Id_TP_Servico = Id_TP_Servico from inserted 
	--Esquema pra salvar alteração do status 8 pra qq outro
	Declare @ID_Status as int	
	Declare @ID_Status_Novo as int
	Declare @MSG Varchar(400)
	
	Begin
		select @ID_Status=ID_Status from deleted
	End
	Begin
		select @ID_Status_Novo=ID_Status from inserted
	End
	
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

		if @ID_Status <> @ID_Status_Novo  
		Begin
			set @MSG=('Job Status has been changed to: ' +  convert(varchar(10),@ID_Status,105) + space(5)+'To: ' 
			+ convert(varchar(10),@ID_Status_Novo,105) + space(10) + 'Historic created by ATL System - Verification')
			exec spHistG_InsUPD @Processo,Null,Null,'CSR',@MSG,'01-01-2010',Null,'ATL System','N','S',Null		
	
		End	

GO
ALTER TABLE [dbo].[LLP_BDP_OUT] ENABLE TRIGGER [TrgLBO_InsUpd]
GO

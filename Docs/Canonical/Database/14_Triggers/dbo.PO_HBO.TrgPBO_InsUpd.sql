SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgPBO_InsUpd] ON [dbo].[PO_HBO] 
FOR INSERT
AS
	Declare @Processo varchar(16)
	Select @Processo = Num_Proc_HBO from inserted 
	if len(@processo)=16		
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
		






--ALTER TRIGGER [dbo].[TrgPBO_InsUpd] ON [dbo].[PO_HBO] 
--FOR INSERT
--AS
--	Declare @Processo varchar(16)
--	Select @Processo = Num_Proc_HBO from inserted 
--	if len(@processo)=16
--		Begin 
--			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
--			values (@Processo, getdate(), 0,GETDATE()) 

--			Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
--			values (@Processo, getdate()) 

--		End



GO
ALTER TABLE [dbo].[PO_HBO] ENABLE TRIGGER [TrgPBO_InsUpd]
GO

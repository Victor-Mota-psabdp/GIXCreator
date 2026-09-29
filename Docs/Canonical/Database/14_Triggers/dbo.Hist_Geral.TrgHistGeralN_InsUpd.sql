SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgHistGeralN_InsUpd] ON [dbo].[Hist_Geral] 
FOR INSERT
AS
	--Declare @Processo varchar(16)
	--Select @Processo = hsgprocesso from inserted 
	
	
	Declare @Processo varchar(16)
	Declare @Cd_Tp_Ocor int
	Select @Processo = hsgprocesso from inserted 
	Select @Cd_Tp_Ocor = cd_tp_ocor from inserted 
	
	if len(@processo)=16
		--Begin 
		--	Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,excdtenvio) 
		--	values (@Processo, getdate(), 1,'01-01-2010') 

		--End
		IF LEFT(@Processo,2) = 'BO'
			Begin
			--se for sem job, tem q ir p o smart, report manager e ax
				if exists(select LBO.Num_Proc_LBO from LLP_BDP_OUT LBO with(nolock)	
					where LBO.Num_Proc_LBO = @Processo and isnull(LBO.Id_TP_Servico ,0) <> 1)										
						Begin
							Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
							values (@Processo, getdate(), 0,GETDATE()) 
				
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
				values (@Processo, getdate(), 1,'01-01-2010') 
			End	
			
			
		
	if @Cd_Tp_Ocor = 49			
			Begin 
				Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,excdtenvio) 
				(select Num_Proc,getdate(), 1,getdate() from Pedido_Ship with (nolock) where cd_pedido = @Processo)
			End
GO
ALTER TABLE [dbo].[Hist_Geral] ENABLE TRIGGER [TrgHistGeralN_InsUpd]
GO

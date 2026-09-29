SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE PRocedure [dbo].[spSaidaReportManagerHist_Rel]
		@Num_Proc	Varchar(16)
as

select @Num_proc Job, dbo.fBusca_HistoricoDescr(@Num_Proc,0,getdate())  Historico,dbo.fBusca_Historico(@Num_Proc,56,getdate()) DepositoDataReal,dbo.fBusca_Volumes(@Num_Proc) VolumeDescription,dbo.fBusca_HistoricoDescr_Completo(@Num_Proc) Hist_Completo




GO

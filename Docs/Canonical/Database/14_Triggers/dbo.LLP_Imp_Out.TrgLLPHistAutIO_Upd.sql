SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgLLPHistAutIO_Upd] ON [dbo].[LLP_Imp_Out] 
FOR  UPDATE
AS
	Declare @Processo	varchar(16)
	Declare @ATA		Datetime
	Declare @ATD		Datetime

	Select @Processo = Num_Proc_LIO from inserted 

	Select @ATA=ATA_LIO from inserted
	Select @ATD=ATD_LIO from inserted


	if @ATD  is not null
		Begin
			Insert hist_geral
				select 
					Num_Proc_LIO,(select isnull(max(hsgseq),0)+1 from hist_Geral with(nolock) where hsgprocesso=num_proc_LIO) Seq,null,
					HA.cd_tp_ocor,Mensagem + convert(varchar(10),ATD_LIO,103) +' , histórico gerado por  ' + 'ATL System' ,getdate(),null,'ATL' Usuario,
					null,HA.disp_cliente,'U',null
				from 
					LLP_imp_out TP with(nolock)
					Join Historico_Auto HA with(nolock) on HA.id_Task='-2' and left(TP.num_proc_LIO,2)=HA.Modal and HA.ativo='S'
					LEft Join Hist_Geral HG with(nolock) on hg.hsgprocesso=@Processo and HG.cd_tp_ocor=HA.cd_tp_ocor
				where
					Num_Proc_LIO=@Processo 
					and hsgprocesso is null
					and atd_LIO >='07-01-2010'

				--select 
				--	Num_Proc_LIO,(select isnull(max(hsgseq),0)+1 from hist_Geral with(nolock) where hsgprocesso=num_proc_LIO) Seq,null,
				--	'-2',Mensagem + convert(varchar(10),ATD_LIO,103) +' , histórico gerado por  ' + 'ATL System' ,getdate(),null,'ATL' Usuario,
				--	null,'S','U',null
				--from 
				--	LLP_imp_out TP with(nolock)
				--	Join Historico_Auto HA with(nolock) on HA.id_Task='-2' and left(TP.num_proc_LIO,2)=HA.Modal and HA.ativo='S'
				--	LEft Join Hist_Geral HG with(nolock) on hg.hsgprocesso=@Processo and HG.cd_tp_ocor='-2'
				--where

				--	Num_Proc_LIO=@Processo 
				--	and hsgprocesso is null
				--	and atd_LIO >='07-01-2010'
		End

	if @ATA  is not null
		Begin
			Insert hist_geral
				select 
					Num_Proc_LIO,(select isnull(max(hsgseq),0)+1 from hist_Geral with(nolock) where hsgprocesso=num_proc_LIO) Seq,null,
					HA.cd_tp_ocor,Mensagem + convert(varchar(10),ATA_LIO,103) +' , histórico gerado por  ' + 'ATL System' ,getdate(),null,'ATL' Usuario,
					null,HA.disp_cliente,'U',null
				from 
					LLP_imp_out TP with(nolock)
					Join Historico_Auto HA with(nolock) on HA.id_Task='-4' and left(TP.num_proc_LIO,2)=HA.Modal and HA.ativo='S'
					LEft Join Hist_Geral HG with(nolock) on hg.hsgprocesso=@Processo and HG.cd_tp_ocor=HA.cd_tp_ocor
				where
					Num_Proc_LIO=@Processo 
					and hsgprocesso is null
					and atd_LIO >='07-01-2010'

				--select 
				--	Num_Proc_LIO,(select isnull(max(hsgseq),0)+1 from hist_Geral with(nolock) where hsgprocesso=num_proc_LIO) Seq,null,
				--	'-4',Mensagem + convert(varchar(10),ATA_LIO,103) +' , histórico gerado por  ' + 'ATL System' ,getdate(),null,'ATL' Usuario,
				--	null,'S','U',null
				--from 
				--	LLP_imp_out TP with(nolock)
				--	Join Historico_Auto HA with(nolock) on HA.id_Task='-4' and left(TP.num_proc_LIO,2)=HA.Modal and HA.ativo='S'
				--	LEft Join Hist_Geral HG with(nolock) on hg.hsgprocesso=@Processo and HG.cd_tp_ocor='-4'
				--where

				--	Num_Proc_LIO=@Processo 
				--	and hsgprocesso is null
				--	and ata_LIO >='07-01-2010'

		End



GO
ALTER TABLE [dbo].[LLP_Imp_Out] ENABLE TRIGGER [TrgLLPHistAutIO_Upd]
GO

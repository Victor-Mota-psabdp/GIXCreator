SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgLLPHistAutEA_Upd] ON [dbo].[LLP_Exp_Aer] 
FOR  UPDATE
AS
	Declare @Processo	varchar(16)
	Declare @ATA		Datetime
	Declare @ATD		Datetime

	Select @Processo = Num_Proc_LEA from inserted 

	Select @ATA=ATA_LEA from inserted
	Select @ATD=ATD_LEA from inserted


	if @ATD  is not null
		Begin
			Insert hist_geral
				select 
					Num_Proc_LEA,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc_LEA) Seq,null,
					HA.cd_tp_ocor,Mensagem + convert(varchar(10),ATD_LEA,103) +' , histórico gerado por  ' + 'ATL System' ,getdate(),null,'ATL' Usuario,
					null,HA.disp_cliente,'U',null
				from 
					LLP_Exp_Aer TP
					Join Historico_Auto HA on HA.id_Task='-2' and left(TP.num_proc_LEA,2)=HA.Modal and HA.ativo='S'
					LEft Join Hist_Geral HG on hg.hsgprocesso=@Processo and HG.cd_tp_ocor=HA.cd_tp_ocor
				where
					Num_Proc_LEA=@Processo 
					and hsgprocesso is null
					and atd_LEA >='07-01-2010'

				--select 
				--	Num_Proc_LEA,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc_LEA) Seq,null,
				--	'-2',Mensagem + convert(varchar(10),ATD_LEA,103) +' , histórico gerado por  ' + 'ATL System' ,getdate(),null,'ATL' Usuario,
				--	null,'S','U',null
				--from 
				--	LLP_Exp_Aer TP
				--	Join Historico_Auto HA on HA.id_Task='-2' and left(TP.num_proc_LEA,2)=HA.Modal and HA.ativo='S'
				--	LEft Join Hist_Geral HG on hg.hsgprocesso=@Processo and HG.cd_tp_ocor='-2'
				--where

				--	Num_Proc_LEA=@Processo 
				--	and hsgprocesso is null
				--	and atd_LEA >='07-01-2010'
		End

	if @ATA  is not null
		Begin
			Insert hist_geral
				select 
					Num_Proc_LEA,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc_LEA) Seq,null,
					HA.cd_tp_ocor,Mensagem + convert(varchar(10),ATA_LEA,103) +' , histórico gerado por  ' + 'ATL System' ,getdate(),null,'ATL' Usuario,
					null,HA.disp_cliente,'U',null
				from 
					LLP_Exp_Aer TP
					Join Historico_Auto HA on HA.id_Task='-4' and left(TP.num_proc_LEA,2)=HA.Modal and HA.ativo='S'
					LEft Join Hist_Geral HG on hg.hsgprocesso=@Processo and HG.cd_tp_ocor=HA.cd_tp_ocor
				where

					Num_Proc_LEA=@Processo 
					and hsgprocesso is null
					and ata_LEA >='07-01-2010'

				--select 
				--	Num_Proc_LEA,(select isnull(max(hsgseq),0)+1 from hist_Geral where hsgprocesso=num_proc_LEA) Seq,null,
				--	'-4',Mensagem + convert(varchar(10),ATA_LEA,103) +' , histórico gerado por  ' + 'ATL System' ,getdate(),null,'ATL' Usuario,
				--	null,'S','U',null
				--from 
				--	LLP_Exp_Aer TP
				--	Join Historico_Auto HA on HA.id_Task='-4' and left(TP.num_proc_LEA,2)=HA.Modal and HA.ativo='S'
				--	LEft Join Hist_Geral HG on hg.hsgprocesso=@Processo and HG.cd_tp_ocor='-4'
				--where

				--	Num_Proc_LEA=@Processo 
				--	and hsgprocesso is null
				--	and ata_LEA >='07-01-2010'

		End



GO
ALTER TABLE [dbo].[LLP_Exp_Aer] ENABLE TRIGGER [TrgLLPHistAutEA_Upd]
GO

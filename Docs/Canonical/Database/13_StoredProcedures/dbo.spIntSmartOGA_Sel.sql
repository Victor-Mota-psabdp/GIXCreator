SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spIntSmartOGA_Sel]-- 'IMCSR201205004BR'
		@Num_Proc	Varchar(16)


AS


if left(uppeR(@num_proc),1)='I'
	Begin
		Select 
			Nome_Orgao_Anuente Nome_OGA, Isnull(Dt_Aut_Embarque,Dt_Deferimento) Data_Release_OGA,Dt_LI Data_Submit_OGA 
		fRom 
			dbo.Solicitacao_LI SI with(nolock)
			Join Solicitacao_Li_Orgao_Anuente SLOA with(nolock) on SI.num_solicitacao=SLOA.num_solicitacao
			Join Orgao_Anuente OA with(nolock) on OA.id_orgao=SLOA.id_orgao_anuente
		Where
			Num_Proc=@Num_Proc

	End
Else
	Begin

		Select 
			'PF1' Nome_OGA,TP91.Dt_Conclusao Data_Release_OGA, TP89.Dt_Conclusao Data_Submit_OGA
		From
			Tarefas_Processos TP89 With(Nolock)
			Join Tarefas_PRocessos TP91 with(nolock) on TP89.num_proc=TP91.num_proc and TP91.id_task=91
		Where
			TP89.Num_Proc=@Num_Proc and TP89.id_task=89
		
		Union All

		Select 
			'PF2' Nome_OGA,TP93.Dt_Conclusao Data_Release_OGA, TP92.Dt_Conclusao Data_Submit_OGA
		From
			Tarefas_Processos TP92 With(Nolock)
			Join Tarefas_PRocessos TP93 with(nolock) on TP92.num_proc=TP93.num_proc and TP93.id_task=91
		Where
			Tp92.Num_Proc=@Num_Proc and TP92.id_task=89
	End

GO

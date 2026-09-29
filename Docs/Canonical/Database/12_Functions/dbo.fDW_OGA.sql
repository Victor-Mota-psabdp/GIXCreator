SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[spIntSmartOGA_Sel

Create Function [dbo].[fDW_OGA]
(
	@Num_Proc varchar(16),
	@Type varchar(50)

)
RETURNS varchar(200)

BEGIN
	Declare @Resultado varchar(200)


	if @Type = 'OGA'
		BEGIN
			if left(uppeR(@num_proc),1)='I'
				Begin
					SET @Resultado=(Select top 1 Nome_Orgao_Anuente Nome_OGA fRom dbo.Solicitacao_LI SI with(nolock)
						Join Solicitacao_Li_Orgao_Anuente SLOA with(nolock) on SI.num_solicitacao=SLOA.num_solicitacao
						Join Orgao_Anuente OA with(nolock) on OA.id_orgao=SLOA.id_orgao_anuente
					Where
						Num_Proc=@Num_Proc)
				End
			Else
				Begin
					SET @Resultado=(Select 'PF1' Nome_OGA From Tarefas_Processos TP89 With(Nolock)
						Join Tarefas_PRocessos TP91 with(nolock) on TP89.num_proc=TP91.num_proc and TP91.id_task=91
					Where
						TP89.Num_Proc=@Num_Proc and TP89.id_task=89)		
				End
		END
			
	if @Type = 'Data_Release_OGA'
		BEGIN
			if left(uppeR(@num_proc),1)='I'
				Begin
					SET @Resultado=(Select top 1 CONVERT(VARCHAR, Isnull(Dt_Aut_Embarque,Dt_Deferimento), 112) 	 Data_Release_OGA fRom dbo.Solicitacao_LI SI with(nolock)
					Where Num_Proc=@Num_Proc)
				End
			Else
				Begin
					SET @Resultado=(Select CONVERT(VARCHAR,TP91.Dt_Conclusao, 112) Data_Release_OGA From Tarefas_Processos TP89 With(Nolock)
						Join Tarefas_PRocessos TP91 with(nolock) on TP89.num_proc=TP91.num_proc and TP91.id_task=91
					Where
						TP89.Num_Proc=@Num_Proc and TP89.id_task=89)		
				End
		END

		if @Type = 'Data_Submit_OGA'
		BEGIN
			if left(uppeR(@num_proc),1)='I'
				Begin
					SET @Resultado=(Select top 1  CONVERT(VARCHAR,Dt_LI,112) Data_Submit_OGA fRom dbo.Solicitacao_LI SI with(nolock)
					Where Num_Proc=@Num_Proc)
				End
			Else
				Begin
					SET @Resultado=(Select CONVERT(VARCHAR,TP89.Dt_Conclusao,112) Data_Submit_OGA From Tarefas_Processos TP89 With(Nolock)
						Join Tarefas_PRocessos TP91 with(nolock) on TP89.num_proc=TP91.num_proc and TP91.id_task=91
					Where
						TP89.Num_Proc=@Num_Proc and TP89.id_task=89)		
				End
		END

	RETURN @Resultado

END















GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ========================================================================
-- Author:		Claudio Alves
-- Create date: 13/12/2011
-- Description:	Select para gerar planilha "Draft da NF por Processo"
-- no módulo ReportXLS
-- ========================================================================
CREATE PROCEDURE [dbo].[spATL_DraftNF_Rel] --'IMCEN201304001BR'
(
	@Processo varchar(16)
)
AS
	select DISTINCT
		@Processo JOB,
		dbo.fBusca_Docs_PO_Modal(@Processo,1) PO,
		isnull(HIM.HAWB_HIM,isnull(HIA.HAWB_HIA,HIO.HAWB_HIO)) House,
		CFOP, 
		dbo.fBusca_Docs_PO_Modal(@Processo,5) DI,
		Paridade [Paridade Valor],
		T4.dt_conclusao [Data Desembaraço],
		(select nome_local from Localidade LO join campo_processo CP on CP.campo_dados=LO.cd_local where num_Proc =@Processo and CP.id_campo= 25) [Local de Desembaraco]
	from 
		Nota_Cliente NC with(nolock)
		Left Join House_Imp_Mar HIM with(nolock) on HIM.Num_Proc_HIM=NC.Num_Proc
		Left Join House_Imp_Aer HIA with(nolock) on HIA.Num_Proc_HIA=NC.Num_Proc
		Left Join House_Imp_Out HIO with(nolock) on HIO.Num_Proc_HIO=NC.Num_Proc
		Left Join tarefas_processos T4 with(nolock) on T4.num_proc = @Processo and T4.id_task = 4
	where 
		NC.Num_Proc=@Processo
GO

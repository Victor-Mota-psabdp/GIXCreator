SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spINTSmart_SEl]
		@Num_Proc	Varchar(16)

AS


select top 1 hsddescricao Saida from hist_geral with(nolock) where hsgprocesso=@num_proc and cd_tp_ocor='100' and disp_cliente='S'
Union All
select 
	'Doc Sent: ' + apelido + '  -  '  + 'AWB Number ' + courier_number_lem + '       Date: ' + convert(varchar(10),dbo.fBusca_Tarefa(num_proc_lem,12),103) 
from 
	llp_exp_mar with(nolock)
	LEft Join Pessoa PP with(nolock) on PP.cd_pes=cd_Courier
where num_proc_lem=@Num_Proc


OPTION(HASH JOIN)
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spJobsWithoutHonorarios_alert]

as

		BEGIN
			exec MSDB.dbo.SP_SEND_DBMAIL

				@profile_name = 'BDPMail', --@recipients='claudio.alves@bdp.com.br',

				@recipients='carlos.eduardo@bdp.com.br',

				--@copy_recipients = 'sistemas@bdp.com.br',

				@query = '(
							select distinct(num_proc_lim) Num_Proc from ATLANTIS.dbo.LLP_Imp_Mar where num_proc_lim not in (
								select distinct num_proc_him from ATLANTIS.dbo.cta_cte_hou_imp_Mar where cd_tp_tx in(''HN1'', ''HN2'',''HON''))					
							)',

				@subject = 'Teste de Email',

				@attach_query_result_as_file = 0,

				@query_result_width = 50000,

				@query_result_header = 0,

				@query_result_separator ='	'
		END


GO

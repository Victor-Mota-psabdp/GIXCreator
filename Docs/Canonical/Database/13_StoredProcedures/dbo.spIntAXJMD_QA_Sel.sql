SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spIntAXJMD_QA_Sel] 

AS


--select distinct top 100  excprocesso Job, 'U' strInstrucao from exchange with(nolock)
--Join Exchange_JMD_AX_ATL EX with(nolock) on EX.num_proc=excprocesso and dt_envio_Ax < getdate()-1
--where 
--	len(excprocesso)=16 and excdataalt<=getdate()-7

--	and dt_envio_jmd_ax is null
--union all

select distinct top 1  excprocesso Job, 'I' strInstrucao from exchange with(nolock)
Left Join Exchange_JMD_AX_ATL EX with(nolock) on EX.num_proc=excprocesso 
left join AX_Master_XML AM	with(nolock) on Ex.Num_Proc = AM.Num_proc
where 
	len(excprocesso)=16 and
	AM.Num_proc is null  and SUBSTRING(ExcProcesso,6,4) in  ('2015')
	
	
--	and ex.num_proc is null 
--		and dt_envio_jmd_ax is null
		
--union all

--select distinct top 100  excprocesso Job, 'U' strInstrucao from exchange with(nolock)
-- Join Exchange_JMD_AX_ATL EX with(nolock) on EX.num_proc=excprocesso
--where 
--	len(excprocesso)=16 
--	and dt_envio_jmd_ax is null
--	and SUBSTRING(ExcProcesso,6,4) between '2014' and '2015' and Dt_Envio_AX <= GETDATE() -30
	
	
GO

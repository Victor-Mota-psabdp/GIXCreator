SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spAX_Debitos2AXDOC_SEL 0  
--spAX_Faturas2AXDOCNF_SEL 0  
--spAX_Adto2AX_SEL 0  
--spAX_Debitos2AXDOCSOL_SEL 0  
--spIntAXJMD_Sel 650  
--20/02/2018 - incluido o esquema do bo - Cadu 
--14-01-2021 - incluido o U para reenvio como Update
/*
select 
	EX.num_proc Job, 
	'U' strInstrucao
		
	,DATEADD(day,1,EX.dt_envio_AX),
	getdate(),
	CP.campo_dados
from Exchange_JMD_AX_ATL EX with(nolock)  
	join vwALL_JOBs AL with(nolock) on EX.num_proc = AL.Num_Proc
	join Campo_Processo CP on CP.num_proc = EX.num_proc and id_campo = 143
where
	EX.Envio = 0 and
	DATEADD(day,1,EX.dt_envio) < getdate()
	--and ex.Num_Proc = 'IACTV202011016BR'
group by 
	EX.num_proc,EX.dt_envio_AX ,CP.campo_dados
*/

CREATE Procedure [dbo].[spIntAXJMD_Sel]   
  
AS  

-----07/2/2020 - Anderson: query add to check because OUT is not being saved by trigger  
insert exchange  
select null,num_proc_hbo,getdate(),0,getdate(),getdate(),getdate(),getdate(),null  from House_BDP_OUT L  
Left Join exchange EXC on L.Num_Proc_HBO=EXC.ExcProcesso  
where exc.excprocesso  is null   
and convert(datetime,dt_emis_hbo,105)>=getdate()-30 
 
BEGIN
  --BUSCA OS jobS para serem I -Insert
	select 
		excprocesso Job, 
		'I' strInstrucao  
	from exchange C with(nolock)  
		join vwALL_JOBs AL with(nolock) on C.ExcProcesso = AL.Num_Proc  
		Left Join Exchange_JMD_AX_ATL EX with(nolock) on EX.num_proc=c.excprocesso  
		left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO = C.ExcProcesso  
		left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO  
 
		left join LLP_Imp_mar LIM with(nolock) on LIM.Num_Proc_LIM = C.ExcProcesso  
		left join LLP_Exp_mar LEM with(nolock) on LEM.Num_Proc_LEM = C.ExcProcesso  

		left join House_Imp_mar HIM  with(nolock) on HIM.Num_Proc_HIM = C.ExcProcesso  
		left Join Pessoa PP with (nolock) on PP.Cd_Pes=Cd_Consig_him  
		left join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C' 
	where
		ex.num_proc is null   
		and c.dt_envio_jmd_ax is null   
	--Alessandra 03/07/2020 - obrigatorio para IM enviar no master
		and 
			(
				HIM.Num_Proc_HIM is null
				or
				(HIM.Num_Proc_HIM is not null and AX.Cd_Pes is not null )
			)
	--Alessandra 03/07/2020 - obrigatorio para IM e EM enviar no master
	and 
		(
			LIM.Num_Proc_LIM is null
			or
			(LIM.Num_Proc_LIM is not null and LIM.cd_tp_Carga is not null )
		)
	and 
		(
			LeM.Num_Proc_Lem is null
			or
			(LeM.Num_Proc_Lem is not null and LeM.cd_tp_Carga is not null )
		)
	and  
		(  
			J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1  
			or  
			J.Num_Proc is not null and LBO.Id_TP_Servico = 1    
		)
	group by 
		excprocesso
		
	UNION ALL

	select 
		EX.num_proc Job, 
		'U' strInstrucao
		
		--,DATEADD(day,1,EX.dt_envio_AX),
		--getdate(),
		--CP.campo_dados
	from Exchange_JMD_AX_ATL EX with(nolock)  
		join vwALL_JOBs AL with(nolock) on EX.num_proc = AL.Num_Proc
		join Campo_Processo CP on CP.num_proc = EX.num_proc and id_campo = 143
	where
		EX.Envio = 0 and
		DATEADD(day,1,EX.dt_envio) < getdate()
		--and ex.Num_Proc = 'IACTV202011016BR'
	group by 
		EX.num_proc--,EX.dt_envio_AX ,CP.campo_dados

END



/*
  
--select excprocesso Job, 'I' strInstrucao  from exchange C with(nolock)  
--join vwALL_JOBs AL with(nolock) on C.ExcProcesso = AL.Num_Proc  
--Left Join Exchange_JMD_AX_ATL EX with(nolock) on EX.num_proc=c.excprocesso  
--where   
-- len(c.excprocesso)=16   
-- and ex.num_proc is null   
-- and c.dt_envio_jmd_ax is null   
   
-- --and SUBSTRING(excprocesso,6,4) >='2014'  
--group by excprocesso  
  
--OPTION(HASH JOIN)  
  
-----07/2/2020 - Anderson: query add to check because OUT is not being saved by trigger  
insert exchange  
select null,num_proc_hbo,getdate(),0,getdate(),getdate(),getdate(),getdate(),null  from House_BDP_OUT L  
Left Join exchange EXC on L.Num_Proc_HBO=EXC.ExcProcesso  
where exc.excprocesso  is null   
and convert(datetime,dt_emis_hbo,105)>=getdate()-30 
---- and Num_Proc_HBO in ('BOCSR202006036BR','BOCSR202006050BR','BOSLA202006002BR')  
-----  
------cadu - 31/07/2020 - included more rules to be checked
--select null,L.num_proc_hbo,getdate(),0,getdate(),getdate(),getdate(),getdate(),null  
--	--,llp.Id_TP_Servico
--from House_BDP_OUT L with(nolock)  
--	 Join LLP_BDP_OUT LLP with(nolock)  on L.Num_Proc_HBO=LLP.num_proc_lbo
--	 join JOB_HBO J with(nolock) on J.Num_Proc_HBO = LLP.Num_Proc_LBO   
--Left Join exchange EXC with(nolock)  on L.Num_Proc_HBO=EXC.ExcProcesso  
--left join AX_Master_XML X with(nolock)  on L.Num_Proc_HBO=X.num_proc  
--where 
--	exc.excprocesso  is null  
--	and X.num_proc  is null
--	and j.Num_Proc is not null 
----and convert(datetime,dt_emis_hbo,105)>=getdate()-360
--and isnull(LLP.Id_TP_Servico ,0) = 1



  
select excprocesso Job, 'I' strInstrucao  from exchange C with(nolock)  
 join vwALL_JOBs AL with(nolock) on C.ExcProcesso = AL.Num_Proc  
 Left Join Exchange_JMD_AX_ATL EX with(nolock) on EX.num_proc=c.excprocesso  
 left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO = C.ExcProcesso  
 left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO  
 
 left join LLP_Imp_mar LIM with(nolock) on LIM.Num_Proc_LIM = C.ExcProcesso  
 left join LLP_Exp_mar LEM with(nolock) on LEM.Num_Proc_LEM = C.ExcProcesso  

 left join House_Imp_mar HIM  with(nolock) on HIM.Num_Proc_HIM = C.ExcProcesso  
 left Join Pessoa PP with (nolock) on PP.Cd_Pes=Cd_Consig_him  
 left join Pessoa_ATL_AX AX with(nolock) on AX.Cd_Pes = PP.Cd_Pes and Tipo='C' 


where   
  
 --len(c.excprocesso)=16   
  ex.num_proc is null   
 and c.dt_envio_jmd_ax is null   
 --and LEFT(c.ExcProcesso,2) ='BO'  
 
  --Alessandra 03/07/2020 - obrigatorio para IM enviar no master
  and 
 (
 HIM.Num_Proc_HIM is null
 or
 (HIM.Num_Proc_HIM is not null and AX.Cd_Pes is not null )
 )
 --Alessandra 03/07/2020 - obrigatorio para IM e EM enviar no master
  and 
 (
 LIM.Num_Proc_LIM is null
 or
 (LIM.Num_Proc_LIM is not null and LIM.cd_tp_Carga is not null )
 )
 and 
 (
 LeM.Num_Proc_Lem is null
 or
 (LeM.Num_Proc_Lem is not null and LeM.cd_tp_Carga is not null )
 )



 and  
 (  
  J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1  
  or  
  J.Num_Proc is not null and LBO.Id_TP_Servico = 1    
 )  
   
 --and SUBSTRING(excprocesso,6,4) >='2014'  
group by excprocesso  
  
--OPTION(HASH JOIN)  
  
--select distinct E.num_proc Job, 'I' strInstrucao from Exchange_JMD_AX_ATL  E  
--left join Temp_Master_AX T on T.num_proc = E.Num_Proc  
--join vwcliente C on E.num_proc = C.num_proc  
--where T.Num_Proc is null  
  
  
--select  excprocesso Job, 'I' strInstrucao from exchange with(nolock)  
--Left Join Exchange_JMD_AX_ATL EX with(nolock) on EX.num_proc=excprocesso  
--where   
-- len(excprocesso)=16   
-- and ex.num_proc is null   
-- and dt_envio_jmd_ax is null   
--group by excprocesso  
  
   */
 
GO

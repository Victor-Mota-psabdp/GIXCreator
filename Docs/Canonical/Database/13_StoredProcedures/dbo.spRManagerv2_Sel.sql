SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--20-02-2018 - cadu - incluido o esquema do bo  
  
CREATE Procedure [dbo].[spRManagerv2_Sel]  
  
as  
  ---deprecated 
  
 
select distinct 0, upper(excprocesso) job,min(Excdataalt) Data from exchange E with(nolock)  
 join vwCliente V with(nolock) on V.num_proc = E.ExcProcesso  
 left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO = E.ExcProcesso  
 left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO   
where   
 --len(excprocesso)=16   
  excreportmanager2 is null  
 and ExcFile is null  
 and substring(excprocesso,3,3) in('LYB','RHO','OXT','SOL')  
 and  
 (  
  J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1  
  --or  
  --J.Num_Proc is not null and LBO.Id_TP_Servico = 1    
 )  
 --and excprocesso<>'IMOXT202001060BR'  
group by upper(excprocesso)   
  
union all  
select distinct 1, upper(excprocesso) job,min(Excdataalt) Data from exchange E with(nolock)  
 join vwCliente V with(nolock) on V.num_proc = E.ExcProcesso  
 left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO = E.ExcProcesso  
 left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO   
where   
 --len(excprocesso)=16   
  excreportmanager2 is null  
 and ExcFile is null  
 and substring(excprocesso,3,3) not in('LYB','RHO','OXT','SOL')  
 and  
 (  
  J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1  
  --or  
  --J.Num_Proc is not null and LBO.Id_TP_Servico = 1    
 ) ---and excprocesso='IMCSR202003505BR'  
  --and excprocesso<>'IMOXT202001060BR'  
group by upper(excprocesso)   
  
  
order by 3 asc, 1 asc  
option(hash join)  
 
GO

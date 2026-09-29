SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spINTDocAnexos_CORTEVA_REPROCESSAMENTO]  
AS  
    
SET NOCOUNT ON  


 create table #tmp_num_proc   
 (  
 num_proc varchar(16) COLLATE Latin1_General_CI_AI   
 )  
--insert into #tmp_num_proc select 'IMCSR201905442BR'


insert into #tmp_num_proc select  'IMCSR201811138BR'
insert into #tmp_num_proc select  'IMCSR201903463BR'
insert into #tmp_num_proc select  'IMCSR201903464BR'
insert into #tmp_num_proc select  'IMCSR201903466BR'
insert into #tmp_num_proc select  'IMCSR201903608BR'
insert into #tmp_num_proc select  'IMCSR201903607BR'
insert into #tmp_num_proc select  'IMCSR201901565BR'
insert into #tmp_num_proc select  'IMCSR201901714BR'
insert into #tmp_num_proc select  'IMCSR201904092BR'
insert into #tmp_num_proc select  'IMCSR201904096BR'
insert into #tmp_num_proc select  'IMCSR201906099BR'
insert into #tmp_num_proc select  'IMCSR201906098BR'
insert into #tmp_num_proc select  'IMCSR201906112BR'
insert into #tmp_num_proc select  'IMCSR201907480BR'
insert into #tmp_num_proc select  'IMCSR201901704BR'
insert into #tmp_num_proc select  'IMCSR201901706BR'
insert into #tmp_num_proc select  'IMCSR201901708BR'
insert into #tmp_num_proc select  'IMCSR201901707BR'






	select     
	Nome_Arquivo,
	Smart_DOc,
	DA.num_proc + '_' +Smart_Doc+'.PDF' Nome_Doc,    
	'01BDPBRSAO_'+DA.num_proc+'_'+right('0000' + DMS_Code ,4) + '_01_add' DMS_Arquivo,    
	DMS_Code,
	dt_creacao,
	Anexado_em    
	FROM Doc_Anexos DA (nolock)    
	INNER JOIN tipo_doc_cliente TC (nolock) 
		on TC.id_dc=DA.id_dc    
	INNER JOIN dbo.vwClienteALLJOBS AJ (nolock) 
		on DA.num_proc = AJ.Num_Proc  
	--INNER JOIN vwHouse_Imp HOU (nolock)
	--	on DA.num_proc = HOU.Num_Proc  
	--LEFT JOIN Pessoa CS (nolock) 
	--	on AJ.cd_cliente = CS.Cd_Pes 
	WHERE	--len(DA.num_proc)=16    
			--and left(DA.num_proc,2) <> 'BO'   
			--and right(DA.num_proc,2)in ('BR','01') and    
			isnull(TC.DMS_Code,'') <> '' 
			--and DMS_Code not in ('0010','0025','0036','0039','0047','0053','0057','0059','0066','0030','114','0049','0103')    
			--and J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1        
			--AND Anexado_Em between  GETDATE()-90 and GETDATE()
				--(convert(datetime,dt_emis,103) >= GETDATE()-90
				--or dt_envio between  GETDATE()-90 and GETDATE()
				--or Anexado_Em between  GETDATE()-90 and GETDATE()
				--or exists 
				--	(
				--	select * from tarefas_processos tp (nolock)
				--	where da.Num_Proc =  tp.Num_Proc
				--	and tp.id_Task=4
				--	and tp.dt_Conclusao between GETDATE()-90 and GETDATE()
				--	)
				--)
			 --AND (CS.Apelido like 'DOW AGRO%' or CS.Apelido like 'DUPONT%' or CS.Apelido like 'DU PONT%' OR CS.Apelido = 'DOW - 3770C') 
		--and da.Num_Proc = 'IMDPT201905079BR'
		--and DMS_Code = '0059'
		
	  and da.Num_Proc in (select Num_Proc from #tmp_num_proc (nolock))
	  -- CI - 0039  
	  -- DAT - 0066  
	  -- LI - 0078  
	  -- COA - 0023  
	  --and DMS_Code in ('0039','0066','0078','0023')
	  --and DMS_Code = '0042' -- NF
 
set nocount off   
  
  
 /*
 alter Procedure [dbo].[spINTDocAnexos_CORTEVA_REPROCESSAMENTO]  
  as  
    
set nocount on  
    
 --create table #tmp_num_proc   
 --(  
 --num_proc varchar(16) COLLATE Latin1_General_CI_AI   
 --,DMS_Code  varchar(5) COLLATE Latin1_General_CI_AI 
 --)  
 

	--insert into #tmp_num_proc
	--select distinct DA.num_proc  ,DMS_Code   
	--from Doc_Anexos DA with(nolock)  
	--Join tipo_doc_cliente TC with(nolock) on TC.id_dc=DA.id_dc  
	--where dt_envio between  GETDATE()-90 and GETDATE()   
	--and len(DA.num_proc)=16  
	--and right(DA.num_proc,2)in ('BR','01')  
	--and DMS_Code is not null and DMS_Code <> ''   
	--and left(DA.num_proc,2) <> 'BO'  
	----and Nome_Arquivo  in  (select nome_arquivo from Historico_reprocessamento_docs_DOW (nolock))
	--group by DA.num_proc ,DMS_Code
	--having count(*) > 1
	
 --create table #tmp_num_proc   
 --(  
 --num_proc varchar(16) COLLATE Latin1_General_CI_AI   
 --)  
 
 --insert into #tmp_num_proc
 --select 'IACSR201907011BR'


   
 select distinct DA.num_proc   
     ,Nome_Arquivo  
     ,Smart_DOc,DA.num_proc + '_' +Smart_Doc+'.PDF' Nome_Doc,  
     '01BDPBRSAO_'+DA.num_proc+'_'+right('0000' + TC.DMS_Code ,4) + '_01_add' DMS_Arquivo,  
     TC.DMS_Code,dt_creacao,Anexado_em  
   ,GETDATE() as data_reprocessamento  
 from   
  Doc_Anexos DA with(nolock)  
  Join tipo_doc_cliente TC with(nolock) on TC.id_dc=DA.id_dc  
 -- inner join #tmp_num_proc tmp
	--on da.Num_Proc = tmp.num_proc
	--and TC.DMS_Code = tmp.DMS_Code
  
  --Join dbo.vwClienteALLJOBS AJ with(nolock) on DA.num_proc = AJ.Num_Proc   
  --left join LLP_BDP_OUT LBO on LBO.Num_Proc_LBO COLLATE DATABASE_DEFAULT =DA.num_proc COLLATE DATABASE_DEFAULT  
  --left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO =DA.num_proc  
  --left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO  
  --left join Pessoa CS with(nolock) on AJ.cd_cliente = CS.Cd_Pes  
 where --dt_envio between  GETDATE()-90 and GETDATE()and   
  len(DA.num_proc)=16  
  and right(DA.num_proc,2)in ('BR','01')  
  --and isnull(Anexado_em,'01-01-2014') >=getdate()-360   
  and TC.DMS_Code is not null and TC.DMS_Code <> ''  
  --and DMS_Code not in ('0010','0025','0036','0039','0047','0053','0057','0059','0066','0030','114','0049','0103')  
  --and (J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1)  
  and left(DA.num_proc,2) <> 'BO'  
  
  -- CI - 0039  
  -- DAT - 0066  
  -- LI - 0078  
  -- COA - 0023  
    
  and da.Num_Proc in (select Num_Proc from #tmp_num_proc ) 
    
  --and DMS_Code = '0059'
  --and DMS_Code in ('0039','0066','0078','0023') -- ,0109,0103,0100,0095,0071,0066,0049,0047,0042,0040,0039,0032,0030,0025,0023,0017,0015  
  order by Nome_Arquivo
  
  
set nocount off   
  
 
 
 
 */
GO

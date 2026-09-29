SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--10-01-2018 - retirado o envio do BO - Cadu/Anderson 300-41549
--4/12 - INCLUIDO O '0103' E REENVIADO OS JOBS SLA2017 - CADU
--2/4/2018 - incluido o esquema do BO
CREATE Procedure [dbo].[spINTDocAnexos_FDS]
		as
		

declare @data_ini datetime
declare @data_fim datetime

IF DATEPART(dw,getdate()) IN (1) -- DOMINGO 
	BEGIN
		SET @data_ini = getdate()-6
		SET @data_fim = getdate()-1
	END
ELSE IF DATEPART(dw,getdate()) IN (7) -- SABADO
	BEGIN
		SET @data_ini = getdate()-5
		SET @data_fim = getdate()-1
	END
ELSE IF DATEPART(dw,getdate()) IN (6) -- sexta
	BEGIN
		SET @data_ini = getdate()-4
		SET @data_fim = getdate()
	END	

select 
	Nome_Arquivo,Smart_DOc,DA.num_proc + '_' +Smart_Doc+'.PDF' Nome_Doc,
	'01BDPBRSAO_'+DA.num_proc+'_'+right('0000' + DMS_Code ,4) + '_01_add' DMS_Arquivo,
	 DMS_Code,dt_creacao,Anexado_em

from 
	Doc_Anexos DA with(nolock)
	Join tipo_doc_cliente TC with(nolock) on TC.id_dc=DA.id_dc
	Join dbo.vwALL_JObs AJ	with(nolock) on DA.num_proc = AJ.Num_Proc	
	--left join LLP_BDP_OUT LBO on LBO.Num_Proc_LBO COLLATE DATABASE_DEFAULT =DA.num_proc COLLATE DATABASE_DEFAULT
	left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO =DA.num_proc
	left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO
	
where
	Dt_Envio between @data_ini and @data_fim
	and len(DA.num_proc)=16
	and right(DA.num_proc,2)in ('BR','01')
	and isnull(Anexado_em,'01-01-2014') >=getdate()-360 
	and DMS_Code is not null and DMS_Code <> ''
	--and DMS_COde not in ('114','0036','0010','0039','0030')
	and DMS_Code not in ('0010','0025','0036','0039','0047','0053','0057','0059','0066','0030','114','0049','0103')
	and
		(
			J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
			--or
			--J.Num_Proc is not null and LBO.Id_TP_Servico = 1		
		)
	and left(DA.num_proc,2) <> 'BO'
	
Union all

select 
	Nome_Arquivo,Smart_DOc,DA.num_proc + '_' +Smart_Doc+'.PDF' Nome_Doc,
	'01BDPBRSAO_'+DA.num_proc+'_'+right('0000' + DMS_Code ,4) + '_' + right('0000' + cast(da.ID_DC as varchar(3)),2) + '_add' DMS_Arquivo,
	 DMS_Code,dt_creacao,Anexado_em

from 
	Doc_Anexos DA with(nolock)
	Join tipo_doc_cliente TC with(nolock) on TC.id_dc=DA.id_dc
	Join dbo.vwALL_JObs AJ	with(nolock) on DA.num_proc = AJ.Num_Proc
	left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO =DA.num_proc
	left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO
where 
	Dt_Envio between @data_ini and @data_fim
	and len(DA.num_proc)=16
	and right(DA.num_proc,2)in ('BR','01')
	and isnull(Anexado_em,'01-01-2014') >=getdate()-360 and DMS_Code is not null and DMS_Code <> ''
	--and DMS_COde in ('114','0036','0010','0039','0030')
	and DMS_Code in ('0010','0025',	'0036','0039','0047','0053','0057','0059','0066','0030','114','0049','0103')
	and
		(
			J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
			--or
			--J.Num_Proc is not null and LBO.Id_TP_Servico = 1		
		)
	and left(DA.num_proc,2) <> 'BO'
order by 
	Anexado_em


GO

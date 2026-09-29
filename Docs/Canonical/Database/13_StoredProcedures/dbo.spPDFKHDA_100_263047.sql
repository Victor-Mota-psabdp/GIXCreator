SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPDFKHDA_100_263047]                   
                  
AS                  
SET NOCOUNT ON           

select 
--top 10
distinct 
UPPER(da.Num_Proc)		Num_Proc                       
,UPPER(nome_arquivo)		nome_arquivo                     
,UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','')) + '.pdf' NOME_DOC
,case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'I' 
then 'Importação' 
else 
	case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'E' then 'Exportação' else 'Outros' end  
end as PASTA_01


, convert(char(4),YEAR(dt_Conclusao)) as PASTA_02



,CASE WHEN 
	LEN(
		ISNULL(
	
		replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	
		ltrim(rtrim(numero_po))
	
		,char(13)+char(10),''),char(10),''),'-',''),'.',''),'+',''),')',''),'(',''),'_',''),' ',''),'.',''),',',''),'#',''),':',''),'°','')

		,'PO_NOT_FOUND_'+da.Num_Proc)
		)<1
	THEN
		'PO_NOT_FOUND_'+da.Num_Proc
	ELSE

		ISNULL(

		replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	
		ltrim(rtrim(numero_po))
	
		,char(13)+char(10),''),char(10),''),'-',''),'.',''),'+',''),')',''),'(',''),'_',''),' ',''),'.',''),',',''),'#',''),':',''),'°','')

		,'PO_NOT_FOUND_'+da.Num_Proc)

	END AS PASTA_03
--,DMS_Code 
--into aux_ale
FROM vwClienteALLJOBS V (NOLOCK)  
INNER JOIN doc_anexos DA (NOLOCK)
	on V.Num_Proc = DA.Num_Proc       
INNER Join Tipo_DoC_Cliente TC with(nolock) 
	on TC.id_dc=da.Id_DC --and DMS_Code is not null 
inner join tarefas_processos tp  (NOLOCK)
	on DA.Num_Proc =  tp.Num_Proc



 left join vwPO PO with(nolock)       
  on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1  




--and TC.ID_DC in (10,195,040,075,5)     
 WHERE id_Task=40   -- Envio da Prestação de Contas
 and tp.dt_Conclusao between '2019-10-01 00:00:00.000' and '2020-12-31 23:59:59.999'   



 --select Cd_Pes from Pessoa where Apelido = 'GRUPO OXITENO'
and cd_cliente in (
	select cd_pes from Pessoa_LLP (nolock)       
	where Cd_Pes_Grupo in          
		(select Cd_Pes from Pessoa where Apelido = 'GRUPO OXITENO')      
	)   
	

 ORDER BY 

case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'I' 
then 'Importação' 
else 
	case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'E' then 'Exportação' else 'Outros' end  
end 
,convert(char(4),YEAR(dt_Conclusao)) 


               
        
SET NOCOUNT OFF   

GO

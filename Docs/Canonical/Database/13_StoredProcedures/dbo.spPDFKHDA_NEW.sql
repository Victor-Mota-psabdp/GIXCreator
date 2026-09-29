SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPDFKHDA_NEW]                       
                      
AS        




SELECT DISTINCT 
	UPPER(da.Num_Proc) Num_Proc,    
	da.Id_DC  ,                
	UPPER(nome_arquivo) nome_arquivo,    
	UPPER(nome_arquivo) nome_doc
	--UPPER(da.Num_Proc + '_' + replace(replace(da.Id_DC ,' ',''),'/','')) + '.pdf' NOME_DOC                                                                              
FROM doc_anexos DA (NOLOCK)         
INNER Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null
WHERE da.Id_DC  in (  060
--5
)                                    
              
and da.Num_Proc in                      
(                      
'BOSUE202310009BR',
'BOSUE202311004BR',
'BOSUE202312008BR',
'EASUE202401001BR',
'EASUE202401004BR',
'EASUE202403001BR',
'EASUE202404001BR',
'EASUE202404003BR',
'EMSUE202312002BR',
'EMSUE202401001BR',
'EMSUE202401002BR',
'EMSUE202401003BR',
'EMSUE202401004BR',
'EMSUE202401005BR',
'EMSUE202402001BR',
'EMSUE202403001BR',
'EMSUE202403002BR',
'EMSUE202403003BR',
'EMSUE202404001BR',
'EMSUE202405004BR',
'EOSUE202401005BR',
'EOSUE202401016BR',
'EOSUE202402011BR',
'EOSUE202403014BR',
'EOSUE202404011BR',
'EOSUE202404014BR',
'EOSUE202404016BR',
'EOSUE202404018BR',
'EOSUE202405002BR',
'EOSUE202405003BR',
'IASUE202211014BR',
'IASUE202212020BR',
'IASUE202303012BR',
'IASUE202306004BR',
'IASUE202306011BR',
'IASUE202308003BR',
'IASUE202310002BR',
'IASUE202312001BR',
'IASUE202312002BR',
'IASUE202401004BR',
'IASUE202401005BR',
'IASUE202402008BR',
'IASUE202403005BR',
'IASUE202403020BR',
'IASUE202404016BR',
'IASUE202405001BR',
'IASUE202405010BR',
'IASUE202405013BR',
'IASUE202405014BR',
'IMSUE202303009BR',
'IMSUE202305035BR',
'IMSUE202307027BR',
'IMSUE202307038BR',
'IMSUE202307040BR',
'IMSUE202307041BR',
'IMSUE202311020BR'

)                      
order by  da.Id_DC         

  
  
  
  
                
--select po.Numero_PO,  
-- isnull(replace(replace(  
   
-- case when po.Numero_PO = ''   then 'PONotFound'  else (case when po.Numero_PO = '-' then 'PONotFound' else po.Numero_PO  end) end  
   
   
-- ,' ',''),'/',''),'PONotFound')  pasta,  
--upper(V.Num_Proc) Num_Proc,                       
--upper(nome_arquivo) nome_arquivo,                      
--upper(da.Num_Proc) + '_' + replace(replace(upper(TC.Nome_DC),' ',''),'/','') + '.pdf' NOME_DOC,                       
--*   
--from vwAll_JOBs V (nolock)  
--inner join Tarefas_Processos  T (nolock)  
-- on V.Num_Proc = T.Num_Proc  
--inner join doc_anexos DA (nolock)  
-- on V.Num_Proc = DA.Num_Proc  
--inner join  Tipo_DoC_Cliente TC with(nolock)   
-- on TC.id_dc=da.Id_DC and DMS_Code is not null      
--left join vwPO PO with(nolock) on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1   
--where t.ID_Task = '40'  
--and t.Dt_Conclusao between '2019-05-01' and '2019-10-18'  
--and SUBSTRING(V.Num_Proc,3,3) ='sol'   -- oxt sol swb  
--and SUBSTRING(v.Num_Proc,1,2) ='BO'  
--order by pasta, v.Num_Proc      


  
                               
                 
--select   
--CASE WHEN SUBSTRING(v.Num_Proc,1,2) ='BO' THEN 'BO' ELSE isnull(replace(replace(po.Numero_PO,' ',''),'/',''),'PONotFound') END pasta,  
--upper(V.Num_Proc) Num_Proc,                       
--upper(nome_arquivo) nome_arquivo,                      
--upper(da.Num_Proc) + '_' + replace(replace(upper(TC.Nome_DC),' ',''),'/','') + '.pdf' NOME_DOC,                       
--*   
--from vwAll_JOBs V (nolock)  
--inner join Tarefas_Processos  T (nolock)  
-- on V.Num_Proc = T.Num_Proc  
--inner join doc_anexos DA (nolock)  
-- on V.Num_Proc = DA.Num_Proc  
--inner join  Tipo_DoC_Cliente TC with(nolock)   
-- on TC.id_dc=da.Id_DC and DMS_Code is not null      
--left join vwPO PO with(nolock) on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1   
--where t.ID_Task = '40'  
--and t.Dt_Conclusao between '2019-05-01' and '2019-10-18'  
--and SUBSTRING(V.Num_Proc,3,3) ='SWB'     
--and (SUBSTRING(v.Num_Proc,1,1) ='I' or SUBSTRING(v.Num_Proc,1,2) ='BO' )  
--order by pasta, v.Num_Proc        
                      
                      
--select distinct UPPER(da.Num_Proc) Num_Proc,    da.Id_DC  ,                
-- UPPER(nome_arquivo) nome_arquivo,                      
-- UPPER(da.Num_Proc + '_' + replace(replace(da.Id_DC ,' ',''),'/','')) + '.pdf' NOME_DOC                                         
-- --,DMS_Code                                        
-- from doc_anexos DA with(nolock)                      
-- --Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC                                      
--where da.Id_DC  in (  
-- 015  
--,020  
--,044  
--,074  
-- ,149  
-- ,177  
--,178  
--,180  
--,181  
  
--)                    
---- and da.Num_Proc in                      
----(                      
----'IAOSR201602012BR')                   
                    
--and da.Num_Proc in                      
--(                      
--'EACSR201605005BR',  
--'EAATH201708001BR',  
--'EAATL201711004BR',  
--'EAATL201612015BR',  
--'EAATL201612002BR',  
--'EAATL201612003BR',  
--'EAATL201612004BR',  
--'EAATL201612007BR',  
--'EAATL201612008BR',  
--'EAATL201612012BR',  
--'EAATL201612013BR',  
--'EAATL201607002BR',  
--'EAATL201701001BR',  
--'EMATL201706002BR',  
--'IAATL201711049BR',  
--'IAATL201708047BR',  
--'IAFUN201708001BR',  
--'IAATL201706042BR',  
--'IACSR201709010BR',  
--'IANVS201706001BR',  
--'IACSR201703059BR',  
--'IACSR201602022BR',  
--'EAKRY201605001BR',  
--'EMATL201703055BR',  
--'EMATL201703054BR',  
--'EMATL201703023BR',  
--'EMATL201702009BR',  
--'EMATL201702008BR',  
--'EMATL201702007BR',  
--'EMATL201608014BR',  
--'EMATL201606045BR',  
--'EMATL201603011BR',  
--'EMATL201604001BR',  
--'EMATL201602021BR',  
--'EACSR201711006BR',  
--'EAOSR201712001BR',  
--'EACSR201711003BR',  
--'EAKRY201601001BR',  
--'EAMAU201512002BR',  
--'EAOCV201601001BR',  
--'EAKRY201601002BR',  
--'EAOCV201601002BR',  
--'EAKRY201601003BR',  
--'EAOCV201601003BR',  
--'EAKRY201602001BR',  
--'EASYN201603001BR',  
--'EAMAU201604001BR',  
--'EAKRY201605002BR',  
--'EALAN201606001BR',  
--'EAKRY201606001BR',  
--'EAOSR201606001BR',  
--'EAEXO201608001BR',  
--'EAOSR201610001BR',  
--'EAHEX201611001BR',  
--'EAOSR201611001BR',  
--'EAOSR201611002BR',  
--'EALES201612001BR',  
--'EASGB201702001BR',  
--'EASGB201702002BR',  
--'EASGB201702003BR',  
--'EAEXO201703003BR',  
--'EAEXO201704001BR',  
--'EALAN201706001BR',  
--'EASGB201709001BR',  
--'EACSR201709003BR',  
--'EACSR201709004BR',  
--'EACSR201709005BR',  
--'EACSR201709007BR',  
--'EACSR201709014BR',  
--'EACSR201709012BR',  
--'EACSR201709013BR',  
--'EACSR201711002BR',  
--'EACSR201711005BR',  
--'EACSR201711004BR',  
--'EASGB201712001BR',  
--'EASGB201710002BR',  
--'EASGB201710003BR',  
--'EMATL201602002BR',  
--'EMATL201601007BR',  
--'EMATL201603026BR',  
--'EMBCB201603006BR',  
--'EMATL201602006BR',  
--'EMAMZ201603008BR',  
--'EMBCB201605002BR',  
--'EMATL201602005BR',  
--'EMFMC201609001BR',  
--'EMATL201610007BR',  
--'EMATL201610023BR',  
--'EMATL201612031BR',  
--'EMATL201703018BR',  
--'EMBCB201703002BR',  
--'EMATL201705034BR',  
--'EMATL201706030BR',  
--'EMATL201709004BR',  
--'EMATL201710018BR',  
--'IAAPB201801006BR',  
--'IACSR201712066BR',  
--'IACSR201706024BR',  
--'IAATL201702044BR'  
--)                      
--order by  da.Id_DC         
  
  
  
  
  
  
  
  
  
  
  
  
  
  
         
                      
--option(hash join)                      
                      
--select distinct UPPER(da.Num_Proc) Num_Proc,                       
-- UPPER(nome_arquivo) nome_arquivo,                      
-- UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','')) + '.pdf' NOME_DOC,                       
-- --isnull(replace(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),' ',''),'/',''),'SalesOrder_NotFound') pasta,                      
-- isnull(replace(replace(po.Numero_PO,' ',''),'/',''),'PONotFound') pasta,                      
-- --replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),'PONotFound'),' ',''),'/','')  pasta,                      
-- DMS_Code                      
-- --F.Data_PC,                      
-- --SUBSTRING(DA.Num_Proc,3,3),                      
-- --SUBSTRING(DA.Num_Proc,3,3) Grupo                      
-- from doc_anexos DA with(nolock)                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
-- join Fatura_CHB F on left(F.Fatura_PC,16) = DA.Num_Proc                      
-- --join Pessoa P on P.cd_pes = A.cd_cliente                      
-- join vwPO PO with(nolock) on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1                      
--where                      
-- F.Data_PC between '2018-01-01' and '2019-05-17'                      
-- and SUBSTRING(DA.Num_Proc,3,3) ='OXT'                       
-- and  SUBSTRING(DA.Num_Proc,1,1) ='B'                      
--order by pasta                      
                       
--Período: 01/01/2018 até 17/05/2019                      
--BO da Oxiteno                      
 --select * from Pessoa where Apelido like 'grupo%Oxiteno%'                      
 --select * from Grupo where Cd_Pes_Grupo = 'P21128'              
 --da.Num_Proc in                      
 -- ('EAOXT201807005BR')         
                      
                      
                      
--select                      
-- upper(da.Num_Proc) Num_Proc,                       
-- upper(nome_arquivo) nome_arquivo,                      
-- upper(da.Num_Proc) + '_' + replace(replace(upper(TC.Nome_DC),' ',''),'/','') + '.pdf' NOME_DOC,                       
-- replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),'PONotFound'),' ',''),'/','')  pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao                      
-- --SUBSTRING(DA.Num_Proc,3,3),                      
-- --SUBSTRING(DA.Num_Proc,3,3) Grupo,                      
-- --cp143.Campo_Dados                      
-- from doc_anexos DA with(nolock)                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
-- join vwClienteALLJOBS a on A.Num_Proc = DA.Num_Proc                      
-- --join Pessoa P on P.cd_pes = A.cd_cliente                      
-- join Campo_Processo cp143 with(nolock) on da.Num_Proc = cp143.Num_proc and  cp143.Id_Campo = 143                      
--where                      
-- CONVERT(date,a.dt_criacao, 103) between '2019-01-01' and '2019-05-17'                       
-- and SUBSTRING(DA.Num_Proc,3,3) ='SOL'                       
-- and  SUBSTRING(DA.Num_Proc,1,1) ='E'                      
--order by 3                      
                      
                      
--select                
-- da.Num_Proc,                       
-- nome_arquivo,                      
-- da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
-- --isnull(replace(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),' ',''),'/',''),'SalesOrderNotFound') pasta,                      
-- isnull(replace(replace(P.Numero_PO,' ',''),'/',''),'SalesOrderNotFound') pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao                      
-- from doc_anexos DA with(nolock)                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=DA.Id_DC and DMS_Code is not null                      
-- join vwPO P with(nolock) on da.Num_Proc = P.Num_proc and  P.ID_DC = 3                      
-- join vwClienteALLJOBS a on A.Num_Proc = DA.Num_Proc                      
--where                      
-- --and SUBSTRING(DA.Num_Proc,3,3) ='SOL'                       
-- --and  SUBSTRING(DA.Num_Proc,1,1) ='B'                      
-- DA.Num_Proc IN                      
-- (                      
--)                      
--order by 3                      
                      
--select                       
-- da.Num_Proc,                       
-- a.Dt_Criacao [JOB Register Date],                      
-- nome_arquivo,                      
-- da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                      
-- LEFT(UPPER(da.Num_Proc),2) pasta,                      
-- a.Dt_Criacao,                      
-- TC.Nome_DC [Document Type],                      
-- DMS_Code,                      
-- SUBSTRING(DA.Num_Proc,3,3) Modal,                      
-- (Case when substring(P.Apelido,1,8) = 'DOW AGRO' and  PG.Apelido = 'Grupo DOW'  then 'Grupo DOW AGRO' else PG.Apelido end) [Group],                      
-- P.Num_CPF_CNPJ [CNPJ],                      
-- replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),'SaleOrder_NotFound'),' ',''),'|','') [Sales Order],                      
-- replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),'PO_NotFound'),' ',''),'|','') [PO],                      
-- replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,8),'ShipmentNumber_NotFound'),' ',''),'|','') [Shipment Number],                      
-- replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,9),'CustomerPO_NotFound'),' ',''),'|','') [Customer PO],                      
-- P.Apelido [Customer Name]                      
-- from doc_anexos DA with(nolock)                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
-- join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc                      
-- join Pessoa P with(nolock) on P.cd_pes = A.cd_cliente                      
-- join Pessoa_LLP PL with(nolock) on A.cd_cliente = PL.Cd_Pes                      
-- join Pessoa PG with(nolock) on PL.Cd_Pes_Grupo = PG.Cd_Pes                      
-- join Grupo G with(nolock) on PG.Cd_Pes = G.Cd_Pes_Grupo                      
--where DA.Id_DC = '5' and  DA.Num_Proc in ('IMFMC201402010BR',                      
--'IMFMC201402011BR',                      
                      
                      
--)                      
                      
/*                      
select                       
 da.Num_Proc,                       
 a.Dt_Criacao [JOB Register Date],                      
 nome_arquivo,                      
 da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                      
 LEFT(UPPER(da.Num_Proc),2) pasta,                      
 a.Dt_Criacao,                      
 TC.Nome_DC [Document Type],                      
 DMS_Code,                      
 SUBSTRING(DA.Num_Proc,3,3) Modal,                      
 (Case when substring(P.Apelido,1,8) = 'DOW AGRO' and  PG.Apelido = 'Grupo DOW'  then 'Grupo DOW AGRO' else PG.Apelido end) [Group],                      
 P.Num_CPF_CNPJ [CNPJ],                      
 replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),'SaleOrder_NotFound'),' ',''),'|','') [Sales Order],                      
 replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),'PO_NotFound'),' ',''),'|','') [PO],                      
 replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,8),'ShipmentNumber_NotFound'),' ',''),'|','') [Shipment Number],                      
 replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,9),'CustomerPO_NotFound'),' ',''),'|','') [Customer PO],                      
 P.Apelido [Customer Name]                      
 from doc_anexos DA with(nolock)                      
 Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
 join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc                      
 join Pessoa P with(nolock) on P.cd_pes = A.cd_cliente                      
 join Pessoa_LLP PL with(nolock) on A.cd_cliente = PL.Cd_Pes                      
 join Pessoa PG with(nolock) on PL.Cd_Pes_Grupo = PG.Cd_Pes                      
 join Grupo G with(nolock) on PG.Cd_Pes = G.Cd_Pes_Grupo                      
where CONVERT(date,a.dt_criacao, 103) between '2018-01-01' and '2018-12-31'                       
 and PG.Apelido in ('GRUPO CERES')                      
 order by 1                      
option (hash join)                      
/*                      
select                      
 da.Num_Proc,                       
 nome_arquivo,                      
 da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
 LEFT(UPPER(da.Num_Proc),2) pasta,                      
 DMS_Code,                      
 a.Dt_Criacao,                      
 SUBSTRING(DA.Num_Proc,3,3),                      
 (Case when substring(P.Apelido,1,8) = 'DOW AGRO' then                       
  'Grupo DOW AGRO'                       
 else                       
  'Grupo Dow' end) Grupo                      
 from doc_anexos DA with(nolock)                      
 Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
 join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc                      
 join Pessoa P with(nolock) on P.cd_pes = A.cd_cliente                      
where                      
 CONVERT(date,a.dt_criacao, 103) between '2018-01-01' and '2018-12-31'                      
 and SUBSTRING(DA.Num_Proc,3,3) ='CSR'                       
 and substring(P.Apelido,1,8) = 'DOW AGRO'                      
 and P.Num_CPF_CNPJ in ('47180625002190', '47180625002009')                      
order by 1                       
                      
                      
/*                      
                      
select distinct da.Num_Proc,                       
 nome_arquivo,                      
 da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
 --isnull(replace(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),' ',''),'/',''),'SalesOrder_NotFound') pasta,                      
 isnull(replace(replace(po.Numero_PO,' ',''),'/',''),'SalesOrder_NotFound') pasta,                      
 DMS_Code                      
 --F.Data_PC,                      
 --SUBSTRING(DA.Num_Proc,3,3),                      
 --SUBSTRING(DA.Num_Proc,3,3) Grupo          
 from doc_anexos DA with(nolock)                      
 Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
 --join Fatura_CHB F on left(F.Fatura_PC,16) = DA.Num_Proc                      
 --join Pessoa P on P.cd_pes = A.cd_cliente                      
 join vwPO PO with(nolock) on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 3                      
where                      
 --F.Data_PC between '2018-07-01' and '2018-12-31'                      
 --and SUBSTRING(DA.Num_Proc,3,3) ='SOL'                       
 --and  SUBSTRING(DA.Num_Proc,1,1) ='B'                      
 da.Num_Proc in                      
  ('EAOXT201807005BR',                      
)                      
                
order by 1                      
                      
option(hash join)                      
*/                      
----por prestaão de contas                      
--select distinct da.Num_Proc,                       
-- nome_arquivo,                      
-- da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
-- (case when dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1) = '' or dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1) = '-' then DA.Num_Proc else                      
-- isnull(replace(replace(replace(replace(replace(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),' ',''),'/',''),',','_'),'(',''),')',''),'-','_'),'PO_NotFound')                      
-- end) pasta,                      
-- DMS_Code               
-- --F.Data_PC,                      
-- --SUBSTRING(DA.Num_Proc,3,3),                      
-- --SUBSTRING(DA.Num_Proc,3,3) Grupo                      
-- from doc_anexos DA with(nolock)                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
-- join Fatura_CHB F on left(F.Fatura_PC,16) = DA.Num_Proc                      
-- --join Pessoa P on P.cd_pes = A.cd_cliente                      
-- --join vwPO PO with(nolock) on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 3                      
--where                      
-- F.Data_PC between '2018-07-01' and '2018-12-31'                      
-- and SUBSTRING(DA.Num_Proc,3,3) ='OXT'                       
-- --and  SUBSTRING(DA.Num_Proc,1,1) ='I'                       
-- and SUBSTRING(DA.Num_Proc,1,1) ='B'                      
                       
--order by 1                      
                      
                      
                      
--select                      
-- da.Num_Proc,                       
-- nome_arquivo,                       
-- da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
-- isnull(replace(replace(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,2),' ',''),'-','_'),'/','_'),'InvoiceNotFound') pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao,                      
-- SUBSTRING(DA.Num_Proc,3,3)                      
-- from doc_anexos DA   with(nolock)                      
-- join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc                      
-- --join doc_anexos DA with(nolock) on da.Num_Proc = P.Num_proc                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=DA.Id_DC and DMS_Code is not null                      
-- where                       
--  DA.Num_Proc in                       
--  ('EASUN201802001BR',                      
--'EASUN201802003BR',                      
--'EOSUN201805002BR')                      
                       
                      
                   
--select                      
-- da.Num_Proc,                       
-- nome_arquivo,                      
-- replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,9),'CustomePONotFound'),' ',''),'|','') + '_' + da.Num_Proc +  '_' + replace(replace(TC.Nome_DC,' ',''),'/','')+ '_' + cast(YEAR(TP4.Dt_Conclusao) as varchar(4)) + '.pdf' NOME_DOC,           
  
     
     
         
         
            
-- --replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,9),'CustomePONotFound'),' ',''),'|','') + '_' + UPPER(DA.Num_Proc) pasta,                      
-- YEAR(TP4.Dt_Conclusao) pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao,                      
-- SUBSTRING(DA.Num_Proc,3,3)                      
-- from doc_anexos DA with(nolock)                      
-- join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc                      
-- --join Job_temp J with(nolock) on da.Num_Proc = J.Job                      
-- --join vwPO P with(nolock) on da.Num_Proc = P.Num_proc and  P.ID_DC = 9                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=DA.Id_DC and DMS_Code is not null                      
-- join Tarefas_Processos TP4 with(nolock) on DA.Num_Proc = TP4.Num_Proc and TP4.ID_Task = 4 and TP4.Dt_Conclusao is not null                      
-- where                       
-- SUBSTRING(DA.Num_Proc,3,3) in ('GVD')                      
-- --and SUBSTRING(DA.Num_Proc,1,1) in ('I')                       
-- and YEAR(TP4.Dt_Conclusao) between '2018' and '2018'                       
-- --and DA.Id_DC in('2','11','16','13','5','6','23','40','195','10','60','147','41','72','81','157')                       
-- --and da.num_proc = 'IAGVA201506006BR'                      
--option(hash join)                   
                      
                      
--select                      
-- da.Num_Proc,                       
-- nome_arquivo,                      
-- --da.Num_Proc + '_' + replace(replace(p.Numero_PO,' ',''),'_','') + '.pdf' NOME_DOC,                       
-- --replace(replace(p.Numero_PO,' ',''),'_','') + '.pdf' NOME_DOC,                       
-- replace(replace(p.Numero_PO,' ',''),'/','_') + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
-- '2018' pasta,                      
-- --isnull(replace(replace(p.Numero_PO,' ',''),'/','_'),'DI_NotFound') pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao,                      
-- p.Numero_PO                      
-- from doc_anexos DA with(nolock)                      
-- join vwPO P with(nolock) on da.Num_Proc = P.Num_proc and  P.ID_DC = 9                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
-- join vwClienteALLJOBS a on A.Num_Proc = DA.Num_Proc                      
--where                      
-- da.Id_DC = 5 and                      
-- (left(p.Numero_PO,10) in                       
--('4451748604',                      
--'4451775054')                      
--or                       
--(right(p.Numero_PO,10) in                         
--('4451748604',                      
--'4451775054')))                      
                      
                      
--select                      
-- da.Num_Proc,                       
-- nome_arquivo,                      
-- da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
-- isnull(replace(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),' ',''),'/',''),'SalesOrderNotFound') pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao                      
-- from doc_anexos DA with(nolock)                      
-- join vwPO P with(nolock) on da.Num_Proc = P.Num_proc and  P.ID_DC = 9                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
-- join vwClienteALLJOBS a on A.Num_Proc = DA.Num_Proc                     
--where                      
-- p.Numero_PO in                       
-- ()                       
-- order by 1                      
                      
 --select                      
-- da.Num_Proc,                       
-- nome_arquivo,                      
-- --replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),'CustomePONotFound'),' ',''),'|','') + '_' + da.Num_Proc +  '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
-- da.Num_Proc + '_' + TC.Nome_DC + '.pdf' NOME_DOC,                       
-- SUBSTRING(DA.Num_Proc,3,3) pasta,                      
-- --replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),'CustomePONotFound'),' ','') pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao,                      
-- SUBSTRING(DA.Num_Proc,3,3)                      
-- from doc_anexos DA with(nolock)                      
-- join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc                      
-- --join Job_temp J with(nolock) on da.Num_Proc = J.Job                      
-- --join vwPO P with(nolock) on da.Num_Proc = P.Num_proc and  P.ID_DC = 9                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=DA.Id_DC                       
-- --join Tarefas_Processos TP40 with(nolock) on DA.Num_Proc = TP40.Num_Proc and TP40.ID_Task = 40 and TP4.Dt_Conclusao is not null                  
-- where  DMS_Code is not null and CONVERT(date,a.dt_criacao, 103) between '2017-01-01' and '2017-12-31'and SUBSTRING(DA.Num_Proc,3,3) ='AMZ'                      
----and da.num_proc = 'IAGVA201506006BR'                      
--option(hash join)                      
                      
--select                      
-- da.Num_Proc,                       
-- nome_arquivo,                      
-- da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
-- replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),'PO'),' ',''),'/','')  pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao,                      
-- SUBSTRING(DA.Num_Proc,3,3),                      
-- SUBSTRING(DA.Num_Proc,3,3) Grupo,                      
-- cp143.Campo_Dados                      
-- from doc_anexos DA with(nolock)                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC-- and DMS_Code is not null                      
-- join vwClienteALLJOBS a on A.Num_Proc = DA.Num_Proc                      
-- --join Pessoa P on P.cd_pes = A.cd_cliente                      
-- join Campo_Processo cp143 with(nolock) on da.Num_Proc = cp143.Num_proc and  cp143.Id_Campo = 143                      
--where                      
-- da.Id_DC in (044,020,072,073)                      
-- and SUBSTRING(DA.Num_Proc,3,3) ='SOL'                       
-- and  SUBSTRING(DA.Num_Proc,1,1) ='I'                      
-- and cp143.Campo_Dados = '1'                      
                       
---- DA.Num_Proc in                      
---- ('EMOXT201502160BR',         
--)                       
--order by 1                      
                      
                      
--por prestaão de contas                      
--select distinct da.Num_Proc,                       
-- nome_arquivo,                      
-- da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
-- isnull(replace(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),' ',''),'/',''),'SalesOrderNotFound') pasta,                
-- DMS_Code                      
-- --F.Data_PC,                      
-- --SUBSTRING(DA.Num_Proc,3,3),                      
-- --SUBSTRING(DA.Num_Proc,3,3) Grupo                      
-- from doc_anexos DA with(nolock)                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
-- join Fatura_CHB F on left(F.Fatura_PC,16) = DA.Num_Proc                      
-- --join Pessoa P on P.cd_pes = A.cd_cliente                      
-- --join vwPO PO with(nolock) on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 3                      
--where                      
-- F.Data_PC between '2017-12-01' and '2018-06-30'                      
-- and SUBSTRING(DA.Num_Proc,3,3) ='OXT'     
-- and  SUBSTRING(DA.Num_Proc,1,1) ='I'                      
                       
--order by 1                       
                      
                      
                       
                    
                      
--select                      
-- da.Num_Proc,                       
-- nome_arquivo,                      
-- --replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),'SalesOrderNotFound'),' ',''),'|','') + '_' + da.Num_Proc +  '_' + replace(replace(TC.Nome_DC,' ',''),'/','')+ '_' + '.pdf' NOME_DOC,                       
-- da.Num_Proc +  '_' + replace(replace(TC.Nome_DC,' ',''),'/','')+'.pdf' NOME_DOC,                         
-- isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),'SalesOrderNotFound') pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao,                      
-- SUBSTRING(DA.Num_Proc,3,3)                      
-- from doc_anexos DA with(nolock)                      
-- join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=DA.Id_DC and DMS_Code is not null                      
--where                       
-- DA.Num_Proc  in  ('IMATN201712006BR',                      
--'IMATN201709001BR') and TC.ID_DC = '5'                      
                      
--/*                      
--select                      
-- da.Num_Proc,                       
-- nome_arquivo,                      
-- replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,9),'CustomePONotFound'),' ',''),'|','') + '_' + da.Num_Proc +  '_' + replace(replace(TC.Nome_DC,' ',''),'/','')+ '_' + cast(YEAR(TP4.Dt_Conclusao) as varchar(4)) + '.pdf' NOME_DOC,            
 
    
      
        
          
            
-- --replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,9),'CustomePONotFound'),' ',''),'|','') + '_' + UPPER(DA.Num_Proc) pasta,                      
-- YEAR(TP4.Dt_Conclusao)pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao,                      
-- SUBSTRING(DA.Num_Proc,3,3)                      
-- from doc_anexos DA with(nolock)                      
-- join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc                      
-- --join Job_temp J with(nolock) on da.Num_Proc = J.Job                      
-- --join vwPO P with(nolock) on da.Num_Proc = P.Num_proc and  P.ID_DC = 9                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=DA.Id_DC --and DMS_Code is not null                      
-- join Tarefas_Processos TP4 with(nolock) on DA.Num_Proc = TP4.Num_Proc and TP4.ID_Task = 4 and TP4.Dt_Conclusao is not null                      
-- where SUBSTRING(DA.Num_Proc,3,3) in ('GVA') and SUBSTRING(DA.Num_Proc,1,1) in ('I') and YEAR(TP4.Dt_Conclusao) between '2014' and '2017' and                      
-- DA.Id_DC in('2','11','16','13','5','6','23','40','195','10','60','147','41','72','81','157') --and da.num_proc = 'IAGVA201506006BR'                      
--option(hash join)                      
--*/          
--select                      
-- da.Num_Proc,                       
-- nome_arquivo,                      
-- --replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),'CustomePONotFound'),' ',''),'|','') + '_' + da.Num_Proc +  '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
-- da.Num_Proc + '_' + TC.Nome_DC + '.pdf' NOME_DOC,                       
-- SUBSTRING(DA.Num_Proc,3,3) pasta,                      
-- --replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),'CustomePONotFound'),' ','') pasta,                      
-- DMS_Code,                      
-- a.Dt_Criacao,                      
-- SUBSTRING(DA.Num_Proc,3,3)                      
-- from doc_anexos DA with(nolock)                      
-- join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc                      
-- --join Job_temp J with(nolock) on da.Num_Proc = J.Job                     
-- --join vwPO P with(nolock) on da.Num_Proc = P.Num_proc and  P.ID_DC = 9                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=DA.Id_DC            
-- --join Tarefas_Processos TP40 with(nolock) on DA.Num_Proc = TP40.Num_Proc and TP40.ID_Task = 40 and TP4.Dt_Conclusao is not null                      
-- where  DMS_Code is not null and CONVERT(date,a.dt_criacao, 103) between '2017-01-01' and '2017-12-31'and SUBSTRING(DA.Num_Proc,3,3) ='AMZ'                      
----and da.num_proc = 'IAGVA201506006BR'                      
--option(hash join)                      
                  
--select * from Grupo                      
--where Cd_Pes_Grupo = 'P000027066'                      
                      
---- CONVERT(date,a.dt_criacao, 103) between '2017-01-01' and '2017-12-31'                      
---- and SUBSTRING(DA.Num_Proc,3,3) ='TAM'                        
                      
----select * from Tipo_Tarefas                      
                      
----select * from  Tipo_Doc_Cliente                      
                      
----select                      
---- da.Num_Proc,                       
---- nome_arquivo,                      
---- da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
---- LEFT(UPPER(da.Num_Proc),2) pasta,                      
---- DMS_Code,                      
---- a.Dt_Criacao,                      
---- SUBSTRING(DA.Num_Proc,3,3),                      
---- (Case when substring(P.Apelido,1,8) = 'DOW AGRO' then                       
----  'Grupo DOW AGRO'                       
---- else                       
----  'Grupo Dow' end) Grupo                      
---- from doc_anexos DA with(nolock)                      
---- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null                      
---- join vwClienteALLJOBS a on A.Num_Proc = DA.Num_Proc                      
---- join Pessoa P on P.cd_pes = A.cd_cliente              
----where                      
---- CONVERT(date,a.dt_criacao, 103) between '2017-01-01' and '2017-12-31'                      
---- and SUBSTRING(DA.Num_Proc,3,3) ='CSR'                       
---- and substring(P.Apelido,1,8) = 'DOW AGRO'                      
----order by 1                       
                      
----100-115860 - 002-Invoice,--011- Packing list,--010-Nota fiscal,--004-RE,--012-DDE                      
                      
----select                       
---- nome_arquivo,                      
---- da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','') + '.pdf' NOME_DOC,                       
---- LEFT(UPPER(da.Num_Proc),2) pasta,                      
---- 'Rebeca' pasta                      
---- from Temp_Ajust DA with(nolock)                      
---- Join dbo.doc_anexos T with(nolock) on T.num_proc=DA.num_proc and T.Id_DC in (2,11,10,4,12)                      
---- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=T.Id_DC                      
----order by 1                       
                      
                      
----select                       
---- nome_arquivo,                      
---- da.Num_Proc + '_' + TC.Nome_DC + '.pdf' NOME_DOC,                       
---- --LEFT(UPPER(da.Num_Proc),2) pasta                      
---- 'keity' pasta                      
---- from Temp_Ajust DA with(nolock)                      
---- Join dbo.doc_anexos T with(nolock) on T.num_proc=DA.num_proc and T.Id_DC in (2,5,20)                      
---- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=T.Id_DC                      
----order by 1                       
                       
----select                       
---- nome_arquivo,                       
---- --da.Num_Proc + '_' + TC.Nome_DC + '.pdf' NOME_DOC,                       
---- --substring(da.num_proc,3,3)                       
---- --+ '\' + left(da.Num_Proc,1)                       
---- --+ '\' +                        
---- --replace(dbo.fBusca_TipoDocCliente('N',DA.num_proc,3),' ','')  Pasta                      
---- --isnull(replace(replace(replace(replace(replace(replace(replace(isnull(HEA.Numero_PO_HEA,isnull(HEM.Numero_PO_HEM,isnull(HEO.Numero_PO_HEO,isnull(HIM.Numero_PO_HIM,isnull(HIA.Numero_PO_HIA,HIO.Numero_PO_HIO))))),' ',''),'.','_'),'/','_'),'''',''),' 
 
    
      
         
      
             
             
              
              
(                
                  
                    
',''),')',''),',',''),DA.num_proc)  Pasta                       
---- 'EA' pasta                      
----from doc_anexos DA with(nolock)                      
----  Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=DA.id_dc                      
----  Join dbo.Temp_Ajust T  with(nolock) on T.num_proc=DA.num_proc                      
----  join PO_HEA  HEA with(nolock) on HEA.num_proc_hea = DA.num_proc  and HEA.ID_DC =4                      
----  --left join PO_HEM  HEM with(nolock) on HEM.num_proc_hem = DA.num_proc  and HEM.ID_DC =4                      
----  --left join PO_HEO  HEO with(nolock) on HEO.num_proc_heo = DA.num_proc  and HEO.ID_DC =4                      
----  --left join PO_HIM  HIM with(nolock) on HIM.num_proc_him = DA.num_proc  and HIM.ID_DC =5                      
----  --left join PO_HIA  HIA with(nolock) on HIA.num_proc_hia = DA.num_proc  and HIA.ID_DC =5                      
----  --left join PO_HIO  HIO with(nolock) on HIO.num_proc_hio = DA.num_proc  and HIO.ID_DC =5                      
----where                       
---- TC.ID_DC in ('4')                      
                      
                      
----and DA.Num_Proc = 'EMOXT201301179BR'                      
----where TC.ID_DC in ('12','4','10','2','20')                      
----select * from Tipo_Doc_Cliente where ID_DC = 12                      
----where Nome_DC like '%Laudo%'                      
----delete Temp_Ajust                      
                      
----select distinct * from Temp_Ajust                      
----where Num_Proc = 'EOCSR201512046BR'                      
                      
----*/                      
                  
----256 + 16                      
                      
----149 - encontrados                      
----107 -nao encontrados                                
----ALTER procedure [dbo].[spPDFKHDA_NEW]                      
                      
----AS                      
                      
----select                      
---- DOC.nome_arquivo,                       
---- nome_arquivo NOME_DOC,                      
---- replace(replace(DI.Numero_PO_HIM,'-',''),'/','') + '_' + replace(replace(SLI.Num_LI,'-',''),'/','') + '.pdf' NOME_DOC,                      
---- replace(replace(DI.Numero_PO_HIM,'-',''),'/','') + '_' + replace(replace(SLI.Num_LI,'-',''),'/','') + '.pdf' NOME_DOC,                        
---- '\Keity\' Pasta                      
----from                        
---- Solicitacao_LI SLI with(nolock)                      
---- Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23                       
---- join PO_HIM DI on DI.Num_Proc_HIM = SLI.Num_Proc and DI.ID_DC = 5                      
---- join PO_HIM DI on DI.Num_Proc_HIM = DA.Num_Proc and DI.ID_DC = 5                      
----where                      
----SLI.Num_Proc  in                       
----('IMFMC201201062BR',                      
----'IMFMC201208031BR',                      
                      
----'IAFMC201204002BR')                      
------and Nome_Arquivo is not null                      
                      
*/                  
              
        

GO

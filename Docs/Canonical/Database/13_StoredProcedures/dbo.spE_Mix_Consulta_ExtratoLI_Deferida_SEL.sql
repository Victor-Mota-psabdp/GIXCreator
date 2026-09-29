SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spE_Mix_Consulta_ExtratoLI_Deferida_SEL] --33
       
AS     
    
declare @dias as int    
set @dias = 30   
    
--Doc Anexado > Dt_Deferimento    
 select distinct    
  '102'        [id_cliente],    
  '139'        [id_integracao],    
  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
  '1'         [id_servico],    
  ID_Empresa.Campo_Dados    [id_empresa] ,    
  ID_CNPJ.Campo_Dados     [id_cnpj],    
  '12'        [id_consulta_tipo] ,    
  '12'        [id_parametro_grupo],    
  '12'        [id_parametro_tipo],    
  replace(SLI.Num_LI,' ','')        [valor],    
  SLI.Num_Proc        [num_proc],    
  SLI.Dt_LI,    
  DOC.Anexado_Em,Dt_Deferimento    
 from     
  Solicitacao_LI SLI    
  join House_Imp_Mar  HOU with(nolock) on HOU.Num_Proc_HIM =SLI.Num_Proc     
  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'      
  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'      
  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Deferimento     
 where      
  SLI.ID_Status not in (9,11,12)    
  and SLI.Dt_Deferimento  between GETDATE()- @dias and  GETDATE() + 1     
  --and SLI.Dt_Aut_Embarque is null    
  and ID_Empresa.Cd_Pes is not null    
  and ID_CNPJ.Cd_Pes is not null    
  and E_mix.num_proc is not null      
  and Doc.Anexado_Em is null      
  and SLI.Num_LI is not null    
  and SLI.Num_LI like '%-%'    
  and SLI.num_proc not in     
(select distinct C.num_proc from E_MIX_XML E with(nolock)    
Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
Where   
(  
(Dt_retorno is null and Dt_Envio is not null)  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta foi criada%')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta não constou registros!')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')  
)  
  
  
and C.num_proc not in ('IMCSR201509531BR')    
and C.id_consulta_tipo in (12))    
    
        
Union All    
    
 select distinct    
  '102'        [id_cliente],    
  '139'        [id_integracao],    
  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
    
  '1'         [id_servico],    
  ID_Empresa.Campo_Dados    [id_empresa] ,    
  ID_CNPJ.Campo_Dados     [id_cnpj],    
  '12'        [id_consulta_tipo] ,    
  '12'        [id_parametro_grupo],    
  '12'        [id_parametro_tipo],    
  replace(SLI.Num_LI,' ','')      [valor],    
  SLI.Num_Proc        [num_proc],    
  SLI.Dt_LI ,    
  DOC.Anexado_Em,Dt_Deferimento    
 from     
     
  Solicitacao_LI SLI    
  join House_Imp_Aer  HOU with(nolock) on HOU.Num_Proc_HIA =SLI.Num_Proc     
  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'    
  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'      
  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Deferimento      
 where      
  SLI.ID_Status not in (9,11,12)    
  and SLI.Dt_Deferimento  between GETDATE()- @dias and  GETDATE() + 1    
  --and SLI.Dt_Aut_Embarque is null    
  and ID_Empresa.Cd_Pes is not null    
  and ID_CNPJ.Cd_Pes is not null    
  and E_mix.num_proc is not null        
  and Doc.Anexado_Em is null      
  and SLI.Num_LI is not null    
  and SLI.Num_LI like '%-%'    
and SLI.num_proc not in     
(select distinct C.num_proc from E_MIX_XML E with(nolock)    
Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
Where   
(  
(Dt_retorno is null and Dt_Envio is not null)  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta foi criada%')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta não constou registros!')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')  
)  
  
  
and C.num_proc not in ('IMCSR201509531BR')    
and C.id_consulta_tipo in (12))    
    
    
    
UNION ALL    
    
 Select distinct    
  '102'        [id_cliente],    
  '139'        [id_integracao],    
  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
    
  '1'         [id_servico],    
  ID_Empresa.Campo_Dados    [id_empresa] ,    
  ID_CNPJ.Campo_Dados     [id_cnpj],    
  '12'         [id_consulta_tipo] ,    
  '12'        [id_parametro_grupo],    
  '12'        [id_parametro_tipo],    
  replace(SLI.Num_LI,' ','')      [valor],    
  SLI.Num_Proc       [num_proc],    
  SLI.Dt_LI ,    
  DOC.Anexado_Em,Dt_Deferimento    
 from     
     
  Solicitacao_LI SLI    
  join House_Imp_Out  HOU with(nolock) on HOU.Num_Proc_HIo =SLI.Num_Proc     
  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'    
  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'      
  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Deferimento     
 where      
  SLI.ID_Status not in (9,11,12)    
  and SLI.Dt_Deferimento  between GETDATE()- @dias and GETDATE() + 1    
  --and SLI.Dt_Aut_Embarque is null    
  and ID_Empresa.Cd_Pes is not null    
  and ID_CNPJ.Cd_Pes is not null    
  and E_mix.num_proc is not null          
  and Doc.Anexado_Em is null      
  and SLI.Num_LI is not null    
  and SLI.Num_LI like '%-%'    
  and SLI.num_proc not in     
(select distinct C.num_proc from E_MIX_XML E with(nolock)    
Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
Where   
(  
(Dt_retorno is null and Dt_Envio is not null)  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta foi criada%')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta não constou registros!')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')  
)  
  
and C.num_proc not in ('IMCSR201509531BR')    
and C.id_consulta_tipo in (12))    
    
     
Union All    
     
--Doc Anexado > Dt_Aut_Embarque    
 select distinct    
  '102'        [id_cliente],    
  '139'        [id_integracao],    
  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
    
  '1'         [id_servico],    
  ID_Empresa.Campo_Dados    [id_empresa] ,    
  ID_CNPJ.Campo_Dados     [id_cnpj],    
  '12'         [id_consulta_tipo] ,    
  '12'        [id_parametro_grupo],    
  '12'        [id_parametro_tipo],    
  replace(SLI.Num_LI,' ','')      [valor],    
  SLI.Num_Proc       [num_proc],    
  SLI.Dt_LI ,    
  DOC.Anexado_Em,Dt_Aut_Embarque    
 from     
     
  Solicitacao_LI SLI    
  join House_Imp_Mar  HOU with(nolock) on HOU.Num_Proc_HIM =SLI.Num_Proc     
  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'    
  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'      
  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Aut_Embarque     
 where      
  SLI.ID_Status not in (11,12)    
  --and SLI.Dt_Deferimento  is null    
  and SLI.Dt_Aut_Embarque  between GETDATE()- @dias and  GETDATE() + 1      
  and ID_Empresa.Cd_Pes is not null    
  and ID_CNPJ.Cd_Pes is not null    
  and E_mix.num_proc is not null         
  and Doc.Anexado_Em is null      
  and SLI.Num_LI is not null    
  and SLI.Num_LI like '%-%'    
  and SLI.num_proc not in     
(select distinct C.num_proc from E_MIX_XML E with(nolock)    
Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
Where   
(  
(Dt_retorno is null and Dt_Envio is not null)  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta foi criada%')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta não constou registros!')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')  
)  
  
and C.num_proc not in ('IMCSR201509531BR')    
and C.id_consulta_tipo in (12))    
    
      
    
Union All    
    
 select distinct    
  '102'        [id_cliente],    
  '139'        [id_integracao],    
  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
    
  '1'         [id_servico],    
  ID_Empresa.Campo_Dados    [id_empresa] ,    
  ID_CNPJ.Campo_Dados     [id_cnpj],    
  '12'         [id_consulta_tipo] ,    
  '12'        [id_parametro_grupo],    
  '12'        [id_parametro_tipo],    
  replace(SLI.Num_LI,' ','')       [valor],    
  SLI.Num_Proc       [num_proc],    
  SLI.Dt_LI ,    
  DOC.Anexado_Em,Dt_Aut_Embarque    
 from     
     
  Solicitacao_LI SLI    
  join House_Imp_Aer  HOU with(nolock) on HOU.Num_Proc_HIA =SLI.Num_Proc     
  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'    
  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'    
  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Aut_Embarque      
 where      
  SLI.ID_Status not in (11,12)    
  and SLI.Dt_Aut_Embarque  between GETDATE()- @dias and  GETDATE() + 1    
  --and SLI.Dt_Deferimento  is null      
  and ID_Empresa.Cd_Pes is not null    
  and ID_CNPJ.Cd_Pes is not null    
  and E_mix.num_proc is not null         
  and Doc.Anexado_Em is null      
  and SLI.Num_LI is not null    
  and SLI.Num_LI like '%-%'    
  and SLI.num_proc not in     
(select distinct C.num_proc from E_MIX_XML E with(nolock)    
Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
Where   
(  
(Dt_retorno is null and Dt_Envio is not null)  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta foi criada%')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta não constou registros!')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')  
)  
  
and C.num_proc not in ('IMCSR201509531BR')    
and C.id_consulta_tipo in (12))    
    
      
      
    
UNION ALL    
    
 Select distinct    
  '102'        [id_cliente],    
  '139'        [id_integracao],    
  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
    
  '1'         [id_servico],    
  ID_Empresa.Campo_Dados    [id_empresa] ,    
  ID_CNPJ.Campo_Dados     [id_cnpj],    
  '12'        [id_consulta_tipo] ,    
  '12'        [id_parametro_grupo],    
  '12'        [id_parametro_tipo],    
  replace(SLI.Num_LI,' ','')       [valor],    
  SLI.Num_Proc        [num_proc],    
  SLI.Dt_LI ,    
  DOC.Anexado_Em,Dt_Aut_Embarque    
 from     
     
  Solicitacao_LI SLI      join House_Imp_Out  HOU with(nolock) on HOU.Num_Proc_HIo =SLI.Num_Proc     
  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'    
  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI and E_mix.id_consulta_tipo = '12'      
  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Aut_Embarque     
 where      
  SLI.ID_Status not in (11,12)    
  and SLI.Dt_Aut_Embarque  between GETDATE()- @dias and  GETDATE() + 1    
  --and SLI.Dt_Deferimento  is null    
  and ID_Empresa.Cd_Pes is not null    
  and ID_CNPJ.Cd_Pes is not null    
  and E_mix.num_proc is not null          
  and Doc.Anexado_Em is null      
  and SLI.Num_LI is not null    
  and SLI.Num_LI like '%-%'    
  and SLI.num_proc not in     
(select distinct C.num_proc from E_MIX_XML E with(nolock)    
Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
Where   
(  
(Dt_retorno is null and Dt_Envio is not null)  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta foi criada%')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Sua consulta não constou registros!')  
or   
(Dt_retorno is not null and Dt_Envio > '2019-06-01' and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')  
)  
  
and C.num_proc not in ('IMCSR201509531BR')    
and C.id_consulta_tipo in (12))    
    
--OPTION(HASH JOIN)      
    
    
--declare @dias as int    
--set @dias = 10    
    
----li´s sem documentos    
-- select distinct    
--  '102'        [id_cliente],    
--  '139'        [id_integracao],    
--  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
--  '1'         [id_servico],    
--  ID_Empresa.Campo_Dados    [id_empresa] ,    
--  ID_CNPJ.Campo_Dados     [id_cnpj],    
--  '12'        [id_consulta_tipo] ,    
--  '12'        [id_parametro_grupo],    
--  '12'        [id_parametro_tipo],    
--  SLI.Num_LI        [valor],    
--  SLI.Num_Proc        [num_proc],    
--  SLI.Dt_LI,    
--  DOC.Anexado_Em,Dt_Deferimento    
-- from     
--  Solicitacao_LI SLI    
--  join House_Imp_Mar  HOU with(nolock) on HOU.Num_Proc_HIM =SLI.Num_Proc     
--  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
--  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
--  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'      
--  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'      
--  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Deferimento     
-- --select * from Solicitacao_LI L    
-- -- left Join Doc_Anexos D on D.Num_Proc = l.Num_Solicitacao    
-- where    
--  SLI.ID_Status < 9  and    
--  SLI.Dt_Solicitacao between GETDATE()- @dias and  GETDATE() + 1    
--  --and L.Dt_Deferimento is not null    
--  --and L.Dt_Deferimento > '2016-01-01'    
--  --and D.Id_DC =23    
--  and DOC.Num_Proc is null    
--  and SLI.Num_LI  is not null    
--  and SLI.num_proc not in     
-- (select distinct C.num_proc from E_MIX_XML E with(nolock)    
-- Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
-- Where     
-- Dt_retorno is null and Dt_Envio is not null    
-- and C.num_proc not in ('IMCSR201509531BR')    
-- and C.id_consulta_tipo in (12))    
    
--UNION ALL    
    
-- select distinct    
--  '102'        [id_cliente],    
--  '139'        [id_integracao],    
--  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
    
--  '1'         [id_servico],    
--  ID_Empresa.Campo_Dados    [id_empresa] ,    
--  ID_CNPJ.Campo_Dados     [id_cnpj],    
--  '12'        [id_consulta_tipo] ,    
--  '12'        [id_parametro_grupo],    
--  '12'        [id_parametro_tipo],    
--  SLI.Num_LI        [valor],    
--  SLI.Num_Proc        [num_proc],    
--  SLI.Dt_LI ,    
--  DOC.Anexado_Em,Dt_Deferimento    
-- from      
--  Solicitacao_LI SLI    
--  join House_Imp_Aer  HOU with(nolock) on HOU.Num_Proc_HIA =SLI.Num_Proc     
--  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
--  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
--  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'    
--  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'      
--  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Deferimento      
-- where      
--  SLI.ID_Status < 9  and    
--  SLI.Dt_Solicitacao between GETDATE()- @dias and  GETDATE() + 1    
--  --and L.Dt_Deferimento is not null    
--  --and L.Dt_Deferimento > '2016-01-01'    
--  --and D.Id_DC =23    
--  and DOC.Num_Proc is null    
--  and SLI.Num_LI  is not null    
--  and SLI.num_proc not in     
-- (select distinct C.num_proc from E_MIX_XML E with(nolock)    
-- Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
-- Where     
-- Dt_retorno is null and Dt_Envio is not null    
-- and C.num_proc not in ('IMCSR201509531BR')    
-- and C.id_consulta_tipo in (12))    
    
    
    
--UNION ALL    
    
-- Select distinct    
--  '102'        [id_cliente],    
--  '139'        [id_integracao],    
--  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
    
--  '1'         [id_servico],    
--  ID_Empresa.Campo_Dados    [id_empresa] ,    
--  ID_CNPJ.Campo_Dados     [id_cnpj],    
--  '12'         [id_consulta_tipo] ,    
--  '12'        [id_parametro_grupo],    
--  '12'        [id_parametro_tipo],    
--  SLI.Num_LI       [valor],    
--  SLI.Num_Proc       [num_proc],    
--  SLI.Dt_LI ,    
--  DOC.Anexado_Em,Dt_Deferimento    
-- from     
     
--  Solicitacao_LI SLI    
--  join House_Imp_Out  HOU with(nolock) on HOU.Num_Proc_HIo =SLI.Num_Proc     
--  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
--  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
--  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'    
--  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'      
--  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Deferimento     
-- where    --  SLI.ID_Status < 9  and    
-- SLI.Dt_Solicitacao between GETDATE()- @dias and  GETDATE() + 1    
-- --and L.Dt_Deferimento is not null    
-- --and L.Dt_Deferimento > '2016-01-01'    
-- --and D.Id_DC =23    
-- and DOC.Num_Proc is null    
-- and SLI.Num_LI  is not null    
-- and SLI.num_proc not in     
-- (select distinct C.num_proc from E_MIX_XML E with(nolock)    
--  Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
--  Where     
--  Dt_retorno is null and Dt_Envio is not null    
--  and C.num_proc not in ('IMCSR201509531BR')    
--  and C.id_consulta_tipo in (12))    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
--declare @dias as int    
--set @dias = 90    
    
-------Sem emix criado, pq foi utilizado o li backup    
-- select distinct    
--  '102'        [id_cliente],    
--  '139'        [id_integracao],    
--  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
    
--  '1'         [id_servico],    
--  ID_Empresa.Campo_Dados    [id_empresa] ,    
--  ID_CNPJ.Campo_Dados     [id_cnpj],    
--  '12'         [id_consulta_tipo] ,    
--  '12'        [id_parametro_grupo],    
--  '12'        [id_parametro_tipo],    
--  SLI.Num_LI       [valor],    
--  SLI.Num_Proc       [num_proc],    
--  SLI.Dt_LI ,    
--  DOC.Anexado_Em,Dt_Aut_Embarque    
-- from     
     
--  Solicitacao_LI SLI    
--  join House_Imp_Mar  HOU with(nolock) on HOU.Num_Proc_HIM =SLI.Num_Proc     
--  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
--  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
--  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'    
--  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'      
--  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Aut_Embarque     
-- where     
--  SLI.ID_Status not in (11,12)    
--  --and SLI.Dt_Deferimento  is null    
--  and SLI.Dt_Aut_Embarque  between GETDATE()- @dias and  GETDATE() + 1      
--  and ID_Empresa.Cd_Pes is not null    
--  and ID_CNPJ.Cd_Pes is not null    
--  --and E_mix.num_proc is not null         
--  and Doc.Anexado_Em is null      
--  and SLI.Num_LI is not null    
--  and SLI.Num_LI like '%-%'    
--  and SLI.num_proc not in     
--(select distinct C.num_proc from E_MIX_XML E with(nolock)    
--Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
--Where     
--Dt_retorno is null and Dt_Envio is not null    
--and C.num_proc not in ('IMCSR201509531BR')    
--and C.id_consulta_tipo in (12))    
    
      
    
--Union All    
    
-- select distinct    
--  '102'        [id_cliente],    
--  '139'        [id_integracao],    
--  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
    
--  '1'         [id_servico],    
--  ID_Empresa.Campo_Dados    [id_empresa] ,    
--  ID_CNPJ.Campo_Dados     [id_cnpj],    
--  '12'         [id_consulta_tipo] ,    
--  '12'        [id_parametro_grupo],    
--  '12'        [id_parametro_tipo],    
--  SLI.Num_LI       [valor],    
--  SLI.Num_Proc       [num_proc],    
--  SLI.Dt_LI ,    
--  DOC.Anexado_Em,Dt_Aut_Embarque    
-- from     
     
--  Solicitacao_LI SLI    
--  join House_Imp_Aer  HOU with(nolock) on HOU.Num_Proc_HIA =SLI.Num_Proc     
--  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
--  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
--  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'    
--  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'    
--  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Aut_Embarque      
-- where      
--  SLI.ID_Status not in (11,12)    
--  and SLI.Dt_Aut_Embarque  between GETDATE()- @dias and  GETDATE() + 1    
--  --and SLI.Dt_Deferimento  is null      
--  and ID_Empresa.Cd_Pes is not null    
--  and ID_CNPJ.Cd_Pes is not null    
--  --and E_mix.num_proc is not null         
--  and Doc.Anexado_Em is null      
--  and SLI.Num_LI is not null    
--  and SLI.Num_LI like '%-%'    
--  and SLI.num_proc not in     
--(select distinct C.num_proc from E_MIX_XML E with(nolock)    
--Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
--Where     
--Dt_retorno is null and Dt_Envio is not null    
--and C.num_proc not in ('IMCSR201509531BR')    
--and C.id_consulta_tipo in (12))    
    
      
      
    
--UNION ALL    
    
-- Select distinct    
--  '102'        [id_cliente],    
--  '139'        [id_integracao],    
--  'b71b7b989a9dcb68026483c1c5ffe47d' [contra_senha],    
    
--  '1'         [id_servico],    
--  ID_Empresa.Campo_Dados    [id_empresa] ,    
--  ID_CNPJ.Campo_Dados     [id_cnpj],    
--  '12'        [id_consulta_tipo] ,    
--  '12'        [id_parametro_grupo],    
--  '12'        [id_parametro_tipo],    
--  SLI.Num_LI        [valor],    
--  SLI.Num_Proc        [num_proc],    
--  SLI.Dt_LI ,    
--  DOC.Anexado_Em,Dt_Aut_Embarque    
-- from     
     
--  Solicitacao_LI SLI    
--  join House_Imp_Out  HOU with(nolock) on HOU.Num_Proc_HIo =SLI.Num_Proc     
--  left join Campo_Pessoa ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12    
--  left join Campo_Pessoa ID_CNPJ with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13    
--  --left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'    
--  left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI and E_mix.id_consulta_tipo = '12'      
--  Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Aut_Embarque     
-- where      
--  SLI.ID_Status not in (11,12)    
--  and SLI.Dt_Aut_Embarque  between GETDATE()- @dias and  GETDATE() + 1    
--  --and SLI.Dt_Deferimento  is null    
--  and ID_Empresa.Cd_Pes is not null    
--  and ID_CNPJ.Cd_Pes is not null    
--  --and E_mix.num_proc is not null          
--  and Doc.Anexado_Em is null      
--  and SLI.Num_LI is not null    
--  and SLI.Num_LI like '%-%'    
--  and SLI.num_proc not in     
--(select distinct C.num_proc from E_MIX_XML E with(nolock)    
--Join E_Mix_Consulta C with(nolock) on C.id=E.ID     
--Where     
--Dt_retorno is null and Dt_Envio is not null    
--and C.num_proc not in ('IMCSR201509531BR')    
--and C.id_consulta_tipo in (12))
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--cadu  9/3/15 - incluido ver só o q esta como status = 1    
--Isnull(Site_AX,'BRSAO') Dimensao_4,    
--incluido o bo - 02-04-2018  
--incluido varchar no   Cadu 02/02/2022
--left join ax_doc AXD with(nolock) on AXD.Numero_Documento=convert(varchar(200),SP.ID), pq estamos usando o numero do documento p enviar a invoice
--cadu 28/11/2023 - incluida a taxa: XIN	Devol. Adto. (Fornecedores) - CHB 3, no select
CREATE  Procedure [dbo].[spAX_Debitos2AXDOCSOL_SEL]    
    
as    
    
--Erbson 16-05-2013: Não Buscar caso não tenha paridade lançada no dia.    
/*    
if not exists(select Par_Moeda from Paridade where Cd_Tp_Moeda ='USD' and Cd_Tp_Par = 'OFC' and convert(datetime,Dt_Par,103) =convert(varchar,getdate(),111))    
Begin    
 RETURN -2    
End    
*/    
Select     
  distinct      
 '10001' Dimensao_1,    
  '' Dimensao_3,    
  --'BRSAO' Dimensao_4,    
 Isnull(Site_AX,'BRSAO') Dimensao_4,    
 --(    
    
 --Case LEFT(SI.num_proc,2)     
 -- when 'IM' then 221    
 -- when 'IA' then 122     
 -- when 'EA' then 112    
 -- when 'EM' then 216    
 -- when 'EO' then 411    
 -- when 'IO' then 421    
 -- when 'BO' then     
 -- (case LEFT(J.Num_Proc,2)     
 --  when 'IM' then 221    
 --  when 'IA' then 122     
 --  when 'EA' then 112    
 --  when 'EM' then 216    
 --  when 'EO' then 411    
 --  when 'IO' then 421    
 --  else 800    
 -- End)    
 --End    
 --) Dimensao_2,    
 null Dimensao_2,    
 '' Dimensao_5,    
     
 'BR1' Dimensao_6,    
 Dimensao7 Dimensao_7,    
 2 Tipo,    
 NULL NumeroInternoAX,    
 cd_AX Cd_PessoA_AX,    
 'Vend' AccountType,    
 1 Aprovado,    
 Null Aprovado_Por,    
 getdate() Dt_Aprovacao,    
 'BR1' Company,    
 (convert(Datetime,Dt_Aprovacao,105)) Dt_Documento,    
 SP.ID Numero_Documento,    
 max(convert(datetime,SP.Dt_Vcto,105)) Dt_Vencimento,    
 SP.ID Invoice_Number,    
 AV.TaxGroup TaxGroup,    
    
 null TaxItemGroup,    
 (convert(Datetime,Dt_Aprovacao,105))   Dt_Ins,    
 Null Dt_Envio_AX,    
 ''Obs_AX,    
 1 Ativo,    
 Getdate() Data_Aprovacao    
From dbo.Sol_Pgto_Cta_Cte SP with(nolock)    
  join Sol_Pgto_Cta_Cte_Item SI with(nolock) on SI.ID = SP.ID and Status_Aprovacao = 'A'    
  Join Pessoa PP with (nolock) on PP.Cd_Pes=SP.Cd_Cred_Dev    
  Left Join Pessoa_LLP P with (nolock) on P.Cd_Pes=PP.Cd_Pes    
  Left Join Pessoa_ATL_AX AX with (nolock) on (AX.Cd_Pes = PP.Cd_Pes) and Tipo='F'    
  Left Join vwcliente C with (nolock) on C.num_proc=SI.Num_Proc    
  left  Join dbo.AX_XML_Vendor_Recebido AV with (nolock) on accountnum=cd_ax    
  left join ax_doc AXD with(nolock) on AXD.Numero_Documento=convert(varchar(200),SP.ID)
      
  left join Site S with(nolock) on SP.Ref_Acesso = S.Cd_Site    
      
    
  left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO = SI.Num_Proc    
  left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO     
 Where     
  (SI.DC='D' or SI.DC='C' and SI.Cd_Tp_Tx in ('XY0','XY1','D2D','XIN'))and    
  (    
   (month(convert(Datetime,Dt_Aprovacao,105))=month(getdate()-30)    
   and year(convert(Datetime,Dt_Aprovacao,105))=year(getdate()-30))    
  or    
   (month(convert(Datetime,Dt_Aprovacao,105))=month(getdate())    
   and year(convert(Datetime,Dt_Aprovacao,105))=year(getdate()))    
  ) and    
  (C.cd_cliente <> SP.Cd_Cred_Dev or C.cd_cliente is null)    
  and AV.AccountNum is not null    
  and AXD.ID_AX is null    
  and SP.Status = 1    
      
  and    
  (    
   J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1    
   or    
   J.Num_Proc is not null and LBO.Id_TP_Servico = 1      
  )      


  --cadu 22/09/2023- 14:34h - Nao criar se nao tiver vendor
  and AV.TaxGroup is not null

--group by SP.ID,SI.DC,SI.cd_Tp_Tx ,Apelido,AV.TaxGroup,pp.cd_pes,SI.Num_Proc,AX.cd_ax,    
--(convert(datetime,Dt_Aprovacao,105)),dimensao7,num_cpf_cnpj,LEFT(J.Num_Proc,2)    
    
group by SP.ID,SI.DC,SI.cd_Tp_Tx ,Apelido,AV.TaxGroup,pp.cd_pes,SI.Num_Proc,AX.cd_ax,    
(convert(datetime,Dt_Aprovacao,105)),dimensao7,num_cpf_cnpj,Site_AX,LEFT(J.Num_Proc,2)    
    
	/*
  UNION  
  
  
  Select     
  distinct      
 '10001' Dimensao_1,    
  '' Dimensao_3,    
  --'BRSAO' Dimensao_4,    
 Isnull(Site_AX,'BRSAO') Dimensao_4,    
 --(    
    
 --Case LEFT(SI.num_proc,2)     
 -- when 'IM' then 221    
 -- when 'IA' then 122     
 -- when 'EA' then 112    
 -- when 'EM' then 216    
 -- when 'EO' then 411    
 -- when 'IO' then 421    
 -- when 'BO' then     
 -- (case LEFT(J.Num_Proc,2)     
 --  when 'IM' then 221   
 --  when 'IA' then 122     
 --  when 'EA' then 112    
 --  when 'EM' then 216    
 --  when 'EO' then 411    
 --  when 'IO' then 421    
 --  else 800    
 -- End)    
 --End    
 --) Dimensao_2,    
 null Dimensao_2,    
 '' Dimensao_5,    
     
 'BR1' Dimensao_6,    
 Dimensao7 Dimensao_7,    
 2 Tipo,    
 NULL NumeroInternoAX,    
 cd_AX Cd_PessoA_AX,    
 'Vend' AccountType,    
 1 Aprovado,    
 Null Aprovado_Por,    
 getdate() Dt_Aprovacao,    
 'BR1' Company,    
 (convert(Datetime,Dt_Aprovacao,105)) Dt_Documento,    
 SP.ID Numero_Documento,    
 max(convert(datetime,SP.Dt_Vcto,105)) Dt_Vencimento,    
 SP.ID Invoice_Number,    
 AV.TaxGroup TaxGroup,    
    
 null TaxItemGroup,    
 (convert(Datetime,Dt_Aprovacao,105))   Dt_Ins,    
 Null Dt_Envio_AX,    
 ''Obs_AX,    
 1 Ativo,    
 Getdate() Data_Aprovacao    
From dbo.Sol_Pgto_Cta_Cte SP with(nolock)    
  join Sol_Pgto_Cta_Cte_Item SI with(nolock) on SI.ID = SP.ID and Status_Aprovacao = 'A'    
  Join Pessoa PP with (nolock) on PP.Cd_Pes=SP.Cd_Cred_Dev    
  Left Join Pessoa_LLP P with (nolock) on P.Cd_Pes=PP.Cd_Pes    
  Left Join Pessoa_ATL_AX AX with (nolock) on (AX.Cd_Pes = PP.Cd_Pes) and Tipo='F'    
  Left Join vwcliente C with (nolock) on C.num_proc=SI.Num_Proc    
  left  Join dbo.AX_XML_Vendor_Recebido AV with (nolock) on accountnum=cd_ax    
  left join ax_doc AXD with(nolock) on AXD.Numero_Documento=SP.ID    
      
  left join Site S with(nolock) on SP.Ref_Acesso = S.Cd_Site    
      
    
  left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO = SI.Num_Proc    
  left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO     
 Where     
  (SI.DC='D' or SI.DC='C' and SI.Cd_Tp_Tx in ('XY0','XY1','D2D'))and    
  (    
   (month(convert(Datetime,Dt_Aprovacao,105))=month(getdate()-30)    
   and year(convert(Datetime,Dt_Aprovacao,105))=year(getdate()-30))    
  or    
   (month(convert(Datetime,Dt_Aprovacao,105))=month(getdate())    
   and year(convert(Datetime,Dt_Aprovacao,105))=year(getdate()))    
  ) and    
  (C.cd_cliente <> SP.Cd_Cred_Dev or C.cd_cliente is null)    
  --and AV.AccountNum is not null    
  --and AXD.ID_AX is null    
  and SP.Status = 1    
      
  and    
  (    
   J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1    
   or    
   J.Num_Proc is not null and LBO.Id_TP_Servico = 1      
  )      
--group by SP.ID,SI.DC,SI.cd_Tp_Tx ,Apelido,AV.TaxGroup,pp.cd_pes,SI.Num_Proc,AX.cd_ax,    
--(convert(datetime,Dt_Aprovacao,105)),dimensao7,num_cpf_cnpj,LEFT(J.Num_Proc,2)    
    
   and SI.Num_Proc IN ('BOCSR202006036BR','BOCSR202006002BR','BOCSR202006006BR','BOCSR202006007BR','BOCSR202006008BR')  
  
group by SP.ID,SI.DC,SI.cd_Tp_Tx ,Apelido,AV.TaxGroup,pp.cd_pes,SI.Num_Proc,AX.cd_ax,    
(convert(datetime,Dt_Aprovacao,105)),dimensao7,num_cpf_cnpj,Site_AX,LEFT(J.Num_Proc,2)    
*/
GO

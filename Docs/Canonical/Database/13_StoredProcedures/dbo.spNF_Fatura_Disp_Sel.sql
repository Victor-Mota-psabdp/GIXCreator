SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--Incluido um Table pra fatura_nf, pois estava duplicando os valores igual o item fat -Cadu = 30/06/2014  
--spNF_Fatura_Disp_Sel 'DOW BRASIL','ce'  
--spNF_Fatura_Disp_Sel 'BDPsdcsd','admin'  
--incluido nao trazer o q tem solPgto - Cadu 4/4/15  
--incluido só trazer taxas com vinculação de servico - 14/08/2015 - cadu  
--incluido ser pela vwFaturas - cadu 15-09-2015  
--incluido ser pela vwInvoice_NFValidas - cadu 15-09-2015  
--incluido nao trazer taxas sem codigo de serviço - cadu 15-09-2015  
--2-9-2016  -cadu, incluido o left join com ax docs  
--24-10-2016 - incluido verificar o Campo_Processo-BDP Produto, qdo for Freight ou Freight + CHB - tem q ter ATD ou ATA  
  
--26-10-2016 - incluido p trazer o master  
--[spNF_Fatura_Disp_Sel]'ABSA - 1691C','admin','A'  
--[spNF_Fatura_Disp_Sel]'OSRAM COMER - 3209C','admin','A'  
  
CREATE procedure [dbo].[spNF_Fatura_Disp_Sel]--'OSRAM COMER - 3209C','admin','I'  
  
 @Cliente varchar(50),  
 @cd_user varchar(6),  
 @cd_site char(1)  
as  
  
SET NOCOUNT ON   
   
 declare @CD_PES varchar(10)   
 set @CD_PES = (Select cd_pes from pessoa with(nolock) where Apelido = @Cliente)   
  
 select   
  CC.Num_Proc_hia   Processo,   
  TT.Nome_tp_tx   Taxa,   
  CC.DC_hia    DC,   
  TM.Nome_tp_moeda  Moeda,  
  CC.Vlr_Org_hia   Vlr_Org,   
----  Par_Moeda_him   Par_Moeda,  
  (case When  
   CC.Num_NF_HIA is not NULL  
  Then   
   CC.Par_NF_HIA   
  else     
   (case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')  
    else   
   (case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')  
    else   
   (case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')  
    else   
   (case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')       
    else  
     dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')   
   end)end)end)end)end)  Par_Moeda,    
  TT.NF     T_NF,  
  Repasse_TX    Repasse_TX,  
  CC.num_nf_hia NF,   
  CC.ref_acesso_nf_hia [Site]  
    
  ,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx  
 from vwCTA_CTE CC with(nolock)  
  join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx    
  left Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda  
  left Join vwCxas CXA with(nolock) on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia      
  Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'  
  Left Join vwFaturasValidas FAt with(nolock) on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc      
  Left join vwAXDocs AXD with (nolock)on CC.Num_Proc_HIA = AXD.Num_proc  and CC.cd_tp_tx = AXD.Cd_Tp_Tx_ATL and cc.DC_HIA = AXD.dc      
  Left Join vwInvoice_NFValidas NFI with(nolock) on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc      
  Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA  
  left join Tipo_taxaXTipo_NF_Doc_Register TN with(nolock) on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site  
  join [vwCliente_Alerta] V with(nolock) on V.num_proc = CC.Num_proc_hia  
  join Campo_Processo CP  with(nolock) on CP.Num_Proc = CC.Num_proc_hia and Id_Campo = 143  
 where   
  convert(datetime,dt_ins_hia,103) > getdate() - 450  
  and CC.cd_cred_dev_hia = @CD_PES    
  and desp_org_hia='N'   
  and desat_tx='N'  
  and CXA.Num_Lcto is null   
  and Fat.num_proc is null  
  and NFI.num_proc is null  
  and CC.Num_NF_HIA is null  
  and AXD.id_Ax is null  
  and CC.Vlr_Org_hia <> 0  
  and S.ID is null  
  and (  
   (@cd_site in ('J','K','I','A','C','H') and TN.cd_servico is not null)  
   OR  
   (@cd_site not in('J','K','I','A','C','H') and TN.cd_servico is null)  
   )  
  and (  
   (LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))  
   or  
   (LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))  
   or  
   (LEFT(CC.Num_proc_hia,1) = 'B' and isnull(CP.Campo_Dados,1) in (1,2,3))  
   or  
   (CP.Campo_Dados in (1))  
   )  
   --and V.Master = 'JOB'  
     
 UNION ALL  
   
 select   
  CC.Num_Proc_hia   Processo,   
  TT.Nome_tp_tx   Taxa,   
  CC.DC_hia    DC,   
  TM.Nome_tp_moeda  Moeda,  
  CC.Vlr_Org_hia   Vlr_Org,   
----  Par_Moeda_him   Par_Moeda,  
  (case When  
   CC.Num_NF_HIA is not NULL  
  Then   
   CC.Par_NF_HIA   
  else     
   (case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')  
    else   
   (case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')  
    else   
   (case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')  
    else   
   (case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')       
    else  
     dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')   
   end)end)end)end)end)  Par_Moeda,    
  TT.NF     T_NF,  
  Repasse_TX    Repasse_TX,  
  CC.num_nf_hia NF,   
  CC.ref_acesso_nf_hia [Site]    
  ,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx  
 from vwCTA_CTE CC with(nolock)  
  join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx    
  left Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda  
  left Join vwCxas CXA with(nolock) on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia      
  Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'  
  Left Join vwFaturasValidas FAt with(nolock) on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc      
  Left join vwAXDocs AXD with (nolock)on CC.Num_Proc_HIA = AXD.Num_proc  and CC.cd_tp_tx = AXD.Cd_Tp_Tx_ATL and cc.DC_HIA = AXD.dc      
  Left Join vwInvoice_NFValidas NFI with(nolock) on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc      
  Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA  
  left join Tipo_taxaXTipo_NF_Doc_Register TN with(nolock) on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site  
  join [vwCliente_Alerta] V with(nolock) on V.Master = CC.Num_proc_hia   
  join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143  
 where   
  convert(datetime,dt_ins_hia,103) > getdate() - 450  
  and CC.cd_cred_dev_hia = @CD_PES    
  and desp_org_hia='N'   
  and desat_tx='N'  
  and CXA.Num_Lcto is null   
  and Fat.num_proc is null  
  and NFI.num_proc is null  
  and CC.Num_NF_HIA is null  
  and AXD.id_Ax is null  
  and CC.Vlr_Org_hia <> 0  
  and S.ID is null  
  and (  
   (@cd_site in ('J','K','I','A','C','H') and TN.cd_servico is not null)  
   OR  
   (@cd_site not in('J','K','I','A','C','H') and TN.cd_servico is null)  
   )  
  and (  
   (LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))  
   or  
   (LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))  
   or  
   (LEFT(CC.Num_proc_hia,1) = 'B' and isnull(CP.Campo_Dados,1) in (1,2,3))  
   or  
   (CP.Campo_Dados in (1))  
   )  
     
     
  --and V.Master <> 'JOB'  
   
  
/*  
ALTER procedure [dbo].[spNF_Fatura_Disp_Sel]--'ET LTDA','admin','I'  
  
 @Cliente varchar(50),  
 @cd_user varchar(6),  
 @cd_site char(1)  
as  
  
SET NOCOUNT ON   
    
 declare @CD_PES varchar(10)   
 set @CD_PES = (Select cd_pes from pessoa with(nolock) where Apelido = @Cliente)  
   
 select   
  CC.Num_Proc_hia   Processo,   
  TT.Nome_tp_tx   Taxa,   
  CC.DC_hia    DC,   
  TM.Nome_tp_moeda  Moeda,  
  CC.Vlr_Org_hia   Vlr_Org,   
----  Par_Moeda_him   Par_Moeda,  
  (case When  
   CC.Num_NF_HIA is not NULL  
  Then   
   CC.Par_NF_HIA   
  else     
   (case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')  
    else   
   (case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')  
    else   
   (case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')  
    else   
   (case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')       
    else  
     dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')   
   end)end)end)end)end)  Par_Moeda,    
  TT.NF     T_NF,  
  Repasse_TX    Repasse_TX,  
  CC.num_nf_hia NF,   
  CC.ref_acesso_nf_hia [Site]  
    
  ,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao,TT.IRRF_Tx  
 from vwCTA_CTE CC with(nolock)  
  join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx    
  left Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda  
  left Join vwCxas CXA with(nolock) on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia      
  Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'  
  Left Join vwFaturasValidas FAt with(nolock) on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc      
  Left join vwAXDocs AXD with (nolock)on CC.Num_Proc_HIA = AXD.Num_proc  and CC.cd_tp_tx = AXD.Cd_Tp_Tx_ATL and cc.DC_HIA = AXD.dc      
  Left Join vwInvoice_NFValidas NFI with(nolock) on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc      
  Left join vwSolPgtoCtaCteAprovadas S with(nolock) on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA  
  left join Tipo_taxaXTipo_NF_Doc_Register TN with(nolock) on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site  
 where   
  convert(datetime,dt_ins_hia,103) > getdate() - 450  
  and CC.cd_cred_dev_hia = @CD_PES    
  and desp_org_hia='N'   
  and desat_tx='N'  
  and CXA.Num_Lcto is null   
  and Fat.num_proc is null  
  and NFI.num_proc is null  
  and CC.Num_NF_HIA is null  
  and AXD.id_Ax is null  
  and CC.Vlr_Org_hia <> 0  
  and S.ID is null  
  and (  
   (@cd_site in ('I','A','C','H') and TN.cd_servico is not null)  
   OR  
   (@cd_site not in('I','A','C','H') and TN.cd_servico is null)  
   )  
     
*/     
  
/*Codigo ANtigo  
ALTER procedure [dbo].[spNF_Fatura_Disp_Sel]--'ET LTDA','admin','I'  
  
 @Cliente varchar(50),  
 @cd_user varchar(6),  
 @cd_site char(1)  
as  
  
SET NOCOUNT ON   
    
 declare @CD_PES varchar(10)   
 set @CD_PES = (Select cd_pes from pessoa with(nolock) where Apelido = @Cliente)  
   
 Declare @Fatura Table  
  (  
   Num_proc varchar(16),  
   Cd_tp_Tx Varchar(3),  
   DC   Varchar(1)     
  )  
 Begin     
  Insert @Fatura     
   Select (case when len(i.fatcod)= 15 then left(i.fatcod,14) else left(i.fatcod,16) end),   
   cd_tp_Tx,dc from item_fat I      
    Join Fatura F on F.fatcod=i.fatcod   
   where  
    fatdtEmissao >='01-01-2013' and fatstatus =1  
 End    
   
 Declare @Invoice_NF Table  
  (  
   Num_proc varchar(16),  
   Cd_tp_Tx Varchar(3),  
   DC   Varchar(1)     
  )  
 Begin     
  Insert @Invoice_NF     
   Select I.num_proc,   
   cd_tp_Tx,dc from NF_Fatura_Item I      
    Join NF_Fatura F on F.id=i.id   
   where   
    isnull(cd_status,0) <> 2  
 End   
  
 select   
  CC.Num_Proc_hia   Processo,   
  TT.Nome_tp_tx   Taxa,   
  CC.DC_hia    DC,   
  TM.Nome_tp_moeda  Moeda,  
  CC.Vlr_Org_hia   Vlr_Org,   
----  Par_Moeda_him   Par_Moeda,  
  (case When  
   CC.Num_NF_HIA is not NULL  
  Then   
   CC.Par_NF_HIA   
  else   
   dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')   
  end )Par_Moeda,     
  TT.NF     T_NF,  
  Repasse_TX    Repasse_TX,  
  CC.num_nf_hia NF,   
  CC.ref_acesso_nf_hia [Site]  
    
  ,TN.cd_servico,TN.Item_lei,TN.CNAE,TN.Descricao  
 from vwCTA_CTE CC  
  join tipo_Taxa TT with(nolock) on CC.cd_tp_tx = TT.cd_tp_tx    
  left Join Tipo_Moeda TM with(nolock) on CC.cd_tp_moeda = TM.cd_tp_moeda  
  left Join vwCxas CXA on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia      
  --left Join NF_Fatura_Item NFI on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc  
  --left Join NF_Fatura NF on NF.ID = NFI.ID and isnull(NF.cd_status,0) <> 2  
  Join Pessoa_Atl_AX AX with(nolock) on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'  
  Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc      
  Left Join @Invoice_NF NFI on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc      
  Left join vwSolPgtoCtaCteAprovadas S on S.num_proc=cc.Num_Proc_HIA and S.cd_tp_Tx=cc.cd_tp_Tx and S.dc=cc.DC_HIA  
  left join Tipo_taxaXTipo_NF_Doc_Register TN on TN.cd_tp_tx = CC.cd_tp_tx and TN.cd_site = @cd_site  
 where   
  convert(datetime,dt_ins_hia,103) > getdate() - 450  
  and CC.cd_cred_dev_hia = @CD_PES    
  and desp_org_hia='N'   
  and desat_tx='N'  
  and CXA.Num_Lcto is null   
  and Fat.num_proc is null  
  and NFI.num_proc is null  
  and CC.Num_NF_HIA is null  
  and CC.Vlr_Org_hia <> 0  
  and S.ID is null  
    
*/    
    
    
    
    
    
    
    
----OLD  
--declare @CD_PES varchar(10)   
-- set @CD_PES = (Select cd_pes from pessoa where Apelido = @Cliente)  
   
-- Declare @Fatura Table  
--  (  
--   Num_proc varchar(16),  
--   Cd_tp_Tx Varchar(3),  
--   DC   Varchar(1)     
--  )  
-- Begin     
--  Insert @Fatura     
--   Select (case when len(i.fatcod)= 15 then left(i.fatcod,14) else left(i.fatcod,16) end),   
--   cd_tp_Tx,dc from item_fat I      
--    Join Fatura F on F.fatcod=i.fatcod   
--   where  
--    fatdtEmissao >='01-01-2013' and fatstatus =1  
-- End    
  
-- select   
--  CC.Num_Proc_hia   Processo,   
--  TT.Nome_tp_tx   Taxa,   
--  CC.DC_hia    DC,   
--  TM.Nome_tp_moeda  Moeda,  
--  CC.Vlr_Org_hia   Vlr_Org,   
------  Par_Moeda_him   Par_Moeda,  
--  (case When  
--   CC.Num_NF_HIA is not NULL  
--  Then   
--   CC.Par_NF_HIA   
--  else   
--   dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')   
--  end )Par_Moeda,     
--  TT.NF     T_NF,  
--  Repasse_TX    Repasse_TX,  
--  CC.num_nf_hia NF,   
--  CC.ref_acesso_nf_hia [Site]  
-- from vwCTA_CTE CC  
--  join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx    
--  left Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda  
--  left Join vwCxas CXA on CC.Num_proc_hia = CXA.Num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia      
--  left Join NF_Fatura_Item NFI on CC.Num_proc_hia = NFI.Num_proc and CC.cd_tp_tx = NFI.cd_tp_tx and CC.dc_hia = NFI.dc  
--  left Join NF_Fatura NF on NF.ID = NFI.ID and isnull(NF.cd_status,0) <> 2  
--  Join Pessoa_Atl_AX AX on AX.cd_pes=CC.cd_cred_dev_hia and tipo='C'  
--  Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc      
-- where   
--  convert(datetime,dt_ins_hia,103) > getdate() - 450  
--  and CC.cd_cred_dev_hia = @CD_PES    
--  and desp_org_hia='N'   
--  and desat_tx='N'  
--  and CXA.Num_Lcto is null   
--  and Fat.num_proc is null  
--  and CC.Num_NF_HIA is null  
--  and CC.Vlr_Org_hia <> 0  
  
  
GO

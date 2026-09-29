SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--spBuscaNFcomRPSNFE_Sel '147984','A'  
CREATE Procedure [dbo].[spBuscaNFcomRPSNFE_Sel]--'20010','I'  
 @Nota_fiscal Varchar(10),  
 @Ref_Acesso  char(1)  
   
as   

if @Ref_Acesso='A' -- Alessandra 20/07/2020 -- para são paulo ela nao precisa ter sido enviada para prefeitura pois foi cancelado o envio pra prefeitura  
 Begin  
  select   
   NF.Nota_Fiscal  
  from base_nota_fiscal NF with(nolock)  
     
  where  
   nf.notA_fiscal = @Nota_fiscal  
   and ref_acesso =  @Ref_Acesso    
   and RPS_NFE is not null  
   and dt_Cancel_Prefeitura is null  
   and Cd_Status <> 2  
 END  
else if @Ref_Acesso='H'  
 Begin  
  select   
   NF.Nota_Fiscal  
  from base_nota_fiscal NF with(nolock)  
     
  where  
   nf.notA_fiscal = @Nota_fiscal  
   and ref_acesso =  @Ref_Acesso    
   and RPS_NFE is null  
   and dt_Cancel_Prefeitura is null  
   and Cd_Status <> 2  
 END  
   
else if @Ref_Acesso='I'  
 BEGIN  
  select   
   NF.Nota_Fiscal  
  from   
   base_nota_fiscal NF with(nolock)    
  where  
   nf.notA_fiscal = @Nota_fiscal  
   and ref_acesso =  @Ref_Acesso    
   and RPS_NFE is null  
   --and protocolo is null  
   and dt_Cancel_Prefeitura is null  
   and Cd_Status <> 2  
 END  
else  
 BEGIN  
  select   
   NF.Nota_Fiscal  
  from   
   base_nota_fiscal NF with(nolock)     
  where  
   nf.notA_fiscal = @Nota_fiscal  
   and ref_acesso =  @Ref_Acesso    
   and RPS_NFE is null  
   and dt_Cancel_Prefeitura is null  
   and Cd_Status <> 2  
   --and Nota_Fiscal > '3786'  
 END  
GO

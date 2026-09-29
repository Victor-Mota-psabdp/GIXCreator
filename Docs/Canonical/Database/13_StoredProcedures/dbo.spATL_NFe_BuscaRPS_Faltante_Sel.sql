SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_NFe_BuscaRPS_Faltante_Sel]--'2015-10-02','2015-10-22','I'  
 @dtInicial datetime,  
 @dtFinal datetime,  
 @Site char(1)  
as  
  

 select   
  BNF.Nota_Fiscal,  
  BNF.RPS_NFE  
 from   
  Base_Nota_Fiscal BNF  
 where  
  BNF.Ref_Acesso = @Site    
  and BNF.Cd_Status <> 2   
  and BNF.RPS_Envio <> 1  
  and (emissao between @dtInicial and @dtFinal)   
  and BNF.Protocolo is not null    
  and RPS_NFE is null 
  --and BNF.Nota_Fiscal in ('187940')
 --and BNF.Nota_Fiscal not in  (  '35163','35164','35165','35168','35169' )
  --and Item_lei not in (10.05)
   
   /*
  union

 select   
  BNF.Nota_Fiscal,  
  BNF.RPS_NFE  
 from   
  Base_Nota_Fiscal BNF  
 where  
  BNF.Ref_Acesso = @Site    
  and BNF.Cd_Status <> 2   
  and BNF.RPS_Envio <> 1  
  and (emissao between '2020-05-01 00:00:00.000' and getdate())
  and BNF.Protocolo is not null    
  and RPS_NFE is null  
  and nota_fiscal in
  (132
,133
,134
,136
,137
,138
,165
,194
,223
,228
,232
,233
,235
,236
,283
,288
,290
,291
,294
,296
,299
,332
,338
,340
)
 */
 
GO

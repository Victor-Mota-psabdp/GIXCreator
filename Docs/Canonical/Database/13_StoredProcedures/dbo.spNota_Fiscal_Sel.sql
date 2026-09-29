SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNota_Fiscal_Sel]--'6623','I'  
  
 @Nota_fiscal varchar(50),   
 @cd_site char(1)  
  
as  
 --Declare @mes int  
 --Declare @ano int  
 --set @mes = (select MONTH(GETDATE()))  
 --set @ano = (select YEAR(getdate()))  
  
select  
 --(Case when MONTH(emissao) = @mes and YEAR(emissao) = @ano then  
 -- cd_status  
 -- else    
 -- 3  
    
 --End) cd_status  
 cd_status  
 --MONTH(emissao),  
 --YEAR(emissao),  
 --@mes Mes,  
 --@ano Ano   
from   
 base_nota_fiscal With(nolock)  
where     
 ref_acesso =@cd_site   
 and nota_fiscal =@Nota_fiscal  
   
   
    
  
    
  
GO

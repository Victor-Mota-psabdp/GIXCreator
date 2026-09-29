SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  --use atl_br
  --use atlantis 
-- drop proc [dbo].[spNF_Grupo_Envio]  
  --Marcela new proc #100-182106 
 CREATE procedure [dbo].[spNF_Grupo_Envio]  
 @Grupo varchar(3),  
 @Num_Proc varchar(16)  
    
AS  

 update ATL_BR.dbo.danfe_base set dt_alerta = getdate()  
 where  substring(num_proc,3,3) = @Grupo  
  and (Num_Proc like '%'+@Num_Proc+'%')   


GO

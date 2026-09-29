SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table DE_PARA_PRODUTO add [Dt_Ins] Datetime Null 
--select * from DE_PARA_PRODUTO where [Dt_Ins]  is not null 
--sp_help DE_PARA_PRODUTO 
--novos campos:Dow Product Structure - June/2019 - 21-6  
--"Performance Center Code" and "Performance Center Name". 
CREATE Procedure [dbo].[spDeParaProduto_Cliente_InsUpd]  
    
  @Cd_Cliente           Varchar(10),  
  @GMID            VarChar(30),  
  @GMID_Descr_Curta      VarChar(100),  
  @P_Descricao       VarChar(150),  
  @S_Descricao       VarChar(150),  
  @Business_Group_Code  VarChar(8),  
  @Business_Group_Name  VarChar(40),  
  @Business_Code       VarChar(8),  
  @Business_Name       VarChar(40),  
  @Value_Center_Code      VarChar(8),  
  @Value_Center_Descr      VarChar(40),  
  @Performance_Center_Code VarChar(8) = NULL,  
  @Performance_Center_Descr VarChar(40) = NULL  
  
AS  
  
Begin Transaction  
  
  
if exists(select Produto_Descr from Produto_Cliente where cd_Proc_Cliente = @GMID and Cd_Cliente=@Cd_Cliente)  
 BEGIN  
  if not exists(select gmid from DE_PARA_PRODUTO where gmid=@GMID and Cd_Cliente=@Cd_Cliente)  
   BEGIN  
    INSERT INTO   
     DE_PARA_PRODUTO  
      (  
       Cd_Cliente, GMID, GMID_Descr_Curta, P_Descricao, S_Descricao, Business_Group_Code,   
       Business_Group_Descr, Business_Code,Business_Descr,Value_Center_Code,Value_Center_Descr,  
       dt_ins,  
       Performance_Center_Code,Performance_Center_Descr  
      )  
    VALUES  
  
      (  
       @Cd_Cliente, @GMID, @GMID_Descr_Curta, @P_Descricao, @S_Descricao, @Business_Group_Code,  
       @Business_Group_Name, @Business_Code, @Business_Name, @Value_Center_Code, @Value_Center_Descr,  
       GETDATE(),  
       @Performance_Center_Code,@Performance_Center_Descr  
      )  
   END  
  
  ELSE  
   BEGIN  
    UPDATE  
     DE_PARA_PRODUTO  
      SET  
       --Cd_Cliente=@Cd_Cliente,  
       GMID_Descr_Curta=@GMID_Descr_Curta,  
--       P_Descricao=@P_Descricao,  
--       S_Descricao=@S_Descricao,  
       Value_Center_Code=@Value_Center_Code,  
       Value_Center_Descr=@Value_Center_Descr,  
       Business_Code=@Business_Code,  
       Business_Descr=@Business_Name,  
       Business_Group_Code=@Business_Group_Code,  
       Business_Group_Descr=@Business_Group_Name,  
       dt_ins = GETDATE(),  
       Performance_Center_Code= @Performance_Center_Code,  
       Performance_Center_Descr = @Performance_Center_Descr  
      WHERE  
       GMID=@GMID and Cd_Cliente=@Cd_Cliente  
   END  
 END  
   
 if @@Error<>0  
  BEGIN  
   ROLLBACK TRANSACTION  
   RETURN -1  
  END  
COMMIT TRANSACTION  
GO

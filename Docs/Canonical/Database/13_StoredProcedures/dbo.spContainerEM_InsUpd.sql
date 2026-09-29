SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spContainerEM_InsUpd] --'11','EMCSR20080206601','FSCU792444-8','20ft - Box','HS1278632', 16183.440  
(  
 @Item_Cont_EM   INT,  
 @Num_Proc_HEM  VarChar(16),  
 @Num_Cont_EM  VarChar(15),  
 @Nome_Tp_Cont  VarChar(30),  
 @Num_Lacre_EM  VarChar(50),  
 @Num_Lacre_EM2  VarChar(15),  
 @Peso_Bruto_EM  float,  
 @VolumeM3   float,  
 @Tara_EM   float  
)  
AS  
  
BEGIN TRANSACTION  
 Declare @Num_Proc_MEM VarChar(14)  
 Declare @Cd_tp_Cont   VarChar(3)  
  
 Set @Cd_Tp_Cont =(select cd_tp_cont from tipo_container where nome_tp_cont = @nome_tp_cont)  
 SET @Num_Proc_MEM=(select num_proc_MEM from house_EXP_mar where num_proc_HEM=@num_proc_HEM)  
  
 If @Item_Cont_EM is Null  
  
  BEGIN  
   Set @Item_Cont_EM='000000000'+ (select IsNULL(max(cast(item_cont_EM as int)),0)+1 from container_mas_EXP_mar where num_proc_MEM=@Num_Proc_MEM)  
   SET @Item_Cont_EM=right(@Item_Cont_EM,10)  
  
   Insert Container_Mas_EXP_mar  
    (  
     Num_Proc_MEM,  
     Num_Cont_EM,  
     Cd_tp_Cont,  
     Item_Cont_EM,  
     Num_Lacre_EM,  
     Peso_Bruto_EM,  
     VolumeM3,  
     Tara_EM,  
     Lacre_02_EM  
    )  
   Values  
    (  
     @Num_Proc_MEM,  
     @Num_Cont_EM,  
     @Cd_tp_Cont,  
     @Item_Cont_EM,  
     @num_lacre_EM,  
     @Peso_Bruto_EM,  
     @VolumeM3,  
     @Tara_EM,  
     @Num_Lacre_EM2  
    )  
  
--Inserir Container_Hou_Exp_Mar  
   Insert container_Hou_EXP_mar  
    (  
     Num_Proc_MEM,  
     Item_Cont_EM,  
     Num_Proc_HEM  
    )  
   Values  
    (  
     @Num_Proc_MEM,  
     @Item_Cont_EM,  
     @Num_Proc_HEM  
    )  
  END  
 ELSE  
  BEGIN  
     
   UPDATE   
    CONTAINER_MAS_EXP_MAR  
     set  
      Num_Cont_EM = @Num_Cont_EM,  
      Num_Lacre_EM=@Num_Lacre_EM,  
      Cd_tp_Cont=@Cd_tp_Cont,  
      Peso_Bruto_EM = @Peso_Bruto_EM,  
      VolumeM3 = @VolumeM3,  
      Tara_EM = @Tara_EM,  
      Lacre_02_EM = @Num_Lacre_EM2  
   WHERE  
    Num_Proc_MEM = @Num_Proc_MEM and Item_Cont_EM = @Item_Cont_EM  
  
  END  
  
  
Commit Transaction   
  
  
  
GO

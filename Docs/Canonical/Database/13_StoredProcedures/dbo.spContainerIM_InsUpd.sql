SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spContainerIM_InsUpd]

@ITEM_CONT_IM INT,  
@Num_Proc_HIM VarChar(16),  
@Num_Cont_IM VarChar(15),  
@Nome_Tp_Cont VarChar(30),  
@Num_Lacre_IM VarChar(50),  
@Num_Lacre_IM2 VarChar(15),  
@Num_Lacre_IM3 VarChar(15),  
@Peso_Bruto_IM float,  
@Dt_Vcto_Devol_IM VarChar(10),  
@Dt_Devol_IM VarChar(10),  
@VolumeM3 float,  
@Inspecao char(1)  
  
AS  
  
BEGIN TRANSACTION  
  
Declare  @Num_Proc_MIM VarChar(14)  
Declare  @Cd_tp_Cont   VarChar(3)  
  
Set @Cd_Tp_Cont =(select cd_tp_cont from tipo_container where nome_tp_cont = @nome_tp_cont)  
SET @Num_Proc_MIM=(select num_proc_MIM from house_imp_mar where num_proc_HIM=@num_proc_HIM)  
 IF @Item_Cont_IM is Null  
-- if not exists(   
--  select * from container_hou_imp_mar HOU  
--  join container_mas_imp_mar CM on cm.num_proc_MIM=hou.num_proc_MIM and cm.item_cont_IM=HOU.item_cont_IM  
--  Where num_proc_HIM=@num_proc_HIM and Num_Cont_IM=@Num_Cont_IM  
--  )  
  BEGIN  
   Set @Item_Cont_IM='000000000'+(select IsNULL(max(cast(item_cont_IM as int)),0)+1 from container_mas_imp_mar where num_proc_MIM=@num_proc_MIM)  
   SET @Item_Cont_IM=right(@Item_Cont_IM,10)  
--Inserir Container_mas_imp_Mar  
   Insert Container_Mas_imp_mar  
    (  
     Num_Proc_MIM,  
     Num_Cont_IM,  
     Cd_tp_Cont,  
     Item_Cont_IM,  
     Num_Lacre_IM,  
     Peso_Bruto_IM,  
     Dt_Vcto_Devol_IM,  
     Dt_Devol_IM,  
     VolumeM3,  
     Lacre_02_IM,  
     Lacre_03_IM,  
     inspecao,  
     dt_ins  
    )  
   Values  
    (  
     @Num_Proc_MIM,  
     @Num_Cont_IM,  
     @Cd_tp_Cont,  
     @Item_Cont_IM,  
     @num_lacre_IM,  
     @Peso_Bruto_IM,  
     @Dt_Vcto_Devol_IM,  
     @Dt_Devol_IM,  
     @VolumeM3,  
     @Num_Lacre_IM2,  
     @Num_Lacre_IM3,  
     @Inspecao,  
     getdate()  
    )  
  
--Inserir Container_Hou_imp_Mar  
   Insert container_Hou_Imp_mar  
    (  
     Num_Proc_MIM,  
     Item_Cont_IM,  
     Num_Proc_HIM  
    )  
   Values  
    (  
     @Num_Proc_MIM,  
     @Item_Cont_IM,  
     @Num_Proc_HIM  
    )  
  END  
 ELSE  
  BEGIN  
--   SET @Item_Cont_IM=(  
--     select HOU.item_cont_IM from container_hou_imp_mar HOU  
--     join container_mas_imp_mar CM on cm.num_proc_MIM=hou.num_proc_MIM and cm.item_cont_IM=HOU.item_cont_IM  
--     Where num_proc_HIM=@num_proc_HIM and Num_Cont_IM=@Num_Cont_IM  
--     )  
   UPDATE   
    CONTAINER_MAS_IMP_MAR  
     set  
      Num_Lacre_IM=@Num_Lacre_IM,  
      Cd_tp_Cont=@Cd_tp_Cont,  
      Peso_Bruto_IM = @Peso_Bruto_IM,  
      Dt_Vcto_Devol_IM = @Dt_Vcto_Devol_IM,  
      Dt_Devol_IM = @Dt_Devol_IM,  
      VolumeM3 = @VolumeM3,  
      Lacre_02_IM = @Num_Lacre_IM2,  
      Lacre_03_IM = @Num_Lacre_IM3,  
      inspecao = @Inspecao,  
	  Num_Cont_IM=@Num_Cont_IM, -- Alessandra 16/07/2020
      dt_ins = getdate()  
   WHERE  
    Num_Proc_MIM = @Num_Proc_MIM and Item_Cont_IM = @Item_Cont_IM  
  
  END  
    
    
     
  Commit Transaction   
  
        
        
  
  
  
  
  
  
  
  
  
  
  
  
GO

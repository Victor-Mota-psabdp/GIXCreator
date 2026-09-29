SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATLANTIS_Container_Temp_Imp_Mar_Sel]--'2'
(
	@ID	BIGINT
)

as
	select ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,Item_Cont_IM,
			Cd_Tp_Cont,Name_Type_Container,Num_Cont_IM,
			Num_Lacre_IM,Dt_Vcto_Devol_IM,
			Dt_Devol_IM,Lacre_02_IM,Lacre_03_IM,Lacre_04_IM,
			Peso_Bruto_IM,VolumeM3,
			ID_ISO,Tara_IM,DataDevCli_IM,inspecao,Dt_Ins	
	from Container_Temp_Imp_Mar
	where
		ID = @ID

GO

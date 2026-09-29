SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


------- Container_Imp_Mar --------------
--SELECT * FROM Container_HOU_Imp_Mar
--sp_help Container_HOU_Imp_Mar
--SELECT * FROM Container_MAS_Imp_Mar
--sp_help Container_MAS_Imp_Mar

CREATE Procedure [dbo].[spATL_Container_Imp_Mar_InsUpd]
(
	@Num_Proc_HIM		VarChar(16),
	@Item_Cont_IM		VarChar(10),
	@Cd_tp_Cont			VarChar(3),	
	@Num_Cont_IM		VarChar(15),	
	@Num_Lacre_IM		VarChar(50),
	@Dt_Vcto_Devol_IM	VarChar(10),
	@Dt_Devol_IM		VarChar(10),
	@Lacre_02_IM		VarChar(15),
	@Lacre_03_IM		VarChar(15),
	@Lacre_04_IM		VarChar(15),
	@Peso_Bruto_IM		float,	
	@VolumeM3			float,
	@Inspecao			char(1),
	@ID_ISO				int,
	@Tara_IM			float,
	@DataDevCli_IM		datetime,
	@Dt_Ins				datetime
)

AS

BEGIN TRANSACTION

Declare	@Num_Proc_MIM VarChar(14)
SET @Num_Proc_MIM=(select num_proc_MIM from house_imp_mar where num_proc_HIM=@num_proc_HIM)

IF @Item_Cont_IM is Null
	begin
		set @Item_Cont_IM = (select HOU.Item_Cont_IM from container_hou_imp_mar HOU
				join container_mas_imp_mar CM on cm.num_proc_MIM=hou.num_proc_MIM and cm.item_cont_IM=HOU.item_cont_IM
				Where num_proc_HIM=@num_proc_HIM and Num_Cont_IM=@Num_Cont_IM)
	
	end
	
	IF @Item_Cont_IM is Null
		BEGIN
			Set @Item_Cont_IM='000000000'+(select IsNULL(max(cast(item_cont_IM as int)),0)+1 from container_mas_imp_mar where num_proc_MIM=@num_proc_MIM)
			SET @Item_Cont_IM=right(@Item_Cont_IM,10)
			Insert Container_Mas_imp_mar
				(
					Num_Proc_MIM,Num_Cont_IM,Cd_tp_Cont,Item_Cont_IM,
					Num_Lacre_IM,Peso_Bruto_IM,Dt_Vcto_Devol_IM,Dt_Devol_IM,
					VolumeM3,Lacre_02_IM,Lacre_03_IM,inspecao,dt_ins
					,Lacre_04_IM
					--,ID_ISO,Tara_IM,DataDevCli_IM
				)
			Values
				(
					@Num_Proc_MIM,@Num_Cont_IM,@Cd_tp_Cont,@Item_Cont_IM,
					@num_lacre_IM,@Peso_Bruto_IM,@Dt_Vcto_Devol_IM,@Dt_Devol_IM,
					@VolumeM3,@Lacre_02_IM,	@Lacre_03_IM,@Inspecao,	getdate()
					,@Lacre_04_IM
					--,@ID_ISO,@Tara_IM,@DataDevCli_IM
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
			UPDATE 
				CONTAINER_MAS_IMP_MAR
					set
						Num_Lacre_IM=@Num_Lacre_IM,
						Cd_tp_Cont=@Cd_tp_Cont,
						Peso_Bruto_IM = @Peso_Bruto_IM,
						Dt_Vcto_Devol_IM = @Dt_Vcto_Devol_IM,
						Dt_Devol_IM = @Dt_Devol_IM,
						VolumeM3 = @VolumeM3,
						Lacre_02_IM = @Lacre_02_IM,
						Lacre_03_IM = @Lacre_03_IM,
						inspecao = @Inspecao,
						dt_ins = getdate()
						,Lacre_04_IM =@Lacre_04_IM
						--,ID_ISO = @ID_ISO,
						--Tara_IM =@Tara_IM ,
						--DataDevCli_IM=@DataDevCli_IM
			WHERE
				Num_Proc_MIM = @Num_Proc_MIM and Item_Cont_IM = @Item_Cont_IM

		END
		
		
			
		Commit Transaction

GO

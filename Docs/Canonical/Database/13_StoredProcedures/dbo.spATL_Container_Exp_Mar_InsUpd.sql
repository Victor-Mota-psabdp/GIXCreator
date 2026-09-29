SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------- Container_Exp_Mar --------------
--SELECT * FROM Container_HOU_Exp_Mar
--sp_help Container_HOU_Exp_Mar
--SELECT * FROM Container_MAS_Exp_Mar
--sp_help Container_MAS_EXp_Mar

CREATE Procedure [dbo].[spATL_Container_Exp_Mar_InsUpd] 
(
	@Num_Proc_HEM		VarChar(16),
	@Item_Cont_EM		VarChar(10),
	@Cd_tp_Cont			VarChar(3),	
	@Num_Cont_EM		VarChar(15),	
	@Num_Lacre_EM		VarChar(50),	
	@Lacre_02_EM		VarChar(15),
	@Lacre_03_EM		VarChar(15),
	@Lacre_04_EM		VarChar(15),
	@Peso_Bruto_EM		float,	
	@VolumeM3			float,
	@ID_ISO				int,
	@Tara_EM			float,	
	@Temperature		float,
	@Vent_Status		VarChar(10),	
	@Battery_Time		VarChar(10),
	@Cd_Tp_Volt			VarChar(10),
	@Graus				VarChar(1),	
	@Dt_Vcto_Devol_EM	Datetime,
	@Dt_Est_Devol_EM	Datetime,
	@Peso_Liquido_EM		float
	
)
AS

BEGIN TRANSACTION
	Declare @Tp_Oper char(1)
	Declare @Num_Proc_MEM VarChar(14)

	SET @Num_Proc_MEM=(select num_proc_MEM from house_EXP_mar where num_proc_HEM=@num_proc_HEM)
	If @Item_Cont_EM is Null

		BEGIN
			Set @Tp_Oper = 'I'
			Set @Item_Cont_EM='000000000'+ (select IsNULL(max(cast(item_cont_EM as int)),0)+1 from container_mas_EXP_mar where num_proc_MEM=@Num_Proc_MEM)
			SET @Item_Cont_EM=right(@Item_Cont_EM,10)

			Insert Container_Mas_EXP_mar
				(
					Num_Proc_MEM,Num_Cont_EM,Cd_tp_Cont,Item_Cont_EM,Num_Lacre_EM,
					Peso_Bruto_EM,Peso_Liquido_EM,VolumeM3,Tara_EM,	Lacre_02_EM,
					Lacre_03_EM,Temperature,Graus,Vent_Status,Battery_Time,Cd_Tp_Volt,
					Dt_Vcto_Devol_EM,Dt_Est_Devol_EM
					,Lacre_04_EM
					--,ID_ISO			
				)
			Values
				(
					@Num_Proc_MEM,@Num_Cont_EM,@Cd_tp_Cont,@Item_Cont_EM,@num_lacre_EM,
					@Peso_Bruto_EM,@Peso_Liquido_EM,@VolumeM3,@Tara_EM,	@Lacre_02_EM,
					@Lacre_03_EM,@Temperature,@Graus,@Battery_Time,@Vent_Status,@Cd_Tp_Volt,
					@Dt_Vcto_Devol_EM,@Dt_Est_Devol_EM
					,@Lacre_04_EM
					--,@ID_ISO				
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
						Peso_Liquido_EM = @Peso_Liquido_EM,
						VolumeM3 = @VolumeM3,
						Tara_EM = @Tara_EM,
						Lacre_02_EM = @Lacre_02_EM,						
						Lacre_03_EM = @Lacre_03_EM,
						[Temperature] = @Temperature,
						[Graus] = @Graus,
						[Vent_Status] = @Battery_Time,
						[Battery_Time] = @Vent_Status,
						[Cd_Tp_Volt]  = @Cd_Tp_Volt,
						Dt_Vcto_Devol_EM = @Dt_Vcto_Devol_EM,
						Dt_Est_Devol_EM = @Dt_Est_Devol_EM
						,Lacre_04_EM = @Lacre_04_EM
						--,	ID_ISO = @ID_ISO						
						
			WHERE
				Num_Proc_MEM = @Num_Proc_MEM and Item_Cont_EM = @Item_Cont_EM
			
			Set @Tp_Oper = 'A'

		END

--LOG
	BEGIN
		Insert Container_LOG_Exp_Mar
				(
					Num_Proc_MEM,
					Item_Cont_EM,
					Num_Cont_EM,
					Dt_Ins
				)
			Values
				(
					@Num_Proc_MEM,
					@Item_Cont_EM,
					@Num_Cont_EM,
					getdate()
				)
	
	END

Commit Transaction 




GO

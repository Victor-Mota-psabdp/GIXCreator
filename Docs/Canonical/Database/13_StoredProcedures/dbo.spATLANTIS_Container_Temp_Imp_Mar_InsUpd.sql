SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATLANTIS_Container_Temp_Imp_Mar_InsUpd]
(
	@ID						BIGINT,				
	@ID_House_Temp			BIGINT,
	@ID_Req					BIGINT,
	@Intl_Reference			varchar(200),
	@Num_Proc				varchar(200),
	@Item_Cont_IM			varchar(200),
	@Cd_Tp_Cont				varchar(200),
	@Num_Cont_IM			varchar(200),
	@Num_Lacre_IM			varchar(200),
	@Dt_Vcto_Devol_IM		varchar(200),
	@Dt_Devol_IM			varchar(200),
	@Lacre_02_IM			varchar(200),
	@Lacre_03_IM			varchar(200),
	@Lacre_04_IM			varchar(200),
	@Peso_Bruto_IM			varchar(200),
	@VolumeM3				varchar(200),
	@ID_ISO					varchar(200),
	@Tara_IM				varchar(200),
	@DataDevCli_IM			varchar(200),
	@inspecao				varchar(200),
	@Dt_Ins					varchar(200),
	@Name_Type_Container	varchar(200)
)

AS

	
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Container_Temp_Imp_Mar
	BEGIN TRY
	
	Declare @ID_New as bigint;

	if not exists(select ID from Container_Temp_Imp_Mar with(nolock)
		where ID = @ID  and Num_Cont_IM = @Num_Cont_IM)
		--AND Item_Cont_IM = @Item_Cont_IM)
		BEGIN
			insert into Container_Temp_Imp_Mar
			(
				ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,Item_Cont_IM,
				Cd_Tp_Cont,Name_Type_Container,Num_Cont_IM,
				Num_Lacre_IM,Dt_Vcto_Devol_IM,
				Dt_Devol_IM,Lacre_02_IM,Lacre_03_IM,Lacre_04_IM,
				Peso_Bruto_IM,VolumeM3,
				ID_ISO,Tara_IM,DataDevCli_IM,inspecao,Dt_Ins	
			)
			Values
			(
				@ID,@ID_House_Temp,@ID_Req,@Intl_Reference,@Num_Proc,@Item_Cont_IM,
				@Cd_Tp_Cont,@Name_Type_Container,@Num_Cont_IM,
				@Num_Lacre_IM,@Dt_Vcto_Devol_IM,
				@Dt_Devol_IM,@Lacre_02_IM,@Lacre_03_IM,@Lacre_04_IM,
				@Peso_Bruto_IM,@VolumeM3,
				@ID_ISO,@Tara_IM,@DataDevCli_IM,@inspecao,@Dt_Ins
			)
			
			set @ID_New = @ID;
			
		END
	else
		BEGIN
			update
				Container_Temp_Imp_Mar
			set
				--ID_House_Temp=@ID_House_Temp,
				ID_Req=@ID_Req,
				Intl_Reference=@Intl_Reference,
				Num_Proc=@Num_Proc,
				Item_Cont_IM=@Item_Cont_IM,
				Cd_Tp_Cont=@Cd_Tp_Cont,
				Num_Cont_IM=@Num_Cont_IM,
				Num_Lacre_IM=@Num_Lacre_IM,
				Dt_Vcto_Devol_IM=@Dt_Vcto_Devol_IM,
				Dt_Devol_IM=@Dt_Devol_IM,
				Lacre_02_IM=@Lacre_02_IM,
				Lacre_03_IM=@Lacre_03_IM,
				Lacre_04_IM=@Lacre_04_IM,
				Peso_Bruto_IM=@Peso_Bruto_IM,
				VolumeM3=@VolumeM3,
				ID_ISO=@ID_ISO,
				Tara_IM=@Tara_IM,
				DataDevCli_IM=@DataDevCli_IM,
				inspecao=@inspecao,
				Dt_Ins=@Dt_Ins,
				Name_Type_Container=@Name_Type_Container
			where
				ID = @ID  and Num_Cont_IM = @Num_Cont_IM
				--ID= @ID AND Item_Cont_IM = @Item_Cont_IM
				--ID_House_Temp=@ID_House_Temp
				--Intl_Reference= @Intl_Reference
				
			set @ID_New = @ID
		
		END
		
	
	Select @ID_New as Retorno;

		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO

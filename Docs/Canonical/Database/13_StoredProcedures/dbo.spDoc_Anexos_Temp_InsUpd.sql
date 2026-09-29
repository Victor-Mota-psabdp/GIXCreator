SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_House_Temp_Sel '2',NULL,'1256319875','D'
--select * from House_Temp where Intl_Reference = '1256319875'
--select * from PO_Temp where Intl_Reference = '1256319875'
--select * from Container_Temp_Imp_Mar where Intl_Reference = '1256319875'
--select * from Doc_Anexos_Temp where Intl_Reference = '1256319875'
--SP_HELP Doc_Anexos_Temp

--alter table Doc_Anexos_Temp alter column Item_Doc int null
--alter table Doc_Anexos_Temp alter column DT_INS DATETIME NULL

CREATE Procedure [dbo].[spDoc_Anexos_Temp_InsUpd]
(
	@ID				bigint,
	@ID_House_Temp	varchar(200),
	@ID_Req			varchar(200),
	@Intl_Reference	varchar(200),
	@Num_Proc		varchar(200),
	@Item_Doc 		int,
	@Nome_Arquivo	varchar(200),
	@ID_DC			varchar(200),
	@DMS_Code		varchar(200),
	@cd_usuario		varchar(200),
	@dt_ins			varchar(200)
)

AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Doc_Anexos_Temp
	BEGIN TRY
	
	Declare @ID_New as bigint;
	
	Set @Item_Doc = (select Item_Doc from Doc_Anexos_Temp where ID = @ID and DMS_CODE = @DMS_Code)

	if not exists(select ID from Doc_Anexos_Temp where ID = @ID and DMS_Code = @DMS_Code AND Item_Doc = @Item_Doc)
		BEGIN
			SET @Item_Doc=(select Isnull(max(Item_Doc),0)+1 from Doc_Anexos_Temp where ID = @ID)
			insert into Doc_Anexos_Temp
			(
				ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,
				Item_Doc,Nome_Arquivo,ID_DC,DMS_Code,cd_usuario,dt_ins
			)
			Values
			(
				@ID,@ID_House_Temp,@ID_Req,@Intl_Reference,@Num_Proc,
				@Item_Doc,@Nome_Arquivo,@ID_DC,@DMS_Code,@cd_usuario,GETDATE()
			)
			
			set @ID_New = @ID;
			
		END
	else
		BEGIN
			update
				Doc_Anexos_Temp
			set
				--ID_House_Temp=@ID_House_Temp,
				--ID_Req=@ID_Req,
				--Intl_Reference=@Intl_Reference,
				Num_Proc=@Num_Proc,
				--Item_Doc=@Item_Doc,
				--Nome_Arquivo=@Nome_Arquivo,
				ID_DC=@ID_DC,
				cd_usuario=@cd_usuario
			where
				ID = @ID and DMS_Code = @DMS_Code AND Item_Doc = @Item_Doc
				
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

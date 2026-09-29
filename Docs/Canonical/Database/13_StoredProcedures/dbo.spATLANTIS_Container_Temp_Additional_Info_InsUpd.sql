SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_HELP Container_Temp_Additional_Info
CREATE PROCEDURE [dbo].[spATLANTIS_Container_Temp_Additional_Info_InsUpd]
(
	@ID						BIGINT,				
	@ID_House_Temp			BIGINT,
	@ID_Req					BIGINT,
	@Intl_Reference			varchar(200),
	@Num_Proc				varchar(200),
	@Item_Cont_IM			varchar(200),
	@Cd_Tp_Cont				varchar(200),
	@Num_Cont_IM			varchar(200),
	
	@dt_entregaPlanta	varchar(200),
	@dt_entregaArmazem	varchar(200),
	@dt_saidaArmazem	varchar(200),
	@dt_saidaVazio	varchar(200),
	@local_entrega	varchar(200),
	@dt_devolucao	varchar(200),
	@local_entrega_vazio	varchar(200),
	@Mercadoria	varchar(200),
	@cd_usuario	varchar(200),
	@dt_ins	varchar(200),
	@ativo	varchar(200),
	@Peso_Bruto_EM_VGM	varchar(200),
	@UOM_VGM	varchar(200),
	@Dt_Envio_VGM	varchar(200),
	@Nome_Responsavel_VGM	varchar(200),
	@Metodo_VGM	varchar(200),
	@TatcNumber	varchar(200),
	@dt_ReleaseTatc	varchar(200),
	@Itinerary_ID	varchar(200)

)

AS

	
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Container_Temp_Additional_Info
	BEGIN TRY
	
	Declare @ID_New as bigint;

	if not exists(select ID from Container_Temp_Additional_Info 
		where ID = @ID  and Num_Cont_IM = @Num_Cont_IM)
		--AND Item_Cont_IM = @Item_Cont_IM)
		BEGIN
			insert into Container_Temp_Additional_Info
			(
				ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,Item_Cont_IM,
				Cd_Tp_Cont,Num_Cont_IM,
				dt_entregaPlanta,dt_entregaArmazem,dt_saidaArmazem,dt_saidaVazio,local_entrega,
				dt_devolucao,local_entrega_vazio,Mercadoria,cd_usuario,dt_ins,ativo,Peso_Bruto_EM_VGM,
				UOM_VGM,Dt_Envio_VGM,Nome_Responsavel_VGM,Metodo_VGM,TatcNumber,dt_ReleaseTatc,Itinerary_ID	
			)
			Values
			(
				@ID,@ID_House_Temp,@ID_Req,@Intl_Reference,@Num_Proc,@Item_Cont_IM,
				@Cd_Tp_Cont,@Num_Cont_IM,
				@dt_entregaPlanta,@dt_entregaArmazem,@dt_saidaArmazem,@dt_saidaVazio,@local_entrega,
				@dt_devolucao,@local_entrega_vazio,@Mercadoria,@cd_usuario,@dt_ins,@ativo,@Peso_Bruto_EM_VGM,
				@UOM_VGM,@Dt_Envio_VGM,@Nome_Responsavel_VGM,@Metodo_VGM,@TatcNumber,@dt_ReleaseTatc,@Itinerary_ID
			)
			
			set @ID_New = @ID;
			
		END
	else
		BEGIN
			update
				Container_Temp_Additional_Info
			set
				--ID_House_Temp=@ID_House_Temp,
				ID_Req=@ID_Req,
				Intl_Reference=@Intl_Reference,
				Num_Proc=@Num_Proc,
				Item_Cont_IM=@Item_Cont_IM,
				Cd_Tp_Cont=@Cd_Tp_Cont,
				Num_Cont_IM=@Num_Cont_IM,
				
				dt_entregaPlanta=@dt_entregaPlanta,
				dt_entregaArmazem=@dt_entregaArmazem,
				dt_saidaArmazem=@dt_saidaArmazem,
				dt_saidaVazio=@dt_saidaVazio,
				local_entrega=@local_entrega,
				dt_devolucao=@dt_devolucao,
				local_entrega_vazio=@local_entrega_vazio,
				Mercadoria=@Mercadoria,
				cd_usuario=@cd_usuario,
				dt_ins=@dt_ins,
				ativo=@ativo,
				Peso_Bruto_EM_VGM=@Peso_Bruto_EM_VGM,
				UOM_VGM=@UOM_VGM,
				Dt_Envio_VGM=@Dt_Envio_VGM,
				Nome_Responsavel_VGM=@Nome_Responsavel_VGM,
				Metodo_VGM=@Metodo_VGM,
				TatcNumber=@TatcNumber,
				dt_ReleaseTatc=@dt_ReleaseTatc,
				Itinerary_ID=@Itinerary_ID
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

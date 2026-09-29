SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table Container_Additional_Info alter column Mercadoria varchar(MAX)null
                       
CREATE Procedure [dbo].[spContainerAdditionalInfo_InsUpd]

	@Num_Proc				VarChar(16),
	@Num_Cont				VarChar(15),
	@dt_entregaPlanta		Datetime,
	@dt_entregaArmazem		Datetime,
	@dt_saidaArmazem		Datetime,
	@dt_saidaVazio			Datetime,
	@dt_devolucao			Datetime,
	@localEntrega			varchar(300),
	@localEntregaVazio		varchar(300),
	@Mercadoria				varchar(MAX),
	@cd_usuario				Varchar(6),
	@Peso_Bruto_EM_VGM		float,
	@UOM_VGM				varchar(2),
	@Dt_Envio_VGM			Datetime,
	@Nome_Responsavel_VGM	varchar(100),
	@Metodo_VGM				varchar(1),
	@TatcNumber				varchar(100),
	@dt_ReleaseTatc			Datetime,
	@Itinerary_Id			varchar(8) = null -- Alessandra 07/07/2020 - e-mail TESTE SCHNEIDER EXPORTAÇÃO MARÍTIMA RM X ABERTURA DE JOB x CONSOLIDADA TRANSPORTATION


AS


set @Num_Cont = REPLACE(@Num_Cont,'-','')
set @Num_Cont = REPLACE(@Num_Cont,'/','')

BEGIN TRANSACTION

	if not exists (select num_proc from container_additional_info where num_proc=@num_proc and num_cont=@num_cont)
		BEGIN			
			Insert container_additional_info
				(
					Num_Proc,
					num_cont,
					dt_entregaPlanta,
					dt_entregaArmazem,
					dt_saidaArmazem,
					dt_saidaVazio,
					dt_devolucao,					
					local_Entrega,
					local_Entrega_Vazio,
					Mercadoria,
					Cd_usuario,
					dt_ins,
					ativo,
					Peso_Bruto_EM_VGM,
					UOM_VGM,
					Dt_Envio_VGM,
					Nome_Responsavel_VGM,
					Metodo_VGM,
					TatcNumber,
					dt_ReleaseTatc,	
					itinerary_id -- Alessandra 07/07/2020 - e-mail TESTE SCHNEIDER EXPORTAÇÃO MARÍTIMA RM X ABERTURA DE JOB x CONSOLIDADA TRANSPORTATION
				)
			Values
				(
					@Num_Proc,
					@Num_Cont,
					@dt_entregaPlanta,
					@dt_entregaArmazem,
					@dt_saidaArmazem,
					@dt_saidaVazio,
					@dt_devolucao,					
					@localEntrega,
					@localEntregaVazio,
					@Mercadoria,
					@cd_usuario,
					getdate(),
					1,
					@Peso_Bruto_EM_VGM,
					@UOM_VGM,
					@Dt_Envio_VGM,
					@Nome_Responsavel_VGM,
					@Metodo_VGM,
					@TatcNumber,
					@dt_ReleaseTatc,
					@itinerary_id -- Alessandra 07/07/2020 - e-mail TESTE SCHNEIDER EXPORTAÇÃO MARÍTIMA RM X ABERTURA DE JOB x CONSOLIDADA TRANSPORTATION
				)
		End
	ELSE
		BEGIN
			UPDATE 
				container_additional_info
					set
						dt_entregaPlanta = @dt_entregaPlanta,
						dt_entregaArmazem = @dt_entregaArmazem,						
						dt_saidaArmazem = @dt_saidaArmazem,
						dt_saidaVazio = @dt_saidaVazio,
						dt_devolucao = @dt_devolucao,						
						local_Entrega = @localEntrega,
						local_Entrega_Vazio = @localEntregaVazio,
						Mercadoria = @Mercadoria,
						Cd_usuario = @cd_usuario,
						Dt_ins = Getdate(),
						ativo = 1,
						Peso_Bruto_EM_VGM = @Peso_Bruto_EM_VGM,
						UOM_VGM = @UOM_VGM,
						Dt_Envio_VGM = @Dt_Envio_VGM,
						Nome_Responsavel_VGM = @Nome_Responsavel_VGM,
						Metodo_VGM=@Metodo_VGM,
						TatcNumber=@TatcNumber,
						dt_ReleaseTatc = @dt_ReleaseTatc,
						itinerary_id = @itinerary_id -- Alessandra 07/07/2020 - e-mail TESTE SCHNEIDER EXPORTAÇÃO MARÍTIMA RM X ABERTURA DE JOB x CONSOLIDADA TRANSPORTATION
			WHERE
				num_proc=@num_proc and num_cont=@num_cont
		END


Commit Transaction 

						
						













GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Nota_Cliente_InsUpd]
(
	@ID_NF						bigint,
	@CNPJ						varchar(15),
	@Nota_Fiscal				varchar(20),
	@Emissao					datetime,
	@CFOP						varchar(10),
	@Invoice					varchar(30),
	@Cd_Exportador				varchar(20),
	@Vlr_NF						float,
	@CD_Cliente					varchar(10),
	@Complementar				char(1),
	@ID_NF_FK					int,
	@DI							varchar(25),
	@Data_DI					datetime,
	@Paridade					float,
	@Num_Proc					varchar(16),
	@Custo						varchar(1),
	@Envio						char(1),
	@data_envio					datetime,
	@Mensagem_Erro				varchar(200),
	@CNPJ_Destinatario			varchar(15),
	@Serie						varchar(20),
	@IntNLog					int,
	@IntNAleatorio				int,
	@intDigitoControle			int,
	@Cd_IBGE_Municipio_Gerador	int,
	@Cd_IBGE_Municipio_Emitente	int,
	@Cd_IBGE_Municipio_Destinatario	int,
	@Cd_Pais_BACEN				int,
	@Vlr_Tot_Base_ICMS			decimal(15,2),
	@Vlr_Tot_ICMS				decimal(15,2),
	@Vlr_Tot_Base_ICMS_ST		decimal(15,2),
	@Vlr_Tot_ICMS_ST			decimal(15,2),
	@Vlr_Tot_Prod_Serv			decimal(15,2),
	@Vlr_Tot_Frete				decimal(15,2),
	@Vlr_Tot_Seguro				decimal(15,2),
	@Vlr_Tot_Desconto			decimal(15,2),
	@Vlr_Tot_IPI				decimal(15,2),
	@Vlr_Tot_PIS				decimal(15,2),
	@Vlr_Tot_Cofins				decimal(15,2),
	@Vlr_Tot_Outras_Desp		decimal(15,2),
	@Cd_Transp					varchar(10),
	@Info_Complementar			varchar(100),
	@Dt_Envio_RM				datetime

)
AS  

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Nota_Cliente
	BEGIN TRY
		Declare @ID_New as bigint;
		
		IF not exists(select ID_NF from Nota_Cliente where num_proc=@num_proc and nota_fiscal=@nota_fiscal)	
			BEGIN 
				Set @ID_NF=(Select iSNULL(max(ID_NF),0)+1 from Nota_Cliente where Cd_cliente = @Cd_Cliente) 
				set @ID_New = @ID_NF

				INSERT Nota_Cliente
				(  
					ID_NF,CNPJ,Nota_Fiscal,Emissao,CFOP,Invoice,Cd_Exportador,Vlr_NF,CD_Cliente,Complementar,ID_NF_FK,DI,
					Data_DI,Paridade,Num_Proc,Custo,Envio,data_envio,Mensagem_Erro,CNPJ_Destinatario,Serie,IntNLog,
					IntNAleatorio,intDigitoControle,Cd_IBGE_Municipio_Gerador,Cd_IBGE_Municipio_Emitente,Cd_IBGE_Municipio_Destinatario,
					Cd_Pais_BACEN,
					Vlr_Tot_Base_ICMS,Vlr_Tot_ICMS,Vlr_Tot_Base_ICMS_ST,Vlr_Tot_ICMS_ST,Vlr_Tot_Prod_Serv,
					Vlr_Tot_Frete,Vlr_Tot_Seguro,Vlr_Tot_Desconto,Vlr_Tot_IPI,Vlr_Tot_PIS,Vlr_Tot_Cofins,
					Vlr_Tot_Outras_Desp,Cd_Transp,Info_Complementar,Dt_Envio_RM
				)  
				VALUES  
				(  
					@ID_NF,@CNPJ,@Nota_Fiscal,@Emissao,@CFOP,@Invoice,@Cd_Exportador,@Vlr_NF,@CD_Cliente,@Complementar,@ID_NF_FK,@DI,
					@Data_DI,@Paridade,@Num_Proc,@Custo,@Envio,@data_envio,@Mensagem_Erro,@CNPJ_Destinatario,@Serie,@IntNLog,
					@IntNAleatorio,@intDigitoControle,@Cd_IBGE_Municipio_Gerador,@Cd_IBGE_Municipio_Emitente,@Cd_IBGE_Municipio_Destinatario,
					@Cd_Pais_BACEN,
					@Vlr_Tot_Base_ICMS,@Vlr_Tot_ICMS,@Vlr_Tot_Base_ICMS_ST,@Vlr_Tot_ICMS_ST,@Vlr_Tot_Prod_Serv,
					@Vlr_Tot_Frete,@Vlr_Tot_Seguro,@Vlr_Tot_Desconto,@Vlr_Tot_IPI,@Vlr_Tot_PIS,@Vlr_Tot_Cofins,
					@Vlr_Tot_Outras_Desp,@Cd_Transp,@Info_Complementar,@Dt_Envio_RM
				)  
			END 
		ELSE  
			BEGIN  
				set @ID_NF = (select ID_NF from Nota_Cliente where num_proc=@num_proc and nota_fiscal=@nota_fiscal)	

				UPDATE  
					Nota_Cliente   
				SET 				
					CNPJ=@CNPJ,
					Nota_Fiscal=@Nota_Fiscal,
					Emissao=@Emissao,
					CFOP=@CFOP,
					Invoice=@Invoice,
					Cd_Exportador=@Cd_Exportador,
					Vlr_NF=@Vlr_NF,
					CD_Cliente=@CD_Cliente,
					Complementar=@Complementar,
					ID_NF_FK=@ID_NF_FK,
					DI=@DI,
					Data_DI=@Data_DI,
					Paridade=@Paridade,
					--Num_Proc=@Num_Proc,
					Custo=@Custo,
					Envio=@Envio,
					data_envio=@data_envio,
					Mensagem_Erro=@Mensagem_Erro,
					CNPJ_Destinatario=@CNPJ_Destinatario,
					Serie=@Serie,
					IntNLog=@IntNLog,
					IntNAleatorio=@IntNAleatorio,
					intDigitoControle=@intDigitoControle,
					Cd_IBGE_Municipio_Gerador=@Cd_IBGE_Municipio_Gerador,
					Cd_IBGE_Municipio_Emitente=@Cd_IBGE_Municipio_Emitente,
					Cd_IBGE_Municipio_Destinatario=@Cd_IBGE_Municipio_Destinatario,
					Cd_Pais_BACEN=@Cd_Pais_BACEN,
					Vlr_Tot_Base_ICMS=@Vlr_Tot_Base_ICMS,
					Vlr_Tot_ICMS=@Vlr_Tot_ICMS,
					Vlr_Tot_Base_ICMS_ST=@Vlr_Tot_Base_ICMS_ST,
					Vlr_Tot_ICMS_ST=@Vlr_Tot_ICMS_ST,
					Vlr_Tot_Prod_Serv=@Vlr_Tot_Prod_Serv,
					Vlr_Tot_Frete=@Vlr_Tot_Frete,
					Vlr_Tot_Seguro=@Vlr_Tot_Seguro,
					Vlr_Tot_Desconto=@Vlr_Tot_Desconto,
					Vlr_Tot_IPI=@Vlr_Tot_IPI,
					Vlr_Tot_PIS=@Vlr_Tot_PIS,
					Vlr_Tot_Cofins=@Vlr_Tot_Cofins,
					Vlr_Tot_Outras_Desp=@Vlr_Tot_Outras_Desp,
					Cd_Transp=@Cd_Transp,
					Info_Complementar=@Info_Complementar,
					Dt_Envio_RM=@Dt_Envio_RM
				WHERE  
					Num_Proc = @Num_Proc and ID_NF= @ID_NF

					set @ID_New = @ID_NF
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

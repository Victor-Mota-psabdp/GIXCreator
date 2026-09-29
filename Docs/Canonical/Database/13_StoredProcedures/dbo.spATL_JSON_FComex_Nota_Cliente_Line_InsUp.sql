SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 02-01-2025 - antonio ajuste para aceitar a nota fiscal e o processo 
--  permitindo gravar mais de uma nota fiscal no mesmo processo 
-- 12-03-2026 =  acrescentara  data de inclusão da nota fical na tabela
-- 01-04-2026 - colocar o ponteiro da nota fiscal para comparar com o item recebido ("processo_nfe_id": 61403,)

CREATE procedure [dbo].[spATL_JSON_FComex_Nota_Cliente_Line_InsUp]
	@Id_Processo [bigint],
	@CNPJ [varchar](200) NULL,
	@Nota_Fiscal [varchar](200) NULL,
	@Emissao [varchar](200) NULL,
	@CFOP [varchar](200) NULL,
	@Invoice [varchar](200) NULL,
	@Cd_Exportador [varchar](200) NULL,
	@Vlr_NF [varchar](200) NULL,
	@CD_Cliente [varchar](200) NULL,
	@Complementar [varchar](200) NULL,
	@DI [varchar](200) NULL,
	@Data_DI [varchar](200) NULL,
	@Paridade [varchar](200) NULL,
	@Custo [varchar](200) NULL,
	@Envio [varchar](200) NULL,
	@data_envio [varchar](200) NULL,
	@Mensagem_Erro [varchar](200) NULL,
	@CNPJ_Destinatario [varchar](200) NULL,
	@Serie [varchar](200) NULL,
	@IntNLog [varchar](200) NULL,
	@IntNAleatorio [varchar](200) NULL,
	@intDigitoControle [varchar](200) NULL,
	@Cd_IBGE_Municipio_Gerador [varchar](200) NULL,
	@Cd_IBGE_Municipio_Emitente [varchar](200) NULL,
	@Cd_IBGE_Municipio_Destinatario [varchar](200) NULL,
	@Cd_Pais_BACEN [varchar](200) NULL,
	@Vlr_Tot_Base_ICMS [varchar](200) NULL,
	@Vlr_Tot_ICMS [varchar](200) NULL,
	@Vlr_Tot_Base_ICMS_ST [varchar](200) NULL,
	@Vlr_Tot_ICMS_ST [varchar](200) NULL,
	@Vlr_Tot_Prod_Serv [varchar](200) NULL,
	@Vlr_Tot_Frete [varchar](200) NULL,
	@Vlr_Tot_Seguro [varchar](200) NULL,
	@Vlr_Tot_Desconto [varchar](200) NULL,
	@Vlr_Tot_IPI [varchar](200) NULL,
	@Vlr_Tot_PIS [varchar](200) NULL,
	@Vlr_Tot_Cofins [varchar](200) NULL,
	@Vlr_Tot_Outras_Desp [varchar](200) NULL,
	@Cd_Transp [varchar](200) NULL,
	@Info_Complementar [varchar](200) NULL,
	@Processo_Nfe_Id [bigint],
	@ItemsTotalPages [int],
	@ItemsTotalQty [int],
	@ItemsTotalIncluded [int],
	@Dt_Envio_RM [varchar](200) NULL
	   	  
AS
BEGIN
BEGIN TRANSACTION;
--Exceção(try/CATCH)
--Transação
--sp_help JSON_FComex_Nota_Cliente 

	BEGIN TRY
		IF exists(select @Id_Processo from ATL_INT.dbo.JSON_FComex_Nota_Cliente_Line 
		          where Id_Processo = @Id_Processo
				  and   Nota_Fiscal = @Nota_Fiscal)
			Begin
				Update
					ATL_INT.dbo.JSON_FComex_Nota_Cliente_Line
				Set					
					[CNPJ] =@CNPJ,
					[Emissao] = @Emissao,
					[CFOP]=  @CFOP,
					[Invoice] =@Invoice,
					[Cd_Exportador] =@Cd_Exportador,
					[Vlr_NF]=@Vlr_NF,
					[CD_Cliente] =@CD_Cliente,
					[Complementar]=@Complementar,
					[DI]=@DI,
					[Data_DI] =@Data_DI,
					[Paridade] =@Paridade,
					[Custo] =@Custo,
					[Envio] =@Envio,
					[data_envio] =@data_envio,
					[Mensagem_Erro] = @Mensagem_Erro,
					[CNPJ_Destinatario] =@CNPJ_Destinatario,
					[Serie] = @Serie,
					[IntNLog] =@IntNLog,
					[IntNAleatorio]=@IntNAleatorio,
					[intDigitoControle]=@intDigitoControle,
					[Cd_IBGE_Municipio_Gerador]=@Cd_IBGE_Municipio_Gerador,
					[Cd_IBGE_Municipio_Emitente]=@Cd_IBGE_Municipio_Emitente,
					[Cd_IBGE_Municipio_Destinatario] =@Cd_IBGE_Municipio_Destinatario,
					[Cd_Pais_BACEN]=@Cd_Pais_BACEN,
					[Vlr_Tot_Base_ICMS]=@Vlr_Tot_Base_ICMS,
					[Vlr_Tot_ICMS]=@Vlr_Tot_ICMS,
					[Vlr_Tot_Base_ICMS_ST]=@Vlr_Tot_Base_ICMS_ST,
					[Vlr_Tot_ICMS_ST]=@Vlr_Tot_ICMS_ST,
					[Vlr_Tot_Prod_Serv]=@Vlr_Tot_Prod_Serv,
					[Vlr_Tot_Frete]=@Vlr_Tot_Frete,
					[Vlr_Tot_Seguro]=@Vlr_Tot_Seguro,
					[Vlr_Tot_Desconto]=@Vlr_Tot_Desconto,
					[Vlr_Tot_IPI]=@Vlr_Tot_IPI,
					[Vlr_Tot_PIS]=@Vlr_Tot_PIS,
					[Vlr_Tot_Cofins]=@Vlr_Tot_Cofins,
					[Vlr_Tot_Outras_Desp]=@Vlr_Tot_Outras_Desp,
					[Cd_Transp]=@Cd_Transp,
					[Info_Complementar]=@Info_Complementar,
					[Processo_Nfe_Id]=@processo_nfe_id,
					[ItemsTotalPages] =	@ItemsTotalPages,
					[ItemsTotalQty] = @ItemsTotalQty,
					[ItemsTotalIncluded] = @ItemsTotalIncluded,
					[Dt_Envio_RM] =@Dt_Envio_RM
				Where
					Id_Processo = @Id_Processo
				and Nota_Fiscal = @Nota_Fiscal					
			End
		Else
			BEGIN
				Insert ATL_INT.dbo.JSON_FComex_Nota_Cliente_Line
				(
				    [id_processo],
					[CNPJ],
					[Nota_Fiscal],
					[Emissao],
					[CFOP],
					[Invoice],
					[Cd_Exportador],
					[Vlr_NF],
					[CD_Cliente],
					[Complementar],
					[DI],
					[Data_DI],
					[Paridade],
					[Custo],
					[Envio],
					[data_envio],
					[Mensagem_Erro],
					[CNPJ_Destinatario],
					[Serie],
					[IntNLog],
					[IntNAleatorio],
					[intDigitoControle],
					[Cd_IBGE_Municipio_Gerador],
					[Cd_IBGE_Municipio_Emitente],
					[Cd_IBGE_Municipio_Destinatario],
					[Cd_Pais_BACEN],
					[Vlr_Tot_Base_ICMS],
					[Vlr_Tot_ICMS],
					[Vlr_Tot_Base_ICMS_ST],
					[Vlr_Tot_ICMS_ST],
					[Vlr_Tot_Prod_Serv],
					[Vlr_Tot_Frete],
					[Vlr_Tot_Seguro],
					[Vlr_Tot_Desconto],
					[Vlr_Tot_IPI],
					[Vlr_Tot_PIS],
					[Vlr_Tot_Cofins],
					[Vlr_Tot_Outras_Desp],
					[Cd_Transp],
					[Info_Complementar],
					[Processo_Nfe_Id],
					[ItemsTotalPages], 
					[ItemsTotalQty],
					[ItemsTotalIncluded],
					[Dt_Envio_RM],
					[Dt_Ins]
				)
				Values
				(  
				    @id_Processo,
					@CNPJ,
					@Nota_Fiscal,
					@Emissao,
					@CFOP,
					@Invoice,
					@Cd_Exportador,
					@Vlr_NF,
					@CD_Cliente,
					@Complementar,
					@DI,
					@Data_DI,
					@Paridade,
					@Custo,
					@Envio,
					@data_envio,
					@Mensagem_Erro,
					@CNPJ_Destinatario,
					@Serie,
					@IntNLog,
					@IntNAleatorio,
					@intDigitoControle,
					@Cd_IBGE_Municipio_Gerador,
					@Cd_IBGE_Municipio_Emitente,
					@Cd_IBGE_Municipio_Destinatario,
					@Cd_Pais_BACEN,
					@Vlr_Tot_Base_ICMS,
					@Vlr_Tot_ICMS,
					@Vlr_Tot_Base_ICMS_ST,
					@Vlr_Tot_ICMS_ST,
					@Vlr_Tot_Prod_Serv,
					@Vlr_Tot_Frete,
					@Vlr_Tot_Seguro,
					@Vlr_Tot_Desconto,
					@Vlr_Tot_IPI,
					@Vlr_Tot_PIS,
					@Vlr_Tot_Cofins,
					@Vlr_Tot_Outras_Desp,
					@Cd_Transp,
					@Info_Complementar,
					@Processo_Nfe_Id,
					@ItemsTotalPages,
					@ItemsTotalQty,
					@ItemsTotalIncluded,
					@Dt_Envio_RM,
					getdate()
				)
			END	
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	
END
GO

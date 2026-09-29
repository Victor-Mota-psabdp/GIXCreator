SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Nota_Cliente_Sel]
(  
	@ID_NF				bigint, 
	@Nota_Fiscal		VarChar(20),  
	@Cd_Cliente			VarChar(10),
	@Num_Proc			VarChar(16),
	@Tipo				CHAR(1)  
)  
AS 

--sp_help Nota_Cliente
IF @Tipo = 'A'  
	BEGIN  
		SELECT 
			NC.ID_NF,
			NC.CNPJ,
			NC.Nota_Fiscal,
			NC.Emissao,
			NC.CFOP,
			NC.Invoice,
			NC.Cd_Exportador,
			NC.Vlr_NF,
			NC.CD_Cliente [Client Code],
			P.APelido	[Client Name],
			NC.Complementar,
			NC.ID_NF_FK,
			NC.DI,
			NC.Data_DI,
			NC.Paridade,
			NC.Num_Proc,
			NC.Custo,
			NC.Envio,
			NC.data_envio,
			NC.Mensagem_Erro,
			NC.CNPJ_Destinatario,
			NC.Serie,
			NC.IntNLog,
			NC.IntNAleatorio,
			NC.intDigitoControle,
			NC.Cd_IBGE_Municipio_Gerador,
			NC.Cd_IBGE_Municipio_Emitente,
			NC.Cd_IBGE_Municipio_Destinatario,
			NC.Cd_Pais_BACEN,
			NC.Vlr_Tot_Base_ICMS,
			NC.Vlr_Tot_ICMS,
			NC.Vlr_Tot_Base_ICMS_ST,
			NC.Vlr_Tot_ICMS_ST,
			NC.Vlr_Tot_Prod_Serv,
			NC.Vlr_Tot_Frete,
			NC.Vlr_Tot_Seguro,
			NC.Vlr_Tot_Desconto,
			NC.Vlr_Tot_IPI,
			NC.Vlr_Tot_PIS,
			NC.Vlr_Tot_Cofins,
			NC.Vlr_Tot_Outras_Desp,
			NC.Cd_Transp,
			NC.Info_Complementar,
			NC.Dt_Envio_RM
		FROM Nota_Cliente NC with (NOLOCK)
			JOIN Pessoa P with (NOLOCK)	ON P.Cd_Pes	 = NC.Cd_Cliente 
		Where
			NC.ID_NF= @ID_NF	
	END  

IF  @Tipo = 'B'  
	BEGIN  
		SELECT 
			NC.ID_NF,
			NC.CNPJ,
			NC.Nota_Fiscal,
			NC.Emissao,
			NC.CFOP,
			NC.Invoice,
			NC.Cd_Exportador,
			NC.Vlr_NF,
			NC.CD_Cliente [Client Code],
			P.APelido	[Client Name],
			NC.Complementar,
			NC.ID_NF_FK,
			NC.DI,
			NC.Data_DI,
			NC.Paridade,
			NC.Num_Proc,
			NC.Custo,
			NC.Envio,
			NC.data_envio,
			NC.Mensagem_Erro,
			NC.CNPJ_Destinatario,
			NC.Serie,
			NC.IntNLog,
			NC.IntNAleatorio,
			NC.intDigitoControle,
			NC.Cd_IBGE_Municipio_Gerador,
			NC.Cd_IBGE_Municipio_Emitente,
			NC.Cd_IBGE_Municipio_Destinatario,
			NC.Cd_Pais_BACEN,
			NC.Vlr_Tot_Base_ICMS,
			NC.Vlr_Tot_ICMS,
			NC.Vlr_Tot_Base_ICMS_ST,
			NC.Vlr_Tot_ICMS_ST,
			NC.Vlr_Tot_Prod_Serv,
			NC.Vlr_Tot_Frete,
			NC.Vlr_Tot_Seguro,
			NC.Vlr_Tot_Desconto,
			NC.Vlr_Tot_IPI,
			NC.Vlr_Tot_PIS,
			NC.Vlr_Tot_Cofins,
			NC.Vlr_Tot_Outras_Desp,
			NC.Cd_Transp,
			NC.Info_Complementar,
			NC.Dt_Envio_RM
		FROM Nota_Cliente NC with (NOLOCK)
			JOIN Pessoa P with (NOLOCK)	ON P.Cd_Pes	 = NC.Cd_Cliente 
		Where
			NC.Num_Proc= @Num_Proc
	END  
  
IF @Tipo = 'C'  
	BEGIN 
		SELECT 
			NC.ID_NF,
			NC.CNPJ,
			NC.Nota_Fiscal,
			NC.Emissao,
			NC.CFOP,
			NC.Invoice,
			NC.Cd_Exportador,
			NC.Vlr_NF,
			NC.CD_Cliente [Client Code],
			P.APelido	[Client Name],
			NC.Complementar,
			NC.ID_NF_FK,
			NC.DI,
			NC.Data_DI,
			NC.Paridade,
			NC.Num_Proc,
			NC.Custo,
			NC.Envio,
			NC.data_envio,
			NC.Mensagem_Erro,
			NC.CNPJ_Destinatario,
			NC.Serie,
			NC.IntNLog,
			NC.IntNAleatorio,
			NC.intDigitoControle,
			NC.Cd_IBGE_Municipio_Gerador,
			NC.Cd_IBGE_Municipio_Emitente,
			NC.Cd_IBGE_Municipio_Destinatario,
			NC.Cd_Pais_BACEN,
			NC.Vlr_Tot_Base_ICMS,
			NC.Vlr_Tot_ICMS,
			NC.Vlr_Tot_Base_ICMS_ST,
			NC.Vlr_Tot_ICMS_ST,
			NC.Vlr_Tot_Prod_Serv,
			NC.Vlr_Tot_Frete,
			NC.Vlr_Tot_Seguro,
			NC.Vlr_Tot_Desconto,
			NC.Vlr_Tot_IPI,
			NC.Vlr_Tot_PIS,
			NC.Vlr_Tot_Cofins,
			NC.Vlr_Tot_Outras_Desp,
			NC.Cd_Transp,
			NC.Info_Complementar,
			NC.Dt_Envio_RM
		FROM Nota_Cliente NC with (NOLOCK)
			JOIN Pessoa P with (NOLOCK)	ON P.Cd_Pes	 = NC.Cd_Cliente 
		Where			
			NC.Num_Proc= @Num_Proc and NC.Nota_Fiscal = @Nota_Fiscal
	END

IF @Tipo = 'D'  
	BEGIN 
		SELECT 
			NC.ID_NF,
			NC.CNPJ,
			NC.Nota_Fiscal,
			NC.Emissao,
			NC.CFOP,
			NC.Invoice,
			NC.Cd_Exportador,
			NC.Vlr_NF,
			NC.CD_Cliente [Client Code],
			P.APelido	[Client Name],
			NC.Complementar,
			NC.ID_NF_FK,
			NC.DI,
			NC.Data_DI,
			NC.Paridade,
			NC.Num_Proc,
			NC.Custo,
			NC.Envio,
			NC.data_envio,
			NC.Mensagem_Erro,
			NC.CNPJ_Destinatario,
			NC.Serie,
			NC.IntNLog,
			NC.IntNAleatorio,
			NC.intDigitoControle,
			NC.Cd_IBGE_Municipio_Gerador,
			NC.Cd_IBGE_Municipio_Emitente,
			NC.Cd_IBGE_Municipio_Destinatario,
			NC.Cd_Pais_BACEN,
			NC.Vlr_Tot_Base_ICMS,
			NC.Vlr_Tot_ICMS,
			NC.Vlr_Tot_Base_ICMS_ST,
			NC.Vlr_Tot_ICMS_ST,
			NC.Vlr_Tot_Prod_Serv,
			NC.Vlr_Tot_Frete,
			NC.Vlr_Tot_Seguro,
			NC.Vlr_Tot_Desconto,
			NC.Vlr_Tot_IPI,
			NC.Vlr_Tot_PIS,
			NC.Vlr_Tot_Cofins,
			NC.Vlr_Tot_Outras_Desp,
			NC.Cd_Transp,
			NC.Info_Complementar,
			NC.Dt_Envio_RM
		FROM Nota_Cliente NC with (NOLOCK)
			JOIN Pessoa P with (NOLOCK)	ON P.Cd_Pes	 = NC.Cd_Cliente 
		Where
			NC.ID_NF= @ID_NF 
	END  

--IF @Tipo = 'N'  
--	BEGIN  
--		SELECT 
--			NC.ID_NF,
--			NC.CNPJ,
--			NC.Nota_Fiscal,
--			NC.Emissao,
--			NC.CFOP,
--			NC.Invoice,
--			NC.Cd_Exportador,
--			NC.Vlr_NF,
--			NC.CD_Cliente [Client Code],
--			P.APelido	[Client Name],
--			NC.Complementar,
--			NC.ID_NF_FK,
--			NC.DI,
--			NC.Data_DI,
--			NC.Paridade,
--			NC.Num_Proc,
--			NC.Custo,
--			NC.Envio,
--			NC.data_envio,
--			NC.Mensagem_Erro,
--			NC.CNPJ_Destinatario,
--			NC.Serie,
--			NC.IntNLog,
--			NC.IntNAleatorio,
--			NC.intDigitoControle,
--			NC.Cd_IBGE_Municipio_Gerador,
--			NC.Cd_IBGE_Municipio_Emitente,
--			NC.Cd_IBGE_Municipio_Destinatario,
--			NC.Cd_Pais_BACEN,
--			NC.Vlr_Tot_Base_ICMS,
--			NC.Vlr_Tot_ICMS,
--			NC.Vlr_Tot_Base_ICMS_ST,
--			NC.Vlr_Tot_ICMS_ST,
--			NC.Vlr_Tot_Prod_Serv,
--			NC.Vlr_Tot_Frete,
--			NC.Vlr_Tot_Seguro,
--			NC.Vlr_Tot_Desconto,
--			NC.Vlr_Tot_IPI,
--			NC.Vlr_Tot_PIS,
--			NC.Vlr_Tot_Cofins,
--			NC.Vlr_Tot_Outras_Desp,
--			NC.Cd_Transp,
--			NC.Info_Complementar,
--			NC.Dt_Envio_RM
--		FROM Nota_Cliente NC with (NOLOCK)
--			JOIN Pessoa P with (NOLOCK)	ON P.Cd_Pes	 = NC.Cd_Cliente 
--		WHERE 
--			ACC.cd_bank = @cd_bank 
--	END
	
--IF @Tipo = 'O'  
--	BEGIN  
--		SELECT 
--			NC.ID_NF,
--			NC.CNPJ,
--			NC.Nota_Fiscal,
--			NC.Emissao,
--			NC.CFOP,
--			NC.Invoice,
--			NC.Cd_Exportador,
--			NC.Vlr_NF,
--			NC.CD_Cliente [Client Code],
--			P.APelido	[Client Name],
--			NC.Complementar,
--			NC.ID_NF_FK,
--			NC.DI,
--			NC.Data_DI,
--			NC.Paridade,
--			NC.Num_Proc,
--			NC.Custo,
--			NC.Envio,
--			NC.data_envio,
--			NC.Mensagem_Erro,
--			NC.CNPJ_Destinatario,
--			NC.Serie,
--			NC.IntNLog,
--			NC.IntNAleatorio,
--			NC.intDigitoControle,
--			NC.Cd_IBGE_Municipio_Gerador,
--			NC.Cd_IBGE_Municipio_Emitente,
--			NC.Cd_IBGE_Municipio_Destinatario,
--			NC.Cd_Pais_BACEN,
--			NC.Vlr_Tot_Base_ICMS,
--			NC.Vlr_Tot_ICMS,
--			NC.Vlr_Tot_Base_ICMS_ST,
--			NC.Vlr_Tot_ICMS_ST,
--			NC.Vlr_Tot_Prod_Serv,
--			NC.Vlr_Tot_Frete,
--			NC.Vlr_Tot_Seguro,
--			NC.Vlr_Tot_Desconto,
--			NC.Vlr_Tot_IPI,
--			NC.Vlr_Tot_PIS,
--			NC.Vlr_Tot_Cofins,
--			NC.Vlr_Tot_Outras_Desp,
--			NC.Cd_Transp,
--			NC.Info_Complementar,
--			NC.Dt_Envio_RM
--		FROM Nota_Cliente NC with (NOLOCK)
--			JOIN Pessoa P with (NOLOCK)	ON P.Cd_Pes	 = NC.Cd_Cliente 
--		WHERE 
--			ACC.cd_bank	= @cd_bank and ACC.Cd_Agency= @Cd_Agency
--	END  

  

GO

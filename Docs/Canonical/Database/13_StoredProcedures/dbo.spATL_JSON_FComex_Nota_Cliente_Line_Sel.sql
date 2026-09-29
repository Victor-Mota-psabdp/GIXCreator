SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_JSON_FComex_Nota_Cliente_Line_Sel]
	@Id_Processo [bigint],
	@Nota_Fiscal varchar(200), 
	@Processo_Nfe_Id [bigint], 
	@Tipo varchar(1)
AS
/*02-01-2026 amarrara as notas fiscais no select 
   A - pegar todos 
   C - Pegar unico  com CFOP amarrar a nota fiscal mas verificar se
       ja tem a quantidade de itens ja na tabela 
   D - Pegar unico           amarrar a nota fiscal  
06-04-2026 - incluir os campos de paginação 
   E - Comparar se todos os itnes ja subiram para a tabela de integração 
   F - localizar a nota com o Id da nota fiscal  
*/


if @Tipo ='A'
			Begin
				Select		
				    [Id_Processo],
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
                from ATL_INT.dbo.JSON_FComex_Nota_Cliente_Line
				Order by Id_Processo 	
			End
if @Tipo ='C'
			Begin
				Select		
				    [Id_Processo],
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
                from ATL_INT.dbo.JSON_FComex_Nota_Cliente_Line
				Where
					Id_Processo = @Id_Processo 	
				and  LEN([CFOP])=4
				and  CAST([ItemsTotalIncluded] as INT) = cast([ItemsTotalQty] as INT) 
			End
if @Tipo ='D'
			Begin
				Select		
				    [Id_Processo],
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
                from ATL_INT.dbo.JSON_FComex_Nota_Cliente_Line
				Where
					Id_Processo = @Id_Processo 	
					and Nota_Fiscal = @Nota_Fiscal
			End

if @Tipo ='E'
			Begin
				Select		
				    [Id_Processo],
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
					[Dt_Envio_RM],
					[Processo_Nfe_Id],
					[ItemsTotalPages], 
					[ItemsTotalQty],
					[ItemsTotalIncluded],
					[Dt_Ins]
                from ATL_INT.dbo.JSON_FComex_Nota_Cliente_Line
				Where CAST([ItemsTotalIncluded] as INT) < cast([ItemsTotalQty] as INT)   
			End
if @Tipo ='F'
			Begin
				Select		
				    [Id_Processo],
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
                from ATL_INT.dbo.JSON_FComex_Nota_Cliente_Line
				Where
					Id_Processo = @Id_Processo 	
					and Processo_Nfe_Id = @Processo_Nfe_Id
End
GO

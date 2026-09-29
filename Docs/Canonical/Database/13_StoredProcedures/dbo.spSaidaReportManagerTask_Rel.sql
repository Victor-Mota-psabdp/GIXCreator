SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSaidaReportManagerTask_Rel]
	@Num_Proc	Varchar(16)
AS
	select
		distinct @Num_Proc Job,
		 Null CCD,
		 Null GR,
		 Null GI,
		
		NULL Presenca ,--[dbo].[fBusca_Tarefa](@Num_Proc,15) Presenca,,Cadu 04/02/2015		
		NULL Doc_Deliv, --[dbo].[fBusca_Tarefa](@Num_Proc,7) Doc_Deliv, ,Cadu 06/02/2015		
		NULL Digitacao_DI, --[dbo].[fBusca_Tarefa](@Num_Proc,27) Digitacao_DI,,Cadu 04/02/2015		
		NULL Remocao, --[dbo].[fBusca_Tarefa](@Num_Proc,19) Remocao,,Cadu 04/02/2015
		
		Null Faturamento,
		Null GR_E, 
		Null GI_E,		
		 
		NULL Desova ,--[dbo].[fBusca_Tarefa](@Num_Proc,29) Desova,Cadu 04/02/2015		
		NULL FileOpen, --[dbo].[fBusca_Tarefa](@Num_Proc,60) FileOpen,Cadu 04/02/2015		
		NULL SolAdto, --[dbo].[fBusca_Tarefa](@Num_Proc,59) SolAdto,Cadu 04/02/2015		
		NULL Redistinacao, --[dbo].[fBusca_Tarefa](@Num_Proc,42) Redistinacao,Cadu 04/02/2015
		
		Null PgtoAFRMM,
		
		NULL EnvioCobranca, --[dbo].[fBusca_Tarefa](@Num_Proc,78) EnvioCobranca,	Cadu 04/02/2015	
		NULL DocsReceived, --[dbo].[fBusca_Tarefa](@Num_Proc,16) DocsReceived,Cadu 04/02/2015	
		
		Null EnvioCHBFaturamento,
		
		NULL Dt_SI, --[dbo].[fBusca_Tarefa](@Num_Proc,45) Dt_SI,Cadu 04/02/2015		
		NULL Dt_Aut, --[dbo].[fBusca_Tarefa](@Num_Proc,39) Dt_Aut,Cadu 04/02/2015	
		
		NULL Doc_Sent, --[dbo].[fBusca_Tarefa](@Num_Proc,12) Doc_Sent,já estava desabilitado no VB6 - CADU 08/02/2015
				
		
		NULL Def_LI, --[dbo].[fBusca_Tarefa](@Num_Proc,20) Def_LI,,Cadu 04/02/2015		
		
		Null Dt_Entrada_Terminal, 
		Null Dt_DraftNFE,
		
		NULL Envio_Prestacao, --[dbo].[fBusca_Tarefa](@Num_Proc,40) Envio_Prestacao,Cadu 04/02/2015		
		NULL Emissao_BLBR, --[dbo].[fBusca_Tarefa](@Num_Proc,80) Emissao_BLBR, Cadu 04/02/2015	
		
		Null Envio_Originais_BLBR,	
		Null Devol_BLBR, 
		
		NULL Recebimento_Draft, --[dbo].[fBusca_Tarefa](@Num_Proc,83) Recebimento_Draft,	 Cadu 04/02/2015	
		NULL Envio_Draft_Cliente, --[dbo].[fBusca_Tarefa](@Num_Proc,84) Envio_Draft_Cliente,  Cadu 04/02/2015		
		NULL Retorno_Draft_Cliente, --[dbo].[fBusca_Tarefa](@Num_Proc,85) Retorno_Draft_Cliente,Cadu 04/02/2015
		
				
		NULL LibBL, --[dbo].[fBusca_Tarefa](@Num_Proc,21) LibBL, --Cadu 11/02/2015	
				
		
		Null Madeira, 
		Null Cambio,
		
		NULL LibDTA ,--[dbo].[fBusca_Tarefa](@Num_Proc,18) LibDTA ,Cadu 04/02/2015		
		Null SolLI, --[dbo].[fBusca_Tarefa](@Num_Proc,46) SolLI,Cadu 04/02/2015
				
		NULL Doc_1,--[dbo].[fBusca_Tarefa](@Num_Proc,89) Doc_1,		
		NULL Rec_Doc_1,--[dbo].[fBusca_Tarefa](@Num_Proc,90) Rec_Doc_1,
		NULL Def_1,--[dbo].[fBusca_Tarefa](@Num_Proc,91) Def_1,
		NULL Doc_2,--[dbo].[fBusca_Tarefa](@Num_Proc,92) Doc_2,
		NULL Def_2,--[dbo].[fBusca_Tarefa](@Num_Proc,93) Def_2,
		
		NULL PREFaturamento, --[dbo].[fBusca_Tarefa](@Num_Proc,79) PREFaturamento, Cadu 04/02/2015
				
		Null Averbacao_Exp, 
		Null EnvioCapa ,
		
		NULL EnvioShipping, --[dbo].[fBusca_Tarefa](@Num_Proc,45) EnvioShipping, Cadu 04/02/2015
		
		Null EnvioCustoEstimado,
		Null enviocustorevisado,
		
		--este não era utilizado, o certo é Solic_Booking
		NULL  Sol_Booking, --[dbo].[fBusca_Tarefa](@Num_Proc,58) Sol_Booking,
		
		Null Booking,
		Null Solicitacao_Agenda,
		Null Confirmacao_Agenda,
		
		NULL Confirmacao_Carregamento, --[dbo].[fBusca_Tarefa](@Num_Proc,100) Confirmacao_Carregamento,Cadu 04/02/2015
		
		Null Primeira_Previsao,
		Null Segunda_Previsao,
		
		NULL Draft_Exp, --[dbo].[fBusca_Tarefa](@Num_Proc,66) Draft_Exp, Cadu 04/02/2015
		
		Null REC_Item_BDP,
		Null REC_Item_WM, 
		
		NULL Draft_Imp, --[dbo].[fBusca_Tarefa](@Num_Proc,41) Draft_Imp,Cadu 04/02/2015		
		NULL Averbacao_imp,--[dbo].[fBusca_Tarefa](@Num_Proc,68) Averbacao_imp, ,Cadu 05/02/2015
		
		Null Recebimento_Processo,
		Null Faturamento_Criado, 		
		Null Solicita_Posicionamento,
		
		NULL Posicionamento_Efetivo,--[dbo].[fBusca_Tarefa](@Num_Proc,104) Posicionamento_Efetivo, ,Cadu 05/02/2015		
		NULL InspMAPA, --[dbo].[fBusca_Tarefa](@Num_Proc,105)InspMAPA,,Cadu 05/02/2015		
		NULL DocsPRestrito, --[dbo].[fBusca_Tarefa](@Num_Proc,63) DocsPRestrito,	 ,Cadu 05/02/2015	
		NULL RegSiscarga, --[dbo].[fBusca_Tarefa](@Num_Proc,903) RegSiscarga, 	 ,Cadu 05/02/2015		
		NULL Manifesto, --[dbo].[fBusca_Tarefa](@Num_Proc,8) Manifesto,	,Cadu 05/02/2015	
		NULL ProcessoOKPPG, --[dbo].[fBusca_Tarefa](@Num_Proc,88) ProcessoOKPPG,	,Cadu 05/02/2015	 
		NULL EnvioVlores, --[dbo].[fBusca_Tarefa](@Num_Proc,87) EnvioVlores,,Cadu 05/02/2015		
		NULL RegProft, --[dbo].[fBusca_Tarefa](@Num_Proc,905) RegProft,,Cadu 05/02/2015	
		
			 
		NULL EnvioPreAlerta, --[dbo].[fBusca_Tarefa](@Num_Proc,1) EnvioPreAlerta, ,Cadu 05/02/2015
				
		
		Null EntrRequerimento,
		
		NULL ChegadaFronteira, --[dbo].[fBusca_Tarefa](@Num_Proc,31) ChegadaFronteira,,Cadu 05/02/2015		
		NULL Cumplido, --[dbo].[fBusca_Tarefa](@Num_Proc,6) Cumplido, ,Cadu 05/02/2015
		NULL Cumplido_Est, --[dbo].[fBusca_Tarefa_Prev](@Num_Proc,6) Cumplido_Est,  ,Cadu 05/02/2015
		NULL AnticipoDOC, --[dbo].[fBusca_Tarefa](@Num_Proc,202) AnticipoDOC,,Cadu 05/02/2015
		
		
		NULL Entrega_Cobr, --[dbo].[fBusca_Tarefa](@Num_Proc,201) Entrega_Cobr,	,Cadu 05/02/2015
				
			
		NULL Invoice_SentC, --[dbo].[fBusca_Tarefa](@Num_Proc,203) Invoice_SentC,,Cadu 05/02/2015
		
		NULL Cambio_BDP,  --[dbo].[fBusca_Tarefa](@Num_Proc,86)  Cambio_BDP, ,Cadu 05/02/2015
		NULL DANFE_Recebe, --[dbo].[fBusca_Tarefa](@Num_Proc,108)  DANFE_Recebe,  ,Cadu 05/02/2015
		NULL PrestacaoRecibo, --[dbo].[fBusca_Tarefa](@Num_Proc,77)  PrestacaoRecibo, ,Cadu 05/02/2015
		NULL Conf_DI, --[dbo].[fBusca_Tarefa](@Num_Proc,65)  Conf_DI,,Cadu 05/02/2015
		NULL Receb_MBL, --[dbo].[fBusca_Tarefa](@Num_Proc,110) Receb_MBL, ,Cadu 05/02/2015
		NULL Receb_HBL, --[dbo].[fBusca_Tarefa](@Num_Proc,111) Receb_HBL, ,Cadu 05/02/2015
		NULL Receb_LaudoArqueacao, --[dbo].[fBusca_Tarefa](@Num_Proc,114) Receb_LaudoArqueacao,,Cadu 05/02/2015
		
		
		NULL TransshipmentDeparture, --[dbo].[fBusca_Tarefa](@Num_Proc,37) TransshipmentDeparture, ,Cadu 05/02/2015
		
		NULL TransshipmentArrival, --[dbo].[fBusca_Tarefa](@Num_Proc,38) TransshipmentArrival, ,Cadu 05/02/2015
		
		
		
		NULL Solic_Booking --[dbo].[fBusca_Tarefa](@Num_Proc,58) Solic_Booking, Cadu 05/02/2015











GO

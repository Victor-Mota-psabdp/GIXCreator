SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--14/09/2020 - include the [FRemoveCaracteresEspeciais_Enter] - Cadu
CREATE FUNCTION [dbo].[fBusca_Alerta_Email_Doc_Automatico]--''  
(  
	 @Tipo varchar(25),  
	 @JOB varchar(16),  
	 @ID bigint,  
	 @cd_pes_grupo varchar(25),  
	 @cd_tp_carga int,  
	 @cd_org varchar(10),  
	 @cd_dst varchar(10),  
	 @cd_pes varchar(10),  
	 @Modal varchar(10),  
	 @cd_tp_pedido varchar(5),  
	 @Cd_Transportadora varchar(10),  
	 @Cd_Terminal varchar(10)  
)  
RETURNS Varchar(MAX)   
AS  
BEGIN  
   
 declare @Conteudo varchar(MAX)  
 declare @Temp varchar(200)  
  
 if @Tipo = 'Assunto'  
  Begin  
   set @Conteudo = (select Assunto from Alerta_Email_Doc_Automatico with(nolock) where ID = @ID  
       --and (Cd_Pes_Grupo = @cd_pes_grupo or Cd_Pes_Grupo = '10017')   
       and Cd_Pes_Grupo = @cd_pes_grupo and cd_tp_carga = @cd_tp_carga   
       and Cd_Org = @cd_org and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes   
       and Modal =@Modal and cd_tp_pedido = @cd_tp_pedido  
       and Cd_Transportadora = @Cd_Transportadora  
       and Cd_Terminal = @Cd_Terminal)  
  END  
 else  
  BEGIN  
   set @Conteudo = (select mensagem from Alerta_Email_Doc_Automatico with(nolock) where ID = @ID  
       --and (Cd_Pes_Grupo = @cd_pes_grupo or Cd_Pes_Grupo = '10017')  
       and Cd_Pes_Grupo = @cd_pes_grupo and cd_tp_carga = @cd_tp_carga   
       and Cd_Org = @cd_org and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes  
       and Modal =@Modal and cd_tp_pedido = @cd_tp_pedido  
       and Cd_Transportadora = @Cd_Transportadora  
       and Cd_Terminal = @Cd_Terminal)  
  END  
    
    
 set @Conteudo = replace(@conteudo,'@JOB_NUMBER',@JOB)  
   
   
--PRODUTOS  
 set @Temp = (select dbo.fBusca_PRODUTO(@JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@PRODUCTS',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@PRODUCTS',' ')    
    
    
--Soma da Quantidade de Produtos  
 set @Temp = (select dbo.fBusca_Qty_PRODUTO(@JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@QTY_SUM_PRODUCTS',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@QTY_SUM_PRODUCTS',' ')  
   
   
  
--TASKS  
 set @Temp = (select convert(varchar,dbo.fBusca_Tarefa(@JOB,'4'),103))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CUSTOMS_CLEARANCE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CUSTOMS_CLEARANCE',' ')  
 --100-148249  
 set @Temp = (select convert(varchar,dbo.fBusca_Tarefa(@JOB,'68'),103))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@IMPORTATION_VERIFICATION',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@IMPORTATION_VERIFICATION',' ')  
 --100-148249  
 set @Temp = (select convert(varchar,dbo.fBusca_Tarefa(@JOB,'15'),103))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@EXPORT_VERIFICATION',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@EXPORT_VERIFICATION',' ')  
    
  
--PO MODAL  
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'1'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@PO_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@PO_NUMBER',' ')  
    
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'2'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@INVOICE_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@INVOICE_NUMBER',' ')  
    
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'3'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@SALES_ORDER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@SALES_ORDER',' ')  
  
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'5'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@DI_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@DI_NUMBER',' ')  
    
 --100-148249    
 set @Temp = (select  convert(varchar,dbo.fBusca_DATA_PO_Modal(@JOB,'5'),103))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@DI_DATE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@DI_DATE',' ')  
  
--100-148249    
 set @Temp = (select  convert(varchar,dbo.fBusca_DATA_PO_Modal(@JOB,'204'),103))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@EXPORT_REGISTRATION',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@EXPORT_REGISTRATION',' ')  
  
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'4'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@RE_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@RE_NUMBER',' ')  
    
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'9'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CUSTOMER_PO',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CUSTOMER_PO',' ')  
    
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'29'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CE_MERCANTE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CE_MERCANTE',' ')  
  
  
--Peso_Liquido  
set @Temp = (select Convert(varchar(25),Peso_Liquido) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@NETWEIGHT',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@NETWEIGHT',' ')  
    
--Peso_Bruto  
set @Temp = (select Convert(varchar(25),Peso_Bruto) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@GROSSWEIGHT',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@GROSSWEIGHT',' ')  
    
--Peso_Cubado  
set @Temp = (select Convert(varchar(25),Peso_Cubado) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CHARGEABLE_WEIGHT',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CHARGEABLE_WEIGHT',' ')  
    
    
--Qtd_Tot_Vol  
set @Temp = (select Convert(varchar(25),Qtd_Tot_Vol) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@PIECES',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@PIECES',' ')  
    
--Vol_Tot  
set @Temp = (select Convert(varchar(25),Vol_Tot) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@VOLUME',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@VOLUME',' ')  
    
--BOOKING   
 set @Temp = (select Nr_Reserva from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@BOOKING',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@BOOKING',' ')   
  
--Terminal  
 set @Temp = (select nome_terminal from Terminal with(nolock) where Cd_Terminal in (  
    select Cd_Terminal from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@TERMINAL',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@TERMINAL',' ')  
  
--BUSCA DATAS LLP   
 set @Temp = (select convert(varchar,ATD,103) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@ATD',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@ATD',' ')  
   
 set @Temp = (select convert(varchar,ATA,103) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@ATA',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@ATA',' ')  
   
 set @Temp = (select convert(varchar,ETD,103) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@ETD',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@ETD',' ')  
   
 set @Temp = (select convert(varchar,ETA,103) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@ETA',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@ETA',' ')  
    
-- Transit Time   
 set @Temp = (select convert(varchar,DATEDIFF(day,ETD,ETA),103) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@TRANSIT_TIME',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@TRANSIT_TIME',' ')  
    
-- Transit Time Ref.Adic  
 set @Temp = (select convert(varchar,TransitTime,103) from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@TRANSITTIME_REF_ADIC',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@TRANSITTIME_REF_ADIC',' ')  
  
--BUSCA RAZAO SOCIAL  
 set @Temp = (select nome_raz_soc from pessoa with(nolock) where cd_pes in (  
     select cd_export from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@SHIPPER',@Temp)  
  
 set @Temp = (select nome_raz_soc from pessoa with(nolock) where cd_pes in (  
     select cd_consig from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))   
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CONSIGNEE',@Temp)  
  
 set @Temp = (select nome_raz_soc from pessoa with(nolock) where cd_pes in (  
     select cd_notify from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@NOTIFY',@Temp)  
  
--NAVIO  
 set @Temp = (select Navio from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)      
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@VESSEL',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@VESSEL',' ')  
    
--LOADING  
 set @Temp = (select nome_local from localidade with(nolock) where cd_local in   
    (select cd_org from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@PORT_LOADING',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@PORT_LOADING',' ')  
    
 set @Temp = (select Pais_Local from localidade with(nolock) where cd_local in   
    (select cd_org from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COUNTRY_LOADING',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COUNTRY_LOADING',' ')  
    
 set @Temp = (select Cd_Pais from localidade with(nolock) where cd_local in   
    (select cd_org from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COUNTRY_CODE_LOADING',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COUNTRY_CODE_LOADING',' ')  
  
--DISCHARGE  
 set @Temp = (select nome_local from localidade with(nolock) where cd_local in   
     (select cd_dst from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)) if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@PORT_DISCHARGE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@PORT_DISCHARGE',' ')  
    
 set @Temp = (select Pais_Local from localidade with(nolock) where cd_local in   
     (select cd_dst from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))      
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COUNTRY_DISCHARGE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COUNTRY_DISCHARGE',' ')  
    
 set @Temp = (select Cd_Pais from localidade with(nolock) where cd_local in   
     (select cd_dst from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))      
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COUNTRY_CODE_DISCHARGE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COUNTRY_CODE_DISCHARGE',' ')  
    
--MAWB  
 set @Temp = (select MAWB from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@MAWB',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@MAWB',' ')  
  
--HAWB  
 set @Temp = (select HAWB from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@BL_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@BL_NUMBER',' ')  
  
--COURIER  
 set @Temp = (select Courier_Number from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COURIER_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COURIER_NUMBER',' ')  
  
 set @Temp = (select nome_raz_soc from pessoa with(nolock) where cd_pes in   
    (select cd_courier from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COURIER_COMPANY',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COURIER_COMPANY',' ')  
   
--Notes  
 set @Temp = (select replace(Obs, char(13)+ char(10),'')    
  from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@Notes',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@Notes',' ')  
    
--Nature_Goods  
 set @Temp = (select Descr from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@DESCR_HANDLING_INFORMATIONS',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@DESCR_HANDLING_INFORMATIONS',' ')  
   
--Carrier  
 set @Temp = (select [dbo].[fBusca_Carrier](@JOB,'CARRIER'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CARRIER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CARRIER',' ')  
    
--Viagem  
 set @Temp = (select Voo_Viagem from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB)  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@VOYAGE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@VOYAGE',' ')   
    
--Incoterm  
 set @Temp = (Select Nome_Tp_Oper from Tipo_Oper with(nolock) where cd_tp_oper in   
     (select Cd_Tp_Oper from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))      
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@INCOTERM',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@INCOTERM',' ')   
   
--Tipo Container   
 set @Temp = (select [dbo].[fBusca_Containers](@JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CONTAINER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CONTAINER',' ')   
   
--Qty Container   
 set @Temp = (select [dbo].[qty_container](@JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@QTYCONTAINER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@QTYCONTAINER',' ')  
  
--Tipo Container   
 set @Temp = (select [dbo].[fBusca_TipoContainers](@JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@TYPE_CONTAINER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@TYPE_CONTAINER',' ')  
    
--CONTAINER_SEAL_TARE  
 set @Temp = (select [dbo].[fBusca_Containers_Lacre_Tara](@JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@SEAL_TARE_CONTAINER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@SEAL_TARE_CONTAINER',' ')  
   
  
-- Campo Cliente  
      
--Termo de Pagamento 87  
set @Temp = (select Descricao_Termo from Termo_Pagamento with(nolock) where Cd_Termo in (  
    select [dbo].[fBusca_CampoCliente](@JOB,'87')))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@TermodePagamento',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@TermodePagamento',' ')    
  
--149 10017 D Venc. 2º Periodo Armazenagem  
set @Temp = (select [dbo].[fBusca_CampoCliente](@JOB,'149'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@Venc2_PeriodoArmazenagem',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@Venc2_PeriodoArmazenagem',' ')  
    
--150 10017 D Venc. 1º Periodo Armazenagem  
set @Temp = (select [dbo].[fBusca_CampoCliente](@JOB,'150'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@Venc1_PeriodoArmazenagem',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@Venc1_PeriodoArmazenagem',' ')  
  
--138 FreeTime     
set @Temp = (select [dbo].[fBusca_CampoCliente](@JOB,'138'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@FREETIME',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@FREETIME',' ')  
    
--Product ID  
 set @Temp = (select dbo.fBusca_PRODUTOID(@JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@PRODUCT_ID',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@PRODUCT_ID',' ')   
    
--156 10017 I QTDE 1º PERÍODO DEMURRAGE    
set @Temp = (select [dbo].[fBusca_CampoCliente](@JOB,'156'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@QTDE1_PeriodoDemurrage',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@QTDE1_PeriodoDemurrage',' ')  
    
--157 10017 F VALOR 1º PERÍODO DEMURRAGE  
set @Temp = (select [dbo].[fBusca_CampoCliente](@JOB,'157'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@Vlr1_PeriodoDemurrage',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@Vlr1_PeriodoDemurrage',' ')  
    
--158 10017 F VALOR 2º PERÍODO DEMURRAGE  
set @Temp = (select [dbo].[fBusca_CampoCliente](@JOB,'158'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@Vlr2_PeriodoDemurrage',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@Vlr2_PeriodoDemurrage',' ')  
  
 --91 SC-Solicitação de Compras SC  
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'91'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@SC_SolicitacaodeCompras',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@SC_SolicitacaodeCompras',' ')  
   
-- dados da solicitação de LI   
set @Temp = (select dbo.fBusca_Solicitacao_LI_DadosCompletos(@JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@Solicitacao_LI_DadosCompletos',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@Solicitacao_LI_DadosCompletos',' ')  
    
--CHB Collaborator  
--167 10017 S CHB Collaborator  
 set @Temp = (Select Nome_Usuario from Usuario with(nolock) where cd_usuario in   
     (select [dbo].[fBusca_CampoCliente](@JOB,'167')))    
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CHB_Collaborator',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CHB_Collaborator',' ')  
    
--Urgente  
--36 10 B Urgente  
set @Temp = (Select Descricao from Verdade with(nolock) where id in   
     (select [dbo].[fBusca_CampoCliente](@JOB,'36')))    
 if @Temp is NOT null or @Temp <>''  
  set @Conteudo = replace(@conteudo,'@Urgente_REF_ADIC',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@Urgente_REF_ADIC','NÃO')  
    
--Drawback  
--44 10 B Drawback?  
set @Temp = (Select Descricao from Verdade with(nolock) where id in   
     (select [dbo].[fBusca_CampoCliente](@JOB,'44')))    
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@Drawback_REF_ADIC',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@Drawback_REF_ADIC',' ')  
  
  
--RETORNA O CONTEUDO 
if @Tipo = 'Assunto'  
	begin 
		set @Conteudo = (select [dbo].[FRemoveCaracteresEspeciais_Enter](@Conteudo))
	end
  
 RETURN @Conteudo  
END  
  
  
  
/*  
ALTER FUNCTION [dbo].[fBusca_Alerta_Email_Doc_Automatico]--''  
(  
 @Tipo varchar(25),  
 @JOB varchar(16),  
 @ID bigint,  
 @cd_pes_grupo varchar(25),  
 @cd_tp_carga int,  
 @cd_org varchar(10),  
 @cd_dst varchar(10),  
 @cd_pes varchar(10),  
 @Modal varchar(10),  
 @cd_tp_pedido varchar(5),  
 @Cd_Transportadora varchar(10)  
)  
RETURNS Varchar(MAX)   
AS  
BEGIN  
   
 declare @Conteudo varchar(MAX)  
 declare @Temp varchar(200)  
  
 if @Tipo = 'Assunto'  
  Begin  
   set @Conteudo = (select Assunto from Alerta_Email_Doc_Automatico where ID = @ID  
       --and (Cd_Pes_Grupo = @cd_pes_grupo or Cd_Pes_Grupo = '10017')   
       and Cd_Pes_Grupo = @cd_pes_grupo and cd_tp_carga = @cd_tp_carga   
       and Cd_Org = @cd_org and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes   
       and Modal =@Modal and cd_tp_pedido = @cd_tp_pedido  
       and Cd_Transportadora = @Cd_Transportadora)  
  END  
 else  
  BEGIN  
   set @Conteudo = (select mensagem from Alerta_Email_Doc_Automatico where ID = @ID  
       --and (Cd_Pes_Grupo = @cd_pes_grupo or Cd_Pes_Grupo = '10017')  
       and Cd_Pes_Grupo = @cd_pes_grupo and cd_tp_carga = @cd_tp_carga   
       and Cd_Org = @cd_org and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes  
       and Modal =@Modal and cd_tp_pedido = @cd_tp_pedido  
       and Cd_Transportadora = @Cd_Transportadora)  
  END  
    
    
 set @Conteudo = replace(@conteudo,'@JOB_NUMBER',@JOB)  
  
--PO MODAL  
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'1'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@PO_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@PO_NUMBER',' ')  
    
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'3'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@SALES_ORDER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@SALES_ORDER',' ')  
  
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'5'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@DI_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@DI_NUMBER',' ')  
  
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'4'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@RE_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@RE_NUMBER',' ')  
    
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'9'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CUSTOMER_PO',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CUSTOMER_PO',' ')  
    
 set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'29'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CE_MERCANTE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CE_MERCANTE',' ')  
    
    
--BOOKING  
 set @Temp = (select Nr_Reserva from llp_Imp_Mar where Num_Proc_LIM = @JOB  
    union all      
    select Nr_Reserva from Job_Exp_Mar where Num_Proc_HEM = @JOB  
    )  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@BOOKING',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@BOOKING',' ')  
   
 --estava incorreto, tem q pegar da tabela   
 --set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'130'))  
 --if @Temp is NOT null  
 -- set @Conteudo = replace(@conteudo,'@BOOKING',@Temp)  
 --else  
 -- set @Conteudo = replace(@conteudo,'@BOOKING',' ')  
  
  
--Terminal  
 set @Temp = (select nome_terminal from Terminal where Cd_Terminal in (  
    select Cd_Terminal from LLP_Imp_Aer where Num_Proc_Lia = @JOB  
    union all  
    select Cd_Terminal from llp_imp_mar where Num_Proc_Lim = @JOB  
    union all  
    select Cd_Terminal from llp_imp_out where Num_Proc_Lio = @JOB  
    union all  
    select Cd_Terminal from llp_exp_aer where Num_Proc_Lea = @JOB  
    union all  
    select Cd_Terminal from llp_exp_mar where Num_Proc_Lem = @JOB  
    union all  
    select Cd_Terminal from llp_exp_out where Num_Proc_Leo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@TERMINAL',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@TERMINAL',' ')  
  
--BUSCA DATAS LLP  
 set @Temp = (select convert(varchar,dbo.fBusca_Data(@JOB,'ATD'),103))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@ATD',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@ATD',' ')  
  
 set @Temp = (select convert(varchar,dbo.fBusca_Data(@JOB,'ATA'),103))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@ATA',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@ATA',' ')  
  
 set @Temp = (select convert(varchar,dbo.fBusca_Data(@JOB,'ETD'),103))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@ETD',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@ETD',' ')  
  
 set @Temp = (select convert(varchar,dbo.fBusca_Data(@JOB,'ETA'),103))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@ETA',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@ETA',' ')  
    
-- Transit Time  
 set @Temp = (select convert(varchar,DATEDIFF(day,dbo.fBusca_Data(@JOB,'ETD'),dbo.fBusca_Data(@JOB,'ETA')),103))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@TRANSIT_TIME',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@TRANSIT_TIME',' ')  
  
--BUSCA RAZO SOCIAL  
 set @Temp = (select nome_raz_soc from pessoa where cd_pes in (  
    select cd_export_hia from house_imp_aer where num_proc_hia = @JOB  
    union all  
    select cd_export_him from house_imp_mar where num_proc_him = @JOB  
    union all  
    select cd_export_hio from house_imp_out where num_proc_hio = @JOB  
    union all  
    select cd_export_hea from house_exp_aer where num_proc_hea = @JOB  
    union all  
    select cd_export_hem from house_exp_mar where num_proc_hem = @JOB  
    union all  
    select cd_export_heo from house_exp_out where num_proc_heo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@SHIPPER',@Temp)  
  
 set @Temp = (select nome_raz_soc from pessoa where cd_pes in (  
    select cd_consig_hia from house_imp_aer where num_proc_hia = @JOB  
    union all  
    select cd_consig_him from house_imp_mar where num_proc_him = @JOB  
    union all  
    select cd_consig_hio from house_imp_out where num_proc_hio = @JOB  
    union all  
    select cd_consig_hea from house_exp_aer where num_proc_hea = @JOB  
    union all  
    select cd_consig_hem from house_exp_mar where num_proc_hem = @JOB  
    union all  
    select cd_consig_heo from house_exp_out where num_proc_heo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CONSIGNEE',@Temp)  
  
 set @Temp = (select nome_raz_soc from pessoa where cd_pes in (  
    select cd_import_hia from house_imp_aer where num_proc_hia = @JOB  
    union all  
    select cd_import_him from house_imp_mar where num_proc_him = @JOB  
    union all  
    select cd_import_hio from house_imp_out where num_proc_hio = @JOB  
    union all  
    select cd_notify_hea from house_exp_aer where num_proc_hea = @JOB  
    union all  
    select cd_notify_hem from house_exp_mar where num_proc_hem = @JOB  
    union all  
    select cd_notify_heo from house_exp_out where num_proc_heo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@NOTIFY',@Temp)  
  
--NAVIO E LOCALIDADE  
 set @Temp = (select navio_him from house_imp_mar where num_proc_him = @JOB  
    union all  
    select navio_hem from house_exp_mar where num_proc_hem = @JOB  
    )  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@VESSEL',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@VESSEL',' ')  
    
--LOADING  
 set @Temp = (select nome_local from localidade where cd_local in (  
    select cd_org_hia from house_imp_aer where num_proc_hia = @JOB  
    union all  
    select cd_org_him from house_imp_mar where num_proc_him = @JOB  
    union all  
    select cd_org_hio from house_imp_out where num_proc_hio = @JOB  
    union all  
    select cd_org_hea from house_exp_aer where num_proc_hea = @JOB  
    union all  
    select cd_org_hem from house_exp_mar where num_proc_hem = @JOB  
    union all  
    select cd_org_heo from house_exp_out where num_proc_heo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@PORT_LOADING',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@PORT_LOADING',' ')  
    
 set @Temp = (select Pais_Local from localidade where cd_local in (  
    select cd_org_hia from house_imp_aer where num_proc_hia = @JOB  
    union all  
    select cd_org_him from house_imp_mar where num_proc_him = @JOB  
    union all  
    select cd_org_hio from house_imp_out where num_proc_hio = @JOB  
    union all  
    select cd_org_hea from house_exp_aer where num_proc_hea = @JOB  
    union all  
    select cd_org_hem from house_exp_mar where num_proc_hem = @JOB  
    union all  
    select cd_org_heo from house_exp_out where num_proc_heo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COUNTRY_LOADING',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COUNTRY_LOADING',' ')  
    
 set @Temp = (select Cd_Pais from localidade where cd_local in (  
    select cd_org_hia from house_imp_aer where num_proc_hia = @JOB  
    union all  
    select cd_org_him from house_imp_mar where num_proc_him = @JOB  
    union all  
    select cd_org_hio from house_imp_out where num_proc_hio = @JOB  
    union all  
    select cd_org_hea from house_exp_aer where num_proc_hea = @JOB  
    union all  
    select cd_org_hem from house_exp_mar where num_proc_hem = @JOB  
    union all  
    select cd_org_heo from house_exp_out where num_proc_heo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COUNTRY_CODE_LOADING',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COUNTRY_CODE_LOADING',' ')  
  
  
--DISCHARGE  
 set @Temp = (select nome_local from localidade where cd_local in (  
    select cd_dst_hia from house_imp_aer where num_proc_hia = @JOB  
    union all  
    select cd_dst_him from house_imp_mar where num_proc_him = @JOB  
    union all  
    select cd_dst_hio from house_imp_out where num_proc_hio = @JOB  
    union all  
    select cd_dst_hea from house_exp_aer where num_proc_hea = @JOB  
    union all  
    select cd_dst_hem from house_exp_mar where num_proc_hem = @JOB  
    union all  
    select cd_dst_heo from house_exp_out where num_proc_heo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@PORT_DISCHARGE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@PORT_DISCHARGE',' ')  
    
 set @Temp = (select Pais_Local from localidade where cd_local in (  
    select cd_dst_hia from house_imp_aer where num_proc_hia = @JOB  
    union all  
    select cd_dst_him from house_imp_mar where num_proc_him = @JOB  
    union all  
    select cd_dst_hio from house_imp_out where num_proc_hio = @JOB  
    union all  
    select cd_dst_hea from house_exp_aer where num_proc_hea = @JOB  
    union all  
    select cd_dst_hem from house_exp_mar where num_proc_hem = @JOB  
    union all  
    select cd_dst_heo from house_exp_out where num_proc_heo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COUNTRY_DISCHARGE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COUNTRY_DISCHARGE',' ')  
    
 set @Temp = (select Cd_Pais from localidade where cd_local in (  
    select cd_dst_hia from house_imp_aer where num_proc_hia = @JOB  
    union all  
    select cd_dst_him from house_imp_mar where num_proc_him = @JOB  
    union all  
    select cd_dst_hio from house_imp_out where num_proc_hio = @JOB  
    union all  
    select cd_dst_hea from house_exp_aer where num_proc_hea = @JOB  
    union all  
    select cd_dst_hem from house_exp_mar where num_proc_hem = @JOB  
    union all  
    select cd_dst_heo from house_exp_out where num_proc_heo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COUNTRY_CODE_DISCHARGE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COUNTRY_CODE_DISCHARGE',' ')  
  
--BL  
 set @Temp = (select HAWB_HIM from house_imp_mar where num_proc_him = @JOB  
    union all  
    select HAWB_hem from house_exp_mar where num_proc_hem = @JOB  
    )  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@BL_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@BL_NUMBER',' ')  
  
--TASKS  
 set @Temp = (select convert(varchar,dbo.fBusca_Tarefa(@JOB,'4'),107))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CUSTOMS_CLEARANCE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CUSTOMS_CLEARANCE',' ')  
  
--COURIER  
 set @Temp = (  
    select Courier_Number_LIA from llp_imp_aer where num_proc_lia = @JOB  
    union all  
    select Courier_Number_LIM from llp_imp_mar where num_proc_lim = @JOB  
    union all  
    select Courier_Number_LIO from llp_imp_out where num_proc_lio = @JOB  
    union all  
    select Courier_Number_LEA from llp_exp_aer where num_proc_lea = @JOB  
    union all  
    select Courier_Number_LEM from llp_exp_mar where num_proc_lem = @JOB  
    union all  
    select Courier_Number_LEO from llp_exp_out where num_proc_leo = @JOB  
    )  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COURIER_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COURIER_NUMBER',' ')  
  
 set @Temp = (select nome_raz_soc from pessoa where cd_pes in (  
    select cd_courier from llp_imp_aer where num_proc_lia = @JOB  
    union all  
    select cd_courier from llp_imp_mar where num_proc_lim = @JOB  
    union all  
    select cd_courier from llp_imp_out where num_proc_lio = @JOB  
    union all  
    select cd_courier from llp_exp_aer where num_proc_lea = @JOB  
    union all  
    select cd_courier from llp_exp_mar where num_proc_lem = @JOB  
    union all  
    select cd_courier from llp_exp_out where num_proc_leo = @JOB  
    ))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@COURIER_COMPANY',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@COURIER_COMPANY',' ')  
  
--PRODUTOS  
 set @Temp = (select dbo.fBusca_PRODUTO(@JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@PRODUCTS',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@PRODUCTS',' ')  
    
      
   
--Notes  
 set @Temp = (  
    select Obs_HIA from House_Imp_Aer where Num_Proc_HIA = @JOB  
    union all  
    select Obs_HIM from House_imp_mar where Num_Proc_HIM = @JOB  
    union all  
    select Obs_HIO from House_imp_out where Num_Proc_HIO = @JOB  
    union all  
    select Obs_HEA from House_exp_aer where Num_Proc_HEA = @JOB  
    union all  
    select Obs_HEM from House_exp_mar where Num_Proc_HEM = @JOB  
    union all  
    select Obs_HEO from House_exp_out where Num_Proc_HEO = @JOB  
    )  
  if @Temp is NOT null  
   set @Conteudo = replace(@conteudo,'@Notes',@Temp)  
  else  
   set @Conteudo = replace(@conteudo,'@Notes',' ')  
       
       
--Termo de Pagamento 87  
set @Temp = (select [dbo].[fBusca_CampoCliente](@JOB,'87'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@TermodePagamento',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@TermodePagamento',' ')  
    
  
--149 10017 D Venc. 2º Periodo Armazenagem  
set @Temp = (select [dbo].[fBusca_CampoCliente](@JOB,'149'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@Venc2_PeriodoArmazenagem',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@Venc2_PeriodoArmazenagem',' ')  
    
--150 10017 D Venc. 1º Periodo Armazenagem  
set @Temp = (select [dbo].[fBusca_CampoCliente](@JOB,'150'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@Venc1_PeriodoArmazenagem',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@Venc1_PeriodoArmazenagem',' ')  
    
    
--Carrier  
 set @Temp = (select [dbo].[fBusca_Carrier](@JOB,'CARRIER'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CARRIER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CARRIER',' ')  
    
--Viagem  
 set @Temp = (select Voo_HIA from House_Imp_Aer where Num_Proc_HIA = @JOB  
    union all  
    select Viagem_HIM from House_imp_mar where Num_Proc_HIM = @JOB  
    union all  
    select Voo_HIO from House_imp_out where Num_Proc_HIO = @JOB  
    union all  
    select Voo_HEA from House_exp_aer where Num_Proc_HEA = @JOB  
    union all  
    select Viagem_HEM from House_exp_mar where Num_Proc_HEM = @JOB  
    union all  
    select Voo_HEO from House_exp_out where Num_Proc_HEO = @JOB  
    )  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@VOYAGE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@VOYAGE',' ')  
    
    
    
--Incoterm  
  set @Temp = (  
    select Oper.Nome_Tp_Oper from House_Imp_Aer HOU  
    left join Tipo_oper Oper with(nolock) on HOU.Cd_Tp_Oper = Oper.Cd_Tp_Oper   
    where Num_Proc_HIA = @JOB  
    union all  
    select Oper.Nome_Tp_Oper from House_imp_mar HOU  
    left join Tipo_oper Oper with(nolock) on HOU.Cd_Tp_Oper = Oper.Cd_Tp_Oper   
    where Num_Proc_HIM = @JOB  
    union all  
    select Oper.Nome_Tp_Oper from House_imp_out HOU  
    left join Tipo_oper Oper with(nolock) on HOU.Cd_Tp_Oper = Oper.Cd_Tp_Oper   
    where Num_Proc_HIO = @JOB  
    union all  
    select Oper.Nome_Tp_Oper from House_exp_aer HOU  
    left join Tipo_oper Oper with(nolock) on HOU.Cd_Tp_Oper = Oper.Cd_Tp_Oper   
    where Num_Proc_HEA = @JOB  
    union all  
    select Oper.Nome_Tp_Oper from House_exp_mar HOU  
    left join Tipo_oper Oper with(nolock) on HOU.Cd_Tp_Oper = Oper.Cd_Tp_Oper   
    where Num_Proc_HEM = @JOB  
    union all  
    select Oper.Nome_Tp_Oper from House_exp_out HOU  
    left join Tipo_oper Oper with(nolock) on HOU.Cd_Tp_Oper = Oper.Cd_Tp_Oper    
    where Num_Proc_HEO = @JOB  
    )  
  if @Temp is NOT null  
   set @Conteudo = replace(@conteudo,'@INCOTERM',@Temp)  
  else  
   set @Conteudo = replace(@conteudo,'@INCOTERM',' ')  
     
  
--RETORNA O CONTEUDO  
  
 RETURN @Conteudo  
END  
  
*/  
  
  
  
  
GO

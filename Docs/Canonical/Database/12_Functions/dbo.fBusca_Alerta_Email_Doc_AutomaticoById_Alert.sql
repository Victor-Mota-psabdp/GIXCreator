SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fBusca_Alerta_Email_Doc_AutomaticoById_Alert]
(  	 
	@Tipo varchar(25), 
	@Id_Alert bigint,
	@JOB varchar(16) 
)  
RETURNS Varchar(MAX)   
AS  
BEGIN  
   
 declare @Conteudo varchar(MAX)  
 declare @Temp varchar(200)  
  

if @Tipo = 'Assunto'  
	Begin  
		set @Conteudo = (select Assunto from Alerta_Email_Doc_Automatico with(nolock) where ID_Alerta = @Id_Alert)  
	END  
else  
	BEGIN  
		set @Conteudo = (select Mensagem from Alerta_Email_Doc_Automatico with(nolock) where ID_Alerta = @Id_Alert)    
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

--Inland Trucker (Leandro)
 set @Temp = (select nome_raz_soc from pessoa with(nolock) where cd_pes in (  
     select Cd_Transportadora from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@INLAND_TRUCK',@Temp)
  
 --Customer (Leandro)
 set @Temp = (select Nome_Usuario from Usuario with(nolock) where cd_usuario in (  
     select cd_usuario from [dbo].[vwfBusca_Alerta_Email_Doc_Automatico] where Num_Proc = @JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CSR_NAME',@Temp)

--Due Number (Leandro)
  set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'204'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@DUE_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@DUE_NUMBER',' ') 



--Ruc Number (Leandro)
  set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'205'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@RUC_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@RUC_NUMBER',' ') 

--Chave de Acesso Due Number (Leandro)
  set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'209'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CHAVE_ACESSO_DUE_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CHAVE_ACESSO_DUE_NUMBER',' ') 

--Shipment Number (Leandro)
  set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'008'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@SHIPMENT_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@SHIPMENT_NUMBER',' ')

--LPCO Number (Leandro)
  set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'233'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@LPCO_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@LPCO_NUMBER',' ')

--Chave de Acesso LPCO Number (Leandro)
  set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'284'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CHAVE_ACESSO_LPCO_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CHAVE_ACESSO_LPCO_NUMBER',' ')

--Duimp Number (Leandro)
  set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'237'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@DUIMP_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@DUIMP_NUMBER',' ')

--Duimp Date (Leandro)
  --set @Temp = (select dbo.fBusca_Docs_PO_Modal_Date(@JOB,'237'))  
  set @Temp = (select dbo.fBusca_DATA_PO_Modal(@JOB,237))    
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@DUIMP_DATE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@DUIMP_DATE',' ')

--CI Intercompany Invoice (Leandro)
  set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'282'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CI_INTERCOMPANY_INVOICE',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CI_INTERCOMPANY_INVOICE',' ')

--Business Group (Leandro)
  set @Temp = (select dbo.fBusca_PRODUTO_Business_Group(@JOB))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@BUSINESS_GROUP_DESCR',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@BUSINESS_GROUP_DESCR',' ')


 --Chave de Acesso DUIMP Number (Leandro)
   set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'288'))  
 if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@CHAVE_ACESSO_DUIMP_NUMBER',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@CHAVE_ACESSO_DUIMP_NUMBER',' ') 

  
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


--Id Task
declare @Id_Task BigInt
	Begin  
		set @Id_Task = (select Id_Task from Alerta_Email_Doc_Automatico with(nolock) where ID_Alerta = @Id_Alert)  
	END 
set @Temp = (select convert(varchar(25),ID_TP) ID_TP from tarefas_processos where num_proc = @JOB and ID_Task = @Id_Task)  
if @Temp is NOT null  
  set @Conteudo = replace(@conteudo,'@ID_TP_Task_Send',@Temp)  
 else  
  set @Conteudo = replace(@conteudo,'@ID_TP_Task_Send',' ')  
 
  
 RETURN @Conteudo  
END   
  
  

GO

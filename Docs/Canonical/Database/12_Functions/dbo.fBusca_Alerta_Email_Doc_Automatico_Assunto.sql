SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto]--''
(
	@JOB varchar(16),
	@ID bigint,
	@cd_pes_grupo varchar(25),
	@cd_tp_carga int,
	@cd_org varchar(10),
	@cd_dst varchar(10),
	@cd_pes varchar(10),
	@Modal varchar(10),
	@cd_tp_pedido varchar(5)
)
RETURNS Varchar(MAX) 
AS
BEGIN
	
	declare @Conteudo varchar(MAX)
	declare @Temp varchar(200)

	set @Conteudo = (select Assunto from Alerta_Email_Doc_Automatico where ID = @ID
	--and (Cd_Pes_Grupo = @cd_pes_grupo or Cd_Pes_Grupo = '10017') 
	and Cd_Pes_Grupo = @cd_pes_grupo
	and cd_tp_carga = @cd_tp_carga 
	and Cd_Org = @cd_org
	and Cd_Dst =@cd_dst
	and Cd_pes =@Cd_Pes
	and Modal =@Modal
	and cd_tp_pedido = @cd_tp_pedido)

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
		
	set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'130'))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@BOOKING',@Temp)
	else
		set @Conteudo = replace(@conteudo,'@BOOKING',' ')


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
		

--149	10017	D	Venc. 2º Periodo Armazenagem
set @Temp = (select [dbo].[fBusca_CampoCliente](@JOB,'149'))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@Venc2_PeriodoArmazenagem',@Temp)
	else
		set @Conteudo = replace(@conteudo,'@Venc2_PeriodoArmazenagem',' ')
		
--150	10017	D	Venc. 1º Periodo Armazenagem
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

--RETORNA O CONTEUDO

	RETURN @Conteudo
END









GO

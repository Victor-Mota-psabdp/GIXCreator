SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spAlertaPadrao_Corpo_Sel 'EMOXT201105027BR','001 - SHIPMENT CONFIRMATION'

CREATE procedure [dbo].[spAlertaPadrao_Corpo_Sel] 
(
	@JOB varchar(16),
	@Tipo varchar(50)
)
AS

	declare @Conteudo varchar(max)
	declare @Temp varchar(200)

	set @Conteudo = (select Conteudo from alerta_padrao where ID = left(@Tipo,3))

	set @Conteudo = replace(@conteudo,'@JOB_NUMBER',@JOB)

--PO MODAL
	set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'1'))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@PO_NUMBER',@Temp)

	set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'3'))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@SALES_ORDER',@Temp)

	set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'5'))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@DI_NUMBER',@Temp)

	set @Temp = (select dbo.fBusca_Docs_PO_Modal(@JOB,'4'))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@RE_NUMBER',@Temp)

--BUSCA DATAS LLP
	set @Temp = (select convert(varchar,dbo.fBusca_Data(@JOB,'ATD'),107))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@ATD',@Temp)

	set @Temp = (select convert(varchar,dbo.fBusca_Data(@JOB,'ATA'),107))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@ATA',@Temp)

	set @Temp = (select convert(varchar,dbo.fBusca_Data(@JOB,'ETD'),107))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@ETD',@Temp)

	set @Temp = (select convert(varchar,dbo.fBusca_Data(@JOB,'ETA'),107))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@ETA',@Temp)

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

--BL
	set @Temp = (select HAWB_HIM from house_imp_mar where num_proc_him = @JOB
				union all
				select HAWB_hem from house_exp_mar where num_proc_hem = @JOB
				)
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@BL_NUMBER',@Temp)

--TASKS
	set @Temp = (select convert(varchar,dbo.fBusca_Tarefa(@JOB,'4'),107))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@CUSTOMS_CLEARANCE',@Temp)

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

--PRODUTOS
	set @Temp = (select dbo.fBusca_PRODUTO(@JOB))
	if @Temp is NOT null
		set @Conteudo = replace(@conteudo,'@PRODUCTS',@Temp)

--RETORNA O CONTEUDO
	select @Conteudo



GO
